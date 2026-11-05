// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"


// Function prototypes
void freerange(void *vstart, void *vend);
void kfree(char *v);
char* kalloc(void);
void khugeinit(void);
void* khugealloc(void);
void khugefree(char *v);
int ishugepage(uint addr);

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

struct run_huge {
  struct run_huge *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run_huge *freelist;
} khugefreelist;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
khugeinit(void)
{
  char *p;
  
  initlock(&khugefreelist.lock, "khugefreelist");
  khugefreelist.use_lock = 0;
  khugefreelist.freelist = 0;
  
  // Add huge pages from HUGE_PAGE_START to HUGE_PAGE_END to the freelist
  for(p = (char*)(KERNBASE+HUGE_PAGE_START); 
  p + HUGE_PAGE_SIZE <= (char*)(KERNBASE+HUGE_PAGE_END); 
  p += HUGE_PAGE_SIZE) {
  khugefree(p);
  }
  
  khugefreelist.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

void*
khugealloc(void)
{
  struct run_huge *r;

  if(khugefreelist.use_lock)
    acquire(&khugefreelist.lock);
  
  r = khugefreelist.freelist;
  if(r)
    khugefreelist.freelist = r->next;
  
  if(khugefreelist.use_lock)
    release(&khugefreelist.lock);
  
  return (void*)r;
}

void
khugefree(char *v)
{
  struct run_huge *r;

  // Validation: ensure address is properly aligned and within range
  if((uint)v % HUGE_PAGE_SIZE || v < (char*)(KERNBASE+HUGE_PAGE_START) || v >= (char*)(KERNBASE+HUGE_PAGE_END))
    panic("khugefree: invalid address");


  // Fill with junk to catch dangling refs
  memset(v, 1, HUGE_PAGE_SIZE);

  // Add to free list
  r = (struct run_huge*)v;
  
  if(khugefreelist.use_lock)
    acquire(&khugefreelist.lock);
  
  r->next = khugefreelist.freelist;
  khugefreelist.freelist = r;
  
  if(khugefreelist.use_lock)
    release(&khugefreelist.lock);
}

int
ishugepage(uint addr)
{
  return addr >= HUGE_PAGE_START && addr < HUGE_PAGE_END && 
    addr % HUGE_PAGE_SIZE == 0;
}