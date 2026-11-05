#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.
#define PGSIZE          4096 
#define HUGE_VA_OFFSET  0x1E000000  
#define VMALLOC_SIZE_BASE 0
#define VMALLOC_SIZE_HUGE 1
#define KERNBASE        0x80000000
#define HUGE_PAGE_SIZE  0x400000  

typedef long Align;

union header {
  struct {
    union header *ptr;
    uint size;
  } s;
  Align x;
};

typedef union header Header;

static Header base;
static Header *freep;

void free_huge(void *ap);

void
free(void *ap)
{
  Header *bp, *p;

  if((uint)ap >= KERNBASE) {
    printf(2, "Error - trying to free a kernel pointer in userspace\n");
    exit();
  }
  if((uint)ap >= HUGE_VA_OFFSET) {
    free_huge(ap);
    return;
  }

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}

static Header*
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
  return freep;
}

static void*
malloc_base(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}

static Header base_huge;
static Header *freep_huge;

void 
free_huge(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep_huge; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  
  freep_huge = p;
}


static Header* 
morecore_huge(uint nu)
{
  char *p;
  Header *hp;

  // Round up to whole huge pages so the pool owns everything the kernel maps
  nu = (nu + HUGE_PAGE_SIZE/sizeof(Header) - 1) / (HUGE_PAGE_SIZE/sizeof(Header)) * (HUGE_PAGE_SIZE/sizeof(Header));
  
  p = sbrkhuge(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free_huge((void*)(hp + 1));
  return freep_huge;
}

void* 
malloc_huge(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  
  if((prevp = freep_huge) == 0){
    base_huge.s.ptr = freep_huge = prevp = &base_huge;
    base_huge.s.size = 0;
  }
  
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep_huge = prevp;
      return (void*)(p + 1);
    }
    if(p == freep_huge)
      if((p = morecore_huge(nunits)) == 0)
        return 0;
  }
}

void*
malloc(uint nbytes)
{
  // THP: requests of 1MB or more use the huge page pool when enabled
  if(nbytes >= 1024*1024 && getthp())
    return malloc_huge(nbytes);
  return malloc_base(nbytes);
}

void *vmalloc(uint nbytes, int flag) {
  if (flag == VMALLOC_SIZE_BASE)
    return malloc_base(nbytes);
  else if (flag == VMALLOC_SIZE_HUGE)
    return malloc_huge(nbytes);
  else {
    printf(2, "Please pass VMALLOC_SIZE_BASE or VMALLOC_SIZE_HUGE as flag.\n");
    exit();
    return 0;
  }
}

void vfree(void *ap) {
  if((uint)ap >= KERNBASE) {
    printf(2, "Error - trying to free a kernel pointer in userspace\n");
    exit();
  }
  
  if(((uint)ap >= HUGE_VA_OFFSET) && ((uint)ap < KERNBASE))
    free_huge(ap);
  else
    free(ap);
}