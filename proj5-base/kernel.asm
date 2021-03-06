
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 2e 10 80       	mov    $0x80102ed0,%eax
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
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 a5 47 00 00       	call   80104800 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 53 46 00 00       	call   801046f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 07 48 00 00       	call   801048f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 a9 48 00 00       	call   80104a10 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 45 00 00       	call   80104730 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 74 10 80       	push   $0x801074ee
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 46 00 00       	call   801047d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 74 10 80       	push   $0x801074ff
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 45 00 00       	call   801047d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 45 00 00       	call   80104790 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 e0 46 00 00       	call   801048f0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 47 00 00       	jmp    80104a10 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 75 10 80       	push   $0x80107506
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 5f 46 00 00       	call   801048f0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002a7:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002c5:	e8 16 3b 00 00       	call   80103de0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 35 00 00       	call   80103810 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 1c 47 00 00       	call   80104a10 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 be 46 00 00       	call   80104a10 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 75 10 80       	push   $0x8010750d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 3b 7f 10 80 	movl   $0x80107f3b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 43 44 00 00       	call   80104820 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 75 10 80       	push   $0x80107521
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 c1 5c 00 00       	call   80106100 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 0f 5c 00 00       	call   80106100 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 5c 00 00       	call   80106100 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 5b 00 00       	call   80106100 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 f7 45 00 00       	call   80104b20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 2a 45 00 00       	call   80104a70 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 75 10 80       	push   $0x80107525
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 d0 42 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 c4 43 00 00       	call   80104a10 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 ec 42 00 00       	call   80104a10 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 38 75 10 80       	mov    $0x80107538,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 fb 40 00 00       	call   801048f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 75 10 80       	push   $0x8010753f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 c8 40 00 00       	call   801048f0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100856:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 83 41 00 00       	call   80104a10 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100911:	68 c0 ff 10 80       	push   $0x8010ffc0
80100916:	e8 75 36 00 00       	call   80103f90 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010093d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100964:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 d4 36 00 00       	jmp    80104070 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 48 75 10 80       	push   $0x80107548
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 2b 3e 00 00       	call   80104800 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 ef 2d 00 00       	call   80103810 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 84 21 00 00       	call   80102bb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 ac 21 00 00       	call   80102c20 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 b7 67 00 00       	call   80107250 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 75 65 00 00       	call   80107070 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 83 64 00 00       	call   80106fb0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 59 66 00 00       	call   801071d0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 c1 64 00 00       	call   80107070 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 0a 66 00 00       	call   801071d0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 61 75 10 80       	push   $0x80107561
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 e5 66 00 00       	call   801072f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 52 40 00 00       	call   80104c90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 40 00 00       	call   80104c90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 de 67 00 00       	call   80107440 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 74 67 00 00       	call   80107440 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 41 3f 00 00       	call   80104c50 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 e7 60 00 00       	call   80106e20 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 8f 64 00 00       	call   801071d0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 6d 75 10 80       	push   $0x8010756d
80100d6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d70:	e8 8b 3a 00 00       	call   80104800 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 5a 3b 00 00       	call   801048f0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc1:	e8 4a 3c 00 00       	call   80104a10 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dda:	e8 31 3c 00 00       	call   80104a10 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dff:	e8 ec 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e1c:	e8 ef 3b 00 00       	call   80104a10 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 74 75 10 80       	push   $0x80107574
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e51:	e8 9a 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 8f 3b 00 00       	jmp    80104a10 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 63 3b 00 00       	call   80104a10 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 aa 24 00 00       	call   80103380 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 cb 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 21 1d 00 00       	jmp    80102c20 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 7c 75 10 80       	push   $0x8010757c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 5e 25 00 00       	jmp    80103530 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 86 75 10 80       	push   $0x80107586
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 d2 1b 00 00       	call   80102c20 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 35 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 6e 1b 00 00       	call   80102c20 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 2e 23 00 00       	jmp    80103420 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 8f 75 10 80       	push   $0x8010758f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 95 75 10 80       	push   $0x80107595
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 9f 75 10 80       	push   $0x8010759f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ae 1b 00 00       	call   80102d80 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 76 38 00 00       	call   80104a70 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 7e 1b 00 00       	call   80102d80 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 00 0a 11 80       	push   $0x80110a00
8010123a:	e8 b1 36 00 00       	call   801048f0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 6c 37 00 00       	call   80104a10 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 3e 37 00 00       	call   80104a10 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 b5 75 10 80       	push   $0x801075b5
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 1d 1a 00 00       	call   80102d80 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 c5 75 10 80       	push   $0x801075c5
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 2a 37 00 00       	call   80104b20 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 e0 09 11 80       	push   $0x801109e0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 11 19 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 d8 75 10 80       	push   $0x801075d8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 eb 75 10 80       	push   $0x801075eb
801014a1:	68 00 0a 11 80       	push   $0x80110a00
801014a6:	e8 55 33 00 00       	call   80104800 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 f2 75 10 80       	push   $0x801075f2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 2c 32 00 00       	call   801046f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 e0 09 11 80       	push   $0x801109e0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014e5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014eb:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014f1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014f7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014fd:	ff 35 e4 09 11 80    	pushl  0x801109e4
80101503:	ff 35 e0 09 11 80    	pushl  0x801109e0
80101509:	68 58 76 10 80       	push   $0x80107658
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 cd 34 00 00       	call   80104a70 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 cb 17 00 00       	call   80102d80 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 f8 75 10 80       	push   $0x801075f8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 da 34 00 00       	call   80104b20 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 32 17 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 00 0a 11 80       	push   $0x80110a00
8010166f:	e8 7c 32 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010167f:	e8 8c 33 00 00       	call   80104a10 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 79 30 00 00       	call   80104730 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 f3 33 00 00       	call   80104b20 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 10 76 10 80       	push   $0x80107610
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 0a 76 10 80       	push   $0x8010760a
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 48 30 00 00       	call   801047d0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 ec 2f 00 00       	jmp    80104790 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 1f 76 10 80       	push   $0x8010761f
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 5b 2f 00 00       	call   80104730 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 a1 2f 00 00       	call   80104790 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017f6:	e8 f5 30 00 00       	call   801048f0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 fb 31 00 00       	jmp    80104a10 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 0a 11 80       	push   $0x80110a00
80101820:	e8 cb 30 00 00       	call   801048f0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010182f:	e8 dc 31 00 00       	call   80104a10 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 04 31 00 00       	call   80104b20 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 08 30 00 00       	call   80104b20 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 60 12 00 00       	call   80102d80 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 dd 2f 00 00       	call   80104b90 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 7e 2f 00 00       	call   80104b90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 39 76 10 80       	push   $0x80107639
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 27 76 10 80       	push   $0x80107627
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 82 1b 00 00       	call   80103810 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 0a 11 80       	push   $0x80110a00
80101c99:	e8 52 2c 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca9:	e8 62 2d 00 00       	call   80104a10 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 16 2e 00 00       	call   80104b20 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 83 2d 00 00       	call   80104b20 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 5e 2d 00 00       	call   80104bf0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 48 76 10 80       	push   $0x80107648
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 22 7d 10 80       	push   $0x80107d22
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 b4 76 10 80       	push   $0x801076b4
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 ab 76 10 80       	push   $0x801076ab
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 c6 76 10 80       	push   $0x801076c6
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 db 27 00 00       	call   80104800 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 20 2d 11 80       	mov    0x80112d20,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 a5 10 80       	push   $0x8010a580
8010209e:	e8 4d 28 00 00       	call   801048f0 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 8a 1e 00 00       	call   80103f90 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 a5 10 80       	push   $0x8010a580
8010211f:	e8 ec 28 00 00       	call   80104a10 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 8d 26 00 00       	call   801047d0 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	e8 73 27 00 00       	call   801048f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	53                   	push   %ebx
801021c9:	e8 12 1c 00 00       	call   80103de0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 25 28 00 00       	jmp    80104a10 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 e0 76 10 80       	push   $0x801076e0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 ca 76 10 80       	push   $0x801076ca
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 f5 76 10 80       	push   $0x801076f5
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 54 26 11 80       	mov    0x80112654,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 14 77 10 80       	push   $0x80107714
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb c8 68 11 80    	cmp    $0x801168c8,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 19 27 00 00       	call   80104a70 <memset>

  if(kmem.use_lock)
80102357:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102364:	a1 98 26 11 80       	mov    0x80112698,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010236b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102370:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 80 26 00 00       	jmp    80104a10 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 60 26 11 80       	push   $0x80112660
80102398:	e8 53 25 00 00       	call   801048f0 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 46 77 10 80       	push   $0x80107746
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 4c 77 10 80       	push   $0x8010774c
80102410:	68 60 26 11 80       	push   $0x80112660
80102415:	e8 e6 23 00 00       	call   80104800 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102427:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024d0:	a1 94 26 11 80       	mov    0x80112694,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 98 26 11 80    	mov    %edx,0x80112698
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 60 26 11 80       	push   $0x80112660
80102503:	e8 e8 23 00 00       	call   801048f0 <acquire>
  r = kmem.freelist;
80102508:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 60 26 11 80       	push   $0x80112660
80102531:	e8 da 24 00 00       	call   80104a10 <release>
  return (char*)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 c2 00 00 00    	je     80102610 <kbdgetc+0xd0>
8010254e:	ba 60 00 00 00       	mov    $0x60,%edx
80102553:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102554:	0f b6 d0             	movzbl %al,%edx
80102557:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010255d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102563:	0f 84 7f 00 00 00    	je     801025e8 <kbdgetc+0xa8>
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	53                   	push   %ebx
8010256d:	89 cb                	mov    %ecx,%ebx
8010256f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102572:	84 c0                	test   %al,%al
80102574:	78 4a                	js     801025c0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 09                	je     80102583 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010257d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102580:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102583:	0f b6 82 80 78 10 80 	movzbl -0x7fef8780(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010258c:	0f b6 82 80 77 10 80 	movzbl -0x7fef8880(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102597:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025a0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%eax
801025aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ae:	74 31                	je     801025e1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b3:	83 fa 19             	cmp    $0x19,%edx
801025b6:	77 40                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025bb:	5b                   	pop    %ebx
801025bc:	5d                   	pop    %ebp
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025c0:	83 e0 7f             	and    $0x7f,%eax
801025c3:	85 db                	test   %ebx,%ebx
801025c5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025c8:	0f b6 82 80 78 10 80 	movzbl -0x7fef8780(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
    return 0;
801025d9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025e1:	5b                   	pop    %ebx
801025e2:	5d                   	pop    %ebp
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025e8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025eb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025ed:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025fe:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102602:	0f 42 c2             	cmovb  %edx,%eax
}
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102626:	68 40 25 10 80       	push   $0x80102540
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
}
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102640:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
  lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
  lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
  lapic[index] = value;
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102715:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102740:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
{
80102746:	55                   	push   %ebp
80102747:	31 c0                	xor    %eax,%eax
80102749:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102760:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	b8 0f 00 00 00       	mov    $0xf,%eax
80102796:	ba 70 00 00 00       	mov    $0x70,%edx
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	ba 71 00 00 00       	mov    $0x71,%edx
801027af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027c0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027c3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ce:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	b8 0b 00 00 00       	mov    $0xb,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102842:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102845:	8d 76 00             	lea    0x0(%esi),%esi
80102848:	31 c0                	xor    %eax,%eax
8010284a:	89 da                	mov    %ebx,%edx
8010284c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	b8 02 00 00 00       	mov    $0x2,%eax
8010285f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
80102863:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102866:	89 da                	mov    %ebx,%edx
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
80102871:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102874:	89 da                	mov    %ebx,%edx
80102876:	b8 07 00 00 00       	mov    $0x7,%eax
8010287b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 da                	mov    %ebx,%edx
80102884:	b8 08 00 00 00       	mov    $0x8,%eax
80102889:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	b8 09 00 00 00       	mov    $0x9,%eax
80102896:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102897:	89 ca                	mov    %ecx,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289c:	89 da                	mov    %ebx,%edx
8010289e:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	89 ca                	mov    %ecx,%edx
801028a6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a7:	84 c0                	test   %al,%al
801028a9:	78 9d                	js     80102848 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028af:	89 fa                	mov    %edi,%edx
801028b1:	0f b6 fa             	movzbl %dl,%edi
801028b4:	89 f2                	mov    %esi,%edx
801028b6:	0f b6 f2             	movzbl %dl,%esi
801028b9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028c4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028cb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d9:	31 c0                	xor    %eax,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
801028f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 da                	mov    %ebx,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
80102912:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 da                	mov    %ebx,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
80102934:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	50                   	push   %eax
80102943:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102946:	50                   	push   %eax
80102947:	e8 74 21 00 00       	call   80104ac0 <memcmp>
8010294c:	83 c4 10             	add    $0x10,%esp
8010294f:	85 c0                	test   %eax,%eax
80102951:	0f 85 f1 fe ff ff    	jne    80102848 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102957:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010295b:	75 78                	jne    801029d5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102960:	89 c2                	mov    %eax,%edx
80102962:	83 e0 0f             	and    $0xf,%eax
80102965:	c1 ea 04             	shr    $0x4,%edx
80102968:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102971:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102974:	89 c2                	mov    %eax,%edx
80102976:	83 e0 0f             	and    $0xf,%eax
80102979:	c1 ea 04             	shr    $0x4,%edx
8010297c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102982:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102985:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102988:	89 c2                	mov    %eax,%edx
8010298a:	83 e0 0f             	and    $0xf,%eax
8010298d:	c1 ea 04             	shr    $0x4,%edx
80102990:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102993:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102996:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299c:	89 c2                	mov    %eax,%edx
8010299e:	83 e0 0f             	and    $0xf,%eax
801029a1:	c1 ea 04             	shr    $0x4,%edx
801029a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d5:	8b 75 08             	mov    0x8(%ebp),%esi
801029d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029db:	89 06                	mov    %eax,(%esi)
801029dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e0:	89 46 04             	mov    %eax,0x4(%esi)
801029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e6:	89 46 08             	mov    %eax,0x8(%esi)
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 46 0c             	mov    %eax,0xc(%esi)
801029ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f2:	89 46 10             	mov    %eax,0x10(%esi)
801029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a05:	5b                   	pop    %ebx
80102a06:	5e                   	pop    %esi
80102a07:	5f                   	pop    %edi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 8a 00 00 00    	jle    80102aa8 <install_trans+0x98>
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	31 db                	xor    %ebx,%ebx
{
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a54:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 a7 20 00 00       	call   80104b20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa8:	f3 c3                	repz ret 
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102abe:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac9:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ad2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ad6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	7e 16                	jle    80102af1 <write_head+0x41>
80102adb:	c1 e3 02             	shl    $0x2,%ebx
80102ade:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ae0:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102ae6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102aea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <write_head+0x30>
  }
  bwrite(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	56                   	push   %esi
80102af5:	e8 a6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102afa:	89 34 24             	mov    %esi,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>
}
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b08:	5b                   	pop    %ebx
80102b09:	5e                   	pop    %esi
80102b0a:	5d                   	pop    %ebp
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b1a:	68 80 79 10 80       	push   $0x80107980
80102b1f:	68 a0 26 11 80       	push   $0x801126a0
80102b24:	e8 d7 1c 00 00       	call   80104800 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 9b e8 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  log.dev = dev;
80102b3c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102b42:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.start = sb.logstart;
80102b48:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b55:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b5d:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
}
80102b9e:	83 c4 10             	add    $0x10,%esp
80102ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 a0 26 11 80       	push   $0x801126a0
80102bbb:	e8 30 1d 00 00       	call   801048f0 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 a0 26 11 80       	push   $0x801126a0
80102bd0:	68 a0 26 11 80       	push   $0x801126a0
80102bd5:	e8 06 12 00 00       	call   80103de0 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bdd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102beb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c02:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c07:	68 a0 26 11 80       	push   $0x801126a0
80102c0c:	e8 ff 1d 00 00       	call   80104a10 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 a0 26 11 80       	push   $0x801126a0
80102c2e:	e8 bd 1c 00 00       	call   801048f0 <acquire>
  log.outstanding -= 1;
80102c33:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c38:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c44:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c46:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102c4c:	0f 85 1a 01 00 00    	jne    80102d6c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c52:	85 db                	test   %ebx,%ebx
80102c54:	0f 85 ee 00 00 00    	jne    80102d48 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c5a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c5d:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c64:	00 00 00 
  release(&log.lock);
80102c67:	68 a0 26 11 80       	push   $0x801126a0
80102c6c:	e8 9f 1d 00 00       	call   80104a10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c71:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c82:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102ca6:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102caf:	e8 1c d4 ff ff       	call   801000d0 <bread>
80102cb4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb9:	83 c4 0c             	add    $0xc,%esp
80102cbc:	68 00 02 00 00       	push   $0x200
80102cc1:	50                   	push   %eax
80102cc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc5:	50                   	push   %eax
80102cc6:	e8 55 1e 00 00       	call   80104b20 <memmove>
    bwrite(to);  // write the log
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 cd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd3:	89 3c 24             	mov    %edi,(%esp)
80102cd6:	e8 05 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 fd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce3:	83 c4 10             	add    $0x10,%esp
80102ce6:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cf8:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102cff:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
    acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 a0 26 11 80       	push   $0x801126a0
80102d0f:	e8 dc 1b 00 00       	call   801048f0 <acquire>
    wakeup(&log);
80102d14:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102d1b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d22:	00 00 00 
    wakeup(&log);
80102d25:	e8 66 12 00 00       	call   80103f90 <wakeup>
    release(&log.lock);
80102d2a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d31:	e8 da 1c 00 00       	call   80104a10 <release>
80102d36:	83 c4 10             	add    $0x10,%esp
}
80102d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3c:	5b                   	pop    %ebx
80102d3d:	5e                   	pop    %esi
80102d3e:	5f                   	pop    %edi
80102d3f:	5d                   	pop    %ebp
80102d40:	c3                   	ret    
80102d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 a0 26 11 80       	push   $0x801126a0
80102d50:	e8 3b 12 00 00       	call   80103f90 <wakeup>
  release(&log.lock);
80102d55:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d5c:	e8 af 1c 00 00       	call   80104a10 <release>
80102d61:	83 c4 10             	add    $0x10,%esp
}
80102d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d67:	5b                   	pop    %ebx
80102d68:	5e                   	pop    %esi
80102d69:	5f                   	pop    %edi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
    panic("log.committing");
80102d6c:	83 ec 0c             	sub    $0xc,%esp
80102d6f:	68 84 79 10 80       	push   $0x80107984
80102d74:	e8 17 d6 ff ff       	call   80100390 <panic>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d87:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102da9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 a0 26 11 80       	push   $0x801126a0
80102dbe:	e8 2d 1b 00 00       	call   801048f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd6:	3b 15 ec 26 11 80    	cmp    0x801126ec,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 ec 26 11 80 	cmp    %edx,-0x7feed914(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102df0:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e02:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
  release(&log.lock);
80102e0d:	e9 fe 1b 00 00       	jmp    80104a10 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e18:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
    panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 93 79 10 80       	push   $0x80107993
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 a9 79 10 80       	push   $0x801079a9
80102e4b:	e8 40 d5 ff ff       	call   80100390 <panic>

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  //cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
  //--------------------------------------------------------------------------
  cprintf("cpu%d: starting %d ----------------------------------  Running fsck ...\n", cpuid(), cpuid());
80102e57:	e8 94 09 00 00       	call   801037f0 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 8d 09 00 00       	call   801037f0 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 c4 79 10 80       	push   $0x801079c4
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
  check_fs();
80102e72:	e8 99 16 00 00       	call   80104510 <check_fs>
  cprintf("Finish fsck ...\n", cpuid(), cpuid());
80102e77:	e8 74 09 00 00       	call   801037f0 <cpuid>
80102e7c:	89 c3                	mov    %eax,%ebx
80102e7e:	e8 6d 09 00 00       	call   801037f0 <cpuid>
80102e83:	83 c4 0c             	add    $0xc,%esp
80102e86:	53                   	push   %ebx
80102e87:	50                   	push   %eax
80102e88:	68 0d 7a 10 80       	push   $0x80107a0d
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  //---------------------------------------------------------------------------
  idtinit();       // load idt register
80102e92:	e8 79 2e 00 00       	call   80105d10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e97:	e8 d4 08 00 00       	call   80103770 <mycpu>
80102e9c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e9e:	b8 01 00 00 00       	mov    $0x1,%eax
80102ea3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eaa:	e8 01 0b 00 00       	call   801039b0 <scheduler>
80102eaf:	90                   	nop

80102eb0 <mpenter>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 45 3f 00 00       	call   80106e00 <switchkvm>
  seginit();
80102ebb:	e8 b0 3e 00 00       	call   80106d70 <seginit>
  lapicinit();
80102ec0:	e8 7b f7 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102ec5:	e8 86 ff ff ff       	call   80102e50 <mpmain>
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <main>:
{
80102ed0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ed4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ed7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	53                   	push   %ebx
80102ede:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102edf:	83 ec 08             	sub    $0x8,%esp
80102ee2:	68 00 00 40 80       	push   $0x80400000
80102ee7:	68 c8 68 11 80       	push   $0x801168c8
80102eec:	e8 0f f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 da 43 00 00       	call   801072d0 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 40 f7 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 6b 3e 00 00       	call   80106d70 <seginit>
  picinit();       // disable pic
80102f05:	e8 46 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 21 f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 27 31 00 00       	call   80106040 <uartinit>
  pinit();         // process table
80102f19:	e8 32 08 00 00       	call   80103750 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 6d 2d 00 00       	call   80105c90 <tvinit>
  binit();         // buffer cache
80102f23:	e8 18 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f28:	e8 33 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f2d:	e8 de f0 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f32:	83 c4 0c             	add    $0xc,%esp
80102f35:	68 8a 00 00 00       	push   $0x8a
80102f3a:	68 8c a4 10 80       	push   $0x8010a48c
80102f3f:	68 00 70 00 80       	push   $0x80007000
80102f44:	e8 d7 1b 00 00       	call   80104b20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f49:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102f50:	00 00 00 
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f5b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80102f60:	76 71                	jbe    80102fd3 <main+0x103>
80102f62:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80102f67:	89 f6                	mov    %esi,%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f70:	e8 fb 07 00 00       	call   80103770 <mycpu>
80102f75:	39 d8                	cmp    %ebx,%eax
80102f77:	74 41                	je     80102fba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f79:	e8 52 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f7e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f83:	c7 05 f8 6f 00 80 b0 	movl   $0x80102eb0,0x80006ff8
80102f8a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f8d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f94:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f97:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f9c:	0f b6 03             	movzbl (%ebx),%eax
80102f9f:	83 ec 08             	sub    $0x8,%esp
80102fa2:	68 00 70 00 00       	push   $0x7000
80102fa7:	50                   	push   %eax
80102fa8:	e8 e3 f7 ff ff       	call   80102790 <lapicstartap>
80102fad:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fb0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 f6                	je     80102fb0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fba:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fca:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fcf:	39 c3                	cmp    %eax,%ebx
80102fd1:	72 9d                	jb     80102f70 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fd3:	83 ec 08             	sub    $0x8,%esp
80102fd6:	68 00 00 00 8e       	push   $0x8e000000
80102fdb:	68 00 00 40 80       	push   $0x80400000
80102fe0:	e8 8b f4 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102fe5:	e8 56 08 00 00       	call   80103840 <userinit>
  mpmain();        // finish this processor's setup
80102fea:	e8 61 fe ff ff       	call   80102e50 <mpmain>
80102fef:	90                   	nop

80102ff0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ff5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102ffb:	53                   	push   %ebx
  e = addr+len;
80102ffc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103002:	39 de                	cmp    %ebx,%esi
80103004:	72 10                	jb     80103016 <mpsearch1+0x26>
80103006:	eb 50                	jmp    80103058 <mpsearch1+0x68>
80103008:	90                   	nop
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	39 fb                	cmp    %edi,%ebx
80103012:	89 fe                	mov    %edi,%esi
80103014:	76 42                	jbe    80103058 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103016:	83 ec 04             	sub    $0x4,%esp
80103019:	8d 7e 10             	lea    0x10(%esi),%edi
8010301c:	6a 04                	push   $0x4
8010301e:	68 1e 7a 10 80       	push   $0x80107a1e
80103023:	56                   	push   %esi
80103024:	e8 97 1a 00 00       	call   80104ac0 <memcmp>
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	85 c0                	test   %eax,%eax
8010302e:	75 e0                	jne    80103010 <mpsearch1+0x20>
80103030:	89 f1                	mov    %esi,%ecx
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103038:	0f b6 11             	movzbl (%ecx),%edx
8010303b:	83 c1 01             	add    $0x1,%ecx
8010303e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103040:	39 f9                	cmp    %edi,%ecx
80103042:	75 f4                	jne    80103038 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103044:	84 c0                	test   %al,%al
80103046:	75 c8                	jne    80103010 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304b:	89 f0                	mov    %esi,%eax
8010304d:	5b                   	pop    %ebx
8010304e:	5e                   	pop    %esi
8010304f:	5f                   	pop    %edi
80103050:	5d                   	pop    %ebp
80103051:	c3                   	ret    
80103052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010305b:	31 f6                	xor    %esi,%esi
}
8010305d:	89 f0                	mov    %esi,%eax
8010305f:	5b                   	pop    %ebx
80103060:	5e                   	pop    %esi
80103061:	5f                   	pop    %edi
80103062:	5d                   	pop    %ebp
80103063:	c3                   	ret    
80103064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010306a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103070 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103079:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103080:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103087:	c1 e0 08             	shl    $0x8,%eax
8010308a:	09 d0                	or     %edx,%eax
8010308c:	c1 e0 04             	shl    $0x4,%eax
8010308f:	85 c0                	test   %eax,%eax
80103091:	75 1b                	jne    801030ae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103093:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010309a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030a1:	c1 e0 08             	shl    $0x8,%eax
801030a4:	09 d0                	or     %edx,%eax
801030a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030a9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ae:	ba 00 04 00 00       	mov    $0x400,%edx
801030b3:	e8 38 ff ff ff       	call   80102ff0 <mpsearch1>
801030b8:	85 c0                	test   %eax,%eax
801030ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030bd:	0f 84 3d 01 00 00    	je     80103200 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030c6:	8b 58 04             	mov    0x4(%eax),%ebx
801030c9:	85 db                	test   %ebx,%ebx
801030cb:	0f 84 4f 01 00 00    	je     80103220 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030d7:	83 ec 04             	sub    $0x4,%esp
801030da:	6a 04                	push   $0x4
801030dc:	68 3b 7a 10 80       	push   $0x80107a3b
801030e1:	56                   	push   %esi
801030e2:	e8 d9 19 00 00       	call   80104ac0 <memcmp>
801030e7:	83 c4 10             	add    $0x10,%esp
801030ea:	85 c0                	test   %eax,%eax
801030ec:	0f 85 2e 01 00 00    	jne    80103220 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030f9:	3c 01                	cmp    $0x1,%al
801030fb:	0f 95 c2             	setne  %dl
801030fe:	3c 04                	cmp    $0x4,%al
80103100:	0f 95 c0             	setne  %al
80103103:	20 c2                	and    %al,%dl
80103105:	0f 85 15 01 00 00    	jne    80103220 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010310b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103112:	66 85 ff             	test   %di,%di
80103115:	74 1a                	je     80103131 <mpinit+0xc1>
80103117:	89 f0                	mov    %esi,%eax
80103119:	01 f7                	add    %esi,%edi
  sum = 0;
8010311b:	31 d2                	xor    %edx,%edx
8010311d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103120:	0f b6 08             	movzbl (%eax),%ecx
80103123:	83 c0 01             	add    $0x1,%eax
80103126:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103128:	39 c7                	cmp    %eax,%edi
8010312a:	75 f4                	jne    80103120 <mpinit+0xb0>
8010312c:	84 d2                	test   %dl,%dl
8010312e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103131:	85 f6                	test   %esi,%esi
80103133:	0f 84 e7 00 00 00    	je     80103220 <mpinit+0x1b0>
80103139:	84 d2                	test   %dl,%dl
8010313b:	0f 85 df 00 00 00    	jne    80103220 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103141:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103147:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103153:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103159:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315e:	01 d6                	add    %edx,%esi
80103160:	39 c6                	cmp    %eax,%esi
80103162:	76 23                	jbe    80103187 <mpinit+0x117>
    switch(*p){
80103164:	0f b6 10             	movzbl (%eax),%edx
80103167:	80 fa 04             	cmp    $0x4,%dl
8010316a:	0f 87 ca 00 00 00    	ja     8010323a <mpinit+0x1ca>
80103170:	ff 24 95 60 7a 10 80 	jmp    *-0x7fef85a0(,%edx,4)
80103177:	89 f6                	mov    %esi,%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103180:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103183:	39 c6                	cmp    %eax,%esi
80103185:	77 dd                	ja     80103164 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103187:	85 db                	test   %ebx,%ebx
80103189:	0f 84 9e 00 00 00    	je     8010322d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010318f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103192:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103196:	74 15                	je     801031ad <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103198:	b8 70 00 00 00       	mov    $0x70,%eax
8010319d:	ba 22 00 00 00       	mov    $0x22,%edx
801031a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a3:	ba 23 00 00 00       	mov    $0x23,%edx
801031a8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031a9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ac:	ee                   	out    %al,(%dx)
  }
}
801031ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b0:	5b                   	pop    %ebx
801031b1:	5e                   	pop    %esi
801031b2:	5f                   	pop    %edi
801031b3:	5d                   	pop    %ebp
801031b4:	c3                   	ret    
801031b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031b8:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
801031be:	83 f9 07             	cmp    $0x7,%ecx
801031c1:	7f 19                	jg     801031dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031cd:	83 c1 01             	add    $0x1,%ecx
801031d0:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d6:	88 97 a0 27 11 80    	mov    %dl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801031dc:	83 c0 14             	add    $0x14,%eax
      continue;
801031df:	e9 7c ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031ec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ef:	88 15 80 27 11 80    	mov    %dl,0x80112780
      continue;
801031f5:	e9 66 ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103200:	ba 00 00 01 00       	mov    $0x10000,%edx
80103205:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010320a:	e8 e1 fd ff ff       	call   80102ff0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010320f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103211:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103214:	0f 85 a9 fe ff ff    	jne    801030c3 <mpinit+0x53>
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103220:	83 ec 0c             	sub    $0xc,%esp
80103223:	68 23 7a 10 80       	push   $0x80107a23
80103228:	e8 63 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 40 7a 10 80       	push   $0x80107a40
80103235:	e8 56 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010323a:	31 db                	xor    %ebx,%ebx
8010323c:	e9 26 ff ff ff       	jmp    80103167 <mpinit+0xf7>
80103241:	66 90                	xchg   %ax,%ax
80103243:	66 90                	xchg   %ax,%ax
80103245:	66 90                	xchg   %ax,%ax
80103247:	66 90                	xchg   %ax,%ax
80103249:	66 90                	xchg   %ax,%ax
8010324b:	66 90                	xchg   %ax,%ax
8010324d:	66 90                	xchg   %ax,%ax
8010324f:	90                   	nop

80103250 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103250:	55                   	push   %ebp
80103251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103256:	ba 21 00 00 00       	mov    $0x21,%edx
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	ee                   	out    %al,(%dx)
8010325e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103263:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103264:	5d                   	pop    %ebp
80103265:	c3                   	ret    
80103266:	66 90                	xchg   %ax,%ax
80103268:	66 90                	xchg   %ax,%ax
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010327f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010328b:	e8 f0 da ff ff       	call   80100d80 <filealloc>
80103290:	85 c0                	test   %eax,%eax
80103292:	89 03                	mov    %eax,(%ebx)
80103294:	74 22                	je     801032b8 <pipealloc+0x48>
80103296:	e8 e5 da ff ff       	call   80100d80 <filealloc>
8010329b:	85 c0                	test   %eax,%eax
8010329d:	89 06                	mov    %eax,(%esi)
8010329f:	74 3f                	je     801032e0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032a1:	e8 2a f2 ff ff       	call   801024d0 <kalloc>
801032a6:	85 c0                	test   %eax,%eax
801032a8:	89 c7                	mov    %eax,%edi
801032aa:	75 54                	jne    80103300 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032ac:	8b 03                	mov    (%ebx),%eax
801032ae:	85 c0                	test   %eax,%eax
801032b0:	75 34                	jne    801032e6 <pipealloc+0x76>
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032b8:	8b 06                	mov    (%esi),%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	74 0c                	je     801032ca <pipealloc+0x5a>
    fileclose(*f1);
801032be:	83 ec 0c             	sub    $0xc,%esp
801032c1:	50                   	push   %eax
801032c2:	e8 79 db ff ff       	call   80100e40 <fileclose>
801032c7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032d2:	5b                   	pop    %ebx
801032d3:	5e                   	pop    %esi
801032d4:	5f                   	pop    %edi
801032d5:	5d                   	pop    %ebp
801032d6:	c3                   	ret    
801032d7:	89 f6                	mov    %esi,%esi
801032d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032e0:	8b 03                	mov    (%ebx),%eax
801032e2:	85 c0                	test   %eax,%eax
801032e4:	74 e4                	je     801032ca <pipealloc+0x5a>
    fileclose(*f0);
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	50                   	push   %eax
801032ea:	e8 51 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032ef:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032f1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032f4:	85 c0                	test   %eax,%eax
801032f6:	75 c6                	jne    801032be <pipealloc+0x4e>
801032f8:	eb d0                	jmp    801032ca <pipealloc+0x5a>
801032fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103300:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103303:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010330a:	00 00 00 
  p->writeopen = 1;
8010330d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103314:	00 00 00 
  p->nwrite = 0;
80103317:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010331e:	00 00 00 
  p->nread = 0;
80103321:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103328:	00 00 00 
  initlock(&p->lock, "pipe");
8010332b:	68 74 7a 10 80       	push   $0x80107a74
80103330:	50                   	push   %eax
80103331:	e8 ca 14 00 00       	call   80104800 <initlock>
  (*f0)->type = FD_PIPE;
80103336:	8b 03                	mov    (%ebx),%eax
  return 0;
80103338:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010333b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103341:	8b 03                	mov    (%ebx),%eax
80103343:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103347:	8b 03                	mov    (%ebx),%eax
80103349:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010334d:	8b 03                	mov    (%ebx),%eax
8010334f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103352:	8b 06                	mov    (%esi),%eax
80103354:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010335a:	8b 06                	mov    (%esi),%eax
8010335c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103360:	8b 06                	mov    (%esi),%eax
80103362:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103366:	8b 06                	mov    (%esi),%eax
80103368:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010336b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010336e:	31 c0                	xor    %eax,%eax
}
80103370:	5b                   	pop    %ebx
80103371:	5e                   	pop    %esi
80103372:	5f                   	pop    %edi
80103373:	5d                   	pop    %ebp
80103374:	c3                   	ret    
80103375:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103380 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	56                   	push   %esi
80103384:	53                   	push   %ebx
80103385:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103388:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010338b:	83 ec 0c             	sub    $0xc,%esp
8010338e:	53                   	push   %ebx
8010338f:	e8 5c 15 00 00       	call   801048f0 <acquire>
  if(writable){
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 f6                	test   %esi,%esi
80103399:	74 45                	je     801033e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010339b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033a1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033ab:	00 00 00 
    wakeup(&p->nread);
801033ae:	50                   	push   %eax
801033af:	e8 dc 0b 00 00       	call   80103f90 <wakeup>
801033b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033bd:	85 d2                	test   %edx,%edx
801033bf:	75 0a                	jne    801033cb <pipeclose+0x4b>
801033c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033c7:	85 c0                	test   %eax,%eax
801033c9:	74 35                	je     80103400 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033d1:	5b                   	pop    %ebx
801033d2:	5e                   	pop    %esi
801033d3:	5d                   	pop    %ebp
    release(&p->lock);
801033d4:	e9 37 16 00 00       	jmp    80104a10 <release>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033f0:	00 00 00 
    wakeup(&p->nwrite);
801033f3:	50                   	push   %eax
801033f4:	e8 97 0b 00 00       	call   80103f90 <wakeup>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	eb b9                	jmp    801033b7 <pipeclose+0x37>
801033fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	53                   	push   %ebx
80103404:	e8 07 16 00 00       	call   80104a10 <release>
    kfree((char*)p);
80103409:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010340c:	83 c4 10             	add    $0x10,%esp
}
8010340f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103412:	5b                   	pop    %ebx
80103413:	5e                   	pop    %esi
80103414:	5d                   	pop    %ebp
    kfree((char*)p);
80103415:	e9 06 ef ff ff       	jmp    80102320 <kfree>
8010341a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103420 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 28             	sub    $0x28,%esp
80103429:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010342c:	53                   	push   %ebx
8010342d:	e8 be 14 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++){
80103432:	8b 45 10             	mov    0x10(%ebp),%eax
80103435:	83 c4 10             	add    $0x10,%esp
80103438:	85 c0                	test   %eax,%eax
8010343a:	0f 8e c9 00 00 00    	jle    80103509 <pipewrite+0xe9>
80103440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103443:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103449:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010344f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103452:	03 4d 10             	add    0x10(%ebp),%ecx
80103455:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103458:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010345e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103464:	39 d0                	cmp    %edx,%eax
80103466:	75 71                	jne    801034d9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103468:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010346e:	85 c0                	test   %eax,%eax
80103470:	74 4e                	je     801034c0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103472:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103478:	eb 3a                	jmp    801034b4 <pipewrite+0x94>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	57                   	push   %edi
80103484:	e8 07 0b 00 00       	call   80103f90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103489:	5a                   	pop    %edx
8010348a:	59                   	pop    %ecx
8010348b:	53                   	push   %ebx
8010348c:	56                   	push   %esi
8010348d:	e8 4e 09 00 00       	call   80103de0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103492:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103498:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010349e:	83 c4 10             	add    $0x10,%esp
801034a1:	05 00 02 00 00       	add    $0x200,%eax
801034a6:	39 c2                	cmp    %eax,%edx
801034a8:	75 36                	jne    801034e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034aa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034b0:	85 c0                	test   %eax,%eax
801034b2:	74 0c                	je     801034c0 <pipewrite+0xa0>
801034b4:	e8 57 03 00 00       	call   80103810 <myproc>
801034b9:	8b 40 24             	mov    0x24(%eax),%eax
801034bc:	85 c0                	test   %eax,%eax
801034be:	74 c0                	je     80103480 <pipewrite+0x60>
        release(&p->lock);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	53                   	push   %ebx
801034c4:	e8 47 15 00 00       	call   80104a10 <release>
        return -1;
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d4:	5b                   	pop    %ebx
801034d5:	5e                   	pop    %esi
801034d6:	5f                   	pop    %edi
801034d7:	5d                   	pop    %ebp
801034d8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d9:	89 c2                	mov    %eax,%edx
801034db:	90                   	nop
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034e3:	8d 42 01             	lea    0x1(%edx),%eax
801034e6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034ec:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034f2:	83 c6 01             	add    $0x1,%esi
801034f5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034f9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034fc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ff:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103503:	0f 85 4f ff ff ff    	jne    80103458 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103509:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	50                   	push   %eax
80103513:	e8 78 0a 00 00       	call   80103f90 <wakeup>
  release(&p->lock);
80103518:	89 1c 24             	mov    %ebx,(%esp)
8010351b:	e8 f0 14 00 00       	call   80104a10 <release>
  return n;
80103520:	83 c4 10             	add    $0x10,%esp
80103523:	8b 45 10             	mov    0x10(%ebp),%eax
80103526:	eb a9                	jmp    801034d1 <pipewrite+0xb1>
80103528:	90                   	nop
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103530 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 18             	sub    $0x18,%esp
80103539:	8b 75 08             	mov    0x8(%ebp),%esi
8010353c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010353f:	56                   	push   %esi
80103540:	e8 ab 13 00 00       	call   801048f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103545:	83 c4 10             	add    $0x10,%esp
80103548:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010354e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103554:	75 6a                	jne    801035c0 <piperead+0x90>
80103556:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010355c:	85 db                	test   %ebx,%ebx
8010355e:	0f 84 c4 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103564:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010356a:	eb 2d                	jmp    80103599 <piperead+0x69>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103570:	83 ec 08             	sub    $0x8,%esp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	e8 66 08 00 00       	call   80103de0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010357a:	83 c4 10             	add    $0x10,%esp
8010357d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103583:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103589:	75 35                	jne    801035c0 <piperead+0x90>
8010358b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	0f 84 8f 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
80103599:	e8 72 02 00 00       	call   80103810 <myproc>
8010359e:	8b 48 24             	mov    0x24(%eax),%ecx
801035a1:	85 c9                	test   %ecx,%ecx
801035a3:	74 cb                	je     80103570 <piperead+0x40>
      release(&p->lock);
801035a5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035a8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ad:	56                   	push   %esi
801035ae:	e8 5d 14 00 00       	call   80104a10 <release>
      return -1;
801035b3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b9:	89 d8                	mov    %ebx,%eax
801035bb:	5b                   	pop    %ebx
801035bc:	5e                   	pop    %esi
801035bd:	5f                   	pop    %edi
801035be:	5d                   	pop    %ebp
801035bf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c0:	8b 45 10             	mov    0x10(%ebp),%eax
801035c3:	85 c0                	test   %eax,%eax
801035c5:	7e 61                	jle    80103628 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035c7:	31 db                	xor    %ebx,%ebx
801035c9:	eb 13                	jmp    801035de <piperead+0xae>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035d6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035dc:	74 1f                	je     801035fd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035de:	8d 41 01             	lea    0x1(%ecx),%eax
801035e1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035e7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035ed:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035f2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f5:	83 c3 01             	add    $0x1,%ebx
801035f8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035fb:	75 d3                	jne    801035d0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035fd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103603:	83 ec 0c             	sub    $0xc,%esp
80103606:	50                   	push   %eax
80103607:	e8 84 09 00 00       	call   80103f90 <wakeup>
  release(&p->lock);
8010360c:	89 34 24             	mov    %esi,(%esp)
8010360f:	e8 fc 13 00 00       	call   80104a10 <release>
  return i;
80103614:	83 c4 10             	add    $0x10,%esp
}
80103617:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361a:	89 d8                	mov    %ebx,%eax
8010361c:	5b                   	pop    %ebx
8010361d:	5e                   	pop    %esi
8010361e:	5f                   	pop    %edi
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103628:	31 db                	xor    %ebx,%ebx
8010362a:	eb d1                	jmp    801035fd <piperead+0xcd>
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103634:	bb 74 41 11 80       	mov    $0x80114174,%ebx
{
80103639:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010363c:	68 40 41 11 80       	push   $0x80114140
80103641:	e8 aa 12 00 00       	call   801048f0 <acquire>
80103646:	83 c4 10             	add    $0x10,%esp
80103649:	eb 10                	jmp    8010365b <allocproc+0x2b>
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103650:	83 c3 7c             	add    $0x7c,%ebx
80103653:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103659:	73 75                	jae    801036d0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010365b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010365e:	85 c0                	test   %eax,%eax
80103660:	75 ee                	jne    80103650 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103662:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103667:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010366a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103671:	8d 50 01             	lea    0x1(%eax),%edx
80103674:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103677:	68 40 41 11 80       	push   $0x80114140
  p->pid = nextpid++;
8010367c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103682:	e8 89 13 00 00       	call   80104a10 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103687:	e8 44 ee ff ff       	call   801024d0 <kalloc>
8010368c:	83 c4 10             	add    $0x10,%esp
8010368f:	85 c0                	test   %eax,%eax
80103691:	89 43 08             	mov    %eax,0x8(%ebx)
80103694:	74 53                	je     801036e9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103696:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010369c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010369f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036a4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036a7:	c7 40 14 7b 5c 10 80 	movl   $0x80105c7b,0x14(%eax)
  p->context = (struct context*)sp;
801036ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036b1:	6a 14                	push   $0x14
801036b3:	6a 00                	push   $0x0
801036b5:	50                   	push   %eax
801036b6:	e8 b5 13 00 00       	call   80104a70 <memset>
  p->context->eip = (uint)forkret;
801036bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036c1:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)
}
801036c8:	89 d8                	mov    %ebx,%eax
801036ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036cd:	c9                   	leave  
801036ce:	c3                   	ret    
801036cf:	90                   	nop
  release(&ptable.lock);
801036d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036d5:	68 40 41 11 80       	push   $0x80114140
801036da:	e8 31 13 00 00       	call   80104a10 <release>
}
801036df:	89 d8                	mov    %ebx,%eax
  return 0;
801036e1:	83 c4 10             	add    $0x10,%esp
}
801036e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036e7:	c9                   	leave  
801036e8:	c3                   	ret    
    p->state = UNUSED;
801036e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036f0:	31 db                	xor    %ebx,%ebx
801036f2:	eb d4                	jmp    801036c8 <allocproc+0x98>
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103706:	68 40 41 11 80       	push   $0x80114140
8010370b:	e8 00 13 00 00       	call   80104a10 <release>

  if (first) {
80103710:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	75 04                	jne    80103720 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010371c:	c9                   	leave  
8010371d:	c3                   	ret    
8010371e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103720:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103723:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010372a:	00 00 00 
    iinit(ROOTDEV);
8010372d:	6a 01                	push   $0x1
8010372f:	e8 5c dd ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103734:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010373b:	e8 d0 f3 ff ff       	call   80102b10 <initlog>
80103740:	83 c4 10             	add    $0x10,%esp
}
80103743:	c9                   	leave  
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <pinit>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103756:	68 79 7a 10 80       	push   $0x80107a79
8010375b:	68 40 41 11 80       	push   $0x80114140
80103760:	e8 9b 10 00 00       	call   80104800 <initlock>
}
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	c9                   	leave  
80103769:	c3                   	ret    
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103770 <mycpu>:
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103775:	9c                   	pushf  
80103776:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103777:	f6 c4 02             	test   $0x2,%ah
8010377a:	75 5e                	jne    801037da <mycpu+0x6a>
  apicid = lapicid();
8010377c:	e8 bf ef ff ff       	call   80102740 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103781:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
80103787:	85 f6                	test   %esi,%esi
80103789:	7e 42                	jle    801037cd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010378b:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103792:	39 d0                	cmp    %edx,%eax
80103794:	74 30                	je     801037c6 <mycpu+0x56>
80103796:	b9 50 28 11 80       	mov    $0x80112850,%ecx
  for (i = 0; i < ncpu; ++i) {
8010379b:	31 d2                	xor    %edx,%edx
8010379d:	8d 76 00             	lea    0x0(%esi),%esi
801037a0:	83 c2 01             	add    $0x1,%edx
801037a3:	39 f2                	cmp    %esi,%edx
801037a5:	74 26                	je     801037cd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037a7:	0f b6 19             	movzbl (%ecx),%ebx
801037aa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037b0:	39 c3                	cmp    %eax,%ebx
801037b2:	75 ec                	jne    801037a0 <mycpu+0x30>
801037b4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037ba:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
801037bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037c2:	5b                   	pop    %ebx
801037c3:	5e                   	pop    %esi
801037c4:	5d                   	pop    %ebp
801037c5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037c6:	b8 a0 27 11 80       	mov    $0x801127a0,%eax
      return &cpus[i];
801037cb:	eb f2                	jmp    801037bf <mycpu+0x4f>
  panic("unknown apicid\n");
801037cd:	83 ec 0c             	sub    $0xc,%esp
801037d0:	68 80 7a 10 80       	push   $0x80107a80
801037d5:	e8 b6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037da:	83 ec 0c             	sub    $0xc,%esp
801037dd:	68 6c 7b 10 80       	push   $0x80107b6c
801037e2:	e8 a9 cb ff ff       	call   80100390 <panic>
801037e7:	89 f6                	mov    %esi,%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037f0 <cpuid>:
cpuid() {
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037f6:	e8 75 ff ff ff       	call   80103770 <mycpu>
801037fb:	2d a0 27 11 80       	sub    $0x801127a0,%eax
}
80103800:	c9                   	leave  
  return mycpu()-cpus;
80103801:	c1 f8 04             	sar    $0x4,%eax
80103804:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010380a:	c3                   	ret    
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103810 <myproc>:
myproc(void) {
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103817:	e8 94 10 00 00       	call   801048b0 <pushcli>
  c = mycpu();
8010381c:	e8 4f ff ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103821:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103827:	e8 84 11 00 00       	call   801049b0 <popcli>
}
8010382c:	83 c4 04             	add    $0x4,%esp
8010382f:	89 d8                	mov    %ebx,%eax
80103831:	5b                   	pop    %ebx
80103832:	5d                   	pop    %ebp
80103833:	c3                   	ret    
80103834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010383a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103840 <userinit>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
80103844:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103847:	e8 e4 fd ff ff       	call   80103630 <allocproc>
8010384c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010384e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
80103853:	e8 f8 39 00 00       	call   80107250 <setupkvm>
80103858:	85 c0                	test   %eax,%eax
8010385a:	89 43 04             	mov    %eax,0x4(%ebx)
8010385d:	0f 84 bd 00 00 00    	je     80103920 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103863:	83 ec 04             	sub    $0x4,%esp
80103866:	68 2c 00 00 00       	push   $0x2c
8010386b:	68 60 a4 10 80       	push   $0x8010a460
80103870:	50                   	push   %eax
80103871:	e8 ba 36 00 00       	call   80106f30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103876:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103879:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010387f:	6a 4c                	push   $0x4c
80103881:	6a 00                	push   $0x0
80103883:	ff 73 18             	pushl  0x18(%ebx)
80103886:	e8 e5 11 00 00       	call   80104a70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010388b:	8b 43 18             	mov    0x18(%ebx),%eax
8010388e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103893:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103898:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010389b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010389f:	8b 43 18             	mov    0x18(%ebx),%eax
801038a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038a6:	8b 43 18             	mov    0x18(%ebx),%eax
801038a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038b1:	8b 43 18             	mov    0x18(%ebx),%eax
801038b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038b8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038bc:	8b 43 18             	mov    0x18(%ebx),%eax
801038bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038c6:	8b 43 18             	mov    0x18(%ebx),%eax
801038c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038d0:	8b 43 18             	mov    0x18(%ebx),%eax
801038d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038dd:	6a 10                	push   $0x10
801038df:	68 a9 7a 10 80       	push   $0x80107aa9
801038e4:	50                   	push   %eax
801038e5:	e8 66 13 00 00       	call   80104c50 <safestrcpy>
  p->cwd = namei("/");
801038ea:	c7 04 24 b2 7a 10 80 	movl   $0x80107ab2,(%esp)
801038f1:	e8 fa e5 ff ff       	call   80101ef0 <namei>
801038f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801038f9:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103900:	e8 eb 0f 00 00       	call   801048f0 <acquire>
  p->state = RUNNABLE;
80103905:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010390c:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103913:	e8 f8 10 00 00       	call   80104a10 <release>
}
80103918:	83 c4 10             	add    $0x10,%esp
8010391b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010391e:	c9                   	leave  
8010391f:	c3                   	ret    
    panic("userinit: out of memory?");
80103920:	83 ec 0c             	sub    $0xc,%esp
80103923:	68 90 7a 10 80       	push   $0x80107a90
80103928:	e8 63 ca ff ff       	call   80100390 <panic>
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <growproc>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
80103935:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103938:	e8 73 0f 00 00       	call   801048b0 <pushcli>
  c = mycpu();
8010393d:	e8 2e fe ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103942:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103948:	e8 63 10 00 00       	call   801049b0 <popcli>
  if(n > 0){
8010394d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103950:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103952:	7f 1c                	jg     80103970 <growproc+0x40>
  } else if(n < 0){
80103954:	75 3a                	jne    80103990 <growproc+0x60>
  switchuvm(curproc);
80103956:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103959:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010395b:	53                   	push   %ebx
8010395c:	e8 bf 34 00 00       	call   80106e20 <switchuvm>
  return 0;
80103961:	83 c4 10             	add    $0x10,%esp
80103964:	31 c0                	xor    %eax,%eax
}
80103966:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103969:	5b                   	pop    %ebx
8010396a:	5e                   	pop    %esi
8010396b:	5d                   	pop    %ebp
8010396c:	c3                   	ret    
8010396d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103970:	83 ec 04             	sub    $0x4,%esp
80103973:	01 c6                	add    %eax,%esi
80103975:	56                   	push   %esi
80103976:	50                   	push   %eax
80103977:	ff 73 04             	pushl  0x4(%ebx)
8010397a:	e8 f1 36 00 00       	call   80107070 <allocuvm>
8010397f:	83 c4 10             	add    $0x10,%esp
80103982:	85 c0                	test   %eax,%eax
80103984:	75 d0                	jne    80103956 <growproc+0x26>
      return -1;
80103986:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010398b:	eb d9                	jmp    80103966 <growproc+0x36>
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103990:	83 ec 04             	sub    $0x4,%esp
80103993:	01 c6                	add    %eax,%esi
80103995:	56                   	push   %esi
80103996:	50                   	push   %eax
80103997:	ff 73 04             	pushl  0x4(%ebx)
8010399a:	e8 01 38 00 00       	call   801071a0 <deallocuvm>
8010399f:	83 c4 10             	add    $0x10,%esp
801039a2:	85 c0                	test   %eax,%eax
801039a4:	75 b0                	jne    80103956 <growproc+0x26>
801039a6:	eb de                	jmp    80103986 <growproc+0x56>
801039a8:	90                   	nop
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <scheduler>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801039b9:	e8 b2 fd ff ff       	call   80103770 <mycpu>
801039be:	8d 78 04             	lea    0x4(%eax),%edi
801039c1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039c3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039ca:	00 00 00 
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039d0:	fb                   	sti    
    acquire(&ptable.lock);
801039d1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d4:	bb 74 41 11 80       	mov    $0x80114174,%ebx
    acquire(&ptable.lock);
801039d9:	68 40 41 11 80       	push   $0x80114140
801039de:	e8 0d 0f 00 00       	call   801048f0 <acquire>
801039e3:	83 c4 10             	add    $0x10,%esp
801039e6:	8d 76 00             	lea    0x0(%esi),%esi
801039e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801039f0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039f4:	75 33                	jne    80103a29 <scheduler+0x79>
      switchuvm(p);
801039f6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801039f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039ff:	53                   	push   %ebx
80103a00:	e8 1b 34 00 00       	call   80106e20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103a05:	58                   	pop    %eax
80103a06:	5a                   	pop    %edx
80103a07:	ff 73 1c             	pushl  0x1c(%ebx)
80103a0a:	57                   	push   %edi
      p->state = RUNNING;
80103a0b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103a12:	e8 94 12 00 00       	call   80104cab <swtch>
      switchkvm();
80103a17:	e8 e4 33 00 00       	call   80106e00 <switchkvm>
      c->proc = 0;
80103a1c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a23:	00 00 00 
80103a26:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a29:	83 c3 7c             	add    $0x7c,%ebx
80103a2c:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103a32:	72 bc                	jb     801039f0 <scheduler+0x40>
    release(&ptable.lock);
80103a34:	83 ec 0c             	sub    $0xc,%esp
80103a37:	68 40 41 11 80       	push   $0x80114140
80103a3c:	e8 cf 0f 00 00       	call   80104a10 <release>
    sti();
80103a41:	83 c4 10             	add    $0x10,%esp
80103a44:	eb 8a                	jmp    801039d0 <scheduler+0x20>
80103a46:	8d 76 00             	lea    0x0(%esi),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <sched>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
  pushcli();
80103a55:	e8 56 0e 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103a5a:	e8 11 fd ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103a5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a65:	e8 46 0f 00 00       	call   801049b0 <popcli>
  if(!holding(&ptable.lock))
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	68 40 41 11 80       	push   $0x80114140
80103a72:	e8 f9 0d 00 00       	call   80104870 <holding>
80103a77:	83 c4 10             	add    $0x10,%esp
80103a7a:	85 c0                	test   %eax,%eax
80103a7c:	74 4f                	je     80103acd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103a7e:	e8 ed fc ff ff       	call   80103770 <mycpu>
80103a83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a8a:	75 68                	jne    80103af4 <sched+0xa4>
  if(p->state == RUNNING)
80103a8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a90:	74 55                	je     80103ae7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a92:	9c                   	pushf  
80103a93:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a94:	f6 c4 02             	test   $0x2,%ah
80103a97:	75 41                	jne    80103ada <sched+0x8a>
  intena = mycpu()->intena;
80103a99:	e8 d2 fc ff ff       	call   80103770 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a9e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103aa1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103aa7:	e8 c4 fc ff ff       	call   80103770 <mycpu>
80103aac:	83 ec 08             	sub    $0x8,%esp
80103aaf:	ff 70 04             	pushl  0x4(%eax)
80103ab2:	53                   	push   %ebx
80103ab3:	e8 f3 11 00 00       	call   80104cab <swtch>
  mycpu()->intena = intena;
80103ab8:	e8 b3 fc ff ff       	call   80103770 <mycpu>
}
80103abd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ac0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac9:	5b                   	pop    %ebx
80103aca:	5e                   	pop    %esi
80103acb:	5d                   	pop    %ebp
80103acc:	c3                   	ret    
    panic("sched ptable.lock");
80103acd:	83 ec 0c             	sub    $0xc,%esp
80103ad0:	68 b4 7a 10 80       	push   $0x80107ab4
80103ad5:	e8 b6 c8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 e0 7a 10 80       	push   $0x80107ae0
80103ae2:	e8 a9 c8 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ae7:	83 ec 0c             	sub    $0xc,%esp
80103aea:	68 d2 7a 10 80       	push   $0x80107ad2
80103aef:	e8 9c c8 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103af4:	83 ec 0c             	sub    $0xc,%esp
80103af7:	68 c6 7a 10 80       	push   $0x80107ac6
80103afc:	e8 8f c8 ff ff       	call   80100390 <panic>
80103b01:	eb 0d                	jmp    80103b10 <fork>
80103b03:	90                   	nop
80103b04:	90                   	nop
80103b05:	90                   	nop
80103b06:	90                   	nop
80103b07:	90                   	nop
80103b08:	90                   	nop
80103b09:	90                   	nop
80103b0a:	90                   	nop
80103b0b:	90                   	nop
80103b0c:	90                   	nop
80103b0d:	90                   	nop
80103b0e:	90                   	nop
80103b0f:	90                   	nop

80103b10 <fork>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b19:	e8 92 0d 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103b1e:	e8 4d fc ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103b23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b29:	e8 82 0e 00 00       	call   801049b0 <popcli>
  if((np = allocproc()) == 0){
80103b2e:	e8 fd fa ff ff       	call   80103630 <allocproc>
80103b33:	85 c0                	test   %eax,%eax
80103b35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b38:	0f 84 ed 00 00 00    	je     80103c2b <fork+0x11b>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b3e:	83 ec 08             	sub    $0x8,%esp
80103b41:	ff 33                	pushl  (%ebx)
80103b43:	ff 73 04             	pushl  0x4(%ebx)
80103b46:	89 c7                	mov    %eax,%edi
80103b48:	e8 d3 37 00 00       	call   80107320 <copyuvm>
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	85 c0                	test   %eax,%eax
80103b52:	89 47 04             	mov    %eax,0x4(%edi)
80103b55:	0f 84 d7 00 00 00    	je     80103c32 <fork+0x122>
  np->sz = curproc->sz;
80103b5b:	8b 03                	mov    (%ebx),%eax
80103b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b60:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b62:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b65:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b67:	8b 79 18             	mov    0x18(%ecx),%edi
80103b6a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b6d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b76:	8b 40 18             	mov    0x18(%eax),%eax
80103b79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 13                	je     80103b9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	50                   	push   %eax
80103b8c:	e8 5f d2 ff ff       	call   80100df0 <filedup>
80103b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b94:	83 c4 10             	add    $0x10,%esp
80103b97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b9b:	83 c6 01             	add    $0x1,%esi
80103b9e:	83 fe 10             	cmp    $0x10,%esi
80103ba1:	75 dd                	jne    80103b80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ba3:	83 ec 0c             	sub    $0xc,%esp
80103ba6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bac:	e8 af da ff ff       	call   80101660 <idup>
80103bb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	53                   	push   %ebx
80103bc0:	50                   	push   %eax
80103bc1:	e8 8a 10 00 00       	call   80104c50 <safestrcpy>
  pid = np->pid;
80103bc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bc9:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103bd0:	e8 1b 0d 00 00       	call   801048f0 <acquire>
  if(fork_winner){
80103bd5:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103bda:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80103bdd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  if(fork_winner){
80103be4:	85 c0                	test   %eax,%eax
80103be6:	75 20                	jne    80103c08 <fork+0xf8>
  release(&ptable.lock);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	68 40 41 11 80       	push   $0x80114140
80103bf0:	e8 1b 0e 00 00       	call   80104a10 <release>
  return pid;
80103bf5:	83 c4 10             	add    $0x10,%esp
}
80103bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfb:	89 d8                	mov    %ebx,%eax
80103bfd:	5b                   	pop    %ebx
80103bfe:	5e                   	pop    %esi
80103bff:	5f                   	pop    %edi
80103c00:	5d                   	pop    %ebp
80103c01:	c3                   	ret    
80103c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pushcli();
80103c08:	e8 a3 0c 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103c0d:	e8 5e fb ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103c12:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c18:	e8 93 0d 00 00       	call   801049b0 <popcli>
    myproc()->state=RUNNABLE;
80103c1d:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
    sched();
80103c24:	e8 27 fe ff ff       	call   80103a50 <sched>
80103c29:	eb bd                	jmp    80103be8 <fork+0xd8>
    return -1;
80103c2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c30:	eb c6                	jmp    80103bf8 <fork+0xe8>
    kfree(np->kstack);
80103c32:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c35:	83 ec 0c             	sub    $0xc,%esp
80103c38:	ff 73 08             	pushl  0x8(%ebx)
80103c3b:	e8 e0 e6 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103c40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c47:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c4e:	83 c4 10             	add    $0x10,%esp
80103c51:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c56:	eb a0                	jmp    80103bf8 <fork+0xe8>
80103c58:	90                   	nop
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <exit>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c69:	e8 42 0c 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103c6e:	e8 fd fa ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103c73:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c79:	e8 32 0d 00 00       	call   801049b0 <popcli>
  if(curproc == initproc)
80103c7e:	39 35 bc a5 10 80    	cmp    %esi,0x8010a5bc
80103c84:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c87:	8d 7e 68             	lea    0x68(%esi),%edi
80103c8a:	0f 84 e7 00 00 00    	je     80103d77 <exit+0x117>
    if(curproc->ofile[fd]){
80103c90:	8b 03                	mov    (%ebx),%eax
80103c92:	85 c0                	test   %eax,%eax
80103c94:	74 12                	je     80103ca8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c96:	83 ec 0c             	sub    $0xc,%esp
80103c99:	50                   	push   %eax
80103c9a:	e8 a1 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103c9f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ca5:	83 c4 10             	add    $0x10,%esp
80103ca8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103cab:	39 fb                	cmp    %edi,%ebx
80103cad:	75 e1                	jne    80103c90 <exit+0x30>
  begin_op();
80103caf:	e8 fc ee ff ff       	call   80102bb0 <begin_op>
  iput(curproc->cwd);
80103cb4:	83 ec 0c             	sub    $0xc,%esp
80103cb7:	ff 76 68             	pushl  0x68(%esi)
80103cba:	e8 01 db ff ff       	call   801017c0 <iput>
  end_op();
80103cbf:	e8 5c ef ff ff       	call   80102c20 <end_op>
  curproc->cwd = 0;
80103cc4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103ccb:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103cd2:	e8 19 0c 00 00       	call   801048f0 <acquire>
  wakeup1(curproc->parent);
80103cd7:	8b 56 14             	mov    0x14(%esi),%edx
80103cda:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cdd:	b8 74 41 11 80       	mov    $0x80114174,%eax
80103ce2:	eb 0e                	jmp    80103cf2 <exit+0x92>
80103ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce8:	83 c0 7c             	add    $0x7c,%eax
80103ceb:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103cf0:	73 1c                	jae    80103d0e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103cf2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cf6:	75 f0                	jne    80103ce8 <exit+0x88>
80103cf8:	3b 50 20             	cmp    0x20(%eax),%edx
80103cfb:	75 eb                	jne    80103ce8 <exit+0x88>
      p->state = RUNNABLE;
80103cfd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d04:	83 c0 7c             	add    $0x7c,%eax
80103d07:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103d0c:	72 e4                	jb     80103cf2 <exit+0x92>
      p->parent = initproc;
80103d0e:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d14:	ba 74 41 11 80       	mov    $0x80114174,%edx
80103d19:	eb 10                	jmp    80103d2b <exit+0xcb>
80103d1b:	90                   	nop
80103d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d20:	83 c2 7c             	add    $0x7c,%edx
80103d23:	81 fa 74 60 11 80    	cmp    $0x80116074,%edx
80103d29:	73 33                	jae    80103d5e <exit+0xfe>
    if(p->parent == curproc){
80103d2b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d2e:	75 f0                	jne    80103d20 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d30:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d34:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d37:	75 e7                	jne    80103d20 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d39:	b8 74 41 11 80       	mov    $0x80114174,%eax
80103d3e:	eb 0a                	jmp    80103d4a <exit+0xea>
80103d40:	83 c0 7c             	add    $0x7c,%eax
80103d43:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103d48:	73 d6                	jae    80103d20 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d4e:	75 f0                	jne    80103d40 <exit+0xe0>
80103d50:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d53:	75 eb                	jne    80103d40 <exit+0xe0>
      p->state = RUNNABLE;
80103d55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d5c:	eb e2                	jmp    80103d40 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d5e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d65:	e8 e6 fc ff ff       	call   80103a50 <sched>
  panic("zombie exit");
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 01 7b 10 80       	push   $0x80107b01
80103d72:	e8 19 c6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 f4 7a 10 80       	push   $0x80107af4
80103d7f:	e8 0c c6 ff ff       	call   80100390 <panic>
80103d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d90 <yield>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	53                   	push   %ebx
80103d94:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d97:	68 40 41 11 80       	push   $0x80114140
80103d9c:	e8 4f 0b 00 00       	call   801048f0 <acquire>
  pushcli();
80103da1:	e8 0a 0b 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103da6:	e8 c5 f9 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103dab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db1:	e8 fa 0b 00 00       	call   801049b0 <popcli>
  myproc()->state = RUNNABLE;
80103db6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103dbd:	e8 8e fc ff ff       	call   80103a50 <sched>
  release(&ptable.lock);
80103dc2:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103dc9:	e8 42 0c 00 00       	call   80104a10 <release>
}
80103dce:	83 c4 10             	add    $0x10,%esp
80103dd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dd4:	c9                   	leave  
80103dd5:	c3                   	ret    
80103dd6:	8d 76 00             	lea    0x0(%esi),%esi
80103dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103de0 <sleep>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
80103de9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103def:	e8 bc 0a 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103df4:	e8 77 f9 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103df9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dff:	e8 ac 0b 00 00       	call   801049b0 <popcli>
  if(p == 0)
80103e04:	85 db                	test   %ebx,%ebx
80103e06:	0f 84 87 00 00 00    	je     80103e93 <sleep+0xb3>
  if(lk == 0)
80103e0c:	85 f6                	test   %esi,%esi
80103e0e:	74 76                	je     80103e86 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e10:	81 fe 40 41 11 80    	cmp    $0x80114140,%esi
80103e16:	74 50                	je     80103e68 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	68 40 41 11 80       	push   $0x80114140
80103e20:	e8 cb 0a 00 00       	call   801048f0 <acquire>
    release(lk);
80103e25:	89 34 24             	mov    %esi,(%esp)
80103e28:	e8 e3 0b 00 00       	call   80104a10 <release>
  p->chan = chan;
80103e2d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e30:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e37:	e8 14 fc ff ff       	call   80103a50 <sched>
  p->chan = 0;
80103e3c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e43:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103e4a:	e8 c1 0b 00 00       	call   80104a10 <release>
    acquire(lk);
80103e4f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e52:	83 c4 10             	add    $0x10,%esp
}
80103e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e58:	5b                   	pop    %ebx
80103e59:	5e                   	pop    %esi
80103e5a:	5f                   	pop    %edi
80103e5b:	5d                   	pop    %ebp
    acquire(lk);
80103e5c:	e9 8f 0a 00 00       	jmp    801048f0 <acquire>
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e68:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e6b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e72:	e8 d9 fb ff ff       	call   80103a50 <sched>
  p->chan = 0;
80103e77:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e81:	5b                   	pop    %ebx
80103e82:	5e                   	pop    %esi
80103e83:	5f                   	pop    %edi
80103e84:	5d                   	pop    %ebp
80103e85:	c3                   	ret    
    panic("sleep without lk");
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	68 13 7b 10 80       	push   $0x80107b13
80103e8e:	e8 fd c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	68 0d 7b 10 80       	push   $0x80107b0d
80103e9b:	e8 f0 c4 ff ff       	call   80100390 <panic>

80103ea0 <wait>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	56                   	push   %esi
80103ea4:	53                   	push   %ebx
  pushcli();
80103ea5:	e8 06 0a 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103eaa:	e8 c1 f8 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103eaf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103eb5:	e8 f6 0a 00 00       	call   801049b0 <popcli>
  acquire(&ptable.lock);
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 40 41 11 80       	push   $0x80114140
80103ec2:	e8 29 0a 00 00       	call   801048f0 <acquire>
80103ec7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecc:	bb 74 41 11 80       	mov    $0x80114174,%ebx
80103ed1:	eb 10                	jmp    80103ee3 <wait+0x43>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	83 c3 7c             	add    $0x7c,%ebx
80103edb:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103ee1:	73 1b                	jae    80103efe <wait+0x5e>
      if(p->parent != curproc)
80103ee3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ee6:	75 f0                	jne    80103ed8 <wait+0x38>
      if(p->state == ZOMBIE){
80103ee8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eec:	74 32                	je     80103f20 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103ef1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef6:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103efc:	72 e5                	jb     80103ee3 <wait+0x43>
    if(!havekids || curproc->killed){
80103efe:	85 c0                	test   %eax,%eax
80103f00:	74 74                	je     80103f76 <wait+0xd6>
80103f02:	8b 46 24             	mov    0x24(%esi),%eax
80103f05:	85 c0                	test   %eax,%eax
80103f07:	75 6d                	jne    80103f76 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f09:	83 ec 08             	sub    $0x8,%esp
80103f0c:	68 40 41 11 80       	push   $0x80114140
80103f11:	56                   	push   %esi
80103f12:	e8 c9 fe ff ff       	call   80103de0 <sleep>
    havekids = 0;
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	eb ae                	jmp    80103eca <wait+0x2a>
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f26:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f29:	e8 f2 e3 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80103f2e:	5a                   	pop    %edx
80103f2f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f39:	e8 92 32 00 00       	call   801071d0 <freevm>
        release(&ptable.lock);
80103f3e:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
        p->pid = 0;
80103f45:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f4c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f53:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f57:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f5e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f65:	e8 a6 0a 00 00       	call   80104a10 <release>
        return pid;
80103f6a:	83 c4 10             	add    $0x10,%esp
}
80103f6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f70:	89 f0                	mov    %esi,%eax
80103f72:	5b                   	pop    %ebx
80103f73:	5e                   	pop    %esi
80103f74:	5d                   	pop    %ebp
80103f75:	c3                   	ret    
      release(&ptable.lock);
80103f76:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f79:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f7e:	68 40 41 11 80       	push   $0x80114140
80103f83:	e8 88 0a 00 00       	call   80104a10 <release>
      return -1;
80103f88:	83 c4 10             	add    $0x10,%esp
80103f8b:	eb e0                	jmp    80103f6d <wait+0xcd>
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi

80103f90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 10             	sub    $0x10,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f9a:	68 40 41 11 80       	push   $0x80114140
80103f9f:	e8 4c 09 00 00       	call   801048f0 <acquire>
80103fa4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa7:	b8 74 41 11 80       	mov    $0x80114174,%eax
80103fac:	eb 0c                	jmp    80103fba <wakeup+0x2a>
80103fae:	66 90                	xchg   %ax,%ax
80103fb0:	83 c0 7c             	add    $0x7c,%eax
80103fb3:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103fb8:	73 1c                	jae    80103fd6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fbe:	75 f0                	jne    80103fb0 <wakeup+0x20>
80103fc0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fc3:	75 eb                	jne    80103fb0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fcc:	83 c0 7c             	add    $0x7c,%eax
80103fcf:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103fd4:	72 e4                	jb     80103fba <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103fd6:	c7 45 08 40 41 11 80 	movl   $0x80114140,0x8(%ebp)
}
80103fdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe0:	c9                   	leave  
  release(&ptable.lock);
80103fe1:	e9 2a 0a 00 00       	jmp    80104a10 <release>
80103fe6:	8d 76 00             	lea    0x0(%esi),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103ffa:	68 40 41 11 80       	push   $0x80114140
80103fff:	e8 ec 08 00 00       	call   801048f0 <acquire>
80104004:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104007:	b8 74 41 11 80       	mov    $0x80114174,%eax
8010400c:	eb 0c                	jmp    8010401a <kill+0x2a>
8010400e:	66 90                	xchg   %ax,%ax
80104010:	83 c0 7c             	add    $0x7c,%eax
80104013:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80104018:	73 36                	jae    80104050 <kill+0x60>
    if(p->pid == pid){
8010401a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010401d:	75 f1                	jne    80104010 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010401f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104023:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010402a:	75 07                	jne    80104033 <kill+0x43>
        p->state = RUNNABLE;
8010402c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 40 41 11 80       	push   $0x80114140
8010403b:	e8 d0 09 00 00       	call   80104a10 <release>
      return 0;
80104040:	83 c4 10             	add    $0x10,%esp
80104043:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104048:	c9                   	leave  
80104049:	c3                   	ret    
8010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104050:	83 ec 0c             	sub    $0xc,%esp
80104053:	68 40 41 11 80       	push   $0x80114140
80104058:	e8 b3 09 00 00       	call   80104a10 <release>
  return -1;
8010405d:	83 c4 10             	add    $0x10,%esp
80104060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104068:	c9                   	leave  
80104069:	c3                   	ret    
8010406a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104070 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104079:	bb 74 41 11 80       	mov    $0x80114174,%ebx
{
8010407e:	83 ec 3c             	sub    $0x3c,%esp
80104081:	eb 24                	jmp    801040a7 <procdump+0x37>
80104083:	90                   	nop
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 3b 7f 10 80       	push   $0x80107f3b
80104090:	e8 cb c5 ff ff       	call   80100660 <cprintf>
80104095:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104098:	83 c3 7c             	add    $0x7c,%ebx
8010409b:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
801040a1:	0f 83 81 00 00 00    	jae    80104128 <procdump+0xb8>
    if(p->state == UNUSED)
801040a7:	8b 43 0c             	mov    0xc(%ebx),%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 ea                	je     80104098 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040ae:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801040b1:	ba 24 7b 10 80       	mov    $0x80107b24,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040b6:	77 11                	ja     801040c9 <procdump+0x59>
801040b8:	8b 14 85 14 7c 10 80 	mov    -0x7fef83ec(,%eax,4),%edx
      state = "???";
801040bf:	b8 24 7b 10 80       	mov    $0x80107b24,%eax
801040c4:	85 d2                	test   %edx,%edx
801040c6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040cc:	50                   	push   %eax
801040cd:	52                   	push   %edx
801040ce:	ff 73 10             	pushl  0x10(%ebx)
801040d1:	68 28 7b 10 80       	push   $0x80107b28
801040d6:	e8 85 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040db:	83 c4 10             	add    $0x10,%esp
801040de:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801040e2:	75 a4                	jne    80104088 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040e4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040e7:	83 ec 08             	sub    $0x8,%esp
801040ea:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040ed:	50                   	push   %eax
801040ee:	8b 43 1c             	mov    0x1c(%ebx),%eax
801040f1:	8b 40 0c             	mov    0xc(%eax),%eax
801040f4:	83 c0 08             	add    $0x8,%eax
801040f7:	50                   	push   %eax
801040f8:	e8 23 07 00 00       	call   80104820 <getcallerpcs>
801040fd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104100:	8b 17                	mov    (%edi),%edx
80104102:	85 d2                	test   %edx,%edx
80104104:	74 82                	je     80104088 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104106:	83 ec 08             	sub    $0x8,%esp
80104109:	83 c7 04             	add    $0x4,%edi
8010410c:	52                   	push   %edx
8010410d:	68 21 75 10 80       	push   $0x80107521
80104112:	e8 49 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104117:	83 c4 10             	add    $0x10,%esp
8010411a:	39 fe                	cmp    %edi,%esi
8010411c:	75 e2                	jne    80104100 <procdump+0x90>
8010411e:	e9 65 ff ff ff       	jmp    80104088 <procdump+0x18>
80104123:	90                   	nop
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010412b:	5b                   	pop    %ebx
8010412c:	5e                   	pop    %esi
8010412d:	5f                   	pop    %edi
8010412e:	5d                   	pop    %ebp
8010412f:	c3                   	ret    

80104130 <waitdisk>:
//------------------------------------------------------------------------
#define SECTSIZE  512
// copy from bootmain.c
void 
waitdisk(void)
{
80104130:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104131:	ba f7 01 00 00       	mov    $0x1f7,%edx
80104136:	89 e5                	mov    %esp,%ebp
80104138:	90                   	nop
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104140:	ec                   	in     (%dx),%al
  // Wait for disk ready
  while((inb(0x1F7) & 0xC0) != 0x40);
80104141:	83 e0 c0             	and    $0xffffffc0,%eax
80104144:	3c 40                	cmp    $0x40,%al
80104146:	75 f8                	jne    80104140 <waitdisk+0x10>
}
80104148:	5d                   	pop    %ebp
80104149:	c3                   	ret    
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <readsec>:

// copy from bootmain.c
// Read a single sector at offset into dst.
void
readsec(void *dst, uint offset)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	53                   	push   %ebx
80104155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104158:	bb f7 01 00 00       	mov    $0x1f7,%ebx
8010415d:	8d 76 00             	lea    0x0(%esi),%esi
80104160:	89 da                	mov    %ebx,%edx
80104162:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
80104163:	83 e0 c0             	and    $0xffffffc0,%eax
80104166:	3c 40                	cmp    $0x40,%al
80104168:	75 f6                	jne    80104160 <readsec+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010416a:	b8 01 00 00 00       	mov    $0x1,%eax
8010416f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80104174:	ee                   	out    %al,(%dx)
80104175:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010417a:	89 c8                	mov    %ecx,%eax
8010417c:	ee                   	out    %al,(%dx)
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
8010417d:	89 c8                	mov    %ecx,%eax
8010417f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80104184:	c1 e8 08             	shr    $0x8,%eax
80104187:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
80104188:	89 c8                	mov    %ecx,%eax
8010418a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010418f:	c1 e8 10             	shr    $0x10,%eax
80104192:	ee                   	out    %al,(%dx)
  //------------------------------------------
  // E0->F0  Read from disk img 1
  outb(0x1F6, (offset >> 24) | 0xF0);
80104193:	89 c8                	mov    %ecx,%eax
80104195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010419a:	c1 e8 18             	shr    $0x18,%eax
8010419d:	83 c8 f0             	or     $0xfffffff0,%eax
801041a0:	ee                   	out    %al,(%dx)
801041a1:	b8 20 00 00 00       	mov    $0x20,%eax
801041a6:	89 da                	mov    %ebx,%edx
801041a8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801041a9:	ba f7 01 00 00       	mov    $0x1f7,%edx
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
801041b1:	83 e0 c0             	and    $0xffffffc0,%eax
801041b4:	3c 40                	cmp    $0x40,%al
801041b6:	75 f8                	jne    801041b0 <readsec+0x60>
  asm volatile("cld; rep insl" :
801041b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801041bb:	b9 80 00 00 00       	mov    $0x80,%ecx
801041c0:	ba f0 01 00 00       	mov    $0x1f0,%edx
801041c5:	fc                   	cld    
801041c6:	f3 6d                	rep insl (%dx),%es:(%edi)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
  insl(0x1F0, dst, SECTSIZE/4);
}
801041c8:	5b                   	pop    %ebx
801041c9:	5f                   	pop    %edi
801041ca:	5d                   	pop    %ebp
801041cb:	c3                   	ret    
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041d0 <Writesec>:

// Write a single sector at offset into dst.
void
Writesec(void *dst, uint offset)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	56                   	push   %esi
801041d4:	53                   	push   %ebx
801041d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801041d8:	bb f7 01 00 00       	mov    $0x1f7,%ebx
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
801041e0:	89 da                	mov    %ebx,%edx
801041e2:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
801041e3:	83 e0 c0             	and    $0xffffffc0,%eax
801041e6:	3c 40                	cmp    $0x40,%al
801041e8:	75 f6                	jne    801041e0 <Writesec+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801041ea:	b8 01 00 00 00       	mov    $0x1,%eax
801041ef:	ba f2 01 00 00       	mov    $0x1f2,%edx
801041f4:	ee                   	out    %al,(%dx)
801041f5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801041fa:	89 c8                	mov    %ecx,%eax
801041fc:	ee                   	out    %al,(%dx)
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
801041fd:	89 c8                	mov    %ecx,%eax
801041ff:	ba f4 01 00 00       	mov    $0x1f4,%edx
80104204:	c1 e8 08             	shr    $0x8,%eax
80104207:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
80104208:	89 c8                	mov    %ecx,%eax
8010420a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010420f:	c1 e8 10             	shr    $0x10,%eax
80104212:	ee                   	out    %al,(%dx)
  //------------------------------------------
  // E0->F0  Read from disk img 1
  outb(0x1F6, (offset >> 24) | 0xF0);
80104213:	89 c8                	mov    %ecx,%eax
80104215:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010421a:	c1 e8 18             	shr    $0x18,%eax
8010421d:	83 c8 f0             	or     $0xfffffff0,%eax
80104220:	ee                   	out    %al,(%dx)
80104221:	b8 30 00 00 00       	mov    $0x30,%eax
80104226:	89 da                	mov    %ebx,%edx
80104228:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104229:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010422e:	66 90                	xchg   %ax,%ax
80104230:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
80104231:	83 e0 c0             	and    $0xffffffc0,%eax
80104234:	3c 40                	cmp    $0x40,%al
80104236:	75 f8                	jne    80104230 <Writesec+0x60>
  asm volatile("cld; rep outsl" :
80104238:	8b 75 08             	mov    0x8(%ebp),%esi
8010423b:	b9 80 00 00 00       	mov    $0x80,%ecx
80104240:	ba f0 01 00 00       	mov    $0x1f0,%edx
80104245:	fc                   	cld    
80104246:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  outb(0x1F7, 0x30);  // cmd 0x30 - write sectors

  // Read data.
  waitdisk();
  outsl(0x1F0, dst, SECTSIZE/4);
}
80104248:	5b                   	pop    %ebx
80104249:	5e                   	pop    %esi
8010424a:	5d                   	pop    %ebp
8010424b:	c3                   	ret    
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104250 <readblock>:

// copy from bootmain.c
void 
readblock(char* pa, uint count, uint offset)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	8b 7d 10             	mov    0x10(%ebp),%edi
80104258:	53                   	push   %ebx
  char* epa;

  epa = pa + count;
80104259:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010425c:	8b 5d 08             	mov    0x8(%ebp),%ebx

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
8010425f:	89 f8                	mov    %edi,%eax

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
80104261:	c1 ef 09             	shr    $0x9,%edi
  pa -= offset % SECTSIZE;
80104264:	25 ff 01 00 00       	and    $0x1ff,%eax
  epa = pa + count;
80104269:	01 de                	add    %ebx,%esi
  offset = (offset / SECTSIZE) + 1;
8010426b:	83 c7 01             	add    $0x1,%edi
  pa -= offset % SECTSIZE;
8010426e:	29 c3                	sub    %eax,%ebx

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
80104270:	39 de                	cmp    %ebx,%esi
80104272:	76 1a                	jbe    8010428e <readblock+0x3e>
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    readsec(pa, offset);
80104278:	57                   	push   %edi
80104279:	53                   	push   %ebx
  for(; pa < epa; pa += SECTSIZE, offset++)
8010427a:	81 c3 00 02 00 00    	add    $0x200,%ebx
80104280:	83 c7 01             	add    $0x1,%edi
    readsec(pa, offset);
80104283:	e8 c8 fe ff ff       	call   80104150 <readsec>
  for(; pa < epa; pa += SECTSIZE, offset++)
80104288:	39 de                	cmp    %ebx,%esi
8010428a:	58                   	pop    %eax
8010428b:	5a                   	pop    %edx
8010428c:	77 ea                	ja     80104278 <readblock+0x28>
}
8010428e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104291:	5b                   	pop    %ebx
80104292:	5e                   	pop    %esi
80104293:	5f                   	pop    %edi
80104294:	5d                   	pop    %ebp
80104295:	c3                   	ret    
80104296:	8d 76 00             	lea    0x0(%esi),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <writeblock>:

int flag[250];

void 
writeblock(char* pa, uint count, uint offset)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	8b 7d 10             	mov    0x10(%ebp),%edi
801042a8:	53                   	push   %ebx
  char* epa;

  epa = pa + count;
801042a9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
801042ac:	8b 5d 08             	mov    0x8(%ebp),%ebx

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
801042af:	89 f8                	mov    %edi,%eax

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
801042b1:	c1 ef 09             	shr    $0x9,%edi
  pa -= offset % SECTSIZE;
801042b4:	25 ff 01 00 00       	and    $0x1ff,%eax
  epa = pa + count;
801042b9:	01 de                	add    %ebx,%esi
  offset = (offset / SECTSIZE) + 1;
801042bb:	83 c7 01             	add    $0x1,%edi
  pa -= offset % SECTSIZE;
801042be:	29 c3                	sub    %eax,%ebx

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
801042c0:	39 de                	cmp    %ebx,%esi
801042c2:	76 1a                	jbe    801042de <writeblock+0x3e>
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    Writesec(pa, offset);
801042c8:	57                   	push   %edi
801042c9:	53                   	push   %ebx
  for(; pa < epa; pa += SECTSIZE, offset++)
801042ca:	81 c3 00 02 00 00    	add    $0x200,%ebx
801042d0:	83 c7 01             	add    $0x1,%edi
    Writesec(pa, offset);
801042d3:	e8 f8 fe ff ff       	call   801041d0 <Writesec>
  for(; pa < epa; pa += SECTSIZE, offset++)
801042d8:	39 de                	cmp    %ebx,%esi
801042da:	58                   	pop    %eax
801042db:	5a                   	pop    %edx
801042dc:	77 ea                	ja     801042c8 <writeblock+0x28>
}
801042de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e1:	5b                   	pop    %ebx
801042e2:	5e                   	pop    %esi
801042e3:	5f                   	pop    %edi
801042e4:	5d                   	pop    %ebp
801042e5:	c3                   	ret    
801042e6:	8d 76 00             	lea    0x0(%esi),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042f0 <dfs>:
#define BSIZE 512  // block size
#define ENTNUM  BSIZE/sizeof(struct dirent)
int logNum;
char single[4096];
void
dfs(const char* name, const struct dinode* inode,int depth){
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
  // single block

  // inode
  struct dinode INODES[8]; 
  // cprintf("before if\n");
  if(inode->type == 0) return;
801042fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ff:	66 83 38 01          	cmpw   $0x1,(%eax)
80104303:	0f 85 f7 01 00 00    	jne    80104500 <dfs+0x210>
80104309:	8d 78 0c             	lea    0xc(%eax),%edi
8010430c:	83 c0 3c             	add    $0x3c,%eax
        entry->inum>200){
          entry++;
          continue;
        }
        // get the inode metioned in the entry
        readblock((char*)(&INODES),BSIZE, BSIZE + logNum * BSIZE + (entry->inum/8 * BSIZE));
8010430f:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
80104315:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
      addr = inode->addrs[i];
8010431b:	8b 07                	mov    (%edi),%eax
      if(0 == addr) {
8010431d:	85 c0                	test   %eax,%eax
8010431f:	75 1c                	jne    8010433d <dfs+0x4d>
80104321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104328:	83 c7 04             	add    $0x4,%edi
    for(int i = 0; i < NDIRECT; i++){
8010432b:	3b bd e4 fb ff ff    	cmp    -0x41c(%ebp),%edi
80104331:	0f 84 c9 00 00 00    	je     80104400 <dfs+0x110>
      addr = inode->addrs[i];
80104337:	8b 07                	mov    (%edi),%eax
      if(0 == addr) {
80104339:	85 c0                	test   %eax,%eax
8010433b:	74 eb                	je     80104328 <dfs+0x38>
      readblock(&db[0],BSIZE,(addr-1) * BSIZE);
8010433d:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
80104343:	05 ff ff 7f 00       	add    $0x7fffff,%eax
80104348:	c1 e0 09             	shl    $0x9,%eax
8010434b:	50                   	push   %eax
8010434c:	68 00 02 00 00       	push   $0x200
80104351:	53                   	push   %ebx
80104352:	e8 f9 fe ff ff       	call   80104250 <readblock>
        struct dinode* next_inode = &INODES[entry->inum%8];
        // dfs into the newly got inode and search for more legal files
        if(next_inode==inode) continue;
        // flag the found dir/file
        flag[entry->inum] = 1;
        dfs(entry->name,next_inode,depth+1);
80104357:	8b 45 10             	mov    0x10(%ebp),%eax
8010435a:	89 bd e0 fb ff ff    	mov    %edi,-0x420(%ebp)
      readblock(&db[0],BSIZE,(addr-1) * BSIZE);
80104360:	83 c4 0c             	add    $0xc,%esp
        dfs(entry->name,next_inode,depth+1);
80104363:	89 df                	mov    %ebx,%edi
80104365:	83 c0 01             	add    $0x1,%eax
80104368:	89 c3                	mov    %eax,%ebx
8010436a:	eb 0b                	jmp    80104377 <dfs+0x87>
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(int j = 0; j < ENTNUM; j++){
80104370:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104373:	39 c7                	cmp    %eax,%edi
80104375:	74 71                	je     801043e8 <dfs+0xf8>
        if(entry->name[0]=='.'||
80104377:	0f b6 57 02          	movzbl 0x2(%edi),%edx
8010437b:	83 c7 10             	add    $0x10,%edi
8010437e:	80 fa 2e             	cmp    $0x2e,%dl
80104381:	74 ed                	je     80104370 <dfs+0x80>
        entry->inum<=0||
80104383:	0f b7 57 f0          	movzwl -0x10(%edi),%edx
80104387:	8d 4a ff             	lea    -0x1(%edx),%ecx
8010438a:	66 81 f9 c7 00       	cmp    $0xc7,%cx
8010438f:	77 df                	ja     80104370 <dfs+0x80>
        readblock((char*)(&INODES),BSIZE, BSIZE + logNum * BSIZE + (entry->inum/8 * BSIZE));
80104391:	8b 0d 28 31 11 80    	mov    0x80113128,%ecx
80104397:	66 c1 ea 03          	shr    $0x3,%dx
8010439b:	0f b7 d2             	movzwl %dx,%edx
8010439e:	8d 54 11 01          	lea    0x1(%ecx,%edx,1),%edx
801043a2:	c1 e2 09             	shl    $0x9,%edx
801043a5:	52                   	push   %edx
801043a6:	68 00 02 00 00       	push   $0x200
801043ab:	56                   	push   %esi
801043ac:	e8 9f fe ff ff       	call   80104250 <readblock>
        struct dinode* next_inode = &INODES[entry->inum%8];
801043b1:	0f b7 4f f0          	movzwl -0x10(%edi),%ecx
        dfs(entry->name,next_inode,depth+1);
801043b5:	83 ec 08             	sub    $0x8,%esp
801043b8:	53                   	push   %ebx
        struct dinode* next_inode = &INODES[entry->inum%8];
801043b9:	89 ca                	mov    %ecx,%edx
        flag[entry->inum] = 1;
801043bb:	c7 04 8d 40 2d 11 80 	movl   $0x1,-0x7feed2c0(,%ecx,4)
801043c2:	01 00 00 00 
        struct dinode* next_inode = &INODES[entry->inum%8];
801043c6:	83 e2 07             	and    $0x7,%edx
801043c9:	c1 e2 06             	shl    $0x6,%edx
801043cc:	01 f2                	add    %esi,%edx
        dfs(entry->name,next_inode,depth+1);
801043ce:	52                   	push   %edx
801043cf:	8d 57 f2             	lea    -0xe(%edi),%edx
801043d2:	52                   	push   %edx
801043d3:	e8 18 ff ff ff       	call   801042f0 <dfs>
      for(int j = 0; j < ENTNUM; j++){
801043d8:	8d 45 e8             	lea    -0x18(%ebp),%eax
        dfs(entry->name,next_inode,depth+1);
801043db:	83 c4 20             	add    $0x20,%esp
      for(int j = 0; j < ENTNUM; j++){
801043de:	39 c7                	cmp    %eax,%edi
801043e0:	75 95                	jne    80104377 <dfs+0x87>
801043e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043e8:	8b bd e0 fb ff ff    	mov    -0x420(%ebp),%edi
801043ee:	83 c7 04             	add    $0x4,%edi
    for(int i = 0; i < NDIRECT; i++){
801043f1:	3b bd e4 fb ff ff    	cmp    -0x41c(%ebp),%edi
801043f7:	0f 85 3a ff ff ff    	jne    80104337 <dfs+0x47>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
        entry++;
      }
    }
  
    addr = inode->addrs[NDIRECT];
80104400:	8b 45 0c             	mov    0xc(%ebp),%eax
80104403:	8b 40 3c             	mov    0x3c(%eax),%eax
    if(addr == 0) return;
80104406:	85 c0                	test   %eax,%eax
80104408:	0f 84 f2 00 00 00    	je     80104500 <dfs+0x210>
    // get the single indirect block
    readblock(&single[0],4096,(addr-1) * BSIZE);
8010440e:	05 ff ff 7f 00       	add    $0x7fffff,%eax
80104413:	83 ec 04             	sub    $0x4,%esp
80104416:	bf 40 31 11 80       	mov    $0x80113140,%edi
8010441b:	c1 e0 09             	shl    $0x9,%eax
        if(entry->name[0]=='.'||
        entry->inum==0||
        entry->inum>200){
          continue;
        }
        readblock((char*)(&INODES),BSIZE, BSIZE + logNum * BSIZE + (entry->inum/8 * BSIZE));
8010441e:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
    readblock(&single[0],4096,(addr-1) * BSIZE);
80104424:	50                   	push   %eax
80104425:	68 00 10 00 00       	push   $0x1000
8010442a:	68 40 31 11 80       	push   $0x80113140
8010442f:	e8 1c fe ff ff       	call   80104250 <readblock>
80104434:	83 c4 10             	add    $0x10,%esp
80104437:	eb 19                	jmp    80104452 <dfs+0x162>
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104440:	81 c7 00 40 00 00    	add    $0x4000,%edi
    for(int i = 0;i < NINDIRECT;i+=4){
80104446:	81 ff 40 31 19 80    	cmp    $0x80193140,%edi
8010444c:	0f 84 ae 00 00 00    	je     80104500 <dfs+0x210>
      if(addr == 0) continue;
80104452:	85 ff                	test   %edi,%edi
80104454:	74 ea                	je     80104440 <dfs+0x150>
      readblock(&db[0],BSIZE,(addr - 1) * BSIZE);
80104456:	8d 87 ff ff 7f 00    	lea    0x7fffff(%edi),%eax
8010445c:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
80104462:	83 ec 04             	sub    $0x4,%esp
80104465:	c1 e0 09             	shl    $0x9,%eax
80104468:	50                   	push   %eax
80104469:	68 00 02 00 00       	push   $0x200
8010446e:	53                   	push   %ebx
8010446f:	e8 dc fd ff ff       	call   80104250 <readblock>
        struct dinode* next_inode = &INODES[entry->inum%8];
        flag[entry->inum] = 1;
        dfs(entry->name,next_inode,depth+1); 
80104474:	8b 45 10             	mov    0x10(%ebp),%eax
      readblock(&db[0],BSIZE,(addr - 1) * BSIZE);
80104477:	83 c4 10             	add    $0x10,%esp
        dfs(entry->name,next_inode,depth+1); 
8010447a:	83 c0 01             	add    $0x1,%eax
8010447d:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
80104483:	eb 0d                	jmp    80104492 <dfs+0x1a2>
80104485:	8d 76 00             	lea    0x0(%esi),%esi
      for(int j = 0; j < ENTNUM; j++,entry++){
80104488:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010448b:	83 c3 10             	add    $0x10,%ebx
8010448e:	39 c3                	cmp    %eax,%ebx
80104490:	74 ae                	je     80104440 <dfs+0x150>
        if(entry->name[0]=='.'||
80104492:	80 7b 02 2e          	cmpb   $0x2e,0x2(%ebx)
80104496:	74 f0                	je     80104488 <dfs+0x198>
        entry->inum==0||
80104498:	0f b7 03             	movzwl (%ebx),%eax
8010449b:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010449e:	66 81 f9 c7 00       	cmp    $0xc7,%cx
801044a3:	77 e3                	ja     80104488 <dfs+0x198>
        readblock((char*)(&INODES),BSIZE, BSIZE + logNum * BSIZE + (entry->inum/8 * BSIZE));
801044a5:	8b 0d 28 31 11 80    	mov    0x80113128,%ecx
801044ab:	66 c1 e8 03          	shr    $0x3,%ax
801044af:	83 ec 04             	sub    $0x4,%esp
801044b2:	0f b7 c0             	movzwl %ax,%eax
801044b5:	8d 44 01 01          	lea    0x1(%ecx,%eax,1),%eax
801044b9:	c1 e0 09             	shl    $0x9,%eax
801044bc:	50                   	push   %eax
801044bd:	68 00 02 00 00       	push   $0x200
801044c2:	56                   	push   %esi
801044c3:	e8 88 fd ff ff       	call   80104250 <readblock>
        struct dinode* next_inode = &INODES[entry->inum%8];
801044c8:	0f b7 0b             	movzwl (%ebx),%ecx
        dfs(entry->name,next_inode,depth+1); 
801044cb:	83 c4 0c             	add    $0xc,%esp
801044ce:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
        struct dinode* next_inode = &INODES[entry->inum%8];
801044d4:	89 c8                	mov    %ecx,%eax
        flag[entry->inum] = 1;
801044d6:	c7 04 8d 40 2d 11 80 	movl   $0x1,-0x7feed2c0(,%ecx,4)
801044dd:	01 00 00 00 
        struct dinode* next_inode = &INODES[entry->inum%8];
801044e1:	83 e0 07             	and    $0x7,%eax
801044e4:	c1 e0 06             	shl    $0x6,%eax
801044e7:	01 f0                	add    %esi,%eax
        dfs(entry->name,next_inode,depth+1); 
801044e9:	50                   	push   %eax
801044ea:	8d 43 02             	lea    0x2(%ebx),%eax
801044ed:	50                   	push   %eax
801044ee:	e8 fd fd ff ff       	call   801042f0 <dfs>
801044f3:	83 c4 10             	add    $0x10,%esp
801044f6:	eb 90                	jmp    80104488 <dfs+0x198>
801044f8:	90                   	nop
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      }
    }
  }else{
      // cprintf("name :  %s\n",name);
  }
}
80104500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104503:	5b                   	pop    %ebx
80104504:	5e                   	pop    %esi
80104505:	5f                   	pop    %edi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
80104508:	90                   	nop
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104510 <check_fs>:

void check_fs()
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	53                   	push   %ebx
    readsec(pa, offset);
80104516:	8d 85 cc fd ff ff    	lea    -0x234(%ebp),%eax
  int Fnum = 0;
  int Dnum = 0;
  uint addr;
  // int a[128];
  readblock((char*)(&sb),BSIZE,0);
  readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE);
8010451c:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
{
80104522:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  flag[ROOTINO] = 1;
80104528:	c7 05 44 2d 11 80 01 	movl   $0x1,0x80112d44
8010452f:	00 00 00 
    readsec(pa, offset);
80104532:	6a 01                	push   $0x1
80104534:	50                   	push   %eax
80104535:	e8 16 fc ff ff       	call   80104150 <readsec>
  readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE);
8010453a:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
80104540:	83 c0 01             	add    $0x1,%eax
80104543:	c1 e0 09             	shl    $0x9,%eax
80104546:	50                   	push   %eax
80104547:	68 00 02 00 00       	push   $0x200
8010454c:	56                   	push   %esi
8010454d:	e8 fe fc ff ff       	call   80104250 <readblock>
  logNum = sb.nlog;
80104552:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  struct dinode * root = &INODE[1];
  dfs("/",root,1);
80104558:	6a 01                	push   $0x1
  logNum = sb.nlog;
8010455a:	a3 28 31 11 80       	mov    %eax,0x80113128
  dfs("/",root,1);
8010455f:	8d 85 28 fe ff ff    	lea    -0x1d8(%ebp),%eax
80104565:	50                   	push   %eax
80104566:	68 b2 7a 10 80       	push   $0x80107ab2
8010456b:	e8 80 fd ff ff       	call   801042f0 <dfs>
  // cprintf("after dfs\n");
  for(int i = 1; i < sb.ninodes; i++){
80104570:	83 c4 20             	add    $0x20,%esp
80104573:	83 bd d4 fd ff ff 01 	cmpl   $0x1,-0x22c(%ebp)
8010457a:	76 6d                	jbe    801045e9 <check_fs+0xd9>
8010457c:	bf 01 00 00 00       	mov    $0x1,%edi
  int Fnum = 0;
80104581:	c7 85 c4 fd ff ff 00 	movl   $0x0,-0x23c(%ebp)
80104588:	00 00 00 
  int Dnum = 0;
8010458b:	31 db                	xor    %ebx,%ebx
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
    if(i % 8 == 0){
      readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE + i / 8 * BSIZE);
    }
    check = &INODE[i % 8];
    if(flag[i] == 0 && check->type != 0){
80104590:	8b 14 bd 40 2d 11 80 	mov    -0x7feed2c0(,%edi,4),%edx
80104597:	85 d2                	test   %edx,%edx
80104599:	75 15                	jne    801045b0 <check_fs+0xa0>
    check = &INODE[i % 8];
8010459b:	89 f9                	mov    %edi,%ecx
8010459d:	83 e1 07             	and    $0x7,%ecx
    if(flag[i] == 0 && check->type != 0){
801045a0:	89 ca                	mov    %ecx,%edx
801045a2:	c1 e2 06             	shl    $0x6,%edx
801045a5:	66 83 bc 15 e8 fd ff 	cmpw   $0x0,-0x218(%ebp,%edx,1)
801045ac:	ff 00 
801045ae:	75 68                	jne    80104618 <check_fs+0x108>
  for(int i = 1; i < sb.ninodes; i++){
801045b0:	83 c7 01             	add    $0x1,%edi
801045b3:	39 bd d4 fd ff ff    	cmp    %edi,-0x22c(%ebp)
801045b9:	76 3a                	jbe    801045f5 <check_fs+0xe5>
    if(i % 8 == 0){
801045bb:	f7 c7 07 00 00 00    	test   $0x7,%edi
801045c1:	75 cd                	jne    80104590 <check_fs+0x80>
      readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE + i / 8 * BSIZE);
801045c3:	8b 95 d8 fd ff ff    	mov    -0x228(%ebp),%edx
801045c9:	89 f8                	mov    %edi,%eax
801045cb:	83 ec 04             	sub    $0x4,%esp
801045ce:	c1 f8 03             	sar    $0x3,%eax
801045d1:	8d 44 02 01          	lea    0x1(%edx,%eax,1),%eax
801045d5:	c1 e0 09             	shl    $0x9,%eax
801045d8:	50                   	push   %eax
801045d9:	68 00 02 00 00       	push   $0x200
801045de:	56                   	push   %esi
801045df:	e8 6c fc ff ff       	call   80104250 <readblock>
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	eb a7                	jmp    80104590 <check_fs+0x80>
  int Dnum = 0;
801045e9:	31 db                	xor    %ebx,%ebx
  int Fnum = 0;
801045eb:	c7 85 c4 fd ff ff 00 	movl   $0x0,-0x23c(%ebp)
801045f2:	00 00 00 
      writeblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE + (i / 8) * BSIZE);
      cprintf("Fixing ... done");
    }
  }
  if(checkFlag){
    cprintf("\nfsck completed. Fixed %d inodes and freed %d disk blocks.\n ",Fnum,Dnum);
801045f5:	83 ec 04             	sub    $0x4,%esp
801045f8:	53                   	push   %ebx
801045f9:	ff b5 c4 fd ff ff    	pushl  -0x23c(%ebp)
801045ff:	68 d4 7b 10 80       	push   $0x80107bd4
80104604:	e8 57 c0 ff ff       	call   80100660 <cprintf>
  }else{
    cprintf(" fsck: no problem found. ");
  }
80104609:	83 c4 10             	add    $0x10,%esp
8010460c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010460f:	5b                   	pop    %ebx
80104610:	5e                   	pop    %esi
80104611:	5f                   	pop    %edi
80104612:	5d                   	pop    %ebp
80104613:	c3                   	ret    
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      check->type = 0;
80104618:	31 c0                	xor    %eax,%eax
      Fnum = Fnum + 1;
8010461a:	83 85 c4 fd ff ff 01 	addl   $0x1,-0x23c(%ebp)
      check->type = 0;
80104621:	66 89 84 15 e8 fd ff 	mov    %ax,-0x218(%ebp,%edx,1)
80104628:	ff 
80104629:	8d 44 16 0c          	lea    0xc(%esi,%edx,1),%eax
8010462d:	89 85 c0 fd ff ff    	mov    %eax,-0x240(%ebp)
80104633:	8d 85 24 fe ff ff    	lea    -0x1dc(%ebp),%eax
80104639:	01 c2                	add    %eax,%edx
8010463b:	8b 85 c0 fd ff ff    	mov    -0x240(%ebp),%eax
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        Dnum++;
80104648:	83 38 01             	cmpl   $0x1,(%eax)
8010464b:	83 db ff             	sbb    $0xffffffff,%ebx
8010464e:	83 c0 04             	add    $0x4,%eax
      for(int i = 0; i < NDIRECT; i++){
80104651:	39 d0                	cmp    %edx,%eax
80104653:	75 f3                	jne    80104648 <check_fs+0x138>
        addr = check->addrs[NDIRECT];
80104655:	c1 e1 06             	shl    $0x6,%ecx
80104658:	8b 84 0d 24 fe ff ff 	mov    -0x1dc(%ebp,%ecx,1),%eax
        if(addr != 0){
8010465f:	85 c0                	test   %eax,%eax
80104661:	75 4d                	jne    801046b0 <check_fs+0x1a0>
      cprintf("\nfsck: inode %d is allocated but is not referenced by any dir!",i);
80104663:	83 ec 08             	sub    $0x8,%esp
80104666:	57                   	push   %edi
80104667:	68 94 7b 10 80       	push   $0x80107b94
8010466c:	e8 ef bf ff ff       	call   80100660 <cprintf>
      writeblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE + (i / 8) * BSIZE);
80104671:	8b 95 d8 fd ff ff    	mov    -0x228(%ebp),%edx
80104677:	89 f8                	mov    %edi,%eax
80104679:	83 c4 0c             	add    $0xc,%esp
8010467c:	c1 f8 03             	sar    $0x3,%eax
8010467f:	8d 44 02 01          	lea    0x1(%edx,%eax,1),%eax
80104683:	c1 e0 09             	shl    $0x9,%eax
80104686:	50                   	push   %eax
80104687:	68 00 02 00 00       	push   $0x200
8010468c:	56                   	push   %esi
8010468d:	e8 0e fc ff ff       	call   801042a0 <writeblock>
      cprintf("Fixing ... done");
80104692:	c7 04 24 31 7b 10 80 	movl   $0x80107b31,(%esp)
80104699:	e8 c2 bf ff ff       	call   80100660 <cprintf>
8010469e:	83 c4 10             	add    $0x10,%esp
801046a1:	e9 0a ff ff ff       	jmp    801045b0 <check_fs+0xa0>
801046a6:	8d 76 00             	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          readblock(&single[0],4096,(addr-1) * BSIZE);
801046b0:	05 ff ff 7f 00       	add    $0x7fffff,%eax
801046b5:	83 ec 04             	sub    $0x4,%esp
801046b8:	c1 e0 09             	shl    $0x9,%eax
801046bb:	50                   	push   %eax
801046bc:	68 00 10 00 00       	push   $0x1000
801046c1:	68 40 31 11 80       	push   $0x80113140
801046c6:	e8 85 fb ff ff       	call   80104250 <readblock>
801046cb:	b8 40 31 11 80       	mov    $0x80113140,%eax
801046d0:	83 c4 10             	add    $0x10,%esp
801046d3:	90                   	nop
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          Dnum++;
801046d8:	83 f8 01             	cmp    $0x1,%eax
801046db:	83 db ff             	sbb    $0xffffffff,%ebx
801046de:	05 00 40 00 00       	add    $0x4000,%eax
          for(int i = 0;i < BSIZE;i+=4){
801046e3:	3d 40 31 31 80       	cmp    $0x80313140,%eax
801046e8:	75 ee                	jne    801046d8 <check_fs+0x1c8>
801046ea:	e9 74 ff ff ff       	jmp    80104663 <check_fs+0x153>
801046ef:	90                   	nop

801046f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046fa:	68 2c 7c 10 80       	push   $0x80107c2c
801046ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104702:	50                   	push   %eax
80104703:	e8 f8 00 00 00       	call   80104800 <initlock>
  lk->name = name;
80104708:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010470b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104711:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104714:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010471b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010471e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104721:	c9                   	leave  
80104722:	c3                   	ret    
80104723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	8d 73 04             	lea    0x4(%ebx),%esi
8010473e:	56                   	push   %esi
8010473f:	e8 ac 01 00 00       	call   801048f0 <acquire>
  while (lk->locked) {
80104744:	8b 13                	mov    (%ebx),%edx
80104746:	83 c4 10             	add    $0x10,%esp
80104749:	85 d2                	test   %edx,%edx
8010474b:	74 16                	je     80104763 <acquiresleep+0x33>
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104750:	83 ec 08             	sub    $0x8,%esp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	e8 86 f6 ff ff       	call   80103de0 <sleep>
  while (lk->locked) {
8010475a:	8b 03                	mov    (%ebx),%eax
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	85 c0                	test   %eax,%eax
80104761:	75 ed                	jne    80104750 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104763:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104769:	e8 a2 f0 ff ff       	call   80103810 <myproc>
8010476e:	8b 40 10             	mov    0x10(%eax),%eax
80104771:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104774:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104777:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010477a:	5b                   	pop    %ebx
8010477b:	5e                   	pop    %esi
8010477c:	5d                   	pop    %ebp
  release(&lk->lk);
8010477d:	e9 8e 02 00 00       	jmp    80104a10 <release>
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	8d 73 04             	lea    0x4(%ebx),%esi
8010479e:	56                   	push   %esi
8010479f:	e8 4c 01 00 00       	call   801048f0 <acquire>
  lk->locked = 0;
801047a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047b1:	89 1c 24             	mov    %ebx,(%esp)
801047b4:	e8 d7 f7 ff ff       	call   80103f90 <wakeup>
  release(&lk->lk);
801047b9:	89 75 08             	mov    %esi,0x8(%ebp)
801047bc:	83 c4 10             	add    $0x10,%esp
}
801047bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c2:	5b                   	pop    %ebx
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
  release(&lk->lk);
801047c5:	e9 46 02 00 00       	jmp    80104a10 <release>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801047d8:	83 ec 0c             	sub    $0xc,%esp
801047db:	8d 5e 04             	lea    0x4(%esi),%ebx
801047de:	53                   	push   %ebx
801047df:	e8 0c 01 00 00       	call   801048f0 <acquire>
  r = lk->locked;
801047e4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801047e6:	89 1c 24             	mov    %ebx,(%esp)
801047e9:	e8 22 02 00 00       	call   80104a10 <release>
  return r;
}
801047ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047f1:	89 f0                	mov    %esi,%eax
801047f3:	5b                   	pop    %ebx
801047f4:	5e                   	pop    %esi
801047f5:	5d                   	pop    %ebp
801047f6:	c3                   	ret    
801047f7:	66 90                	xchg   %ax,%ax
801047f9:	66 90                	xchg   %ax,%ax
801047fb:	66 90                	xchg   %ax,%ax
801047fd:	66 90                	xchg   %ax,%ax
801047ff:	90                   	nop

80104800 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104806:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010480f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104812:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104820 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104820:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104821:	31 d2                	xor    %edx,%edx
{
80104823:	89 e5                	mov    %esp,%ebp
80104825:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104826:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010482c:	83 e8 08             	sub    $0x8,%eax
8010482f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104830:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104836:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010483c:	77 1a                	ja     80104858 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010483e:	8b 58 04             	mov    0x4(%eax),%ebx
80104841:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104844:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104847:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104849:	83 fa 0a             	cmp    $0xa,%edx
8010484c:	75 e2                	jne    80104830 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010484e:	5b                   	pop    %ebx
8010484f:	5d                   	pop    %ebp
80104850:	c3                   	ret    
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104858:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010485b:	83 c1 28             	add    $0x28,%ecx
8010485e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104866:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104869:	39 c1                	cmp    %eax,%ecx
8010486b:	75 f3                	jne    80104860 <getcallerpcs+0x40>
}
8010486d:	5b                   	pop    %ebx
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret    

80104870 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
80104877:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010487a:	8b 02                	mov    (%edx),%eax
8010487c:	85 c0                	test   %eax,%eax
8010487e:	75 10                	jne    80104890 <holding+0x20>
}
80104880:	83 c4 04             	add    $0x4,%esp
80104883:	31 c0                	xor    %eax,%eax
80104885:	5b                   	pop    %ebx
80104886:	5d                   	pop    %ebp
80104887:	c3                   	ret    
80104888:	90                   	nop
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104890:	8b 5a 08             	mov    0x8(%edx),%ebx
80104893:	e8 d8 ee ff ff       	call   80103770 <mycpu>
80104898:	39 c3                	cmp    %eax,%ebx
8010489a:	0f 94 c0             	sete   %al
}
8010489d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801048a0:	0f b6 c0             	movzbl %al,%eax
}
801048a3:	5b                   	pop    %ebx
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret    
801048a6:	8d 76 00             	lea    0x0(%esi),%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048b7:	9c                   	pushf  
801048b8:	5b                   	pop    %ebx
  asm volatile("cli");
801048b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ba:	e8 b1 ee ff ff       	call   80103770 <mycpu>
801048bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048c5:	85 c0                	test   %eax,%eax
801048c7:	75 11                	jne    801048da <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048cf:	e8 9c ee ff ff       	call   80103770 <mycpu>
801048d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048da:	e8 91 ee ff ff       	call   80103770 <mycpu>
801048df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048e6:	83 c4 04             	add    $0x4,%esp
801048e9:	5b                   	pop    %ebx
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <acquire>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801048f5:	e8 b6 ff ff ff       	call   801048b0 <pushcli>
  if(holding(lk))
801048fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801048fd:	8b 03                	mov    (%ebx),%eax
801048ff:	85 c0                	test   %eax,%eax
80104901:	0f 85 81 00 00 00    	jne    80104988 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104907:	ba 01 00 00 00       	mov    $0x1,%edx
8010490c:	eb 05                	jmp    80104913 <acquire+0x23>
8010490e:	66 90                	xchg   %ax,%ax
80104910:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104913:	89 d0                	mov    %edx,%eax
80104915:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104918:	85 c0                	test   %eax,%eax
8010491a:	75 f4                	jne    80104910 <acquire+0x20>
  __sync_synchronize();
8010491c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104921:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104924:	e8 47 ee ff ff       	call   80103770 <mycpu>
  for(i = 0; i < 10; i++){
80104929:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010492b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010492e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104931:	89 e8                	mov    %ebp,%eax
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104938:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010493e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104944:	77 1a                	ja     80104960 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104946:	8b 58 04             	mov    0x4(%eax),%ebx
80104949:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010494c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010494f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104951:	83 fa 0a             	cmp    $0xa,%edx
80104954:	75 e2                	jne    80104938 <acquire+0x48>
}
80104956:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104959:	5b                   	pop    %ebx
8010495a:	5e                   	pop    %esi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret    
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104963:	83 c1 28             	add    $0x28,%ecx
80104966:	8d 76 00             	lea    0x0(%esi),%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104976:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104979:	39 c8                	cmp    %ecx,%eax
8010497b:	75 f3                	jne    80104970 <acquire+0x80>
}
8010497d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104980:	5b                   	pop    %ebx
80104981:	5e                   	pop    %esi
80104982:	5d                   	pop    %ebp
80104983:	c3                   	ret    
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104988:	8b 73 08             	mov    0x8(%ebx),%esi
8010498b:	e8 e0 ed ff ff       	call   80103770 <mycpu>
80104990:	39 c6                	cmp    %eax,%esi
80104992:	0f 85 6f ff ff ff    	jne    80104907 <acquire+0x17>
    panic("acquire");
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	68 37 7c 10 80       	push   $0x80107c37
801049a0:	e8 eb b9 ff ff       	call   80100390 <panic>
801049a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <popcli>:

void
popcli(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049b6:	9c                   	pushf  
801049b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049b8:	f6 c4 02             	test   $0x2,%ah
801049bb:	75 35                	jne    801049f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049bd:	e8 ae ed ff ff       	call   80103770 <mycpu>
801049c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049c9:	78 34                	js     801049ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049cb:	e8 a0 ed ff ff       	call   80103770 <mycpu>
801049d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049d6:	85 d2                	test   %edx,%edx
801049d8:	74 06                	je     801049e0 <popcli+0x30>
    sti();
}
801049da:	c9                   	leave  
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049e0:	e8 8b ed ff ff       	call   80103770 <mycpu>
801049e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049eb:	85 c0                	test   %eax,%eax
801049ed:	74 eb                	je     801049da <popcli+0x2a>
  asm volatile("sti");
801049ef:	fb                   	sti    
}
801049f0:	c9                   	leave  
801049f1:	c3                   	ret    
    panic("popcli - interruptible");
801049f2:	83 ec 0c             	sub    $0xc,%esp
801049f5:	68 3f 7c 10 80       	push   $0x80107c3f
801049fa:	e8 91 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	68 56 7c 10 80       	push   $0x80107c56
80104a07:	e8 84 b9 ff ff       	call   80100390 <panic>
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <release>:
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104a18:	8b 03                	mov    (%ebx),%eax
80104a1a:	85 c0                	test   %eax,%eax
80104a1c:	74 0c                	je     80104a2a <release+0x1a>
80104a1e:	8b 73 08             	mov    0x8(%ebx),%esi
80104a21:	e8 4a ed ff ff       	call   80103770 <mycpu>
80104a26:	39 c6                	cmp    %eax,%esi
80104a28:	74 16                	je     80104a40 <release+0x30>
    panic("release");
80104a2a:	83 ec 0c             	sub    $0xc,%esp
80104a2d:	68 5d 7c 10 80       	push   $0x80107c5d
80104a32:	e8 59 b9 ff ff       	call   80100390 <panic>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104a40:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a47:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a4e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a53:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a5c:	5b                   	pop    %ebx
80104a5d:	5e                   	pop    %esi
80104a5e:	5d                   	pop    %ebp
  popcli();
80104a5f:	e9 4c ff ff ff       	jmp    801049b0 <popcli>
80104a64:	66 90                	xchg   %ax,%ax
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	53                   	push   %ebx
80104a75:	8b 55 08             	mov    0x8(%ebp),%edx
80104a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a7b:	f6 c2 03             	test   $0x3,%dl
80104a7e:	75 05                	jne    80104a85 <memset+0x15>
80104a80:	f6 c1 03             	test   $0x3,%cl
80104a83:	74 13                	je     80104a98 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a85:	89 d7                	mov    %edx,%edi
80104a87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8a:	fc                   	cld    
80104a8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a8d:	5b                   	pop    %ebx
80104a8e:	89 d0                	mov    %edx,%eax
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a9c:	c1 e9 02             	shr    $0x2,%ecx
80104a9f:	89 f8                	mov    %edi,%eax
80104aa1:	89 fb                	mov    %edi,%ebx
80104aa3:	c1 e0 18             	shl    $0x18,%eax
80104aa6:	c1 e3 10             	shl    $0x10,%ebx
80104aa9:	09 d8                	or     %ebx,%eax
80104aab:	09 f8                	or     %edi,%eax
80104aad:	c1 e7 08             	shl    $0x8,%edi
80104ab0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ab2:	89 d7                	mov    %edx,%edi
80104ab4:	fc                   	cld    
80104ab5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ab7:	5b                   	pop    %ebx
80104ab8:	89 d0                	mov    %edx,%eax
80104aba:	5f                   	pop    %edi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ac9:	8b 75 08             	mov    0x8(%ebp),%esi
80104acc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104acf:	85 db                	test   %ebx,%ebx
80104ad1:	74 29                	je     80104afc <memcmp+0x3c>
    if(*s1 != *s2)
80104ad3:	0f b6 16             	movzbl (%esi),%edx
80104ad6:	0f b6 0f             	movzbl (%edi),%ecx
80104ad9:	38 d1                	cmp    %dl,%cl
80104adb:	75 2b                	jne    80104b08 <memcmp+0x48>
80104add:	b8 01 00 00 00       	mov    $0x1,%eax
80104ae2:	eb 14                	jmp    80104af8 <memcmp+0x38>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104aec:	83 c0 01             	add    $0x1,%eax
80104aef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104af4:	38 ca                	cmp    %cl,%dl
80104af6:	75 10                	jne    80104b08 <memcmp+0x48>
  while(n-- > 0){
80104af8:	39 d8                	cmp    %ebx,%eax
80104afa:	75 ec                	jne    80104ae8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104afc:	5b                   	pop    %ebx
  return 0;
80104afd:	31 c0                	xor    %eax,%eax
}
80104aff:	5e                   	pop    %esi
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b08:	0f b6 c2             	movzbl %dl,%eax
}
80104b0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b0c:	29 c8                	sub    %ecx,%eax
}
80104b0e:	5e                   	pop    %esi
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 45 08             	mov    0x8(%ebp),%eax
80104b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b2e:	39 c3                	cmp    %eax,%ebx
80104b30:	73 26                	jae    80104b58 <memmove+0x38>
80104b32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b35:	39 c8                	cmp    %ecx,%eax
80104b37:	73 1f                	jae    80104b58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b39:	85 f6                	test   %esi,%esi
80104b3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b3e:	74 0f                	je     80104b4f <memmove+0x2f>
      *--d = *--s;
80104b40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b47:	83 ea 01             	sub    $0x1,%edx
80104b4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b4d:	75 f1                	jne    80104b40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b58:	31 d2                	xor    %edx,%edx
80104b5a:	85 f6                	test   %esi,%esi
80104b5c:	74 f1                	je     80104b4f <memmove+0x2f>
80104b5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b6a:	39 d6                	cmp    %edx,%esi
80104b6c:	75 f2                	jne    80104b60 <memmove+0x40>
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b84:	eb 9a                	jmp    80104b20 <memmove>
80104b86:	8d 76 00             	lea    0x0(%esi),%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b98:	53                   	push   %ebx
80104b99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b9f:	85 ff                	test   %edi,%edi
80104ba1:	74 2f                	je     80104bd2 <strncmp+0x42>
80104ba3:	0f b6 01             	movzbl (%ecx),%eax
80104ba6:	0f b6 1e             	movzbl (%esi),%ebx
80104ba9:	84 c0                	test   %al,%al
80104bab:	74 37                	je     80104be4 <strncmp+0x54>
80104bad:	38 c3                	cmp    %al,%bl
80104baf:	75 33                	jne    80104be4 <strncmp+0x54>
80104bb1:	01 f7                	add    %esi,%edi
80104bb3:	eb 13                	jmp    80104bc8 <strncmp+0x38>
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
80104bb8:	0f b6 01             	movzbl (%ecx),%eax
80104bbb:	84 c0                	test   %al,%al
80104bbd:	74 21                	je     80104be0 <strncmp+0x50>
80104bbf:	0f b6 1a             	movzbl (%edx),%ebx
80104bc2:	89 d6                	mov    %edx,%esi
80104bc4:	38 d8                	cmp    %bl,%al
80104bc6:	75 1c                	jne    80104be4 <strncmp+0x54>
    n--, p++, q++;
80104bc8:	8d 56 01             	lea    0x1(%esi),%edx
80104bcb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104bce:	39 fa                	cmp    %edi,%edx
80104bd0:	75 e6                	jne    80104bb8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104bd2:	5b                   	pop    %ebx
    return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	5e                   	pop    %esi
80104bd6:	5f                   	pop    %edi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104be4:	29 d8                	sub    %ebx,%eax
}
80104be6:	5b                   	pop    %ebx
80104be7:	5e                   	pop    %esi
80104be8:	5f                   	pop    %edi
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	90                   	nop
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bfe:	89 c2                	mov    %eax,%edx
80104c00:	eb 19                	jmp    80104c1b <strncpy+0x2b>
80104c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c08:	83 c3 01             	add    $0x1,%ebx
80104c0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c0f:	83 c2 01             	add    $0x1,%edx
80104c12:	84 c9                	test   %cl,%cl
80104c14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c17:	74 09                	je     80104c22 <strncpy+0x32>
80104c19:	89 f1                	mov    %esi,%ecx
80104c1b:	85 c9                	test   %ecx,%ecx
80104c1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c20:	7f e6                	jg     80104c08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c22:	31 c9                	xor    %ecx,%ecx
80104c24:	85 f6                	test   %esi,%esi
80104c26:	7e 17                	jle    80104c3f <strncpy+0x4f>
80104c28:	90                   	nop
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c34:	89 f3                	mov    %esi,%ebx
80104c36:	83 c1 01             	add    $0x1,%ecx
80104c39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c3b:	85 db                	test   %ebx,%ebx
80104c3d:	7f f1                	jg     80104c30 <strncpy+0x40>
  return os;
}
80104c3f:	5b                   	pop    %ebx
80104c40:	5e                   	pop    %esi
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    
80104c43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c58:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c5e:	85 c9                	test   %ecx,%ecx
80104c60:	7e 26                	jle    80104c88 <safestrcpy+0x38>
80104c62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c66:	89 c1                	mov    %eax,%ecx
80104c68:	eb 17                	jmp    80104c81 <safestrcpy+0x31>
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c70:	83 c2 01             	add    $0x1,%edx
80104c73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c77:	83 c1 01             	add    $0x1,%ecx
80104c7a:	84 db                	test   %bl,%bl
80104c7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c7f:	74 04                	je     80104c85 <safestrcpy+0x35>
80104c81:	39 f2                	cmp    %esi,%edx
80104c83:	75 eb                	jne    80104c70 <safestrcpy+0x20>
    ;
  *s = 0;
80104c85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <strlen>:

int
strlen(const char *s)
{
80104c90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c91:	31 c0                	xor    %eax,%eax
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c98:	80 3a 00             	cmpb   $0x0,(%edx)
80104c9b:	74 0c                	je     80104ca9 <strlen+0x19>
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ca0:	83 c0 01             	add    $0x1,%eax
80104ca3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ca7:	75 f7                	jne    80104ca0 <strlen+0x10>
    ;
  return n;
}
80104ca9:	5d                   	pop    %ebp
80104caa:	c3                   	ret    

80104cab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104cab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104caf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104cb3:	55                   	push   %ebp
  pushl %ebx
80104cb4:	53                   	push   %ebx
  pushl %esi
80104cb5:	56                   	push   %esi
  pushl %edi
80104cb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cb9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104cbb:	5f                   	pop    %edi
  popl %esi
80104cbc:	5e                   	pop    %esi
  popl %ebx
80104cbd:	5b                   	pop    %ebx
  popl %ebp
80104cbe:	5d                   	pop    %ebp
  ret
80104cbf:	c3                   	ret    

80104cc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104cca:	e8 41 eb ff ff       	call   80103810 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ccf:	8b 00                	mov    (%eax),%eax
80104cd1:	39 d8                	cmp    %ebx,%eax
80104cd3:	76 1b                	jbe    80104cf0 <fetchint+0x30>
80104cd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104cd8:	39 d0                	cmp    %edx,%eax
80104cda:	72 14                	jb     80104cf0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cdf:	8b 13                	mov    (%ebx),%edx
80104ce1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ce3:	31 c0                	xor    %eax,%eax
}
80104ce5:	83 c4 04             	add    $0x4,%esp
80104ce8:	5b                   	pop    %ebx
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf5:	eb ee                	jmp    80104ce5 <fetchint+0x25>
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d0a:	e8 01 eb ff ff       	call   80103810 <myproc>

  if(addr >= curproc->sz)
80104d0f:	39 18                	cmp    %ebx,(%eax)
80104d11:	76 29                	jbe    80104d3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d16:	89 da                	mov    %ebx,%edx
80104d18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d1c:	39 c3                	cmp    %eax,%ebx
80104d1e:	73 1c                	jae    80104d3c <fetchstr+0x3c>
    if(*s == 0)
80104d20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d23:	75 10                	jne    80104d35 <fetchstr+0x35>
80104d25:	eb 39                	jmp    80104d60 <fetchstr+0x60>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d30:	80 3a 00             	cmpb   $0x0,(%edx)
80104d33:	74 1b                	je     80104d50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d35:	83 c2 01             	add    $0x1,%edx
80104d38:	39 d0                	cmp    %edx,%eax
80104d3a:	77 f4                	ja     80104d30 <fetchstr+0x30>
    return -1;
80104d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d41:	83 c4 04             	add    $0x4,%esp
80104d44:	5b                   	pop    %ebx
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d50:	83 c4 04             	add    $0x4,%esp
80104d53:	89 d0                	mov    %edx,%eax
80104d55:	29 d8                	sub    %ebx,%eax
80104d57:	5b                   	pop    %ebx
80104d58:	5d                   	pop    %ebp
80104d59:	c3                   	ret    
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d62:	eb dd                	jmp    80104d41 <fetchstr+0x41>
80104d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d75:	e8 96 ea ff ff       	call   80103810 <myproc>
80104d7a:	8b 40 18             	mov    0x18(%eax),%eax
80104d7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d80:	8b 40 44             	mov    0x44(%eax),%eax
80104d83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d86:	e8 85 ea ff ff       	call   80103810 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d90:	39 c6                	cmp    %eax,%esi
80104d92:	73 1c                	jae    80104db0 <argint+0x40>
80104d94:	8d 53 08             	lea    0x8(%ebx),%edx
80104d97:	39 d0                	cmp    %edx,%eax
80104d99:	72 15                	jb     80104db0 <argint+0x40>
  *ip = *(int*)(addr);
80104d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104da1:	89 10                	mov    %edx,(%eax)
  return 0;
80104da3:	31 c0                	xor    %eax,%eax
}
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5d                   	pop    %ebp
80104da8:	c3                   	ret    
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104db5:	eb ee                	jmp    80104da5 <argint+0x35>
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
80104dc5:	83 ec 10             	sub    $0x10,%esp
80104dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dcb:	e8 40 ea ff ff       	call   80103810 <myproc>
80104dd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd5:	83 ec 08             	sub    $0x8,%esp
80104dd8:	50                   	push   %eax
80104dd9:	ff 75 08             	pushl  0x8(%ebp)
80104ddc:	e8 8f ff ff ff       	call   80104d70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104de1:	83 c4 10             	add    $0x10,%esp
80104de4:	85 c0                	test   %eax,%eax
80104de6:	78 28                	js     80104e10 <argptr+0x50>
80104de8:	85 db                	test   %ebx,%ebx
80104dea:	78 24                	js     80104e10 <argptr+0x50>
80104dec:	8b 16                	mov    (%esi),%edx
80104dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df1:	39 c2                	cmp    %eax,%edx
80104df3:	76 1b                	jbe    80104e10 <argptr+0x50>
80104df5:	01 c3                	add    %eax,%ebx
80104df7:	39 da                	cmp    %ebx,%edx
80104df9:	72 15                	jb     80104e10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dfe:	89 02                	mov    %eax,(%edx)
  return 0;
80104e00:	31 c0                	xor    %eax,%eax
}
80104e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e15:	eb eb                	jmp    80104e02 <argptr+0x42>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e29:	50                   	push   %eax
80104e2a:	ff 75 08             	pushl  0x8(%ebp)
80104e2d:	e8 3e ff ff ff       	call   80104d70 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 17                	js     80104e50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	ff 75 0c             	pushl  0xc(%ebp)
80104e3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e42:	e8 b9 fe ff ff       	call   80104d00 <fetchstr>
80104e47:	83 c4 10             	add    $0x10,%esp
}
80104e4a:	c9                   	leave  
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <syscall>:
[SYS_shutdown] sys_shutdown,
};

void
syscall(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e67:	e8 a4 e9 ff ff       	call   80103810 <myproc>
80104e6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e6e:	8b 40 18             	mov    0x18(%eax),%eax
80104e71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e77:	83 fa 15             	cmp    $0x15,%edx
80104e7a:	77 1c                	ja     80104e98 <syscall+0x38>
80104e7c:	8b 14 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%edx
80104e83:	85 d2                	test   %edx,%edx
80104e85:	74 11                	je     80104e98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e87:	ff d2                	call   *%edx
80104e89:	8b 53 18             	mov    0x18(%ebx),%edx
80104e8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e92:	c9                   	leave  
80104e93:	c3                   	ret    
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e9c:	50                   	push   %eax
80104e9d:	ff 73 10             	pushl  0x10(%ebx)
80104ea0:	68 65 7c 10 80       	push   $0x80107c65
80104ea5:	e8 b6 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104eaa:	8b 43 18             	mov    0x18(%ebx),%eax
80104ead:	83 c4 10             	add    $0x10,%esp
80104eb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eba:	c9                   	leave  
80104ebb:	c3                   	ret    
80104ebc:	66 90                	xchg   %ax,%ax
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ec6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ec9:	83 ec 44             	sub    $0x44,%esp
80104ecc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104ecf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ed2:	56                   	push   %esi
80104ed3:	50                   	push   %eax
{
80104ed4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ed7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eda:	e8 31 d0 ff ff       	call   80101f10 <nameiparent>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	0f 84 46 01 00 00    	je     80105030 <create+0x170>
    return 0;
  ilock(dp);
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	89 c3                	mov    %eax,%ebx
80104eef:	50                   	push   %eax
80104ef0:	e8 9b c7 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ef5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ef8:	83 c4 0c             	add    $0xc,%esp
80104efb:	50                   	push   %eax
80104efc:	56                   	push   %esi
80104efd:	53                   	push   %ebx
80104efe:	e8 bd cc ff ff       	call   80101bc0 <dirlookup>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	89 c7                	mov    %eax,%edi
80104f0a:	74 34                	je     80104f40 <create+0x80>
    iunlockput(dp);
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	53                   	push   %ebx
80104f10:	e8 0b ca ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104f15:	89 3c 24             	mov    %edi,(%esp)
80104f18:	e8 73 c7 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104f25:	0f 85 95 00 00 00    	jne    80104fc0 <create+0x100>
80104f2b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f30:	0f 85 8a 00 00 00    	jne    80104fc0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f39:	89 f8                	mov    %edi,%eax
80104f3b:	5b                   	pop    %ebx
80104f3c:	5e                   	pop    %esi
80104f3d:	5f                   	pop    %edi
80104f3e:	5d                   	pop    %ebp
80104f3f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104f40:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104f44:	83 ec 08             	sub    $0x8,%esp
80104f47:	50                   	push   %eax
80104f48:	ff 33                	pushl  (%ebx)
80104f4a:	e8 d1 c5 ff ff       	call   80101520 <ialloc>
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	85 c0                	test   %eax,%eax
80104f54:	89 c7                	mov    %eax,%edi
80104f56:	0f 84 e8 00 00 00    	je     80105044 <create+0x184>
  ilock(ip);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	50                   	push   %eax
80104f60:	e8 2b c7 ff ff       	call   80101690 <ilock>
  ip->major = major;
80104f65:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f69:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104f6d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f71:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104f75:	b8 01 00 00 00       	mov    $0x1,%eax
80104f7a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104f7e:	89 3c 24             	mov    %edi,(%esp)
80104f81:	e8 5a c6 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f8e:	74 50                	je     80104fe0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f90:	83 ec 04             	sub    $0x4,%esp
80104f93:	ff 77 04             	pushl  0x4(%edi)
80104f96:	56                   	push   %esi
80104f97:	53                   	push   %ebx
80104f98:	e8 93 ce ff ff       	call   80101e30 <dirlink>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	0f 88 8f 00 00 00    	js     80105037 <create+0x177>
  iunlockput(dp);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	53                   	push   %ebx
80104fac:	e8 6f c9 ff ff       	call   80101920 <iunlockput>
  return ip;
80104fb1:	83 c4 10             	add    $0x10,%esp
}
80104fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb7:	89 f8                	mov    %edi,%eax
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5f                   	pop    %edi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	57                   	push   %edi
    return 0;
80104fc4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104fc6:	e8 55 c9 ff ff       	call   80101920 <iunlockput>
    return 0;
80104fcb:	83 c4 10             	add    $0x10,%esp
}
80104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd1:	89 f8                	mov    %edi,%eax
80104fd3:	5b                   	pop    %ebx
80104fd4:	5e                   	pop    %esi
80104fd5:	5f                   	pop    %edi
80104fd6:	5d                   	pop    %ebp
80104fd7:	c3                   	ret    
80104fd8:	90                   	nop
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104fe0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	53                   	push   %ebx
80104fe9:	e8 f2 c5 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fee:	83 c4 0c             	add    $0xc,%esp
80104ff1:	ff 77 04             	pushl  0x4(%edi)
80104ff4:	68 18 7d 10 80       	push   $0x80107d18
80104ff9:	57                   	push   %edi
80104ffa:	e8 31 ce ff ff       	call   80101e30 <dirlink>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	78 1c                	js     80105022 <create+0x162>
80105006:	83 ec 04             	sub    $0x4,%esp
80105009:	ff 73 04             	pushl  0x4(%ebx)
8010500c:	68 17 7d 10 80       	push   $0x80107d17
80105011:	57                   	push   %edi
80105012:	e8 19 ce ff ff       	call   80101e30 <dirlink>
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	85 c0                	test   %eax,%eax
8010501c:	0f 89 6e ff ff ff    	jns    80104f90 <create+0xd0>
      panic("create dots");
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 0b 7d 10 80       	push   $0x80107d0b
8010502a:	e8 61 b3 ff ff       	call   80100390 <panic>
8010502f:	90                   	nop
    return 0;
80105030:	31 ff                	xor    %edi,%edi
80105032:	e9 ff fe ff ff       	jmp    80104f36 <create+0x76>
    panic("create: dirlink");
80105037:	83 ec 0c             	sub    $0xc,%esp
8010503a:	68 1a 7d 10 80       	push   $0x80107d1a
8010503f:	e8 4c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 fc 7c 10 80       	push   $0x80107cfc
8010504c:	e8 3f b3 ff ff       	call   80100390 <panic>
80105051:	eb 0d                	jmp    80105060 <argfd.constprop.0>
80105053:	90                   	nop
80105054:	90                   	nop
80105055:	90                   	nop
80105056:	90                   	nop
80105057:	90                   	nop
80105058:	90                   	nop
80105059:	90                   	nop
8010505a:	90                   	nop
8010505b:	90                   	nop
8010505c:	90                   	nop
8010505d:	90                   	nop
8010505e:	90                   	nop
8010505f:	90                   	nop

80105060 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
80105065:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105067:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010506a:	89 d6                	mov    %edx,%esi
8010506c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506f:	50                   	push   %eax
80105070:	6a 00                	push   $0x0
80105072:	e8 f9 fc ff ff       	call   80104d70 <argint>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	78 2a                	js     801050a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105082:	77 24                	ja     801050a8 <argfd.constprop.0+0x48>
80105084:	e8 87 e7 ff ff       	call   80103810 <myproc>
80105089:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010508c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105090:	85 c0                	test   %eax,%eax
80105092:	74 14                	je     801050a8 <argfd.constprop.0+0x48>
  if(pfd)
80105094:	85 db                	test   %ebx,%ebx
80105096:	74 02                	je     8010509a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105098:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010509a:	89 06                	mov    %eax,(%esi)
  return 0;
8010509c:	31 c0                	xor    %eax,%eax
}
8010509e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a1:	5b                   	pop    %ebx
801050a2:	5e                   	pop    %esi
801050a3:	5d                   	pop    %ebp
801050a4:	c3                   	ret    
801050a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ad:	eb ef                	jmp    8010509e <argfd.constprop.0+0x3e>
801050af:	90                   	nop

801050b0 <sys_dup>:
{
801050b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050b1:	31 c0                	xor    %eax,%eax
{
801050b3:	89 e5                	mov    %esp,%ebp
801050b5:	56                   	push   %esi
801050b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050bd:	e8 9e ff ff ff       	call   80105060 <argfd.constprop.0>
801050c2:	85 c0                	test   %eax,%eax
801050c4:	78 42                	js     80105108 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801050c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050cb:	e8 40 e7 ff ff       	call   80103810 <myproc>
801050d0:	eb 0e                	jmp    801050e0 <sys_dup+0x30>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050d8:	83 c3 01             	add    $0x1,%ebx
801050db:	83 fb 10             	cmp    $0x10,%ebx
801050de:	74 28                	je     80105108 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801050e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050e4:	85 d2                	test   %edx,%edx
801050e6:	75 f0                	jne    801050d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801050e8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	ff 75 f4             	pushl  -0xc(%ebp)
801050f2:	e8 f9 bc ff ff       	call   80100df0 <filedup>
  return fd;
801050f7:	83 c4 10             	add    $0x10,%esp
}
801050fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050fd:	89 d8                	mov    %ebx,%eax
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105108:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010510b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105110:	89 d8                	mov    %ebx,%eax
80105112:	5b                   	pop    %ebx
80105113:	5e                   	pop    %esi
80105114:	5d                   	pop    %ebp
80105115:	c3                   	ret    
80105116:	8d 76 00             	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_read>:
{
80105120:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105128:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010512b:	e8 30 ff ff ff       	call   80105060 <argfd.constprop.0>
80105130:	85 c0                	test   %eax,%eax
80105132:	78 4c                	js     80105180 <sys_read+0x60>
80105134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105137:	83 ec 08             	sub    $0x8,%esp
8010513a:	50                   	push   %eax
8010513b:	6a 02                	push   $0x2
8010513d:	e8 2e fc ff ff       	call   80104d70 <argint>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	78 37                	js     80105180 <sys_read+0x60>
80105149:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514c:	83 ec 04             	sub    $0x4,%esp
8010514f:	ff 75 f0             	pushl  -0x10(%ebp)
80105152:	50                   	push   %eax
80105153:	6a 01                	push   $0x1
80105155:	e8 66 fc ff ff       	call   80104dc0 <argptr>
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	85 c0                	test   %eax,%eax
8010515f:	78 1f                	js     80105180 <sys_read+0x60>
  return fileread(f, p, n);
80105161:	83 ec 04             	sub    $0x4,%esp
80105164:	ff 75 f0             	pushl  -0x10(%ebp)
80105167:	ff 75 f4             	pushl  -0xc(%ebp)
8010516a:	ff 75 ec             	pushl  -0x14(%ebp)
8010516d:	e8 ee bd ff ff       	call   80100f60 <fileread>
80105172:	83 c4 10             	add    $0x10,%esp
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <sys_write>:
{
80105190:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105198:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010519b:	e8 c0 fe ff ff       	call   80105060 <argfd.constprop.0>
801051a0:	85 c0                	test   %eax,%eax
801051a2:	78 4c                	js     801051f0 <sys_write+0x60>
801051a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a7:	83 ec 08             	sub    $0x8,%esp
801051aa:	50                   	push   %eax
801051ab:	6a 02                	push   $0x2
801051ad:	e8 be fb ff ff       	call   80104d70 <argint>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 37                	js     801051f0 <sys_write+0x60>
801051b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051bc:	83 ec 04             	sub    $0x4,%esp
801051bf:	ff 75 f0             	pushl  -0x10(%ebp)
801051c2:	50                   	push   %eax
801051c3:	6a 01                	push   $0x1
801051c5:	e8 f6 fb ff ff       	call   80104dc0 <argptr>
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	85 c0                	test   %eax,%eax
801051cf:	78 1f                	js     801051f0 <sys_write+0x60>
  return filewrite(f, p, n);
801051d1:	83 ec 04             	sub    $0x4,%esp
801051d4:	ff 75 f0             	pushl  -0x10(%ebp)
801051d7:	ff 75 f4             	pushl  -0xc(%ebp)
801051da:	ff 75 ec             	pushl  -0x14(%ebp)
801051dd:	e8 0e be ff ff       	call   80100ff0 <filewrite>
801051e2:	83 c4 10             	add    $0x10,%esp
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_close>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105206:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105209:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010520c:	e8 4f fe ff ff       	call   80105060 <argfd.constprop.0>
80105211:	85 c0                	test   %eax,%eax
80105213:	78 2b                	js     80105240 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105215:	e8 f6 e5 ff ff       	call   80103810 <myproc>
8010521a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010521d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105220:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105227:	00 
  fileclose(f);
80105228:	ff 75 f4             	pushl  -0xc(%ebp)
8010522b:	e8 10 bc ff ff       	call   80100e40 <fileclose>
  return 0;
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	31 c0                	xor    %eax,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_fstat>:
{
80105250:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105251:	31 c0                	xor    %eax,%eax
{
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105258:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010525b:	e8 00 fe ff ff       	call   80105060 <argfd.constprop.0>
80105260:	85 c0                	test   %eax,%eax
80105262:	78 2c                	js     80105290 <sys_fstat+0x40>
80105264:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105267:	83 ec 04             	sub    $0x4,%esp
8010526a:	6a 14                	push   $0x14
8010526c:	50                   	push   %eax
8010526d:	6a 01                	push   $0x1
8010526f:	e8 4c fb ff ff       	call   80104dc0 <argptr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	78 15                	js     80105290 <sys_fstat+0x40>
  return filestat(f, st);
8010527b:	83 ec 08             	sub    $0x8,%esp
8010527e:	ff 75 f4             	pushl  -0xc(%ebp)
80105281:	ff 75 f0             	pushl  -0x10(%ebp)
80105284:	e8 87 bc ff ff       	call   80100f10 <filestat>
80105289:	83 c4 10             	add    $0x10,%esp
}
8010528c:	c9                   	leave  
8010528d:	c3                   	ret    
8010528e:	66 90                	xchg   %ax,%ax
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <sys_link>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ac:	50                   	push   %eax
801052ad:	6a 00                	push   $0x0
801052af:	e8 6c fb ff ff       	call   80104e20 <argstr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	0f 88 fb 00 00 00    	js     801053ba <sys_link+0x11a>
801052bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052c2:	83 ec 08             	sub    $0x8,%esp
801052c5:	50                   	push   %eax
801052c6:	6a 01                	push   $0x1
801052c8:	e8 53 fb ff ff       	call   80104e20 <argstr>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	0f 88 e2 00 00 00    	js     801053ba <sys_link+0x11a>
  begin_op();
801052d8:	e8 d3 d8 ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
801052dd:	83 ec 0c             	sub    $0xc,%esp
801052e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801052e3:	e8 08 cc ff ff       	call   80101ef0 <namei>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	0f 84 ea 00 00 00    	je     801053df <sys_link+0x13f>
  ilock(ip);
801052f5:	83 ec 0c             	sub    $0xc,%esp
801052f8:	50                   	push   %eax
801052f9:	e8 92 c3 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105306:	0f 84 bb 00 00 00    	je     801053c7 <sys_link+0x127>
  ip->nlink++;
8010530c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105311:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105314:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105317:	53                   	push   %ebx
80105318:	e8 c3 c2 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010531d:	89 1c 24             	mov    %ebx,(%esp)
80105320:	e8 4b c4 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105325:	58                   	pop    %eax
80105326:	5a                   	pop    %edx
80105327:	57                   	push   %edi
80105328:	ff 75 d0             	pushl  -0x30(%ebp)
8010532b:	e8 e0 cb ff ff       	call   80101f10 <nameiparent>
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	85 c0                	test   %eax,%eax
80105335:	89 c6                	mov    %eax,%esi
80105337:	74 5b                	je     80105394 <sys_link+0xf4>
  ilock(dp);
80105339:	83 ec 0c             	sub    $0xc,%esp
8010533c:	50                   	push   %eax
8010533d:	e8 4e c3 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	8b 03                	mov    (%ebx),%eax
80105347:	39 06                	cmp    %eax,(%esi)
80105349:	75 3d                	jne    80105388 <sys_link+0xe8>
8010534b:	83 ec 04             	sub    $0x4,%esp
8010534e:	ff 73 04             	pushl  0x4(%ebx)
80105351:	57                   	push   %edi
80105352:	56                   	push   %esi
80105353:	e8 d8 ca ff ff       	call   80101e30 <dirlink>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	78 29                	js     80105388 <sys_link+0xe8>
  iunlockput(dp);
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	56                   	push   %esi
80105363:	e8 b8 c5 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105368:	89 1c 24             	mov    %ebx,(%esp)
8010536b:	e8 50 c4 ff ff       	call   801017c0 <iput>
  end_op();
80105370:	e8 ab d8 ff ff       	call   80102c20 <end_op>
  return 0;
80105375:	83 c4 10             	add    $0x10,%esp
80105378:	31 c0                	xor    %eax,%eax
}
8010537a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537d:	5b                   	pop    %ebx
8010537e:	5e                   	pop    %esi
8010537f:	5f                   	pop    %edi
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	56                   	push   %esi
8010538c:	e8 8f c5 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105391:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105394:	83 ec 0c             	sub    $0xc,%esp
80105397:	53                   	push   %ebx
80105398:	e8 f3 c2 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010539d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053a2:	89 1c 24             	mov    %ebx,(%esp)
801053a5:	e8 36 c2 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801053aa:	89 1c 24             	mov    %ebx,(%esp)
801053ad:	e8 6e c5 ff ff       	call   80101920 <iunlockput>
  end_op();
801053b2:	e8 69 d8 ff ff       	call   80102c20 <end_op>
  return -1;
801053b7:	83 c4 10             	add    $0x10,%esp
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5f                   	pop    %edi
801053c5:	5d                   	pop    %ebp
801053c6:	c3                   	ret    
    iunlockput(ip);
801053c7:	83 ec 0c             	sub    $0xc,%esp
801053ca:	53                   	push   %ebx
801053cb:	e8 50 c5 ff ff       	call   80101920 <iunlockput>
    end_op();
801053d0:	e8 4b d8 ff ff       	call   80102c20 <end_op>
    return -1;
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dd:	eb 9b                	jmp    8010537a <sys_link+0xda>
    end_op();
801053df:	e8 3c d8 ff ff       	call   80102c20 <end_op>
    return -1;
801053e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e9:	eb 8f                	jmp    8010537a <sys_link+0xda>
801053eb:	90                   	nop
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_unlink>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801053f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 1c fa ff ff       	call   80104e20 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 77 01 00 00    	js     80105586 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010540f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105412:	e8 99 d7 ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	53                   	push   %ebx
8010541b:	ff 75 c0             	pushl  -0x40(%ebp)
8010541e:	e8 ed ca ff ff       	call   80101f10 <nameiparent>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	89 c6                	mov    %eax,%esi
8010542a:	0f 84 60 01 00 00    	je     80105590 <sys_unlink+0x1a0>
  ilock(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	50                   	push   %eax
80105434:	e8 57 c2 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105439:	58                   	pop    %eax
8010543a:	5a                   	pop    %edx
8010543b:	68 18 7d 10 80       	push   $0x80107d18
80105440:	53                   	push   %ebx
80105441:	e8 5a c7 ff ff       	call   80101ba0 <namecmp>
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	85 c0                	test   %eax,%eax
8010544b:	0f 84 03 01 00 00    	je     80105554 <sys_unlink+0x164>
80105451:	83 ec 08             	sub    $0x8,%esp
80105454:	68 17 7d 10 80       	push   $0x80107d17
80105459:	53                   	push   %ebx
8010545a:	e8 41 c7 ff ff       	call   80101ba0 <namecmp>
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	85 c0                	test   %eax,%eax
80105464:	0f 84 ea 00 00 00    	je     80105554 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010546a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010546d:	83 ec 04             	sub    $0x4,%esp
80105470:	50                   	push   %eax
80105471:	53                   	push   %ebx
80105472:	56                   	push   %esi
80105473:	e8 48 c7 ff ff       	call   80101bc0 <dirlookup>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	89 c3                	mov    %eax,%ebx
8010547f:	0f 84 cf 00 00 00    	je     80105554 <sys_unlink+0x164>
  ilock(ip);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	50                   	push   %eax
80105489:	e8 02 c2 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105496:	0f 8e 10 01 00 00    	jle    801055ac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010549c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a1:	74 6d                	je     80105510 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	6a 10                	push   $0x10
801054ab:	6a 00                	push   $0x0
801054ad:	50                   	push   %eax
801054ae:	e8 bd f5 ff ff       	call   80104a70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054b6:	6a 10                	push   $0x10
801054b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054bb:	50                   	push   %eax
801054bc:	56                   	push   %esi
801054bd:	e8 ae c5 ff ff       	call   80101a70 <writei>
801054c2:	83 c4 20             	add    $0x20,%esp
801054c5:	83 f8 10             	cmp    $0x10,%eax
801054c8:	0f 85 eb 00 00 00    	jne    801055b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801054ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054d3:	0f 84 97 00 00 00    	je     80105570 <sys_unlink+0x180>
  iunlockput(dp);
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	56                   	push   %esi
801054dd:	e8 3e c4 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
801054e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054e7:	89 1c 24             	mov    %ebx,(%esp)
801054ea:	e8 f1 c0 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801054ef:	89 1c 24             	mov    %ebx,(%esp)
801054f2:	e8 29 c4 ff ff       	call   80101920 <iunlockput>
  end_op();
801054f7:	e8 24 d7 ff ff       	call   80102c20 <end_op>
  return 0;
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	31 c0                	xor    %eax,%eax
}
80105501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105504:	5b                   	pop    %ebx
80105505:	5e                   	pop    %esi
80105506:	5f                   	pop    %edi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105510:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105514:	76 8d                	jbe    801054a3 <sys_unlink+0xb3>
80105516:	bf 20 00 00 00       	mov    $0x20,%edi
8010551b:	eb 0f                	jmp    8010552c <sys_unlink+0x13c>
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
80105520:	83 c7 10             	add    $0x10,%edi
80105523:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105526:	0f 83 77 ff ff ff    	jae    801054a3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010552c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010552f:	6a 10                	push   $0x10
80105531:	57                   	push   %edi
80105532:	50                   	push   %eax
80105533:	53                   	push   %ebx
80105534:	e8 37 c4 ff ff       	call   80101970 <readi>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	83 f8 10             	cmp    $0x10,%eax
8010553f:	75 5e                	jne    8010559f <sys_unlink+0x1af>
    if(de.inum != 0)
80105541:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105546:	74 d8                	je     80105520 <sys_unlink+0x130>
    iunlockput(ip);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	53                   	push   %ebx
8010554c:	e8 cf c3 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105551:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	56                   	push   %esi
80105558:	e8 c3 c3 ff ff       	call   80101920 <iunlockput>
  end_op();
8010555d:	e8 be d6 ff ff       	call   80102c20 <end_op>
  return -1;
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556a:	eb 95                	jmp    80105501 <sys_unlink+0x111>
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105570:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	56                   	push   %esi
80105579:	e8 62 c0 ff ff       	call   801015e0 <iupdate>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	e9 53 ff ff ff       	jmp    801054d9 <sys_unlink+0xe9>
    return -1;
80105586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558b:	e9 71 ff ff ff       	jmp    80105501 <sys_unlink+0x111>
    end_op();
80105590:	e8 8b d6 ff ff       	call   80102c20 <end_op>
    return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559a:	e9 62 ff ff ff       	jmp    80105501 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	68 3c 7d 10 80       	push   $0x80107d3c
801055a7:	e8 e4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	68 2a 7d 10 80       	push   $0x80107d2a
801055b4:	e8 d7 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	68 4e 7d 10 80       	push   $0x80107d4e
801055c1:	e8 ca ad ff ff       	call   80100390 <panic>
801055c6:	8d 76 00             	lea    0x0(%esi),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_open>:

int
sys_open(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
801055d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055dc:	50                   	push   %eax
801055dd:	6a 00                	push   $0x0
801055df:	e8 3c f8 ff ff       	call   80104e20 <argstr>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	0f 88 1d 01 00 00    	js     8010570c <sys_open+0x13c>
801055ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055f2:	83 ec 08             	sub    $0x8,%esp
801055f5:	50                   	push   %eax
801055f6:	6a 01                	push   $0x1
801055f8:	e8 73 f7 ff ff       	call   80104d70 <argint>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	0f 88 04 01 00 00    	js     8010570c <sys_open+0x13c>
    return -1;

  begin_op();
80105608:	e8 a3 d5 ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
8010560d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105611:	0f 85 a9 00 00 00    	jne    801056c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	ff 75 e0             	pushl  -0x20(%ebp)
8010561d:	e8 ce c8 ff ff       	call   80101ef0 <namei>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	89 c6                	mov    %eax,%esi
80105629:	0f 84 b2 00 00 00    	je     801056e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010562f:	83 ec 0c             	sub    $0xc,%esp
80105632:	50                   	push   %eax
80105633:	e8 58 c0 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105640:	0f 84 aa 00 00 00    	je     801056f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105646:	e8 35 b7 ff ff       	call   80100d80 <filealloc>
8010564b:	85 c0                	test   %eax,%eax
8010564d:	89 c7                	mov    %eax,%edi
8010564f:	0f 84 a6 00 00 00    	je     801056fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105655:	e8 b6 e1 ff ff       	call   80103810 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010565a:	31 db                	xor    %ebx,%ebx
8010565c:	eb 0e                	jmp    8010566c <sys_open+0x9c>
8010565e:	66 90                	xchg   %ax,%ax
80105660:	83 c3 01             	add    $0x1,%ebx
80105663:	83 fb 10             	cmp    $0x10,%ebx
80105666:	0f 84 ac 00 00 00    	je     80105718 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010566c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105670:	85 d2                	test   %edx,%edx
80105672:	75 ec                	jne    80105660 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105674:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105677:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010567b:	56                   	push   %esi
8010567c:	e8 ef c0 ff ff       	call   80101770 <iunlock>
  end_op();
80105681:	e8 9a d5 ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105686:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010568c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010568f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105692:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105695:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010569c:	89 d0                	mov    %edx,%eax
8010569e:	f7 d0                	not    %eax
801056a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b0:	89 d8                	mov    %ebx,%eax
801056b2:	5b                   	pop    %ebx
801056b3:	5e                   	pop    %esi
801056b4:	5f                   	pop    %edi
801056b5:	5d                   	pop    %ebp
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056c6:	31 c9                	xor    %ecx,%ecx
801056c8:	6a 00                	push   $0x0
801056ca:	ba 02 00 00 00       	mov    $0x2,%edx
801056cf:	e8 ec f7 ff ff       	call   80104ec0 <create>
    if(ip == 0){
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801056d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056db:	0f 85 65 ff ff ff    	jne    80105646 <sys_open+0x76>
      end_op();
801056e1:	e8 3a d5 ff ff       	call   80102c20 <end_op>
      return -1;
801056e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056eb:	eb c0                	jmp    801056ad <sys_open+0xdd>
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801056f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056f3:	85 c9                	test   %ecx,%ecx
801056f5:	0f 84 4b ff ff ff    	je     80105646 <sys_open+0x76>
    iunlockput(ip);
801056fb:	83 ec 0c             	sub    $0xc,%esp
801056fe:	56                   	push   %esi
801056ff:	e8 1c c2 ff ff       	call   80101920 <iunlockput>
    end_op();
80105704:	e8 17 d5 ff ff       	call   80102c20 <end_op>
    return -1;
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105711:	eb 9a                	jmp    801056ad <sys_open+0xdd>
80105713:	90                   	nop
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	57                   	push   %edi
8010571c:	e8 1f b7 ff ff       	call   80100e40 <fileclose>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	eb d5                	jmp    801056fb <sys_open+0x12b>
80105726:	8d 76 00             	lea    0x0(%esi),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_mkdir>:

int
sys_mkdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105736:	e8 75 d4 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010573b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573e:	83 ec 08             	sub    $0x8,%esp
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 d7 f6 ff ff       	call   80104e20 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 30                	js     80105780 <sys_mkdir+0x50>
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105756:	31 c9                	xor    %ecx,%ecx
80105758:	6a 00                	push   $0x0
8010575a:	ba 01 00 00 00       	mov    $0x1,%edx
8010575f:	e8 5c f7 ff ff       	call   80104ec0 <create>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	85 c0                	test   %eax,%eax
80105769:	74 15                	je     80105780 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010576b:	83 ec 0c             	sub    $0xc,%esp
8010576e:	50                   	push   %eax
8010576f:	e8 ac c1 ff ff       	call   80101920 <iunlockput>
  end_op();
80105774:	e8 a7 d4 ff ff       	call   80102c20 <end_op>
  return 0;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	31 c0                	xor    %eax,%eax
}
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    
    end_op();
80105780:	e8 9b d4 ff ff       	call   80102c20 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_mknod>:

int
sys_mknod(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105796:	e8 15 d4 ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010579b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 77 f6 ff ff       	call   80104e20 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 60                	js     80105810 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b3:	83 ec 08             	sub    $0x8,%esp
801057b6:	50                   	push   %eax
801057b7:	6a 01                	push   $0x1
801057b9:	e8 b2 f5 ff ff       	call   80104d70 <argint>
  if((argstr(0, &path)) < 0 ||
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 4b                	js     80105810 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c8:	83 ec 08             	sub    $0x8,%esp
801057cb:	50                   	push   %eax
801057cc:	6a 02                	push   $0x2
801057ce:	e8 9d f5 ff ff       	call   80104d70 <argint>
     argint(1, &major) < 0 ||
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 36                	js     80105810 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801057de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801057e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801057e5:	ba 03 00 00 00       	mov    $0x3,%edx
801057ea:	50                   	push   %eax
801057eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057ee:	e8 cd f6 ff ff       	call   80104ec0 <create>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 c0                	test   %eax,%eax
801057f8:	74 16                	je     80105810 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057fa:	83 ec 0c             	sub    $0xc,%esp
801057fd:	50                   	push   %eax
801057fe:	e8 1d c1 ff ff       	call   80101920 <iunlockput>
  end_op();
80105803:	e8 18 d4 ff ff       	call   80102c20 <end_op>
  return 0;
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	31 c0                	xor    %eax,%eax
}
8010580d:	c9                   	leave  
8010580e:	c3                   	ret    
8010580f:	90                   	nop
    end_op();
80105810:	e8 0b d4 ff ff       	call   80102c20 <end_op>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581a:	c9                   	leave  
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_chdir>:

int
sys_chdir(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105828:	e8 e3 df ff ff       	call   80103810 <myproc>
8010582d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010582f:	e8 7c d3 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 00                	push   $0x0
8010583d:	e8 de f5 ff ff       	call   80104e20 <argstr>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 77                	js     801058c0 <sys_chdir+0xa0>
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	ff 75 f4             	pushl  -0xc(%ebp)
8010584f:	e8 9c c6 ff ff       	call   80101ef0 <namei>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	89 c3                	mov    %eax,%ebx
8010585b:	74 63                	je     801058c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	50                   	push   %eax
80105861:	e8 2a be ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010586e:	75 30                	jne    801058a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 f7 be ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105879:	58                   	pop    %eax
8010587a:	ff 76 68             	pushl  0x68(%esi)
8010587d:	e8 3e bf ff ff       	call   801017c0 <iput>
  end_op();
80105882:	e8 99 d3 ff ff       	call   80102c20 <end_op>
  curproc->cwd = ip;
80105887:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	31 c0                	xor    %eax,%eax
}
8010588f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5d                   	pop    %ebp
80105895:	c3                   	ret    
80105896:	8d 76 00             	lea    0x0(%esi),%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	53                   	push   %ebx
801058a4:	e8 77 c0 ff ff       	call   80101920 <iunlockput>
    end_op();
801058a9:	e8 72 d3 ff ff       	call   80102c20 <end_op>
    return -1;
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b6:	eb d7                	jmp    8010588f <sys_chdir+0x6f>
801058b8:	90                   	nop
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058c0:	e8 5b d3 ff ff       	call   80102c20 <end_op>
    return -1;
801058c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ca:	eb c3                	jmp    8010588f <sys_chdir+0x6f>
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exec>:

int
sys_exec(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058e2:	50                   	push   %eax
801058e3:	6a 00                	push   $0x0
801058e5:	e8 36 f5 ff ff       	call   80104e20 <argstr>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	0f 88 87 00 00 00    	js     8010597c <sys_exec+0xac>
801058f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058fb:	83 ec 08             	sub    $0x8,%esp
801058fe:	50                   	push   %eax
801058ff:	6a 01                	push   $0x1
80105901:	e8 6a f4 ff ff       	call   80104d70 <argint>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	85 c0                	test   %eax,%eax
8010590b:	78 6f                	js     8010597c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010590d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105913:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105916:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105918:	68 80 00 00 00       	push   $0x80
8010591d:	6a 00                	push   $0x0
8010591f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105925:	50                   	push   %eax
80105926:	e8 45 f1 ff ff       	call   80104a70 <memset>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	eb 2c                	jmp    8010595c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105930:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105936:	85 c0                	test   %eax,%eax
80105938:	74 56                	je     80105990 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010593a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105940:	83 ec 08             	sub    $0x8,%esp
80105943:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105946:	52                   	push   %edx
80105947:	50                   	push   %eax
80105948:	e8 b3 f3 ff ff       	call   80104d00 <fetchstr>
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	85 c0                	test   %eax,%eax
80105952:	78 28                	js     8010597c <sys_exec+0xac>
  for(i=0;; i++){
80105954:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105957:	83 fb 20             	cmp    $0x20,%ebx
8010595a:	74 20                	je     8010597c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010595c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105962:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105969:	83 ec 08             	sub    $0x8,%esp
8010596c:	57                   	push   %edi
8010596d:	01 f0                	add    %esi,%eax
8010596f:	50                   	push   %eax
80105970:	e8 4b f3 ff ff       	call   80104cc0 <fetchint>
80105975:	83 c4 10             	add    $0x10,%esp
80105978:	85 c0                	test   %eax,%eax
8010597a:	79 b4                	jns    80105930 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010597c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010597f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105984:	5b                   	pop    %ebx
80105985:	5e                   	pop    %esi
80105986:	5f                   	pop    %edi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret    
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105990:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105996:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105999:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059a0:	00 00 00 00 
  return exec(path, argv);
801059a4:	50                   	push   %eax
801059a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059ab:	e8 60 b0 ff ff       	call   80100a10 <exec>
801059b0:	83 c4 10             	add    $0x10,%esp
}
801059b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b6:	5b                   	pop    %ebx
801059b7:	5e                   	pop    %esi
801059b8:	5f                   	pop    %edi
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    
801059bb:	90                   	nop
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_pipe>:

int
sys_pipe(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059cc:	6a 08                	push   $0x8
801059ce:	50                   	push   %eax
801059cf:	6a 00                	push   $0x0
801059d1:	e8 ea f3 ff ff       	call   80104dc0 <argptr>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	0f 88 ae 00 00 00    	js     80105a8f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059e4:	83 ec 08             	sub    $0x8,%esp
801059e7:	50                   	push   %eax
801059e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059eb:	50                   	push   %eax
801059ec:	e8 7f d8 ff ff       	call   80103270 <pipealloc>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	0f 88 93 00 00 00    	js     80105a8f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a01:	e8 0a de ff ff       	call   80103810 <myproc>
80105a06:	eb 10                	jmp    80105a18 <sys_pipe+0x58>
80105a08:	90                   	nop
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a10:	83 c3 01             	add    $0x1,%ebx
80105a13:	83 fb 10             	cmp    $0x10,%ebx
80105a16:	74 60                	je     80105a78 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a1c:	85 f6                	test   %esi,%esi
80105a1e:	75 f0                	jne    80105a10 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a20:	8d 73 08             	lea    0x8(%ebx),%esi
80105a23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a2a:	e8 e1 dd ff ff       	call   80103810 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a2f:	31 d2                	xor    %edx,%edx
80105a31:	eb 0d                	jmp    80105a40 <sys_pipe+0x80>
80105a33:	90                   	nop
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a38:	83 c2 01             	add    $0x1,%edx
80105a3b:	83 fa 10             	cmp    $0x10,%edx
80105a3e:	74 28                	je     80105a68 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a40:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a44:	85 c9                	test   %ecx,%ecx
80105a46:	75 f0                	jne    80105a38 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a48:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a4f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a54:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a57:	31 c0                	xor    %eax,%eax
}
80105a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5f                   	pop    %edi
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105a68:	e8 a3 dd ff ff       	call   80103810 <myproc>
80105a6d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a74:	00 
80105a75:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a7e:	e8 bd b3 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105a83:	58                   	pop    %eax
80105a84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a87:	e8 b4 b3 ff ff       	call   80100e40 <fileclose>
    return -1;
80105a8c:	83 c4 10             	add    $0x10,%esp
80105a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a94:	eb c3                	jmp    80105a59 <sys_pipe+0x99>
80105a96:	66 90                	xchg   %ax,%ax
80105a98:	66 90                	xchg   %ax,%ax
80105a9a:	66 90                	xchg   %ax,%ax
80105a9c:	66 90                	xchg   %ax,%ax
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105aa3:	5d                   	pop    %ebp
  return fork();
80105aa4:	e9 67 e0 ff ff       	jmp    80103b10 <fork>
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_exit>:

int
sys_exit(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ab6:	e8 a5 e1 ff ff       	call   80103c60 <exit>
  return 0;  // not reached
}
80105abb:	31 c0                	xor    %eax,%eax
80105abd:	c9                   	leave  
80105abe:	c3                   	ret    
80105abf:	90                   	nop

80105ac0 <sys_wait>:

int
sys_wait(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ac3:	5d                   	pop    %ebp
  return wait();
80105ac4:	e9 d7 e3 ff ff       	jmp    80103ea0 <wait>
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_kill>:

int
sys_kill(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 00                	push   $0x0
80105adc:	e8 8f f2 ff ff       	call   80104d70 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 18                	js     80105b00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	ff 75 f4             	pushl  -0xc(%ebp)
80105aee:	e8 fd e4 ff ff       	call   80103ff0 <kill>
80105af3:	83 c4 10             	add    $0x10,%esp
}
80105af6:	c9                   	leave  
80105af7:	c3                   	ret    
80105af8:	90                   	nop
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	89 f6                	mov    %esi,%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <sys_getpid>:

int
sys_getpid(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b16:	e8 f5 dc ff ff       	call   80103810 <myproc>
80105b1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b1e:	c9                   	leave  
80105b1f:	c3                   	ret    

80105b20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b2a:	50                   	push   %eax
80105b2b:	6a 00                	push   $0x0
80105b2d:	e8 3e f2 ff ff       	call   80104d70 <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
80105b35:	85 c0                	test   %eax,%eax
80105b37:	78 27                	js     80105b60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b39:	e8 d2 dc ff ff       	call   80103810 <myproc>
  if(growproc(n) < 0)
80105b3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b43:	ff 75 f4             	pushl  -0xc(%ebp)
80105b46:	e8 e5 dd ff ff       	call   80103930 <growproc>
80105b4b:	83 c4 10             	add    $0x10,%esp
80105b4e:	85 c0                	test   %eax,%eax
80105b50:	78 0e                	js     80105b60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b52:	89 d8                	mov    %ebx,%eax
80105b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b57:	c9                   	leave  
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b65:	eb eb                	jmp    80105b52 <sys_sbrk+0x32>
80105b67:	89 f6                	mov    %esi,%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_sleep>:

int
sys_sleep(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b7a:	50                   	push   %eax
80105b7b:	6a 00                	push   $0x0
80105b7d:	e8 ee f1 ff ff       	call   80104d70 <argint>
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	85 c0                	test   %eax,%eax
80105b87:	0f 88 8a 00 00 00    	js     80105c17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	68 80 60 11 80       	push   $0x80116080
80105b95:	e8 56 ed ff ff       	call   801048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ba0:	8b 1d c0 68 11 80    	mov    0x801168c0,%ebx
  while(ticks - ticks0 < n){
80105ba6:	85 d2                	test   %edx,%edx
80105ba8:	75 27                	jne    80105bd1 <sys_sleep+0x61>
80105baa:	eb 54                	jmp    80105c00 <sys_sleep+0x90>
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bb0:	83 ec 08             	sub    $0x8,%esp
80105bb3:	68 80 60 11 80       	push   $0x80116080
80105bb8:	68 c0 68 11 80       	push   $0x801168c0
80105bbd:	e8 1e e2 ff ff       	call   80103de0 <sleep>
  while(ticks - ticks0 < n){
80105bc2:	a1 c0 68 11 80       	mov    0x801168c0,%eax
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	29 d8                	sub    %ebx,%eax
80105bcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bcf:	73 2f                	jae    80105c00 <sys_sleep+0x90>
    if(myproc()->killed){
80105bd1:	e8 3a dc ff ff       	call   80103810 <myproc>
80105bd6:	8b 40 24             	mov    0x24(%eax),%eax
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	74 d3                	je     80105bb0 <sys_sleep+0x40>
      release(&tickslock);
80105bdd:	83 ec 0c             	sub    $0xc,%esp
80105be0:	68 80 60 11 80       	push   $0x80116080
80105be5:	e8 26 ee ff ff       	call   80104a10 <release>
      return -1;
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	68 80 60 11 80       	push   $0x80116080
80105c08:	e8 03 ee ff ff       	call   80104a10 <release>
  return 0;
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	31 c0                	xor    %eax,%eax
}
80105c12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
    return -1;
80105c17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1c:	eb f4                	jmp    80105c12 <sys_sleep+0xa2>
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	53                   	push   %ebx
80105c24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c27:	68 80 60 11 80       	push   $0x80116080
80105c2c:	e8 bf ec ff ff       	call   801048f0 <acquire>
  xticks = ticks;
80105c31:	8b 1d c0 68 11 80    	mov    0x801168c0,%ebx
  release(&tickslock);
80105c37:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80105c3e:	e8 cd ed ff ff       	call   80104a10 <release>
  return xticks;
}
80105c43:	89 d8                	mov    %ebx,%eax
80105c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c48:	c9                   	leave  
80105c49:	c3                   	ret    
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c50 <sys_shutdown>:

int
sys_shutdown(void){
80105c50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c51:	b8 00 20 00 00       	mov    $0x2000,%eax
80105c56:	ba 04 06 00 00       	mov    $0x604,%edx
80105c5b:	89 e5                	mov    %esp,%ebp
80105c5d:	66 ef                	out    %ax,(%dx)
  outw(0x604, 0x2000);
  return 0;
80105c5f:	31 c0                	xor    %eax,%eax
80105c61:	5d                   	pop    %ebp
80105c62:	c3                   	ret    

80105c63 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c63:	1e                   	push   %ds
  pushl %es
80105c64:	06                   	push   %es
  pushl %fs
80105c65:	0f a0                	push   %fs
  pushl %gs
80105c67:	0f a8                	push   %gs
  pushal
80105c69:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c6a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c6e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c70:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c72:	54                   	push   %esp
  call trap
80105c73:	e8 c8 00 00 00       	call   80105d40 <trap>
  addl $4, %esp
80105c78:	83 c4 04             	add    $0x4,%esp

80105c7b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c7b:	61                   	popa   
  popl %gs
80105c7c:	0f a9                	pop    %gs
  popl %fs
80105c7e:	0f a1                	pop    %fs
  popl %es
80105c80:	07                   	pop    %es
  popl %ds
80105c81:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c82:	83 c4 08             	add    $0x8,%esp
  iret
80105c85:	cf                   	iret   
80105c86:	66 90                	xchg   %ax,%ax
80105c88:	66 90                	xchg   %ax,%ax
80105c8a:	66 90                	xchg   %ax,%ax
80105c8c:	66 90                	xchg   %ax,%ax
80105c8e:	66 90                	xchg   %ax,%ax

80105c90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c91:	31 c0                	xor    %eax,%eax
{
80105c93:	89 e5                	mov    %esp,%ebp
80105c95:	83 ec 08             	sub    $0x8,%esp
80105c98:	90                   	nop
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ca0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105ca7:	c7 04 c5 c2 60 11 80 	movl   $0x8e000008,-0x7fee9f3e(,%eax,8)
80105cae:	08 00 00 8e 
80105cb2:	66 89 14 c5 c0 60 11 	mov    %dx,-0x7fee9f40(,%eax,8)
80105cb9:	80 
80105cba:	c1 ea 10             	shr    $0x10,%edx
80105cbd:	66 89 14 c5 c6 60 11 	mov    %dx,-0x7fee9f3a(,%eax,8)
80105cc4:	80 
  for(i = 0; i < 256; i++)
80105cc5:	83 c0 01             	add    $0x1,%eax
80105cc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ccd:	75 d1                	jne    80105ca0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ccf:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105cd4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cd7:	c7 05 c2 62 11 80 08 	movl   $0xef000008,0x801162c2
80105cde:	00 00 ef 
  initlock(&tickslock, "time");
80105ce1:	68 5d 7d 10 80       	push   $0x80107d5d
80105ce6:	68 80 60 11 80       	push   $0x80116080
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ceb:	66 a3 c0 62 11 80    	mov    %ax,0x801162c0
80105cf1:	c1 e8 10             	shr    $0x10,%eax
80105cf4:	66 a3 c6 62 11 80    	mov    %ax,0x801162c6
  initlock(&tickslock, "time");
80105cfa:	e8 01 eb ff ff       	call   80104800 <initlock>
}
80105cff:	83 c4 10             	add    $0x10,%esp
80105d02:	c9                   	leave  
80105d03:	c3                   	ret    
80105d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105d10 <idtinit>:

void
idtinit(void)
{
80105d10:	55                   	push   %ebp
  pd[0] = size-1;
80105d11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d16:	89 e5                	mov    %esp,%ebp
80105d18:	83 ec 10             	sub    $0x10,%esp
80105d1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d1f:	b8 c0 60 11 80       	mov    $0x801160c0,%eax
80105d24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d28:	c1 e8 10             	shr    $0x10,%eax
80105d2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
80105d45:	53                   	push   %ebx
80105d46:	83 ec 1c             	sub    $0x1c,%esp
80105d49:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d4c:	8b 47 30             	mov    0x30(%edi),%eax
80105d4f:	83 f8 40             	cmp    $0x40,%eax
80105d52:	0f 84 f0 00 00 00    	je     80105e48 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d58:	83 e8 20             	sub    $0x20,%eax
80105d5b:	83 f8 1f             	cmp    $0x1f,%eax
80105d5e:	77 10                	ja     80105d70 <trap+0x30>
80105d60:	ff 24 85 04 7e 10 80 	jmp    *-0x7fef81fc(,%eax,4)
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d70:	e8 9b da ff ff       	call   80103810 <myproc>
80105d75:	85 c0                	test   %eax,%eax
80105d77:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d7a:	0f 84 14 02 00 00    	je     80105f94 <trap+0x254>
80105d80:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d84:	0f 84 0a 02 00 00    	je     80105f94 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d8a:	0f 20 d1             	mov    %cr2,%ecx
80105d8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d90:	e8 5b da ff ff       	call   801037f0 <cpuid>
80105d95:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d98:	8b 47 34             	mov    0x34(%edi),%eax
80105d9b:	8b 77 30             	mov    0x30(%edi),%esi
80105d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105da1:	e8 6a da ff ff       	call   80103810 <myproc>
80105da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105da9:	e8 62 da ff ff       	call   80103810 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105db4:	51                   	push   %ecx
80105db5:	53                   	push   %ebx
80105db6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105db7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dba:	ff 75 e4             	pushl  -0x1c(%ebp)
80105dbd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dbe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dc1:	52                   	push   %edx
80105dc2:	ff 70 10             	pushl  0x10(%eax)
80105dc5:	68 c0 7d 10 80       	push   $0x80107dc0
80105dca:	e8 91 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105dcf:	83 c4 20             	add    $0x20,%esp
80105dd2:	e8 39 da ff ff       	call   80103810 <myproc>
80105dd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dde:	e8 2d da ff ff       	call   80103810 <myproc>
80105de3:	85 c0                	test   %eax,%eax
80105de5:	74 1d                	je     80105e04 <trap+0xc4>
80105de7:	e8 24 da ff ff       	call   80103810 <myproc>
80105dec:	8b 50 24             	mov    0x24(%eax),%edx
80105def:	85 d2                	test   %edx,%edx
80105df1:	74 11                	je     80105e04 <trap+0xc4>
80105df3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105df7:	83 e0 03             	and    $0x3,%eax
80105dfa:	66 83 f8 03          	cmp    $0x3,%ax
80105dfe:	0f 84 4c 01 00 00    	je     80105f50 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e04:	e8 07 da ff ff       	call   80103810 <myproc>
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	74 0b                	je     80105e18 <trap+0xd8>
80105e0d:	e8 fe d9 ff ff       	call   80103810 <myproc>
80105e12:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e16:	74 68                	je     80105e80 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e18:	e8 f3 d9 ff ff       	call   80103810 <myproc>
80105e1d:	85 c0                	test   %eax,%eax
80105e1f:	74 19                	je     80105e3a <trap+0xfa>
80105e21:	e8 ea d9 ff ff       	call   80103810 <myproc>
80105e26:	8b 40 24             	mov    0x24(%eax),%eax
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	74 0d                	je     80105e3a <trap+0xfa>
80105e2d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e31:	83 e0 03             	and    $0x3,%eax
80105e34:	66 83 f8 03          	cmp    $0x3,%ax
80105e38:	74 37                	je     80105e71 <trap+0x131>
    exit();
}
80105e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e3d:	5b                   	pop    %ebx
80105e3e:	5e                   	pop    %esi
80105e3f:	5f                   	pop    %edi
80105e40:	5d                   	pop    %ebp
80105e41:	c3                   	ret    
80105e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e48:	e8 c3 d9 ff ff       	call   80103810 <myproc>
80105e4d:	8b 58 24             	mov    0x24(%eax),%ebx
80105e50:	85 db                	test   %ebx,%ebx
80105e52:	0f 85 e8 00 00 00    	jne    80105f40 <trap+0x200>
    myproc()->tf = tf;
80105e58:	e8 b3 d9 ff ff       	call   80103810 <myproc>
80105e5d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e60:	e8 fb ef ff ff       	call   80104e60 <syscall>
    if(myproc()->killed)
80105e65:	e8 a6 d9 ff ff       	call   80103810 <myproc>
80105e6a:	8b 48 24             	mov    0x24(%eax),%ecx
80105e6d:	85 c9                	test   %ecx,%ecx
80105e6f:	74 c9                	je     80105e3a <trap+0xfa>
}
80105e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e74:	5b                   	pop    %ebx
80105e75:	5e                   	pop    %esi
80105e76:	5f                   	pop    %edi
80105e77:	5d                   	pop    %ebp
      exit();
80105e78:	e9 e3 dd ff ff       	jmp    80103c60 <exit>
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e80:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e84:	75 92                	jne    80105e18 <trap+0xd8>
    yield();
80105e86:	e8 05 df ff ff       	call   80103d90 <yield>
80105e8b:	eb 8b                	jmp    80105e18 <trap+0xd8>
80105e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e90:	e8 5b d9 ff ff       	call   801037f0 <cpuid>
80105e95:	85 c0                	test   %eax,%eax
80105e97:	0f 84 c3 00 00 00    	je     80105f60 <trap+0x220>
    lapiceoi();
80105e9d:	e8 be c8 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ea2:	e8 69 d9 ff ff       	call   80103810 <myproc>
80105ea7:	85 c0                	test   %eax,%eax
80105ea9:	0f 85 38 ff ff ff    	jne    80105de7 <trap+0xa7>
80105eaf:	e9 50 ff ff ff       	jmp    80105e04 <trap+0xc4>
80105eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105eb8:	e8 63 c7 ff ff       	call   80102620 <kbdintr>
    lapiceoi();
80105ebd:	e8 9e c8 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ec2:	e8 49 d9 ff ff       	call   80103810 <myproc>
80105ec7:	85 c0                	test   %eax,%eax
80105ec9:	0f 85 18 ff ff ff    	jne    80105de7 <trap+0xa7>
80105ecf:	e9 30 ff ff ff       	jmp    80105e04 <trap+0xc4>
80105ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ed8:	e8 53 02 00 00       	call   80106130 <uartintr>
    lapiceoi();
80105edd:	e8 7e c8 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee2:	e8 29 d9 ff ff       	call   80103810 <myproc>
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 85 f8 fe ff ff    	jne    80105de7 <trap+0xa7>
80105eef:	e9 10 ff ff ff       	jmp    80105e04 <trap+0xc4>
80105ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ef8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105efc:	8b 77 38             	mov    0x38(%edi),%esi
80105eff:	e8 ec d8 ff ff       	call   801037f0 <cpuid>
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
80105f06:	50                   	push   %eax
80105f07:	68 68 7d 10 80       	push   $0x80107d68
80105f0c:	e8 4f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105f11:	e8 4a c8 ff ff       	call   80102760 <lapiceoi>
    break;
80105f16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f19:	e8 f2 d8 ff ff       	call   80103810 <myproc>
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	0f 85 c1 fe ff ff    	jne    80105de7 <trap+0xa7>
80105f26:	e9 d9 fe ff ff       	jmp    80105e04 <trap+0xc4>
80105f2b:	90                   	nop
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f30:	e8 5b c1 ff ff       	call   80102090 <ideintr>
80105f35:	e9 63 ff ff ff       	jmp    80105e9d <trap+0x15d>
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f40:	e8 1b dd ff ff       	call   80103c60 <exit>
80105f45:	e9 0e ff ff ff       	jmp    80105e58 <trap+0x118>
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f50:	e8 0b dd ff ff       	call   80103c60 <exit>
80105f55:	e9 aa fe ff ff       	jmp    80105e04 <trap+0xc4>
80105f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	68 80 60 11 80       	push   $0x80116080
80105f68:	e8 83 e9 ff ff       	call   801048f0 <acquire>
      wakeup(&ticks);
80105f6d:	c7 04 24 c0 68 11 80 	movl   $0x801168c0,(%esp)
      ticks++;
80105f74:	83 05 c0 68 11 80 01 	addl   $0x1,0x801168c0
      wakeup(&ticks);
80105f7b:	e8 10 e0 ff ff       	call   80103f90 <wakeup>
      release(&tickslock);
80105f80:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80105f87:	e8 84 ea ff ff       	call   80104a10 <release>
80105f8c:	83 c4 10             	add    $0x10,%esp
80105f8f:	e9 09 ff ff ff       	jmp    80105e9d <trap+0x15d>
80105f94:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f97:	e8 54 d8 ff ff       	call   801037f0 <cpuid>
80105f9c:	83 ec 0c             	sub    $0xc,%esp
80105f9f:	56                   	push   %esi
80105fa0:	53                   	push   %ebx
80105fa1:	50                   	push   %eax
80105fa2:	ff 77 30             	pushl  0x30(%edi)
80105fa5:	68 8c 7d 10 80       	push   $0x80107d8c
80105faa:	e8 b1 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105faf:	83 c4 14             	add    $0x14,%esp
80105fb2:	68 62 7d 10 80       	push   $0x80107d62
80105fb7:	e8 d4 a3 ff ff       	call   80100390 <panic>
80105fbc:	66 90                	xchg   %ax,%ax
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fc0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105fc5:	55                   	push   %ebp
80105fc6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fc8:	85 c0                	test   %eax,%eax
80105fca:	74 1c                	je     80105fe8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fcc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fd1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fd2:	a8 01                	test   $0x1,%al
80105fd4:	74 12                	je     80105fe8 <uartgetc+0x28>
80105fd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fdc:	0f b6 c0             	movzbl %al,%eax
}
80105fdf:	5d                   	pop    %ebp
80105fe0:	c3                   	ret    
80105fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fed:	5d                   	pop    %ebp
80105fee:	c3                   	ret    
80105fef:	90                   	nop

80105ff0 <uartputc.part.0>:
uartputc(int c)
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	53                   	push   %ebx
80105ff6:	89 c7                	mov    %eax,%edi
80105ff8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ffd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106002:	83 ec 0c             	sub    $0xc,%esp
80106005:	eb 1b                	jmp    80106022 <uartputc.part.0+0x32>
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	6a 0a                	push   $0xa
80106015:	e8 66 c7 ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	83 eb 01             	sub    $0x1,%ebx
80106020:	74 07                	je     80106029 <uartputc.part.0+0x39>
80106022:	89 f2                	mov    %esi,%edx
80106024:	ec                   	in     (%dx),%al
80106025:	a8 20                	test   $0x20,%al
80106027:	74 e7                	je     80106010 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106029:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010602e:	89 f8                	mov    %edi,%eax
80106030:	ee                   	out    %al,(%dx)
}
80106031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106034:	5b                   	pop    %ebx
80106035:	5e                   	pop    %esi
80106036:	5f                   	pop    %edi
80106037:	5d                   	pop    %ebp
80106038:	c3                   	ret    
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106040 <uartinit>:
{
80106040:	55                   	push   %ebp
80106041:	31 c9                	xor    %ecx,%ecx
80106043:	89 c8                	mov    %ecx,%eax
80106045:	89 e5                	mov    %esp,%ebp
80106047:	57                   	push   %edi
80106048:	56                   	push   %esi
80106049:	53                   	push   %ebx
8010604a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010604f:	89 da                	mov    %ebx,%edx
80106051:	83 ec 0c             	sub    $0xc,%esp
80106054:	ee                   	out    %al,(%dx)
80106055:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010605a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010605f:	89 fa                	mov    %edi,%edx
80106061:	ee                   	out    %al,(%dx)
80106062:	b8 0c 00 00 00       	mov    $0xc,%eax
80106067:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010606c:	ee                   	out    %al,(%dx)
8010606d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106072:	89 c8                	mov    %ecx,%eax
80106074:	89 f2                	mov    %esi,%edx
80106076:	ee                   	out    %al,(%dx)
80106077:	b8 03 00 00 00       	mov    $0x3,%eax
8010607c:	89 fa                	mov    %edi,%edx
8010607e:	ee                   	out    %al,(%dx)
8010607f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106084:	89 c8                	mov    %ecx,%eax
80106086:	ee                   	out    %al,(%dx)
80106087:	b8 01 00 00 00       	mov    $0x1,%eax
8010608c:	89 f2                	mov    %esi,%edx
8010608e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010608f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106094:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106095:	3c ff                	cmp    $0xff,%al
80106097:	74 5a                	je     801060f3 <uartinit+0xb3>
  uart = 1;
80106099:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
801060a0:	00 00 00 
801060a3:	89 da                	mov    %ebx,%edx
801060a5:	ec                   	in     (%dx),%al
801060a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060af:	bb 84 7e 10 80       	mov    $0x80107e84,%ebx
  ioapicenable(IRQ_COM1, 0);
801060b4:	6a 00                	push   $0x0
801060b6:	6a 04                	push   $0x4
801060b8:	e8 23 c2 ff ff       	call   801022e0 <ioapicenable>
801060bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060c0:	b8 78 00 00 00       	mov    $0x78,%eax
801060c5:	eb 13                	jmp    801060da <uartinit+0x9a>
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060d0:	83 c3 01             	add    $0x1,%ebx
801060d3:	0f be 03             	movsbl (%ebx),%eax
801060d6:	84 c0                	test   %al,%al
801060d8:	74 19                	je     801060f3 <uartinit+0xb3>
  if(!uart)
801060da:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
801060e0:	85 d2                	test   %edx,%edx
801060e2:	74 ec                	je     801060d0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060e4:	83 c3 01             	add    $0x1,%ebx
801060e7:	e8 04 ff ff ff       	call   80105ff0 <uartputc.part.0>
801060ec:	0f be 03             	movsbl (%ebx),%eax
801060ef:	84 c0                	test   %al,%al
801060f1:	75 e7                	jne    801060da <uartinit+0x9a>
}
801060f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060f6:	5b                   	pop    %ebx
801060f7:	5e                   	pop    %esi
801060f8:	5f                   	pop    %edi
801060f9:	5d                   	pop    %ebp
801060fa:	c3                   	ret    
801060fb:	90                   	nop
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106100 <uartputc>:
  if(!uart)
80106100:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80106106:	55                   	push   %ebp
80106107:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106109:	85 d2                	test   %edx,%edx
{
8010610b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010610e:	74 10                	je     80106120 <uartputc+0x20>
}
80106110:	5d                   	pop    %ebp
80106111:	e9 da fe ff ff       	jmp    80105ff0 <uartputc.part.0>
80106116:	8d 76 00             	lea    0x0(%esi),%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106120:	5d                   	pop    %ebp
80106121:	c3                   	ret    
80106122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106130 <uartintr>:

void
uartintr(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106136:	68 c0 5f 10 80       	push   $0x80105fc0
8010613b:	e8 d0 a6 ff ff       	call   80100810 <consoleintr>
}
80106140:	83 c4 10             	add    $0x10,%esp
80106143:	c9                   	leave  
80106144:	c3                   	ret    

80106145 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $0
80106147:	6a 00                	push   $0x0
  jmp alltraps
80106149:	e9 15 fb ff ff       	jmp    80105c63 <alltraps>

8010614e <vector1>:
.globl vector1
vector1:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $1
80106150:	6a 01                	push   $0x1
  jmp alltraps
80106152:	e9 0c fb ff ff       	jmp    80105c63 <alltraps>

80106157 <vector2>:
.globl vector2
vector2:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $2
80106159:	6a 02                	push   $0x2
  jmp alltraps
8010615b:	e9 03 fb ff ff       	jmp    80105c63 <alltraps>

80106160 <vector3>:
.globl vector3
vector3:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $3
80106162:	6a 03                	push   $0x3
  jmp alltraps
80106164:	e9 fa fa ff ff       	jmp    80105c63 <alltraps>

80106169 <vector4>:
.globl vector4
vector4:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $4
8010616b:	6a 04                	push   $0x4
  jmp alltraps
8010616d:	e9 f1 fa ff ff       	jmp    80105c63 <alltraps>

80106172 <vector5>:
.globl vector5
vector5:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $5
80106174:	6a 05                	push   $0x5
  jmp alltraps
80106176:	e9 e8 fa ff ff       	jmp    80105c63 <alltraps>

8010617b <vector6>:
.globl vector6
vector6:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $6
8010617d:	6a 06                	push   $0x6
  jmp alltraps
8010617f:	e9 df fa ff ff       	jmp    80105c63 <alltraps>

80106184 <vector7>:
.globl vector7
vector7:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $7
80106186:	6a 07                	push   $0x7
  jmp alltraps
80106188:	e9 d6 fa ff ff       	jmp    80105c63 <alltraps>

8010618d <vector8>:
.globl vector8
vector8:
  pushl $8
8010618d:	6a 08                	push   $0x8
  jmp alltraps
8010618f:	e9 cf fa ff ff       	jmp    80105c63 <alltraps>

80106194 <vector9>:
.globl vector9
vector9:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $9
80106196:	6a 09                	push   $0x9
  jmp alltraps
80106198:	e9 c6 fa ff ff       	jmp    80105c63 <alltraps>

8010619d <vector10>:
.globl vector10
vector10:
  pushl $10
8010619d:	6a 0a                	push   $0xa
  jmp alltraps
8010619f:	e9 bf fa ff ff       	jmp    80105c63 <alltraps>

801061a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061a4:	6a 0b                	push   $0xb
  jmp alltraps
801061a6:	e9 b8 fa ff ff       	jmp    80105c63 <alltraps>

801061ab <vector12>:
.globl vector12
vector12:
  pushl $12
801061ab:	6a 0c                	push   $0xc
  jmp alltraps
801061ad:	e9 b1 fa ff ff       	jmp    80105c63 <alltraps>

801061b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061b2:	6a 0d                	push   $0xd
  jmp alltraps
801061b4:	e9 aa fa ff ff       	jmp    80105c63 <alltraps>

801061b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061b9:	6a 0e                	push   $0xe
  jmp alltraps
801061bb:	e9 a3 fa ff ff       	jmp    80105c63 <alltraps>

801061c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $15
801061c2:	6a 0f                	push   $0xf
  jmp alltraps
801061c4:	e9 9a fa ff ff       	jmp    80105c63 <alltraps>

801061c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $16
801061cb:	6a 10                	push   $0x10
  jmp alltraps
801061cd:	e9 91 fa ff ff       	jmp    80105c63 <alltraps>

801061d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061d2:	6a 11                	push   $0x11
  jmp alltraps
801061d4:	e9 8a fa ff ff       	jmp    80105c63 <alltraps>

801061d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $18
801061db:	6a 12                	push   $0x12
  jmp alltraps
801061dd:	e9 81 fa ff ff       	jmp    80105c63 <alltraps>

801061e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $19
801061e4:	6a 13                	push   $0x13
  jmp alltraps
801061e6:	e9 78 fa ff ff       	jmp    80105c63 <alltraps>

801061eb <vector20>:
.globl vector20
vector20:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $20
801061ed:	6a 14                	push   $0x14
  jmp alltraps
801061ef:	e9 6f fa ff ff       	jmp    80105c63 <alltraps>

801061f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $21
801061f6:	6a 15                	push   $0x15
  jmp alltraps
801061f8:	e9 66 fa ff ff       	jmp    80105c63 <alltraps>

801061fd <vector22>:
.globl vector22
vector22:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $22
801061ff:	6a 16                	push   $0x16
  jmp alltraps
80106201:	e9 5d fa ff ff       	jmp    80105c63 <alltraps>

80106206 <vector23>:
.globl vector23
vector23:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $23
80106208:	6a 17                	push   $0x17
  jmp alltraps
8010620a:	e9 54 fa ff ff       	jmp    80105c63 <alltraps>

8010620f <vector24>:
.globl vector24
vector24:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $24
80106211:	6a 18                	push   $0x18
  jmp alltraps
80106213:	e9 4b fa ff ff       	jmp    80105c63 <alltraps>

80106218 <vector25>:
.globl vector25
vector25:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $25
8010621a:	6a 19                	push   $0x19
  jmp alltraps
8010621c:	e9 42 fa ff ff       	jmp    80105c63 <alltraps>

80106221 <vector26>:
.globl vector26
vector26:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $26
80106223:	6a 1a                	push   $0x1a
  jmp alltraps
80106225:	e9 39 fa ff ff       	jmp    80105c63 <alltraps>

8010622a <vector27>:
.globl vector27
vector27:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $27
8010622c:	6a 1b                	push   $0x1b
  jmp alltraps
8010622e:	e9 30 fa ff ff       	jmp    80105c63 <alltraps>

80106233 <vector28>:
.globl vector28
vector28:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $28
80106235:	6a 1c                	push   $0x1c
  jmp alltraps
80106237:	e9 27 fa ff ff       	jmp    80105c63 <alltraps>

8010623c <vector29>:
.globl vector29
vector29:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $29
8010623e:	6a 1d                	push   $0x1d
  jmp alltraps
80106240:	e9 1e fa ff ff       	jmp    80105c63 <alltraps>

80106245 <vector30>:
.globl vector30
vector30:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $30
80106247:	6a 1e                	push   $0x1e
  jmp alltraps
80106249:	e9 15 fa ff ff       	jmp    80105c63 <alltraps>

8010624e <vector31>:
.globl vector31
vector31:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $31
80106250:	6a 1f                	push   $0x1f
  jmp alltraps
80106252:	e9 0c fa ff ff       	jmp    80105c63 <alltraps>

80106257 <vector32>:
.globl vector32
vector32:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $32
80106259:	6a 20                	push   $0x20
  jmp alltraps
8010625b:	e9 03 fa ff ff       	jmp    80105c63 <alltraps>

80106260 <vector33>:
.globl vector33
vector33:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $33
80106262:	6a 21                	push   $0x21
  jmp alltraps
80106264:	e9 fa f9 ff ff       	jmp    80105c63 <alltraps>

80106269 <vector34>:
.globl vector34
vector34:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $34
8010626b:	6a 22                	push   $0x22
  jmp alltraps
8010626d:	e9 f1 f9 ff ff       	jmp    80105c63 <alltraps>

80106272 <vector35>:
.globl vector35
vector35:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $35
80106274:	6a 23                	push   $0x23
  jmp alltraps
80106276:	e9 e8 f9 ff ff       	jmp    80105c63 <alltraps>

8010627b <vector36>:
.globl vector36
vector36:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $36
8010627d:	6a 24                	push   $0x24
  jmp alltraps
8010627f:	e9 df f9 ff ff       	jmp    80105c63 <alltraps>

80106284 <vector37>:
.globl vector37
vector37:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $37
80106286:	6a 25                	push   $0x25
  jmp alltraps
80106288:	e9 d6 f9 ff ff       	jmp    80105c63 <alltraps>

8010628d <vector38>:
.globl vector38
vector38:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $38
8010628f:	6a 26                	push   $0x26
  jmp alltraps
80106291:	e9 cd f9 ff ff       	jmp    80105c63 <alltraps>

80106296 <vector39>:
.globl vector39
vector39:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $39
80106298:	6a 27                	push   $0x27
  jmp alltraps
8010629a:	e9 c4 f9 ff ff       	jmp    80105c63 <alltraps>

8010629f <vector40>:
.globl vector40
vector40:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $40
801062a1:	6a 28                	push   $0x28
  jmp alltraps
801062a3:	e9 bb f9 ff ff       	jmp    80105c63 <alltraps>

801062a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $41
801062aa:	6a 29                	push   $0x29
  jmp alltraps
801062ac:	e9 b2 f9 ff ff       	jmp    80105c63 <alltraps>

801062b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $42
801062b3:	6a 2a                	push   $0x2a
  jmp alltraps
801062b5:	e9 a9 f9 ff ff       	jmp    80105c63 <alltraps>

801062ba <vector43>:
.globl vector43
vector43:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $43
801062bc:	6a 2b                	push   $0x2b
  jmp alltraps
801062be:	e9 a0 f9 ff ff       	jmp    80105c63 <alltraps>

801062c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $44
801062c5:	6a 2c                	push   $0x2c
  jmp alltraps
801062c7:	e9 97 f9 ff ff       	jmp    80105c63 <alltraps>

801062cc <vector45>:
.globl vector45
vector45:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $45
801062ce:	6a 2d                	push   $0x2d
  jmp alltraps
801062d0:	e9 8e f9 ff ff       	jmp    80105c63 <alltraps>

801062d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $46
801062d7:	6a 2e                	push   $0x2e
  jmp alltraps
801062d9:	e9 85 f9 ff ff       	jmp    80105c63 <alltraps>

801062de <vector47>:
.globl vector47
vector47:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $47
801062e0:	6a 2f                	push   $0x2f
  jmp alltraps
801062e2:	e9 7c f9 ff ff       	jmp    80105c63 <alltraps>

801062e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $48
801062e9:	6a 30                	push   $0x30
  jmp alltraps
801062eb:	e9 73 f9 ff ff       	jmp    80105c63 <alltraps>

801062f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $49
801062f2:	6a 31                	push   $0x31
  jmp alltraps
801062f4:	e9 6a f9 ff ff       	jmp    80105c63 <alltraps>

801062f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $50
801062fb:	6a 32                	push   $0x32
  jmp alltraps
801062fd:	e9 61 f9 ff ff       	jmp    80105c63 <alltraps>

80106302 <vector51>:
.globl vector51
vector51:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $51
80106304:	6a 33                	push   $0x33
  jmp alltraps
80106306:	e9 58 f9 ff ff       	jmp    80105c63 <alltraps>

8010630b <vector52>:
.globl vector52
vector52:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $52
8010630d:	6a 34                	push   $0x34
  jmp alltraps
8010630f:	e9 4f f9 ff ff       	jmp    80105c63 <alltraps>

80106314 <vector53>:
.globl vector53
vector53:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $53
80106316:	6a 35                	push   $0x35
  jmp alltraps
80106318:	e9 46 f9 ff ff       	jmp    80105c63 <alltraps>

8010631d <vector54>:
.globl vector54
vector54:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $54
8010631f:	6a 36                	push   $0x36
  jmp alltraps
80106321:	e9 3d f9 ff ff       	jmp    80105c63 <alltraps>

80106326 <vector55>:
.globl vector55
vector55:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $55
80106328:	6a 37                	push   $0x37
  jmp alltraps
8010632a:	e9 34 f9 ff ff       	jmp    80105c63 <alltraps>

8010632f <vector56>:
.globl vector56
vector56:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $56
80106331:	6a 38                	push   $0x38
  jmp alltraps
80106333:	e9 2b f9 ff ff       	jmp    80105c63 <alltraps>

80106338 <vector57>:
.globl vector57
vector57:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $57
8010633a:	6a 39                	push   $0x39
  jmp alltraps
8010633c:	e9 22 f9 ff ff       	jmp    80105c63 <alltraps>

80106341 <vector58>:
.globl vector58
vector58:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $58
80106343:	6a 3a                	push   $0x3a
  jmp alltraps
80106345:	e9 19 f9 ff ff       	jmp    80105c63 <alltraps>

8010634a <vector59>:
.globl vector59
vector59:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $59
8010634c:	6a 3b                	push   $0x3b
  jmp alltraps
8010634e:	e9 10 f9 ff ff       	jmp    80105c63 <alltraps>

80106353 <vector60>:
.globl vector60
vector60:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $60
80106355:	6a 3c                	push   $0x3c
  jmp alltraps
80106357:	e9 07 f9 ff ff       	jmp    80105c63 <alltraps>

8010635c <vector61>:
.globl vector61
vector61:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $61
8010635e:	6a 3d                	push   $0x3d
  jmp alltraps
80106360:	e9 fe f8 ff ff       	jmp    80105c63 <alltraps>

80106365 <vector62>:
.globl vector62
vector62:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $62
80106367:	6a 3e                	push   $0x3e
  jmp alltraps
80106369:	e9 f5 f8 ff ff       	jmp    80105c63 <alltraps>

8010636e <vector63>:
.globl vector63
vector63:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $63
80106370:	6a 3f                	push   $0x3f
  jmp alltraps
80106372:	e9 ec f8 ff ff       	jmp    80105c63 <alltraps>

80106377 <vector64>:
.globl vector64
vector64:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $64
80106379:	6a 40                	push   $0x40
  jmp alltraps
8010637b:	e9 e3 f8 ff ff       	jmp    80105c63 <alltraps>

80106380 <vector65>:
.globl vector65
vector65:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $65
80106382:	6a 41                	push   $0x41
  jmp alltraps
80106384:	e9 da f8 ff ff       	jmp    80105c63 <alltraps>

80106389 <vector66>:
.globl vector66
vector66:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $66
8010638b:	6a 42                	push   $0x42
  jmp alltraps
8010638d:	e9 d1 f8 ff ff       	jmp    80105c63 <alltraps>

80106392 <vector67>:
.globl vector67
vector67:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $67
80106394:	6a 43                	push   $0x43
  jmp alltraps
80106396:	e9 c8 f8 ff ff       	jmp    80105c63 <alltraps>

8010639b <vector68>:
.globl vector68
vector68:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $68
8010639d:	6a 44                	push   $0x44
  jmp alltraps
8010639f:	e9 bf f8 ff ff       	jmp    80105c63 <alltraps>

801063a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $69
801063a6:	6a 45                	push   $0x45
  jmp alltraps
801063a8:	e9 b6 f8 ff ff       	jmp    80105c63 <alltraps>

801063ad <vector70>:
.globl vector70
vector70:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $70
801063af:	6a 46                	push   $0x46
  jmp alltraps
801063b1:	e9 ad f8 ff ff       	jmp    80105c63 <alltraps>

801063b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $71
801063b8:	6a 47                	push   $0x47
  jmp alltraps
801063ba:	e9 a4 f8 ff ff       	jmp    80105c63 <alltraps>

801063bf <vector72>:
.globl vector72
vector72:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $72
801063c1:	6a 48                	push   $0x48
  jmp alltraps
801063c3:	e9 9b f8 ff ff       	jmp    80105c63 <alltraps>

801063c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $73
801063ca:	6a 49                	push   $0x49
  jmp alltraps
801063cc:	e9 92 f8 ff ff       	jmp    80105c63 <alltraps>

801063d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $74
801063d3:	6a 4a                	push   $0x4a
  jmp alltraps
801063d5:	e9 89 f8 ff ff       	jmp    80105c63 <alltraps>

801063da <vector75>:
.globl vector75
vector75:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $75
801063dc:	6a 4b                	push   $0x4b
  jmp alltraps
801063de:	e9 80 f8 ff ff       	jmp    80105c63 <alltraps>

801063e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $76
801063e5:	6a 4c                	push   $0x4c
  jmp alltraps
801063e7:	e9 77 f8 ff ff       	jmp    80105c63 <alltraps>

801063ec <vector77>:
.globl vector77
vector77:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $77
801063ee:	6a 4d                	push   $0x4d
  jmp alltraps
801063f0:	e9 6e f8 ff ff       	jmp    80105c63 <alltraps>

801063f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $78
801063f7:	6a 4e                	push   $0x4e
  jmp alltraps
801063f9:	e9 65 f8 ff ff       	jmp    80105c63 <alltraps>

801063fe <vector79>:
.globl vector79
vector79:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $79
80106400:	6a 4f                	push   $0x4f
  jmp alltraps
80106402:	e9 5c f8 ff ff       	jmp    80105c63 <alltraps>

80106407 <vector80>:
.globl vector80
vector80:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $80
80106409:	6a 50                	push   $0x50
  jmp alltraps
8010640b:	e9 53 f8 ff ff       	jmp    80105c63 <alltraps>

80106410 <vector81>:
.globl vector81
vector81:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $81
80106412:	6a 51                	push   $0x51
  jmp alltraps
80106414:	e9 4a f8 ff ff       	jmp    80105c63 <alltraps>

80106419 <vector82>:
.globl vector82
vector82:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $82
8010641b:	6a 52                	push   $0x52
  jmp alltraps
8010641d:	e9 41 f8 ff ff       	jmp    80105c63 <alltraps>

80106422 <vector83>:
.globl vector83
vector83:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $83
80106424:	6a 53                	push   $0x53
  jmp alltraps
80106426:	e9 38 f8 ff ff       	jmp    80105c63 <alltraps>

8010642b <vector84>:
.globl vector84
vector84:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $84
8010642d:	6a 54                	push   $0x54
  jmp alltraps
8010642f:	e9 2f f8 ff ff       	jmp    80105c63 <alltraps>

80106434 <vector85>:
.globl vector85
vector85:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $85
80106436:	6a 55                	push   $0x55
  jmp alltraps
80106438:	e9 26 f8 ff ff       	jmp    80105c63 <alltraps>

8010643d <vector86>:
.globl vector86
vector86:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $86
8010643f:	6a 56                	push   $0x56
  jmp alltraps
80106441:	e9 1d f8 ff ff       	jmp    80105c63 <alltraps>

80106446 <vector87>:
.globl vector87
vector87:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $87
80106448:	6a 57                	push   $0x57
  jmp alltraps
8010644a:	e9 14 f8 ff ff       	jmp    80105c63 <alltraps>

8010644f <vector88>:
.globl vector88
vector88:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $88
80106451:	6a 58                	push   $0x58
  jmp alltraps
80106453:	e9 0b f8 ff ff       	jmp    80105c63 <alltraps>

80106458 <vector89>:
.globl vector89
vector89:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $89
8010645a:	6a 59                	push   $0x59
  jmp alltraps
8010645c:	e9 02 f8 ff ff       	jmp    80105c63 <alltraps>

80106461 <vector90>:
.globl vector90
vector90:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $90
80106463:	6a 5a                	push   $0x5a
  jmp alltraps
80106465:	e9 f9 f7 ff ff       	jmp    80105c63 <alltraps>

8010646a <vector91>:
.globl vector91
vector91:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $91
8010646c:	6a 5b                	push   $0x5b
  jmp alltraps
8010646e:	e9 f0 f7 ff ff       	jmp    80105c63 <alltraps>

80106473 <vector92>:
.globl vector92
vector92:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $92
80106475:	6a 5c                	push   $0x5c
  jmp alltraps
80106477:	e9 e7 f7 ff ff       	jmp    80105c63 <alltraps>

8010647c <vector93>:
.globl vector93
vector93:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $93
8010647e:	6a 5d                	push   $0x5d
  jmp alltraps
80106480:	e9 de f7 ff ff       	jmp    80105c63 <alltraps>

80106485 <vector94>:
.globl vector94
vector94:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $94
80106487:	6a 5e                	push   $0x5e
  jmp alltraps
80106489:	e9 d5 f7 ff ff       	jmp    80105c63 <alltraps>

8010648e <vector95>:
.globl vector95
vector95:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $95
80106490:	6a 5f                	push   $0x5f
  jmp alltraps
80106492:	e9 cc f7 ff ff       	jmp    80105c63 <alltraps>

80106497 <vector96>:
.globl vector96
vector96:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $96
80106499:	6a 60                	push   $0x60
  jmp alltraps
8010649b:	e9 c3 f7 ff ff       	jmp    80105c63 <alltraps>

801064a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $97
801064a2:	6a 61                	push   $0x61
  jmp alltraps
801064a4:	e9 ba f7 ff ff       	jmp    80105c63 <alltraps>

801064a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $98
801064ab:	6a 62                	push   $0x62
  jmp alltraps
801064ad:	e9 b1 f7 ff ff       	jmp    80105c63 <alltraps>

801064b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $99
801064b4:	6a 63                	push   $0x63
  jmp alltraps
801064b6:	e9 a8 f7 ff ff       	jmp    80105c63 <alltraps>

801064bb <vector100>:
.globl vector100
vector100:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $100
801064bd:	6a 64                	push   $0x64
  jmp alltraps
801064bf:	e9 9f f7 ff ff       	jmp    80105c63 <alltraps>

801064c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $101
801064c6:	6a 65                	push   $0x65
  jmp alltraps
801064c8:	e9 96 f7 ff ff       	jmp    80105c63 <alltraps>

801064cd <vector102>:
.globl vector102
vector102:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $102
801064cf:	6a 66                	push   $0x66
  jmp alltraps
801064d1:	e9 8d f7 ff ff       	jmp    80105c63 <alltraps>

801064d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $103
801064d8:	6a 67                	push   $0x67
  jmp alltraps
801064da:	e9 84 f7 ff ff       	jmp    80105c63 <alltraps>

801064df <vector104>:
.globl vector104
vector104:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $104
801064e1:	6a 68                	push   $0x68
  jmp alltraps
801064e3:	e9 7b f7 ff ff       	jmp    80105c63 <alltraps>

801064e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $105
801064ea:	6a 69                	push   $0x69
  jmp alltraps
801064ec:	e9 72 f7 ff ff       	jmp    80105c63 <alltraps>

801064f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $106
801064f3:	6a 6a                	push   $0x6a
  jmp alltraps
801064f5:	e9 69 f7 ff ff       	jmp    80105c63 <alltraps>

801064fa <vector107>:
.globl vector107
vector107:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $107
801064fc:	6a 6b                	push   $0x6b
  jmp alltraps
801064fe:	e9 60 f7 ff ff       	jmp    80105c63 <alltraps>

80106503 <vector108>:
.globl vector108
vector108:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $108
80106505:	6a 6c                	push   $0x6c
  jmp alltraps
80106507:	e9 57 f7 ff ff       	jmp    80105c63 <alltraps>

8010650c <vector109>:
.globl vector109
vector109:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $109
8010650e:	6a 6d                	push   $0x6d
  jmp alltraps
80106510:	e9 4e f7 ff ff       	jmp    80105c63 <alltraps>

80106515 <vector110>:
.globl vector110
vector110:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $110
80106517:	6a 6e                	push   $0x6e
  jmp alltraps
80106519:	e9 45 f7 ff ff       	jmp    80105c63 <alltraps>

8010651e <vector111>:
.globl vector111
vector111:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $111
80106520:	6a 6f                	push   $0x6f
  jmp alltraps
80106522:	e9 3c f7 ff ff       	jmp    80105c63 <alltraps>

80106527 <vector112>:
.globl vector112
vector112:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $112
80106529:	6a 70                	push   $0x70
  jmp alltraps
8010652b:	e9 33 f7 ff ff       	jmp    80105c63 <alltraps>

80106530 <vector113>:
.globl vector113
vector113:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $113
80106532:	6a 71                	push   $0x71
  jmp alltraps
80106534:	e9 2a f7 ff ff       	jmp    80105c63 <alltraps>

80106539 <vector114>:
.globl vector114
vector114:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $114
8010653b:	6a 72                	push   $0x72
  jmp alltraps
8010653d:	e9 21 f7 ff ff       	jmp    80105c63 <alltraps>

80106542 <vector115>:
.globl vector115
vector115:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $115
80106544:	6a 73                	push   $0x73
  jmp alltraps
80106546:	e9 18 f7 ff ff       	jmp    80105c63 <alltraps>

8010654b <vector116>:
.globl vector116
vector116:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $116
8010654d:	6a 74                	push   $0x74
  jmp alltraps
8010654f:	e9 0f f7 ff ff       	jmp    80105c63 <alltraps>

80106554 <vector117>:
.globl vector117
vector117:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $117
80106556:	6a 75                	push   $0x75
  jmp alltraps
80106558:	e9 06 f7 ff ff       	jmp    80105c63 <alltraps>

8010655d <vector118>:
.globl vector118
vector118:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $118
8010655f:	6a 76                	push   $0x76
  jmp alltraps
80106561:	e9 fd f6 ff ff       	jmp    80105c63 <alltraps>

80106566 <vector119>:
.globl vector119
vector119:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $119
80106568:	6a 77                	push   $0x77
  jmp alltraps
8010656a:	e9 f4 f6 ff ff       	jmp    80105c63 <alltraps>

8010656f <vector120>:
.globl vector120
vector120:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $120
80106571:	6a 78                	push   $0x78
  jmp alltraps
80106573:	e9 eb f6 ff ff       	jmp    80105c63 <alltraps>

80106578 <vector121>:
.globl vector121
vector121:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $121
8010657a:	6a 79                	push   $0x79
  jmp alltraps
8010657c:	e9 e2 f6 ff ff       	jmp    80105c63 <alltraps>

80106581 <vector122>:
.globl vector122
vector122:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $122
80106583:	6a 7a                	push   $0x7a
  jmp alltraps
80106585:	e9 d9 f6 ff ff       	jmp    80105c63 <alltraps>

8010658a <vector123>:
.globl vector123
vector123:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $123
8010658c:	6a 7b                	push   $0x7b
  jmp alltraps
8010658e:	e9 d0 f6 ff ff       	jmp    80105c63 <alltraps>

80106593 <vector124>:
.globl vector124
vector124:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $124
80106595:	6a 7c                	push   $0x7c
  jmp alltraps
80106597:	e9 c7 f6 ff ff       	jmp    80105c63 <alltraps>

8010659c <vector125>:
.globl vector125
vector125:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $125
8010659e:	6a 7d                	push   $0x7d
  jmp alltraps
801065a0:	e9 be f6 ff ff       	jmp    80105c63 <alltraps>

801065a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $126
801065a7:	6a 7e                	push   $0x7e
  jmp alltraps
801065a9:	e9 b5 f6 ff ff       	jmp    80105c63 <alltraps>

801065ae <vector127>:
.globl vector127
vector127:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $127
801065b0:	6a 7f                	push   $0x7f
  jmp alltraps
801065b2:	e9 ac f6 ff ff       	jmp    80105c63 <alltraps>

801065b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $128
801065b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065be:	e9 a0 f6 ff ff       	jmp    80105c63 <alltraps>

801065c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $129
801065c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ca:	e9 94 f6 ff ff       	jmp    80105c63 <alltraps>

801065cf <vector130>:
.globl vector130
vector130:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $130
801065d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065d6:	e9 88 f6 ff ff       	jmp    80105c63 <alltraps>

801065db <vector131>:
.globl vector131
vector131:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $131
801065dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065e2:	e9 7c f6 ff ff       	jmp    80105c63 <alltraps>

801065e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $132
801065e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ee:	e9 70 f6 ff ff       	jmp    80105c63 <alltraps>

801065f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $133
801065f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065fa:	e9 64 f6 ff ff       	jmp    80105c63 <alltraps>

801065ff <vector134>:
.globl vector134
vector134:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $134
80106601:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106606:	e9 58 f6 ff ff       	jmp    80105c63 <alltraps>

8010660b <vector135>:
.globl vector135
vector135:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $135
8010660d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106612:	e9 4c f6 ff ff       	jmp    80105c63 <alltraps>

80106617 <vector136>:
.globl vector136
vector136:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $136
80106619:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010661e:	e9 40 f6 ff ff       	jmp    80105c63 <alltraps>

80106623 <vector137>:
.globl vector137
vector137:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $137
80106625:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010662a:	e9 34 f6 ff ff       	jmp    80105c63 <alltraps>

8010662f <vector138>:
.globl vector138
vector138:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $138
80106631:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106636:	e9 28 f6 ff ff       	jmp    80105c63 <alltraps>

8010663b <vector139>:
.globl vector139
vector139:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $139
8010663d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106642:	e9 1c f6 ff ff       	jmp    80105c63 <alltraps>

80106647 <vector140>:
.globl vector140
vector140:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $140
80106649:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010664e:	e9 10 f6 ff ff       	jmp    80105c63 <alltraps>

80106653 <vector141>:
.globl vector141
vector141:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $141
80106655:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010665a:	e9 04 f6 ff ff       	jmp    80105c63 <alltraps>

8010665f <vector142>:
.globl vector142
vector142:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $142
80106661:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106666:	e9 f8 f5 ff ff       	jmp    80105c63 <alltraps>

8010666b <vector143>:
.globl vector143
vector143:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $143
8010666d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106672:	e9 ec f5 ff ff       	jmp    80105c63 <alltraps>

80106677 <vector144>:
.globl vector144
vector144:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $144
80106679:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010667e:	e9 e0 f5 ff ff       	jmp    80105c63 <alltraps>

80106683 <vector145>:
.globl vector145
vector145:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $145
80106685:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010668a:	e9 d4 f5 ff ff       	jmp    80105c63 <alltraps>

8010668f <vector146>:
.globl vector146
vector146:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $146
80106691:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106696:	e9 c8 f5 ff ff       	jmp    80105c63 <alltraps>

8010669b <vector147>:
.globl vector147
vector147:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $147
8010669d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066a2:	e9 bc f5 ff ff       	jmp    80105c63 <alltraps>

801066a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $148
801066a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ae:	e9 b0 f5 ff ff       	jmp    80105c63 <alltraps>

801066b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $149
801066b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ba:	e9 a4 f5 ff ff       	jmp    80105c63 <alltraps>

801066bf <vector150>:
.globl vector150
vector150:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $150
801066c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066c6:	e9 98 f5 ff ff       	jmp    80105c63 <alltraps>

801066cb <vector151>:
.globl vector151
vector151:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $151
801066cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066d2:	e9 8c f5 ff ff       	jmp    80105c63 <alltraps>

801066d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $152
801066d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066de:	e9 80 f5 ff ff       	jmp    80105c63 <alltraps>

801066e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $153
801066e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ea:	e9 74 f5 ff ff       	jmp    80105c63 <alltraps>

801066ef <vector154>:
.globl vector154
vector154:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $154
801066f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066f6:	e9 68 f5 ff ff       	jmp    80105c63 <alltraps>

801066fb <vector155>:
.globl vector155
vector155:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $155
801066fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106702:	e9 5c f5 ff ff       	jmp    80105c63 <alltraps>

80106707 <vector156>:
.globl vector156
vector156:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $156
80106709:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010670e:	e9 50 f5 ff ff       	jmp    80105c63 <alltraps>

80106713 <vector157>:
.globl vector157
vector157:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $157
80106715:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010671a:	e9 44 f5 ff ff       	jmp    80105c63 <alltraps>

8010671f <vector158>:
.globl vector158
vector158:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $158
80106721:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106726:	e9 38 f5 ff ff       	jmp    80105c63 <alltraps>

8010672b <vector159>:
.globl vector159
vector159:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $159
8010672d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106732:	e9 2c f5 ff ff       	jmp    80105c63 <alltraps>

80106737 <vector160>:
.globl vector160
vector160:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $160
80106739:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010673e:	e9 20 f5 ff ff       	jmp    80105c63 <alltraps>

80106743 <vector161>:
.globl vector161
vector161:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $161
80106745:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010674a:	e9 14 f5 ff ff       	jmp    80105c63 <alltraps>

8010674f <vector162>:
.globl vector162
vector162:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $162
80106751:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106756:	e9 08 f5 ff ff       	jmp    80105c63 <alltraps>

8010675b <vector163>:
.globl vector163
vector163:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $163
8010675d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106762:	e9 fc f4 ff ff       	jmp    80105c63 <alltraps>

80106767 <vector164>:
.globl vector164
vector164:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $164
80106769:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010676e:	e9 f0 f4 ff ff       	jmp    80105c63 <alltraps>

80106773 <vector165>:
.globl vector165
vector165:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $165
80106775:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010677a:	e9 e4 f4 ff ff       	jmp    80105c63 <alltraps>

8010677f <vector166>:
.globl vector166
vector166:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $166
80106781:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106786:	e9 d8 f4 ff ff       	jmp    80105c63 <alltraps>

8010678b <vector167>:
.globl vector167
vector167:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $167
8010678d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106792:	e9 cc f4 ff ff       	jmp    80105c63 <alltraps>

80106797 <vector168>:
.globl vector168
vector168:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $168
80106799:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010679e:	e9 c0 f4 ff ff       	jmp    80105c63 <alltraps>

801067a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $169
801067a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067aa:	e9 b4 f4 ff ff       	jmp    80105c63 <alltraps>

801067af <vector170>:
.globl vector170
vector170:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $170
801067b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067b6:	e9 a8 f4 ff ff       	jmp    80105c63 <alltraps>

801067bb <vector171>:
.globl vector171
vector171:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $171
801067bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067c2:	e9 9c f4 ff ff       	jmp    80105c63 <alltraps>

801067c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $172
801067c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067ce:	e9 90 f4 ff ff       	jmp    80105c63 <alltraps>

801067d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $173
801067d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067da:	e9 84 f4 ff ff       	jmp    80105c63 <alltraps>

801067df <vector174>:
.globl vector174
vector174:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $174
801067e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067e6:	e9 78 f4 ff ff       	jmp    80105c63 <alltraps>

801067eb <vector175>:
.globl vector175
vector175:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $175
801067ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067f2:	e9 6c f4 ff ff       	jmp    80105c63 <alltraps>

801067f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $176
801067f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067fe:	e9 60 f4 ff ff       	jmp    80105c63 <alltraps>

80106803 <vector177>:
.globl vector177
vector177:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $177
80106805:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010680a:	e9 54 f4 ff ff       	jmp    80105c63 <alltraps>

8010680f <vector178>:
.globl vector178
vector178:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $178
80106811:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106816:	e9 48 f4 ff ff       	jmp    80105c63 <alltraps>

8010681b <vector179>:
.globl vector179
vector179:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $179
8010681d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106822:	e9 3c f4 ff ff       	jmp    80105c63 <alltraps>

80106827 <vector180>:
.globl vector180
vector180:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $180
80106829:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010682e:	e9 30 f4 ff ff       	jmp    80105c63 <alltraps>

80106833 <vector181>:
.globl vector181
vector181:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $181
80106835:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010683a:	e9 24 f4 ff ff       	jmp    80105c63 <alltraps>

8010683f <vector182>:
.globl vector182
vector182:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $182
80106841:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106846:	e9 18 f4 ff ff       	jmp    80105c63 <alltraps>

8010684b <vector183>:
.globl vector183
vector183:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $183
8010684d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106852:	e9 0c f4 ff ff       	jmp    80105c63 <alltraps>

80106857 <vector184>:
.globl vector184
vector184:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $184
80106859:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010685e:	e9 00 f4 ff ff       	jmp    80105c63 <alltraps>

80106863 <vector185>:
.globl vector185
vector185:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $185
80106865:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010686a:	e9 f4 f3 ff ff       	jmp    80105c63 <alltraps>

8010686f <vector186>:
.globl vector186
vector186:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $186
80106871:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106876:	e9 e8 f3 ff ff       	jmp    80105c63 <alltraps>

8010687b <vector187>:
.globl vector187
vector187:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $187
8010687d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106882:	e9 dc f3 ff ff       	jmp    80105c63 <alltraps>

80106887 <vector188>:
.globl vector188
vector188:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $188
80106889:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010688e:	e9 d0 f3 ff ff       	jmp    80105c63 <alltraps>

80106893 <vector189>:
.globl vector189
vector189:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $189
80106895:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010689a:	e9 c4 f3 ff ff       	jmp    80105c63 <alltraps>

8010689f <vector190>:
.globl vector190
vector190:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $190
801068a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068a6:	e9 b8 f3 ff ff       	jmp    80105c63 <alltraps>

801068ab <vector191>:
.globl vector191
vector191:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $191
801068ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068b2:	e9 ac f3 ff ff       	jmp    80105c63 <alltraps>

801068b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $192
801068b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068be:	e9 a0 f3 ff ff       	jmp    80105c63 <alltraps>

801068c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $193
801068c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ca:	e9 94 f3 ff ff       	jmp    80105c63 <alltraps>

801068cf <vector194>:
.globl vector194
vector194:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $194
801068d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068d6:	e9 88 f3 ff ff       	jmp    80105c63 <alltraps>

801068db <vector195>:
.globl vector195
vector195:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $195
801068dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068e2:	e9 7c f3 ff ff       	jmp    80105c63 <alltraps>

801068e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $196
801068e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ee:	e9 70 f3 ff ff       	jmp    80105c63 <alltraps>

801068f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $197
801068f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068fa:	e9 64 f3 ff ff       	jmp    80105c63 <alltraps>

801068ff <vector198>:
.globl vector198
vector198:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $198
80106901:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106906:	e9 58 f3 ff ff       	jmp    80105c63 <alltraps>

8010690b <vector199>:
.globl vector199
vector199:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $199
8010690d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106912:	e9 4c f3 ff ff       	jmp    80105c63 <alltraps>

80106917 <vector200>:
.globl vector200
vector200:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $200
80106919:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010691e:	e9 40 f3 ff ff       	jmp    80105c63 <alltraps>

80106923 <vector201>:
.globl vector201
vector201:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $201
80106925:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010692a:	e9 34 f3 ff ff       	jmp    80105c63 <alltraps>

8010692f <vector202>:
.globl vector202
vector202:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $202
80106931:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106936:	e9 28 f3 ff ff       	jmp    80105c63 <alltraps>

8010693b <vector203>:
.globl vector203
vector203:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $203
8010693d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106942:	e9 1c f3 ff ff       	jmp    80105c63 <alltraps>

80106947 <vector204>:
.globl vector204
vector204:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $204
80106949:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010694e:	e9 10 f3 ff ff       	jmp    80105c63 <alltraps>

80106953 <vector205>:
.globl vector205
vector205:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $205
80106955:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010695a:	e9 04 f3 ff ff       	jmp    80105c63 <alltraps>

8010695f <vector206>:
.globl vector206
vector206:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $206
80106961:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106966:	e9 f8 f2 ff ff       	jmp    80105c63 <alltraps>

8010696b <vector207>:
.globl vector207
vector207:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $207
8010696d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106972:	e9 ec f2 ff ff       	jmp    80105c63 <alltraps>

80106977 <vector208>:
.globl vector208
vector208:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $208
80106979:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010697e:	e9 e0 f2 ff ff       	jmp    80105c63 <alltraps>

80106983 <vector209>:
.globl vector209
vector209:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $209
80106985:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010698a:	e9 d4 f2 ff ff       	jmp    80105c63 <alltraps>

8010698f <vector210>:
.globl vector210
vector210:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $210
80106991:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106996:	e9 c8 f2 ff ff       	jmp    80105c63 <alltraps>

8010699b <vector211>:
.globl vector211
vector211:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $211
8010699d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069a2:	e9 bc f2 ff ff       	jmp    80105c63 <alltraps>

801069a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $212
801069a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ae:	e9 b0 f2 ff ff       	jmp    80105c63 <alltraps>

801069b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $213
801069b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ba:	e9 a4 f2 ff ff       	jmp    80105c63 <alltraps>

801069bf <vector214>:
.globl vector214
vector214:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $214
801069c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069c6:	e9 98 f2 ff ff       	jmp    80105c63 <alltraps>

801069cb <vector215>:
.globl vector215
vector215:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $215
801069cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069d2:	e9 8c f2 ff ff       	jmp    80105c63 <alltraps>

801069d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $216
801069d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069de:	e9 80 f2 ff ff       	jmp    80105c63 <alltraps>

801069e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $217
801069e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ea:	e9 74 f2 ff ff       	jmp    80105c63 <alltraps>

801069ef <vector218>:
.globl vector218
vector218:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $218
801069f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069f6:	e9 68 f2 ff ff       	jmp    80105c63 <alltraps>

801069fb <vector219>:
.globl vector219
vector219:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $219
801069fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a02:	e9 5c f2 ff ff       	jmp    80105c63 <alltraps>

80106a07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $220
80106a09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a0e:	e9 50 f2 ff ff       	jmp    80105c63 <alltraps>

80106a13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $221
80106a15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a1a:	e9 44 f2 ff ff       	jmp    80105c63 <alltraps>

80106a1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $222
80106a21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a26:	e9 38 f2 ff ff       	jmp    80105c63 <alltraps>

80106a2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $223
80106a2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a32:	e9 2c f2 ff ff       	jmp    80105c63 <alltraps>

80106a37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $224
80106a39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a3e:	e9 20 f2 ff ff       	jmp    80105c63 <alltraps>

80106a43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $225
80106a45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a4a:	e9 14 f2 ff ff       	jmp    80105c63 <alltraps>

80106a4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $226
80106a51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a56:	e9 08 f2 ff ff       	jmp    80105c63 <alltraps>

80106a5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $227
80106a5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a62:	e9 fc f1 ff ff       	jmp    80105c63 <alltraps>

80106a67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $228
80106a69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a6e:	e9 f0 f1 ff ff       	jmp    80105c63 <alltraps>

80106a73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $229
80106a75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a7a:	e9 e4 f1 ff ff       	jmp    80105c63 <alltraps>

80106a7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $230
80106a81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a86:	e9 d8 f1 ff ff       	jmp    80105c63 <alltraps>

80106a8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $231
80106a8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a92:	e9 cc f1 ff ff       	jmp    80105c63 <alltraps>

80106a97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $232
80106a99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a9e:	e9 c0 f1 ff ff       	jmp    80105c63 <alltraps>

80106aa3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $233
80106aa5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aaa:	e9 b4 f1 ff ff       	jmp    80105c63 <alltraps>

80106aaf <vector234>:
.globl vector234
vector234:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $234
80106ab1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ab6:	e9 a8 f1 ff ff       	jmp    80105c63 <alltraps>

80106abb <vector235>:
.globl vector235
vector235:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $235
80106abd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ac2:	e9 9c f1 ff ff       	jmp    80105c63 <alltraps>

80106ac7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $236
80106ac9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ace:	e9 90 f1 ff ff       	jmp    80105c63 <alltraps>

80106ad3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $237
80106ad5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ada:	e9 84 f1 ff ff       	jmp    80105c63 <alltraps>

80106adf <vector238>:
.globl vector238
vector238:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $238
80106ae1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ae6:	e9 78 f1 ff ff       	jmp    80105c63 <alltraps>

80106aeb <vector239>:
.globl vector239
vector239:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $239
80106aed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106af2:	e9 6c f1 ff ff       	jmp    80105c63 <alltraps>

80106af7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $240
80106af9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106afe:	e9 60 f1 ff ff       	jmp    80105c63 <alltraps>

80106b03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $241
80106b05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b0a:	e9 54 f1 ff ff       	jmp    80105c63 <alltraps>

80106b0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $242
80106b11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b16:	e9 48 f1 ff ff       	jmp    80105c63 <alltraps>

80106b1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $243
80106b1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b22:	e9 3c f1 ff ff       	jmp    80105c63 <alltraps>

80106b27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $244
80106b29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b2e:	e9 30 f1 ff ff       	jmp    80105c63 <alltraps>

80106b33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $245
80106b35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b3a:	e9 24 f1 ff ff       	jmp    80105c63 <alltraps>

80106b3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $246
80106b41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b46:	e9 18 f1 ff ff       	jmp    80105c63 <alltraps>

80106b4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $247
80106b4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b52:	e9 0c f1 ff ff       	jmp    80105c63 <alltraps>

80106b57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $248
80106b59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b5e:	e9 00 f1 ff ff       	jmp    80105c63 <alltraps>

80106b63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $249
80106b65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b6a:	e9 f4 f0 ff ff       	jmp    80105c63 <alltraps>

80106b6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $250
80106b71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b76:	e9 e8 f0 ff ff       	jmp    80105c63 <alltraps>

80106b7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $251
80106b7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b82:	e9 dc f0 ff ff       	jmp    80105c63 <alltraps>

80106b87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $252
80106b89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b8e:	e9 d0 f0 ff ff       	jmp    80105c63 <alltraps>

80106b93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $253
80106b95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b9a:	e9 c4 f0 ff ff       	jmp    80105c63 <alltraps>

80106b9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $254
80106ba1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ba6:	e9 b8 f0 ff ff       	jmp    80105c63 <alltraps>

80106bab <vector255>:
.globl vector255
vector255:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $255
80106bad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bb2:	e9 ac f0 ff ff       	jmp    80105c63 <alltraps>
80106bb7:	66 90                	xchg   %ax,%ax
80106bb9:	66 90                	xchg   %ax,%ax
80106bbb:	66 90                	xchg   %ax,%ax
80106bbd:	66 90                	xchg   %ax,%ax
80106bbf:	90                   	nop

80106bc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bc6:	89 d3                	mov    %edx,%ebx
{
80106bc8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106bca:	c1 eb 16             	shr    $0x16,%ebx
80106bcd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106bd0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106bd3:	8b 06                	mov    (%esi),%eax
80106bd5:	a8 01                	test   $0x1,%al
80106bd7:	74 27                	je     80106c00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bde:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106be4:	c1 ef 0a             	shr    $0xa,%edi
}
80106be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bea:	89 fa                	mov    %edi,%edx
80106bec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bf2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c00:	85 c9                	test   %ecx,%ecx
80106c02:	74 2c                	je     80106c30 <walkpgdir+0x70>
80106c04:	e8 c7 b8 ff ff       	call   801024d0 <kalloc>
80106c09:	85 c0                	test   %eax,%eax
80106c0b:	89 c3                	mov    %eax,%ebx
80106c0d:	74 21                	je     80106c30 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c0f:	83 ec 04             	sub    $0x4,%esp
80106c12:	68 00 10 00 00       	push   $0x1000
80106c17:	6a 00                	push   $0x0
80106c19:	50                   	push   %eax
80106c1a:	e8 51 de ff ff       	call   80104a70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c1f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c25:	83 c4 10             	add    $0x10,%esp
80106c28:	83 c8 07             	or     $0x7,%eax
80106c2b:	89 06                	mov    %eax,(%esi)
80106c2d:	eb b5                	jmp    80106be4 <walkpgdir+0x24>
80106c2f:	90                   	nop
}
80106c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c33:	31 c0                	xor    %eax,%eax
}
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5f                   	pop    %edi
80106c38:	5d                   	pop    %ebp
80106c39:	c3                   	ret    
80106c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c40 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c46:	89 d3                	mov    %edx,%ebx
80106c48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c4e:	83 ec 1c             	sub    $0x1c,%esp
80106c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c66:	29 df                	sub    %ebx,%edi
80106c68:	83 c8 01             	or     $0x1,%eax
80106c6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c6e:	eb 15                	jmp    80106c85 <mappages+0x45>
    if(*pte & PTE_P)
80106c70:	f6 00 01             	testb  $0x1,(%eax)
80106c73:	75 45                	jne    80106cba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c75:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c7b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c7d:	74 31                	je     80106cb0 <mappages+0x70>
      break;
    a += PGSIZE;
80106c7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c88:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c8d:	89 da                	mov    %ebx,%edx
80106c8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c92:	e8 29 ff ff ff       	call   80106bc0 <walkpgdir>
80106c97:	85 c0                	test   %eax,%eax
80106c99:	75 d5                	jne    80106c70 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ca3:	5b                   	pop    %ebx
80106ca4:	5e                   	pop    %esi
80106ca5:	5f                   	pop    %edi
80106ca6:	5d                   	pop    %ebp
80106ca7:	c3                   	ret    
80106ca8:	90                   	nop
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cb3:	31 c0                	xor    %eax,%eax
}
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    
      panic("remap");
80106cba:	83 ec 0c             	sub    $0xc,%esp
80106cbd:	68 8c 7e 10 80       	push   $0x80107e8c
80106cc2:	e8 c9 96 ff ff       	call   80100390 <panic>
80106cc7:	89 f6                	mov    %esi,%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cdc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cde:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ce4:	83 ec 1c             	sub    $0x1c,%esp
80106ce7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cea:	39 d3                	cmp    %edx,%ebx
80106cec:	73 66                	jae    80106d54 <deallocuvm.part.0+0x84>
80106cee:	89 d6                	mov    %edx,%esi
80106cf0:	eb 3d                	jmp    80106d2f <deallocuvm.part.0+0x5f>
80106cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cf8:	8b 10                	mov    (%eax),%edx
80106cfa:	f6 c2 01             	test   $0x1,%dl
80106cfd:	74 26                	je     80106d25 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106cff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d05:	74 58                	je     80106d5f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106d13:	52                   	push   %edx
80106d14:	e8 07 b6 ff ff       	call   80102320 <kfree>
      *pte = 0;
80106d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d1c:	83 c4 10             	add    $0x10,%esp
80106d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d2b:	39 f3                	cmp    %esi,%ebx
80106d2d:	73 25                	jae    80106d54 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d2f:	31 c9                	xor    %ecx,%ecx
80106d31:	89 da                	mov    %ebx,%edx
80106d33:	89 f8                	mov    %edi,%eax
80106d35:	e8 86 fe ff ff       	call   80106bc0 <walkpgdir>
    if(!pte)
80106d3a:	85 c0                	test   %eax,%eax
80106d3c:	75 ba                	jne    80106cf8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d50:	39 f3                	cmp    %esi,%ebx
80106d52:	72 db                	jb     80106d2f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d5a:	5b                   	pop    %ebx
80106d5b:	5e                   	pop    %esi
80106d5c:	5f                   	pop    %edi
80106d5d:	5d                   	pop    %ebp
80106d5e:	c3                   	ret    
        panic("kfree");
80106d5f:	83 ec 0c             	sub    $0xc,%esp
80106d62:	68 46 77 10 80       	push   $0x80107746
80106d67:	e8 24 96 ff ff       	call   80100390 <panic>
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d70 <seginit>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d76:	e8 75 ca ff ff       	call   801037f0 <cpuid>
80106d7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d81:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d8a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106d91:	ff 00 00 
80106d94:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106d9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106da5:	ff 00 00 
80106da8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106daf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106db2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106db9:	ff 00 00 
80106dbc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106dc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dc6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106dcd:	ff 00 00 
80106dd0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106dd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dda:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106ddf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	c1 e8 10             	shr    $0x10,%eax
80106de6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ded:	0f 01 10             	lgdtl  (%eax)
}
80106df0:	c9                   	leave  
80106df1:	c3                   	ret    
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e00:	a1 c4 68 11 80       	mov    0x801168c4,%eax
{
80106e05:	55                   	push   %ebp
80106e06:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e08:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e0d:	0f 22 d8             	mov    %eax,%cr3
}
80106e10:	5d                   	pop    %ebp
80106e11:	c3                   	ret    
80106e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <switchuvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e2c:	85 db                	test   %ebx,%ebx
80106e2e:	0f 84 cb 00 00 00    	je     80106eff <switchuvm+0xdf>
  if(p->kstack == 0)
80106e34:	8b 43 08             	mov    0x8(%ebx),%eax
80106e37:	85 c0                	test   %eax,%eax
80106e39:	0f 84 da 00 00 00    	je     80106f19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e3f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e42:	85 c0                	test   %eax,%eax
80106e44:	0f 84 c2 00 00 00    	je     80106f0c <switchuvm+0xec>
  pushcli();
80106e4a:	e8 61 da ff ff       	call   801048b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e4f:	e8 1c c9 ff ff       	call   80103770 <mycpu>
80106e54:	89 c6                	mov    %eax,%esi
80106e56:	e8 15 c9 ff ff       	call   80103770 <mycpu>
80106e5b:	89 c7                	mov    %eax,%edi
80106e5d:	e8 0e c9 ff ff       	call   80103770 <mycpu>
80106e62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e65:	83 c7 08             	add    $0x8,%edi
80106e68:	e8 03 c9 ff ff       	call   80103770 <mycpu>
80106e6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e70:	83 c0 08             	add    $0x8,%eax
80106e73:	ba 67 00 00 00       	mov    $0x67,%edx
80106e78:	c1 e8 18             	shr    $0x18,%eax
80106e7b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e82:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e89:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e8f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e94:	83 c1 08             	add    $0x8,%ecx
80106e97:	c1 e9 10             	shr    $0x10,%ecx
80106e9a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ea0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ea5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106eb1:	e8 ba c8 ff ff       	call   80103770 <mycpu>
80106eb6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ebd:	e8 ae c8 ff ff       	call   80103770 <mycpu>
80106ec2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ec6:	8b 73 08             	mov    0x8(%ebx),%esi
80106ec9:	e8 a2 c8 ff ff       	call   80103770 <mycpu>
80106ece:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ed4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ed7:	e8 94 c8 ff ff       	call   80103770 <mycpu>
80106edc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ee0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ee5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ee8:	8b 43 04             	mov    0x4(%ebx),%eax
80106eeb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ef0:	0f 22 d8             	mov    %eax,%cr3
}
80106ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef6:	5b                   	pop    %ebx
80106ef7:	5e                   	pop    %esi
80106ef8:	5f                   	pop    %edi
80106ef9:	5d                   	pop    %ebp
  popcli();
80106efa:	e9 b1 da ff ff       	jmp    801049b0 <popcli>
    panic("switchuvm: no process");
80106eff:	83 ec 0c             	sub    $0xc,%esp
80106f02:	68 92 7e 10 80       	push   $0x80107e92
80106f07:	e8 84 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106f0c:	83 ec 0c             	sub    $0xc,%esp
80106f0f:	68 bd 7e 10 80       	push   $0x80107ebd
80106f14:	e8 77 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106f19:	83 ec 0c             	sub    $0xc,%esp
80106f1c:	68 a8 7e 10 80       	push   $0x80107ea8
80106f21:	e8 6a 94 ff ff       	call   80100390 <panic>
80106f26:	8d 76 00             	lea    0x0(%esi),%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f30 <inituvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 1c             	sub    $0x1c,%esp
80106f39:	8b 75 10             	mov    0x10(%ebp),%esi
80106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f42:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f4b:	77 49                	ja     80106f96 <inituvm+0x66>
  mem = kalloc();
80106f4d:	e8 7e b5 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106f52:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f55:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f57:	68 00 10 00 00       	push   $0x1000
80106f5c:	6a 00                	push   $0x0
80106f5e:	50                   	push   %eax
80106f5f:	e8 0c db ff ff       	call   80104a70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f64:	58                   	pop    %eax
80106f65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f6b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f70:	5a                   	pop    %edx
80106f71:	6a 06                	push   $0x6
80106f73:	50                   	push   %eax
80106f74:	31 d2                	xor    %edx,%edx
80106f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f79:	e8 c2 fc ff ff       	call   80106c40 <mappages>
  memmove(mem, init, sz);
80106f7e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f81:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f84:	83 c4 10             	add    $0x10,%esp
80106f87:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f91:	e9 8a db ff ff       	jmp    80104b20 <memmove>
    panic("inituvm: more than a page");
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	68 d1 7e 10 80       	push   $0x80107ed1
80106f9e:	e8 ed 93 ff ff       	call   80100390 <panic>
80106fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <loaduvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106fb9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106fc0:	0f 85 91 00 00 00    	jne    80107057 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106fc6:	8b 75 18             	mov    0x18(%ebp),%esi
80106fc9:	31 db                	xor    %ebx,%ebx
80106fcb:	85 f6                	test   %esi,%esi
80106fcd:	75 1a                	jne    80106fe9 <loaduvm+0x39>
80106fcf:	eb 6f                	jmp    80107040 <loaduvm+0x90>
80106fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fde:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fe4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fe7:	76 57                	jbe    80107040 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fec:	8b 45 08             	mov    0x8(%ebp),%eax
80106fef:	31 c9                	xor    %ecx,%ecx
80106ff1:	01 da                	add    %ebx,%edx
80106ff3:	e8 c8 fb ff ff       	call   80106bc0 <walkpgdir>
80106ff8:	85 c0                	test   %eax,%eax
80106ffa:	74 4e                	je     8010704a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ffc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ffe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107001:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107006:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010700b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107011:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107014:	01 d9                	add    %ebx,%ecx
80107016:	05 00 00 00 80       	add    $0x80000000,%eax
8010701b:	57                   	push   %edi
8010701c:	51                   	push   %ecx
8010701d:	50                   	push   %eax
8010701e:	ff 75 10             	pushl  0x10(%ebp)
80107021:	e8 4a a9 ff ff       	call   80101970 <readi>
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	39 f8                	cmp    %edi,%eax
8010702b:	74 ab                	je     80106fd8 <loaduvm+0x28>
}
8010702d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107035:	5b                   	pop    %ebx
80107036:	5e                   	pop    %esi
80107037:	5f                   	pop    %edi
80107038:	5d                   	pop    %ebp
80107039:	c3                   	ret    
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107043:	31 c0                	xor    %eax,%eax
}
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
      panic("loaduvm: address should exist");
8010704a:	83 ec 0c             	sub    $0xc,%esp
8010704d:	68 eb 7e 10 80       	push   $0x80107eeb
80107052:	e8 39 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107057:	83 ec 0c             	sub    $0xc,%esp
8010705a:	68 8c 7f 10 80       	push   $0x80107f8c
8010705f:	e8 2c 93 ff ff       	call   80100390 <panic>
80107064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010706a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107070 <allocuvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107079:	8b 7d 10             	mov    0x10(%ebp),%edi
8010707c:	85 ff                	test   %edi,%edi
8010707e:	0f 88 8e 00 00 00    	js     80107112 <allocuvm+0xa2>
  if(newsz < oldsz)
80107084:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107087:	0f 82 93 00 00 00    	jb     80107120 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010708d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107090:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107096:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010709c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010709f:	0f 86 7e 00 00 00    	jbe    80107123 <allocuvm+0xb3>
801070a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801070a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070ab:	eb 42                	jmp    801070ef <allocuvm+0x7f>
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801070b0:	83 ec 04             	sub    $0x4,%esp
801070b3:	68 00 10 00 00       	push   $0x1000
801070b8:	6a 00                	push   $0x0
801070ba:	50                   	push   %eax
801070bb:	e8 b0 d9 ff ff       	call   80104a70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070c0:	58                   	pop    %eax
801070c1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070cc:	5a                   	pop    %edx
801070cd:	6a 06                	push   $0x6
801070cf:	50                   	push   %eax
801070d0:	89 da                	mov    %ebx,%edx
801070d2:	89 f8                	mov    %edi,%eax
801070d4:	e8 67 fb ff ff       	call   80106c40 <mappages>
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	85 c0                	test   %eax,%eax
801070de:	78 50                	js     80107130 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801070e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070e6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070e9:	0f 86 81 00 00 00    	jbe    80107170 <allocuvm+0x100>
    mem = kalloc();
801070ef:	e8 dc b3 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
801070f4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070f6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070f8:	75 b6                	jne    801070b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 09 7f 10 80       	push   $0x80107f09
80107102:	e8 59 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107107:	83 c4 10             	add    $0x10,%esp
8010710a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010710d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107110:	77 6e                	ja     80107180 <allocuvm+0x110>
}
80107112:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107115:	31 ff                	xor    %edi,%edi
}
80107117:	89 f8                	mov    %edi,%eax
80107119:	5b                   	pop    %ebx
8010711a:	5e                   	pop    %esi
8010711b:	5f                   	pop    %edi
8010711c:	5d                   	pop    %ebp
8010711d:	c3                   	ret    
8010711e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107120:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107126:	89 f8                	mov    %edi,%eax
80107128:	5b                   	pop    %ebx
80107129:	5e                   	pop    %esi
8010712a:	5f                   	pop    %edi
8010712b:	5d                   	pop    %ebp
8010712c:	c3                   	ret    
8010712d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107130:	83 ec 0c             	sub    $0xc,%esp
80107133:	68 21 7f 10 80       	push   $0x80107f21
80107138:	e8 23 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010713d:	83 c4 10             	add    $0x10,%esp
80107140:	8b 45 0c             	mov    0xc(%ebp),%eax
80107143:	39 45 10             	cmp    %eax,0x10(%ebp)
80107146:	76 0d                	jbe    80107155 <allocuvm+0xe5>
80107148:	89 c1                	mov    %eax,%ecx
8010714a:	8b 55 10             	mov    0x10(%ebp),%edx
8010714d:	8b 45 08             	mov    0x8(%ebp),%eax
80107150:	e8 7b fb ff ff       	call   80106cd0 <deallocuvm.part.0>
      kfree(mem);
80107155:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107158:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010715a:	56                   	push   %esi
8010715b:	e8 c0 b1 ff ff       	call   80102320 <kfree>
      return 0;
80107160:	83 c4 10             	add    $0x10,%esp
}
80107163:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107166:	89 f8                	mov    %edi,%eax
80107168:	5b                   	pop    %ebx
80107169:	5e                   	pop    %esi
8010716a:	5f                   	pop    %edi
8010716b:	5d                   	pop    %ebp
8010716c:	c3                   	ret    
8010716d:	8d 76 00             	lea    0x0(%esi),%esi
80107170:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107176:	5b                   	pop    %ebx
80107177:	89 f8                	mov    %edi,%eax
80107179:	5e                   	pop    %esi
8010717a:	5f                   	pop    %edi
8010717b:	5d                   	pop    %ebp
8010717c:	c3                   	ret    
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
80107180:	89 c1                	mov    %eax,%ecx
80107182:	8b 55 10             	mov    0x10(%ebp),%edx
80107185:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107188:	31 ff                	xor    %edi,%edi
8010718a:	e8 41 fb ff ff       	call   80106cd0 <deallocuvm.part.0>
8010718f:	eb 92                	jmp    80107123 <allocuvm+0xb3>
80107191:	eb 0d                	jmp    801071a0 <deallocuvm>
80107193:	90                   	nop
80107194:	90                   	nop
80107195:	90                   	nop
80107196:	90                   	nop
80107197:	90                   	nop
80107198:	90                   	nop
80107199:	90                   	nop
8010719a:	90                   	nop
8010719b:	90                   	nop
8010719c:	90                   	nop
8010719d:	90                   	nop
8010719e:	90                   	nop
8010719f:	90                   	nop

801071a0 <deallocuvm>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801071a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801071ac:	39 d1                	cmp    %edx,%ecx
801071ae:	73 10                	jae    801071c0 <deallocuvm+0x20>
}
801071b0:	5d                   	pop    %ebp
801071b1:	e9 1a fb ff ff       	jmp    80106cd0 <deallocuvm.part.0>
801071b6:	8d 76 00             	lea    0x0(%esi),%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071c0:	89 d0                	mov    %edx,%eax
801071c2:	5d                   	pop    %ebp
801071c3:	c3                   	ret    
801071c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071dc:	85 f6                	test   %esi,%esi
801071de:	74 59                	je     80107239 <freevm+0x69>
801071e0:	31 c9                	xor    %ecx,%ecx
801071e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071e7:	89 f0                	mov    %esi,%eax
801071e9:	e8 e2 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
801071ee:	89 f3                	mov    %esi,%ebx
801071f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071f6:	eb 0f                	jmp    80107207 <freevm+0x37>
801071f8:	90                   	nop
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107200:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107203:	39 fb                	cmp    %edi,%ebx
80107205:	74 23                	je     8010722a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107207:	8b 03                	mov    (%ebx),%eax
80107209:	a8 01                	test   $0x1,%al
8010720b:	74 f3                	je     80107200 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010720d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107212:	83 ec 0c             	sub    $0xc,%esp
80107215:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107218:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010721d:	50                   	push   %eax
8010721e:	e8 fd b0 ff ff       	call   80102320 <kfree>
80107223:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107226:	39 fb                	cmp    %edi,%ebx
80107228:	75 dd                	jne    80107207 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010722a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010722d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107230:	5b                   	pop    %ebx
80107231:	5e                   	pop    %esi
80107232:	5f                   	pop    %edi
80107233:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107234:	e9 e7 b0 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80107239:	83 ec 0c             	sub    $0xc,%esp
8010723c:	68 3d 7f 10 80       	push   $0x80107f3d
80107241:	e8 4a 91 ff ff       	call   80100390 <panic>
80107246:	8d 76 00             	lea    0x0(%esi),%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <setupkvm>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	56                   	push   %esi
80107254:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107255:	e8 76 b2 ff ff       	call   801024d0 <kalloc>
8010725a:	85 c0                	test   %eax,%eax
8010725c:	89 c6                	mov    %eax,%esi
8010725e:	74 42                	je     801072a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107260:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107263:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107268:	68 00 10 00 00       	push   $0x1000
8010726d:	6a 00                	push   $0x0
8010726f:	50                   	push   %eax
80107270:	e8 fb d7 ff ff       	call   80104a70 <memset>
80107275:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107278:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010727b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010727e:	83 ec 08             	sub    $0x8,%esp
80107281:	8b 13                	mov    (%ebx),%edx
80107283:	ff 73 0c             	pushl  0xc(%ebx)
80107286:	50                   	push   %eax
80107287:	29 c1                	sub    %eax,%ecx
80107289:	89 f0                	mov    %esi,%eax
8010728b:	e8 b0 f9 ff ff       	call   80106c40 <mappages>
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	85 c0                	test   %eax,%eax
80107295:	78 19                	js     801072b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107297:	83 c3 10             	add    $0x10,%ebx
8010729a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801072a0:	75 d6                	jne    80107278 <setupkvm+0x28>
}
801072a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072a5:	89 f0                	mov    %esi,%eax
801072a7:	5b                   	pop    %ebx
801072a8:	5e                   	pop    %esi
801072a9:	5d                   	pop    %ebp
801072aa:	c3                   	ret    
801072ab:	90                   	nop
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	56                   	push   %esi
      return 0;
801072b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801072b6:	e8 15 ff ff ff       	call   801071d0 <freevm>
      return 0;
801072bb:	83 c4 10             	add    $0x10,%esp
}
801072be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072c1:	89 f0                	mov    %esi,%eax
801072c3:	5b                   	pop    %ebx
801072c4:	5e                   	pop    %esi
801072c5:	5d                   	pop    %ebp
801072c6:	c3                   	ret    
801072c7:	89 f6                	mov    %esi,%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072d0 <kvmalloc>:
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072d6:	e8 75 ff ff ff       	call   80107250 <setupkvm>
801072db:	a3 c4 68 11 80       	mov    %eax,0x801168c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e0:	05 00 00 00 80       	add    $0x80000000,%eax
801072e5:	0f 22 d8             	mov    %eax,%cr3
}
801072e8:	c9                   	leave  
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072f1:	31 c9                	xor    %ecx,%ecx
{
801072f3:	89 e5                	mov    %esp,%ebp
801072f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072fb:	8b 45 08             	mov    0x8(%ebp),%eax
801072fe:	e8 bd f8 ff ff       	call   80106bc0 <walkpgdir>
  if(pte == 0)
80107303:	85 c0                	test   %eax,%eax
80107305:	74 05                	je     8010730c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107307:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010730a:	c9                   	leave  
8010730b:	c3                   	ret    
    panic("clearpteu");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 4e 7f 10 80       	push   $0x80107f4e
80107314:	e8 77 90 ff ff       	call   80100390 <panic>
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107329:	e8 22 ff ff ff       	call   80107250 <setupkvm>
8010732e:	85 c0                	test   %eax,%eax
80107330:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107333:	0f 84 a0 00 00 00    	je     801073d9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010733c:	85 c9                	test   %ecx,%ecx
8010733e:	0f 84 95 00 00 00    	je     801073d9 <copyuvm+0xb9>
80107344:	31 f6                	xor    %esi,%esi
80107346:	eb 4e                	jmp    80107396 <copyuvm+0x76>
80107348:	90                   	nop
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107350:	83 ec 04             	sub    $0x4,%esp
80107353:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010735c:	68 00 10 00 00       	push   $0x1000
80107361:	57                   	push   %edi
80107362:	50                   	push   %eax
80107363:	e8 b8 d7 ff ff       	call   80104b20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107368:	58                   	pop    %eax
80107369:	5a                   	pop    %edx
8010736a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010736d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107370:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107375:	53                   	push   %ebx
80107376:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010737c:	52                   	push   %edx
8010737d:	89 f2                	mov    %esi,%edx
8010737f:	e8 bc f8 ff ff       	call   80106c40 <mappages>
80107384:	83 c4 10             	add    $0x10,%esp
80107387:	85 c0                	test   %eax,%eax
80107389:	78 39                	js     801073c4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010738b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107391:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107394:	76 43                	jbe    801073d9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107396:	8b 45 08             	mov    0x8(%ebp),%eax
80107399:	31 c9                	xor    %ecx,%ecx
8010739b:	89 f2                	mov    %esi,%edx
8010739d:	e8 1e f8 ff ff       	call   80106bc0 <walkpgdir>
801073a2:	85 c0                	test   %eax,%eax
801073a4:	74 3e                	je     801073e4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
801073a6:	8b 18                	mov    (%eax),%ebx
801073a8:	f6 c3 01             	test   $0x1,%bl
801073ab:	74 44                	je     801073f1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
801073ad:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801073af:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801073b5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801073bb:	e8 10 b1 ff ff       	call   801024d0 <kalloc>
801073c0:	85 c0                	test   %eax,%eax
801073c2:	75 8c                	jne    80107350 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801073c4:	83 ec 0c             	sub    $0xc,%esp
801073c7:	ff 75 e0             	pushl  -0x20(%ebp)
801073ca:	e8 01 fe ff ff       	call   801071d0 <freevm>
  return 0;
801073cf:	83 c4 10             	add    $0x10,%esp
801073d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073df:	5b                   	pop    %ebx
801073e0:	5e                   	pop    %esi
801073e1:	5f                   	pop    %edi
801073e2:	5d                   	pop    %ebp
801073e3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801073e4:	83 ec 0c             	sub    $0xc,%esp
801073e7:	68 58 7f 10 80       	push   $0x80107f58
801073ec:	e8 9f 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801073f1:	83 ec 0c             	sub    $0xc,%esp
801073f4:	68 72 7f 10 80       	push   $0x80107f72
801073f9:	e8 92 8f ff ff       	call   80100390 <panic>
801073fe:	66 90                	xchg   %ax,%ax

80107400 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107400:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107401:	31 c9                	xor    %ecx,%ecx
{
80107403:	89 e5                	mov    %esp,%ebp
80107405:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107408:	8b 55 0c             	mov    0xc(%ebp),%edx
8010740b:	8b 45 08             	mov    0x8(%ebp),%eax
8010740e:	e8 ad f7 ff ff       	call   80106bc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107413:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107415:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107416:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010741d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107420:	05 00 00 00 80       	add    $0x80000000,%eax
80107425:	83 fa 05             	cmp    $0x5,%edx
80107428:	ba 00 00 00 00       	mov    $0x0,%edx
8010742d:	0f 45 c2             	cmovne %edx,%eax
}
80107430:	c3                   	ret    
80107431:	eb 0d                	jmp    80107440 <copyout>
80107433:	90                   	nop
80107434:	90                   	nop
80107435:	90                   	nop
80107436:	90                   	nop
80107437:	90                   	nop
80107438:	90                   	nop
80107439:	90                   	nop
8010743a:	90                   	nop
8010743b:	90                   	nop
8010743c:	90                   	nop
8010743d:	90                   	nop
8010743e:	90                   	nop
8010743f:	90                   	nop

80107440 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010744c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107452:	85 db                	test   %ebx,%ebx
80107454:	75 40                	jne    80107496 <copyout+0x56>
80107456:	eb 70                	jmp    801074c8 <copyout+0x88>
80107458:	90                   	nop
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107460:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107463:	89 f1                	mov    %esi,%ecx
80107465:	29 d1                	sub    %edx,%ecx
80107467:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010746d:	39 d9                	cmp    %ebx,%ecx
8010746f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107472:	29 f2                	sub    %esi,%edx
80107474:	83 ec 04             	sub    $0x4,%esp
80107477:	01 d0                	add    %edx,%eax
80107479:	51                   	push   %ecx
8010747a:	57                   	push   %edi
8010747b:	50                   	push   %eax
8010747c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010747f:	e8 9c d6 ff ff       	call   80104b20 <memmove>
    len -= n;
    buf += n;
80107484:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107487:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010748a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107490:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107492:	29 cb                	sub    %ecx,%ebx
80107494:	74 32                	je     801074c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107496:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107498:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010749b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010749e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074a4:	56                   	push   %esi
801074a5:	ff 75 08             	pushl  0x8(%ebp)
801074a8:	e8 53 ff ff ff       	call   80107400 <uva2ka>
    if(pa0 == 0)
801074ad:	83 c4 10             	add    $0x10,%esp
801074b0:	85 c0                	test   %eax,%eax
801074b2:	75 ac                	jne    80107460 <copyout+0x20>
  }
  return 0;
}
801074b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074bc:	5b                   	pop    %ebx
801074bd:	5e                   	pop    %esi
801074be:	5f                   	pop    %edi
801074bf:	5d                   	pop    %ebp
801074c0:	c3                   	ret    
801074c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074cb:	31 c0                	xor    %eax,%eax
}
801074cd:	5b                   	pop    %ebx
801074ce:	5e                   	pop    %esi
801074cf:	5f                   	pop    %edi
801074d0:	5d                   	pop    %ebp
801074d1:	c3                   	ret    
