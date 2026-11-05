
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 66 11 80       	mov    $0x80116630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 32 10 80       	mov    $0x80103210,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 74 b5 10 80       	mov    $0x8010b574,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 78 10 80       	push   $0x801078c0
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 c5 45 00 00       	call   80104620 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 3c fc 10 80       	mov    $0x8010fc3c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 8c fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc8c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 90 fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc90
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 78 10 80       	push   $0x801078c7
80100097:	50                   	push   %eax
80100098:	e8 53 44 00 00       	call   801044f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 f9 10 80    	cmp    $0x8010f9e0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 40 b5 10 80       	push   $0x8010b540
801000e4:	e8 07 47 00 00       	call   801047f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 90 fc 10 80    	mov    0x8010fc90,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c fc 10 80    	mov    0x8010fc8c,%ebx
80100126:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 40 b5 10 80       	push   $0x8010b540
80100162:	e8 29 46 00 00       	call   80104790 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 43 00 00       	call   80104530 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ce 78 10 80       	push   $0x801078ce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 0d 44 00 00       	call   801045d0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 78 10 80       	push   $0x801078df
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 43 00 00       	call   801045d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 43 00 00       	call   80104590 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 d0 45 00 00       	call   801047f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 40 b5 10 80 	movl   $0x8010b540,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 45 00 00       	jmp    80104790 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 78 10 80       	push   $0x801078e6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801002a0:	e8 4b 45 00 00       	call   801047f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002b5:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 40 ff 10 80       	push   $0x8010ff40
801002c8:	68 20 ff 10 80       	push   $0x8010ff20
801002cd:	e8 be 3f 00 00       	call   80104290 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 38 00 00       	call   80103b30 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 95 44 00 00       	call   80104790 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 20 ff 10 80    	mov    %edx,0x8010ff20
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a a0 fe 10 80 	movsbl -0x7fef0160(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 40 ff 10 80       	push   $0x8010ff40
8010034c:	e8 3f 44 00 00       	call   80104790 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 74 ff 10 80 00 	movl   $0x0,0x8010ff74
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 02 27 00 00       	call   80102aa0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 78 10 80       	push   $0x801078ed
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 37 83 10 80 	movl   $0x80108337,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 42 00 00       	call   80104640 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 79 10 80       	push   $0x80107901
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 ff 10 80 01 	movl   $0x1,0x8010ff78
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 5d 00 00       	call   80106170 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 66 5c 00 00       	call   80106170 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 5a 5c 00 00       	call   80106170 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 4e 5c 00 00       	call   80106170 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 fa 43 00 00       	call   80104950 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 45 43 00 00       	call   801048b0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 79 10 80       	push   $0x80107905
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801005ab:	e8 40 42 00 00       	call   801047f0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 40 ff 10 80       	push   $0x8010ff40
801005e4:	e8 a7 41 00 00       	call   80104790 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 30 79 10 80 	movzbl -0x7fef86d0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 74 ff 10 80       	mov    0x8010ff74,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 40 ff 10 80       	push   $0x8010ff40
801007e8:	e8 03 40 00 00       	call   801047f0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 18 79 10 80       	mov    $0x80107918,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 30 3f 00 00       	call   80104790 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 79 10 80       	push   $0x8010791f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 40 ff 10 80       	push   $0x8010ff40
80100893:	e8 58 3f 00 00       	call   801047f0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 20 ff 10 80    	sub    0x8010ff20,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 28 ff 10 80    	mov    %ecx,0x8010ff28
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 a0 fe 10 80    	mov    %bl,-0x7fef0160(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 28 ff 10 80    	cmp    %eax,0x8010ff28
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100945:	39 05 24 ff 10 80    	cmp    %eax,0x8010ff24
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba a0 fe 10 80 0a 	cmpb   $0xa,-0x7fef0160(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        input.e--;
8010096c:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100985:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100999:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801009b7:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 40 ff 10 80       	push   $0x8010ff40
801009d0:	e8 bb 3d 00 00       	call   80104790 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 1d 3a 00 00       	jmp    80104430 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 a0 fe 10 80 0a 	movb   $0xa,-0x7fef0160(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 24 ff 10 80       	mov    %eax,0x8010ff24
          wakeup(&input.r);
80100a3f:	68 20 ff 10 80       	push   $0x8010ff20
80100a44:	e8 07 39 00 00       	call   80104350 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 28 79 10 80       	push   $0x80107928
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 ab 3b 00 00       	call   80104620 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 2c 09 11 80 90 	movl   $0x80100590,0x8011092c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 28 09 11 80 80 	movl   $0x80100280,0x80110928
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 74 ff 10 80 01 	movl   $0x1,0x8010ff74
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 6f 30 00 00       	call   80103b30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 44 24 00 00       	call   80102f10 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 6c 24 00 00       	call   80102f80 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 97 69 00 00       	call   801074d0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8d 00 00 00       	jmp    80100bf5 <exec+0x145>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6b                	jne    80100be4 <exec+0x134>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 86 00 00 00    	jb     80100c11 <exec+0x161>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7e                	jb     80100c11 <exec+0x161>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz, 0)) == 0)
80100b93:	6a 00                	push   $0x0
80100b95:	50                   	push   %eax
80100b96:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9c:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba2:	e8 09 66 00 00       	call   801071b0 <allocuvm>
80100ba7:	83 c4 10             	add    $0x10,%esp
80100baa:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb0:	85 c0                	test   %eax,%eax
80100bb2:	74 5d                	je     80100c11 <exec+0x161>
    if(ph.vaddr % PGSIZE != 0)
80100bb4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bba:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bbf:	75 50                	jne    80100c11 <exec+0x161>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc1:	83 ec 0c             	sub    $0xc,%esp
80100bc4:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bca:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd0:	53                   	push   %ebx
80100bd1:	50                   	push   %eax
80100bd2:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd8:	e8 e3 64 00 00       	call   801070c0 <loaduvm>
80100bdd:	83 c4 20             	add    $0x20,%esp
80100be0:	85 c0                	test   %eax,%eax
80100be2:	78 2d                	js     80100c11 <exec+0x161>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be4:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100beb:	83 c7 01             	add    $0x1,%edi
80100bee:	83 c6 20             	add    $0x20,%esi
80100bf1:	39 f8                	cmp    %edi,%eax
80100bf3:	7e 3b                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfb:	6a 20                	push   $0x20
80100bfd:	56                   	push   %esi
80100bfe:	50                   	push   %eax
80100bff:	53                   	push   %ebx
80100c00:	e8 8b 0e 00 00       	call   80101a90 <readi>
80100c05:	83 c4 10             	add    $0x10,%esp
80100c08:	83 f8 20             	cmp    $0x20,%eax
80100c0b:	0f 84 5f ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c11:	83 ec 0c             	sub    $0xc,%esp
80100c14:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1a:	e8 c1 67 00 00       	call   801073e0 <freevm>
  if(ip){
80100c1f:	83 c4 10             	add    $0x10,%esp
80100c22:	e9 df fe ff ff       	jmp    80100b06 <exec+0x56>
80100c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2e:	66 90                	xchg   %ax,%ax
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE, 0)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 2a 23 00 00       	call   80102f80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE, 0)) == 0)
80100c56:	6a 00                	push   $0x0
80100c58:	56                   	push   %esi
80100c59:	57                   	push   %edi
80100c5a:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c60:	57                   	push   %edi
80100c61:	e8 4a 65 00 00       	call   801071b0 <allocuvm>
80100c66:	83 c4 20             	add    $0x20,%esp
80100c69:	89 c6                	mov    %eax,%esi
80100c6b:	85 c0                	test   %eax,%eax
80100c6d:	0f 84 95 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c73:	83 ec 08             	sub    $0x8,%esp
80100c76:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7c:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7e:	50                   	push   %eax
80100c7f:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c80:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c82:	e8 e9 68 00 00       	call   80107570 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c87:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8a:	83 c4 10             	add    $0x10,%esp
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c93:	8b 00                	mov    (%eax),%eax
80100c95:	85 c0                	test   %eax,%eax
80100c97:	0f 84 8c 00 00 00    	je     80100d29 <exec+0x279>
80100c9d:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca3:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ca9:	eb 24                	jmp    80100ccf <exec+0x21f>
80100cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100caf:	90                   	nop
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 d8 3d 00 00       	call   80104ab0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 c4 3d 00 00       	call   80104ab0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 e3 6a 00 00       	call   801077e0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ca 66 00 00       	call   801073e0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 78 6a 00 00       	call   801077e0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 70             	add    $0x70,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ca 3c 00 00       	call   80104a70 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 1c             	mov    0x1c(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 5e 61 00 00       	call   80106f30 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 06 66 00 00       	call   801073e0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 97 21 00 00       	call   80102f80 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 41 79 10 80       	push   $0x80107941
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 4d 79 10 80       	push   $0x8010794d
80100e1b:	68 80 ff 10 80       	push   $0x8010ff80
80100e20:	e8 fb 37 00 00       	call   80104620 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb b4 ff 10 80       	mov    $0x8010ffb4,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 80 ff 10 80       	push   $0x8010ff80
80100e41:	e8 aa 39 00 00       	call   801047f0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 14 09 11 80    	cmp    $0x80110914,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 80 ff 10 80       	push   $0x8010ff80
80100e71:	e8 1a 39 00 00       	call   80104790 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 80 ff 10 80       	push   $0x8010ff80
80100e8a:	e8 01 39 00 00       	call   80104790 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 80 ff 10 80       	push   $0x8010ff80
80100eaf:	e8 3c 39 00 00       	call   801047f0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 80 ff 10 80       	push   $0x8010ff80
80100ecc:	e8 bf 38 00 00       	call   80104790 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 54 79 10 80       	push   $0x80107954
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 80 ff 10 80       	push   $0x8010ff80
80100f01:	e8 ea 38 00 00       	call   801047f0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 80 ff 10 80       	push   $0x8010ff80
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 4f 38 00 00       	call   80104790 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 80 ff 10 80 	movl   $0x8010ff80,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 1d 38 00 00       	jmp    80104790 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 93 1f 00 00       	call   80102f10 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 e9 1f 00 00       	jmp    80102f80 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 32 27 00 00       	call   801036e0 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 5c 79 10 80       	push   $0x8010795c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 ee 27 00 00       	jmp    80103880 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 66 79 10 80       	push   $0x80107966
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 72 1e 00 00       	call   80102f80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 dd 1d 00 00       	call   80102f10 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 16 1e 00 00       	call   80102f80 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 6f 79 10 80       	push   $0x8010796f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 d2 25 00 00       	jmp    80103780 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 75 79 10 80       	push   $0x80107975
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 ec 25 11 80    	add    0x801125ec,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 de 1e 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 7f 79 10 80       	push   $0x8010797f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d d4 25 11 80    	mov    0x801125d4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 ec 25 11 80    	add    0x801125ec,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 d4 25 11 80       	mov    0x801125d4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 d4 25 11 80    	cmp    %eax,0x801125d4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 92 79 10 80       	push   $0x80107992
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 ee 1d 00 00       	call   801030f0 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 86 35 00 00       	call   801048b0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 be 1d 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb b4 09 11 80       	mov    $0x801109b4,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 80 09 11 80       	push   $0x80110980
8010136a:	e8 81 34 00 00       	call   801047f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 80 09 11 80       	push   $0x80110980
801013d7:	e8 b4 33 00 00       	call   80104790 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 80 09 11 80       	push   $0x80110980
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 86 33 00 00       	call   80104790 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 a8 79 10 80       	push   $0x801079a8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 26 1c 00 00       	call   801030f0 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 b8 79 10 80       	push   $0x801079b8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 0a 34 00 00       	call   80104950 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb c0 09 11 80       	mov    $0x801109c0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 cb 79 10 80       	push   $0x801079cb
80101571:	68 80 09 11 80       	push   $0x80110980
80101576:	e8 a5 30 00 00       	call   80104620 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 d2 79 10 80       	push   $0x801079d2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 5c 2f 00 00       	call   801044f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb e0 25 11 80    	cmp    $0x801125e0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 d4 25 11 80       	push   $0x801125d4
801015bc:	e8 8f 33 00 00       	call   80104950 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 ec 25 11 80    	push   0x801125ec
801015cf:	ff 35 e8 25 11 80    	push   0x801125e8
801015d5:	ff 35 e4 25 11 80    	push   0x801125e4
801015db:	ff 35 e0 25 11 80    	push   0x801125e0
801015e1:	ff 35 dc 25 11 80    	push   0x801125dc
801015e7:	ff 35 d8 25 11 80    	push   0x801125d8
801015ed:	ff 35 d4 25 11 80    	push   0x801125d4
801015f3:	68 38 7a 10 80       	push   $0x80107a38
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d dc 25 11 80 01 	cmpl   $0x1,0x801125dc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d dc 25 11 80    	cmp    0x801125dc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 1d 32 00 00       	call   801048b0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 4b 1a 00 00       	call   801030f0 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 d8 79 10 80       	push   $0x801079d8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 1a 32 00 00       	call   80104950 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 b2 19 00 00       	call   801030f0 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 80 09 11 80       	push   $0x80110980
8010175f:	e8 8c 30 00 00       	call   801047f0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010176f:	e8 1c 30 00 00       	call   80104790 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 89 2d 00 00       	call   80104530 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 33 31 00 00       	call   80104950 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 f0 79 10 80       	push   $0x801079f0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ea 79 10 80       	push   $0x801079ea
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 58 2d 00 00       	call   801045d0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 fc 2c 00 00       	jmp    80104590 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 ff 79 10 80       	push   $0x801079ff
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 6b 2c 00 00       	call   80104530 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 b1 2c 00 00       	call   80104590 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018e6:	e8 05 2f 00 00       	call   801047f0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 80 09 11 80 	movl   $0x80110980,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 8b 2e 00 00       	jmp    80104790 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 80 09 11 80       	push   $0x80110980
80101910:	e8 db 2e 00 00       	call   801047f0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010191f:	e8 6c 2e 00 00       	call   80104790 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 a8 2b 00 00       	call   801045d0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 51 2b 00 00       	call   80104590 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 ff 79 10 80       	push   $0x801079ff
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 14 2e 00 00       	call   80104950 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 20 09 11 80 	mov    -0x7feef6e0(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 18 2d 00 00       	call   80104950 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 b0 14 00 00       	call   801030f0 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 24 09 11 80 	mov    -0x7feef6dc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 ed 2c 00 00       	call   801049c0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 8e 2c 00 00       	call   801049c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 19 7a 10 80       	push   $0x80107a19
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 07 7a 10 80       	push   $0x80107a07
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 81 1d 00 00       	call   80103b30 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 80 09 11 80       	push   $0x80110980
80101dba:	e8 31 2a 00 00       	call   801047f0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dca:	e8 c1 29 00 00       	call   80104790 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 24 2b 00 00       	call   80104950 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 3f 27 00 00       	call   801045d0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 dd 26 00 00       	call   80104590 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 70 2a 00 00       	call   80104950 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 a0 26 00 00       	call   801045d0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 41 26 00 00       	call   80104590 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 5e 26 00 00       	call   801045d0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 3b 26 00 00       	call   801045d0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 e4 25 00 00       	call   80104590 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 ff 79 10 80       	push   $0x801079ff
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ce 29 00 00       	call   80104a10 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 28 7a 10 80       	push   $0x80107a28
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 32 80 10 80       	push   $0x80108032
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 94 7a 10 80       	push   $0x80107a94
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 8b 7a 10 80       	push   $0x80107a8b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 a6 7a 10 80       	push   $0x80107aa6
801021cb:	68 20 26 11 80       	push   $0x80112620
801021d0:	e8 4b 24 00 00       	call   80104620 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 e4 27 11 80       	mov    0x801127e4,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 20 26 11 80       	push   $0x80112620
8010224e:	e8 9d 25 00 00       	call   801047f0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 9e 20 00 00       	call   80104350 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 04 26 11 80       	mov    0x80112604,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 20 26 11 80       	push   $0x80112620
801022cb:	e8 c0 24 00 00       	call   80104790 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 dd 22 00 00       	call   801045d0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 00 26 11 80       	mov    0x80112600,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 20 26 11 80       	push   $0x80112620
80102328:	e8 c3 24 00 00       	call   801047f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 20 26 11 80       	push   $0x80112620
80102368:	53                   	push   %ebx
80102369:	e8 22 1f 00 00       	call   80104290 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 05 24 00 00       	jmp    80104790 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba 04 26 11 80       	mov    $0x80112604,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 d5 7a 10 80       	push   $0x80107ad5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 c0 7a 10 80       	push   $0x80107ac0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 aa 7a 10 80       	push   $0x80107aaa
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 e0 27 11 80 	movzbl 0x801127e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 f4 7a 10 80       	push   $0x80107af4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 30 66 11 80    	cmp    $0x80116630,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 b9 23 00 00       	call   801048b0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  kmem.freelist = r;
80102510:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 a0 26 11 80       	push   $0x801126a0
80102528:	e8 c3 22 00 00       	call   801047f0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 48 22 00 00       	jmp    80104790 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 26 7b 10 80       	push   $0x80107b26
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 2c 7b 10 80       	push   $0x80107b2c
80102620:	68 a0 26 11 80       	push   $0x801126a0
80102625:	e8 f6 1f 00 00       	call   80104620 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 a0 26 11 80       	push   $0x801126a0
801026b3:	e8 38 21 00 00       	call   801047f0 <acquire>
  r = kmem.freelist;
801026b8:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if(kmem.use_lock)
801026bd:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d d8 26 11 80    	mov    %ecx,0x801126d8
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 a0 26 11 80       	push   $0x801126a0
801026e1:	e8 aa 20 00 00       	call   80104790 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <khugealloc>:
void*
khugealloc(void)
{
  struct run_huge *r;

  if(khugefreelist.use_lock)
801026f0:	a1 94 26 11 80       	mov    0x80112694,%eax
801026f5:	85 c0                	test   %eax,%eax
801026f7:	75 1f                	jne    80102718 <khugealloc+0x28>
    acquire(&khugefreelist.lock);
  
  r = khugefreelist.freelist;
801026f9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
801026fe:	85 c0                	test   %eax,%eax
80102700:	74 0e                	je     80102710 <khugealloc+0x20>
    khugefreelist.freelist = r->next;
80102702:	8b 10                	mov    (%eax),%edx
80102704:	89 15 98 26 11 80    	mov    %edx,0x80112698
  
  if(khugefreelist.use_lock)
8010270a:	c3                   	ret    
8010270b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
    release(&khugefreelist.lock);
  
  return (void*)r;
}
80102710:	c3                   	ret    
80102711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102718:	55                   	push   %ebp
80102719:	89 e5                	mov    %esp,%ebp
8010271b:	83 ec 24             	sub    $0x24,%esp
    acquire(&khugefreelist.lock);
8010271e:	68 60 26 11 80       	push   $0x80112660
80102723:	e8 c8 20 00 00       	call   801047f0 <acquire>
  r = khugefreelist.freelist;
80102728:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(khugefreelist.use_lock)
8010272d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if(r)
80102733:	83 c4 10             	add    $0x10,%esp
80102736:	85 c0                	test   %eax,%eax
80102738:	74 08                	je     80102742 <khugealloc+0x52>
    khugefreelist.freelist = r->next;
8010273a:	8b 08                	mov    (%eax),%ecx
8010273c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(khugefreelist.use_lock)
80102742:	85 d2                	test   %edx,%edx
80102744:	74 16                	je     8010275c <khugealloc+0x6c>
    release(&khugefreelist.lock);
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010274c:	68 60 26 11 80       	push   $0x80112660
80102751:	e8 3a 20 00 00       	call   80104790 <release>
  return (void*)r;
80102756:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&khugefreelist.lock);
80102759:	83 c4 10             	add    $0x10,%esp
}
8010275c:	c9                   	leave  
8010275d:	c3                   	ret    
8010275e:	66 90                	xchg   %ax,%ax

80102760 <khugefree>:

void
khugefree(char *v)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 04             	sub    $0x4,%esp
80102767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run_huge *r;

  // Validation: ensure address is properly aligned and within range
  if((uint)v % HUGE_PAGE_SIZE || v < (char*)(KERNBASE+HUGE_PAGE_START) || v >= (char*)(KERNBASE+HUGE_PAGE_END))
8010276a:	f7 c3 ff ff 3f 00    	test   $0x3fffff,%ebx
80102770:	75 76                	jne    801027e8 <khugefree+0x88>
80102772:	8d 83 00 00 00 62    	lea    0x62000000(%ebx),%eax
80102778:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
8010277d:	77 69                	ja     801027e8 <khugefree+0x88>
    panic("khugefree: invalid address");


  // Fill with junk to catch dangling refs
  memset(v, 1, HUGE_PAGE_SIZE);
8010277f:	83 ec 04             	sub    $0x4,%esp
80102782:	68 00 00 40 00       	push   $0x400000
80102787:	6a 01                	push   $0x1
80102789:	53                   	push   %ebx
8010278a:	e8 21 21 00 00       	call   801048b0 <memset>

  // Add to free list
  r = (struct run_huge*)v;
  
  if(khugefreelist.use_lock)
8010278f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102795:	83 c4 10             	add    $0x10,%esp
80102798:	85 d2                	test   %edx,%edx
8010279a:	75 24                	jne    801027c0 <khugefree+0x60>
    acquire(&khugefreelist.lock);
  
  r->next = khugefreelist.freelist;
8010279c:	a1 98 26 11 80       	mov    0x80112698,%eax
801027a1:	89 03                	mov    %eax,(%ebx)
  khugefreelist.freelist = r;
  
  if(khugefreelist.use_lock)
801027a3:	a1 94 26 11 80       	mov    0x80112694,%eax
  khugefreelist.freelist = r;
801027a8:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(khugefreelist.use_lock)
801027ae:	85 c0                	test   %eax,%eax
801027b0:	75 26                	jne    801027d8 <khugefree+0x78>
    release(&khugefreelist.lock);
}
801027b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b5:	c9                   	leave  
801027b6:	c3                   	ret    
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax
    acquire(&khugefreelist.lock);
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	68 60 26 11 80       	push   $0x80112660
801027c8:	e8 23 20 00 00       	call   801047f0 <acquire>
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	eb ca                	jmp    8010279c <khugefree+0x3c>
801027d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&khugefreelist.lock);
801027d8:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801027df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e2:	c9                   	leave  
    release(&khugefreelist.lock);
801027e3:	e9 a8 1f 00 00       	jmp    80104790 <release>
    panic("khugefree: invalid address");
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	68 31 7b 10 80       	push   $0x80107b31
801027f0:	e8 8b db ff ff       	call   80100380 <panic>
801027f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <khugeinit>:
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	53                   	push   %ebx
  khugefreelist.freelist = 0;
80102804:	bb 00 00 00 9e       	mov    $0x9e000000,%ebx
{
80102809:	83 ec 0c             	sub    $0xc,%esp
  initlock(&khugefreelist.lock, "khugefreelist");
8010280c:	68 4c 7b 10 80       	push   $0x80107b4c
80102811:	68 60 26 11 80       	push   $0x80112660
80102816:	e8 05 1e 00 00       	call   80104620 <initlock>
  khugefreelist.freelist = 0;
8010281b:	83 c4 10             	add    $0x10,%esp
  khugefreelist.use_lock = 0;
8010281e:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102825:	00 00 00 
  khugefreelist.freelist = 0;
80102828:	c7 05 98 26 11 80 00 	movl   $0x0,0x80112698
8010282f:	00 00 00 
  p + HUGE_PAGE_SIZE <= (char*)(KERNBASE+HUGE_PAGE_END); 
80102832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  khugefree(p);
80102838:	83 ec 0c             	sub    $0xc,%esp
8010283b:	53                   	push   %ebx
  p + HUGE_PAGE_SIZE <= (char*)(KERNBASE+HUGE_PAGE_END); 
8010283c:	81 c3 00 00 40 00    	add    $0x400000,%ebx
  khugefree(p);
80102842:	e8 19 ff ff ff       	call   80102760 <khugefree>
  p + HUGE_PAGE_SIZE <= (char*)(KERNBASE+HUGE_PAGE_END); 
80102847:	83 c4 10             	add    $0x10,%esp
8010284a:	81 fb 00 00 00 be    	cmp    $0xbe000000,%ebx
80102850:	75 e6                	jne    80102838 <khugeinit+0x38>
  khugefreelist.use_lock = 1;
80102852:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102859:	00 00 00 
}
8010285c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010285f:	c9                   	leave  
80102860:	c3                   	ret    
80102861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop

80102870 <ishugepage>:

int
ishugepage(uint addr)
{
80102870:	55                   	push   %ebp
80102871:	31 c0                	xor    %eax,%eax
80102873:	89 e5                	mov    %esp,%ebp
80102875:	8b 55 08             	mov    0x8(%ebp),%edx
  return addr >= HUGE_PAGE_START && addr < HUGE_PAGE_END && 
80102878:	8d 8a 00 00 00 e2    	lea    -0x1e000000(%edx),%ecx
8010287e:	81 f9 ff ff ff 1f    	cmp    $0x1fffffff,%ecx
80102884:	77 0b                	ja     80102891 <ishugepage+0x21>
80102886:	31 c0                	xor    %eax,%eax
80102888:	81 e2 ff ff 3f 00    	and    $0x3fffff,%edx
8010288e:	0f 94 c0             	sete   %al
    addr % HUGE_PAGE_SIZE == 0;
80102891:	5d                   	pop    %ebp
80102892:	c3                   	ret    
80102893:	66 90                	xchg   %ax,%ax
80102895:	66 90                	xchg   %ax,%ax
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	ba 64 00 00 00       	mov    $0x64,%edx
801028a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a6:	a8 01                	test   $0x1,%al
801028a8:	0f 84 c2 00 00 00    	je     80102970 <kbdgetc+0xd0>
{
801028ae:	55                   	push   %ebp
801028af:	ba 60 00 00 00       	mov    $0x60,%edx
801028b4:	89 e5                	mov    %esp,%ebp
801028b6:	53                   	push   %ebx
801028b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028b8:	8b 1d dc 26 11 80    	mov    0x801126dc,%ebx
  data = inb(KBDATAP);
801028be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028c1:	3c e0                	cmp    $0xe0,%al
801028c3:	74 5b                	je     80102920 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028c5:	89 da                	mov    %ebx,%edx
801028c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028ca:	84 c0                	test   %al,%al
801028cc:	78 62                	js     80102930 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028ce:	85 d2                	test   %edx,%edx
801028d0:	74 09                	je     801028db <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028d8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028db:	0f b6 91 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%edx
  shift ^= togglecode[data];
801028e2:	0f b6 81 80 7b 10 80 	movzbl -0x7fef8480(%ecx),%eax
  shift |= shiftcode[data];
801028e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028ef:	89 15 dc 26 11 80    	mov    %edx,0x801126dc
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028fb:	8b 04 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%eax
80102902:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102906:	74 0b                	je     80102913 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102908:	8d 50 9f             	lea    -0x61(%eax),%edx
8010290b:	83 fa 19             	cmp    $0x19,%edx
8010290e:	77 48                	ja     80102958 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102910:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102916:	c9                   	leave  
80102917:	c3                   	ret    
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop
    shift |= E0ESC;
80102920:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102923:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102925:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
}
8010292b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010292e:	c9                   	leave  
8010292f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102930:	83 e0 7f             	and    $0x7f,%eax
80102933:	85 d2                	test   %edx,%edx
80102935:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102938:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
8010293f:	83 c8 40             	or     $0x40,%eax
80102942:	0f b6 c0             	movzbl %al,%eax
80102945:	f7 d0                	not    %eax
80102947:	21 d8                	and    %ebx,%eax
}
80102949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010294c:	a3 dc 26 11 80       	mov    %eax,0x801126dc
    return 0;
80102951:	31 c0                	xor    %eax,%eax
}
80102953:	c9                   	leave  
80102954:	c3                   	ret    
80102955:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102958:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010295b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010295e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102961:	c9                   	leave  
      c += 'a' - 'A';
80102962:	83 f9 1a             	cmp    $0x1a,%ecx
80102965:	0f 42 c2             	cmovb  %edx,%eax
}
80102968:	c3                   	ret    
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102975:	c3                   	ret    
80102976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 a0 28 10 80       	push   $0x801028a0
8010298b:	e8 f0 de ff ff       	call   80100880 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave  
80102994:	c3                   	ret    
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	0f 84 cb 00 00 00    	je     80102a78 <lapicinit+0xd8>
  lapic[index] = value;
801029ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fb:	8b 50 30             	mov    0x30(%eax),%edx
801029fe:	c1 ea 10             	shr    $0x10,%edx
80102a01:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a07:	75 77                	jne    80102a80 <lapicinit+0xe0>
  lapic[index] = value;
80102a09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a54:	8b 50 20             	mov    0x20(%eax),%edx
80102a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a66:	80 e6 10             	and    $0x10,%dh
80102a69:	75 f5                	jne    80102a60 <lapicinit+0xc0>
  lapic[index] = value;
80102a6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a78:	c3                   	ret    
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a8d:	e9 77 ff ff ff       	jmp    80102a09 <lapicinit+0x69>
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102aa0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102aa5:	85 c0                	test   %eax,%eax
80102aa7:	74 07                	je     80102ab0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102aa9:	8b 40 20             	mov    0x20(%eax),%eax
80102aac:	c1 e8 18             	shr    $0x18,%eax
80102aaf:	c3                   	ret    
    return 0;
80102ab0:	31 c0                	xor    %eax,%eax
}
80102ab2:	c3                   	ret    
80102ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ac0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102ac5:	85 c0                	test   %eax,%eax
80102ac7:	74 0d                	je     80102ad6 <lapiceoi+0x16>
  lapic[index] = value;
80102ac9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ad0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ad6:	c3                   	ret    
80102ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ade:	66 90                	xchg   %ax,%ax

80102ae0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ae0:	c3                   	ret    
80102ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aef:	90                   	nop

80102af0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102af0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102af6:	ba 70 00 00 00       	mov    $0x70,%edx
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	53                   	push   %ebx
80102afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b04:	ee                   	out    %al,(%dx)
80102b05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b2e:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102b33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    
80102b7f:	90                   	nop

80102b80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b80:	55                   	push   %ebp
80102b81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b86:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	57                   	push   %edi
80102b8e:	56                   	push   %esi
80102b8f:	53                   	push   %ebx
80102b90:	83 ec 4c             	sub    $0x4c,%esp
80102b93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	ba 71 00 00 00       	mov    $0x71,%edx
80102b99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ba2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ba5:	8d 76 00             	lea    0x0(%esi),%esi
80102ba8:	31 c0                	xor    %eax,%eax
80102baa:	89 da                	mov    %ebx,%edx
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bb2:	89 ca                	mov    %ecx,%edx
80102bb4:	ec                   	in     (%dx),%al
80102bb5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb8:	89 da                	mov    %ebx,%edx
80102bba:	b8 02 00 00 00       	mov    $0x2,%eax
80102bbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc0:	89 ca                	mov    %ecx,%edx
80102bc2:	ec                   	in     (%dx),%al
80102bc3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc6:	89 da                	mov    %ebx,%edx
80102bc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bce:	89 ca                	mov    %ecx,%edx
80102bd0:	ec                   	in     (%dx),%al
80102bd1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd4:	89 da                	mov    %ebx,%edx
80102bd6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdc:	89 ca                	mov    %ecx,%edx
80102bde:	ec                   	in     (%dx),%al
80102bdf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be2:	89 da                	mov    %ebx,%edx
80102be4:	b8 08 00 00 00       	mov    $0x8,%eax
80102be9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bea:	89 ca                	mov    %ecx,%edx
80102bec:	ec                   	in     (%dx),%al
80102bed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bef:	89 da                	mov    %ebx,%edx
80102bf1:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf7:	89 ca                	mov    %ecx,%edx
80102bf9:	ec                   	in     (%dx),%al
80102bfa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfc:	89 da                	mov    %ebx,%edx
80102bfe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c04:	89 ca                	mov    %ecx,%edx
80102c06:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c07:	84 c0                	test   %al,%al
80102c09:	78 9d                	js     80102ba8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c0f:	89 fa                	mov    %edi,%edx
80102c11:	0f b6 fa             	movzbl %dl,%edi
80102c14:	89 f2                	mov    %esi,%edx
80102c16:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c19:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c1d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c20:	89 da                	mov    %ebx,%edx
80102c22:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c25:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c28:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c2c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c39:	31 c0                	xor    %eax,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 da                	mov    %ebx,%edx
80102c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c47:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4d:	89 ca                	mov    %ecx,%edx
80102c4f:	ec                   	in     (%dx),%al
80102c50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c53:	89 da                	mov    %ebx,%edx
80102c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
80102c61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 da                	mov    %ebx,%edx
80102c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c69:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6f:	89 ca                	mov    %ecx,%edx
80102c71:	ec                   	in     (%dx),%al
80102c72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	89 da                	mov    %ebx,%edx
80102c77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c80:	89 ca                	mov    %ecx,%edx
80102c82:	ec                   	in     (%dx),%al
80102c83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c86:	89 da                	mov    %ebx,%edx
80102c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c91:	89 ca                	mov    %ecx,%edx
80102c93:	ec                   	in     (%dx),%al
80102c94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ca0:	6a 18                	push   $0x18
80102ca2:	50                   	push   %eax
80102ca3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ca6:	50                   	push   %eax
80102ca7:	e8 54 1c 00 00       	call   80104900 <memcmp>
80102cac:	83 c4 10             	add    $0x10,%esp
80102caf:	85 c0                	test   %eax,%eax
80102cb1:	0f 85 f1 fe ff ff    	jne    80102ba8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cbb:	75 78                	jne    80102d35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cc0:	89 c2                	mov    %eax,%edx
80102cc2:	83 e0 0f             	and    $0xf,%eax
80102cc5:	c1 ea 04             	shr    $0x4,%edx
80102cc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cd4:	89 c2                	mov    %eax,%edx
80102cd6:	83 e0 0f             	and    $0xf,%eax
80102cd9:	c1 ea 04             	shr    $0x4,%edx
80102cdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ce5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce8:	89 c2                	mov    %eax,%edx
80102cea:	83 e0 0f             	and    $0xf,%eax
80102ced:	c1 ea 04             	shr    $0x4,%edx
80102cf0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cfc:	89 c2                	mov    %eax,%edx
80102cfe:	83 e0 0f             	and    $0xf,%eax
80102d01:	c1 ea 04             	shr    $0x4,%edx
80102d04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d10:	89 c2                	mov    %eax,%edx
80102d12:	83 e0 0f             	and    $0xf,%eax
80102d15:	c1 ea 04             	shr    $0x4,%edx
80102d18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d24:	89 c2                	mov    %eax,%edx
80102d26:	83 e0 0f             	and    $0xf,%eax
80102d29:	c1 ea 04             	shr    $0x4,%edx
80102d2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d35:	8b 75 08             	mov    0x8(%ebp),%esi
80102d38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d3b:	89 06                	mov    %eax,(%esi)
80102d3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d40:	89 46 04             	mov    %eax,0x4(%esi)
80102d43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d46:	89 46 08             	mov    %eax,0x8(%esi)
80102d49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d52:	89 46 10             	mov    %eax,0x10(%esi)
80102d55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d65:	5b                   	pop    %ebx
80102d66:	5e                   	pop    %esi
80102d67:	5f                   	pop    %edi
80102d68:	5d                   	pop    %ebp
80102d69:	c3                   	ret    
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d70:	8b 0d 48 27 11 80    	mov    0x80112748,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	0f 8e 8a 00 00 00    	jle    80102e08 <install_trans+0x98>
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d82:	31 ff                	xor    %edi,%edi
{
80102d84:	56                   	push   %esi
80102d85:	53                   	push   %ebx
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d90:	a1 34 27 11 80       	mov    0x80112734,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 f8                	add    %edi,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 44 27 11 80    	push   0x80112744
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 bd 4c 27 11 80 	push   -0x7feed8b4(,%edi,4)
80102db4:	ff 35 44 27 11 80    	push   0x80112744
  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dc5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 77 1b 00 00       	call   80104950 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dd9:	89 1c 24             	mov    %ebx,(%esp)
80102ddc:	e8 cf d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102de1:	89 34 24             	mov    %esi,(%esp)
80102de4:	e8 07 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102de9:	89 1c 24             	mov    %ebx,(%esp)
80102dec:	e8 ff d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	39 3d 48 27 11 80    	cmp    %edi,0x80112748
80102dfa:	7f 94                	jg     80102d90 <install_trans+0x20>
  }
}
80102dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dff:	5b                   	pop    %ebx
80102e00:	5e                   	pop    %esi
80102e01:	5f                   	pop    %edi
80102e02:	5d                   	pop    %ebp
80102e03:	c3                   	ret    
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e08:	c3                   	ret    
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e17:	ff 35 34 27 11 80    	push   0x80112734
80102e1d:	ff 35 44 27 11 80    	push   0x80112744
80102e23:	e8 a8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e28:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e2b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e2d:	a1 48 27 11 80       	mov    0x80112748,%eax
80102e32:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e35:	85 c0                	test   %eax,%eax
80102e37:	7e 19                	jle    80102e52 <write_head+0x42>
80102e39:	31 d2                	xor    %edx,%edx
80102e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e3f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e40:	8b 0c 95 4c 27 11 80 	mov    -0x7feed8b4(,%edx,4),%ecx
80102e47:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e4b:	83 c2 01             	add    $0x1,%edx
80102e4e:	39 d0                	cmp    %edx,%eax
80102e50:	75 ee                	jne    80102e40 <write_head+0x30>
  }
  bwrite(buf);
80102e52:	83 ec 0c             	sub    $0xc,%esp
80102e55:	53                   	push   %ebx
80102e56:	e8 55 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e5b:	89 1c 24             	mov    %ebx,(%esp)
80102e5e:	e8 8d d3 ff ff       	call   801001f0 <brelse>
}
80102e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e66:	83 c4 10             	add    $0x10,%esp
80102e69:	c9                   	leave  
80102e6a:	c3                   	ret    
80102e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <initlog>:
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 2c             	sub    $0x2c,%esp
80102e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e7a:	68 80 7d 10 80       	push   $0x80107d80
80102e7f:	68 00 27 11 80       	push   $0x80112700
80102e84:	e8 97 17 00 00       	call   80104620 <initlock>
  readsb(dev, &sb);
80102e89:	58                   	pop    %eax
80102e8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e8d:	5a                   	pop    %edx
80102e8e:	50                   	push   %eax
80102e8f:	53                   	push   %ebx
80102e90:	e8 8b e6 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e98:	59                   	pop    %ecx
  log.dev = dev;
80102e99:	89 1d 44 27 11 80    	mov    %ebx,0x80112744
  log.size = sb.nlog;
80102e9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ea2:	a3 34 27 11 80       	mov    %eax,0x80112734
  log.size = sb.nlog;
80102ea7:	89 15 38 27 11 80    	mov    %edx,0x80112738
  struct buf *buf = bread(log.dev, log.start);
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 1b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102eb5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102eb8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ebb:	89 1d 48 27 11 80    	mov    %ebx,0x80112748
  for (i = 0; i < log.lh.n; i++) {
80102ec1:	85 db                	test   %ebx,%ebx
80102ec3:	7e 1d                	jle    80102ee2 <initlog+0x72>
80102ec5:	31 d2                	xor    %edx,%edx
80102ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ece:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ed4:	89 0c 95 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102edb:	83 c2 01             	add    $0x1,%edx
80102ede:	39 d3                	cmp    %edx,%ebx
80102ee0:	75 ee                	jne    80102ed0 <initlog+0x60>
  brelse(buf);
80102ee2:	83 ec 0c             	sub    $0xc,%esp
80102ee5:	50                   	push   %eax
80102ee6:	e8 05 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eeb:	e8 80 fe ff ff       	call   80102d70 <install_trans>
  log.lh.n = 0;
80102ef0:	c7 05 48 27 11 80 00 	movl   $0x0,0x80112748
80102ef7:	00 00 00 
  write_head(); // clear the log
80102efa:	e8 11 ff ff ff       	call   80102e10 <write_head>
}
80102eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f02:	83 c4 10             	add    $0x10,%esp
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    
80102f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f16:	68 00 27 11 80       	push   $0x80112700
80102f1b:	e8 d0 18 00 00       	call   801047f0 <acquire>
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	eb 18                	jmp    80102f3d <begin_op+0x2d>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f28:	83 ec 08             	sub    $0x8,%esp
80102f2b:	68 00 27 11 80       	push   $0x80112700
80102f30:	68 00 27 11 80       	push   $0x80112700
80102f35:	e8 56 13 00 00       	call   80104290 <sleep>
80102f3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f3d:	a1 40 27 11 80       	mov    0x80112740,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	75 e2                	jne    80102f28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f46:	a1 3c 27 11 80       	mov    0x8011273c,%eax
80102f4b:	8b 15 48 27 11 80    	mov    0x80112748,%edx
80102f51:	83 c0 01             	add    $0x1,%eax
80102f54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f5a:	83 fa 1e             	cmp    $0x1e,%edx
80102f5d:	7f c9                	jg     80102f28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f62:	a3 3c 27 11 80       	mov    %eax,0x8011273c
      release(&log.lock);
80102f67:	68 00 27 11 80       	push   $0x80112700
80102f6c:	e8 1f 18 00 00       	call   80104790 <release>
      break;
    }
  }
}
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    
80102f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7d:	8d 76 00             	lea    0x0(%esi),%esi

80102f80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f89:	68 00 27 11 80       	push   $0x80112700
80102f8e:	e8 5d 18 00 00       	call   801047f0 <acquire>
  log.outstanding -= 1;
80102f93:	a1 3c 27 11 80       	mov    0x8011273c,%eax
  if(log.committing)
80102f98:	8b 35 40 27 11 80    	mov    0x80112740,%esi
80102f9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fa1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fa4:	89 1d 3c 27 11 80    	mov    %ebx,0x8011273c
  if(log.committing)
80102faa:	85 f6                	test   %esi,%esi
80102fac:	0f 85 22 01 00 00    	jne    801030d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb2:	85 db                	test   %ebx,%ebx
80102fb4:	0f 85 f6 00 00 00    	jne    801030b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fba:	c7 05 40 27 11 80 01 	movl   $0x1,0x80112740
80102fc1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc4:	83 ec 0c             	sub    $0xc,%esp
80102fc7:	68 00 27 11 80       	push   $0x80112700
80102fcc:	e8 bf 17 00 00       	call   80104790 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd1:	8b 0d 48 27 11 80    	mov    0x80112748,%ecx
80102fd7:	83 c4 10             	add    $0x10,%esp
80102fda:	85 c9                	test   %ecx,%ecx
80102fdc:	7f 42                	jg     80103020 <end_op+0xa0>
    acquire(&log.lock);
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 00 27 11 80       	push   $0x80112700
80102fe6:	e8 05 18 00 00       	call   801047f0 <acquire>
    wakeup(&log);
80102feb:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
    log.committing = 0;
80102ff2:	c7 05 40 27 11 80 00 	movl   $0x0,0x80112740
80102ff9:	00 00 00 
    wakeup(&log);
80102ffc:	e8 4f 13 00 00       	call   80104350 <wakeup>
    release(&log.lock);
80103001:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
80103008:	e8 83 17 00 00       	call   80104790 <release>
8010300d:	83 c4 10             	add    $0x10,%esp
}
80103010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103013:	5b                   	pop    %ebx
80103014:	5e                   	pop    %esi
80103015:	5f                   	pop    %edi
80103016:	5d                   	pop    %ebp
80103017:	c3                   	ret    
80103018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103020:	a1 34 27 11 80       	mov    0x80112734,%eax
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	01 d8                	add    %ebx,%eax
8010302a:	83 c0 01             	add    $0x1,%eax
8010302d:	50                   	push   %eax
8010302e:	ff 35 44 27 11 80    	push   0x80112744
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
80103039:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303b:	58                   	pop    %eax
8010303c:	5a                   	pop    %edx
8010303d:	ff 34 9d 4c 27 11 80 	push   -0x7feed8b4(,%ebx,4)
80103044:	ff 35 44 27 11 80    	push   0x80112744
  for (tail = 0; tail < log.lh.n; tail++) {
8010304a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010304d:	e8 7e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103052:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103055:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103057:	8d 40 5c             	lea    0x5c(%eax),%eax
8010305a:	68 00 02 00 00       	push   $0x200
8010305f:	50                   	push   %eax
80103060:	8d 46 5c             	lea    0x5c(%esi),%eax
80103063:	50                   	push   %eax
80103064:	e8 e7 18 00 00       	call   80104950 <memmove>
    bwrite(to);  // write the log
80103069:	89 34 24             	mov    %esi,(%esp)
8010306c:	e8 3f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103071:	89 3c 24             	mov    %edi,(%esp)
80103074:	e8 77 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 6f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103081:	83 c4 10             	add    $0x10,%esp
80103084:	3b 1d 48 27 11 80    	cmp    0x80112748,%ebx
8010308a:	7c 94                	jl     80103020 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010308c:	e8 7f fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103091:	e8 da fc ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
80103096:	c7 05 48 27 11 80 00 	movl   $0x0,0x80112748
8010309d:	00 00 00 
    write_head();    // Erase the transaction from the log
801030a0:	e8 6b fd ff ff       	call   80102e10 <write_head>
801030a5:	e9 34 ff ff ff       	jmp    80102fde <end_op+0x5e>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030b0:	83 ec 0c             	sub    $0xc,%esp
801030b3:	68 00 27 11 80       	push   $0x80112700
801030b8:	e8 93 12 00 00       	call   80104350 <wakeup>
  release(&log.lock);
801030bd:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
801030c4:	e8 c7 16 00 00       	call   80104790 <release>
801030c9:	83 c4 10             	add    $0x10,%esp
}
801030cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
    panic("log.committing");
801030d4:	83 ec 0c             	sub    $0xc,%esp
801030d7:	68 84 7d 10 80       	push   $0x80107d84
801030dc:	e8 9f d2 ff ff       	call   80100380 <panic>
801030e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop

801030f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f7:	8b 15 48 27 11 80    	mov    0x80112748,%edx
{
801030fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103100:	83 fa 1d             	cmp    $0x1d,%edx
80103103:	0f 8f 85 00 00 00    	jg     8010318e <log_write+0x9e>
80103109:	a1 38 27 11 80       	mov    0x80112738,%eax
8010310e:	83 e8 01             	sub    $0x1,%eax
80103111:	39 c2                	cmp    %eax,%edx
80103113:	7d 79                	jge    8010318e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103115:	a1 3c 27 11 80       	mov    0x8011273c,%eax
8010311a:	85 c0                	test   %eax,%eax
8010311c:	7e 7d                	jle    8010319b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010311e:	83 ec 0c             	sub    $0xc,%esp
80103121:	68 00 27 11 80       	push   $0x80112700
80103126:	e8 c5 16 00 00       	call   801047f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010312b:	8b 15 48 27 11 80    	mov    0x80112748,%edx
80103131:	83 c4 10             	add    $0x10,%esp
80103134:	85 d2                	test   %edx,%edx
80103136:	7e 4a                	jle    80103182 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103138:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010313b:	31 c0                	xor    %eax,%eax
8010313d:	eb 08                	jmp    80103147 <log_write+0x57>
8010313f:	90                   	nop
80103140:	83 c0 01             	add    $0x1,%eax
80103143:	39 c2                	cmp    %eax,%edx
80103145:	74 29                	je     80103170 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103147:	39 0c 85 4c 27 11 80 	cmp    %ecx,-0x7feed8b4(,%eax,4)
8010314e:	75 f0                	jne    80103140 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103150:	89 0c 85 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103157:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010315a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010315d:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
80103164:	c9                   	leave  
  release(&log.lock);
80103165:	e9 26 16 00 00       	jmp    80104790 <release>
8010316a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103170:	89 0c 95 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%edx,4)
    log.lh.n++;
80103177:	83 c2 01             	add    $0x1,%edx
8010317a:	89 15 48 27 11 80    	mov    %edx,0x80112748
80103180:	eb d5                	jmp    80103157 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103182:	8b 43 08             	mov    0x8(%ebx),%eax
80103185:	a3 4c 27 11 80       	mov    %eax,0x8011274c
  if (i == log.lh.n)
8010318a:	75 cb                	jne    80103157 <log_write+0x67>
8010318c:	eb e9                	jmp    80103177 <log_write+0x87>
    panic("too big a transaction");
8010318e:	83 ec 0c             	sub    $0xc,%esp
80103191:	68 93 7d 10 80       	push   $0x80107d93
80103196:	e8 e5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010319b:	83 ec 0c             	sub    $0xc,%esp
8010319e:	68 a9 7d 10 80       	push   $0x80107da9
801031a3:	e8 d8 d1 ff ff       	call   80100380 <panic>
801031a8:	66 90                	xchg   %ax,%ax
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	53                   	push   %ebx
801031b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031b7:	e8 54 09 00 00       	call   80103b10 <cpuid>
801031bc:	89 c3                	mov    %eax,%ebx
801031be:	e8 4d 09 00 00       	call   80103b10 <cpuid>
801031c3:	83 ec 04             	sub    $0x4,%esp
801031c6:	53                   	push   %ebx
801031c7:	50                   	push   %eax
801031c8:	68 c4 7d 10 80       	push   $0x80107dc4
801031cd:	e8 ce d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801031d2:	e8 c9 2b 00 00       	call   80105da0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031d7:	e8 d4 08 00 00       	call   80103ab0 <mycpu>
801031dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031de:	b8 01 00 00 00       	mov    $0x1,%eax
801031e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ea:	e8 91 0c 00 00       	call   80103e80 <scheduler>
801031ef:	90                   	nop

801031f0 <mpenter>:
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031f6:	e8 25 3d 00 00       	call   80106f20 <switchkvm>
  seginit();
801031fb:	e8 90 3c 00 00       	call   80106e90 <seginit>
  lapicinit();
80103200:	e8 9b f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
80103205:	e8 a6 ff ff ff       	call   801031b0 <mpmain>
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <main>:
{
80103210:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103214:	83 e4 f0             	and    $0xfffffff0,%esp
80103217:	ff 71 fc             	push   -0x4(%ecx)
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	53                   	push   %ebx
8010321e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010321f:	83 ec 08             	sub    $0x8,%esp
80103222:	68 00 00 40 80       	push   $0x80400000
80103227:	68 30 66 11 80       	push   $0x80116630
8010322c:	e8 df f3 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103231:	e8 1a 43 00 00       	call   80107550 <kvmalloc>
  khugeinit();
80103236:	e8 c5 f5 ff ff       	call   80102800 <khugeinit>
  mpinit();        // detect other processors
8010323b:	e8 80 01 00 00       	call   801033c0 <mpinit>
  lapicinit();     // interrupt controller
80103240:	e8 5b f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103245:	e8 46 3c 00 00       	call   80106e90 <seginit>
  picinit();       // disable pic
8010324a:	e8 71 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010324f:	e8 7c f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
80103254:	e8 07 d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103259:	e8 32 2e 00 00       	call   80106090 <uartinit>
  pinit();         // process table
8010325e:	e8 2d 08 00 00       	call   80103a90 <pinit>
  tvinit();        // trap vectors
80103263:	e8 b8 2a 00 00       	call   80105d20 <tvinit>
  binit();         // buffer cache
80103268:	e8 d3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010326d:	e8 9e db ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
80103272:	e8 49 ef ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103277:	83 c4 0c             	add    $0xc,%esp
8010327a:	68 8a 00 00 00       	push   $0x8a
8010327f:	68 9c b4 10 80       	push   $0x8010b49c
80103284:	68 00 70 00 80       	push   $0x80007000
80103289:	e8 c2 16 00 00       	call   80104950 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010328e:	83 c4 10             	add    $0x10,%esp
80103291:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
80103298:	00 00 00 
8010329b:	05 00 28 11 80       	add    $0x80112800,%eax
801032a0:	3d 00 28 11 80       	cmp    $0x80112800,%eax
801032a5:	76 79                	jbe    80103320 <main+0x110>
801032a7:	bb 00 28 11 80       	mov    $0x80112800,%ebx
801032ac:	eb 1b                	jmp    801032c9 <main+0xb9>
801032ae:	66 90                	xchg   %ax,%ax
801032b0:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
801032b7:	00 00 00 
801032ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032c0:	05 00 28 11 80       	add    $0x80112800,%eax
801032c5:	39 c3                	cmp    %eax,%ebx
801032c7:	73 57                	jae    80103320 <main+0x110>
    if(c == mycpu())  // We've started already.
801032c9:	e8 e2 07 00 00       	call   80103ab0 <mycpu>
801032ce:	39 c3                	cmp    %eax,%ebx
801032d0:	74 de                	je     801032b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032d2:	e8 a9 f3 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032da:	c7 05 f8 6f 00 80 f0 	movl   $0x801031f0,0x80006ff8
801032e1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032e4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032eb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ee:	05 00 10 00 00       	add    $0x1000,%eax
801032f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032f8:	0f b6 03             	movzbl (%ebx),%eax
801032fb:	68 00 70 00 00       	push   $0x7000
80103300:	50                   	push   %eax
80103301:	e8 ea f7 ff ff       	call   80102af0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103306:	83 c4 10             	add    $0x10,%esp
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103316:	85 c0                	test   %eax,%eax
80103318:	74 f6                	je     80103310 <main+0x100>
8010331a:	eb 94                	jmp    801032b0 <main+0xa0>
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103320:	83 ec 08             	sub    $0x8,%esp
80103323:	68 00 00 00 8e       	push   $0x8e000000
80103328:	68 00 00 40 80       	push   $0x80400000
8010332d:	e8 7e f2 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103332:	e8 29 08 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103337:	e8 74 fe ff ff       	call   801031b0 <mpmain>
8010333c:	66 90                	xchg   %ax,%ax
8010333e:	66 90                	xchg   %ax,%ax

80103340 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103345:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010334b:	53                   	push   %ebx
  e = addr+len;
8010334c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010334f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103352:	39 de                	cmp    %ebx,%esi
80103354:	72 10                	jb     80103366 <mpsearch1+0x26>
80103356:	eb 50                	jmp    801033a8 <mpsearch1+0x68>
80103358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop
80103360:	89 fe                	mov    %edi,%esi
80103362:	39 fb                	cmp    %edi,%ebx
80103364:	76 42                	jbe    801033a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103366:	83 ec 04             	sub    $0x4,%esp
80103369:	8d 7e 10             	lea    0x10(%esi),%edi
8010336c:	6a 04                	push   $0x4
8010336e:	68 d8 7d 10 80       	push   $0x80107dd8
80103373:	56                   	push   %esi
80103374:	e8 87 15 00 00       	call   80104900 <memcmp>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	85 c0                	test   %eax,%eax
8010337e:	75 e0                	jne    80103360 <mpsearch1+0x20>
80103380:	89 f2                	mov    %esi,%edx
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103388:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010338b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010338e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103390:	39 fa                	cmp    %edi,%edx
80103392:	75 f4                	jne    80103388 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103394:	84 c0                	test   %al,%al
80103396:	75 c8                	jne    80103360 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339b:	89 f0                	mov    %esi,%eax
8010339d:	5b                   	pop    %ebx
8010339e:	5e                   	pop    %esi
8010339f:	5f                   	pop    %edi
801033a0:	5d                   	pop    %ebp
801033a1:	c3                   	ret    
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ab:	31 f6                	xor    %esi,%esi
}
801033ad:	5b                   	pop    %ebx
801033ae:	89 f0                	mov    %esi,%eax
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret    
801033b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033bf:	90                   	nop

801033c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033d7:	c1 e0 08             	shl    $0x8,%eax
801033da:	09 d0                	or     %edx,%eax
801033dc:	c1 e0 04             	shl    $0x4,%eax
801033df:	75 1b                	jne    801033fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033ef:	c1 e0 08             	shl    $0x8,%eax
801033f2:	09 d0                	or     %edx,%eax
801033f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103401:	e8 3a ff ff ff       	call   80103340 <mpsearch1>
80103406:	89 c3                	mov    %eax,%ebx
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 84 40 01 00 00    	je     80103550 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103410:	8b 73 04             	mov    0x4(%ebx),%esi
80103413:	85 f6                	test   %esi,%esi
80103415:	0f 84 25 01 00 00    	je     80103540 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010341b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010341e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103424:	6a 04                	push   $0x4
80103426:	68 dd 7d 10 80       	push   $0x80107ddd
8010342b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010342c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010342f:	e8 cc 14 00 00       	call   80104900 <memcmp>
80103434:	83 c4 10             	add    $0x10,%esp
80103437:	85 c0                	test   %eax,%eax
80103439:	0f 85 01 01 00 00    	jne    80103540 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010343f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103446:	3c 01                	cmp    $0x1,%al
80103448:	74 08                	je     80103452 <mpinit+0x92>
8010344a:	3c 04                	cmp    $0x4,%al
8010344c:	0f 85 ee 00 00 00    	jne    80103540 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103452:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103459:	66 85 d2             	test   %dx,%dx
8010345c:	74 22                	je     80103480 <mpinit+0xc0>
8010345e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103461:	89 f0                	mov    %esi,%eax
  sum = 0;
80103463:	31 d2                	xor    %edx,%edx
80103465:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103468:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010346f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103472:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103474:	39 c7                	cmp    %eax,%edi
80103476:	75 f0                	jne    80103468 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103478:	84 d2                	test   %dl,%dl
8010347a:	0f 85 c0 00 00 00    	jne    80103540 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103480:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103486:	a3 e0 26 11 80       	mov    %eax,0x801126e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010348b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103492:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103498:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010349d:	03 55 e4             	add    -0x1c(%ebp),%edx
801034a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034a7:	90                   	nop
801034a8:	39 d0                	cmp    %edx,%eax
801034aa:	73 15                	jae    801034c1 <mpinit+0x101>
    switch(*p){
801034ac:	0f b6 08             	movzbl (%eax),%ecx
801034af:	80 f9 02             	cmp    $0x2,%cl
801034b2:	74 4c                	je     80103500 <mpinit+0x140>
801034b4:	77 3a                	ja     801034f0 <mpinit+0x130>
801034b6:	84 c9                	test   %cl,%cl
801034b8:	74 56                	je     80103510 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034ba:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bd:	39 d0                	cmp    %edx,%eax
801034bf:	72 eb                	jb     801034ac <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034c4:	85 f6                	test   %esi,%esi
801034c6:	0f 84 d9 00 00 00    	je     801035a5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034cc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034d0:	74 15                	je     801034e7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d2:	b8 70 00 00 00       	mov    $0x70,%eax
801034d7:	ba 22 00 00 00       	mov    $0x22,%edx
801034dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034dd:	ba 23 00 00 00       	mov    $0x23,%edx
801034e2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034e3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e6:	ee                   	out    %al,(%dx)
  }
}
801034e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ea:	5b                   	pop    %ebx
801034eb:	5e                   	pop    %esi
801034ec:	5f                   	pop    %edi
801034ed:	5d                   	pop    %ebp
801034ee:	c3                   	ret    
801034ef:	90                   	nop
    switch(*p){
801034f0:	83 e9 03             	sub    $0x3,%ecx
801034f3:	80 f9 01             	cmp    $0x1,%cl
801034f6:	76 c2                	jbe    801034ba <mpinit+0xfa>
801034f8:	31 f6                	xor    %esi,%esi
801034fa:	eb ac                	jmp    801034a8 <mpinit+0xe8>
801034fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103500:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103504:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103507:	88 0d e0 27 11 80    	mov    %cl,0x801127e0
      continue;
8010350d:	eb 99                	jmp    801034a8 <mpinit+0xe8>
8010350f:	90                   	nop
      if(ncpu < NCPU) {
80103510:	8b 0d e4 27 11 80    	mov    0x801127e4,%ecx
80103516:	83 f9 07             	cmp    $0x7,%ecx
80103519:	7f 19                	jg     80103534 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010351b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103521:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103525:	83 c1 01             	add    $0x1,%ecx
80103528:	89 0d e4 27 11 80    	mov    %ecx,0x801127e4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010352e:	88 9f 00 28 11 80    	mov    %bl,-0x7feed800(%edi)
      p += sizeof(struct mpproc);
80103534:	83 c0 14             	add    $0x14,%eax
      continue;
80103537:	e9 6c ff ff ff       	jmp    801034a8 <mpinit+0xe8>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	68 e2 7d 10 80       	push   $0x80107de2
80103548:	e8 33 ce ff ff       	call   80100380 <panic>
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103550:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103555:	eb 13                	jmp    8010356a <mpinit+0x1aa>
80103557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103560:	89 f3                	mov    %esi,%ebx
80103562:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103568:	74 d6                	je     80103540 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010356a:	83 ec 04             	sub    $0x4,%esp
8010356d:	8d 73 10             	lea    0x10(%ebx),%esi
80103570:	6a 04                	push   $0x4
80103572:	68 d8 7d 10 80       	push   $0x80107dd8
80103577:	53                   	push   %ebx
80103578:	e8 83 13 00 00       	call   80104900 <memcmp>
8010357d:	83 c4 10             	add    $0x10,%esp
80103580:	85 c0                	test   %eax,%eax
80103582:	75 dc                	jne    80103560 <mpinit+0x1a0>
80103584:	89 da                	mov    %ebx,%edx
80103586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103590:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103593:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103596:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103598:	39 d6                	cmp    %edx,%esi
8010359a:	75 f4                	jne    80103590 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010359c:	84 c0                	test   %al,%al
8010359e:	75 c0                	jne    80103560 <mpinit+0x1a0>
801035a0:	e9 6b fe ff ff       	jmp    80103410 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035a5:	83 ec 0c             	sub    $0xc,%esp
801035a8:	68 fc 7d 10 80       	push   $0x80107dfc
801035ad:	e8 ce cd ff ff       	call   80100380 <panic>
801035b2:	66 90                	xchg   %ax,%ax
801035b4:	66 90                	xchg   %ax,%ax
801035b6:	66 90                	xchg   %ax,%ax
801035b8:	66 90                	xchg   %ax,%ax
801035ba:	66 90                	xchg   %ax,%ax
801035bc:	66 90                	xchg   %ax,%ax
801035be:	66 90                	xchg   %ax,%ax

801035c0 <picinit>:
801035c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c5:	ba 21 00 00 00       	mov    $0x21,%edx
801035ca:	ee                   	out    %al,(%dx)
801035cb:	ba a1 00 00 00       	mov    $0xa1,%edx
801035d0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035d1:	c3                   	ret    
801035d2:	66 90                	xchg   %ax,%ax
801035d4:	66 90                	xchg   %ax,%ax
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035fb:	e8 30 d8 ff ff       	call   80100e30 <filealloc>
80103600:	89 03                	mov    %eax,(%ebx)
80103602:	85 c0                	test   %eax,%eax
80103604:	0f 84 a8 00 00 00    	je     801036b2 <pipealloc+0xd2>
8010360a:	e8 21 d8 ff ff       	call   80100e30 <filealloc>
8010360f:	89 06                	mov    %eax,(%esi)
80103611:	85 c0                	test   %eax,%eax
80103613:	0f 84 87 00 00 00    	je     801036a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103619:	e8 62 f0 ff ff       	call   80102680 <kalloc>
8010361e:	89 c7                	mov    %eax,%edi
80103620:	85 c0                	test   %eax,%eax
80103622:	0f 84 b0 00 00 00    	je     801036d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103628:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010362f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103632:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103635:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010363c:	00 00 00 
  p->nwrite = 0;
8010363f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103646:	00 00 00 
  p->nread = 0;
80103649:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103650:	00 00 00 
  initlock(&p->lock, "pipe");
80103653:	68 1b 7e 10 80       	push   $0x80107e1b
80103658:	50                   	push   %eax
80103659:	e8 c2 0f 00 00       	call   80104620 <initlock>
  (*f0)->type = FD_PIPE;
8010365e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103660:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103663:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103669:	8b 03                	mov    (%ebx),%eax
8010366b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010366f:	8b 03                	mov    (%ebx),%eax
80103671:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103675:	8b 03                	mov    (%ebx),%eax
80103677:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010367a:	8b 06                	mov    (%esi),%eax
8010367c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103682:	8b 06                	mov    (%esi),%eax
80103684:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103688:	8b 06                	mov    (%esi),%eax
8010368a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010368e:	8b 06                	mov    (%esi),%eax
80103690:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103693:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103696:	31 c0                	xor    %eax,%eax
}
80103698:	5b                   	pop    %ebx
80103699:	5e                   	pop    %esi
8010369a:	5f                   	pop    %edi
8010369b:	5d                   	pop    %ebp
8010369c:	c3                   	ret    
8010369d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036a0:	8b 03                	mov    (%ebx),%eax
801036a2:	85 c0                	test   %eax,%eax
801036a4:	74 1e                	je     801036c4 <pipealloc+0xe4>
    fileclose(*f0);
801036a6:	83 ec 0c             	sub    $0xc,%esp
801036a9:	50                   	push   %eax
801036aa:	e8 41 d8 ff ff       	call   80100ef0 <fileclose>
801036af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036b2:	8b 06                	mov    (%esi),%eax
801036b4:	85 c0                	test   %eax,%eax
801036b6:	74 0c                	je     801036c4 <pipealloc+0xe4>
    fileclose(*f1);
801036b8:	83 ec 0c             	sub    $0xc,%esp
801036bb:	50                   	push   %eax
801036bc:	e8 2f d8 ff ff       	call   80100ef0 <fileclose>
801036c1:	83 c4 10             	add    $0x10,%esp
}
801036c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036d8:	8b 03                	mov    (%ebx),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	75 c8                	jne    801036a6 <pipealloc+0xc6>
801036de:	eb d2                	jmp    801036b2 <pipealloc+0xd2>

801036e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	53                   	push   %ebx
801036ef:	e8 fc 10 00 00       	call   801047f0 <acquire>
  if(writable){
801036f4:	83 c4 10             	add    $0x10,%esp
801036f7:	85 f6                	test   %esi,%esi
801036f9:	74 65                	je     80103760 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103704:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010370b:	00 00 00 
    wakeup(&p->nread);
8010370e:	50                   	push   %eax
8010370f:	e8 3c 0c 00 00       	call   80104350 <wakeup>
80103714:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103717:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010371d:	85 d2                	test   %edx,%edx
8010371f:	75 0a                	jne    8010372b <pipeclose+0x4b>
80103721:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	74 15                	je     80103740 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010372b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010372e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103731:	5b                   	pop    %ebx
80103732:	5e                   	pop    %esi
80103733:	5d                   	pop    %ebp
    release(&p->lock);
80103734:	e9 57 10 00 00       	jmp    80104790 <release>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	53                   	push   %ebx
80103744:	e8 47 10 00 00       	call   80104790 <release>
    kfree((char*)p);
80103749:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010374c:	83 c4 10             	add    $0x10,%esp
}
8010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
    kfree((char*)p);
80103755:	e9 66 ed ff ff       	jmp    801024c0 <kfree>
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103769:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103770:	00 00 00 
    wakeup(&p->nwrite);
80103773:	50                   	push   %eax
80103774:	e8 d7 0b 00 00       	call   80104350 <wakeup>
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	eb 99                	jmp    80103717 <pipeclose+0x37>
8010377e:	66 90                	xchg   %ax,%ax

80103780 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 28             	sub    $0x28,%esp
80103789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010378c:	53                   	push   %ebx
8010378d:	e8 5e 10 00 00       	call   801047f0 <acquire>
  for(i = 0; i < n; i++){
80103792:	8b 45 10             	mov    0x10(%ebp),%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	0f 8e c0 00 00 00    	jle    80103860 <pipewrite+0xe0>
801037a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037b2:	03 45 10             	add    0x10(%ebp),%eax
801037b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037be:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c4:	89 ca                	mov    %ecx,%edx
801037c6:	05 00 02 00 00       	add    $0x200,%eax
801037cb:	39 c1                	cmp    %eax,%ecx
801037cd:	74 3f                	je     8010380e <pipewrite+0x8e>
801037cf:	eb 67                	jmp    80103838 <pipewrite+0xb8>
801037d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801037d8:	e8 53 03 00 00       	call   80103b30 <myproc>
801037dd:	8b 48 28             	mov    0x28(%eax),%ecx
801037e0:	85 c9                	test   %ecx,%ecx
801037e2:	75 34                	jne    80103818 <pipewrite+0x98>
      wakeup(&p->nread);
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	57                   	push   %edi
801037e8:	e8 63 0b 00 00       	call   80104350 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037ed:	58                   	pop    %eax
801037ee:	5a                   	pop    %edx
801037ef:	53                   	push   %ebx
801037f0:	56                   	push   %esi
801037f1:	e8 9a 0a 00 00       	call   80104290 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037fc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103802:	83 c4 10             	add    $0x10,%esp
80103805:	05 00 02 00 00       	add    $0x200,%eax
8010380a:	39 c2                	cmp    %eax,%edx
8010380c:	75 2a                	jne    80103838 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010380e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103814:	85 c0                	test   %eax,%eax
80103816:	75 c0                	jne    801037d8 <pipewrite+0x58>
        release(&p->lock);
80103818:	83 ec 0c             	sub    $0xc,%esp
8010381b:	53                   	push   %ebx
8010381c:	e8 6f 0f 00 00       	call   80104790 <release>
        return -1;
80103821:	83 c4 10             	add    $0x10,%esp
80103824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010382c:	5b                   	pop    %ebx
8010382d:	5e                   	pop    %esi
8010382e:	5f                   	pop    %edi
8010382f:	5d                   	pop    %ebp
80103830:	c3                   	ret    
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103838:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010383b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010383e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103844:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010384a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010384d:	83 c6 01             	add    $0x1,%esi
80103850:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103853:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103857:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010385a:	0f 85 58 ff ff ff    	jne    801037b8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103869:	50                   	push   %eax
8010386a:	e8 e1 0a 00 00       	call   80104350 <wakeup>
  release(&p->lock);
8010386f:	89 1c 24             	mov    %ebx,(%esp)
80103872:	e8 19 0f 00 00       	call   80104790 <release>
  return n;
80103877:	8b 45 10             	mov    0x10(%ebp),%eax
8010387a:	83 c4 10             	add    $0x10,%esp
8010387d:	eb aa                	jmp    80103829 <pipewrite+0xa9>
8010387f:	90                   	nop

80103880 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 18             	sub    $0x18,%esp
80103889:	8b 75 08             	mov    0x8(%ebp),%esi
8010388c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010388f:	56                   	push   %esi
80103890:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103896:	e8 55 0f 00 00       	call   801047f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010389b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038a1:	83 c4 10             	add    $0x10,%esp
801038a4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038aa:	74 2f                	je     801038db <piperead+0x5b>
801038ac:	eb 37                	jmp    801038e5 <piperead+0x65>
801038ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038b0:	e8 7b 02 00 00       	call   80103b30 <myproc>
801038b5:	8b 48 28             	mov    0x28(%eax),%ecx
801038b8:	85 c9                	test   %ecx,%ecx
801038ba:	0f 85 80 00 00 00    	jne    80103940 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038c0:	83 ec 08             	sub    $0x8,%esp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	e8 c6 09 00 00       	call   80104290 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801038d9:	75 0a                	jne    801038e5 <piperead+0x65>
801038db:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801038e1:	85 c0                	test   %eax,%eax
801038e3:	75 cb                	jne    801038b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e5:	8b 55 10             	mov    0x10(%ebp),%edx
801038e8:	31 db                	xor    %ebx,%ebx
801038ea:	85 d2                	test   %edx,%edx
801038ec:	7f 20                	jg     8010390e <piperead+0x8e>
801038ee:	eb 2c                	jmp    8010391c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038f0:	8d 48 01             	lea    0x1(%eax),%ecx
801038f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103903:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103906:	83 c3 01             	add    $0x1,%ebx
80103909:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010390c:	74 0e                	je     8010391c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010390e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103914:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010391a:	75 d4                	jne    801038f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010391c:	83 ec 0c             	sub    $0xc,%esp
8010391f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103925:	50                   	push   %eax
80103926:	e8 25 0a 00 00       	call   80104350 <wakeup>
  release(&p->lock);
8010392b:	89 34 24             	mov    %esi,(%esp)
8010392e:	e8 5d 0e 00 00       	call   80104790 <release>
  return i;
80103933:	83 c4 10             	add    $0x10,%esp
}
80103936:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103939:	89 d8                	mov    %ebx,%eax
8010393b:	5b                   	pop    %ebx
8010393c:	5e                   	pop    %esi
8010393d:	5f                   	pop    %edi
8010393e:	5d                   	pop    %ebp
8010393f:	c3                   	ret    
      release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103943:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103948:	56                   	push   %esi
80103949:	e8 42 0e 00 00       	call   80104790 <release>
      return -1;
8010394e:	83 c4 10             	add    $0x10,%esp
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	89 d8                	mov    %ebx,%eax
80103956:	5b                   	pop    %ebx
80103957:	5e                   	pop    %esi
80103958:	5f                   	pop    %edi
80103959:	5d                   	pop    %ebp
8010395a:	c3                   	ret    
8010395b:	66 90                	xchg   %ax,%ax
8010395d:	66 90                	xchg   %ax,%ax
8010395f:	90                   	nop

80103960 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103964:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
80103969:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010396c:	68 80 2d 11 80       	push   $0x80112d80
80103971:	e8 7a 0e 00 00       	call   801047f0 <acquire>
80103976:	83 c4 10             	add    $0x10,%esp
80103979:	eb 14                	jmp    8010398f <allocproc+0x2f>
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	83 eb 80             	sub    $0xffffff80,%ebx
80103983:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80103989:	0f 84 81 00 00 00    	je     80103a10 <allocproc+0xb0>
    if(p->state == UNUSED)
8010398f:	8b 43 10             	mov    0x10(%ebx),%eax
80103992:	85 c0                	test   %eax,%eax
80103994:	75 ea                	jne    80103980 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103996:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->hugesz = 0;

  release(&ptable.lock);
8010399b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010399e:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->hugesz = 0;
801039a5:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  p->pid = nextpid++;
801039ac:	89 43 14             	mov    %eax,0x14(%ebx)
801039af:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039b2:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
801039b7:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039bd:	e8 ce 0d 00 00       	call   80104790 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039c2:	e8 b9 ec ff ff       	call   80102680 <kalloc>
801039c7:	83 c4 10             	add    $0x10,%esp
801039ca:	89 43 0c             	mov    %eax,0xc(%ebx)
801039cd:	85 c0                	test   %eax,%eax
801039cf:	74 58                	je     80103a29 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039d1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039d7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039da:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039df:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801039e2:	c7 40 14 0b 5d 10 80 	movl   $0x80105d0b,0x14(%eax)
  p->context = (struct context*)sp;
801039e9:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039ec:	6a 14                	push   $0x14
801039ee:	6a 00                	push   $0x0
801039f0:	50                   	push   %eax
801039f1:	e8 ba 0e 00 00       	call   801048b0 <memset>
  p->context->eip = (uint)forkret;
801039f6:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
801039f9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039fc:	c7 40 10 40 3a 10 80 	movl   $0x80103a40,0x10(%eax)
}
80103a03:	89 d8                	mov    %ebx,%eax
80103a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a08:	c9                   	leave  
80103a09:	c3                   	ret    
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a15:	68 80 2d 11 80       	push   $0x80112d80
80103a1a:	e8 71 0d 00 00       	call   80104790 <release>
}
80103a1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a21:	83 c4 10             	add    $0x10,%esp
}
80103a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a27:	c9                   	leave  
80103a28:	c3                   	ret    
    p->state = UNUSED;
80103a29:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103a30:	31 db                	xor    %ebx,%ebx
}
80103a32:	89 d8                	mov    %ebx,%eax
80103a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a37:	c9                   	leave  
80103a38:	c3                   	ret    
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a46:	68 80 2d 11 80       	push   $0x80112d80
80103a4b:	e8 40 0d 00 00       	call   80104790 <release>

  if (first) {
80103a50:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	75 04                	jne    80103a60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a5c:	c9                   	leave  
80103a5d:	c3                   	ret    
80103a5e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a60:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a67:	00 00 00 
    iinit(ROOTDEV);
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	6a 01                	push   $0x1
80103a6f:	e8 ec da ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a7b:	e8 f0 f3 ff ff       	call   80102e70 <initlog>
}
80103a80:	83 c4 10             	add    $0x10,%esp
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    
80103a85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a90 <pinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a96:	68 20 7e 10 80       	push   $0x80107e20
80103a9b:	68 80 2d 11 80       	push   $0x80112d80
80103aa0:	e8 7b 0b 00 00       	call   80104620 <initlock>
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	c9                   	leave  
80103aa9:	c3                   	ret    
80103aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ab0 <mycpu>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab5:	9c                   	pushf  
80103ab6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ab7:	f6 c4 02             	test   $0x2,%ah
80103aba:	75 46                	jne    80103b02 <mycpu+0x52>
  apicid = lapicid();
80103abc:	e8 df ef ff ff       	call   80102aa0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ac1:	8b 35 e4 27 11 80    	mov    0x801127e4,%esi
80103ac7:	85 f6                	test   %esi,%esi
80103ac9:	7e 2a                	jle    80103af5 <mycpu+0x45>
80103acb:	31 d2                	xor    %edx,%edx
80103acd:	eb 08                	jmp    80103ad7 <mycpu+0x27>
80103acf:	90                   	nop
80103ad0:	83 c2 01             	add    $0x1,%edx
80103ad3:	39 f2                	cmp    %esi,%edx
80103ad5:	74 1e                	je     80103af5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ad7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103add:	0f b6 99 00 28 11 80 	movzbl -0x7feed800(%ecx),%ebx
80103ae4:	39 c3                	cmp    %eax,%ebx
80103ae6:	75 e8                	jne    80103ad0 <mycpu+0x20>
}
80103ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103aeb:	8d 81 00 28 11 80    	lea    -0x7feed800(%ecx),%eax
}
80103af1:	5b                   	pop    %ebx
80103af2:	5e                   	pop    %esi
80103af3:	5d                   	pop    %ebp
80103af4:	c3                   	ret    
  panic("unknown apicid\n");
80103af5:	83 ec 0c             	sub    $0xc,%esp
80103af8:	68 27 7e 10 80       	push   $0x80107e27
80103afd:	e8 7e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b02:	83 ec 0c             	sub    $0xc,%esp
80103b05:	68 04 7f 10 80       	push   $0x80107f04
80103b0a:	e8 71 c8 ff ff       	call   80100380 <panic>
80103b0f:	90                   	nop

80103b10 <cpuid>:
cpuid() {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b16:	e8 95 ff ff ff       	call   80103ab0 <mycpu>
}
80103b1b:	c9                   	leave  
  return mycpu()-cpus;
80103b1c:	2d 00 28 11 80       	sub    $0x80112800,%eax
80103b21:	c1 f8 04             	sar    $0x4,%eax
80103b24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b2a:	c3                   	ret    
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <myproc>:
myproc(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b37:	e8 64 0b 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103b3c:	e8 6f ff ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103b41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b47:	e8 a4 0b 00 00       	call   801046f0 <popcli>
}
80103b4c:	89 d8                	mov    %ebx,%eax
80103b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b51:	c9                   	leave  
80103b52:	c3                   	ret    
80103b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 f4 fd ff ff       	call   80103960 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 b4 4d 11 80       	mov    %eax,0x80114db4
  if((p->pgdir = setupkvm()) == 0)
80103b73:	e8 58 39 00 00       	call   801074d0 <setupkvm>
80103b78:	89 43 08             	mov    %eax,0x8(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 c4 00 00 00    	je     80103c47 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 70 b4 10 80       	push   $0x8010b470
80103b90:	50                   	push   %eax
80103b91:	e8 aa 34 00 00       	call   80107040 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->hugesz = 0; 
80103b9f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ba6:	6a 4c                	push   $0x4c
80103ba8:	6a 00                	push   $0x0
80103baa:	ff 73 1c             	push   0x1c(%ebx)
80103bad:	e8 fe 0c 00 00       	call   801048b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bb2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bb5:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bba:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbd:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bc2:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bc6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc9:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bcd:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd0:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd4:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd8:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bdb:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bdf:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103be3:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be6:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bed:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bf7:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bfa:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c01:	8d 43 70             	lea    0x70(%ebx),%eax
80103c04:	6a 10                	push   $0x10
80103c06:	68 50 7e 10 80       	push   $0x80107e50
80103c0b:	50                   	push   %eax
80103c0c:	e8 5f 0e 00 00       	call   80104a70 <safestrcpy>
  p->cwd = namei("/");
80103c11:	c7 04 24 59 7e 10 80 	movl   $0x80107e59,(%esp)
80103c18:	e8 83 e4 ff ff       	call   801020a0 <namei>
80103c1d:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c20:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c27:	e8 c4 0b 00 00       	call   801047f0 <acquire>
  p->state = RUNNABLE;
80103c2c:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c33:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c3a:	e8 51 0b 00 00       	call   80104790 <release>
}
80103c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c42:	83 c4 10             	add    $0x10,%esp
80103c45:	c9                   	leave  
80103c46:	c3                   	ret    
    panic("userinit: out of memory?");
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	68 37 7e 10 80       	push   $0x80107e37
80103c4f:	e8 2c c7 ff ff       	call   80100380 <panic>
80103c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <growproc_huge>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c68:	e8 33 0a 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103c6d:	e8 3e fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c78:	e8 73 0a 00 00       	call   801046f0 <popcli>
  if(hugepage) {
80103c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c80:	85 c0                	test   %eax,%eax
80103c82:	74 2c                	je     80103cb0 <growproc_huge+0x50>
    sz = curproc->hugesz;
80103c84:	8b 43 04             	mov    0x4(%ebx),%eax
      sz = HUGE_VA_OFFSET;  // Start at this offset for huge pages
80103c87:	ba 00 00 00 1e       	mov    $0x1e000000,%edx
80103c8c:	85 c0                	test   %eax,%eax
80103c8e:	0f 44 c2             	cmove  %edx,%eax
    if(n > 0){
80103c91:	85 f6                	test   %esi,%esi
80103c93:	7f 5b                	jg     80103cf0 <growproc_huge+0x90>
    } else if(n < 0){
80103c95:	74 6e                	je     80103d05 <growproc_huge+0xa5>
      sz = deallocuvm(curproc->pgdir, sz, sz + n, 1);
80103c97:	01 c6                	add    %eax,%esi
80103c99:	6a 01                	push   $0x1
80103c9b:	56                   	push   %esi
80103c9c:	50                   	push   %eax
80103c9d:	ff 73 08             	push   0x8(%ebx)
80103ca0:	e8 0b 37 00 00       	call   801073b0 <deallocuvm>
80103ca5:	83 c4 10             	add    $0x10,%esp
80103ca8:	eb 5b                	jmp    80103d05 <growproc_huge+0xa5>
80103caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sz = curproc->sz;
80103cb0:	8b 03                	mov    (%ebx),%eax
    if(n > 0){
80103cb2:	85 f6                	test   %esi,%esi
80103cb4:	7f 1a                	jg     80103cd0 <growproc_huge+0x70>
    } else if(n < 0){
80103cb6:	75 58                	jne    80103d10 <growproc_huge+0xb0>
    curproc->sz = sz;
80103cb8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cba:	83 ec 0c             	sub    $0xc,%esp
80103cbd:	53                   	push   %ebx
80103cbe:	e8 6d 32 00 00       	call   80106f30 <switchuvm>
  return 0;
80103cc3:	83 c4 10             	add    $0x10,%esp
80103cc6:	31 c0                	xor    %eax,%eax
}
80103cc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ccb:	5b                   	pop    %ebx
80103ccc:	5e                   	pop    %esi
80103ccd:	5d                   	pop    %ebp
80103cce:	c3                   	ret    
80103ccf:	90                   	nop
      if((sz = allocuvm(curproc->pgdir, sz, sz + n, 0)) == 0)
80103cd0:	01 c6                	add    %eax,%esi
80103cd2:	6a 00                	push   $0x0
80103cd4:	56                   	push   %esi
80103cd5:	50                   	push   %eax
80103cd6:	ff 73 08             	push   0x8(%ebx)
80103cd9:	e8 d2 34 00 00       	call   801071b0 <allocuvm>
80103cde:	83 c4 10             	add    $0x10,%esp
80103ce1:	85 c0                	test   %eax,%eax
80103ce3:	75 d3                	jne    80103cb8 <growproc_huge+0x58>
        return -1;
80103ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cea:	eb dc                	jmp    80103cc8 <growproc_huge+0x68>
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((sz = allocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80103cf0:	01 c6                	add    %eax,%esi
80103cf2:	6a 01                	push   $0x1
80103cf4:	56                   	push   %esi
80103cf5:	50                   	push   %eax
80103cf6:	ff 73 08             	push   0x8(%ebx)
80103cf9:	e8 b2 34 00 00       	call   801071b0 <allocuvm>
80103cfe:	83 c4 10             	add    $0x10,%esp
80103d01:	85 c0                	test   %eax,%eax
80103d03:	74 e0                	je     80103ce5 <growproc_huge+0x85>
    curproc->hugesz = sz;
80103d05:	89 43 04             	mov    %eax,0x4(%ebx)
80103d08:	eb b0                	jmp    80103cba <growproc_huge+0x5a>
80103d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      sz = deallocuvm(curproc->pgdir, sz, sz + n, 0);
80103d10:	01 c6                	add    %eax,%esi
80103d12:	6a 00                	push   $0x0
80103d14:	56                   	push   %esi
80103d15:	50                   	push   %eax
80103d16:	ff 73 08             	push   0x8(%ebx)
80103d19:	e8 92 36 00 00       	call   801073b0 <deallocuvm>
80103d1e:	83 c4 10             	add    $0x10,%esp
80103d21:	eb 95                	jmp    80103cb8 <growproc_huge+0x58>
80103d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d30 <growproc>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	83 ec 10             	sub    $0x10,%esp
  return growproc_huge(n, 0);
80103d36:	6a 00                	push   $0x0
80103d38:	ff 75 08             	push   0x8(%ebp)
80103d3b:	e8 20 ff ff ff       	call   80103c60 <growproc_huge>
}
80103d40:	c9                   	leave  
80103d41:	c3                   	ret    
80103d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d50 <fork>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d59:	e8 42 09 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103d5e:	e8 4d fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103d63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d69:	e8 82 09 00 00       	call   801046f0 <popcli>
  if((np = allocproc()) == 0){
80103d6e:	e8 ed fb ff ff       	call   80103960 <allocproc>
80103d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d76:	85 c0                	test   %eax,%eax
80103d78:	0f 84 c7 00 00 00    	je     80103e45 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d7e:	83 ec 08             	sub    $0x8,%esp
80103d81:	ff 33                	push   (%ebx)
80103d83:	89 c7                	mov    %eax,%edi
80103d85:	ff 73 08             	push   0x8(%ebx)
80103d88:	e8 33 38 00 00       	call   801075c0 <copyuvm>
80103d8d:	83 c4 10             	add    $0x10,%esp
80103d90:	89 47 08             	mov    %eax,0x8(%edi)
80103d93:	85 c0                	test   %eax,%eax
80103d95:	0f 84 b1 00 00 00    	je     80103e4c <fork+0xfc>
  np->sz = curproc->sz;
80103d9b:	8b 03                	mov    (%ebx),%eax
80103d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103da0:	89 01                	mov    %eax,(%ecx)
  np->hugesz = curproc->hugesz;
80103da2:	8b 43 04             	mov    0x4(%ebx),%eax
  *np->tf = *curproc->tf;
80103da5:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103da8:	89 59 18             	mov    %ebx,0x18(%ecx)
  np->hugesz = curproc->hugesz;
80103dab:	89 41 04             	mov    %eax,0x4(%ecx)
  np->parent = curproc;
80103dae:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103db0:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103db3:	b9 13 00 00 00       	mov    $0x13,%ecx
80103db8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103dba:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103dbc:	8b 40 1c             	mov    0x1c(%eax),%eax
80103dbf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103dd0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103dd4:	85 c0                	test   %eax,%eax
80103dd6:	74 13                	je     80103deb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	50                   	push   %eax
80103ddc:	e8 bf d0 ff ff       	call   80100ea0 <filedup>
80103de1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103de4:	83 c4 10             	add    $0x10,%esp
80103de7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103deb:	83 c6 01             	add    $0x1,%esi
80103dee:	83 fe 10             	cmp    $0x10,%esi
80103df1:	75 dd                	jne    80103dd0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103df3:	83 ec 0c             	sub    $0xc,%esp
80103df6:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df9:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103dfc:	e8 4f d9 ff ff       	call   80101750 <idup>
80103e01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e07:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e0a:	8d 47 70             	lea    0x70(%edi),%eax
80103e0d:	6a 10                	push   $0x10
80103e0f:	53                   	push   %ebx
80103e10:	50                   	push   %eax
80103e11:	e8 5a 0c 00 00       	call   80104a70 <safestrcpy>
  pid = np->pid;
80103e16:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103e19:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e20:	e8 cb 09 00 00       	call   801047f0 <acquire>
  np->state = RUNNABLE;
80103e25:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103e2c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e33:	e8 58 09 00 00       	call   80104790 <release>
  return pid;
80103e38:	83 c4 10             	add    $0x10,%esp
}
80103e3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3e:	89 d8                	mov    %ebx,%eax
80103e40:	5b                   	pop    %ebx
80103e41:	5e                   	pop    %esi
80103e42:	5f                   	pop    %edi
80103e43:	5d                   	pop    %ebp
80103e44:	c3                   	ret    
    return -1;
80103e45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e4a:	eb ef                	jmp    80103e3b <fork+0xeb>
    kfree(np->kstack);
80103e4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e4f:	83 ec 0c             	sub    $0xc,%esp
80103e52:	ff 73 0c             	push   0xc(%ebx)
80103e55:	e8 66 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103e5a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e61:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e64:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103e6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e70:	eb c9                	jmp    80103e3b <fork+0xeb>
80103e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e80 <scheduler>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e89:	e8 22 fc ff ff       	call   80103ab0 <mycpu>
  c->proc = 0;
80103e8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e95:	00 00 00 
  struct cpu *c = mycpu();
80103e98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e9a:	8d 78 04             	lea    0x4(%eax),%edi
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ea0:	fb                   	sti    
    acquire(&ptable.lock);
80103ea1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
    acquire(&ptable.lock);
80103ea9:	68 80 2d 11 80       	push   $0x80112d80
80103eae:	e8 3d 09 00 00       	call   801047f0 <acquire>
80103eb3:	83 c4 10             	add    $0x10,%esp
80103eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ec0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103ec4:	75 33                	jne    80103ef9 <scheduler+0x79>
      switchuvm(p);
80103ec6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ec9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ecf:	53                   	push   %ebx
80103ed0:	e8 5b 30 00 00       	call   80106f30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ed5:	58                   	pop    %eax
80103ed6:	5a                   	pop    %edx
80103ed7:	ff 73 20             	push   0x20(%ebx)
80103eda:	57                   	push   %edi
      p->state = RUNNING;
80103edb:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ee2:	e8 e4 0b 00 00       	call   80104acb <swtch>
      switchkvm();
80103ee7:	e8 34 30 00 00       	call   80106f20 <switchkvm>
      c->proc = 0;
80103eec:	83 c4 10             	add    $0x10,%esp
80103eef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ef6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef9:	83 eb 80             	sub    $0xffffff80,%ebx
80103efc:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80103f02:	75 bc                	jne    80103ec0 <scheduler+0x40>
    release(&ptable.lock);
80103f04:	83 ec 0c             	sub    $0xc,%esp
80103f07:	68 80 2d 11 80       	push   $0x80112d80
80103f0c:	e8 7f 08 00 00       	call   80104790 <release>
    sti();
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	eb 8a                	jmp    80103ea0 <scheduler+0x20>
80103f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi

80103f20 <sched>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	56                   	push   %esi
80103f24:	53                   	push   %ebx
  pushcli();
80103f25:	e8 76 07 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103f2a:	e8 81 fb ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103f2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f35:	e8 b6 07 00 00       	call   801046f0 <popcli>
  if(!holding(&ptable.lock))
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 80 2d 11 80       	push   $0x80112d80
80103f42:	e8 09 08 00 00       	call   80104750 <holding>
80103f47:	83 c4 10             	add    $0x10,%esp
80103f4a:	85 c0                	test   %eax,%eax
80103f4c:	74 4f                	je     80103f9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f4e:	e8 5d fb ff ff       	call   80103ab0 <mycpu>
80103f53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f5a:	75 68                	jne    80103fc4 <sched+0xa4>
  if(p->state == RUNNING)
80103f5c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f60:	74 55                	je     80103fb7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f62:	9c                   	pushf  
80103f63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f64:	f6 c4 02             	test   $0x2,%ah
80103f67:	75 41                	jne    80103faa <sched+0x8a>
  intena = mycpu()->intena;
80103f69:	e8 42 fb ff ff       	call   80103ab0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f6e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f77:	e8 34 fb ff ff       	call   80103ab0 <mycpu>
80103f7c:	83 ec 08             	sub    $0x8,%esp
80103f7f:	ff 70 04             	push   0x4(%eax)
80103f82:	53                   	push   %ebx
80103f83:	e8 43 0b 00 00       	call   80104acb <swtch>
  mycpu()->intena = intena;
80103f88:	e8 23 fb ff ff       	call   80103ab0 <mycpu>
}
80103f8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f99:	5b                   	pop    %ebx
80103f9a:	5e                   	pop    %esi
80103f9b:	5d                   	pop    %ebp
80103f9c:	c3                   	ret    
    panic("sched ptable.lock");
80103f9d:	83 ec 0c             	sub    $0xc,%esp
80103fa0:	68 5b 7e 10 80       	push   $0x80107e5b
80103fa5:	e8 d6 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 87 7e 10 80       	push   $0x80107e87
80103fb2:	e8 c9 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103fb7:	83 ec 0c             	sub    $0xc,%esp
80103fba:	68 79 7e 10 80       	push   $0x80107e79
80103fbf:	e8 bc c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fc4:	83 ec 0c             	sub    $0xc,%esp
80103fc7:	68 6d 7e 10 80       	push   $0x80107e6d
80103fcc:	e8 af c3 ff ff       	call   80100380 <panic>
80103fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <exit>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fe9:	e8 42 fb ff ff       	call   80103b30 <myproc>
  if(curproc == initproc)
80103fee:	39 05 b4 4d 11 80    	cmp    %eax,0x80114db4
80103ff4:	0f 84 fd 00 00 00    	je     801040f7 <exit+0x117>
80103ffa:	89 c3                	mov    %eax,%ebx
80103ffc:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fff:	8d 78 6c             	lea    0x6c(%eax),%edi
80104002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104008:	8b 06                	mov    (%esi),%eax
8010400a:	85 c0                	test   %eax,%eax
8010400c:	74 12                	je     80104020 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010400e:	83 ec 0c             	sub    $0xc,%esp
80104011:	50                   	push   %eax
80104012:	e8 d9 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104017:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010401d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104020:	83 c6 04             	add    $0x4,%esi
80104023:	39 f7                	cmp    %esi,%edi
80104025:	75 e1                	jne    80104008 <exit+0x28>
  begin_op();
80104027:	e8 e4 ee ff ff       	call   80102f10 <begin_op>
  iput(curproc->cwd);
8010402c:	83 ec 0c             	sub    $0xc,%esp
8010402f:	ff 73 6c             	push   0x6c(%ebx)
80104032:	e8 79 d8 ff ff       	call   801018b0 <iput>
  end_op();
80104037:	e8 44 ef ff ff       	call   80102f80 <end_op>
  curproc->cwd = 0;
8010403c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104043:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010404a:	e8 a1 07 00 00       	call   801047f0 <acquire>
  wakeup1(curproc->parent);
8010404f:	8b 53 18             	mov    0x18(%ebx),%edx
80104052:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104055:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010405a:	eb 0e                	jmp    8010406a <exit+0x8a>
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104060:	83 e8 80             	sub    $0xffffff80,%eax
80104063:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104068:	74 1c                	je     80104086 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010406a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010406e:	75 f0                	jne    80104060 <exit+0x80>
80104070:	3b 50 24             	cmp    0x24(%eax),%edx
80104073:	75 eb                	jne    80104060 <exit+0x80>
      p->state = RUNNABLE;
80104075:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	83 e8 80             	sub    $0xffffff80,%eax
8010407f:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104084:	75 e4                	jne    8010406a <exit+0x8a>
      p->parent = initproc;
80104086:	8b 0d b4 4d 11 80    	mov    0x80114db4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408c:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
80104091:	eb 10                	jmp    801040a3 <exit+0xc3>
80104093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104097:	90                   	nop
80104098:	83 ea 80             	sub    $0xffffff80,%edx
8010409b:	81 fa b4 4d 11 80    	cmp    $0x80114db4,%edx
801040a1:	74 3b                	je     801040de <exit+0xfe>
    if(p->parent == curproc){
801040a3:	39 5a 18             	cmp    %ebx,0x18(%edx)
801040a6:	75 f0                	jne    80104098 <exit+0xb8>
      if(p->state == ZOMBIE)
801040a8:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
801040ac:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
801040af:	75 e7                	jne    80104098 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b1:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801040b6:	eb 12                	jmp    801040ca <exit+0xea>
801040b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bf:	90                   	nop
801040c0:	83 e8 80             	sub    $0xffffff80,%eax
801040c3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801040c8:	74 ce                	je     80104098 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040ca:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040ce:	75 f0                	jne    801040c0 <exit+0xe0>
801040d0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040d3:	75 eb                	jne    801040c0 <exit+0xe0>
      p->state = RUNNABLE;
801040d5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040dc:	eb e2                	jmp    801040c0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040de:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040e5:	e8 36 fe ff ff       	call   80103f20 <sched>
  panic("zombie exit");
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 a8 7e 10 80       	push   $0x80107ea8
801040f2:	e8 89 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040f7:	83 ec 0c             	sub    $0xc,%esp
801040fa:	68 9b 7e 10 80       	push   $0x80107e9b
801040ff:	e8 7c c2 ff ff       	call   80100380 <panic>
80104104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010410f:	90                   	nop

80104110 <wait>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
  pushcli();
80104115:	e8 86 05 00 00       	call   801046a0 <pushcli>
  c = mycpu();
8010411a:	e8 91 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010411f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104125:	e8 c6 05 00 00       	call   801046f0 <popcli>
  acquire(&ptable.lock);
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 80 2d 11 80       	push   $0x80112d80
80104132:	e8 b9 06 00 00       	call   801047f0 <acquire>
80104137:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010413a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80104141:	eb 10                	jmp    80104153 <wait+0x43>
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
80104148:	83 eb 80             	sub    $0xffffff80,%ebx
8010414b:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80104151:	74 1b                	je     8010416e <wait+0x5e>
      if(p->parent != curproc)
80104153:	39 73 18             	cmp    %esi,0x18(%ebx)
80104156:	75 f0                	jne    80104148 <wait+0x38>
      if(p->state == ZOMBIE){
80104158:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010415c:	74 62                	je     801041c0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104161:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104166:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
8010416c:	75 e5                	jne    80104153 <wait+0x43>
    if(!havekids || curproc->killed){
8010416e:	85 c0                	test   %eax,%eax
80104170:	0f 84 a0 00 00 00    	je     80104216 <wait+0x106>
80104176:	8b 46 28             	mov    0x28(%esi),%eax
80104179:	85 c0                	test   %eax,%eax
8010417b:	0f 85 95 00 00 00    	jne    80104216 <wait+0x106>
  pushcli();
80104181:	e8 1a 05 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80104186:	e8 25 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010418b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104191:	e8 5a 05 00 00       	call   801046f0 <popcli>
  if(p == 0)
80104196:	85 db                	test   %ebx,%ebx
80104198:	0f 84 8f 00 00 00    	je     8010422d <wait+0x11d>
  p->chan = chan;
8010419e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801041a1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801041a8:	e8 73 fd ff ff       	call   80103f20 <sched>
  p->chan = 0;
801041ad:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801041b4:	eb 84                	jmp    8010413a <wait+0x2a>
801041b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041c3:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041c6:	ff 73 0c             	push   0xc(%ebx)
801041c9:	e8 f2 e2 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801041ce:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801041d5:	5a                   	pop    %edx
801041d6:	ff 73 08             	push   0x8(%ebx)
801041d9:	e8 02 32 00 00       	call   801073e0 <freevm>
        p->pid = 0;
801041de:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041e5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041ec:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041f0:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041f7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041fe:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80104205:	e8 86 05 00 00       	call   80104790 <release>
        return pid;
8010420a:	83 c4 10             	add    $0x10,%esp
}
8010420d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104210:	89 f0                	mov    %esi,%eax
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret    
      release(&ptable.lock);
80104216:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104219:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010421e:	68 80 2d 11 80       	push   $0x80112d80
80104223:	e8 68 05 00 00       	call   80104790 <release>
      return -1;
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	eb e0                	jmp    8010420d <wait+0xfd>
    panic("sleep");
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	68 b4 7e 10 80       	push   $0x80107eb4
80104235:	e8 46 c1 ff ff       	call   80100380 <panic>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <yield>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104247:	68 80 2d 11 80       	push   $0x80112d80
8010424c:	e8 9f 05 00 00       	call   801047f0 <acquire>
  pushcli();
80104251:	e8 4a 04 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80104256:	e8 55 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010425b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104261:	e8 8a 04 00 00       	call   801046f0 <popcli>
  myproc()->state = RUNNABLE;
80104266:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010426d:	e8 ae fc ff ff       	call   80103f20 <sched>
  release(&ptable.lock);
80104272:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80104279:	e8 12 05 00 00       	call   80104790 <release>
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	83 c4 10             	add    $0x10,%esp
80104284:	c9                   	leave  
80104285:	c3                   	ret    
80104286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428d:	8d 76 00             	lea    0x0(%esi),%esi

80104290 <sleep>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	8b 7d 08             	mov    0x8(%ebp),%edi
8010429c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010429f:	e8 fc 03 00 00       	call   801046a0 <pushcli>
  c = mycpu();
801042a4:	e8 07 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801042a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042af:	e8 3c 04 00 00       	call   801046f0 <popcli>
  if(p == 0)
801042b4:	85 db                	test   %ebx,%ebx
801042b6:	0f 84 87 00 00 00    	je     80104343 <sleep+0xb3>
  if(lk == 0)
801042bc:	85 f6                	test   %esi,%esi
801042be:	74 76                	je     80104336 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042c0:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
801042c6:	74 50                	je     80104318 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 80 2d 11 80       	push   $0x80112d80
801042d0:	e8 1b 05 00 00       	call   801047f0 <acquire>
    release(lk);
801042d5:	89 34 24             	mov    %esi,(%esp)
801042d8:	e8 b3 04 00 00       	call   80104790 <release>
  p->chan = chan;
801042dd:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042e0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042e7:	e8 34 fc ff ff       	call   80103f20 <sched>
  p->chan = 0;
801042ec:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801042f3:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801042fa:	e8 91 04 00 00       	call   80104790 <release>
    acquire(lk);
801042ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104302:	83 c4 10             	add    $0x10,%esp
}
80104305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5f                   	pop    %edi
8010430b:	5d                   	pop    %ebp
    acquire(lk);
8010430c:	e9 df 04 00 00       	jmp    801047f0 <acquire>
80104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104318:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010431b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104322:	e8 f9 fb ff ff       	call   80103f20 <sched>
  p->chan = 0;
80104327:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010432e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104331:	5b                   	pop    %ebx
80104332:	5e                   	pop    %esi
80104333:	5f                   	pop    %edi
80104334:	5d                   	pop    %ebp
80104335:	c3                   	ret    
    panic("sleep without lk");
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	68 ba 7e 10 80       	push   $0x80107eba
8010433e:	e8 3d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	68 b4 7e 10 80       	push   $0x80107eb4
8010434b:	e8 30 c0 ff ff       	call   80100380 <panic>

80104350 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010435a:	68 80 2d 11 80       	push   $0x80112d80
8010435f:	e8 8c 04 00 00       	call   801047f0 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104367:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010436c:	eb 0c                	jmp    8010437a <wakeup+0x2a>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	83 e8 80             	sub    $0xffffff80,%eax
80104373:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104378:	74 1c                	je     80104396 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010437a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010437e:	75 f0                	jne    80104370 <wakeup+0x20>
80104380:	3b 58 24             	cmp    0x24(%eax),%ebx
80104383:	75 eb                	jne    80104370 <wakeup+0x20>
      p->state = RUNNABLE;
80104385:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438c:	83 e8 80             	sub    $0xffffff80,%eax
8010438f:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104394:	75 e4                	jne    8010437a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104396:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a0:	c9                   	leave  
  release(&ptable.lock);
801043a1:	e9 ea 03 00 00       	jmp    80104790 <release>
801043a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ba:	68 80 2d 11 80       	push   $0x80112d80
801043bf:	e8 2c 04 00 00       	call   801047f0 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c7:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801043cc:	eb 0c                	jmp    801043da <kill+0x2a>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	83 e8 80             	sub    $0xffffff80,%eax
801043d3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801043d8:	74 36                	je     80104410 <kill+0x60>
    if(p->pid == pid){
801043da:	39 58 14             	cmp    %ebx,0x14(%eax)
801043dd:	75 f1                	jne    801043d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043df:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043e3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043ea:	75 07                	jne    801043f3 <kill+0x43>
        p->state = RUNNABLE;
801043ec:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 80 2d 11 80       	push   $0x80112d80
801043fb:	e8 90 03 00 00       	call   80104790 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104403:	83 c4 10             	add    $0x10,%esp
80104406:	31 c0                	xor    %eax,%eax
}
80104408:	c9                   	leave  
80104409:	c3                   	ret    
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 80 2d 11 80       	push   $0x80112d80
80104418:	e8 73 03 00 00       	call   80104790 <release>
}
8010441d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104420:	83 c4 10             	add    $0x10,%esp
80104423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104428:	c9                   	leave  
80104429:	c3                   	ret    
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104438:	53                   	push   %ebx
80104439:	bb 24 2e 11 80       	mov    $0x80112e24,%ebx
8010443e:	83 ec 3c             	sub    $0x3c,%esp
80104441:	eb 24                	jmp    80104467 <procdump+0x37>
80104443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104447:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	68 37 83 10 80       	push   $0x80108337
80104450:	e8 4b c2 ff ff       	call   801006a0 <cprintf>
80104455:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	83 eb 80             	sub    $0xffffff80,%ebx
8010445b:	81 fb 24 4e 11 80    	cmp    $0x80114e24,%ebx
80104461:	0f 84 81 00 00 00    	je     801044e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104467:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010446a:	85 c0                	test   %eax,%eax
8010446c:	74 ea                	je     80104458 <procdump+0x28>
      state = "???";
8010446e:	ba cb 7e 10 80       	mov    $0x80107ecb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104473:	83 f8 05             	cmp    $0x5,%eax
80104476:	77 11                	ja     80104489 <procdump+0x59>
80104478:	8b 14 85 2c 7f 10 80 	mov    -0x7fef80d4(,%eax,4),%edx
      state = "???";
8010447f:	b8 cb 7e 10 80       	mov    $0x80107ecb,%eax
80104484:	85 d2                	test   %edx,%edx
80104486:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104489:	53                   	push   %ebx
8010448a:	52                   	push   %edx
8010448b:	ff 73 a4             	push   -0x5c(%ebx)
8010448e:	68 cf 7e 10 80       	push   $0x80107ecf
80104493:	e8 08 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010449f:	75 a7                	jne    80104448 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044a1:	83 ec 08             	sub    $0x8,%esp
801044a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044aa:	50                   	push   %eax
801044ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044ae:	8b 40 0c             	mov    0xc(%eax),%eax
801044b1:	83 c0 08             	add    $0x8,%eax
801044b4:	50                   	push   %eax
801044b5:	e8 86 01 00 00       	call   80104640 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044ba:	83 c4 10             	add    $0x10,%esp
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
801044c0:	8b 17                	mov    (%edi),%edx
801044c2:	85 d2                	test   %edx,%edx
801044c4:	74 82                	je     80104448 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044cc:	52                   	push   %edx
801044cd:	68 01 79 10 80       	push   $0x80107901
801044d2:	e8 c9 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044d7:	83 c4 10             	add    $0x10,%esp
801044da:	39 fe                	cmp    %edi,%esi
801044dc:	75 e2                	jne    801044c0 <procdump+0x90>
801044de:	e9 65 ff ff ff       	jmp    80104448 <procdump+0x18>
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
  }
}
801044e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044eb:	5b                   	pop    %ebx
801044ec:	5e                   	pop    %esi
801044ed:	5f                   	pop    %edi
801044ee:	5d                   	pop    %ebp
801044ef:	c3                   	ret    

801044f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044fa:	68 44 7f 10 80       	push   $0x80107f44
801044ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104502:	50                   	push   %eax
80104503:	e8 18 01 00 00       	call   80104620 <initlock>
  lk->name = name;
80104508:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010450b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104511:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104514:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010451b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010451e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104521:	c9                   	leave  
80104522:	c3                   	ret    
80104523:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104538:	8d 73 04             	lea    0x4(%ebx),%esi
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	56                   	push   %esi
8010453f:	e8 ac 02 00 00       	call   801047f0 <acquire>
  while (lk->locked) {
80104544:	8b 13                	mov    (%ebx),%edx
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	85 d2                	test   %edx,%edx
8010454b:	74 16                	je     80104563 <acquiresleep+0x33>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104550:	83 ec 08             	sub    $0x8,%esp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	e8 36 fd ff ff       	call   80104290 <sleep>
  while (lk->locked) {
8010455a:	8b 03                	mov    (%ebx),%eax
8010455c:	83 c4 10             	add    $0x10,%esp
8010455f:	85 c0                	test   %eax,%eax
80104561:	75 ed                	jne    80104550 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104563:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104569:	e8 c2 f5 ff ff       	call   80103b30 <myproc>
8010456e:	8b 40 14             	mov    0x14(%eax),%eax
80104571:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104574:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104577:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010457a:	5b                   	pop    %ebx
8010457b:	5e                   	pop    %esi
8010457c:	5d                   	pop    %ebp
  release(&lk->lk);
8010457d:	e9 0e 02 00 00       	jmp    80104790 <release>
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104590 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	8d 73 04             	lea    0x4(%ebx),%esi
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	56                   	push   %esi
8010459f:	e8 4c 02 00 00       	call   801047f0 <acquire>
  lk->locked = 0;
801045a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045b1:	89 1c 24             	mov    %ebx,(%esp)
801045b4:	e8 97 fd ff ff       	call   80104350 <wakeup>
  release(&lk->lk);
801045b9:	89 75 08             	mov    %esi,0x8(%ebp)
801045bc:	83 c4 10             	add    $0x10,%esp
}
801045bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c2:	5b                   	pop    %ebx
801045c3:	5e                   	pop    %esi
801045c4:	5d                   	pop    %ebp
  release(&lk->lk);
801045c5:	e9 c6 01 00 00       	jmp    80104790 <release>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	31 ff                	xor    %edi,%edi
801045d6:	56                   	push   %esi
801045d7:	53                   	push   %ebx
801045d8:	83 ec 18             	sub    $0x18,%esp
801045db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045de:	8d 73 04             	lea    0x4(%ebx),%esi
801045e1:	56                   	push   %esi
801045e2:	e8 09 02 00 00       	call   801047f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045e7:	8b 03                	mov    (%ebx),%eax
801045e9:	83 c4 10             	add    $0x10,%esp
801045ec:	85 c0                	test   %eax,%eax
801045ee:	75 18                	jne    80104608 <holdingsleep+0x38>
  release(&lk->lk);
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	56                   	push   %esi
801045f4:	e8 97 01 00 00       	call   80104790 <release>
  return r;
}
801045f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fc:	89 f8                	mov    %edi,%eax
801045fe:	5b                   	pop    %ebx
801045ff:	5e                   	pop    %esi
80104600:	5f                   	pop    %edi
80104601:	5d                   	pop    %ebp
80104602:	c3                   	ret    
80104603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104607:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104608:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010460b:	e8 20 f5 ff ff       	call   80103b30 <myproc>
80104610:	39 58 14             	cmp    %ebx,0x14(%eax)
80104613:	0f 94 c0             	sete   %al
80104616:	0f b6 c0             	movzbl %al,%eax
80104619:	89 c7                	mov    %eax,%edi
8010461b:	eb d3                	jmp    801045f0 <holdingsleep+0x20>
8010461d:	66 90                	xchg   %ax,%ax
8010461f:	90                   	nop

80104620 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104626:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010462f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104632:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010463f:	90                   	nop

80104640 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104640:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104641:	31 d2                	xor    %edx,%edx
{
80104643:	89 e5                	mov    %esp,%ebp
80104645:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104646:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010464c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010464f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104650:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104656:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010465c:	77 1a                	ja     80104678 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010465e:	8b 58 04             	mov    0x4(%eax),%ebx
80104661:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104664:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104667:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104669:	83 fa 0a             	cmp    $0xa,%edx
8010466c:	75 e2                	jne    80104650 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010466e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104671:	c9                   	leave  
80104672:	c3                   	ret    
80104673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104677:	90                   	nop
  for(; i < 10; i++)
80104678:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010467b:	8d 51 28             	lea    0x28(%ecx),%edx
8010467e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104686:	83 c0 04             	add    $0x4,%eax
80104689:	39 d0                	cmp    %edx,%eax
8010468b:	75 f3                	jne    80104680 <getcallerpcs+0x40>
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104690:	c9                   	leave  
80104691:	c3                   	ret    
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 04             	sub    $0x4,%esp
801046a7:	9c                   	pushf  
801046a8:	5b                   	pop    %ebx
  asm volatile("cli");
801046a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046aa:	e8 01 f4 ff ff       	call   80103ab0 <mycpu>
801046af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046b5:	85 c0                	test   %eax,%eax
801046b7:	74 17                	je     801046d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046b9:	e8 f2 f3 ff ff       	call   80103ab0 <mycpu>
801046be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c8:	c9                   	leave  
801046c9:	c3                   	ret    
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046d0:	e8 db f3 ff ff       	call   80103ab0 <mycpu>
801046d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046e1:	eb d6                	jmp    801046b9 <pushcli+0x19>
801046e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046f0 <popcli>:

void
popcli(void)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046f6:	9c                   	pushf  
801046f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046f8:	f6 c4 02             	test   $0x2,%ah
801046fb:	75 35                	jne    80104732 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046fd:	e8 ae f3 ff ff       	call   80103ab0 <mycpu>
80104702:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104709:	78 34                	js     8010473f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010470b:	e8 a0 f3 ff ff       	call   80103ab0 <mycpu>
80104710:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104716:	85 d2                	test   %edx,%edx
80104718:	74 06                	je     80104720 <popcli+0x30>
    sti();
}
8010471a:	c9                   	leave  
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104720:	e8 8b f3 ff ff       	call   80103ab0 <mycpu>
80104725:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010472b:	85 c0                	test   %eax,%eax
8010472d:	74 eb                	je     8010471a <popcli+0x2a>
  asm volatile("sti");
8010472f:	fb                   	sti    
}
80104730:	c9                   	leave  
80104731:	c3                   	ret    
    panic("popcli - interruptible");
80104732:	83 ec 0c             	sub    $0xc,%esp
80104735:	68 4f 7f 10 80       	push   $0x80107f4f
8010473a:	e8 41 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010473f:	83 ec 0c             	sub    $0xc,%esp
80104742:	68 66 7f 10 80       	push   $0x80107f66
80104747:	e8 34 bc ff ff       	call   80100380 <panic>
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <holding>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 75 08             	mov    0x8(%ebp),%esi
80104758:	31 db                	xor    %ebx,%ebx
  pushcli();
8010475a:	e8 41 ff ff ff       	call   801046a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010475f:	8b 06                	mov    (%esi),%eax
80104761:	85 c0                	test   %eax,%eax
80104763:	75 0b                	jne    80104770 <holding+0x20>
  popcli();
80104765:	e8 86 ff ff ff       	call   801046f0 <popcli>
}
8010476a:	89 d8                	mov    %ebx,%eax
8010476c:	5b                   	pop    %ebx
8010476d:	5e                   	pop    %esi
8010476e:	5d                   	pop    %ebp
8010476f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104770:	8b 5e 08             	mov    0x8(%esi),%ebx
80104773:	e8 38 f3 ff ff       	call   80103ab0 <mycpu>
80104778:	39 c3                	cmp    %eax,%ebx
8010477a:	0f 94 c3             	sete   %bl
  popcli();
8010477d:	e8 6e ff ff ff       	call   801046f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104782:	0f b6 db             	movzbl %bl,%ebx
}
80104785:	89 d8                	mov    %ebx,%eax
80104787:	5b                   	pop    %ebx
80104788:	5e                   	pop    %esi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <release>:
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104798:	e8 03 ff ff ff       	call   801046a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010479d:	8b 03                	mov    (%ebx),%eax
8010479f:	85 c0                	test   %eax,%eax
801047a1:	75 15                	jne    801047b8 <release+0x28>
  popcli();
801047a3:	e8 48 ff ff ff       	call   801046f0 <popcli>
    panic("release");
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 6d 7f 10 80       	push   $0x80107f6d
801047b0:	e8 cb bb ff ff       	call   80100380 <panic>
801047b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047b8:	8b 73 08             	mov    0x8(%ebx),%esi
801047bb:	e8 f0 f2 ff ff       	call   80103ab0 <mycpu>
801047c0:	39 c6                	cmp    %eax,%esi
801047c2:	75 df                	jne    801047a3 <release+0x13>
  popcli();
801047c4:	e8 27 ff ff ff       	call   801046f0 <popcli>
  lk->pcs[0] = 0;
801047c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e5:	5b                   	pop    %ebx
801047e6:	5e                   	pop    %esi
801047e7:	5d                   	pop    %ebp
  popcli();
801047e8:	e9 03 ff ff ff       	jmp    801046f0 <popcli>
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <acquire>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047f7:	e8 a4 fe ff ff       	call   801046a0 <pushcli>
  if(holding(lk))
801047fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047ff:	e8 9c fe ff ff       	call   801046a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104804:	8b 03                	mov    (%ebx),%eax
80104806:	85 c0                	test   %eax,%eax
80104808:	75 7e                	jne    80104888 <acquire+0x98>
  popcli();
8010480a:	e8 e1 fe ff ff       	call   801046f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010480f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104818:	8b 55 08             	mov    0x8(%ebp),%edx
8010481b:	89 c8                	mov    %ecx,%eax
8010481d:	f0 87 02             	lock xchg %eax,(%edx)
80104820:	85 c0                	test   %eax,%eax
80104822:	75 f4                	jne    80104818 <acquire+0x28>
  __sync_synchronize();
80104824:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104829:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010482c:	e8 7f f2 ff ff       	call   80103ab0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104831:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104834:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104836:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104839:	31 c0                	xor    %eax,%eax
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104840:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104846:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010484c:	77 1a                	ja     80104868 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010484e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104851:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104855:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104858:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010485a:	83 f8 0a             	cmp    $0xa,%eax
8010485d:	75 e1                	jne    80104840 <acquire+0x50>
}
8010485f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104862:	c9                   	leave  
80104863:	c3                   	ret    
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104868:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010486c:	8d 51 34             	lea    0x34(%ecx),%edx
8010486f:	90                   	nop
    pcs[i] = 0;
80104870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104876:	83 c0 04             	add    $0x4,%eax
80104879:	39 c2                	cmp    %eax,%edx
8010487b:	75 f3                	jne    80104870 <acquire+0x80>
}
8010487d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104880:	c9                   	leave  
80104881:	c3                   	ret    
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104888:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010488b:	e8 20 f2 ff ff       	call   80103ab0 <mycpu>
80104890:	39 c3                	cmp    %eax,%ebx
80104892:	0f 85 72 ff ff ff    	jne    8010480a <acquire+0x1a>
  popcli();
80104898:	e8 53 fe ff ff       	call   801046f0 <popcli>
    panic("acquire");
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	68 75 7f 10 80       	push   $0x80107f75
801048a5:	e8 d6 ba ff ff       	call   80100380 <panic>
801048aa:	66 90                	xchg   %ax,%ax
801048ac:	66 90                	xchg   %ax,%ax
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ba:	53                   	push   %ebx
801048bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801048be:	89 d7                	mov    %edx,%edi
801048c0:	09 cf                	or     %ecx,%edi
801048c2:	83 e7 03             	and    $0x3,%edi
801048c5:	75 29                	jne    801048f0 <memset+0x40>
    c &= 0xFF;
801048c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048ca:	c1 e0 18             	shl    $0x18,%eax
801048cd:	89 fb                	mov    %edi,%ebx
801048cf:	c1 e9 02             	shr    $0x2,%ecx
801048d2:	c1 e3 10             	shl    $0x10,%ebx
801048d5:	09 d8                	or     %ebx,%eax
801048d7:	09 f8                	or     %edi,%eax
801048d9:	c1 e7 08             	shl    $0x8,%edi
801048dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048de:	89 d7                	mov    %edx,%edi
801048e0:	fc                   	cld    
801048e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048e3:	5b                   	pop    %ebx
801048e4:	89 d0                	mov    %edx,%eax
801048e6:	5f                   	pop    %edi
801048e7:	5d                   	pop    %ebp
801048e8:	c3                   	ret    
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048f0:	89 d7                	mov    %edx,%edi
801048f2:	fc                   	cld    
801048f3:	f3 aa                	rep stos %al,%es:(%edi)
801048f5:	5b                   	pop    %ebx
801048f6:	89 d0                	mov    %edx,%eax
801048f8:	5f                   	pop    %edi
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret    
801048fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ff:	90                   	nop

80104900 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	8b 75 10             	mov    0x10(%ebp),%esi
80104907:	8b 55 08             	mov    0x8(%ebp),%edx
8010490a:	53                   	push   %ebx
8010490b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010490e:	85 f6                	test   %esi,%esi
80104910:	74 2e                	je     80104940 <memcmp+0x40>
80104912:	01 c6                	add    %eax,%esi
80104914:	eb 14                	jmp    8010492a <memcmp+0x2a>
80104916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104920:	83 c0 01             	add    $0x1,%eax
80104923:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104926:	39 f0                	cmp    %esi,%eax
80104928:	74 16                	je     80104940 <memcmp+0x40>
    if(*s1 != *s2)
8010492a:	0f b6 0a             	movzbl (%edx),%ecx
8010492d:	0f b6 18             	movzbl (%eax),%ebx
80104930:	38 d9                	cmp    %bl,%cl
80104932:	74 ec                	je     80104920 <memcmp+0x20>
      return *s1 - *s2;
80104934:	0f b6 c1             	movzbl %cl,%eax
80104937:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104939:	5b                   	pop    %ebx
8010493a:	5e                   	pop    %esi
8010493b:	5d                   	pop    %ebp
8010493c:	c3                   	ret    
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
80104940:	5b                   	pop    %ebx
  return 0;
80104941:	31 c0                	xor    %eax,%eax
}
80104943:	5e                   	pop    %esi
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret    
80104946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494d:	8d 76 00             	lea    0x0(%esi),%esi

80104950 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	8b 55 08             	mov    0x8(%ebp),%edx
80104957:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010495a:	56                   	push   %esi
8010495b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010495e:	39 d6                	cmp    %edx,%esi
80104960:	73 26                	jae    80104988 <memmove+0x38>
80104962:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104965:	39 fa                	cmp    %edi,%edx
80104967:	73 1f                	jae    80104988 <memmove+0x38>
80104969:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010496c:	85 c9                	test   %ecx,%ecx
8010496e:	74 0c                	je     8010497c <memmove+0x2c>
      *--d = *--s;
80104970:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104974:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104977:	83 e8 01             	sub    $0x1,%eax
8010497a:	73 f4                	jae    80104970 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010497c:	5e                   	pop    %esi
8010497d:	89 d0                	mov    %edx,%eax
8010497f:	5f                   	pop    %edi
80104980:	5d                   	pop    %ebp
80104981:	c3                   	ret    
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104988:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010498b:	89 d7                	mov    %edx,%edi
8010498d:	85 c9                	test   %ecx,%ecx
8010498f:	74 eb                	je     8010497c <memmove+0x2c>
80104991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104998:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104999:	39 c6                	cmp    %eax,%esi
8010499b:	75 fb                	jne    80104998 <memmove+0x48>
}
8010499d:	5e                   	pop    %esi
8010499e:	89 d0                	mov    %edx,%eax
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049b0:	eb 9e                	jmp    80104950 <memmove>
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	8b 75 10             	mov    0x10(%ebp),%esi
801049c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049ca:	53                   	push   %ebx
801049cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801049ce:	85 f6                	test   %esi,%esi
801049d0:	74 2e                	je     80104a00 <strncmp+0x40>
801049d2:	01 d6                	add    %edx,%esi
801049d4:	eb 18                	jmp    801049ee <strncmp+0x2e>
801049d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	38 d8                	cmp    %bl,%al
801049e2:	75 14                	jne    801049f8 <strncmp+0x38>
    n--, p++, q++;
801049e4:	83 c2 01             	add    $0x1,%edx
801049e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049ea:	39 f2                	cmp    %esi,%edx
801049ec:	74 12                	je     80104a00 <strncmp+0x40>
801049ee:	0f b6 01             	movzbl (%ecx),%eax
801049f1:	0f b6 1a             	movzbl (%edx),%ebx
801049f4:	84 c0                	test   %al,%al
801049f6:	75 e8                	jne    801049e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049f8:	29 d8                	sub    %ebx,%eax
}
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax
80104a00:	5b                   	pop    %ebx
    return 0;
80104a01:	31 c0                	xor    %eax,%eax
}
80104a03:	5e                   	pop    %esi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret    
80104a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	8b 75 08             	mov    0x8(%ebp),%esi
80104a18:	53                   	push   %ebx
80104a19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a1c:	89 f0                	mov    %esi,%eax
80104a1e:	eb 15                	jmp    80104a35 <strncpy+0x25>
80104a20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a24:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a27:	83 c0 01             	add    $0x1,%eax
80104a2a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a2e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a31:	84 d2                	test   %dl,%dl
80104a33:	74 09                	je     80104a3e <strncpy+0x2e>
80104a35:	89 cb                	mov    %ecx,%ebx
80104a37:	83 e9 01             	sub    $0x1,%ecx
80104a3a:	85 db                	test   %ebx,%ebx
80104a3c:	7f e2                	jg     80104a20 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a3e:	89 c2                	mov    %eax,%edx
80104a40:	85 c9                	test   %ecx,%ecx
80104a42:	7e 17                	jle    80104a5b <strncpy+0x4b>
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a48:	83 c2 01             	add    $0x1,%edx
80104a4b:	89 c1                	mov    %eax,%ecx
80104a4d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104a51:	29 d1                	sub    %edx,%ecx
80104a53:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a57:	85 c9                	test   %ecx,%ecx
80104a59:	7f ed                	jg     80104a48 <strncpy+0x38>
  return os;
}
80104a5b:	5b                   	pop    %ebx
80104a5c:	89 f0                	mov    %esi,%eax
80104a5e:	5e                   	pop    %esi
80104a5f:	5f                   	pop    %edi
80104a60:	5d                   	pop    %ebp
80104a61:	c3                   	ret    
80104a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	8b 55 10             	mov    0x10(%ebp),%edx
80104a77:	8b 75 08             	mov    0x8(%ebp),%esi
80104a7a:	53                   	push   %ebx
80104a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a7e:	85 d2                	test   %edx,%edx
80104a80:	7e 25                	jle    80104aa7 <safestrcpy+0x37>
80104a82:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a86:	89 f2                	mov    %esi,%edx
80104a88:	eb 16                	jmp    80104aa0 <safestrcpy+0x30>
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a90:	0f b6 08             	movzbl (%eax),%ecx
80104a93:	83 c0 01             	add    $0x1,%eax
80104a96:	83 c2 01             	add    $0x1,%edx
80104a99:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a9c:	84 c9                	test   %cl,%cl
80104a9e:	74 04                	je     80104aa4 <safestrcpy+0x34>
80104aa0:	39 d8                	cmp    %ebx,%eax
80104aa2:	75 ec                	jne    80104a90 <safestrcpy+0x20>
    ;
  *s = 0;
80104aa4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104aa7:	89 f0                	mov    %esi,%eax
80104aa9:	5b                   	pop    %ebx
80104aaa:	5e                   	pop    %esi
80104aab:	5d                   	pop    %ebp
80104aac:	c3                   	ret    
80104aad:	8d 76 00             	lea    0x0(%esi),%esi

80104ab0 <strlen>:

int
strlen(const char *s)
{
80104ab0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ab1:	31 c0                	xor    %eax,%eax
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ab8:	80 3a 00             	cmpb   $0x0,(%edx)
80104abb:	74 0c                	je     80104ac9 <strlen+0x19>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ac7:	75 f7                	jne    80104ac0 <strlen+0x10>
    ;
  return n;
}
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret    

80104acb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104acb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104acf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ad3:	55                   	push   %ebp
  pushl %ebx
80104ad4:	53                   	push   %ebx
  pushl %esi
80104ad5:	56                   	push   %esi
  pushl %edi
80104ad6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ad7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ad9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104adb:	5f                   	pop    %edi
  popl %esi
80104adc:	5e                   	pop    %esi
  popl %ebx
80104add:	5b                   	pop    %ebx
  popl %ebp
80104ade:	5d                   	pop    %ebp
  ret
80104adf:	c3                   	ret    

80104ae0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aea:	e8 41 f0 ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aef:	8b 00                	mov    (%eax),%eax
80104af1:	39 d8                	cmp    %ebx,%eax
80104af3:	76 1b                	jbe    80104b10 <fetchint+0x30>
80104af5:	8d 53 04             	lea    0x4(%ebx),%edx
80104af8:	39 d0                	cmp    %edx,%eax
80104afa:	72 14                	jb     80104b10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aff:	8b 13                	mov    (%ebx),%edx
80104b01:	89 10                	mov    %edx,(%eax)
  return 0;
80104b03:	31 c0                	xor    %eax,%eax
}
80104b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ee                	jmp    80104b05 <fetchint+0x25>
80104b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
80104b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b2a:	e8 01 f0 ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz)
80104b2f:	39 18                	cmp    %ebx,(%eax)
80104b31:	76 2d                	jbe    80104b60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b3a:	39 d3                	cmp    %edx,%ebx
80104b3c:	73 22                	jae    80104b60 <fetchstr+0x40>
80104b3e:	89 d8                	mov    %ebx,%eax
80104b40:	eb 0d                	jmp    80104b4f <fetchstr+0x2f>
80104b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b48:	83 c0 01             	add    $0x1,%eax
80104b4b:	39 c2                	cmp    %eax,%edx
80104b4d:	76 11                	jbe    80104b60 <fetchstr+0x40>
    if(*s == 0)
80104b4f:	80 38 00             	cmpb   $0x0,(%eax)
80104b52:	75 f4                	jne    80104b48 <fetchstr+0x28>
      return s - *pp;
80104b54:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b59:	c9                   	leave  
80104b5a:	c3                   	ret    
80104b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop
80104b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b68:	c9                   	leave  
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	e8 b6 ef ff ff       	call   80103b30 <myproc>
80104b7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b7d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b80:	8b 40 44             	mov    0x44(%eax),%eax
80104b83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b86:	e8 a5 ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8e:	8b 00                	mov    (%eax),%eax
80104b90:	39 c6                	cmp    %eax,%esi
80104b92:	73 1c                	jae    80104bb0 <argint+0x40>
80104b94:	8d 53 08             	lea    0x8(%ebx),%edx
80104b97:	39 d0                	cmp    %edx,%eax
80104b99:	72 15                	jb     80104bb0 <argint+0x40>
  *ip = *(int*)(addr);
80104b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ba1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	5b                   	pop    %ebx
80104ba6:	5e                   	pop    %esi
80104ba7:	5d                   	pop    %ebp
80104ba8:	c3                   	ret    
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb5:	eb ee                	jmp    80104ba5 <argint+0x35>
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
80104bc6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bc9:	e8 62 ef ff ff       	call   80103b30 <myproc>
80104bce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd0:	e8 5b ef ff ff       	call   80103b30 <myproc>
80104bd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bd8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bdb:	8b 40 44             	mov    0x44(%eax),%eax
80104bde:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be1:	e8 4a ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104be9:	8b 00                	mov    (%eax),%eax
80104beb:	39 c7                	cmp    %eax,%edi
80104bed:	73 31                	jae    80104c20 <argptr+0x60>
80104bef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bf2:	39 c8                	cmp    %ecx,%eax
80104bf4:	72 2a                	jb     80104c20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bf6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bf9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bfc:	85 d2                	test   %edx,%edx
80104bfe:	78 20                	js     80104c20 <argptr+0x60>
80104c00:	8b 16                	mov    (%esi),%edx
80104c02:	39 c2                	cmp    %eax,%edx
80104c04:	76 1a                	jbe    80104c20 <argptr+0x60>
80104c06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c09:	01 c3                	add    %eax,%ebx
80104c0b:	39 da                	cmp    %ebx,%edx
80104c0d:	72 11                	jb     80104c20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c12:	89 02                	mov    %eax,(%edx)
  return 0;
80104c14:	31 c0                	xor    %eax,%eax
}
80104c16:	83 c4 0c             	add    $0xc,%esp
80104c19:	5b                   	pop    %ebx
80104c1a:	5e                   	pop    %esi
80104c1b:	5f                   	pop    %edi
80104c1c:	5d                   	pop    %ebp
80104c1d:	c3                   	ret    
80104c1e:	66 90                	xchg   %ax,%ax
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb ef                	jmp    80104c16 <argptr+0x56>
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c35:	e8 f6 ee ff ff       	call   80103b30 <myproc>
80104c3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c3d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c40:	8b 40 44             	mov    0x44(%eax),%eax
80104c43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c46:	e8 e5 ee ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4e:	8b 00                	mov    (%eax),%eax
80104c50:	39 c6                	cmp    %eax,%esi
80104c52:	73 44                	jae    80104c98 <argstr+0x68>
80104c54:	8d 53 08             	lea    0x8(%ebx),%edx
80104c57:	39 d0                	cmp    %edx,%eax
80104c59:	72 3d                	jb     80104c98 <argstr+0x68>
  *ip = *(int*)(addr);
80104c5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c5e:	e8 cd ee ff ff       	call   80103b30 <myproc>
  if(addr >= curproc->sz)
80104c63:	3b 18                	cmp    (%eax),%ebx
80104c65:	73 31                	jae    80104c98 <argstr+0x68>
  *pp = (char*)addr;
80104c67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c6e:	39 d3                	cmp    %edx,%ebx
80104c70:	73 26                	jae    80104c98 <argstr+0x68>
80104c72:	89 d8                	mov    %ebx,%eax
80104c74:	eb 11                	jmp    80104c87 <argstr+0x57>
80104c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	83 c0 01             	add    $0x1,%eax
80104c83:	39 c2                	cmp    %eax,%edx
80104c85:	76 11                	jbe    80104c98 <argstr+0x68>
    if(*s == 0)
80104c87:	80 38 00             	cmpb   $0x0,(%eax)
80104c8a:	75 f4                	jne    80104c80 <argstr+0x50>
      return s - *pp;
80104c8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c8e:	5b                   	pop    %ebx
80104c8f:	5e                   	pop    %esi
80104c90:	5d                   	pop    %ebp
80104c91:	c3                   	ret    
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c98:	5b                   	pop    %ebx
    return -1;
80104c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c9e:	5e                   	pop    %esi
80104c9f:	5d                   	pop    %ebp
80104ca0:	c3                   	ret    
80104ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop

80104cb0 <syscall>:
[SYS_sbrkhuge]  sys_sbrkhuge,
};

void
syscall(void)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104cb7:	e8 74 ee ff ff       	call   80103b30 <myproc>
80104cbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cbe:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cc7:	83 fa 19             	cmp    $0x19,%edx
80104cca:	77 24                	ja     80104cf0 <syscall+0x40>
80104ccc:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
80104cd3:	85 d2                	test   %edx,%edx
80104cd5:	74 19                	je     80104cf0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104cd7:	ff d2                	call   *%edx
80104cd9:	89 c2                	mov    %eax,%edx
80104cdb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cde:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce4:	c9                   	leave  
80104ce5:	c3                   	ret    
80104ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ced:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cf0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cf1:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cf4:	50                   	push   %eax
80104cf5:	ff 73 14             	push   0x14(%ebx)
80104cf8:	68 7d 7f 10 80       	push   $0x80107f7d
80104cfd:	e8 9e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d02:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d05:	83 c4 10             	add    $0x10,%esp
80104d08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d12:	c9                   	leave  
80104d13:	c3                   	ret    
80104d14:	66 90                	xchg   %ax,%ax
80104d16:	66 90                	xchg   %ax,%ax
80104d18:	66 90                	xchg   %ax,%ax
80104d1a:	66 90                	xchg   %ax,%ax
80104d1c:	66 90                	xchg   %ax,%ax
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d28:	53                   	push   %ebx
80104d29:	83 ec 34             	sub    $0x34,%esp
80104d2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d32:	57                   	push   %edi
80104d33:	50                   	push   %eax
{
80104d34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d3a:	e8 81 d3 ff ff       	call   801020c0 <nameiparent>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	85 c0                	test   %eax,%eax
80104d44:	0f 84 46 01 00 00    	je     80104e90 <create+0x170>
    return 0;
  ilock(dp);
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	89 c3                	mov    %eax,%ebx
80104d4f:	50                   	push   %eax
80104d50:	e8 2b ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d55:	83 c4 0c             	add    $0xc,%esp
80104d58:	6a 00                	push   $0x0
80104d5a:	57                   	push   %edi
80104d5b:	53                   	push   %ebx
80104d5c:	e8 7f cf ff ff       	call   80101ce0 <dirlookup>
80104d61:	83 c4 10             	add    $0x10,%esp
80104d64:	89 c6                	mov    %eax,%esi
80104d66:	85 c0                	test   %eax,%eax
80104d68:	74 56                	je     80104dc0 <create+0xa0>
    iunlockput(dp);
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	53                   	push   %ebx
80104d6e:	e8 9d cc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d73:	89 34 24             	mov    %esi,(%esp)
80104d76:	e8 05 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d7b:	83 c4 10             	add    $0x10,%esp
80104d7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d83:	75 1b                	jne    80104da0 <create+0x80>
80104d85:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d8a:	75 14                	jne    80104da0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d8f:	89 f0                	mov    %esi,%eax
80104d91:	5b                   	pop    %ebx
80104d92:	5e                   	pop    %esi
80104d93:	5f                   	pop    %edi
80104d94:	5d                   	pop    %ebp
80104d95:	c3                   	ret    
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	56                   	push   %esi
    return 0;
80104da4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104da6:	e8 65 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104dab:	83 c4 10             	add    $0x10,%esp
}
80104dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db1:	89 f0                	mov    %esi,%eax
80104db3:	5b                   	pop    %ebx
80104db4:	5e                   	pop    %esi
80104db5:	5f                   	pop    %edi
80104db6:	5d                   	pop    %ebp
80104db7:	c3                   	ret    
80104db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104dc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104dc4:	83 ec 08             	sub    $0x8,%esp
80104dc7:	50                   	push   %eax
80104dc8:	ff 33                	push   (%ebx)
80104dca:	e8 41 c8 ff ff       	call   80101610 <ialloc>
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	89 c6                	mov    %eax,%esi
80104dd4:	85 c0                	test   %eax,%eax
80104dd6:	0f 84 cd 00 00 00    	je     80104ea9 <create+0x189>
  ilock(ip);
80104ddc:	83 ec 0c             	sub    $0xc,%esp
80104ddf:	50                   	push   %eax
80104de0:	e8 9b c9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104de5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104de9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ded:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104df1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104df5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dfa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dfe:	89 34 24             	mov    %esi,(%esp)
80104e01:	e8 ca c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e06:	83 c4 10             	add    $0x10,%esp
80104e09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e0e:	74 30                	je     80104e40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e10:	83 ec 04             	sub    $0x4,%esp
80104e13:	ff 76 04             	push   0x4(%esi)
80104e16:	57                   	push   %edi
80104e17:	53                   	push   %ebx
80104e18:	e8 c3 d1 ff ff       	call   80101fe0 <dirlink>
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 78                	js     80104e9c <create+0x17c>
  iunlockput(dp);
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	53                   	push   %ebx
80104e28:	e8 e3 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104e2d:	83 c4 10             	add    $0x10,%esp
}
80104e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e33:	89 f0                	mov    %esi,%eax
80104e35:	5b                   	pop    %ebx
80104e36:	5e                   	pop    %esi
80104e37:	5f                   	pop    %edi
80104e38:	5d                   	pop    %ebp
80104e39:	c3                   	ret    
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e48:	53                   	push   %ebx
80104e49:	e8 82 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e4e:	83 c4 0c             	add    $0xc,%esp
80104e51:	ff 76 04             	push   0x4(%esi)
80104e54:	68 28 80 10 80       	push   $0x80108028
80104e59:	56                   	push   %esi
80104e5a:	e8 81 d1 ff ff       	call   80101fe0 <dirlink>
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	85 c0                	test   %eax,%eax
80104e64:	78 18                	js     80104e7e <create+0x15e>
80104e66:	83 ec 04             	sub    $0x4,%esp
80104e69:	ff 73 04             	push   0x4(%ebx)
80104e6c:	68 27 80 10 80       	push   $0x80108027
80104e71:	56                   	push   %esi
80104e72:	e8 69 d1 ff ff       	call   80101fe0 <dirlink>
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	85 c0                	test   %eax,%eax
80104e7c:	79 92                	jns    80104e10 <create+0xf0>
      panic("create dots");
80104e7e:	83 ec 0c             	sub    $0xc,%esp
80104e81:	68 1b 80 10 80       	push   $0x8010801b
80104e86:	e8 f5 b4 ff ff       	call   80100380 <panic>
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop
}
80104e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e93:	31 f6                	xor    %esi,%esi
}
80104e95:	5b                   	pop    %ebx
80104e96:	89 f0                	mov    %esi,%eax
80104e98:	5e                   	pop    %esi
80104e99:	5f                   	pop    %edi
80104e9a:	5d                   	pop    %ebp
80104e9b:	c3                   	ret    
    panic("create: dirlink");
80104e9c:	83 ec 0c             	sub    $0xc,%esp
80104e9f:	68 2a 80 10 80       	push   $0x8010802a
80104ea4:	e8 d7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ea9:	83 ec 0c             	sub    $0xc,%esp
80104eac:	68 0c 80 10 80       	push   $0x8010800c
80104eb1:	e8 ca b4 ff ff       	call   80100380 <panic>
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <sys_dup>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	50                   	push   %eax
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 9d fc ff ff       	call   80104b70 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 36                	js     80104f10 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 30                	ja     80104f10 <sys_dup+0x50>
80104ee0:	e8 4b ec ff ff       	call   80103b30 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104eec:	85 f6                	test   %esi,%esi
80104eee:	74 20                	je     80104f10 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ef0:	e8 3b ec ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ef5:	31 db                	xor    %ebx,%ebx
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f00:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104f04:	85 d2                	test   %edx,%edx
80104f06:	74 18                	je     80104f20 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f08:	83 c3 01             	add    $0x1,%ebx
80104f0b:	83 fb 10             	cmp    $0x10,%ebx
80104f0e:	75 f0                	jne    80104f00 <sys_dup+0x40>
}
80104f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f18:	89 d8                	mov    %ebx,%eax
80104f1a:	5b                   	pop    %ebx
80104f1b:	5e                   	pop    %esi
80104f1c:	5d                   	pop    %ebp
80104f1d:	c3                   	ret    
80104f1e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f20:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f23:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104f27:	56                   	push   %esi
80104f28:	e8 73 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104f2d:	83 c4 10             	add    $0x10,%esp
}
80104f30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f33:	89 d8                	mov    %ebx,%eax
80104f35:	5b                   	pop    %ebx
80104f36:	5e                   	pop    %esi
80104f37:	5d                   	pop    %ebp
80104f38:	c3                   	ret    
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f40 <sys_read>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 00                	push   $0x0
80104f4e:	e8 1d fc ff ff       	call   80104b70 <argint>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 5e                	js     80104fb8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f5e:	77 58                	ja     80104fb8 <sys_read+0x78>
80104f60:	e8 cb eb ff ff       	call   80103b30 <myproc>
80104f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f68:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104f6c:	85 f6                	test   %esi,%esi
80104f6e:	74 48                	je     80104fb8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f70:	83 ec 08             	sub    $0x8,%esp
80104f73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f76:	50                   	push   %eax
80104f77:	6a 02                	push   $0x2
80104f79:	e8 f2 fb ff ff       	call   80104b70 <argint>
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	85 c0                	test   %eax,%eax
80104f83:	78 33                	js     80104fb8 <sys_read+0x78>
80104f85:	83 ec 04             	sub    $0x4,%esp
80104f88:	ff 75 f0             	push   -0x10(%ebp)
80104f8b:	53                   	push   %ebx
80104f8c:	6a 01                	push   $0x1
80104f8e:	e8 2d fc ff ff       	call   80104bc0 <argptr>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 1e                	js     80104fb8 <sys_read+0x78>
  return fileread(f, p, n);
80104f9a:	83 ec 04             	sub    $0x4,%esp
80104f9d:	ff 75 f0             	push   -0x10(%ebp)
80104fa0:	ff 75 f4             	push   -0xc(%ebp)
80104fa3:	56                   	push   %esi
80104fa4:	e8 77 c0 ff ff       	call   80101020 <fileread>
80104fa9:	83 c4 10             	add    $0x10,%esp
}
80104fac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104faf:	5b                   	pop    %ebx
80104fb0:	5e                   	pop    %esi
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret    
80104fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb7:	90                   	nop
    return -1;
80104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fbd:	eb ed                	jmp    80104fac <sys_read+0x6c>
80104fbf:	90                   	nop

80104fc0 <sys_write>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fc5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fcb:	53                   	push   %ebx
80104fcc:	6a 00                	push   $0x0
80104fce:	e8 9d fb ff ff       	call   80104b70 <argint>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 5e                	js     80105038 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fde:	77 58                	ja     80105038 <sys_write+0x78>
80104fe0:	e8 4b eb ff ff       	call   80103b30 <myproc>
80104fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
80104fec:	85 f6                	test   %esi,%esi
80104fee:	74 48                	je     80105038 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ff0:	83 ec 08             	sub    $0x8,%esp
80104ff3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ff6:	50                   	push   %eax
80104ff7:	6a 02                	push   $0x2
80104ff9:	e8 72 fb ff ff       	call   80104b70 <argint>
80104ffe:	83 c4 10             	add    $0x10,%esp
80105001:	85 c0                	test   %eax,%eax
80105003:	78 33                	js     80105038 <sys_write+0x78>
80105005:	83 ec 04             	sub    $0x4,%esp
80105008:	ff 75 f0             	push   -0x10(%ebp)
8010500b:	53                   	push   %ebx
8010500c:	6a 01                	push   $0x1
8010500e:	e8 ad fb ff ff       	call   80104bc0 <argptr>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 1e                	js     80105038 <sys_write+0x78>
  return filewrite(f, p, n);
8010501a:	83 ec 04             	sub    $0x4,%esp
8010501d:	ff 75 f0             	push   -0x10(%ebp)
80105020:	ff 75 f4             	push   -0xc(%ebp)
80105023:	56                   	push   %esi
80105024:	e8 87 c0 ff ff       	call   801010b0 <filewrite>
80105029:	83 c4 10             	add    $0x10,%esp
}
8010502c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010502f:	5b                   	pop    %ebx
80105030:	5e                   	pop    %esi
80105031:	5d                   	pop    %ebp
80105032:	c3                   	ret    
80105033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105037:	90                   	nop
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	eb ed                	jmp    8010502c <sys_write+0x6c>
8010503f:	90                   	nop

80105040 <sys_close>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105045:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105048:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504b:	50                   	push   %eax
8010504c:	6a 00                	push   $0x0
8010504e:	e8 1d fb ff ff       	call   80104b70 <argint>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 3e                	js     80105098 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505e:	77 38                	ja     80105098 <sys_close+0x58>
80105060:	e8 cb ea ff ff       	call   80103b30 <myproc>
80105065:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105068:	8d 5a 08             	lea    0x8(%edx),%ebx
8010506b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010506f:	85 f6                	test   %esi,%esi
80105071:	74 25                	je     80105098 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105073:	e8 b8 ea ff ff       	call   80103b30 <myproc>
  fileclose(f);
80105078:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010507b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105082:	00 
  fileclose(f);
80105083:	56                   	push   %esi
80105084:	e8 67 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105089:	83 c4 10             	add    $0x10,%esp
8010508c:	31 c0                	xor    %eax,%eax
}
8010508e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105091:	5b                   	pop    %ebx
80105092:	5e                   	pop    %esi
80105093:	5d                   	pop    %ebp
80105094:	c3                   	ret    
80105095:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ef                	jmp    8010508e <sys_close+0x4e>
8010509f:	90                   	nop

801050a0 <sys_fstat>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	53                   	push   %ebx
801050ac:	6a 00                	push   $0x0
801050ae:	e8 bd fa ff ff       	call   80104b70 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 46                	js     80105100 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 40                	ja     80105100 <sys_fstat+0x60>
801050c0:	e8 6b ea ff ff       	call   80103b30 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801050cc:	85 f6                	test   %esi,%esi
801050ce:	74 30                	je     80105100 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050d0:	83 ec 04             	sub    $0x4,%esp
801050d3:	6a 14                	push   $0x14
801050d5:	53                   	push   %ebx
801050d6:	6a 01                	push   $0x1
801050d8:	e8 e3 fa ff ff       	call   80104bc0 <argptr>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	78 1c                	js     80105100 <sys_fstat+0x60>
  return filestat(f, st);
801050e4:	83 ec 08             	sub    $0x8,%esp
801050e7:	ff 75 f4             	push   -0xc(%ebp)
801050ea:	56                   	push   %esi
801050eb:	e8 e0 be ff ff       	call   80100fd0 <filestat>
801050f0:	83 c4 10             	add    $0x10,%esp
}
801050f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f6:	5b                   	pop    %ebx
801050f7:	5e                   	pop    %esi
801050f8:	5d                   	pop    %ebp
801050f9:	c3                   	ret    
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105105:	eb ec                	jmp    801050f3 <sys_fstat+0x53>
80105107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510e:	66 90                	xchg   %ax,%ax

80105110 <sys_link>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105115:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105118:	53                   	push   %ebx
80105119:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010511c:	50                   	push   %eax
8010511d:	6a 00                	push   $0x0
8010511f:	e8 0c fb ff ff       	call   80104c30 <argstr>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
80105129:	0f 88 fb 00 00 00    	js     8010522a <sys_link+0x11a>
8010512f:	83 ec 08             	sub    $0x8,%esp
80105132:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105135:	50                   	push   %eax
80105136:	6a 01                	push   $0x1
80105138:	e8 f3 fa ff ff       	call   80104c30 <argstr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	0f 88 e2 00 00 00    	js     8010522a <sys_link+0x11a>
  begin_op();
80105148:	e8 c3 dd ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
8010514d:	83 ec 0c             	sub    $0xc,%esp
80105150:	ff 75 d4             	push   -0x2c(%ebp)
80105153:	e8 48 cf ff ff       	call   801020a0 <namei>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	89 c3                	mov    %eax,%ebx
8010515d:	85 c0                	test   %eax,%eax
8010515f:	0f 84 e4 00 00 00    	je     80105249 <sys_link+0x139>
  ilock(ip);
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	50                   	push   %eax
80105169:	e8 12 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105176:	0f 84 b5 00 00 00    	je     80105231 <sys_link+0x121>
  iupdate(ip);
8010517c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010517f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105184:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105187:	53                   	push   %ebx
80105188:	e8 43 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010518d:	89 1c 24             	mov    %ebx,(%esp)
80105190:	e8 cb c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105195:	58                   	pop    %eax
80105196:	5a                   	pop    %edx
80105197:	57                   	push   %edi
80105198:	ff 75 d0             	push   -0x30(%ebp)
8010519b:	e8 20 cf ff ff       	call   801020c0 <nameiparent>
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	89 c6                	mov    %eax,%esi
801051a5:	85 c0                	test   %eax,%eax
801051a7:	74 5b                	je     80105204 <sys_link+0xf4>
  ilock(dp);
801051a9:	83 ec 0c             	sub    $0xc,%esp
801051ac:	50                   	push   %eax
801051ad:	e8 ce c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051b2:	8b 03                	mov    (%ebx),%eax
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	39 06                	cmp    %eax,(%esi)
801051b9:	75 3d                	jne    801051f8 <sys_link+0xe8>
801051bb:	83 ec 04             	sub    $0x4,%esp
801051be:	ff 73 04             	push   0x4(%ebx)
801051c1:	57                   	push   %edi
801051c2:	56                   	push   %esi
801051c3:	e8 18 ce ff ff       	call   80101fe0 <dirlink>
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	85 c0                	test   %eax,%eax
801051cd:	78 29                	js     801051f8 <sys_link+0xe8>
  iunlockput(dp);
801051cf:	83 ec 0c             	sub    $0xc,%esp
801051d2:	56                   	push   %esi
801051d3:	e8 38 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801051d8:	89 1c 24             	mov    %ebx,(%esp)
801051db:	e8 d0 c6 ff ff       	call   801018b0 <iput>
  end_op();
801051e0:	e8 9b dd ff ff       	call   80102f80 <end_op>
  return 0;
801051e5:	83 c4 10             	add    $0x10,%esp
801051e8:	31 c0                	xor    %eax,%eax
}
801051ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ed:	5b                   	pop    %ebx
801051ee:	5e                   	pop    %esi
801051ef:	5f                   	pop    %edi
801051f0:	5d                   	pop    %ebp
801051f1:	c3                   	ret    
801051f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	56                   	push   %esi
801051fc:	e8 0f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105201:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	53                   	push   %ebx
80105208:	e8 73 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010520d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105212:	89 1c 24             	mov    %ebx,(%esp)
80105215:	e8 b6 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010521a:	89 1c 24             	mov    %ebx,(%esp)
8010521d:	e8 ee c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105222:	e8 59 dd ff ff       	call   80102f80 <end_op>
  return -1;
80105227:	83 c4 10             	add    $0x10,%esp
8010522a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522f:	eb b9                	jmp    801051ea <sys_link+0xda>
    iunlockput(ip);
80105231:	83 ec 0c             	sub    $0xc,%esp
80105234:	53                   	push   %ebx
80105235:	e8 d6 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010523a:	e8 41 dd ff ff       	call   80102f80 <end_op>
    return -1;
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105247:	eb a1                	jmp    801051ea <sys_link+0xda>
    end_op();
80105249:	e8 32 dd ff ff       	call   80102f80 <end_op>
    return -1;
8010524e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105253:	eb 95                	jmp    801051ea <sys_link+0xda>
80105255:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_unlink>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105265:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105268:	53                   	push   %ebx
80105269:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010526c:	50                   	push   %eax
8010526d:	6a 00                	push   $0x0
8010526f:	e8 bc f9 ff ff       	call   80104c30 <argstr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 88 7a 01 00 00    	js     801053f9 <sys_unlink+0x199>
  begin_op();
8010527f:	e8 8c dc ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105284:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	53                   	push   %ebx
8010528b:	ff 75 c0             	push   -0x40(%ebp)
8010528e:	e8 2d ce ff ff       	call   801020c0 <nameiparent>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105299:	85 c0                	test   %eax,%eax
8010529b:	0f 84 62 01 00 00    	je     80105403 <sys_unlink+0x1a3>
  ilock(dp);
801052a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	57                   	push   %edi
801052a8:	e8 d3 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052ad:	58                   	pop    %eax
801052ae:	5a                   	pop    %edx
801052af:	68 28 80 10 80       	push   $0x80108028
801052b4:	53                   	push   %ebx
801052b5:	e8 06 ca ff ff       	call   80101cc0 <namecmp>
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	85 c0                	test   %eax,%eax
801052bf:	0f 84 fb 00 00 00    	je     801053c0 <sys_unlink+0x160>
801052c5:	83 ec 08             	sub    $0x8,%esp
801052c8:	68 27 80 10 80       	push   $0x80108027
801052cd:	53                   	push   %ebx
801052ce:	e8 ed c9 ff ff       	call   80101cc0 <namecmp>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	0f 84 e2 00 00 00    	je     801053c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052de:	83 ec 04             	sub    $0x4,%esp
801052e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052e4:	50                   	push   %eax
801052e5:	53                   	push   %ebx
801052e6:	57                   	push   %edi
801052e7:	e8 f4 c9 ff ff       	call   80101ce0 <dirlookup>
801052ec:	83 c4 10             	add    $0x10,%esp
801052ef:	89 c3                	mov    %eax,%ebx
801052f1:	85 c0                	test   %eax,%eax
801052f3:	0f 84 c7 00 00 00    	je     801053c0 <sys_unlink+0x160>
  ilock(ip);
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	50                   	push   %eax
801052fd:	e8 7e c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010530a:	0f 8e 1c 01 00 00    	jle    8010542c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105310:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105315:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105318:	74 66                	je     80105380 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010531a:	83 ec 04             	sub    $0x4,%esp
8010531d:	6a 10                	push   $0x10
8010531f:	6a 00                	push   $0x0
80105321:	57                   	push   %edi
80105322:	e8 89 f5 ff ff       	call   801048b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105327:	6a 10                	push   $0x10
80105329:	ff 75 c4             	push   -0x3c(%ebp)
8010532c:	57                   	push   %edi
8010532d:	ff 75 b4             	push   -0x4c(%ebp)
80105330:	e8 5b c8 ff ff       	call   80101b90 <writei>
80105335:	83 c4 20             	add    $0x20,%esp
80105338:	83 f8 10             	cmp    $0x10,%eax
8010533b:	0f 85 de 00 00 00    	jne    8010541f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105341:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105346:	0f 84 94 00 00 00    	je     801053e0 <sys_unlink+0x180>
  iunlockput(dp);
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	ff 75 b4             	push   -0x4c(%ebp)
80105352:	e8 b9 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105357:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010535c:	89 1c 24             	mov    %ebx,(%esp)
8010535f:	e8 6c c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105364:	89 1c 24             	mov    %ebx,(%esp)
80105367:	e8 a4 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010536c:	e8 0f dc ff ff       	call   80102f80 <end_op>
  return 0;
80105371:	83 c4 10             	add    $0x10,%esp
80105374:	31 c0                	xor    %eax,%eax
}
80105376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105379:	5b                   	pop    %ebx
8010537a:	5e                   	pop    %esi
8010537b:	5f                   	pop    %edi
8010537c:	5d                   	pop    %ebp
8010537d:	c3                   	ret    
8010537e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105380:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105384:	76 94                	jbe    8010531a <sys_unlink+0xba>
80105386:	be 20 00 00 00       	mov    $0x20,%esi
8010538b:	eb 0b                	jmp    80105398 <sys_unlink+0x138>
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
80105390:	83 c6 10             	add    $0x10,%esi
80105393:	3b 73 58             	cmp    0x58(%ebx),%esi
80105396:	73 82                	jae    8010531a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105398:	6a 10                	push   $0x10
8010539a:	56                   	push   %esi
8010539b:	57                   	push   %edi
8010539c:	53                   	push   %ebx
8010539d:	e8 ee c6 ff ff       	call   80101a90 <readi>
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	83 f8 10             	cmp    $0x10,%eax
801053a8:	75 68                	jne    80105412 <sys_unlink+0x1b2>
    if(de.inum != 0)
801053aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053af:	74 df                	je     80105390 <sys_unlink+0x130>
    iunlockput(ip);
801053b1:	83 ec 0c             	sub    $0xc,%esp
801053b4:	53                   	push   %ebx
801053b5:	e8 56 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	ff 75 b4             	push   -0x4c(%ebp)
801053c6:	e8 45 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053cb:	e8 b0 db ff ff       	call   80102f80 <end_op>
  return -1;
801053d0:	83 c4 10             	add    $0x10,%esp
801053d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d8:	eb 9c                	jmp    80105376 <sys_unlink+0x116>
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053eb:	50                   	push   %eax
801053ec:	e8 df c2 ff ff       	call   801016d0 <iupdate>
801053f1:	83 c4 10             	add    $0x10,%esp
801053f4:	e9 53 ff ff ff       	jmp    8010534c <sys_unlink+0xec>
    return -1;
801053f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053fe:	e9 73 ff ff ff       	jmp    80105376 <sys_unlink+0x116>
    end_op();
80105403:	e8 78 db ff ff       	call   80102f80 <end_op>
    return -1;
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540d:	e9 64 ff ff ff       	jmp    80105376 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105412:	83 ec 0c             	sub    $0xc,%esp
80105415:	68 4c 80 10 80       	push   $0x8010804c
8010541a:	e8 61 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	68 5e 80 10 80       	push   $0x8010805e
80105427:	e8 54 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	68 3a 80 10 80       	push   $0x8010803a
80105434:	e8 47 af ff ff       	call   80100380 <panic>
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_open>:

int
sys_open(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105445:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105448:	53                   	push   %ebx
80105449:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010544c:	50                   	push   %eax
8010544d:	6a 00                	push   $0x0
8010544f:	e8 dc f7 ff ff       	call   80104c30 <argstr>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	0f 88 8e 00 00 00    	js     801054ed <sys_open+0xad>
8010545f:	83 ec 08             	sub    $0x8,%esp
80105462:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105465:	50                   	push   %eax
80105466:	6a 01                	push   $0x1
80105468:	e8 03 f7 ff ff       	call   80104b70 <argint>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 79                	js     801054ed <sys_open+0xad>
    return -1;

  begin_op();
80105474:	e8 97 da ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
80105479:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010547d:	75 79                	jne    801054f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	ff 75 e0             	push   -0x20(%ebp)
80105485:	e8 16 cc ff ff       	call   801020a0 <namei>
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	89 c6                	mov    %eax,%esi
8010548f:	85 c0                	test   %eax,%eax
80105491:	0f 84 7e 00 00 00    	je     80105515 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105497:	83 ec 0c             	sub    $0xc,%esp
8010549a:	50                   	push   %eax
8010549b:	e8 e0 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054a0:	83 c4 10             	add    $0x10,%esp
801054a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054a8:	0f 84 c2 00 00 00    	je     80105570 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054ae:	e8 7d b9 ff ff       	call   80100e30 <filealloc>
801054b3:	89 c7                	mov    %eax,%edi
801054b5:	85 c0                	test   %eax,%eax
801054b7:	74 23                	je     801054dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801054b9:	e8 72 e6 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054c0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801054c4:	85 d2                	test   %edx,%edx
801054c6:	74 60                	je     80105528 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054c8:	83 c3 01             	add    $0x1,%ebx
801054cb:	83 fb 10             	cmp    $0x10,%ebx
801054ce:	75 f0                	jne    801054c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	57                   	push   %edi
801054d4:	e8 17 ba ff ff       	call   80100ef0 <fileclose>
801054d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	56                   	push   %esi
801054e0:	e8 2b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054e5:	e8 96 da ff ff       	call   80102f80 <end_op>
    return -1;
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054f2:	eb 6d                	jmp    80105561 <sys_open+0x121>
801054f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054fe:	31 c9                	xor    %ecx,%ecx
80105500:	ba 02 00 00 00       	mov    $0x2,%edx
80105505:	6a 00                	push   $0x0
80105507:	e8 14 f8 ff ff       	call   80104d20 <create>
    if(ip == 0){
8010550c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010550f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105511:	85 c0                	test   %eax,%eax
80105513:	75 99                	jne    801054ae <sys_open+0x6e>
      end_op();
80105515:	e8 66 da ff ff       	call   80102f80 <end_op>
      return -1;
8010551a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010551f:	eb 40                	jmp    80105561 <sys_open+0x121>
80105521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105528:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010552b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010552f:	56                   	push   %esi
80105530:	e8 2b c3 ff ff       	call   80101860 <iunlock>
  end_op();
80105535:	e8 46 da ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
8010553a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105540:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105543:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105546:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105549:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010554b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105552:	f7 d0                	not    %eax
80105554:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105557:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010555a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010555d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105564:	89 d8                	mov    %ebx,%eax
80105566:	5b                   	pop    %ebx
80105567:	5e                   	pop    %esi
80105568:	5f                   	pop    %edi
80105569:	5d                   	pop    %ebp
8010556a:	c3                   	ret    
8010556b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105570:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105573:	85 c9                	test   %ecx,%ecx
80105575:	0f 84 33 ff ff ff    	je     801054ae <sys_open+0x6e>
8010557b:	e9 5c ff ff ff       	jmp    801054dc <sys_open+0x9c>

80105580 <sys_mkdir>:

int
sys_mkdir(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105586:	e8 85 d9 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105591:	50                   	push   %eax
80105592:	6a 00                	push   $0x0
80105594:	e8 97 f6 ff ff       	call   80104c30 <argstr>
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	85 c0                	test   %eax,%eax
8010559e:	78 30                	js     801055d0 <sys_mkdir+0x50>
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a6:	31 c9                	xor    %ecx,%ecx
801055a8:	ba 01 00 00 00       	mov    $0x1,%edx
801055ad:	6a 00                	push   $0x0
801055af:	e8 6c f7 ff ff       	call   80104d20 <create>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	74 15                	je     801055d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055bb:	83 ec 0c             	sub    $0xc,%esp
801055be:	50                   	push   %eax
801055bf:	e8 4c c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055c4:	e8 b7 d9 ff ff       	call   80102f80 <end_op>
  return 0;
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	c9                   	leave  
801055cf:	c3                   	ret    
    end_op();
801055d0:	e8 ab d9 ff ff       	call   80102f80 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055da:	c9                   	leave  
801055db:	c3                   	ret    
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_mknod>:

int
sys_mknod(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055e6:	e8 25 d9 ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 37 f6 ff ff       	call   80104c30 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 60                	js     80105660 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105606:	50                   	push   %eax
80105607:	6a 01                	push   $0x1
80105609:	e8 62 f5 ff ff       	call   80104b70 <argint>
  if((argstr(0, &path)) < 0 ||
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	85 c0                	test   %eax,%eax
80105613:	78 4b                	js     80105660 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105615:	83 ec 08             	sub    $0x8,%esp
80105618:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561b:	50                   	push   %eax
8010561c:	6a 02                	push   $0x2
8010561e:	e8 4d f5 ff ff       	call   80104b70 <argint>
     argint(1, &major) < 0 ||
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	78 36                	js     80105660 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010562a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010562e:	83 ec 0c             	sub    $0xc,%esp
80105631:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105635:	ba 03 00 00 00       	mov    $0x3,%edx
8010563a:	50                   	push   %eax
8010563b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010563e:	e8 dd f6 ff ff       	call   80104d20 <create>
     argint(2, &minor) < 0 ||
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	74 16                	je     80105660 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010564a:	83 ec 0c             	sub    $0xc,%esp
8010564d:	50                   	push   %eax
8010564e:	e8 bd c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105653:	e8 28 d9 ff ff       	call   80102f80 <end_op>
  return 0;
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	31 c0                	xor    %eax,%eax
}
8010565d:	c9                   	leave  
8010565e:	c3                   	ret    
8010565f:	90                   	nop
    end_op();
80105660:	e8 1b d9 ff ff       	call   80102f80 <end_op>
    return -1;
80105665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010566a:	c9                   	leave  
8010566b:	c3                   	ret    
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_chdir>:

int
sys_chdir(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
80105675:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105678:	e8 b3 e4 ff ff       	call   80103b30 <myproc>
8010567d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010567f:	e8 8c d8 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105684:	83 ec 08             	sub    $0x8,%esp
80105687:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568a:	50                   	push   %eax
8010568b:	6a 00                	push   $0x0
8010568d:	e8 9e f5 ff ff       	call   80104c30 <argstr>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	78 77                	js     80105710 <sys_chdir+0xa0>
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	ff 75 f4             	push   -0xc(%ebp)
8010569f:	e8 fc c9 ff ff       	call   801020a0 <namei>
801056a4:	83 c4 10             	add    $0x10,%esp
801056a7:	89 c3                	mov    %eax,%ebx
801056a9:	85 c0                	test   %eax,%eax
801056ab:	74 63                	je     80105710 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	50                   	push   %eax
801056b1:	e8 ca c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056be:	75 30                	jne    801056f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	53                   	push   %ebx
801056c4:	e8 97 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801056c9:	58                   	pop    %eax
801056ca:	ff 76 6c             	push   0x6c(%esi)
801056cd:	e8 de c1 ff ff       	call   801018b0 <iput>
  end_op();
801056d2:	e8 a9 d8 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801056d7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	31 c0                	xor    %eax,%eax
}
801056df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e2:	5b                   	pop    %ebx
801056e3:	5e                   	pop    %esi
801056e4:	5d                   	pop    %ebp
801056e5:	c3                   	ret    
801056e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 17 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056f9:	e8 82 d8 ff ff       	call   80102f80 <end_op>
    return -1;
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105706:	eb d7                	jmp    801056df <sys_chdir+0x6f>
80105708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
    end_op();
80105710:	e8 6b d8 ff ff       	call   80102f80 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571a:	eb c3                	jmp    801056df <sys_chdir+0x6f>
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_exec>:

int
sys_exec(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105725:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010572b:	53                   	push   %ebx
8010572c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105732:	50                   	push   %eax
80105733:	6a 00                	push   $0x0
80105735:	e8 f6 f4 ff ff       	call   80104c30 <argstr>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	0f 88 87 00 00 00    	js     801057cc <sys_exec+0xac>
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010574e:	50                   	push   %eax
8010574f:	6a 01                	push   $0x1
80105751:	e8 1a f4 ff ff       	call   80104b70 <argint>
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	85 c0                	test   %eax,%eax
8010575b:	78 6f                	js     801057cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010575d:	83 ec 04             	sub    $0x4,%esp
80105760:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105766:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105768:	68 80 00 00 00       	push   $0x80
8010576d:	6a 00                	push   $0x0
8010576f:	56                   	push   %esi
80105770:	e8 3b f1 ff ff       	call   801048b0 <memset>
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105780:	83 ec 08             	sub    $0x8,%esp
80105783:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105789:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105790:	50                   	push   %eax
80105791:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105797:	01 f8                	add    %edi,%eax
80105799:	50                   	push   %eax
8010579a:	e8 41 f3 ff ff       	call   80104ae0 <fetchint>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	78 26                	js     801057cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057ac:	85 c0                	test   %eax,%eax
801057ae:	74 30                	je     801057e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057b6:	52                   	push   %edx
801057b7:	50                   	push   %eax
801057b8:	e8 63 f3 ff ff       	call   80104b20 <fetchstr>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	85 c0                	test   %eax,%eax
801057c2:	78 08                	js     801057cc <sys_exec+0xac>
  for(i=0;; i++){
801057c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057c7:	83 fb 20             	cmp    $0x20,%ebx
801057ca:	75 b4                	jne    80105780 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d4:	5b                   	pop    %ebx
801057d5:	5e                   	pop    %esi
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057e7:	00 00 00 00 
  return exec(path, argv);
801057eb:	83 ec 08             	sub    $0x8,%esp
801057ee:	56                   	push   %esi
801057ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057f5:	e8 b6 b2 ff ff       	call   80100ab0 <exec>
801057fa:	83 c4 10             	add    $0x10,%esp
}
801057fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105800:	5b                   	pop    %ebx
80105801:	5e                   	pop    %esi
80105802:	5f                   	pop    %edi
80105803:	5d                   	pop    %ebp
80105804:	c3                   	ret    
80105805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_pipe>:

int
sys_pipe(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105815:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105818:	53                   	push   %ebx
80105819:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010581c:	6a 08                	push   $0x8
8010581e:	50                   	push   %eax
8010581f:	6a 00                	push   $0x0
80105821:	e8 9a f3 ff ff       	call   80104bc0 <argptr>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	85 c0                	test   %eax,%eax
8010582b:	78 4a                	js     80105877 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010582d:	83 ec 08             	sub    $0x8,%esp
80105830:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105833:	50                   	push   %eax
80105834:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105837:	50                   	push   %eax
80105838:	e8 a3 dd ff ff       	call   801035e0 <pipealloc>
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	85 c0                	test   %eax,%eax
80105842:	78 33                	js     80105877 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105844:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105847:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105849:	e8 e2 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010584e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105850:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105854:	85 f6                	test   %esi,%esi
80105856:	74 28                	je     80105880 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105858:	83 c3 01             	add    $0x1,%ebx
8010585b:	83 fb 10             	cmp    $0x10,%ebx
8010585e:	75 f0                	jne    80105850 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	ff 75 e0             	push   -0x20(%ebp)
80105866:	e8 85 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010586b:	58                   	pop    %eax
8010586c:	ff 75 e4             	push   -0x1c(%ebp)
8010586f:	e8 7c b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587c:	eb 53                	jmp    801058d1 <sys_pipe+0xc1>
8010587e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105880:	8d 73 08             	lea    0x8(%ebx),%esi
80105883:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105887:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010588a:	e8 a1 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010588f:	31 d2                	xor    %edx,%edx
80105891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105898:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010589c:	85 c9                	test   %ecx,%ecx
8010589e:	74 20                	je     801058c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058a0:	83 c2 01             	add    $0x1,%edx
801058a3:	83 fa 10             	cmp    $0x10,%edx
801058a6:	75 f0                	jne    80105898 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058a8:	e8 83 e2 ff ff       	call   80103b30 <myproc>
801058ad:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
801058b4:	00 
801058b5:	eb a9                	jmp    80105860 <sys_pipe+0x50>
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058c0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
801058c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058cf:	31 c0                	xor    %eax,%eax
}
801058d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d4:	5b                   	pop    %ebx
801058d5:	5e                   	pop    %esi
801058d6:	5f                   	pop    %edi
801058d7:	5d                   	pop    %ebp
801058d8:	c3                   	ret    
801058d9:	66 90                	xchg   %ax,%ax
801058db:	66 90                	xchg   %ax,%ax
801058dd:	66 90                	xchg   %ax,%ax
801058df:	90                   	nop

801058e0 <sys_fork>:


int
sys_fork(void)
{
  return fork();
801058e0:	e9 6b e4 ff ff       	jmp    80103d50 <fork>
801058e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_exit>:
}

int
sys_exit(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058f6:	e8 e5 e6 ff ff       	call   80103fe0 <exit>
  return 0;  // not reached
}
801058fb:	31 c0                	xor    %eax,%eax
801058fd:	c9                   	leave  
801058fe:	c3                   	ret    
801058ff:	90                   	nop

80105900 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105900:	e9 0b e8 ff ff       	jmp    80104110 <wait>
80105905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_kill>:
}

int
sys_kill(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105916:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105919:	50                   	push   %eax
8010591a:	6a 00                	push   $0x0
8010591c:	e8 4f f2 ff ff       	call   80104b70 <argint>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	85 c0                	test   %eax,%eax
80105926:	78 18                	js     80105940 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105928:	83 ec 0c             	sub    $0xc,%esp
8010592b:	ff 75 f4             	push   -0xc(%ebp)
8010592e:	e8 7d ea ff ff       	call   801043b0 <kill>
80105933:	83 c4 10             	add    $0x10,%esp
}
80105936:	c9                   	leave  
80105937:	c3                   	ret    
80105938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop
80105940:	c9                   	leave  
    return -1;
80105941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105946:	c3                   	ret    
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_getpid>:

int
sys_getpid(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105956:	e8 d5 e1 ff ff       	call   80103b30 <myproc>
8010595b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    

80105960 <sys_sbrk>:

int
sys_sbrk(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105967:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010596a:	50                   	push   %eax
8010596b:	6a 00                	push   $0x0
8010596d:	e8 fe f1 ff ff       	call   80104b70 <argint>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	78 27                	js     801059a0 <sys_sbrk+0x40>
    return -1;
  
  addr = myproc()->sz;
80105979:	e8 b2 e1 ff ff       	call   80103b30 <myproc>
  if(growproc(n) < 0)
8010597e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105981:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105983:	ff 75 f4             	push   -0xc(%ebp)
80105986:	e8 a5 e3 ff ff       	call   80103d30 <growproc>
8010598b:	83 c4 10             	add    $0x10,%esp
8010598e:	85 c0                	test   %eax,%eax
80105990:	78 0e                	js     801059a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105992:	89 d8                	mov    %ebx,%eax
80105994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105997:	c9                   	leave  
80105998:	c3                   	ret    
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a5:	eb eb                	jmp    80105992 <sys_sbrk+0x32>
801059a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_sleep>:

int
sys_sleep(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 ae f1 ff ff       	call   80104b70 <argint>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	0f 88 8a 00 00 00    	js     80105a57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	68 e0 4d 11 80       	push   $0x80114de0
801059d5:	e8 16 ee ff ff       	call   801047f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059dd:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  while(ticks - ticks0 < n){
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	85 d2                	test   %edx,%edx
801059e8:	75 27                	jne    80105a11 <sys_sleep+0x61>
801059ea:	eb 54                	jmp    80105a40 <sys_sleep+0x90>
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059f0:	83 ec 08             	sub    $0x8,%esp
801059f3:	68 e0 4d 11 80       	push   $0x80114de0
801059f8:	68 c0 4d 11 80       	push   $0x80114dc0
801059fd:	e8 8e e8 ff ff       	call   80104290 <sleep>
  while(ticks - ticks0 < n){
80105a02:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	29 d8                	sub    %ebx,%eax
80105a0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a0f:	73 2f                	jae    80105a40 <sys_sleep+0x90>
    if(myproc()->killed){
80105a11:	e8 1a e1 ff ff       	call   80103b30 <myproc>
80105a16:	8b 40 28             	mov    0x28(%eax),%eax
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	74 d3                	je     801059f0 <sys_sleep+0x40>
      release(&tickslock);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
80105a20:	68 e0 4d 11 80       	push   $0x80114de0
80105a25:	e8 66 ed ff ff       	call   80104790 <release>
  }
  release(&tickslock);
  return 0;
}
80105a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	68 e0 4d 11 80       	push   $0x80114de0
80105a48:	e8 43 ed ff ff       	call   80104790 <release>
  return 0;
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	31 c0                	xor    %eax,%eax
}
80105a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
    return -1;
80105a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5c:	eb f4                	jmp    80105a52 <sys_sleep+0xa2>
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
80105a64:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a67:	68 e0 4d 11 80       	push   $0x80114de0
80105a6c:	e8 7f ed ff ff       	call   801047f0 <acquire>
  xticks = ticks;
80105a71:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  release(&tickslock);
80105a77:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105a7e:	e8 0d ed ff ff       	call   80104790 <release>
  return xticks;
}
80105a83:	89 d8                	mov    %ebx,%eax
80105a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a88:	c9                   	leave  
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a90 <sys_printhugepde>:

// System calls for debugging huge page allocations/mappings
int
sys_printhugepde()
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
80105a95:	53                   	push   %ebx
  pde_t *pgdir = myproc()->pgdir;
  int pid = myproc()->pid;
  int i = 0;
  for (i = 0; i < 1024; i++) {
80105a96:	31 db                	xor    %ebx,%ebx
{
80105a98:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir = myproc()->pgdir;
80105a9b:	e8 90 e0 ff ff       	call   80103b30 <myproc>
80105aa0:	8b 78 08             	mov    0x8(%eax),%edi
  int pid = myproc()->pid;
80105aa3:	e8 88 e0 ff ff       	call   80103b30 <myproc>
80105aa8:	8b 70 14             	mov    0x14(%eax),%esi
  for (i = 0; i < 1024; i++) {
80105aab:	eb 0e                	jmp    80105abb <sys_printhugepde+0x2b>
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
80105ab0:	83 c3 01             	add    $0x1,%ebx
80105ab3:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105ab9:	74 2e                	je     80105ae9 <sys_printhugepde+0x59>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P))
80105abb:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80105abe:	89 c2                	mov    %eax,%edx
80105ac0:	81 e2 85 00 00 00    	and    $0x85,%edx
80105ac6:	81 fa 85 00 00 00    	cmp    $0x85,%edx
80105acc:	75 e2                	jne    80105ab0 <sys_printhugepde+0x20>
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105ace:	50                   	push   %eax
80105acf:	53                   	push   %ebx
  for (i = 0; i < 1024; i++) {
80105ad0:	83 c3 01             	add    $0x1,%ebx
      cprintf("PID %d: PDE[%d] is 0x%x\n", pid, i, pgdir[i]);
80105ad3:	56                   	push   %esi
80105ad4:	68 6d 80 10 80       	push   $0x8010806d
80105ad9:	e8 c2 ab ff ff       	call   801006a0 <cprintf>
80105ade:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1024; i++) {
80105ae1:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80105ae7:	75 d2                	jne    80105abb <sys_printhugepde+0x2b>
  }
  return 0;
}
80105ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aec:	31 c0                	xor    %eax,%eax
80105aee:	5b                   	pop    %ebx
80105aef:	5e                   	pop    %esi
80105af0:	5f                   	pop    %edi
80105af1:	5d                   	pop    %ebp
80105af2:	c3                   	ret    
80105af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b00 <sys_procpgdirinfo>:

int
sys_procpgdirinfo()
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
  int *buf;
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105b08:	53                   	push   %ebx
80105b09:	83 ec 30             	sub    $0x30,%esp
  if(argptr(0, (void*)&buf, 2*sizeof(buf[0])) < 0)
80105b0c:	6a 08                	push   $0x8
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 aa f0 ff ff       	call   80104bc0 <argptr>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	0f 88 90 00 00 00    	js     80105bb1 <sys_procpgdirinfo+0xb1>
    return -1;
  pde_t *pgdir = myproc()->pgdir;
80105b21:	e8 0a e0 ff ff       	call   80103b30 <myproc>
  int base_cnt = 0; // base page count
  int huge_cnt = 0; // huge page count
80105b26:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int base_cnt = 0; // base page count
80105b2d:	31 c9                	xor    %ecx,%ecx
80105b2f:	8b 70 08             	mov    0x8(%eax),%esi
80105b32:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105b38:	eb 12                	jmp    80105b4c <sys_procpgdirinfo+0x4c>
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i = 0;
  int j = 0;
  for (i = 0; i < 1024; i++) {
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
      ++huge_cnt;
    if((pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) && ((pgdir[i] & PTE_PS) == 0) /*Only PTE_P and PTE_U should be set for base pages*/) {
80105b40:	83 f8 05             	cmp    $0x5,%eax
80105b43:	74 3a                	je     80105b7f <sys_procpgdirinfo+0x7f>
  for (i = 0; i < 1024; i++) {
80105b45:	83 c6 04             	add    $0x4,%esi
80105b48:	39 f7                	cmp    %esi,%edi
80105b4a:	74 1b                	je     80105b67 <sys_procpgdirinfo+0x67>
    if((pgdir[i] & PTE_PS) && (pgdir[i] & PTE_U) && (pgdir[i] & PTE_P) /*PTE_P, PTE_U and PTE_PS should be set for huge pages*/)
80105b4c:	8b 1e                	mov    (%esi),%ebx
80105b4e:	89 d8                	mov    %ebx,%eax
80105b50:	25 85 00 00 00       	and    $0x85,%eax
80105b55:	3d 85 00 00 00       	cmp    $0x85,%eax
80105b5a:	75 e4                	jne    80105b40 <sys_procpgdirinfo+0x40>
  for (i = 0; i < 1024; i++) {
80105b5c:	83 c6 04             	add    $0x4,%esi
      ++huge_cnt;
80105b5f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  for (i = 0; i < 1024; i++) {
80105b63:	39 f7                	cmp    %esi,%edi
80105b65:	75 e5                	jne    80105b4c <sys_procpgdirinfo+0x4c>
          ++base_cnt;
        }
      }
    }
  }
  buf[0] = base_cnt; // base page count
80105b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  buf[1] = huge_cnt; // huge page count
80105b6a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  buf[0] = base_cnt; // base page count
80105b6d:	89 08                	mov    %ecx,(%eax)
  buf[1] = huge_cnt; // huge page count
80105b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b72:	89 78 04             	mov    %edi,0x4(%eax)
  return 0;
80105b75:	31 c0                	xor    %eax,%eax
}
80105b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b7a:	5b                   	pop    %ebx
80105b7b:	5e                   	pop    %esi
80105b7c:	5f                   	pop    %edi
80105b7d:	5d                   	pop    %ebp
80105b7e:	c3                   	ret    
      uint* pgtab = (uint*)P2V(PTE_ADDR(pgdir[i]));
80105b7f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105b85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
      for (j = 0; j < 1024; j++) {
80105b8b:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)) {
80105b98:	8b 10                	mov    (%eax),%edx
80105b9a:	83 e2 05             	and    $0x5,%edx
          ++base_cnt;
80105b9d:	83 fa 05             	cmp    $0x5,%edx
80105ba0:	0f 94 c2             	sete   %dl
      for (j = 0; j < 1024; j++) {
80105ba3:	83 c0 04             	add    $0x4,%eax
          ++base_cnt;
80105ba6:	0f b6 d2             	movzbl %dl,%edx
80105ba9:	01 d1                	add    %edx,%ecx
      for (j = 0; j < 1024; j++) {
80105bab:	39 d8                	cmp    %ebx,%eax
80105bad:	75 e9                	jne    80105b98 <sys_procpgdirinfo+0x98>
80105baf:	eb 94                	jmp    80105b45 <sys_procpgdirinfo+0x45>
    return -1;
80105bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb6:	eb bf                	jmp    80105b77 <sys_procpgdirinfo+0x77>
80105bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbf:	90                   	nop

80105bc0 <sys_sbrkhuge>:

int
sys_sbrkhuge(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105bc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bca:	50                   	push   %eax
80105bcb:	6a 00                	push   $0x0
80105bcd:	e8 9e ef ff ff       	call   80104b70 <argint>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	78 27                	js     80105c00 <sys_sbrkhuge+0x40>
    return -1;
  
  addr = myproc()->hugesz;
80105bd9:	e8 52 df ff ff       	call   80103b30 <myproc>
  if(growproc_huge(n, 1) < 0)
80105bde:	83 ec 08             	sub    $0x8,%esp
  addr = myproc()->hugesz;
80105be1:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc_huge(n, 1) < 0)
80105be4:	6a 01                	push   $0x1
80105be6:	ff 75 f4             	push   -0xc(%ebp)
80105be9:	e8 72 e0 ff ff       	call   80103c60 <growproc_huge>
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	85 c0                	test   %eax,%eax
80105bf3:	78 0b                	js     80105c00 <sys_sbrkhuge+0x40>
    return -1;
  return addr;
}
80105bf5:	89 d8                	mov    %ebx,%eax
80105bf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bfa:	c9                   	leave  
80105bfb:	c3                   	ret    
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c05:	eb ee                	jmp    80105bf5 <sys_sbrkhuge+0x35>
80105c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_vmalloc>:
int
sys_vmalloc(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
  int n;
  int flag;
  
  if(argint(0, &n) < 0 || argint(1, &flag) < 0)
80105c14:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105c17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0 || argint(1, &flag) < 0)
80105c1a:	50                   	push   %eax
80105c1b:	6a 00                	push   $0x0
80105c1d:	e8 4e ef ff ff       	call   80104b70 <argint>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 7f                	js     80105ca8 <sys_vmalloc+0x98>
80105c29:	83 ec 08             	sub    $0x8,%esp
80105c2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c2f:	50                   	push   %eax
80105c30:	6a 01                	push   $0x1
80105c32:	e8 39 ef ff ff       	call   80104b70 <argint>
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	85 c0                	test   %eax,%eax
80105c3c:	78 6a                	js     80105ca8 <sys_vmalloc+0x98>
    return -1;
  
  struct proc *curproc = myproc();
80105c3e:	e8 ed de ff ff       	call   80103b30 <myproc>
  
  if(flag == 0) {  // VMALLOC_SIZE_BASE
80105c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c46:	85 d2                	test   %edx,%edx
80105c48:	74 36                	je     80105c80 <sys_vmalloc+0x70>
    if(growproc(8 * PGSIZE) < 0)
      return 0;
    
    return addr;  // Return the address before growth
  } 
  else if(flag == 1) {  // VMALLOC_SIZE_HUGE
80105c4a:	83 fa 01             	cmp    $0x1,%edx
80105c4d:	75 59                	jne    80105ca8 <sys_vmalloc+0x98>
    // Handle huge page allocations
    uint addr = curproc->hugesz;
80105c4f:	8b 58 04             	mov    0x4(%eax),%ebx
    if(addr == 0)
      addr = HUGE_VA_OFFSET;
80105c52:	b8 00 00 00 1e       	mov    $0x1e000000,%eax
80105c57:	85 db                	test   %ebx,%ebx
80105c59:	0f 44 d8             	cmove  %eax,%ebx
    
    // For 4MB allocations, allocate with huge page mechanism
    if(growproc_huge(n, 1) < 0)
80105c5c:	83 ec 08             	sub    $0x8,%esp
80105c5f:	6a 01                	push   $0x1
80105c61:	ff 75 f0             	push   -0x10(%ebp)
80105c64:	e8 f7 df ff ff       	call   80103c60 <growproc_huge>
80105c69:	83 c4 10             	add    $0x10,%esp
80105c6c:	85 c0                	test   %eax,%eax
80105c6e:	78 2a                	js     80105c9a <sys_vmalloc+0x8a>
      return 0;
    
    return addr;
80105c70:	89 d8                	mov    %ebx,%eax
  } 
  else {
    return -1;
  }
}
80105c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax
    if(growproc(8 * PGSIZE) < 0)
80105c80:	83 ec 0c             	sub    $0xc,%esp
    uint addr = curproc->sz;
80105c83:	8b 18                	mov    (%eax),%ebx
    if(growproc(8 * PGSIZE) < 0)
80105c85:	68 00 80 00 00       	push   $0x8000
80105c8a:	e8 a1 e0 ff ff       	call   80103d30 <growproc>
80105c8f:	83 c4 10             	add    $0x10,%esp
80105c92:	89 c2                	mov    %eax,%edx
    return addr;  // Return the address before growth
80105c94:	89 d8                	mov    %ebx,%eax
    if(growproc(8 * PGSIZE) < 0)
80105c96:	85 d2                	test   %edx,%edx
80105c98:	79 d8                	jns    80105c72 <sys_vmalloc+0x62>
}
80105c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105c9d:	31 c0                	xor    %eax,%eax
}
80105c9f:	c9                   	leave  
80105ca0:	c3                   	ret    
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ca8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cad:	eb c3                	jmp    80105c72 <sys_vmalloc+0x62>
80105caf:	90                   	nop

80105cb0 <sys_vfree>:
int
sys_vfree(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 1c             	sub    $0x1c,%esp
  void *ptr;
  
  if(argptr(0, (char**)&ptr, sizeof(ptr)) < 0)
80105cb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cb9:	6a 04                	push   $0x4
80105cbb:	50                   	push   %eax
80105cbc:	6a 00                	push   $0x0
80105cbe:	e8 fd ee ff ff       	call   80104bc0 <argptr>
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	78 0b                	js     80105cd5 <sys_vfree+0x25>
    return -1;
  
  // vfree is handled in user space, so kernel just validates the pointer
  if((uint)ptr >= KERNBASE) {
80105cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	78 0b                	js     80105cdc <sys_vfree+0x2c>
    cprintf("Error - trying to free a kernel pointer in userspace\n");
    return -1;
  }
  
  return 0;
80105cd1:	c9                   	leave  
  return 0;
80105cd2:	31 c0                	xor    %eax,%eax
80105cd4:	c3                   	ret    
80105cd5:	c9                   	leave  
    return -1;
80105cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdb:	c3                   	ret    
    cprintf("Error - trying to free a kernel pointer in userspace\n");
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	68 88 80 10 80       	push   $0x80108088
80105ce4:	e8 b7 a9 ff ff       	call   801006a0 <cprintf>
    return -1;
80105ce9:	83 c4 10             	add    $0x10,%esp
80105cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf1:	c9                   	leave  
80105cf2:	c3                   	ret    

80105cf3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cf3:	1e                   	push   %ds
  pushl %es
80105cf4:	06                   	push   %es
  pushl %fs
80105cf5:	0f a0                	push   %fs
  pushl %gs
80105cf7:	0f a8                	push   %gs
  pushal
80105cf9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cfa:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cfe:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d00:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d02:	54                   	push   %esp
  call trap
80105d03:	e8 c8 00 00 00       	call   80105dd0 <trap>
  addl $4, %esp
80105d08:	83 c4 04             	add    $0x4,%esp

80105d0b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d0b:	61                   	popa   
  popl %gs
80105d0c:	0f a9                	pop    %gs
  popl %fs
80105d0e:	0f a1                	pop    %fs
  popl %es
80105d10:	07                   	pop    %es
  popl %ds
80105d11:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d12:	83 c4 08             	add    $0x8,%esp
  iret
80105d15:	cf                   	iret   
80105d16:	66 90                	xchg   %ax,%ax
80105d18:	66 90                	xchg   %ax,%ax
80105d1a:	66 90                	xchg   %ax,%ax
80105d1c:	66 90                	xchg   %ax,%ax
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d21:	31 c0                	xor    %eax,%eax
{
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 08             	sub    $0x8,%esp
80105d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d30:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d37:	c7 04 c5 22 4e 11 80 	movl   $0x8e000008,-0x7feeb1de(,%eax,8)
80105d3e:	08 00 00 8e 
80105d42:	66 89 14 c5 20 4e 11 	mov    %dx,-0x7feeb1e0(,%eax,8)
80105d49:	80 
80105d4a:	c1 ea 10             	shr    $0x10,%edx
80105d4d:	66 89 14 c5 26 4e 11 	mov    %dx,-0x7feeb1da(,%eax,8)
80105d54:	80 
  for(i = 0; i < 256; i++)
80105d55:	83 c0 01             	add    $0x1,%eax
80105d58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d5d:	75 d1                	jne    80105d30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d5f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d62:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d67:	c7 05 22 50 11 80 08 	movl   $0xef000008,0x80115022
80105d6e:	00 00 ef 
  initlock(&tickslock, "time");
80105d71:	68 be 80 10 80       	push   $0x801080be
80105d76:	68 e0 4d 11 80       	push   $0x80114de0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d7b:	66 a3 20 50 11 80    	mov    %ax,0x80115020
80105d81:	c1 e8 10             	shr    $0x10,%eax
80105d84:	66 a3 26 50 11 80    	mov    %ax,0x80115026
  initlock(&tickslock, "time");
80105d8a:	e8 91 e8 ff ff       	call   80104620 <initlock>
}
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	c9                   	leave  
80105d93:	c3                   	ret    
80105d94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop

80105da0 <idtinit>:

void
idtinit(void)
{
80105da0:	55                   	push   %ebp
  pd[0] = size-1;
80105da1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105da6:	89 e5                	mov    %esp,%ebp
80105da8:	83 ec 10             	sub    $0x10,%esp
80105dab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105daf:	b8 20 4e 11 80       	mov    $0x80114e20,%eax
80105db4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105db8:	c1 e8 10             	shr    $0x10,%eax
80105dbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105dbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105dc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105dc5:	c9                   	leave  
80105dc6:	c3                   	ret    
80105dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
80105dd6:	83 ec 1c             	sub    $0x1c,%esp
80105dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ddc:	8b 43 30             	mov    0x30(%ebx),%eax
80105ddf:	83 f8 40             	cmp    $0x40,%eax
80105de2:	0f 84 68 01 00 00    	je     80105f50 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105de8:	83 e8 20             	sub    $0x20,%eax
80105deb:	83 f8 1f             	cmp    $0x1f,%eax
80105dee:	0f 87 8c 00 00 00    	ja     80105e80 <trap+0xb0>
80105df4:	ff 24 85 64 81 10 80 	jmp    *-0x7fef7e9c(,%eax,4)
80105dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dff:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e00:	e8 3b c4 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105e05:	e8 b6 cc ff ff       	call   80102ac0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0a:	e8 21 dd ff ff       	call   80103b30 <myproc>
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	74 1d                	je     80105e30 <trap+0x60>
80105e13:	e8 18 dd ff ff       	call   80103b30 <myproc>
80105e18:	8b 50 28             	mov    0x28(%eax),%edx
80105e1b:	85 d2                	test   %edx,%edx
80105e1d:	74 11                	je     80105e30 <trap+0x60>
80105e1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e23:	83 e0 03             	and    $0x3,%eax
80105e26:	66 83 f8 03          	cmp    $0x3,%ax
80105e2a:	0f 84 e8 01 00 00    	je     80106018 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e30:	e8 fb dc ff ff       	call   80103b30 <myproc>
80105e35:	85 c0                	test   %eax,%eax
80105e37:	74 0f                	je     80105e48 <trap+0x78>
80105e39:	e8 f2 dc ff ff       	call   80103b30 <myproc>
80105e3e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105e42:	0f 84 b8 00 00 00    	je     80105f00 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e48:	e8 e3 dc ff ff       	call   80103b30 <myproc>
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	74 1d                	je     80105e6e <trap+0x9e>
80105e51:	e8 da dc ff ff       	call   80103b30 <myproc>
80105e56:	8b 40 28             	mov    0x28(%eax),%eax
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	74 11                	je     80105e6e <trap+0x9e>
80105e5d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e61:	83 e0 03             	and    $0x3,%eax
80105e64:	66 83 f8 03          	cmp    $0x3,%ax
80105e68:	0f 84 0f 01 00 00    	je     80105f7d <trap+0x1ad>
    exit();
}
80105e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e71:	5b                   	pop    %ebx
80105e72:	5e                   	pop    %esi
80105e73:	5f                   	pop    %edi
80105e74:	5d                   	pop    %ebp
80105e75:	c3                   	ret    
80105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e80:	e8 ab dc ff ff       	call   80103b30 <myproc>
80105e85:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e88:	85 c0                	test   %eax,%eax
80105e8a:	0f 84 a2 01 00 00    	je     80106032 <trap+0x262>
80105e90:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e94:	0f 84 98 01 00 00    	je     80106032 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e9a:	0f 20 d1             	mov    %cr2,%ecx
80105e9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ea0:	e8 6b dc ff ff       	call   80103b10 <cpuid>
80105ea5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ea8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105eab:	8b 43 34             	mov    0x34(%ebx),%eax
80105eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105eb1:	e8 7a dc ff ff       	call   80103b30 <myproc>
80105eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105eb9:	e8 72 dc ff ff       	call   80103b30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ebe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ec1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ec4:	51                   	push   %ecx
80105ec5:	57                   	push   %edi
80105ec6:	52                   	push   %edx
80105ec7:	ff 75 e4             	push   -0x1c(%ebp)
80105eca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ecb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ece:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ed1:	56                   	push   %esi
80105ed2:	ff 70 14             	push   0x14(%eax)
80105ed5:	68 20 81 10 80       	push   $0x80108120
80105eda:	e8 c1 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105edf:	83 c4 20             	add    $0x20,%esp
80105ee2:	e8 49 dc ff ff       	call   80103b30 <myproc>
80105ee7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eee:	e8 3d dc ff ff       	call   80103b30 <myproc>
80105ef3:	85 c0                	test   %eax,%eax
80105ef5:	0f 85 18 ff ff ff    	jne    80105e13 <trap+0x43>
80105efb:	e9 30 ff ff ff       	jmp    80105e30 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105f00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f04:	0f 85 3e ff ff ff    	jne    80105e48 <trap+0x78>
    yield();
80105f0a:	e8 31 e3 ff ff       	call   80104240 <yield>
80105f0f:	e9 34 ff ff ff       	jmp    80105e48 <trap+0x78>
80105f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f18:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f1f:	e8 ec db ff ff       	call   80103b10 <cpuid>
80105f24:	57                   	push   %edi
80105f25:	56                   	push   %esi
80105f26:	50                   	push   %eax
80105f27:	68 c8 80 10 80       	push   $0x801080c8
80105f2c:	e8 6f a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105f31:	e8 8a cb ff ff       	call   80102ac0 <lapiceoi>
    break;
80105f36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f39:	e8 f2 db ff ff       	call   80103b30 <myproc>
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	0f 85 cd fe ff ff    	jne    80105e13 <trap+0x43>
80105f46:	e9 e5 fe ff ff       	jmp    80105e30 <trap+0x60>
80105f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
    if(myproc()->killed)
80105f50:	e8 db db ff ff       	call   80103b30 <myproc>
80105f55:	8b 70 28             	mov    0x28(%eax),%esi
80105f58:	85 f6                	test   %esi,%esi
80105f5a:	0f 85 c8 00 00 00    	jne    80106028 <trap+0x258>
    myproc()->tf = tf;
80105f60:	e8 cb db ff ff       	call   80103b30 <myproc>
80105f65:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105f68:	e8 43 ed ff ff       	call   80104cb0 <syscall>
    if(myproc()->killed)
80105f6d:	e8 be db ff ff       	call   80103b30 <myproc>
80105f72:	8b 48 28             	mov    0x28(%eax),%ecx
80105f75:	85 c9                	test   %ecx,%ecx
80105f77:	0f 84 f1 fe ff ff    	je     80105e6e <trap+0x9e>
}
80105f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f80:	5b                   	pop    %ebx
80105f81:	5e                   	pop    %esi
80105f82:	5f                   	pop    %edi
80105f83:	5d                   	pop    %ebp
      exit();
80105f84:	e9 57 e0 ff ff       	jmp    80103fe0 <exit>
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f90:	e8 3b 02 00 00       	call   801061d0 <uartintr>
    lapiceoi();
80105f95:	e8 26 cb ff ff       	call   80102ac0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f9a:	e8 91 db ff ff       	call   80103b30 <myproc>
80105f9f:	85 c0                	test   %eax,%eax
80105fa1:	0f 85 6c fe ff ff    	jne    80105e13 <trap+0x43>
80105fa7:	e9 84 fe ff ff       	jmp    80105e30 <trap+0x60>
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fb0:	e8 cb c9 ff ff       	call   80102980 <kbdintr>
    lapiceoi();
80105fb5:	e8 06 cb ff ff       	call   80102ac0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fba:	e8 71 db ff ff       	call   80103b30 <myproc>
80105fbf:	85 c0                	test   %eax,%eax
80105fc1:	0f 85 4c fe ff ff    	jne    80105e13 <trap+0x43>
80105fc7:	e9 64 fe ff ff       	jmp    80105e30 <trap+0x60>
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105fd0:	e8 3b db ff ff       	call   80103b10 <cpuid>
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	0f 85 28 fe ff ff    	jne    80105e05 <trap+0x35>
      acquire(&tickslock);
80105fdd:	83 ec 0c             	sub    $0xc,%esp
80105fe0:	68 e0 4d 11 80       	push   $0x80114de0
80105fe5:	e8 06 e8 ff ff       	call   801047f0 <acquire>
      wakeup(&ticks);
80105fea:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
      ticks++;
80105ff1:	83 05 c0 4d 11 80 01 	addl   $0x1,0x80114dc0
      wakeup(&ticks);
80105ff8:	e8 53 e3 ff ff       	call   80104350 <wakeup>
      release(&tickslock);
80105ffd:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80106004:	e8 87 e7 ff ff       	call   80104790 <release>
80106009:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010600c:	e9 f4 fd ff ff       	jmp    80105e05 <trap+0x35>
80106011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106018:	e8 c3 df ff ff       	call   80103fe0 <exit>
8010601d:	e9 0e fe ff ff       	jmp    80105e30 <trap+0x60>
80106022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106028:	e8 b3 df ff ff       	call   80103fe0 <exit>
8010602d:	e9 2e ff ff ff       	jmp    80105f60 <trap+0x190>
80106032:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106035:	e8 d6 da ff ff       	call   80103b10 <cpuid>
8010603a:	83 ec 0c             	sub    $0xc,%esp
8010603d:	56                   	push   %esi
8010603e:	57                   	push   %edi
8010603f:	50                   	push   %eax
80106040:	ff 73 30             	push   0x30(%ebx)
80106043:	68 ec 80 10 80       	push   $0x801080ec
80106048:	e8 53 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010604d:	83 c4 14             	add    $0x14,%esp
80106050:	68 c3 80 10 80       	push   $0x801080c3
80106055:	e8 26 a3 ff ff       	call   80100380 <panic>
8010605a:	66 90                	xchg   %ax,%ax
8010605c:	66 90                	xchg   %ax,%ax
8010605e:	66 90                	xchg   %ax,%ax

80106060 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106060:	a1 20 56 11 80       	mov    0x80115620,%eax
80106065:	85 c0                	test   %eax,%eax
80106067:	74 17                	je     80106080 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106069:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010606e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010606f:	a8 01                	test   $0x1,%al
80106071:	74 0d                	je     80106080 <uartgetc+0x20>
80106073:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106078:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106079:	0f b6 c0             	movzbl %al,%eax
8010607c:	c3                   	ret    
8010607d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106085:	c3                   	ret    
80106086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608d:	8d 76 00             	lea    0x0(%esi),%esi

80106090 <uartinit>:
{
80106090:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106091:	31 c9                	xor    %ecx,%ecx
80106093:	89 c8                	mov    %ecx,%eax
80106095:	89 e5                	mov    %esp,%ebp
80106097:	57                   	push   %edi
80106098:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010609d:	56                   	push   %esi
8010609e:	89 fa                	mov    %edi,%edx
801060a0:	53                   	push   %ebx
801060a1:	83 ec 1c             	sub    $0x1c,%esp
801060a4:	ee                   	out    %al,(%dx)
801060a5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060af:	89 f2                	mov    %esi,%edx
801060b1:	ee                   	out    %al,(%dx)
801060b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060bc:	ee                   	out    %al,(%dx)
801060bd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060c2:	89 c8                	mov    %ecx,%eax
801060c4:	89 da                	mov    %ebx,%edx
801060c6:	ee                   	out    %al,(%dx)
801060c7:	b8 03 00 00 00       	mov    $0x3,%eax
801060cc:	89 f2                	mov    %esi,%edx
801060ce:	ee                   	out    %al,(%dx)
801060cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060d4:	89 c8                	mov    %ecx,%eax
801060d6:	ee                   	out    %al,(%dx)
801060d7:	b8 01 00 00 00       	mov    $0x1,%eax
801060dc:	89 da                	mov    %ebx,%edx
801060de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060e5:	3c ff                	cmp    $0xff,%al
801060e7:	74 78                	je     80106161 <uartinit+0xd1>
  uart = 1;
801060e9:	c7 05 20 56 11 80 01 	movl   $0x1,0x80115620
801060f0:	00 00 00 
801060f3:	89 fa                	mov    %edi,%edx
801060f5:	ec                   	in     (%dx),%al
801060f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060ff:	bf e4 81 10 80       	mov    $0x801081e4,%edi
80106104:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106109:	6a 00                	push   $0x0
8010610b:	6a 04                	push   $0x4
8010610d:	e8 6e c3 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106112:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106120:	a1 20 56 11 80       	mov    0x80115620,%eax
80106125:	bb 80 00 00 00       	mov    $0x80,%ebx
8010612a:	85 c0                	test   %eax,%eax
8010612c:	75 14                	jne    80106142 <uartinit+0xb2>
8010612e:	eb 23                	jmp    80106153 <uartinit+0xc3>
    microdelay(10);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	6a 0a                	push   $0xa
80106135:	e8 a6 c9 ff ff       	call   80102ae0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010613a:	83 c4 10             	add    $0x10,%esp
8010613d:	83 eb 01             	sub    $0x1,%ebx
80106140:	74 07                	je     80106149 <uartinit+0xb9>
80106142:	89 f2                	mov    %esi,%edx
80106144:	ec                   	in     (%dx),%al
80106145:	a8 20                	test   $0x20,%al
80106147:	74 e7                	je     80106130 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106149:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010614d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106152:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106153:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106157:	83 c7 01             	add    $0x1,%edi
8010615a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010615d:	84 c0                	test   %al,%al
8010615f:	75 bf                	jne    80106120 <uartinit+0x90>
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
80106168:	c3                   	ret    
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106170 <uartputc>:
  if(!uart)
80106170:	a1 20 56 11 80       	mov    0x80115620,%eax
80106175:	85 c0                	test   %eax,%eax
80106177:	74 47                	je     801061c0 <uartputc+0x50>
{
80106179:	55                   	push   %ebp
8010617a:	89 e5                	mov    %esp,%ebp
8010617c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010617d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106182:	53                   	push   %ebx
80106183:	bb 80 00 00 00       	mov    $0x80,%ebx
80106188:	eb 18                	jmp    801061a2 <uartputc+0x32>
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	6a 0a                	push   $0xa
80106195:	e8 46 c9 ff ff       	call   80102ae0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	83 eb 01             	sub    $0x1,%ebx
801061a0:	74 07                	je     801061a9 <uartputc+0x39>
801061a2:	89 f2                	mov    %esi,%edx
801061a4:	ec                   	in     (%dx),%al
801061a5:	a8 20                	test   $0x20,%al
801061a7:	74 e7                	je     80106190 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061a9:	8b 45 08             	mov    0x8(%ebp),%eax
801061ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061b1:	ee                   	out    %al,(%dx)
}
801061b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061b5:	5b                   	pop    %ebx
801061b6:	5e                   	pop    %esi
801061b7:	5d                   	pop    %ebp
801061b8:	c3                   	ret    
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061c0:	c3                   	ret    
801061c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop

801061d0 <uartintr>:

void
uartintr(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061d6:	68 60 60 10 80       	push   $0x80106060
801061db:	e8 a0 a6 ff ff       	call   80100880 <consoleintr>
}
801061e0:	83 c4 10             	add    $0x10,%esp
801061e3:	c9                   	leave  
801061e4:	c3                   	ret    

801061e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $0
801061e7:	6a 00                	push   $0x0
  jmp alltraps
801061e9:	e9 05 fb ff ff       	jmp    80105cf3 <alltraps>

801061ee <vector1>:
.globl vector1
vector1:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $1
801061f0:	6a 01                	push   $0x1
  jmp alltraps
801061f2:	e9 fc fa ff ff       	jmp    80105cf3 <alltraps>

801061f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $2
801061f9:	6a 02                	push   $0x2
  jmp alltraps
801061fb:	e9 f3 fa ff ff       	jmp    80105cf3 <alltraps>

80106200 <vector3>:
.globl vector3
vector3:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $3
80106202:	6a 03                	push   $0x3
  jmp alltraps
80106204:	e9 ea fa ff ff       	jmp    80105cf3 <alltraps>

80106209 <vector4>:
.globl vector4
vector4:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $4
8010620b:	6a 04                	push   $0x4
  jmp alltraps
8010620d:	e9 e1 fa ff ff       	jmp    80105cf3 <alltraps>

80106212 <vector5>:
.globl vector5
vector5:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $5
80106214:	6a 05                	push   $0x5
  jmp alltraps
80106216:	e9 d8 fa ff ff       	jmp    80105cf3 <alltraps>

8010621b <vector6>:
.globl vector6
vector6:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $6
8010621d:	6a 06                	push   $0x6
  jmp alltraps
8010621f:	e9 cf fa ff ff       	jmp    80105cf3 <alltraps>

80106224 <vector7>:
.globl vector7
vector7:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $7
80106226:	6a 07                	push   $0x7
  jmp alltraps
80106228:	e9 c6 fa ff ff       	jmp    80105cf3 <alltraps>

8010622d <vector8>:
.globl vector8
vector8:
  pushl $8
8010622d:	6a 08                	push   $0x8
  jmp alltraps
8010622f:	e9 bf fa ff ff       	jmp    80105cf3 <alltraps>

80106234 <vector9>:
.globl vector9
vector9:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $9
80106236:	6a 09                	push   $0x9
  jmp alltraps
80106238:	e9 b6 fa ff ff       	jmp    80105cf3 <alltraps>

8010623d <vector10>:
.globl vector10
vector10:
  pushl $10
8010623d:	6a 0a                	push   $0xa
  jmp alltraps
8010623f:	e9 af fa ff ff       	jmp    80105cf3 <alltraps>

80106244 <vector11>:
.globl vector11
vector11:
  pushl $11
80106244:	6a 0b                	push   $0xb
  jmp alltraps
80106246:	e9 a8 fa ff ff       	jmp    80105cf3 <alltraps>

8010624b <vector12>:
.globl vector12
vector12:
  pushl $12
8010624b:	6a 0c                	push   $0xc
  jmp alltraps
8010624d:	e9 a1 fa ff ff       	jmp    80105cf3 <alltraps>

80106252 <vector13>:
.globl vector13
vector13:
  pushl $13
80106252:	6a 0d                	push   $0xd
  jmp alltraps
80106254:	e9 9a fa ff ff       	jmp    80105cf3 <alltraps>

80106259 <vector14>:
.globl vector14
vector14:
  pushl $14
80106259:	6a 0e                	push   $0xe
  jmp alltraps
8010625b:	e9 93 fa ff ff       	jmp    80105cf3 <alltraps>

80106260 <vector15>:
.globl vector15
vector15:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $15
80106262:	6a 0f                	push   $0xf
  jmp alltraps
80106264:	e9 8a fa ff ff       	jmp    80105cf3 <alltraps>

80106269 <vector16>:
.globl vector16
vector16:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $16
8010626b:	6a 10                	push   $0x10
  jmp alltraps
8010626d:	e9 81 fa ff ff       	jmp    80105cf3 <alltraps>

80106272 <vector17>:
.globl vector17
vector17:
  pushl $17
80106272:	6a 11                	push   $0x11
  jmp alltraps
80106274:	e9 7a fa ff ff       	jmp    80105cf3 <alltraps>

80106279 <vector18>:
.globl vector18
vector18:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $18
8010627b:	6a 12                	push   $0x12
  jmp alltraps
8010627d:	e9 71 fa ff ff       	jmp    80105cf3 <alltraps>

80106282 <vector19>:
.globl vector19
vector19:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $19
80106284:	6a 13                	push   $0x13
  jmp alltraps
80106286:	e9 68 fa ff ff       	jmp    80105cf3 <alltraps>

8010628b <vector20>:
.globl vector20
vector20:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $20
8010628d:	6a 14                	push   $0x14
  jmp alltraps
8010628f:	e9 5f fa ff ff       	jmp    80105cf3 <alltraps>

80106294 <vector21>:
.globl vector21
vector21:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $21
80106296:	6a 15                	push   $0x15
  jmp alltraps
80106298:	e9 56 fa ff ff       	jmp    80105cf3 <alltraps>

8010629d <vector22>:
.globl vector22
vector22:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $22
8010629f:	6a 16                	push   $0x16
  jmp alltraps
801062a1:	e9 4d fa ff ff       	jmp    80105cf3 <alltraps>

801062a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $23
801062a8:	6a 17                	push   $0x17
  jmp alltraps
801062aa:	e9 44 fa ff ff       	jmp    80105cf3 <alltraps>

801062af <vector24>:
.globl vector24
vector24:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $24
801062b1:	6a 18                	push   $0x18
  jmp alltraps
801062b3:	e9 3b fa ff ff       	jmp    80105cf3 <alltraps>

801062b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $25
801062ba:	6a 19                	push   $0x19
  jmp alltraps
801062bc:	e9 32 fa ff ff       	jmp    80105cf3 <alltraps>

801062c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $26
801062c3:	6a 1a                	push   $0x1a
  jmp alltraps
801062c5:	e9 29 fa ff ff       	jmp    80105cf3 <alltraps>

801062ca <vector27>:
.globl vector27
vector27:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $27
801062cc:	6a 1b                	push   $0x1b
  jmp alltraps
801062ce:	e9 20 fa ff ff       	jmp    80105cf3 <alltraps>

801062d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $28
801062d5:	6a 1c                	push   $0x1c
  jmp alltraps
801062d7:	e9 17 fa ff ff       	jmp    80105cf3 <alltraps>

801062dc <vector29>:
.globl vector29
vector29:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $29
801062de:	6a 1d                	push   $0x1d
  jmp alltraps
801062e0:	e9 0e fa ff ff       	jmp    80105cf3 <alltraps>

801062e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $30
801062e7:	6a 1e                	push   $0x1e
  jmp alltraps
801062e9:	e9 05 fa ff ff       	jmp    80105cf3 <alltraps>

801062ee <vector31>:
.globl vector31
vector31:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $31
801062f0:	6a 1f                	push   $0x1f
  jmp alltraps
801062f2:	e9 fc f9 ff ff       	jmp    80105cf3 <alltraps>

801062f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $32
801062f9:	6a 20                	push   $0x20
  jmp alltraps
801062fb:	e9 f3 f9 ff ff       	jmp    80105cf3 <alltraps>

80106300 <vector33>:
.globl vector33
vector33:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $33
80106302:	6a 21                	push   $0x21
  jmp alltraps
80106304:	e9 ea f9 ff ff       	jmp    80105cf3 <alltraps>

80106309 <vector34>:
.globl vector34
vector34:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $34
8010630b:	6a 22                	push   $0x22
  jmp alltraps
8010630d:	e9 e1 f9 ff ff       	jmp    80105cf3 <alltraps>

80106312 <vector35>:
.globl vector35
vector35:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $35
80106314:	6a 23                	push   $0x23
  jmp alltraps
80106316:	e9 d8 f9 ff ff       	jmp    80105cf3 <alltraps>

8010631b <vector36>:
.globl vector36
vector36:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $36
8010631d:	6a 24                	push   $0x24
  jmp alltraps
8010631f:	e9 cf f9 ff ff       	jmp    80105cf3 <alltraps>

80106324 <vector37>:
.globl vector37
vector37:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $37
80106326:	6a 25                	push   $0x25
  jmp alltraps
80106328:	e9 c6 f9 ff ff       	jmp    80105cf3 <alltraps>

8010632d <vector38>:
.globl vector38
vector38:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $38
8010632f:	6a 26                	push   $0x26
  jmp alltraps
80106331:	e9 bd f9 ff ff       	jmp    80105cf3 <alltraps>

80106336 <vector39>:
.globl vector39
vector39:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $39
80106338:	6a 27                	push   $0x27
  jmp alltraps
8010633a:	e9 b4 f9 ff ff       	jmp    80105cf3 <alltraps>

8010633f <vector40>:
.globl vector40
vector40:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $40
80106341:	6a 28                	push   $0x28
  jmp alltraps
80106343:	e9 ab f9 ff ff       	jmp    80105cf3 <alltraps>

80106348 <vector41>:
.globl vector41
vector41:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $41
8010634a:	6a 29                	push   $0x29
  jmp alltraps
8010634c:	e9 a2 f9 ff ff       	jmp    80105cf3 <alltraps>

80106351 <vector42>:
.globl vector42
vector42:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $42
80106353:	6a 2a                	push   $0x2a
  jmp alltraps
80106355:	e9 99 f9 ff ff       	jmp    80105cf3 <alltraps>

8010635a <vector43>:
.globl vector43
vector43:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $43
8010635c:	6a 2b                	push   $0x2b
  jmp alltraps
8010635e:	e9 90 f9 ff ff       	jmp    80105cf3 <alltraps>

80106363 <vector44>:
.globl vector44
vector44:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $44
80106365:	6a 2c                	push   $0x2c
  jmp alltraps
80106367:	e9 87 f9 ff ff       	jmp    80105cf3 <alltraps>

8010636c <vector45>:
.globl vector45
vector45:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $45
8010636e:	6a 2d                	push   $0x2d
  jmp alltraps
80106370:	e9 7e f9 ff ff       	jmp    80105cf3 <alltraps>

80106375 <vector46>:
.globl vector46
vector46:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $46
80106377:	6a 2e                	push   $0x2e
  jmp alltraps
80106379:	e9 75 f9 ff ff       	jmp    80105cf3 <alltraps>

8010637e <vector47>:
.globl vector47
vector47:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $47
80106380:	6a 2f                	push   $0x2f
  jmp alltraps
80106382:	e9 6c f9 ff ff       	jmp    80105cf3 <alltraps>

80106387 <vector48>:
.globl vector48
vector48:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $48
80106389:	6a 30                	push   $0x30
  jmp alltraps
8010638b:	e9 63 f9 ff ff       	jmp    80105cf3 <alltraps>

80106390 <vector49>:
.globl vector49
vector49:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $49
80106392:	6a 31                	push   $0x31
  jmp alltraps
80106394:	e9 5a f9 ff ff       	jmp    80105cf3 <alltraps>

80106399 <vector50>:
.globl vector50
vector50:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $50
8010639b:	6a 32                	push   $0x32
  jmp alltraps
8010639d:	e9 51 f9 ff ff       	jmp    80105cf3 <alltraps>

801063a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $51
801063a4:	6a 33                	push   $0x33
  jmp alltraps
801063a6:	e9 48 f9 ff ff       	jmp    80105cf3 <alltraps>

801063ab <vector52>:
.globl vector52
vector52:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $52
801063ad:	6a 34                	push   $0x34
  jmp alltraps
801063af:	e9 3f f9 ff ff       	jmp    80105cf3 <alltraps>

801063b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $53
801063b6:	6a 35                	push   $0x35
  jmp alltraps
801063b8:	e9 36 f9 ff ff       	jmp    80105cf3 <alltraps>

801063bd <vector54>:
.globl vector54
vector54:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $54
801063bf:	6a 36                	push   $0x36
  jmp alltraps
801063c1:	e9 2d f9 ff ff       	jmp    80105cf3 <alltraps>

801063c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $55
801063c8:	6a 37                	push   $0x37
  jmp alltraps
801063ca:	e9 24 f9 ff ff       	jmp    80105cf3 <alltraps>

801063cf <vector56>:
.globl vector56
vector56:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $56
801063d1:	6a 38                	push   $0x38
  jmp alltraps
801063d3:	e9 1b f9 ff ff       	jmp    80105cf3 <alltraps>

801063d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $57
801063da:	6a 39                	push   $0x39
  jmp alltraps
801063dc:	e9 12 f9 ff ff       	jmp    80105cf3 <alltraps>

801063e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $58
801063e3:	6a 3a                	push   $0x3a
  jmp alltraps
801063e5:	e9 09 f9 ff ff       	jmp    80105cf3 <alltraps>

801063ea <vector59>:
.globl vector59
vector59:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $59
801063ec:	6a 3b                	push   $0x3b
  jmp alltraps
801063ee:	e9 00 f9 ff ff       	jmp    80105cf3 <alltraps>

801063f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $60
801063f5:	6a 3c                	push   $0x3c
  jmp alltraps
801063f7:	e9 f7 f8 ff ff       	jmp    80105cf3 <alltraps>

801063fc <vector61>:
.globl vector61
vector61:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $61
801063fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106400:	e9 ee f8 ff ff       	jmp    80105cf3 <alltraps>

80106405 <vector62>:
.globl vector62
vector62:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $62
80106407:	6a 3e                	push   $0x3e
  jmp alltraps
80106409:	e9 e5 f8 ff ff       	jmp    80105cf3 <alltraps>

8010640e <vector63>:
.globl vector63
vector63:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $63
80106410:	6a 3f                	push   $0x3f
  jmp alltraps
80106412:	e9 dc f8 ff ff       	jmp    80105cf3 <alltraps>

80106417 <vector64>:
.globl vector64
vector64:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $64
80106419:	6a 40                	push   $0x40
  jmp alltraps
8010641b:	e9 d3 f8 ff ff       	jmp    80105cf3 <alltraps>

80106420 <vector65>:
.globl vector65
vector65:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $65
80106422:	6a 41                	push   $0x41
  jmp alltraps
80106424:	e9 ca f8 ff ff       	jmp    80105cf3 <alltraps>

80106429 <vector66>:
.globl vector66
vector66:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $66
8010642b:	6a 42                	push   $0x42
  jmp alltraps
8010642d:	e9 c1 f8 ff ff       	jmp    80105cf3 <alltraps>

80106432 <vector67>:
.globl vector67
vector67:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $67
80106434:	6a 43                	push   $0x43
  jmp alltraps
80106436:	e9 b8 f8 ff ff       	jmp    80105cf3 <alltraps>

8010643b <vector68>:
.globl vector68
vector68:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $68
8010643d:	6a 44                	push   $0x44
  jmp alltraps
8010643f:	e9 af f8 ff ff       	jmp    80105cf3 <alltraps>

80106444 <vector69>:
.globl vector69
vector69:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $69
80106446:	6a 45                	push   $0x45
  jmp alltraps
80106448:	e9 a6 f8 ff ff       	jmp    80105cf3 <alltraps>

8010644d <vector70>:
.globl vector70
vector70:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $70
8010644f:	6a 46                	push   $0x46
  jmp alltraps
80106451:	e9 9d f8 ff ff       	jmp    80105cf3 <alltraps>

80106456 <vector71>:
.globl vector71
vector71:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $71
80106458:	6a 47                	push   $0x47
  jmp alltraps
8010645a:	e9 94 f8 ff ff       	jmp    80105cf3 <alltraps>

8010645f <vector72>:
.globl vector72
vector72:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $72
80106461:	6a 48                	push   $0x48
  jmp alltraps
80106463:	e9 8b f8 ff ff       	jmp    80105cf3 <alltraps>

80106468 <vector73>:
.globl vector73
vector73:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $73
8010646a:	6a 49                	push   $0x49
  jmp alltraps
8010646c:	e9 82 f8 ff ff       	jmp    80105cf3 <alltraps>

80106471 <vector74>:
.globl vector74
vector74:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $74
80106473:	6a 4a                	push   $0x4a
  jmp alltraps
80106475:	e9 79 f8 ff ff       	jmp    80105cf3 <alltraps>

8010647a <vector75>:
.globl vector75
vector75:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $75
8010647c:	6a 4b                	push   $0x4b
  jmp alltraps
8010647e:	e9 70 f8 ff ff       	jmp    80105cf3 <alltraps>

80106483 <vector76>:
.globl vector76
vector76:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $76
80106485:	6a 4c                	push   $0x4c
  jmp alltraps
80106487:	e9 67 f8 ff ff       	jmp    80105cf3 <alltraps>

8010648c <vector77>:
.globl vector77
vector77:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $77
8010648e:	6a 4d                	push   $0x4d
  jmp alltraps
80106490:	e9 5e f8 ff ff       	jmp    80105cf3 <alltraps>

80106495 <vector78>:
.globl vector78
vector78:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $78
80106497:	6a 4e                	push   $0x4e
  jmp alltraps
80106499:	e9 55 f8 ff ff       	jmp    80105cf3 <alltraps>

8010649e <vector79>:
.globl vector79
vector79:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $79
801064a0:	6a 4f                	push   $0x4f
  jmp alltraps
801064a2:	e9 4c f8 ff ff       	jmp    80105cf3 <alltraps>

801064a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $80
801064a9:	6a 50                	push   $0x50
  jmp alltraps
801064ab:	e9 43 f8 ff ff       	jmp    80105cf3 <alltraps>

801064b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $81
801064b2:	6a 51                	push   $0x51
  jmp alltraps
801064b4:	e9 3a f8 ff ff       	jmp    80105cf3 <alltraps>

801064b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $82
801064bb:	6a 52                	push   $0x52
  jmp alltraps
801064bd:	e9 31 f8 ff ff       	jmp    80105cf3 <alltraps>

801064c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $83
801064c4:	6a 53                	push   $0x53
  jmp alltraps
801064c6:	e9 28 f8 ff ff       	jmp    80105cf3 <alltraps>

801064cb <vector84>:
.globl vector84
vector84:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $84
801064cd:	6a 54                	push   $0x54
  jmp alltraps
801064cf:	e9 1f f8 ff ff       	jmp    80105cf3 <alltraps>

801064d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $85
801064d6:	6a 55                	push   $0x55
  jmp alltraps
801064d8:	e9 16 f8 ff ff       	jmp    80105cf3 <alltraps>

801064dd <vector86>:
.globl vector86
vector86:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $86
801064df:	6a 56                	push   $0x56
  jmp alltraps
801064e1:	e9 0d f8 ff ff       	jmp    80105cf3 <alltraps>

801064e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $87
801064e8:	6a 57                	push   $0x57
  jmp alltraps
801064ea:	e9 04 f8 ff ff       	jmp    80105cf3 <alltraps>

801064ef <vector88>:
.globl vector88
vector88:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $88
801064f1:	6a 58                	push   $0x58
  jmp alltraps
801064f3:	e9 fb f7 ff ff       	jmp    80105cf3 <alltraps>

801064f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $89
801064fa:	6a 59                	push   $0x59
  jmp alltraps
801064fc:	e9 f2 f7 ff ff       	jmp    80105cf3 <alltraps>

80106501 <vector90>:
.globl vector90
vector90:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $90
80106503:	6a 5a                	push   $0x5a
  jmp alltraps
80106505:	e9 e9 f7 ff ff       	jmp    80105cf3 <alltraps>

8010650a <vector91>:
.globl vector91
vector91:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $91
8010650c:	6a 5b                	push   $0x5b
  jmp alltraps
8010650e:	e9 e0 f7 ff ff       	jmp    80105cf3 <alltraps>

80106513 <vector92>:
.globl vector92
vector92:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $92
80106515:	6a 5c                	push   $0x5c
  jmp alltraps
80106517:	e9 d7 f7 ff ff       	jmp    80105cf3 <alltraps>

8010651c <vector93>:
.globl vector93
vector93:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $93
8010651e:	6a 5d                	push   $0x5d
  jmp alltraps
80106520:	e9 ce f7 ff ff       	jmp    80105cf3 <alltraps>

80106525 <vector94>:
.globl vector94
vector94:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $94
80106527:	6a 5e                	push   $0x5e
  jmp alltraps
80106529:	e9 c5 f7 ff ff       	jmp    80105cf3 <alltraps>

8010652e <vector95>:
.globl vector95
vector95:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $95
80106530:	6a 5f                	push   $0x5f
  jmp alltraps
80106532:	e9 bc f7 ff ff       	jmp    80105cf3 <alltraps>

80106537 <vector96>:
.globl vector96
vector96:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $96
80106539:	6a 60                	push   $0x60
  jmp alltraps
8010653b:	e9 b3 f7 ff ff       	jmp    80105cf3 <alltraps>

80106540 <vector97>:
.globl vector97
vector97:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $97
80106542:	6a 61                	push   $0x61
  jmp alltraps
80106544:	e9 aa f7 ff ff       	jmp    80105cf3 <alltraps>

80106549 <vector98>:
.globl vector98
vector98:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $98
8010654b:	6a 62                	push   $0x62
  jmp alltraps
8010654d:	e9 a1 f7 ff ff       	jmp    80105cf3 <alltraps>

80106552 <vector99>:
.globl vector99
vector99:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $99
80106554:	6a 63                	push   $0x63
  jmp alltraps
80106556:	e9 98 f7 ff ff       	jmp    80105cf3 <alltraps>

8010655b <vector100>:
.globl vector100
vector100:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $100
8010655d:	6a 64                	push   $0x64
  jmp alltraps
8010655f:	e9 8f f7 ff ff       	jmp    80105cf3 <alltraps>

80106564 <vector101>:
.globl vector101
vector101:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $101
80106566:	6a 65                	push   $0x65
  jmp alltraps
80106568:	e9 86 f7 ff ff       	jmp    80105cf3 <alltraps>

8010656d <vector102>:
.globl vector102
vector102:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $102
8010656f:	6a 66                	push   $0x66
  jmp alltraps
80106571:	e9 7d f7 ff ff       	jmp    80105cf3 <alltraps>

80106576 <vector103>:
.globl vector103
vector103:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $103
80106578:	6a 67                	push   $0x67
  jmp alltraps
8010657a:	e9 74 f7 ff ff       	jmp    80105cf3 <alltraps>

8010657f <vector104>:
.globl vector104
vector104:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $104
80106581:	6a 68                	push   $0x68
  jmp alltraps
80106583:	e9 6b f7 ff ff       	jmp    80105cf3 <alltraps>

80106588 <vector105>:
.globl vector105
vector105:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $105
8010658a:	6a 69                	push   $0x69
  jmp alltraps
8010658c:	e9 62 f7 ff ff       	jmp    80105cf3 <alltraps>

80106591 <vector106>:
.globl vector106
vector106:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $106
80106593:	6a 6a                	push   $0x6a
  jmp alltraps
80106595:	e9 59 f7 ff ff       	jmp    80105cf3 <alltraps>

8010659a <vector107>:
.globl vector107
vector107:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $107
8010659c:	6a 6b                	push   $0x6b
  jmp alltraps
8010659e:	e9 50 f7 ff ff       	jmp    80105cf3 <alltraps>

801065a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $108
801065a5:	6a 6c                	push   $0x6c
  jmp alltraps
801065a7:	e9 47 f7 ff ff       	jmp    80105cf3 <alltraps>

801065ac <vector109>:
.globl vector109
vector109:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $109
801065ae:	6a 6d                	push   $0x6d
  jmp alltraps
801065b0:	e9 3e f7 ff ff       	jmp    80105cf3 <alltraps>

801065b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $110
801065b7:	6a 6e                	push   $0x6e
  jmp alltraps
801065b9:	e9 35 f7 ff ff       	jmp    80105cf3 <alltraps>

801065be <vector111>:
.globl vector111
vector111:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $111
801065c0:	6a 6f                	push   $0x6f
  jmp alltraps
801065c2:	e9 2c f7 ff ff       	jmp    80105cf3 <alltraps>

801065c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $112
801065c9:	6a 70                	push   $0x70
  jmp alltraps
801065cb:	e9 23 f7 ff ff       	jmp    80105cf3 <alltraps>

801065d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $113
801065d2:	6a 71                	push   $0x71
  jmp alltraps
801065d4:	e9 1a f7 ff ff       	jmp    80105cf3 <alltraps>

801065d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $114
801065db:	6a 72                	push   $0x72
  jmp alltraps
801065dd:	e9 11 f7 ff ff       	jmp    80105cf3 <alltraps>

801065e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $115
801065e4:	6a 73                	push   $0x73
  jmp alltraps
801065e6:	e9 08 f7 ff ff       	jmp    80105cf3 <alltraps>

801065eb <vector116>:
.globl vector116
vector116:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $116
801065ed:	6a 74                	push   $0x74
  jmp alltraps
801065ef:	e9 ff f6 ff ff       	jmp    80105cf3 <alltraps>

801065f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $117
801065f6:	6a 75                	push   $0x75
  jmp alltraps
801065f8:	e9 f6 f6 ff ff       	jmp    80105cf3 <alltraps>

801065fd <vector118>:
.globl vector118
vector118:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $118
801065ff:	6a 76                	push   $0x76
  jmp alltraps
80106601:	e9 ed f6 ff ff       	jmp    80105cf3 <alltraps>

80106606 <vector119>:
.globl vector119
vector119:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $119
80106608:	6a 77                	push   $0x77
  jmp alltraps
8010660a:	e9 e4 f6 ff ff       	jmp    80105cf3 <alltraps>

8010660f <vector120>:
.globl vector120
vector120:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $120
80106611:	6a 78                	push   $0x78
  jmp alltraps
80106613:	e9 db f6 ff ff       	jmp    80105cf3 <alltraps>

80106618 <vector121>:
.globl vector121
vector121:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $121
8010661a:	6a 79                	push   $0x79
  jmp alltraps
8010661c:	e9 d2 f6 ff ff       	jmp    80105cf3 <alltraps>

80106621 <vector122>:
.globl vector122
vector122:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $122
80106623:	6a 7a                	push   $0x7a
  jmp alltraps
80106625:	e9 c9 f6 ff ff       	jmp    80105cf3 <alltraps>

8010662a <vector123>:
.globl vector123
vector123:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $123
8010662c:	6a 7b                	push   $0x7b
  jmp alltraps
8010662e:	e9 c0 f6 ff ff       	jmp    80105cf3 <alltraps>

80106633 <vector124>:
.globl vector124
vector124:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $124
80106635:	6a 7c                	push   $0x7c
  jmp alltraps
80106637:	e9 b7 f6 ff ff       	jmp    80105cf3 <alltraps>

8010663c <vector125>:
.globl vector125
vector125:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $125
8010663e:	6a 7d                	push   $0x7d
  jmp alltraps
80106640:	e9 ae f6 ff ff       	jmp    80105cf3 <alltraps>

80106645 <vector126>:
.globl vector126
vector126:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $126
80106647:	6a 7e                	push   $0x7e
  jmp alltraps
80106649:	e9 a5 f6 ff ff       	jmp    80105cf3 <alltraps>

8010664e <vector127>:
.globl vector127
vector127:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $127
80106650:	6a 7f                	push   $0x7f
  jmp alltraps
80106652:	e9 9c f6 ff ff       	jmp    80105cf3 <alltraps>

80106657 <vector128>:
.globl vector128
vector128:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $128
80106659:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010665e:	e9 90 f6 ff ff       	jmp    80105cf3 <alltraps>

80106663 <vector129>:
.globl vector129
vector129:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $129
80106665:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010666a:	e9 84 f6 ff ff       	jmp    80105cf3 <alltraps>

8010666f <vector130>:
.globl vector130
vector130:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $130
80106671:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106676:	e9 78 f6 ff ff       	jmp    80105cf3 <alltraps>

8010667b <vector131>:
.globl vector131
vector131:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $131
8010667d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106682:	e9 6c f6 ff ff       	jmp    80105cf3 <alltraps>

80106687 <vector132>:
.globl vector132
vector132:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $132
80106689:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010668e:	e9 60 f6 ff ff       	jmp    80105cf3 <alltraps>

80106693 <vector133>:
.globl vector133
vector133:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $133
80106695:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010669a:	e9 54 f6 ff ff       	jmp    80105cf3 <alltraps>

8010669f <vector134>:
.globl vector134
vector134:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $134
801066a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066a6:	e9 48 f6 ff ff       	jmp    80105cf3 <alltraps>

801066ab <vector135>:
.globl vector135
vector135:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $135
801066ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066b2:	e9 3c f6 ff ff       	jmp    80105cf3 <alltraps>

801066b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $136
801066b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066be:	e9 30 f6 ff ff       	jmp    80105cf3 <alltraps>

801066c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $137
801066c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ca:	e9 24 f6 ff ff       	jmp    80105cf3 <alltraps>

801066cf <vector138>:
.globl vector138
vector138:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $138
801066d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066d6:	e9 18 f6 ff ff       	jmp    80105cf3 <alltraps>

801066db <vector139>:
.globl vector139
vector139:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $139
801066dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066e2:	e9 0c f6 ff ff       	jmp    80105cf3 <alltraps>

801066e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $140
801066e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066ee:	e9 00 f6 ff ff       	jmp    80105cf3 <alltraps>

801066f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $141
801066f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066fa:	e9 f4 f5 ff ff       	jmp    80105cf3 <alltraps>

801066ff <vector142>:
.globl vector142
vector142:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $142
80106701:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106706:	e9 e8 f5 ff ff       	jmp    80105cf3 <alltraps>

8010670b <vector143>:
.globl vector143
vector143:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $143
8010670d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106712:	e9 dc f5 ff ff       	jmp    80105cf3 <alltraps>

80106717 <vector144>:
.globl vector144
vector144:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $144
80106719:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010671e:	e9 d0 f5 ff ff       	jmp    80105cf3 <alltraps>

80106723 <vector145>:
.globl vector145
vector145:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $145
80106725:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010672a:	e9 c4 f5 ff ff       	jmp    80105cf3 <alltraps>

8010672f <vector146>:
.globl vector146
vector146:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $146
80106731:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106736:	e9 b8 f5 ff ff       	jmp    80105cf3 <alltraps>

8010673b <vector147>:
.globl vector147
vector147:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $147
8010673d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106742:	e9 ac f5 ff ff       	jmp    80105cf3 <alltraps>

80106747 <vector148>:
.globl vector148
vector148:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $148
80106749:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010674e:	e9 a0 f5 ff ff       	jmp    80105cf3 <alltraps>

80106753 <vector149>:
.globl vector149
vector149:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $149
80106755:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010675a:	e9 94 f5 ff ff       	jmp    80105cf3 <alltraps>

8010675f <vector150>:
.globl vector150
vector150:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $150
80106761:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106766:	e9 88 f5 ff ff       	jmp    80105cf3 <alltraps>

8010676b <vector151>:
.globl vector151
vector151:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $151
8010676d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106772:	e9 7c f5 ff ff       	jmp    80105cf3 <alltraps>

80106777 <vector152>:
.globl vector152
vector152:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $152
80106779:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010677e:	e9 70 f5 ff ff       	jmp    80105cf3 <alltraps>

80106783 <vector153>:
.globl vector153
vector153:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $153
80106785:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010678a:	e9 64 f5 ff ff       	jmp    80105cf3 <alltraps>

8010678f <vector154>:
.globl vector154
vector154:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $154
80106791:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106796:	e9 58 f5 ff ff       	jmp    80105cf3 <alltraps>

8010679b <vector155>:
.globl vector155
vector155:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $155
8010679d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067a2:	e9 4c f5 ff ff       	jmp    80105cf3 <alltraps>

801067a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $156
801067a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067ae:	e9 40 f5 ff ff       	jmp    80105cf3 <alltraps>

801067b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $157
801067b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ba:	e9 34 f5 ff ff       	jmp    80105cf3 <alltraps>

801067bf <vector158>:
.globl vector158
vector158:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $158
801067c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067c6:	e9 28 f5 ff ff       	jmp    80105cf3 <alltraps>

801067cb <vector159>:
.globl vector159
vector159:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $159
801067cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067d2:	e9 1c f5 ff ff       	jmp    80105cf3 <alltraps>

801067d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $160
801067d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067de:	e9 10 f5 ff ff       	jmp    80105cf3 <alltraps>

801067e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $161
801067e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067ea:	e9 04 f5 ff ff       	jmp    80105cf3 <alltraps>

801067ef <vector162>:
.globl vector162
vector162:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $162
801067f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067f6:	e9 f8 f4 ff ff       	jmp    80105cf3 <alltraps>

801067fb <vector163>:
.globl vector163
vector163:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $163
801067fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106802:	e9 ec f4 ff ff       	jmp    80105cf3 <alltraps>

80106807 <vector164>:
.globl vector164
vector164:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $164
80106809:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010680e:	e9 e0 f4 ff ff       	jmp    80105cf3 <alltraps>

80106813 <vector165>:
.globl vector165
vector165:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $165
80106815:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010681a:	e9 d4 f4 ff ff       	jmp    80105cf3 <alltraps>

8010681f <vector166>:
.globl vector166
vector166:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $166
80106821:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106826:	e9 c8 f4 ff ff       	jmp    80105cf3 <alltraps>

8010682b <vector167>:
.globl vector167
vector167:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $167
8010682d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106832:	e9 bc f4 ff ff       	jmp    80105cf3 <alltraps>

80106837 <vector168>:
.globl vector168
vector168:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $168
80106839:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010683e:	e9 b0 f4 ff ff       	jmp    80105cf3 <alltraps>

80106843 <vector169>:
.globl vector169
vector169:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $169
80106845:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010684a:	e9 a4 f4 ff ff       	jmp    80105cf3 <alltraps>

8010684f <vector170>:
.globl vector170
vector170:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $170
80106851:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106856:	e9 98 f4 ff ff       	jmp    80105cf3 <alltraps>

8010685b <vector171>:
.globl vector171
vector171:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $171
8010685d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106862:	e9 8c f4 ff ff       	jmp    80105cf3 <alltraps>

80106867 <vector172>:
.globl vector172
vector172:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $172
80106869:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010686e:	e9 80 f4 ff ff       	jmp    80105cf3 <alltraps>

80106873 <vector173>:
.globl vector173
vector173:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $173
80106875:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010687a:	e9 74 f4 ff ff       	jmp    80105cf3 <alltraps>

8010687f <vector174>:
.globl vector174
vector174:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $174
80106881:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106886:	e9 68 f4 ff ff       	jmp    80105cf3 <alltraps>

8010688b <vector175>:
.globl vector175
vector175:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $175
8010688d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106892:	e9 5c f4 ff ff       	jmp    80105cf3 <alltraps>

80106897 <vector176>:
.globl vector176
vector176:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $176
80106899:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010689e:	e9 50 f4 ff ff       	jmp    80105cf3 <alltraps>

801068a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $177
801068a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068aa:	e9 44 f4 ff ff       	jmp    80105cf3 <alltraps>

801068af <vector178>:
.globl vector178
vector178:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $178
801068b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068b6:	e9 38 f4 ff ff       	jmp    80105cf3 <alltraps>

801068bb <vector179>:
.globl vector179
vector179:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $179
801068bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068c2:	e9 2c f4 ff ff       	jmp    80105cf3 <alltraps>

801068c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $180
801068c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068ce:	e9 20 f4 ff ff       	jmp    80105cf3 <alltraps>

801068d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $181
801068d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068da:	e9 14 f4 ff ff       	jmp    80105cf3 <alltraps>

801068df <vector182>:
.globl vector182
vector182:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $182
801068e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068e6:	e9 08 f4 ff ff       	jmp    80105cf3 <alltraps>

801068eb <vector183>:
.globl vector183
vector183:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $183
801068ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068f2:	e9 fc f3 ff ff       	jmp    80105cf3 <alltraps>

801068f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $184
801068f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068fe:	e9 f0 f3 ff ff       	jmp    80105cf3 <alltraps>

80106903 <vector185>:
.globl vector185
vector185:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $185
80106905:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010690a:	e9 e4 f3 ff ff       	jmp    80105cf3 <alltraps>

8010690f <vector186>:
.globl vector186
vector186:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $186
80106911:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106916:	e9 d8 f3 ff ff       	jmp    80105cf3 <alltraps>

8010691b <vector187>:
.globl vector187
vector187:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $187
8010691d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106922:	e9 cc f3 ff ff       	jmp    80105cf3 <alltraps>

80106927 <vector188>:
.globl vector188
vector188:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $188
80106929:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010692e:	e9 c0 f3 ff ff       	jmp    80105cf3 <alltraps>

80106933 <vector189>:
.globl vector189
vector189:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $189
80106935:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010693a:	e9 b4 f3 ff ff       	jmp    80105cf3 <alltraps>

8010693f <vector190>:
.globl vector190
vector190:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $190
80106941:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106946:	e9 a8 f3 ff ff       	jmp    80105cf3 <alltraps>

8010694b <vector191>:
.globl vector191
vector191:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $191
8010694d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106952:	e9 9c f3 ff ff       	jmp    80105cf3 <alltraps>

80106957 <vector192>:
.globl vector192
vector192:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $192
80106959:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010695e:	e9 90 f3 ff ff       	jmp    80105cf3 <alltraps>

80106963 <vector193>:
.globl vector193
vector193:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $193
80106965:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010696a:	e9 84 f3 ff ff       	jmp    80105cf3 <alltraps>

8010696f <vector194>:
.globl vector194
vector194:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $194
80106971:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106976:	e9 78 f3 ff ff       	jmp    80105cf3 <alltraps>

8010697b <vector195>:
.globl vector195
vector195:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $195
8010697d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106982:	e9 6c f3 ff ff       	jmp    80105cf3 <alltraps>

80106987 <vector196>:
.globl vector196
vector196:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $196
80106989:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010698e:	e9 60 f3 ff ff       	jmp    80105cf3 <alltraps>

80106993 <vector197>:
.globl vector197
vector197:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $197
80106995:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010699a:	e9 54 f3 ff ff       	jmp    80105cf3 <alltraps>

8010699f <vector198>:
.globl vector198
vector198:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $198
801069a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069a6:	e9 48 f3 ff ff       	jmp    80105cf3 <alltraps>

801069ab <vector199>:
.globl vector199
vector199:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $199
801069ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069b2:	e9 3c f3 ff ff       	jmp    80105cf3 <alltraps>

801069b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $200
801069b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069be:	e9 30 f3 ff ff       	jmp    80105cf3 <alltraps>

801069c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $201
801069c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ca:	e9 24 f3 ff ff       	jmp    80105cf3 <alltraps>

801069cf <vector202>:
.globl vector202
vector202:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $202
801069d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069d6:	e9 18 f3 ff ff       	jmp    80105cf3 <alltraps>

801069db <vector203>:
.globl vector203
vector203:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $203
801069dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069e2:	e9 0c f3 ff ff       	jmp    80105cf3 <alltraps>

801069e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $204
801069e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069ee:	e9 00 f3 ff ff       	jmp    80105cf3 <alltraps>

801069f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $205
801069f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069fa:	e9 f4 f2 ff ff       	jmp    80105cf3 <alltraps>

801069ff <vector206>:
.globl vector206
vector206:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $206
80106a01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a06:	e9 e8 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $207
80106a0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a12:	e9 dc f2 ff ff       	jmp    80105cf3 <alltraps>

80106a17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $208
80106a19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a1e:	e9 d0 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $209
80106a25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a2a:	e9 c4 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $210
80106a31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a36:	e9 b8 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $211
80106a3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a42:	e9 ac f2 ff ff       	jmp    80105cf3 <alltraps>

80106a47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $212
80106a49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a4e:	e9 a0 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $213
80106a55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a5a:	e9 94 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $214
80106a61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a66:	e9 88 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $215
80106a6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a72:	e9 7c f2 ff ff       	jmp    80105cf3 <alltraps>

80106a77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $216
80106a79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a7e:	e9 70 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $217
80106a85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a8a:	e9 64 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $218
80106a91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a96:	e9 58 f2 ff ff       	jmp    80105cf3 <alltraps>

80106a9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $219
80106a9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106aa2:	e9 4c f2 ff ff       	jmp    80105cf3 <alltraps>

80106aa7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $220
80106aa9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106aae:	e9 40 f2 ff ff       	jmp    80105cf3 <alltraps>

80106ab3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $221
80106ab5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aba:	e9 34 f2 ff ff       	jmp    80105cf3 <alltraps>

80106abf <vector222>:
.globl vector222
vector222:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $222
80106ac1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ac6:	e9 28 f2 ff ff       	jmp    80105cf3 <alltraps>

80106acb <vector223>:
.globl vector223
vector223:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $223
80106acd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ad2:	e9 1c f2 ff ff       	jmp    80105cf3 <alltraps>

80106ad7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $224
80106ad9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ade:	e9 10 f2 ff ff       	jmp    80105cf3 <alltraps>

80106ae3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $225
80106ae5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106aea:	e9 04 f2 ff ff       	jmp    80105cf3 <alltraps>

80106aef <vector226>:
.globl vector226
vector226:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $226
80106af1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106af6:	e9 f8 f1 ff ff       	jmp    80105cf3 <alltraps>

80106afb <vector227>:
.globl vector227
vector227:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $227
80106afd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b02:	e9 ec f1 ff ff       	jmp    80105cf3 <alltraps>

80106b07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $228
80106b09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b0e:	e9 e0 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $229
80106b15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b1a:	e9 d4 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $230
80106b21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b26:	e9 c8 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $231
80106b2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b32:	e9 bc f1 ff ff       	jmp    80105cf3 <alltraps>

80106b37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $232
80106b39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b3e:	e9 b0 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $233
80106b45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b4a:	e9 a4 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $234
80106b51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b56:	e9 98 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $235
80106b5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b62:	e9 8c f1 ff ff       	jmp    80105cf3 <alltraps>

80106b67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $236
80106b69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b6e:	e9 80 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $237
80106b75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b7a:	e9 74 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $238
80106b81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b86:	e9 68 f1 ff ff       	jmp    80105cf3 <alltraps>

80106b8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $239
80106b8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b92:	e9 5c f1 ff ff       	jmp    80105cf3 <alltraps>

80106b97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $240
80106b99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b9e:	e9 50 f1 ff ff       	jmp    80105cf3 <alltraps>

80106ba3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $241
80106ba5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106baa:	e9 44 f1 ff ff       	jmp    80105cf3 <alltraps>

80106baf <vector242>:
.globl vector242
vector242:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $242
80106bb1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bb6:	e9 38 f1 ff ff       	jmp    80105cf3 <alltraps>

80106bbb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $243
80106bbd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bc2:	e9 2c f1 ff ff       	jmp    80105cf3 <alltraps>

80106bc7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $244
80106bc9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bce:	e9 20 f1 ff ff       	jmp    80105cf3 <alltraps>

80106bd3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $245
80106bd5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bda:	e9 14 f1 ff ff       	jmp    80105cf3 <alltraps>

80106bdf <vector246>:
.globl vector246
vector246:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $246
80106be1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106be6:	e9 08 f1 ff ff       	jmp    80105cf3 <alltraps>

80106beb <vector247>:
.globl vector247
vector247:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $247
80106bed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bf2:	e9 fc f0 ff ff       	jmp    80105cf3 <alltraps>

80106bf7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $248
80106bf9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bfe:	e9 f0 f0 ff ff       	jmp    80105cf3 <alltraps>

80106c03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $249
80106c05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c0a:	e9 e4 f0 ff ff       	jmp    80105cf3 <alltraps>

80106c0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $250
80106c11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c16:	e9 d8 f0 ff ff       	jmp    80105cf3 <alltraps>

80106c1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $251
80106c1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c22:	e9 cc f0 ff ff       	jmp    80105cf3 <alltraps>

80106c27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $252
80106c29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c2e:	e9 c0 f0 ff ff       	jmp    80105cf3 <alltraps>

80106c33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $253
80106c35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c3a:	e9 b4 f0 ff ff       	jmp    80105cf3 <alltraps>

80106c3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $254
80106c41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c46:	e9 a8 f0 ff ff       	jmp    80105cf3 <alltraps>

80106c4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $255
80106c4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c52:	e9 9c f0 ff ff       	jmp    80105cf3 <alltraps>
80106c57:	66 90                	xchg   %ax,%ax
80106c59:	66 90                	xchg   %ax,%ax
80106c5b:	66 90                	xchg   %ax,%ax
80106c5d:	66 90                	xchg   %ax,%ax
80106c5f:	90                   	nop

80106c60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int hugepage)
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	89 c6                	mov    %eax,%esi
80106c67:	53                   	push   %ebx
80106c68:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  if(hugepage) {
80106c6b:	8b 45 08             	mov    0x8(%ebp),%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int hugepage)
80106c6e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(hugepage) {
80106c71:	85 c0                	test   %eax,%eax
80106c73:	0f 84 7f 00 00 00    	je     80106cf8 <deallocuvm.part.0+0x98>
    // Handle huge pages (4MB)
    a = HUGEPGROUNDUP(newsz);
80106c79:	8d 99 ff ff 3f 00    	lea    0x3fffff(%ecx),%ebx
80106c7f:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
    
    for(; a < oldsz; a += HUGE_PAGE_SIZE) {
80106c85:	39 d3                	cmp    %edx,%ebx
80106c87:	73 5d                	jae    80106ce6 <deallocuvm.part.0+0x86>
80106c89:	89 f7                	mov    %esi,%edi
80106c8b:	eb 0d                	jmp    80106c9a <deallocuvm.part.0+0x3a>
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi
80106c90:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106c96:	39 d3                	cmp    %edx,%ebx
80106c98:	73 4c                	jae    80106ce6 <deallocuvm.part.0+0x86>
      pde_t *pde = &pgdir[PDX(a)];
80106c9a:	89 d8                	mov    %ebx,%eax
80106c9c:	c1 e8 16             	shr    $0x16,%eax
80106c9f:	8d 34 87             	lea    (%edi,%eax,4),%esi
      
      // Check if this PDE is a 4MB page (has PTE_PS set)
      if((*pde & PTE_P) && (*pde & PTE_PS)) {
80106ca2:	8b 06                	mov    (%esi),%eax
80106ca4:	89 c1                	mov    %eax,%ecx
80106ca6:	81 e1 81 00 00 00    	and    $0x81,%ecx
80106cac:	81 f9 81 00 00 00    	cmp    $0x81,%ecx
80106cb2:	75 dc                	jne    80106c90 <deallocuvm.part.0+0x30>
        pa = PTE_ADDR(*pde);
        if(pa == 0)
80106cb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cb9:	0f 84 c5 00 00 00    	je     80106d84 <deallocuvm.part.0+0x124>
          panic("deallocuvm huge: address should exist");
        
        // Free the 4MB page
        khugefree(P2V(pa));
80106cbf:	83 ec 0c             	sub    $0xc,%esp
80106cc2:	05 00 00 00 80       	add    $0x80000000,%eax
80106cc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for(; a < oldsz; a += HUGE_PAGE_SIZE) {
80106cca:	81 c3 00 00 40 00    	add    $0x400000,%ebx
        khugefree(P2V(pa));
80106cd0:	50                   	push   %eax
80106cd1:	e8 8a ba ff ff       	call   80102760 <khugefree>
        *pde = 0;
80106cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106cd9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106cdf:	83 c4 10             	add    $0x10,%esp
    for(; a < oldsz; a += HUGE_PAGE_SIZE) {
80106ce2:	39 d3                	cmp    %edx,%ebx
80106ce4:	72 b4                	jb     80106c9a <deallocuvm.part.0+0x3a>
      }
    }
  }
  
  return newsz;
}
80106ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cec:	5b                   	pop    %ebx
80106ced:	5e                   	pop    %esi
80106cee:	5f                   	pop    %edi
80106cef:	5d                   	pop    %ebp
80106cf0:	c3                   	ret    
80106cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    a = PGROUNDUP(newsz);
80106cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cfb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d01:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for(; a < oldsz; a += PGSIZE) {
80106d07:	39 da                	cmp    %ebx,%edx
80106d09:	76 db                	jbe    80106ce6 <deallocuvm.part.0+0x86>
80106d0b:	89 f7                	mov    %esi,%edi
80106d0d:	eb 0d                	jmp    80106d1c <deallocuvm.part.0+0xbc>
80106d0f:	90                   	nop
        a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d10:	83 c0 01             	add    $0x1,%eax
80106d13:	c1 e0 16             	shl    $0x16,%eax
80106d16:	89 c3                	mov    %eax,%ebx
    for(; a < oldsz; a += PGSIZE) {
80106d18:	39 da                	cmp    %ebx,%edx
80106d1a:	76 ca                	jbe    80106ce6 <deallocuvm.part.0+0x86>
  pde = &pgdir[PDX(va)];
80106d1c:	89 d8                	mov    %ebx,%eax
80106d1e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106d21:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106d24:	f6 c1 01             	test   $0x1,%cl
80106d27:	74 e7                	je     80106d10 <deallocuvm.part.0+0xb0>
  return &pgtab[PTX(va)];
80106d29:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d31:	c1 ee 0a             	shr    $0xa,%esi
80106d34:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d3a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
      if(!pte)
80106d41:	85 f6                	test   %esi,%esi
80106d43:	74 cb                	je     80106d10 <deallocuvm.part.0+0xb0>
      else if((*pte & PTE_P) != 0) {
80106d45:	8b 06                	mov    (%esi),%eax
80106d47:	a8 01                	test   $0x1,%al
80106d49:	75 0d                	jne    80106d58 <deallocuvm.part.0+0xf8>
    for(; a < oldsz; a += PGSIZE) {
80106d4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d51:	eb c5                	jmp    80106d18 <deallocuvm.part.0+0xb8>
80106d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d57:	90                   	nop
        if(pa == 0)
80106d58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5d:	74 32                	je     80106d91 <deallocuvm.part.0+0x131>
        kfree(P2V(pa));
80106d5f:	83 ec 0c             	sub    $0xc,%esp
80106d62:	05 00 00 00 80       	add    $0x80000000,%eax
80106d67:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for(; a < oldsz; a += PGSIZE) {
80106d6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(P2V(pa));
80106d70:	50                   	push   %eax
80106d71:	e8 4a b7 ff ff       	call   801024c0 <kfree>
        *pte = 0;
80106d76:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    for(; a < oldsz; a += PGSIZE) {
80106d7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d7f:	83 c4 10             	add    $0x10,%esp
80106d82:	eb 94                	jmp    80106d18 <deallocuvm.part.0+0xb8>
          panic("deallocuvm huge: address should exist");
80106d84:	83 ec 0c             	sub    $0xc,%esp
80106d87:	68 ec 81 10 80       	push   $0x801081ec
80106d8c:	e8 ef 95 ff ff       	call   80100380 <panic>
          panic("deallocuvm: address should exist");
80106d91:	83 ec 0c             	sub    $0xc,%esp
80106d94:	68 14 82 10 80       	push   $0x80108214
80106d99:	e8 e2 95 ff ff       	call   80100380 <panic>
80106d9e:	66 90                	xchg   %ax,%ax

80106da0 <mappages>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106da6:	89 d3                	mov    %edx,%ebx
80106da8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dae:	83 ec 1c             	sub    $0x1c,%esp
80106db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106db4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106db8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc3:	29 d8                	sub    %ebx,%eax
80106dc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dc8:	eb 3d                	jmp    80106e07 <mappages+0x67>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106dd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106dd7:	c1 ea 0a             	shr    $0xa,%edx
80106dda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106de0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106de7:	85 c0                	test   %eax,%eax
80106de9:	74 75                	je     80106e60 <mappages+0xc0>
    if(*pte & PTE_P)
80106deb:	f6 00 01             	testb  $0x1,(%eax)
80106dee:	0f 85 86 00 00 00    	jne    80106e7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106df4:	0b 75 0c             	or     0xc(%ebp),%esi
80106df7:	83 ce 01             	or     $0x1,%esi
80106dfa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dfc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106dff:	74 6f                	je     80106e70 <mappages+0xd0>
    a += PGSIZE;
80106e01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106e0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106e10:	89 d8                	mov    %ebx,%eax
80106e12:	c1 e8 16             	shr    $0x16,%eax
80106e15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106e18:	8b 07                	mov    (%edi),%eax
80106e1a:	a8 01                	test   $0x1,%al
80106e1c:	75 b2                	jne    80106dd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e1e:	e8 5d b8 ff ff       	call   80102680 <kalloc>
80106e23:	85 c0                	test   %eax,%eax
80106e25:	74 39                	je     80106e60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106e27:	83 ec 04             	sub    $0x4,%esp
80106e2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106e2d:	68 00 10 00 00       	push   $0x1000
80106e32:	6a 00                	push   $0x0
80106e34:	50                   	push   %eax
80106e35:	e8 76 da ff ff       	call   801048b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106e3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e46:	83 c8 07             	or     $0x7,%eax
80106e49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e4b:	89 d8                	mov    %ebx,%eax
80106e4d:	c1 e8 0a             	shr    $0xa,%eax
80106e50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e55:	01 d0                	add    %edx,%eax
80106e57:	eb 92                	jmp    80106deb <mappages+0x4b>
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e68:	5b                   	pop    %ebx
80106e69:	5e                   	pop    %esi
80106e6a:	5f                   	pop    %edi
80106e6b:	5d                   	pop    %ebp
80106e6c:	c3                   	ret    
80106e6d:	8d 76 00             	lea    0x0(%esi),%esi
80106e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e73:	31 c0                	xor    %eax,%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
      panic("remap");
80106e7a:	83 ec 0c             	sub    $0xc,%esp
80106e7d:	68 ff 82 10 80       	push   $0x801082ff
80106e82:	e8 f9 94 ff ff       	call   80100380 <panic>
80106e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e8e:	66 90                	xchg   %ax,%ax

80106e90 <seginit>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e96:	e8 75 cc ff ff       	call   80103b10 <cpuid>
  pd[0] = size-1;
80106e9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ea0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ea6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eaa:	c7 80 78 28 11 80 ff 	movl   $0xffff,-0x7feed788(%eax)
80106eb1:	ff 00 00 
80106eb4:	c7 80 7c 28 11 80 00 	movl   $0xcf9a00,-0x7feed784(%eax)
80106ebb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ebe:	c7 80 80 28 11 80 ff 	movl   $0xffff,-0x7feed780(%eax)
80106ec5:	ff 00 00 
80106ec8:	c7 80 84 28 11 80 00 	movl   $0xcf9200,-0x7feed77c(%eax)
80106ecf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ed2:	c7 80 88 28 11 80 ff 	movl   $0xffff,-0x7feed778(%eax)
80106ed9:	ff 00 00 
80106edc:	c7 80 8c 28 11 80 00 	movl   $0xcffa00,-0x7feed774(%eax)
80106ee3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ee6:	c7 80 90 28 11 80 ff 	movl   $0xffff,-0x7feed770(%eax)
80106eed:	ff 00 00 
80106ef0:	c7 80 94 28 11 80 00 	movl   $0xcff200,-0x7feed76c(%eax)
80106ef7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106efa:	05 70 28 11 80       	add    $0x80112870,%eax
  pd[1] = (uint)p;
80106eff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f03:	c1 e8 10             	shr    $0x10,%eax
80106f06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f0d:	0f 01 10             	lgdtl  (%eax)
}
80106f10:	c9                   	leave  
80106f11:	c3                   	ret    
80106f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f20:	a1 24 56 11 80       	mov    0x80115624,%eax
80106f25:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f2a:	0f 22 d8             	mov    %eax,%cr3
}
80106f2d:	c3                   	ret    
80106f2e:	66 90                	xchg   %ax,%ax

80106f30 <switchuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 1c             	sub    $0x1c,%esp
80106f39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f3c:	85 f6                	test   %esi,%esi
80106f3e:	0f 84 cb 00 00 00    	je     8010700f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f44:	8b 46 0c             	mov    0xc(%esi),%eax
80106f47:	85 c0                	test   %eax,%eax
80106f49:	0f 84 da 00 00 00    	je     80107029 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f4f:	8b 46 08             	mov    0x8(%esi),%eax
80106f52:	85 c0                	test   %eax,%eax
80106f54:	0f 84 c2 00 00 00    	je     8010701c <switchuvm+0xec>
  pushcli();
80106f5a:	e8 41 d7 ff ff       	call   801046a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f5f:	e8 4c cb ff ff       	call   80103ab0 <mycpu>
80106f64:	89 c3                	mov    %eax,%ebx
80106f66:	e8 45 cb ff ff       	call   80103ab0 <mycpu>
80106f6b:	89 c7                	mov    %eax,%edi
80106f6d:	e8 3e cb ff ff       	call   80103ab0 <mycpu>
80106f72:	83 c7 08             	add    $0x8,%edi
80106f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f78:	e8 33 cb ff ff       	call   80103ab0 <mycpu>
80106f7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f80:	ba 67 00 00 00       	mov    $0x67,%edx
80106f85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f8c:	83 c0 08             	add    $0x8,%eax
80106f8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f9b:	83 c1 08             	add    $0x8,%ecx
80106f9e:	c1 e8 18             	shr    $0x18,%eax
80106fa1:	c1 e9 10             	shr    $0x10,%ecx
80106fa4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106faa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fb0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fb5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106fc1:	e8 ea ca ff ff       	call   80103ab0 <mycpu>
80106fc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fcd:	e8 de ca ff ff       	call   80103ab0 <mycpu>
80106fd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fd6:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106fd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fdf:	e8 cc ca ff ff       	call   80103ab0 <mycpu>
80106fe4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fe7:	e8 c4 ca ff ff       	call   80103ab0 <mycpu>
80106fec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ff0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ff5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ff8:	8b 46 08             	mov    0x8(%esi),%eax
80106ffb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107000:	0f 22 d8             	mov    %eax,%cr3
}
80107003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107006:	5b                   	pop    %ebx
80107007:	5e                   	pop    %esi
80107008:	5f                   	pop    %edi
80107009:	5d                   	pop    %ebp
  popcli();
8010700a:	e9 e1 d6 ff ff       	jmp    801046f0 <popcli>
    panic("switchuvm: no process");
8010700f:	83 ec 0c             	sub    $0xc,%esp
80107012:	68 5b 82 10 80       	push   $0x8010825b
80107017:	e8 64 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010701c:	83 ec 0c             	sub    $0xc,%esp
8010701f:	68 86 82 10 80       	push   $0x80108286
80107024:	e8 57 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107029:	83 ec 0c             	sub    $0xc,%esp
8010702c:	68 71 82 10 80       	push   $0x80108271
80107031:	e8 4a 93 ff ff       	call   80100380 <panic>
80107036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <inituvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010704c:	8b 75 10             	mov    0x10(%ebp),%esi
8010704f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107055:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010705b:	77 4b                	ja     801070a8 <inituvm+0x68>
  mem = kalloc();
8010705d:	e8 1e b6 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107062:	83 ec 04             	sub    $0x4,%esp
80107065:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010706a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010706c:	6a 00                	push   $0x0
8010706e:	50                   	push   %eax
8010706f:	e8 3c d8 ff ff       	call   801048b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107074:	58                   	pop    %eax
80107075:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010707b:	5a                   	pop    %edx
8010707c:	6a 06                	push   $0x6
8010707e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107083:	31 d2                	xor    %edx,%edx
80107085:	50                   	push   %eax
80107086:	89 f8                	mov    %edi,%eax
80107088:	e8 13 fd ff ff       	call   80106da0 <mappages>
  memmove(mem, init, sz);
8010708d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107090:	89 75 10             	mov    %esi,0x10(%ebp)
80107093:	83 c4 10             	add    $0x10,%esp
80107096:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107099:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010709c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709f:	5b                   	pop    %ebx
801070a0:	5e                   	pop    %esi
801070a1:	5f                   	pop    %edi
801070a2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070a3:	e9 a8 d8 ff ff       	jmp    80104950 <memmove>
    panic("inituvm: more than a page");
801070a8:	83 ec 0c             	sub    $0xc,%esp
801070ab:	68 9a 82 10 80       	push   $0x8010829a
801070b0:	e8 cb 92 ff ff       	call   80100380 <panic>
801070b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070c0 <loaduvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801070cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070d4:	0f 85 bb 00 00 00    	jne    80107195 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801070da:	01 f0                	add    %esi,%eax
801070dc:	89 f3                	mov    %esi,%ebx
801070de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070e1:	8b 45 14             	mov    0x14(%ebp),%eax
801070e4:	01 f0                	add    %esi,%eax
801070e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070e9:	85 f6                	test   %esi,%esi
801070eb:	0f 84 87 00 00 00    	je     80107178 <loaduvm+0xb8>
801070f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801070f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801070fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801070fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107100:	89 c2                	mov    %eax,%edx
80107102:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107105:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107108:	f6 c2 01             	test   $0x1,%dl
8010710b:	75 13                	jne    80107120 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010710d:	83 ec 0c             	sub    $0xc,%esp
80107110:	68 b4 82 10 80       	push   $0x801082b4
80107115:	e8 66 92 ff ff       	call   80100380 <panic>
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107120:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107123:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107129:	25 fc 0f 00 00       	and    $0xffc,%eax
8010712e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107135:	85 c0                	test   %eax,%eax
80107137:	74 d4                	je     8010710d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107139:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010713b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010713e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107143:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107148:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010714e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107151:	29 d9                	sub    %ebx,%ecx
80107153:	05 00 00 00 80       	add    $0x80000000,%eax
80107158:	57                   	push   %edi
80107159:	51                   	push   %ecx
8010715a:	50                   	push   %eax
8010715b:	ff 75 10             	push   0x10(%ebp)
8010715e:	e8 2d a9 ff ff       	call   80101a90 <readi>
80107163:	83 c4 10             	add    $0x10,%esp
80107166:	39 f8                	cmp    %edi,%eax
80107168:	75 1e                	jne    80107188 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010716a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107170:	89 f0                	mov    %esi,%eax
80107172:	29 d8                	sub    %ebx,%eax
80107174:	39 c6                	cmp    %eax,%esi
80107176:	77 80                	ja     801070f8 <loaduvm+0x38>
}
80107178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010717b:	31 c0                	xor    %eax,%eax
}
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
80107181:	c3                   	ret    
80107182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107188:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010718b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107190:	5b                   	pop    %ebx
80107191:	5e                   	pop    %esi
80107192:	5f                   	pop    %edi
80107193:	5d                   	pop    %ebp
80107194:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107195:	83 ec 0c             	sub    $0xc,%esp
80107198:	68 38 82 10 80       	push   $0x80108238
8010719d:	e8 de 91 ff ff       	call   80100380 <panic>
801071a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <allocuvm>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
{
801071bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071bf:	85 db                	test   %ebx,%ebx
801071c1:	0f 88 df 00 00 00    	js     801072a6 <allocuvm+0xf6>
  if(newsz < oldsz)
801071c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801071ca:	39 45 10             	cmp    %eax,0x10(%ebp)
801071cd:	0f 82 d5 00 00 00    	jb     801072a8 <allocuvm+0xf8>
  if(hugepage) {
801071d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    a = HUGEPGROUNDUP(oldsz);
801071d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(hugepage) {
801071d9:	85 c9                	test   %ecx,%ecx
801071db:	0f 84 cf 00 00 00    	je     801072b0 <allocuvm+0x100>
    a = HUGEPGROUNDUP(oldsz);
801071e1:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
801071e7:	b8 00 00 00 1e       	mov    $0x1e000000,%eax
    uint requested_size = newsz - a;
801071ec:	8b 55 10             	mov    0x10(%ebp),%edx
    a = HUGEPGROUNDUP(oldsz);
801071ef:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801071f5:	39 c3                	cmp    %eax,%ebx
801071f7:	0f 42 d8             	cmovb  %eax,%ebx
      num_pages = num_pages < 2 ? 2 : num_pages;
801071fa:	b8 02 00 00 00       	mov    $0x2,%eax
    uint requested_size = newsz - a;
801071ff:	29 da                	sub    %ebx,%edx
    uint num_pages = (requested_size + HUGE_PAGE_SIZE - 1) / HUGE_PAGE_SIZE;
80107201:	8d b2 ff ff 3f 00    	lea    0x3fffff(%edx),%esi
80107207:	c1 ee 16             	shr    $0x16,%esi
      num_pages = num_pages < 2 ? 2 : num_pages;
8010720a:	39 c6                	cmp    %eax,%esi
8010720c:	0f 43 c6             	cmovae %esi,%eax
8010720f:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
80107215:	0f 47 f0             	cmova  %eax,%esi
    uint target_addr = a + (num_pages * HUGE_PAGE_SIZE);
80107218:	c1 e6 16             	shl    $0x16,%esi
8010721b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
8010721e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(; a < target_addr; a += HUGE_PAGE_SIZE) {
80107221:	39 d8                	cmp    %ebx,%eax
80107223:	77 49                	ja     8010726e <allocuvm+0xbe>
80107225:	e9 1e 01 00 00       	jmp    80107348 <allocuvm+0x198>
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      memset(mem, 0, HUGE_PAGE_SIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
80107233:	68 00 00 40 00       	push   $0x400000
80107238:	6a 00                	push   $0x0
8010723a:	50                   	push   %eax
8010723b:	e8 70 d6 ff ff       	call   801048b0 <memset>
      pde_t *pde = &pgdir[PDX(a)];
80107240:	89 d8                	mov    %ebx,%eax
      if(*pde & PTE_P)
80107242:	83 c4 10             	add    $0x10,%esp
      pde_t *pde = &pgdir[PDX(a)];
80107245:	c1 e8 16             	shr    $0x16,%eax
80107248:	8d 04 87             	lea    (%edi,%eax,4),%eax
      if(*pde & PTE_P)
8010724b:	f6 00 01             	testb  $0x1,(%eax)
8010724e:	0f 85 43 01 00 00    	jne    80107397 <allocuvm+0x1e7>
      *pde = V2P(mem) | PTE_W | PTE_U | PTE_P | PTE_PS;
80107254:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
    for(; a < target_addr; a += HUGE_PAGE_SIZE) {
8010725a:	81 c3 00 00 40 00    	add    $0x400000,%ebx
      *pde = V2P(mem) | PTE_W | PTE_U | PTE_P | PTE_PS;
80107260:	80 ca 87             	or     $0x87,%dl
80107263:	89 10                	mov    %edx,(%eax)
    for(; a < target_addr; a += HUGE_PAGE_SIZE) {
80107265:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80107268:	0f 86 da 00 00 00    	jbe    80107348 <allocuvm+0x198>
      mem = khugealloc();
8010726e:	e8 7d b4 ff ff       	call   801026f0 <khugealloc>
80107273:	89 c6                	mov    %eax,%esi
      if(mem == 0) {
80107275:	85 c0                	test   %eax,%eax
80107277:	75 b7                	jne    80107230 <allocuvm+0x80>
        cprintf("allocuvm huge: out of memory\n");
80107279:	83 ec 0c             	sub    $0xc,%esp
8010727c:	68 d2 82 10 80       	push   $0x801082d2
80107281:	e8 1a 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107286:	8b 45 0c             	mov    0xc(%ebp),%eax
80107289:	83 c4 10             	add    $0x10,%esp
8010728c:	39 45 10             	cmp    %eax,0x10(%ebp)
8010728f:	74 15                	je     801072a6 <allocuvm+0xf6>
80107291:	83 ec 0c             	sub    $0xc,%esp
80107294:	ff 75 14             	push   0x14(%ebp)
80107297:	8b 55 10             	mov    0x10(%ebp),%edx
8010729a:	89 c1                	mov    %eax,%ecx
8010729c:	89 f8                	mov    %edi,%eax
8010729e:	e8 bd f9 ff ff       	call   80106c60 <deallocuvm.part.0>
801072a3:	83 c4 10             	add    $0x10,%esp
        return 0;
801072a6:	31 c0                	xor    %eax,%eax
}
801072a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ab:	5b                   	pop    %ebx
801072ac:	5e                   	pop    %esi
801072ad:	5f                   	pop    %edi
801072ae:	5d                   	pop    %ebp
801072af:	c3                   	ret    
    a = PGROUNDUP(oldsz);
801072b0:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
    uint target_size = (newsz < oldsz + 8 * PGSIZE) ? (oldsz + 8 * PGSIZE) : newsz;
801072b6:	05 00 80 00 00       	add    $0x8000,%eax
    a = PGROUNDUP(oldsz);
801072bb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    uint target_size = (newsz < oldsz + 8 * PGSIZE) ? (oldsz + 8 * PGSIZE) : newsz;
801072c1:	3b 45 10             	cmp    0x10(%ebp),%eax
801072c4:	0f 42 45 10          	cmovb  0x10(%ebp),%eax
801072c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(; a < target_size; a += PGSIZE) {
801072cb:	39 c6                	cmp    %eax,%esi
801072cd:	72 44                	jb     80107313 <allocuvm+0x163>
801072cf:	eb 77                	jmp    80107348 <allocuvm+0x198>
801072d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      memset(mem, 0, PGSIZE);
801072d8:	83 ec 04             	sub    $0x4,%esp
801072db:	68 00 10 00 00       	push   $0x1000
801072e0:	6a 00                	push   $0x0
801072e2:	50                   	push   %eax
801072e3:	e8 c8 d5 ff ff       	call   801048b0 <memset>
      if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0) {
801072e8:	58                   	pop    %eax
801072e9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072ef:	5a                   	pop    %edx
801072f0:	6a 06                	push   $0x6
801072f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072f7:	89 f2                	mov    %esi,%edx
801072f9:	50                   	push   %eax
801072fa:	89 f8                	mov    %edi,%eax
801072fc:	e8 9f fa ff ff       	call   80106da0 <mappages>
80107301:	83 c4 10             	add    $0x10,%esp
80107304:	85 c0                	test   %eax,%eax
80107306:	78 50                	js     80107358 <allocuvm+0x1a8>
    for(; a < target_size; a += PGSIZE) {
80107308:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010730e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80107311:	76 35                	jbe    80107348 <allocuvm+0x198>
      mem = kalloc();
80107313:	e8 68 b3 ff ff       	call   80102680 <kalloc>
80107318:	89 c3                	mov    %eax,%ebx
      if(mem == 0) {
8010731a:	85 c0                	test   %eax,%eax
8010731c:	75 ba                	jne    801072d8 <allocuvm+0x128>
        cprintf("allocuvm out of memory\n");
8010731e:	83 ec 0c             	sub    $0xc,%esp
80107321:	68 05 83 10 80       	push   $0x80108305
80107326:	e8 75 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010732b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010732e:	83 c4 10             	add    $0x10,%esp
80107331:	39 45 10             	cmp    %eax,0x10(%ebp)
80107334:	0f 84 6c ff ff ff    	je     801072a6 <allocuvm+0xf6>
8010733a:	83 ec 0c             	sub    $0xc,%esp
8010733d:	6a 00                	push   $0x0
8010733f:	e9 53 ff ff ff       	jmp    80107297 <allocuvm+0xe7>
80107344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return target_size;
80107348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010734b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734e:	5b                   	pop    %ebx
8010734f:	5e                   	pop    %esi
80107350:	5f                   	pop    %edi
80107351:	5d                   	pop    %ebp
80107352:	c3                   	ret    
80107353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107357:	90                   	nop
        cprintf("allocuvm out of memory (2)\n");
80107358:	83 ec 0c             	sub    $0xc,%esp
8010735b:	68 1d 83 10 80       	push   $0x8010831d
80107360:	e8 3b 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107365:	8b 45 0c             	mov    0xc(%ebp),%eax
80107368:	83 c4 10             	add    $0x10,%esp
8010736b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010736e:	74 14                	je     80107384 <allocuvm+0x1d4>
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	8b 55 10             	mov    0x10(%ebp),%edx
80107376:	89 c1                	mov    %eax,%ecx
80107378:	89 f8                	mov    %edi,%eax
8010737a:	6a 00                	push   $0x0
8010737c:	e8 df f8 ff ff       	call   80106c60 <deallocuvm.part.0>
80107381:	83 c4 10             	add    $0x10,%esp
        kfree(mem);
80107384:	83 ec 0c             	sub    $0xc,%esp
80107387:	53                   	push   %ebx
80107388:	e8 33 b1 ff ff       	call   801024c0 <kfree>
        return 0;
8010738d:	83 c4 10             	add    $0x10,%esp
80107390:	31 c0                	xor    %eax,%eax
80107392:	e9 11 ff ff ff       	jmp    801072a8 <allocuvm+0xf8>
        panic("allocuvm huge: remap");
80107397:	83 ec 0c             	sub    $0xc,%esp
8010739a:	68 f0 82 10 80       	push   $0x801082f0
8010739f:	e8 dc 8f ff ff       	call   80100380 <panic>
801073a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop

801073b0 <deallocuvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	53                   	push   %ebx
801073b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801073b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073ba:	8b 45 08             	mov    0x8(%ebp),%eax
801073bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  if(newsz >= oldsz)
801073c0:	39 d1                	cmp    %edx,%ecx
801073c2:	73 0c                	jae    801073d0 <deallocuvm+0x20>
801073c4:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073ca:	c9                   	leave  
801073cb:	e9 90 f8 ff ff       	jmp    80106c60 <deallocuvm.part.0>
801073d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073d3:	89 d0                	mov    %edx,%eax
801073d5:	c9                   	leave  
801073d6:	c3                   	ret    
801073d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073de:	66 90                	xchg   %ax,%ax

801073e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
801073e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801073ec:	85 f6                	test   %esi,%esi
801073ee:	0f 84 c2 00 00 00    	je     801074b6 <freevm+0xd6>
  if(newsz >= oldsz)
801073f4:	83 ec 0c             	sub    $0xc,%esp
801073f7:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073fc:	31 c9                	xor    %ecx,%ecx
801073fe:	89 f0                	mov    %esi,%eax
80107400:	6a 00                	push   $0x0
80107402:	e8 59 f8 ff ff       	call   80106c60 <deallocuvm.part.0>
  
  // Free regular user pages
  deallocuvm(pgdir, KERNBASE, 0, 0);
  
  // Free huge pages
  deallocuvm(pgdir, myproc()->hugesz, 0, 1);
80107407:	e8 24 c7 ff ff       	call   80103b30 <myproc>
  if(newsz >= oldsz)
8010740c:	83 c4 10             	add    $0x10,%esp
  deallocuvm(pgdir, myproc()->hugesz, 0, 1);
8010740f:	8b 50 04             	mov    0x4(%eax),%edx
  if(newsz >= oldsz)
80107412:	85 d2                	test   %edx,%edx
80107414:	74 5c                	je     80107472 <freevm+0x92>
    a = HUGEPGROUNDUP(newsz);
80107416:	31 db                	xor    %ebx,%ebx
80107418:	eb 10                	jmp    8010742a <freevm+0x4a>
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(; a < oldsz; a += HUGE_PAGE_SIZE) {
80107420:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80107426:	39 da                	cmp    %ebx,%edx
80107428:	76 48                	jbe    80107472 <freevm+0x92>
      pde_t *pde = &pgdir[PDX(a)];
8010742a:	89 d8                	mov    %ebx,%eax
8010742c:	c1 e8 16             	shr    $0x16,%eax
8010742f:	8d 3c 86             	lea    (%esi,%eax,4),%edi
      if((*pde & PTE_P) && (*pde & PTE_PS)) {
80107432:	8b 07                	mov    (%edi),%eax
80107434:	89 c1                	mov    %eax,%ecx
80107436:	81 e1 81 00 00 00    	and    $0x81,%ecx
8010743c:	81 f9 81 00 00 00    	cmp    $0x81,%ecx
80107442:	75 dc                	jne    80107420 <freevm+0x40>
        if(pa == 0)
80107444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107449:	74 78                	je     801074c3 <freevm+0xe3>
        khugefree(P2V(pa));
8010744b:	83 ec 0c             	sub    $0xc,%esp
8010744e:	05 00 00 00 80       	add    $0x80000000,%eax
80107453:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for(; a < oldsz; a += HUGE_PAGE_SIZE) {
80107456:	81 c3 00 00 40 00    	add    $0x400000,%ebx
        khugefree(P2V(pa));
8010745c:	50                   	push   %eax
8010745d:	e8 fe b2 ff ff       	call   80102760 <khugefree>
        *pde = 0;
80107462:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107465:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010746b:	83 c4 10             	add    $0x10,%esp
    for(; a < oldsz; a += HUGE_PAGE_SIZE) {
8010746e:	39 da                	cmp    %ebx,%edx
80107470:	77 b8                	ja     8010742a <freevm+0x4a>
80107472:	89 f3                	mov    %esi,%ebx
80107474:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Free page tables
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
80107480:	8b 03                	mov    (%ebx),%eax
80107482:	a8 01                	test   $0x1,%al
80107484:	74 1a                	je     801074a0 <freevm+0xc0>
      // Skip huge pages (they don't have page tables)
      if(pgdir[i] & PTE_PS)
80107486:	a8 80                	test   $0x80,%al
80107488:	75 16                	jne    801074a0 <freevm+0xc0>
        continue;
        
      char *v = P2V(PTE_ADDR(pgdir[i]));
8010748a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
8010748f:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107492:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107497:	50                   	push   %eax
80107498:	e8 23 b0 ff ff       	call   801024c0 <kfree>
8010749d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074a0:	83 c3 04             	add    $0x4,%ebx
801074a3:	39 df                	cmp    %ebx,%edi
801074a5:	75 d9                	jne    80107480 <freevm+0xa0>
    }
  }
  kfree((char*)pgdir);
801074a7:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074b1:	e9 0a b0 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	68 39 83 10 80       	push   $0x80108339
801074be:	e8 bd 8e ff ff       	call   80100380 <panic>
          panic("deallocuvm huge: address should exist");
801074c3:	83 ec 0c             	sub    $0xc,%esp
801074c6:	68 ec 81 10 80       	push   $0x801081ec
801074cb:	e8 b0 8e ff ff       	call   80100380 <panic>

801074d0 <setupkvm>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	56                   	push   %esi
801074d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801074d5:	e8 a6 b1 ff ff       	call   80102680 <kalloc>
801074da:	89 c6                	mov    %eax,%esi
801074dc:	85 c0                	test   %eax,%eax
801074de:	74 42                	je     80107522 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801074e0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801074e8:	68 00 10 00 00       	push   $0x1000
801074ed:	6a 00                	push   $0x0
801074ef:	50                   	push   %eax
801074f0:	e8 bb d3 ff ff       	call   801048b0 <memset>
801074f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801074f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074fb:	83 ec 08             	sub    $0x8,%esp
801074fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107501:	ff 73 0c             	push   0xc(%ebx)
80107504:	8b 13                	mov    (%ebx),%edx
80107506:	50                   	push   %eax
80107507:	29 c1                	sub    %eax,%ecx
80107509:	89 f0                	mov    %esi,%eax
8010750b:	e8 90 f8 ff ff       	call   80106da0 <mappages>
80107510:	83 c4 10             	add    $0x10,%esp
80107513:	85 c0                	test   %eax,%eax
80107515:	78 19                	js     80107530 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107517:	83 c3 10             	add    $0x10,%ebx
8010751a:	81 fb 70 b4 10 80    	cmp    $0x8010b470,%ebx
80107520:	75 d6                	jne    801074f8 <setupkvm+0x28>
}
80107522:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107525:	89 f0                	mov    %esi,%eax
80107527:	5b                   	pop    %ebx
80107528:	5e                   	pop    %esi
80107529:	5d                   	pop    %ebp
8010752a:	c3                   	ret    
8010752b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010752f:	90                   	nop
      freevm(pgdir);
80107530:	83 ec 0c             	sub    $0xc,%esp
80107533:	56                   	push   %esi
      return 0;
80107534:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107536:	e8 a5 fe ff ff       	call   801073e0 <freevm>
      return 0;
8010753b:	83 c4 10             	add    $0x10,%esp
}
8010753e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107541:	89 f0                	mov    %esi,%eax
80107543:	5b                   	pop    %ebx
80107544:	5e                   	pop    %esi
80107545:	5d                   	pop    %ebp
80107546:	c3                   	ret    
80107547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754e:	66 90                	xchg   %ax,%ax

80107550 <kvmalloc>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107556:	e8 75 ff ff ff       	call   801074d0 <setupkvm>
8010755b:	a3 24 56 11 80       	mov    %eax,0x80115624
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107560:	05 00 00 00 80       	add    $0x80000000,%eax
80107565:	0f 22 d8             	mov    %eax,%cr3
}
80107568:	c9                   	leave  
80107569:	c3                   	ret    
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	83 ec 08             	sub    $0x8,%esp
80107576:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107579:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010757c:	89 c1                	mov    %eax,%ecx
8010757e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107581:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107584:	f6 c2 01             	test   $0x1,%dl
80107587:	75 17                	jne    801075a0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107589:	83 ec 0c             	sub    $0xc,%esp
8010758c:	68 4a 83 10 80       	push   $0x8010834a
80107591:	e8 ea 8d ff ff       	call   80100380 <panic>
80107596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010759d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801075a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801075a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801075ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801075b5:	85 c0                	test   %eax,%eax
801075b7:	74 d0                	je     80107589 <clearpteu+0x19>
  *pte &= ~PTE_U;
801075b9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075bc:	c9                   	leave  
801075bd:	c3                   	ret    
801075be:	66 90                	xchg   %ax,%ax

801075c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	57                   	push   %edi
801075c4:	56                   	push   %esi
801075c5:	53                   	push   %ebx
801075c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075c9:	e8 02 ff ff ff       	call   801074d0 <setupkvm>
801075ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075d1:	85 c0                	test   %eax,%eax
801075d3:	0f 84 e8 00 00 00    	je     801076c1 <copyuvm+0x101>
    return 0;
    
  // Copy regular pages (existing code is correct)
  for(i = 0; i < sz; i += PGSIZE){
801075d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075dc:	85 c9                	test   %ecx,%ecx
801075de:	0f 84 fb 00 00 00    	je     801076df <copyuvm+0x11f>
    // ... existing code ...
    for(i = 0; i < sz; i += PGSIZE){
801075e4:	31 f6                	xor    %esi,%esi
801075e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801075f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801075f3:	89 f0                	mov    %esi,%eax
801075f5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801075f8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801075fb:	a8 01                	test   $0x1,%al
801075fd:	75 11                	jne    80107610 <copyuvm+0x50>
      if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
        panic("copyuvm: pte should exist");
801075ff:	83 ec 0c             	sub    $0xc,%esp
80107602:	68 54 83 10 80       	push   $0x80108354
80107607:	e8 74 8d ff ff       	call   80100380 <panic>
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107610:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107612:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107617:	c1 ea 0a             	shr    $0xa,%edx
8010761a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107620:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
      if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107627:	85 c0                	test   %eax,%eax
80107629:	74 d4                	je     801075ff <copyuvm+0x3f>
      if(!(*pte & PTE_P))
8010762b:	8b 00                	mov    (%eax),%eax
8010762d:	a8 01                	test   $0x1,%al
8010762f:	0f 84 47 01 00 00    	je     8010777c <copyuvm+0x1bc>
        panic("copyuvm: page not present");
      pa = PTE_ADDR(*pte);
80107635:	89 c7                	mov    %eax,%edi
      flags = PTE_FLAGS(*pte);
80107637:	25 ff 0f 00 00       	and    $0xfff,%eax
8010763c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
8010763f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      if((mem = kalloc()) == 0)
80107645:	e8 36 b0 ff ff       	call   80102680 <kalloc>
8010764a:	89 c3                	mov    %eax,%ebx
8010764c:	85 c0                	test   %eax,%eax
8010764e:	74 5c                	je     801076ac <copyuvm+0xec>
        goto bad;
      memmove(mem, (char*)P2V(pa), PGSIZE);
80107650:	83 ec 04             	sub    $0x4,%esp
80107653:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107659:	68 00 10 00 00       	push   $0x1000
8010765e:	57                   	push   %edi
8010765f:	50                   	push   %eax
80107660:	e8 eb d2 ff ff       	call   80104950 <memmove>
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107665:	58                   	pop    %eax
80107666:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010766c:	5a                   	pop    %edx
8010766d:	ff 75 e4             	push   -0x1c(%ebp)
80107670:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107675:	89 f2                	mov    %esi,%edx
80107677:	50                   	push   %eax
80107678:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010767b:	e8 20 f7 ff ff       	call   80106da0 <mappages>
80107680:	83 c4 10             	add    $0x10,%esp
80107683:	85 c0                	test   %eax,%eax
80107685:	78 19                	js     801076a0 <copyuvm+0xe0>
    for(i = 0; i < sz; i += PGSIZE){
80107687:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
8010768d:	39 45 0c             	cmp    %eax,0xc(%ebp)
80107690:	76 3e                	jbe    801076d0 <copyuvm+0x110>
80107692:	89 c6                	mov    %eax,%esi
80107694:	e9 57 ff ff ff       	jmp    801075f0 <copyuvm+0x30>
80107699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(mem);
801076a0:	83 ec 0c             	sub    $0xc,%esp
801076a3:	53                   	push   %ebx
801076a4:	e8 17 ae ff ff       	call   801024c0 <kfree>
        goto bad;
801076a9:	83 c4 10             	add    $0x10,%esp
  }
  
  return d;

bad:
  freevm(d);
801076ac:	83 ec 0c             	sub    $0xc,%esp
801076af:	ff 75 e0             	push   -0x20(%ebp)
801076b2:	e8 29 fd ff ff       	call   801073e0 <freevm>
  return 0;
801076b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801076be:	83 c4 10             	add    $0x10,%esp
}
801076c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c7:	5b                   	pop    %ebx
801076c8:	5e                   	pop    %esi
801076c9:	5f                   	pop    %edi
801076ca:	5d                   	pop    %ebp
801076cb:	c3                   	ret    
801076cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < sz; i += PGSIZE){
801076d0:	81 c6 00 20 00 00    	add    $0x2000,%esi
801076d6:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076d9:	0f 87 05 ff ff ff    	ja     801075e4 <copyuvm+0x24>
  struct proc *curproc = myproc();
801076df:	e8 4c c4 ff ff       	call   80103b30 <myproc>
  if(curproc->hugesz > 0) {
801076e4:	81 78 04 00 00 00 1e 	cmpl   $0x1e000000,0x4(%eax)
801076eb:	76 d4                	jbe    801076c1 <copyuvm+0x101>
    for(i = HUGE_VA_OFFSET; i < curproc->hugesz; i += HUGE_PAGE_SIZE) {
801076ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
801076f0:	be 00 00 00 1e       	mov    $0x1e000000,%esi
801076f5:	89 c2                	mov    %eax,%edx
801076f7:	eb 12                	jmp    8010770b <copyuvm+0x14b>
801076f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107700:	81 c6 00 00 40 00    	add    $0x400000,%esi
80107706:	39 72 04             	cmp    %esi,0x4(%edx)
80107709:	76 b6                	jbe    801076c1 <copyuvm+0x101>
      pde_t *pde = &pgdir[PDX(i)];
8010770b:	89 f7                	mov    %esi,%edi
8010770d:	c1 ef 16             	shr    $0x16,%edi
      if((*pde & PTE_P) && (*pde & PTE_PS)) {
80107710:	8b 04 b9             	mov    (%ecx,%edi,4),%eax
80107713:	89 c3                	mov    %eax,%ebx
80107715:	81 e3 81 00 00 00    	and    $0x81,%ebx
8010771b:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
80107721:	75 dd                	jne    80107700 <copyuvm+0x140>
80107723:	89 4d 08             	mov    %ecx,0x8(%ebp)
        pa = PTE_ADDR(*pde);
80107726:	89 c1                	mov    %eax,%ecx
        flags = PTE_FLAGS(*pde);
80107728:	25 ff 0f 00 00       	and    $0xfff,%eax
        pa = PTE_ADDR(*pde);
8010772d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107733:	89 55 d8             	mov    %edx,-0x28(%ebp)
80107736:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        flags = PTE_FLAGS(*pde);
80107739:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if((mem = khugealloc()) == 0)
8010773c:	e8 af af ff ff       	call   801026f0 <khugealloc>
80107741:	89 c3                	mov    %eax,%ebx
80107743:	85 c0                	test   %eax,%eax
80107745:	0f 84 61 ff ff ff    	je     801076ac <copyuvm+0xec>
        memmove(mem, (char*)P2V(pa),HUGE_PAGE_SIZE);
8010774b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010774e:	83 ec 04             	sub    $0x4,%esp
80107751:	68 00 00 40 00       	push   $0x400000
80107756:	05 00 00 00 80       	add    $0x80000000,%eax
8010775b:	50                   	push   %eax
8010775c:	53                   	push   %ebx
        *d_pde = V2P(mem) | flags;
8010775d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        memmove(mem, (char*)P2V(pa),HUGE_PAGE_SIZE);
80107763:	e8 e8 d1 ff ff       	call   80104950 <memmove>
        *d_pde = V2P(mem) | flags;
80107768:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010776b:	0b 5d dc             	or     -0x24(%ebp),%ebx
8010776e:	83 c4 10             	add    $0x10,%esp
80107771:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107774:	8b 55 d8             	mov    -0x28(%ebp),%edx
80107777:	89 1c b8             	mov    %ebx,(%eax,%edi,4)
8010777a:	eb 84                	jmp    80107700 <copyuvm+0x140>
        panic("copyuvm: page not present");
8010777c:	83 ec 0c             	sub    $0xc,%esp
8010777f:	68 6e 83 10 80       	push   $0x8010836e
80107784:	e8 f7 8b ff ff       	call   80100380 <panic>
80107789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107790 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107796:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107799:	89 c1                	mov    %eax,%ecx
8010779b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010779e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801077a1:	f6 c2 01             	test   $0x1,%dl
801077a4:	0f 84 00 01 00 00    	je     801078aa <uva2ka.cold>
  return &pgtab[PTX(va)];
801077aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801077b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801077b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801077b9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801077c0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801077c7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077ca:	05 00 00 00 80       	add    $0x80000000,%eax
801077cf:	83 fa 05             	cmp    $0x5,%edx
801077d2:	ba 00 00 00 00       	mov    $0x0,%edx
801077d7:	0f 45 c2             	cmovne %edx,%eax
}
801077da:	c3                   	ret    
801077db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077df:	90                   	nop

801077e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 0c             	sub    $0xc,%esp
801077e9:	8b 75 14             	mov    0x14(%ebp),%esi
801077ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801077ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077f2:	85 f6                	test   %esi,%esi
801077f4:	75 51                	jne    80107847 <copyout+0x67>
801077f6:	e9 a5 00 00 00       	jmp    801078a0 <copyout+0xc0>
801077fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107800:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107806:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010780c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107812:	74 75                	je     80107889 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107814:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107816:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107819:	29 c3                	sub    %eax,%ebx
8010781b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107821:	39 f3                	cmp    %esi,%ebx
80107823:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107826:	29 f8                	sub    %edi,%eax
80107828:	83 ec 04             	sub    $0x4,%esp
8010782b:	01 c1                	add    %eax,%ecx
8010782d:	53                   	push   %ebx
8010782e:	52                   	push   %edx
8010782f:	51                   	push   %ecx
80107830:	e8 1b d1 ff ff       	call   80104950 <memmove>
    len -= n;
    buf += n;
80107835:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107838:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010783e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107841:	01 da                	add    %ebx,%edx
  while(len > 0){
80107843:	29 de                	sub    %ebx,%esi
80107845:	74 59                	je     801078a0 <copyout+0xc0>
  if(*pde & PTE_P){
80107847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010784a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010784c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010784e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107851:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107857:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010785a:	f6 c1 01             	test   $0x1,%cl
8010785d:	0f 84 4e 00 00 00    	je     801078b1 <copyout.cold>
  return &pgtab[PTX(va)];
80107863:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107865:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010786b:	c1 eb 0c             	shr    $0xc,%ebx
8010786e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107874:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010787b:	89 d9                	mov    %ebx,%ecx
8010787d:	83 e1 05             	and    $0x5,%ecx
80107880:	83 f9 05             	cmp    $0x5,%ecx
80107883:	0f 84 77 ff ff ff    	je     80107800 <copyout+0x20>
  }
  return 0;
}
80107889:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010788c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107891:	5b                   	pop    %ebx
80107892:	5e                   	pop    %esi
80107893:	5f                   	pop    %edi
80107894:	5d                   	pop    %ebp
80107895:	c3                   	ret    
80107896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789d:	8d 76 00             	lea    0x0(%esi),%esi
801078a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078a3:	31 c0                	xor    %eax,%eax
}
801078a5:	5b                   	pop    %ebx
801078a6:	5e                   	pop    %esi
801078a7:	5f                   	pop    %edi
801078a8:	5d                   	pop    %ebp
801078a9:	c3                   	ret    

801078aa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801078aa:	a1 00 00 00 00       	mov    0x0,%eax
801078af:	0f 0b                	ud2    

801078b1 <copyout.cold>:
801078b1:	a1 00 00 00 00       	mov    0x0,%eax
801078b6:	0f 0b                	ud2    
