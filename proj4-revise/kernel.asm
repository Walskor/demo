
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
8010002d:	b8 20 31 10 80       	mov    $0x80103120,%eax
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
8010004c:	68 80 73 10 80       	push   $0x80107380
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 55 44 00 00       	call   801044b0 <initlock>
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
80100092:	68 87 73 10 80       	push   $0x80107387
80100097:	50                   	push   %eax
80100098:	e8 03 43 00 00       	call   801043a0 <initsleeplock>
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
801000e4:	e8 b7 44 00 00       	call   801045a0 <acquire>
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
80100162:	e8 59 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 42 00 00       	call   801043e0 <acquiresleep>
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
80100193:	68 8e 73 10 80       	push   $0x8010738e
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
801001ae:	e8 cd 42 00 00       	call   80104480 <holdingsleep>
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
801001cc:	68 9f 73 10 80       	push   $0x8010739f
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
801001ef:	e8 8c 42 00 00       	call   80104480 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 42 00 00       	call   80104440 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 90 43 00 00       	call   801045a0 <acquire>
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
8010025c:	e9 5f 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 73 10 80       	push   $0x801073a6
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
8010028c:	e8 0f 43 00 00       	call   801045a0 <acquire>
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
801002c5:	e8 86 3d 00 00       	call   80104050 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 80 37 00 00       	call   80103a60 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 cc 43 00 00       	call   801046c0 <release>
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
8010034d:	e8 6e 43 00 00       	call   801046c0 <release>
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
801003a9:	e8 e2 25 00 00       	call   80102990 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 73 10 80       	push   $0x801073ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 b2 78 10 80 	movl   $0x801078b2,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 40 00 00       	call   801044d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 73 10 80       	push   $0x801073c1
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
8010043a:	e8 91 59 00 00       	call   80105dd0 <uartputc>
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
801004ec:	e8 df 58 00 00       	call   80105dd0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 58 00 00       	call   80105dd0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 58 00 00       	call   80105dd0 <uartputc>
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
80100524:	e8 a7 42 00 00       	call   801047d0 <memmove>
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
80100541:	e8 da 41 00 00       	call   80104720 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 73 10 80       	push   $0x801073c5
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
801005b1:	0f b6 92 f0 73 10 80 	movzbl -0x7fef8c10(%edx),%edx
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
8010061b:	e8 80 3f 00 00       	call   801045a0 <acquire>
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
80100647:	e8 74 40 00 00       	call   801046c0 <release>
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
8010071f:	e8 9c 3f 00 00       	call   801046c0 <release>
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
801007d0:	ba d8 73 10 80       	mov    $0x801073d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 ab 3d 00 00       	call   801045a0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 73 10 80       	push   $0x801073df
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
80100823:	e8 78 3d 00 00       	call   801045a0 <acquire>
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
80100888:	e8 33 3e 00 00       	call   801046c0 <release>
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
80100916:	e8 e5 38 00 00       	call   80104200 <wakeup>
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
80100997:	e9 44 39 00 00       	jmp    801042e0 <procdump>
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
801009c6:	68 e8 73 10 80       	push   $0x801073e8
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 db 3a 00 00       	call   801044b0 <initlock>

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
80100a1c:	e8 3f 30 00 00       	call   80103a60 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 d4 23 00 00       	call   80102e00 <begin_op>

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
80100a6f:	e8 fc 23 00 00       	call   80102e70 <end_op>
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
80100a94:	e8 87 64 00 00       	call   80106f20 <setupkvm>
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
80100af6:	e8 45 62 00 00       	call   80106d40 <allocuvm>
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
80100b28:	e8 53 61 00 00       	call   80106c80 <loaduvm>
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
80100b72:	e8 29 63 00 00       	call   80106ea0 <freevm>
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
80100b9a:	e8 d1 22 00 00       	call   80102e70 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 61 00 00       	call   80106d40 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 62 00 00       	call   80106ea0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 98 22 00 00       	call   80102e70 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 74 10 80       	push   $0x80107401
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
80100c06:	e8 b5 63 00 00       	call   80106fc0 <clearpteu>
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
80100c39:	e8 02 3d 00 00       	call   80104940 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 3c 00 00       	call   80104940 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 7e 66 00 00       	call   801072e0 <copyout>
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
80100cc7:	e8 14 66 00 00       	call   801072e0 <copyout>
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
80100d0a:	e8 f1 3b 00 00       	call   80104900 <safestrcpy>
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
80100d34:	e8 b7 5d 00 00       	call   80106af0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 61 00 00       	call   80106ea0 <freevm>
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
80100d66:	68 0d 74 10 80       	push   $0x8010740d
80100d6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d70:	e8 3b 37 00 00       	call   801044b0 <initlock>
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
80100d91:	e8 0a 38 00 00       	call   801045a0 <acquire>
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
80100dc1:	e8 fa 38 00 00       	call   801046c0 <release>
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
80100dda:	e8 e1 38 00 00       	call   801046c0 <release>
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
80100dff:	e8 9c 37 00 00       	call   801045a0 <acquire>
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
80100e1c:	e8 9f 38 00 00       	call   801046c0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 14 74 10 80       	push   $0x80107414
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
80100e51:	e8 4a 37 00 00       	call   801045a0 <acquire>
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
80100e7c:	e9 3f 38 00 00       	jmp    801046c0 <release>
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
80100ea8:	e8 13 38 00 00       	call   801046c0 <release>
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
80100ed1:	e8 fa 26 00 00       	call   801035d0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 1b 1f 00 00       	call   80102e00 <begin_op>
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
80100efa:	e9 71 1f 00 00       	jmp    80102e70 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 1c 74 10 80       	push   $0x8010741c
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
80100fcd:	e9 ae 27 00 00       	jmp    80103780 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 26 74 10 80       	push   $0x80107426
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
80101049:	e8 22 1e 00 00       	call   80102e70 <end_op>
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
80101076:	e8 85 1d 00 00       	call   80102e00 <begin_op>
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
801010ad:	e8 be 1d 00 00       	call   80102e70 <end_op>
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
801010ed:	e9 7e 25 00 00       	jmp    80103670 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 2f 74 10 80       	push   $0x8010742f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 35 74 10 80       	push   $0x80107435
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
801011b4:	68 3f 74 10 80       	push   $0x8010743f
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
801011cd:	e8 fe 1d 00 00       	call   80102fd0 <log_write>
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
801011f5:	e8 26 35 00 00       	call   80104720 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 ce 1d 00 00       	call   80102fd0 <log_write>
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
8010123a:	e8 61 33 00 00       	call   801045a0 <acquire>
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
8010129f:	e8 1c 34 00 00       	call   801046c0 <release>

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
801012cd:	e8 ee 33 00 00       	call   801046c0 <release>
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
801012e2:	68 55 74 10 80       	push   $0x80107455
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
8010135e:	e8 6d 1c 00 00       	call   80102fd0 <log_write>
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
801013b7:	68 65 74 10 80       	push   $0x80107465
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
801013f1:	e8 da 33 00 00       	call   801047d0 <memmove>
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
8010146a:	e8 61 1b 00 00       	call   80102fd0 <log_write>
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
80101484:	68 78 74 10 80       	push   $0x80107478
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
8010149c:	68 8b 74 10 80       	push   $0x8010748b
801014a1:	68 00 0a 11 80       	push   $0x80110a00
801014a6:	e8 05 30 00 00       	call   801044b0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 92 74 10 80       	push   $0x80107492
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 dc 2e 00 00       	call   801043a0 <initsleeplock>
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
80101509:	68 f8 74 10 80       	push   $0x801074f8
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
8010159e:	e8 7d 31 00 00       	call   80104720 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 1b 1a 00 00       	call   80102fd0 <log_write>
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
801015d3:	68 98 74 10 80       	push   $0x80107498
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
80101641:	e8 8a 31 00 00       	call   801047d0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 82 19 00 00       	call   80102fd0 <log_write>
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
8010166f:	e8 2c 2f 00 00       	call   801045a0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010167f:	e8 3c 30 00 00       	call   801046c0 <release>
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
801016b2:	e8 29 2d 00 00       	call   801043e0 <acquiresleep>
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
80101728:	e8 a3 30 00 00       	call   801047d0 <memmove>
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
8010174d:	68 b0 74 10 80       	push   $0x801074b0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 aa 74 10 80       	push   $0x801074aa
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
80101783:	e8 f8 2c 00 00       	call   80104480 <holdingsleep>
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
8010179f:	e9 9c 2c 00 00       	jmp    80104440 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 bf 74 10 80       	push   $0x801074bf
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
801017d0:	e8 0b 2c 00 00       	call   801043e0 <acquiresleep>
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
801017ea:	e8 51 2c 00 00       	call   80104440 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017f6:	e8 a5 2d 00 00       	call   801045a0 <acquire>
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
80101810:	e9 ab 2e 00 00       	jmp    801046c0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 0a 11 80       	push   $0x80110a00
80101820:	e8 7b 2d 00 00       	call   801045a0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010182f:	e8 8c 2e 00 00       	call   801046c0 <release>
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
80101a17:	e8 b4 2d 00 00       	call   801047d0 <memmove>
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
80101b13:	e8 b8 2c 00 00       	call   801047d0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 b0 14 00 00       	call   80102fd0 <log_write>
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
80101bae:	e8 8d 2c 00 00       	call   80104840 <strncmp>
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
80101c0d:	e8 2e 2c 00 00       	call   80104840 <strncmp>
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
80101c52:	68 d9 74 10 80       	push   $0x801074d9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 c7 74 10 80       	push   $0x801074c7
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
80101c89:	e8 d2 1d 00 00       	call   80103a60 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 0a 11 80       	push   $0x80110a00
80101c99:	e8 02 29 00 00       	call   801045a0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca9:	e8 12 2a 00 00       	call   801046c0 <release>
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
80101d05:	e8 c6 2a 00 00       	call   801047d0 <memmove>
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
80101d98:	e8 33 2a 00 00       	call   801047d0 <memmove>
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
80101e8d:	e8 0e 2a 00 00       	call   801048a0 <strncpy>
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
80101ecb:	68 e8 74 10 80       	push   $0x801074e8
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 26 7b 10 80       	push   $0x80107b26
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
80101feb:	68 54 75 10 80       	push   $0x80107554
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 4b 75 10 80       	push   $0x8010754b
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 66 75 10 80       	push   $0x80107566
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 8b 24 00 00       	call   801044b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 40 2d 12 80       	mov    0x80122d40,%eax
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
8010209e:	e8 fd 24 00 00       	call   801045a0 <acquire>

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
80102101:	e8 fa 20 00 00       	call   80104200 <wakeup>

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
8010211f:	e8 9c 25 00 00       	call   801046c0 <release>

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
8010213e:	e8 3d 23 00 00       	call   80104480 <holdingsleep>
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
80102178:	e8 23 24 00 00       	call   801045a0 <acquire>

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
801021c9:	e8 82 1e 00 00       	call   80104050 <sleep>
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
801021e6:	e9 d5 24 00 00       	jmp    801046c0 <release>
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
8010220a:	68 80 75 10 80       	push   $0x80107580
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 6a 75 10 80       	push   $0x8010756a
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 95 75 10 80       	push   $0x80107595
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
8010225d:	0f b6 15 a0 27 12 80 	movzbl 0x801227a0,%edx
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
80102277:	68 b4 75 10 80       	push   $0x801075b4
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
80102330:	0f 85 7c 00 00 00    	jne    801023b2 <kfree+0x92>
80102336:	81 fb e8 54 12 80    	cmp    $0x801254e8,%ebx
8010233c:	72 74                	jb     801023b2 <kfree+0x92>
8010233e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102344:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102349:	77 67                	ja     801023b2 <kfree+0x92>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010234b:	83 ec 04             	sub    $0x4,%esp
8010234e:	68 00 10 00 00       	push   $0x1000
80102353:	6a 01                	push   $0x1
80102355:	53                   	push   %ebx
80102356:	e8 c5 23 00 00       	call   80104720 <memset>

  if(kmem.use_lock)
8010235b:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	85 d2                	test   %edx,%edx
80102366:	75 38                	jne    801023a0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102368:	a1 98 26 11 80       	mov    0x80112698,%eax
8010236d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  free_frame_cnt++;
  if(kmem.use_lock)
8010236f:	a1 94 26 11 80       	mov    0x80112694,%eax
  free_frame_cnt++;
80102374:	83 05 b4 a5 10 80 01 	addl   $0x1,0x8010a5b4
  kmem.freelist = r;
8010237b:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102381:	85 c0                	test   %eax,%eax
80102383:	75 0b                	jne    80102390 <kfree+0x70>
    release(&kmem.lock);
}
80102385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102388:	c9                   	leave  
80102389:	c3                   	ret    
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102390:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239a:	c9                   	leave  
    release(&kmem.lock);
8010239b:	e9 20 23 00 00       	jmp    801046c0 <release>
    acquire(&kmem.lock);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 60 26 11 80       	push   $0x80112660
801023a8:	e8 f3 21 00 00       	call   801045a0 <acquire>
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	eb b6                	jmp    80102368 <kfree+0x48>
    panic("kfree");
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 e6 75 10 80       	push   $0x801075e6
801023ba:	e8 d1 df ff ff       	call   80100390 <panic>
801023bf:	90                   	nop

801023c0 <freerange>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801023d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dd:	39 de                	cmp    %ebx,%esi
801023df:	72 23                	jb     80102404 <freerange+0x44>
801023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801023f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023f7:	50                   	push   %eax
801023f8:	e8 23 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	39 f3                	cmp    %esi,%ebx
80102402:	76 e4                	jbe    801023e8 <freerange+0x28>
}
80102404:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102407:	5b                   	pop    %ebx
80102408:	5e                   	pop    %esi
80102409:	5d                   	pop    %ebp
8010240a:	c3                   	ret    
8010240b:	90                   	nop
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <kinit1>:
{
80102410:	55                   	push   %ebp
  for(int i = 0 ; i < 65540; i++){
80102411:	31 c0                	xor    %eax,%eax
{
80102413:	89 e5                	mov    %esp,%ebp
80102415:	56                   	push   %esi
80102416:	53                   	push   %ebx
80102417:	8b 75 0c             	mov    0xc(%ebp),%esi
8010241a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    refer[i] = (char)0;
80102420:	c6 80 a0 26 11 80 00 	movb   $0x0,-0x7feed960(%eax)
  for(int i = 0 ; i < 65540; i++){
80102427:	83 c0 01             	add    $0x1,%eax
8010242a:	3d 04 00 01 00       	cmp    $0x10004,%eax
8010242f:	75 ef                	jne    80102420 <kinit1+0x10>
  initlock(&kmem.lock, "kmem");
80102431:	83 ec 08             	sub    $0x8,%esp
80102434:	68 ec 75 10 80       	push   $0x801075ec
80102439:	68 60 26 11 80       	push   $0x80112660
8010243e:	e8 6d 20 00 00       	call   801044b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102443:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102446:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102449:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102450:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102453:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102459:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010245f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102465:	39 de                	cmp    %ebx,%esi
80102467:	72 23                	jb     8010248c <kinit1+0x7c>
80102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010247f:	50                   	push   %eax
80102480:	e8 9b fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x60>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 43 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024e4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102500:	a1 94 26 11 80       	mov    0x80112694,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 27                	jne    80102530 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r){
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 16                	je     80102528 <kalloc+0x28>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
    free_frame_cnt--;
80102514:	83 2d b4 a5 10 80 01 	subl   $0x1,0x8010a5b4
    kmem.freelist = r->next;
8010251b:	89 15 98 26 11 80    	mov    %edx,0x80112698
80102521:	c3                   	ret    
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102528:	f3 c3                	repz ret 
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102536:	68 60 26 11 80       	push   $0x80112660
8010253b:	e8 60 20 00 00       	call   801045a0 <acquire>
  r = kmem.freelist;
80102540:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r){
80102545:	83 c4 10             	add    $0x10,%esp
80102548:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010254e:	85 c0                	test   %eax,%eax
80102550:	74 0f                	je     80102561 <kalloc+0x61>
    kmem.freelist = r->next;
80102552:	8b 08                	mov    (%eax),%ecx
    free_frame_cnt--;
80102554:	83 2d b4 a5 10 80 01 	subl   $0x1,0x8010a5b4
    kmem.freelist = r->next;
8010255b:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
80102561:	85 d2                	test   %edx,%edx
80102563:	74 16                	je     8010257b <kalloc+0x7b>
    release(&kmem.lock);
80102565:	83 ec 0c             	sub    $0xc,%esp
80102568:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010256b:	68 60 26 11 80       	push   $0x80112660
80102570:	e8 4b 21 00 00       	call   801046c0 <release>
  return (char*)r;
80102575:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102578:	83 c4 10             	add    $0x10,%esp
}
8010257b:	c9                   	leave  
8010257c:	c3                   	ret    
8010257d:	8d 76 00             	lea    0x0(%esi),%esi

80102580 <kaddRefer>:
// -----------------------------------------------------------------------------------------------------------1
//int kcheckPage(uint pa)
//int kaddRefer(uint pa)
//int kfreeRefer(uint pa)
// Add the reference number of a page
int kaddRefer(uint pa){
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	83 ec 08             	sub    $0x8,%esp
  if(kmem.use_lock)
80102586:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010258c:	85 d2                	test   %edx,%edx
8010258e:	75 18                	jne    801025a8 <kaddRefer+0x28>
    acquire(&kmem.lock);
  pa = (pa >> 12);
80102590:	8b 45 08             	mov    0x8(%ebp),%eax
80102593:	c1 e8 0c             	shr    $0xc,%eax
  refer[pa]++;
80102596:	80 80 a0 26 11 80 01 	addb   $0x1,-0x7feed960(%eax)
    // cprintf("the ++ number of %d is %d\n",pa,refer[pa]);
    release(&kmem.lock);
  }
    
  return 1;
}
8010259d:	b8 01 00 00 00       	mov    $0x1,%eax
801025a2:	c9                   	leave  
801025a3:	c3                   	ret    
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	68 60 26 11 80       	push   $0x80112660
801025b0:	e8 eb 1f 00 00       	call   801045a0 <acquire>
  pa = (pa >> 12);
801025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  if(kmem.use_lock){
801025b8:	83 c4 10             	add    $0x10,%esp
  pa = (pa >> 12);
801025bb:	c1 e8 0c             	shr    $0xc,%eax
  refer[pa]++;
801025be:	80 80 a0 26 11 80 01 	addb   $0x1,-0x7feed960(%eax)
  if(kmem.use_lock){
801025c5:	a1 94 26 11 80       	mov    0x80112694,%eax
801025ca:	85 c0                	test   %eax,%eax
801025cc:	74 cf                	je     8010259d <kaddRefer+0x1d>
    release(&kmem.lock);
801025ce:	83 ec 0c             	sub    $0xc,%esp
801025d1:	68 60 26 11 80       	push   $0x80112660
801025d6:	e8 e5 20 00 00       	call   801046c0 <release>
801025db:	83 c4 10             	add    $0x10,%esp
}
801025de:	b8 01 00 00 00       	mov    $0x1,%eax
801025e3:	c9                   	leave  
801025e4:	c3                   	ret    
801025e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025f0 <kcheckPage>:
  
  return kcheckPage(pa);
}

// Check if the reference number of page is zero, which means the page should be released.
int kcheckPage(uint pa){
801025f0:	55                   	push   %ebp
  if(kmem.use_lock)
801025f1:	a1 94 26 11 80       	mov    0x80112694,%eax
int kcheckPage(uint pa){
801025f6:	89 e5                	mov    %esp,%ebp
801025f8:	56                   	push   %esi
801025f9:	53                   	push   %ebx
801025fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025fd:	89 de                	mov    %ebx,%esi
801025ff:	c1 ee 0c             	shr    $0xc,%esi
  if(kmem.use_lock)
80102602:	85 c0                	test   %eax,%eax
80102604:	75 3a                	jne    80102640 <kcheckPage+0x50>
    acquire(&kmem.lock);
  if(refer[pa >> 12] <= 0){
80102606:	80 be a0 26 11 80 00 	cmpb   $0x0,-0x7feed960(%esi)
8010260d:	7e 11                	jle    80102620 <kcheckPage+0x30>
    return 1;
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return 0;
}
8010260f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102612:	5b                   	pop    %ebx
80102613:	5e                   	pop    %esi
80102614:	5d                   	pop    %ebp
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    char *v = P2V(pa);
80102620:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    kfree(v);
80102626:	83 ec 0c             	sub    $0xc,%esp
80102629:	53                   	push   %ebx
8010262a:	e8 f1 fc ff ff       	call   80102320 <kfree>
8010262f:	83 c4 10             	add    $0x10,%esp
}
80102632:	8d 65 f8             	lea    -0x8(%ebp),%esp
    kfree(v);
80102635:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010263a:	5b                   	pop    %ebx
8010263b:	5e                   	pop    %esi
8010263c:	5d                   	pop    %ebp
8010263d:	c3                   	ret    
8010263e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102640:	83 ec 0c             	sub    $0xc,%esp
80102643:	68 60 26 11 80       	push   $0x80112660
80102648:	e8 53 1f 00 00       	call   801045a0 <acquire>
  if(refer[pa >> 12] <= 0){
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	80 be a0 26 11 80 00 	cmpb   $0x0,-0x7feed960(%esi)
80102657:	7e 27                	jle    80102680 <kcheckPage+0x90>
80102659:	a1 94 26 11 80       	mov    0x80112694,%eax
  if(kmem.use_lock)
8010265e:	85 c0                	test   %eax,%eax
80102660:	74 ad                	je     8010260f <kcheckPage+0x1f>
    release(&kmem.lock);
80102662:	83 ec 0c             	sub    $0xc,%esp
80102665:	68 60 26 11 80       	push   $0x80112660
8010266a:	e8 51 20 00 00       	call   801046c0 <release>
8010266f:	83 c4 10             	add    $0x10,%esp
}
80102672:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
80102675:	31 c0                	xor    %eax,%eax
}
80102677:	5b                   	pop    %ebx
80102678:	5e                   	pop    %esi
80102679:	5d                   	pop    %ebp
8010267a:	c3                   	ret    
8010267b:	90                   	nop
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(kmem.use_lock)
80102680:	a1 94 26 11 80       	mov    0x80112694,%eax
    char *v = P2V(pa);
80102685:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    if(kmem.use_lock)
8010268b:	85 c0                	test   %eax,%eax
8010268d:	74 97                	je     80102626 <kcheckPage+0x36>
      release(&kmem.lock);
8010268f:	83 ec 0c             	sub    $0xc,%esp
80102692:	68 60 26 11 80       	push   $0x80112660
80102697:	e8 24 20 00 00       	call   801046c0 <release>
8010269c:	83 c4 10             	add    $0x10,%esp
8010269f:	eb 85                	jmp    80102626 <kcheckPage+0x36>
801026a1:	eb 0d                	jmp    801026b0 <kfreeRefer>
801026a3:	90                   	nop
801026a4:	90                   	nop
801026a5:	90                   	nop
801026a6:	90                   	nop
801026a7:	90                   	nop
801026a8:	90                   	nop
801026a9:	90                   	nop
801026aa:	90                   	nop
801026ab:	90                   	nop
801026ac:	90                   	nop
801026ad:	90                   	nop
801026ae:	90                   	nop
801026af:	90                   	nop

801026b0 <kfreeRefer>:
int kfreeRefer(uint pa){
801026b0:	55                   	push   %ebp
  if(kmem.use_lock)
801026b1:	8b 15 94 26 11 80    	mov    0x80112694,%edx
int kfreeRefer(uint pa){
801026b7:	89 e5                	mov    %esp,%ebp
801026b9:	56                   	push   %esi
801026ba:	53                   	push   %ebx
801026bb:	8b 75 08             	mov    0x8(%ebp),%esi
  uint paa = (pa >> 12);
801026be:	89 f3                	mov    %esi,%ebx
801026c0:	c1 eb 0c             	shr    $0xc,%ebx
  if(kmem.use_lock)
801026c3:	85 d2                	test   %edx,%edx
801026c5:	75 19                	jne    801026e0 <kfreeRefer+0x30>
  refer[paa]--;
801026c7:	80 ab a0 26 11 80 01 	subb   $0x1,-0x7feed960(%ebx)
  return kcheckPage(pa);
801026ce:	89 75 08             	mov    %esi,0x8(%ebp)
}
801026d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d4:	5b                   	pop    %ebx
801026d5:	5e                   	pop    %esi
801026d6:	5d                   	pop    %ebp
  return kcheckPage(pa);
801026d7:	e9 14 ff ff ff       	jmp    801025f0 <kcheckPage>
801026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 60 26 11 80       	push   $0x80112660
801026e8:	e8 b3 1e 00 00       	call   801045a0 <acquire>
  if(kmem.use_lock){
801026ed:	a1 94 26 11 80       	mov    0x80112694,%eax
  refer[paa]--;
801026f2:	80 ab a0 26 11 80 01 	subb   $0x1,-0x7feed960(%ebx)
  if(kmem.use_lock){
801026f9:	83 c4 10             	add    $0x10,%esp
801026fc:	85 c0                	test   %eax,%eax
801026fe:	74 ce                	je     801026ce <kfreeRefer+0x1e>
    release(&kmem.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 60 26 11 80       	push   $0x80112660
80102708:	e8 b3 1f 00 00       	call   801046c0 <release>
  return kcheckPage(pa);
8010270d:	89 75 08             	mov    %esi,0x8(%ebp)
    release(&kmem.lock);
80102710:	83 c4 10             	add    $0x10,%esp
}
80102713:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102716:	5b                   	pop    %ebx
80102717:	5e                   	pop    %esi
80102718:	5d                   	pop    %ebp
  return kcheckPage(pa);
80102719:	e9 d2 fe ff ff       	jmp    801025f0 <kcheckPage>
8010271e:	66 90                	xchg   %ax,%ax

80102720 <kshowRefer>:

int kshowRefer(uint pa){
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	53                   	push   %ebx
80102724:	83 ec 04             	sub    $0x4,%esp
  pa = (pa >> 12);
80102727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
8010272a:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  pa = (pa >> 12);
80102730:	c1 eb 0c             	shr    $0xc,%ebx
  if(kmem.use_lock)
80102733:	85 d2                	test   %edx,%edx
80102735:	75 41                	jne    80102778 <kshowRefer+0x58>
    acquire(&kmem.lock);
  cprintf("the reference number of %d is %d\n",pa,refer[pa]);
80102737:	0f be 83 a0 26 11 80 	movsbl -0x7feed960(%ebx),%eax
8010273e:	83 ec 04             	sub    $0x4,%esp
80102741:	50                   	push   %eax
80102742:	53                   	push   %ebx
80102743:	68 f4 75 10 80       	push   $0x801075f4
80102748:	e8 13 df ff ff       	call   80100660 <cprintf>
  if(kmem.use_lock)
8010274d:	a1 94 26 11 80       	mov    0x80112694,%eax
80102752:	83 c4 10             	add    $0x10,%esp
80102755:	85 c0                	test   %eax,%eax
80102757:	74 10                	je     80102769 <kshowRefer+0x49>
    release(&kmem.lock);
80102759:	83 ec 0c             	sub    $0xc,%esp
8010275c:	68 60 26 11 80       	push   $0x80112660
80102761:	e8 5a 1f 00 00       	call   801046c0 <release>
80102766:	83 c4 10             	add    $0x10,%esp
  return 1;
}
80102769:	b8 01 00 00 00       	mov    $0x1,%eax
8010276e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102771:	c9                   	leave  
80102772:	c3                   	ret    
80102773:	90                   	nop
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102778:	83 ec 0c             	sub    $0xc,%esp
8010277b:	68 60 26 11 80       	push   $0x80112660
80102780:	e8 1b 1e 00 00       	call   801045a0 <acquire>
80102785:	83 c4 10             	add    $0x10,%esp
80102788:	eb ad                	jmp    80102737 <kshowRefer+0x17>
8010278a:	66 90                	xchg   %ax,%ax
8010278c:	66 90                	xchg   %ax,%ax
8010278e:	66 90                	xchg   %ax,%ax

80102790 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102790:	ba 64 00 00 00       	mov    $0x64,%edx
80102795:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102796:	a8 01                	test   $0x1,%al
80102798:	0f 84 c2 00 00 00    	je     80102860 <kbdgetc+0xd0>
8010279e:	ba 60 00 00 00       	mov    $0x60,%edx
801027a3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801027a4:	0f b6 d0             	movzbl %al,%edx
801027a7:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx

  if(data == 0xE0){
801027ad:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801027b3:	0f 84 7f 00 00 00    	je     80102838 <kbdgetc+0xa8>
{
801027b9:	55                   	push   %ebp
801027ba:	89 e5                	mov    %esp,%ebp
801027bc:	53                   	push   %ebx
801027bd:	89 cb                	mov    %ecx,%ebx
801027bf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801027c2:	84 c0                	test   %al,%al
801027c4:	78 4a                	js     80102810 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027c6:	85 db                	test   %ebx,%ebx
801027c8:	74 09                	je     801027d3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027ca:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027cd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801027d0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801027d3:	0f b6 82 40 77 10 80 	movzbl -0x7fef88c0(%edx),%eax
801027da:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801027dc:	0f b6 82 40 76 10 80 	movzbl -0x7fef89c0(%edx),%eax
801027e3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027e5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801027e7:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
  c = charcode[shift & (CTL | SHIFT)][data];
801027ed:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027f0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027f3:	8b 04 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%eax
801027fa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801027fe:	74 31                	je     80102831 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102800:	8d 50 9f             	lea    -0x61(%eax),%edx
80102803:	83 fa 19             	cmp    $0x19,%edx
80102806:	77 40                	ja     80102848 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102808:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010280b:	5b                   	pop    %ebx
8010280c:	5d                   	pop    %ebp
8010280d:	c3                   	ret    
8010280e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102810:	83 e0 7f             	and    $0x7f,%eax
80102813:	85 db                	test   %ebx,%ebx
80102815:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102818:	0f b6 82 40 77 10 80 	movzbl -0x7fef88c0(%edx),%eax
8010281f:	83 c8 40             	or     $0x40,%eax
80102822:	0f b6 c0             	movzbl %al,%eax
80102825:	f7 d0                	not    %eax
80102827:	21 c1                	and    %eax,%ecx
    return 0;
80102829:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010282b:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
}
80102831:	5b                   	pop    %ebx
80102832:	5d                   	pop    %ebp
80102833:	c3                   	ret    
80102834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102838:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010283b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010283d:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
    return 0;
80102843:	c3                   	ret    
80102844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102848:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010284b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010284e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010284f:	83 f9 1a             	cmp    $0x1a,%ecx
80102852:	0f 42 c2             	cmovb  %edx,%eax
}
80102855:	5d                   	pop    %ebp
80102856:	c3                   	ret    
80102857:	89 f6                	mov    %esi,%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102865:	c3                   	ret    
80102866:	8d 76 00             	lea    0x0(%esi),%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <kbdintr>:

void
kbdintr(void)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102876:	68 90 27 10 80       	push   $0x80102790
8010287b:	e8 90 df ff ff       	call   80100810 <consoleintr>
}
80102880:	83 c4 10             	add    $0x10,%esp
80102883:	c9                   	leave  
80102884:	c3                   	ret    
80102885:	66 90                	xchg   %ax,%ax
80102887:	66 90                	xchg   %ax,%ax
80102889:	66 90                	xchg   %ax,%ax
8010288b:	66 90                	xchg   %ax,%ax
8010288d:	66 90                	xchg   %ax,%ax
8010288f:	90                   	nop

80102890 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102890:	a1 a4 26 12 80       	mov    0x801226a4,%eax
{
80102895:	55                   	push   %ebp
80102896:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102898:	85 c0                	test   %eax,%eax
8010289a:	0f 84 c8 00 00 00    	je     80102968 <lapicinit+0xd8>
  lapic[index] = value;
801028a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ee:	8b 50 30             	mov    0x30(%eax),%edx
801028f1:	c1 ea 10             	shr    $0x10,%edx
801028f4:	80 fa 03             	cmp    $0x3,%dl
801028f7:	77 77                	ja     80102970 <lapicinit+0xe0>
  lapic[index] = value;
801028f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102906:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010290d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102910:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102913:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010291a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102920:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102927:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102934:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102941:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
80102947:	89 f6                	mov    %esi,%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102950:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102956:	80 e6 10             	and    $0x10,%dh
80102959:	75 f5                	jne    80102950 <lapicinit+0xc0>
  lapic[index] = value;
8010295b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102962:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102965:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102968:	5d                   	pop    %ebp
80102969:	c3                   	ret    
8010296a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102970:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102977:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010297a:	8b 50 20             	mov    0x20(%eax),%edx
8010297d:	e9 77 ff ff ff       	jmp    801028f9 <lapicinit+0x69>
80102982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102990:	8b 15 a4 26 12 80    	mov    0x801226a4,%edx
{
80102996:	55                   	push   %ebp
80102997:	31 c0                	xor    %eax,%eax
80102999:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010299b:	85 d2                	test   %edx,%edx
8010299d:	74 06                	je     801029a5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010299f:	8b 42 20             	mov    0x20(%edx),%eax
801029a2:	c1 e8 18             	shr    $0x18,%eax
}
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    
801029a7:	89 f6                	mov    %esi,%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029b0:	a1 a4 26 12 80       	mov    0x801226a4,%eax
{
801029b5:	55                   	push   %ebp
801029b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801029b8:	85 c0                	test   %eax,%eax
801029ba:	74 0d                	je     801029c9 <lapiceoi+0x19>
  lapic[index] = value;
801029bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029c9:	5d                   	pop    %ebp
801029ca:	c3                   	ret    
801029cb:	90                   	nop
801029cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
}
801029d3:	5d                   	pop    %ebp
801029d4:	c3                   	ret    
801029d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	53                   	push   %ebx
801029ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029f4:	ee                   	out    %al,(%dx)
801029f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029fa:	ba 71 00 00 00       	mov    $0x71,%edx
801029ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a00:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a0d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a10:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102a13:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a1e:	a1 a4 26 12 80       	mov    0x801226a4,%eax
80102a23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a6a:	5b                   	pop    %ebx
80102a6b:	5d                   	pop    %ebp
80102a6c:	c3                   	ret    
80102a6d:	8d 76 00             	lea    0x0(%esi),%esi

80102a70 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a70:	55                   	push   %ebp
80102a71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a76:	ba 70 00 00 00       	mov    $0x70,%edx
80102a7b:	89 e5                	mov    %esp,%ebp
80102a7d:	57                   	push   %edi
80102a7e:	56                   	push   %esi
80102a7f:	53                   	push   %ebx
80102a80:	83 ec 4c             	sub    $0x4c,%esp
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	ba 71 00 00 00       	mov    $0x71,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a95:	8d 76 00             	lea    0x0(%esi),%esi
80102a98:	31 c0                	xor    %eax,%eax
80102a9a:	89 da                	mov    %ebx,%edx
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102aa2:	89 ca                	mov    %ecx,%edx
80102aa4:	ec                   	in     (%dx),%al
80102aa5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa8:	89 da                	mov    %ebx,%edx
80102aaa:	b8 02 00 00 00       	mov    $0x2,%eax
80102aaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	89 ca                	mov    %ecx,%edx
80102ab2:	ec                   	in     (%dx),%al
80102ab3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab6:	89 da                	mov    %ebx,%edx
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	b8 07 00 00 00       	mov    $0x7,%eax
80102acb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acc:	89 ca                	mov    %ecx,%edx
80102ace:	ec                   	in     (%dx),%al
80102acf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad2:	89 da                	mov    %ebx,%edx
80102ad4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ad9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ada:	89 ca                	mov    %ecx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102adf:	89 da                	mov    %ebx,%edx
80102ae1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae7:	89 ca                	mov    %ecx,%edx
80102ae9:	ec                   	in     (%dx),%al
80102aea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aec:	89 da                	mov    %ebx,%edx
80102aee:	b8 0a 00 00 00       	mov    $0xa,%eax
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	89 ca                	mov    %ecx,%edx
80102af6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102af7:	84 c0                	test   %al,%al
80102af9:	78 9d                	js     80102a98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102afb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102aff:	89 fa                	mov    %edi,%edx
80102b01:	0f b6 fa             	movzbl %dl,%edi
80102b04:	89 f2                	mov    %esi,%edx
80102b06:	0f b6 f2             	movzbl %dl,%esi
80102b09:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0c:	89 da                	mov    %ebx,%edx
80102b0e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b11:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b14:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b18:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b1b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b22:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b29:	31 c0                	xor    %eax,%eax
80102b2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2c:	89 ca                	mov    %ecx,%edx
80102b2e:	ec                   	in     (%dx),%al
80102b2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b32:	89 da                	mov    %ebx,%edx
80102b34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b37:	b8 02 00 00 00       	mov    $0x2,%eax
80102b3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3d:	89 ca                	mov    %ecx,%edx
80102b3f:	ec                   	in     (%dx),%al
80102b40:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b43:	89 da                	mov    %ebx,%edx
80102b45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b48:	b8 04 00 00 00       	mov    $0x4,%eax
80102b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	89 ca                	mov    %ecx,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	89 da                	mov    %ebx,%edx
80102b56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b59:	b8 07 00 00 00       	mov    $0x7,%eax
80102b5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5f:	89 ca                	mov    %ecx,%edx
80102b61:	ec                   	in     (%dx),%al
80102b62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b65:	89 da                	mov    %ebx,%edx
80102b67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b70:	89 ca                	mov    %ecx,%edx
80102b72:	ec                   	in     (%dx),%al
80102b73:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b76:	89 da                	mov    %ebx,%edx
80102b78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b80:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b81:	89 ca                	mov    %ecx,%edx
80102b83:	ec                   	in     (%dx),%al
80102b84:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b87:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b8d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b90:	6a 18                	push   $0x18
80102b92:	50                   	push   %eax
80102b93:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b96:	50                   	push   %eax
80102b97:	e8 d4 1b 00 00       	call   80104770 <memcmp>
80102b9c:	83 c4 10             	add    $0x10,%esp
80102b9f:	85 c0                	test   %eax,%eax
80102ba1:	0f 85 f1 fe ff ff    	jne    80102a98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ba7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102bab:	75 78                	jne    80102c25 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bad:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bb0:	89 c2                	mov    %eax,%edx
80102bb2:	83 e0 0f             	and    $0xf,%eax
80102bb5:	c1 ea 04             	shr    $0x4,%edx
80102bb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bbe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bc1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bc4:	89 c2                	mov    %eax,%edx
80102bc6:	83 e0 0f             	and    $0xf,%eax
80102bc9:	c1 ea 04             	shr    $0x4,%edx
80102bcc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bd8:	89 c2                	mov    %eax,%edx
80102bda:	83 e0 0f             	and    $0xf,%eax
80102bdd:	c1 ea 04             	shr    $0x4,%edx
80102be0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102be3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102be9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bec:	89 c2                	mov    %eax,%edx
80102bee:	83 e0 0f             	and    $0xf,%eax
80102bf1:	c1 ea 04             	shr    $0x4,%edx
80102bf4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bfa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c00:	89 c2                	mov    %eax,%edx
80102c02:	83 e0 0f             	and    $0xf,%eax
80102c05:	c1 ea 04             	shr    $0x4,%edx
80102c08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c14:	89 c2                	mov    %eax,%edx
80102c16:	83 e0 0f             	and    $0xf,%eax
80102c19:	c1 ea 04             	shr    $0x4,%edx
80102c1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c22:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c25:	8b 75 08             	mov    0x8(%ebp),%esi
80102c28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c2b:	89 06                	mov    %eax,(%esi)
80102c2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c30:	89 46 04             	mov    %eax,0x4(%esi)
80102c33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c36:	89 46 08             	mov    %eax,0x8(%esi)
80102c39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c3c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c42:	89 46 10             	mov    %eax,0x10(%esi)
80102c45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c48:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c4b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c55:	5b                   	pop    %ebx
80102c56:	5e                   	pop    %esi
80102c57:	5f                   	pop    %edi
80102c58:	5d                   	pop    %ebp
80102c59:	c3                   	ret    
80102c5a:	66 90                	xchg   %ax,%ax
80102c5c:	66 90                	xchg   %ax,%ax
80102c5e:	66 90                	xchg   %ax,%ax

80102c60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c60:	8b 0d 08 27 12 80    	mov    0x80122708,%ecx
80102c66:	85 c9                	test   %ecx,%ecx
80102c68:	0f 8e 8a 00 00 00    	jle    80102cf8 <install_trans+0x98>
{
80102c6e:	55                   	push   %ebp
80102c6f:	89 e5                	mov    %esp,%ebp
80102c71:	57                   	push   %edi
80102c72:	56                   	push   %esi
80102c73:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102c74:	31 db                	xor    %ebx,%ebx
{
80102c76:	83 ec 0c             	sub    $0xc,%esp
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c80:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80102c85:	83 ec 08             	sub    $0x8,%esp
80102c88:	01 d8                	add    %ebx,%eax
80102c8a:	83 c0 01             	add    $0x1,%eax
80102c8d:	50                   	push   %eax
80102c8e:	ff 35 04 27 12 80    	pushl  0x80122704
80102c94:	e8 37 d4 ff ff       	call   801000d0 <bread>
80102c99:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c9b:	58                   	pop    %eax
80102c9c:	5a                   	pop    %edx
80102c9d:	ff 34 9d 0c 27 12 80 	pushl  -0x7fedd8f4(,%ebx,4)
80102ca4:	ff 35 04 27 12 80    	pushl  0x80122704
  for (tail = 0; tail < log.lh.n; tail++) {
80102caa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cad:	e8 1e d4 ff ff       	call   801000d0 <bread>
80102cb2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cb4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102cb7:	83 c4 0c             	add    $0xc,%esp
80102cba:	68 00 02 00 00       	push   $0x200
80102cbf:	50                   	push   %eax
80102cc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc3:	50                   	push   %eax
80102cc4:	e8 07 1b 00 00       	call   801047d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cc9:	89 34 24             	mov    %esi,(%esp)
80102ccc:	e8 cf d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102cd1:	89 3c 24             	mov    %edi,(%esp)
80102cd4:	e8 07 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102cd9:	89 34 24             	mov    %esi,(%esp)
80102cdc:	e8 ff d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce1:	83 c4 10             	add    $0x10,%esp
80102ce4:	39 1d 08 27 12 80    	cmp    %ebx,0x80122708
80102cea:	7f 94                	jg     80102c80 <install_trans+0x20>
  }
}
80102cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cef:	5b                   	pop    %ebx
80102cf0:	5e                   	pop    %esi
80102cf1:	5f                   	pop    %edi
80102cf2:	5d                   	pop    %ebp
80102cf3:	c3                   	ret    
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cf8:	f3 c3                	repz ret 
80102cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	56                   	push   %esi
80102d04:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102d05:	83 ec 08             	sub    $0x8,%esp
80102d08:	ff 35 f4 26 12 80    	pushl  0x801226f4
80102d0e:	ff 35 04 27 12 80    	pushl  0x80122704
80102d14:	e8 b7 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d19:	8b 1d 08 27 12 80    	mov    0x80122708,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d1f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d22:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102d24:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102d26:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d29:	7e 16                	jle    80102d41 <write_head+0x41>
80102d2b:	c1 e3 02             	shl    $0x2,%ebx
80102d2e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102d30:	8b 8a 0c 27 12 80    	mov    -0x7fedd8f4(%edx),%ecx
80102d36:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102d3a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102d3d:	39 da                	cmp    %ebx,%edx
80102d3f:	75 ef                	jne    80102d30 <write_head+0x30>
  }
  bwrite(buf);
80102d41:	83 ec 0c             	sub    $0xc,%esp
80102d44:	56                   	push   %esi
80102d45:	e8 56 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d4a:	89 34 24             	mov    %esi,(%esp)
80102d4d:	e8 8e d4 ff ff       	call   801001e0 <brelse>
}
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d58:	5b                   	pop    %ebx
80102d59:	5e                   	pop    %esi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
80102d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d60 <initlog>:
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	53                   	push   %ebx
80102d64:	83 ec 2c             	sub    $0x2c,%esp
80102d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d6a:	68 40 78 10 80       	push   $0x80107840
80102d6f:	68 c0 26 12 80       	push   $0x801226c0
80102d74:	e8 37 17 00 00       	call   801044b0 <initlock>
  readsb(dev, &sb);
80102d79:	58                   	pop    %eax
80102d7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d7d:	5a                   	pop    %edx
80102d7e:	50                   	push   %eax
80102d7f:	53                   	push   %ebx
80102d80:	e8 4b e6 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102d85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d8b:	59                   	pop    %ecx
  log.dev = dev;
80102d8c:	89 1d 04 27 12 80    	mov    %ebx,0x80122704
  log.size = sb.nlog;
80102d92:	89 15 f8 26 12 80    	mov    %edx,0x801226f8
  log.start = sb.logstart;
80102d98:	a3 f4 26 12 80       	mov    %eax,0x801226f4
  struct buf *buf = bread(log.dev, log.start);
80102d9d:	5a                   	pop    %edx
80102d9e:	50                   	push   %eax
80102d9f:	53                   	push   %ebx
80102da0:	e8 2b d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102da5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102da8:	83 c4 10             	add    $0x10,%esp
80102dab:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102dad:	89 1d 08 27 12 80    	mov    %ebx,0x80122708
  for (i = 0; i < log.lh.n; i++) {
80102db3:	7e 1c                	jle    80102dd1 <initlog+0x71>
80102db5:	c1 e3 02             	shl    $0x2,%ebx
80102db8:	31 d2                	xor    %edx,%edx
80102dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102dc0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102dc4:	83 c2 04             	add    $0x4,%edx
80102dc7:	89 8a 08 27 12 80    	mov    %ecx,-0x7fedd8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102dcd:	39 d3                	cmp    %edx,%ebx
80102dcf:	75 ef                	jne    80102dc0 <initlog+0x60>
  brelse(buf);
80102dd1:	83 ec 0c             	sub    $0xc,%esp
80102dd4:	50                   	push   %eax
80102dd5:	e8 06 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dda:	e8 81 fe ff ff       	call   80102c60 <install_trans>
  log.lh.n = 0;
80102ddf:	c7 05 08 27 12 80 00 	movl   $0x0,0x80122708
80102de6:	00 00 00 
  write_head(); // clear the log
80102de9:	e8 12 ff ff ff       	call   80102d00 <write_head>
}
80102dee:	83 c4 10             	add    $0x10,%esp
80102df1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102df4:	c9                   	leave  
80102df5:	c3                   	ret    
80102df6:	8d 76 00             	lea    0x0(%esi),%esi
80102df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e06:	68 c0 26 12 80       	push   $0x801226c0
80102e0b:	e8 90 17 00 00       	call   801045a0 <acquire>
80102e10:	83 c4 10             	add    $0x10,%esp
80102e13:	eb 18                	jmp    80102e2d <begin_op+0x2d>
80102e15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e18:	83 ec 08             	sub    $0x8,%esp
80102e1b:	68 c0 26 12 80       	push   $0x801226c0
80102e20:	68 c0 26 12 80       	push   $0x801226c0
80102e25:	e8 26 12 00 00       	call   80104050 <sleep>
80102e2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e2d:	a1 00 27 12 80       	mov    0x80122700,%eax
80102e32:	85 c0                	test   %eax,%eax
80102e34:	75 e2                	jne    80102e18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e36:	a1 fc 26 12 80       	mov    0x801226fc,%eax
80102e3b:	8b 15 08 27 12 80    	mov    0x80122708,%edx
80102e41:	83 c0 01             	add    $0x1,%eax
80102e44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e4a:	83 fa 1e             	cmp    $0x1e,%edx
80102e4d:	7f c9                	jg     80102e18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e4f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e52:	a3 fc 26 12 80       	mov    %eax,0x801226fc
      release(&log.lock);
80102e57:	68 c0 26 12 80       	push   $0x801226c0
80102e5c:	e8 5f 18 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102e61:	83 c4 10             	add    $0x10,%esp
80102e64:	c9                   	leave  
80102e65:	c3                   	ret    
80102e66:	8d 76 00             	lea    0x0(%esi),%esi
80102e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	57                   	push   %edi
80102e74:	56                   	push   %esi
80102e75:	53                   	push   %ebx
80102e76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e79:	68 c0 26 12 80       	push   $0x801226c0
80102e7e:	e8 1d 17 00 00       	call   801045a0 <acquire>
  log.outstanding -= 1;
80102e83:	a1 fc 26 12 80       	mov    0x801226fc,%eax
  if(log.committing)
80102e88:	8b 35 00 27 12 80    	mov    0x80122700,%esi
80102e8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e91:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e94:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102e96:	89 1d fc 26 12 80    	mov    %ebx,0x801226fc
  if(log.committing)
80102e9c:	0f 85 1a 01 00 00    	jne    80102fbc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102ea2:	85 db                	test   %ebx,%ebx
80102ea4:	0f 85 ee 00 00 00    	jne    80102f98 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102eaa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ead:	c7 05 00 27 12 80 01 	movl   $0x1,0x80122700
80102eb4:	00 00 00 
  release(&log.lock);
80102eb7:	68 c0 26 12 80       	push   $0x801226c0
80102ebc:	e8 ff 17 00 00       	call   801046c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ec1:	8b 0d 08 27 12 80    	mov    0x80122708,%ecx
80102ec7:	83 c4 10             	add    $0x10,%esp
80102eca:	85 c9                	test   %ecx,%ecx
80102ecc:	0f 8e 85 00 00 00    	jle    80102f57 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ed2:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80102ed7:	83 ec 08             	sub    $0x8,%esp
80102eda:	01 d8                	add    %ebx,%eax
80102edc:	83 c0 01             	add    $0x1,%eax
80102edf:	50                   	push   %eax
80102ee0:	ff 35 04 27 12 80    	pushl  0x80122704
80102ee6:	e8 e5 d1 ff ff       	call   801000d0 <bread>
80102eeb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eed:	58                   	pop    %eax
80102eee:	5a                   	pop    %edx
80102eef:	ff 34 9d 0c 27 12 80 	pushl  -0x7fedd8f4(,%ebx,4)
80102ef6:	ff 35 04 27 12 80    	pushl  0x80122704
  for (tail = 0; tail < log.lh.n; tail++) {
80102efc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eff:	e8 cc d1 ff ff       	call   801000d0 <bread>
80102f04:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f06:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f09:	83 c4 0c             	add    $0xc,%esp
80102f0c:	68 00 02 00 00       	push   $0x200
80102f11:	50                   	push   %eax
80102f12:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f15:	50                   	push   %eax
80102f16:	e8 b5 18 00 00       	call   801047d0 <memmove>
    bwrite(to);  // write the log
80102f1b:	89 34 24             	mov    %esi,(%esp)
80102f1e:	e8 7d d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102f23:	89 3c 24             	mov    %edi,(%esp)
80102f26:	e8 b5 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102f2b:	89 34 24             	mov    %esi,(%esp)
80102f2e:	e8 ad d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	3b 1d 08 27 12 80    	cmp    0x80122708,%ebx
80102f3c:	7c 94                	jl     80102ed2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f3e:	e8 bd fd ff ff       	call   80102d00 <write_head>
    install_trans(); // Now install writes to home locations
80102f43:	e8 18 fd ff ff       	call   80102c60 <install_trans>
    log.lh.n = 0;
80102f48:	c7 05 08 27 12 80 00 	movl   $0x0,0x80122708
80102f4f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f52:	e8 a9 fd ff ff       	call   80102d00 <write_head>
    acquire(&log.lock);
80102f57:	83 ec 0c             	sub    $0xc,%esp
80102f5a:	68 c0 26 12 80       	push   $0x801226c0
80102f5f:	e8 3c 16 00 00       	call   801045a0 <acquire>
    wakeup(&log);
80102f64:	c7 04 24 c0 26 12 80 	movl   $0x801226c0,(%esp)
    log.committing = 0;
80102f6b:	c7 05 00 27 12 80 00 	movl   $0x0,0x80122700
80102f72:	00 00 00 
    wakeup(&log);
80102f75:	e8 86 12 00 00       	call   80104200 <wakeup>
    release(&log.lock);
80102f7a:	c7 04 24 c0 26 12 80 	movl   $0x801226c0,(%esp)
80102f81:	e8 3a 17 00 00       	call   801046c0 <release>
80102f86:	83 c4 10             	add    $0x10,%esp
}
80102f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8c:	5b                   	pop    %ebx
80102f8d:	5e                   	pop    %esi
80102f8e:	5f                   	pop    %edi
80102f8f:	5d                   	pop    %ebp
80102f90:	c3                   	ret    
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102f98:	83 ec 0c             	sub    $0xc,%esp
80102f9b:	68 c0 26 12 80       	push   $0x801226c0
80102fa0:	e8 5b 12 00 00       	call   80104200 <wakeup>
  release(&log.lock);
80102fa5:	c7 04 24 c0 26 12 80 	movl   $0x801226c0,(%esp)
80102fac:	e8 0f 17 00 00       	call   801046c0 <release>
80102fb1:	83 c4 10             	add    $0x10,%esp
}
80102fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fb7:	5b                   	pop    %ebx
80102fb8:	5e                   	pop    %esi
80102fb9:	5f                   	pop    %edi
80102fba:	5d                   	pop    %ebp
80102fbb:	c3                   	ret    
    panic("log.committing");
80102fbc:	83 ec 0c             	sub    $0xc,%esp
80102fbf:	68 44 78 10 80       	push   $0x80107844
80102fc4:	e8 c7 d3 ff ff       	call   80100390 <panic>
80102fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fd7:	8b 15 08 27 12 80    	mov    0x80122708,%edx
{
80102fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fe0:	83 fa 1d             	cmp    $0x1d,%edx
80102fe3:	0f 8f 9d 00 00 00    	jg     80103086 <log_write+0xb6>
80102fe9:	a1 f8 26 12 80       	mov    0x801226f8,%eax
80102fee:	83 e8 01             	sub    $0x1,%eax
80102ff1:	39 c2                	cmp    %eax,%edx
80102ff3:	0f 8d 8d 00 00 00    	jge    80103086 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ff9:	a1 fc 26 12 80       	mov    0x801226fc,%eax
80102ffe:	85 c0                	test   %eax,%eax
80103000:	0f 8e 8d 00 00 00    	jle    80103093 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103006:	83 ec 0c             	sub    $0xc,%esp
80103009:	68 c0 26 12 80       	push   $0x801226c0
8010300e:	e8 8d 15 00 00       	call   801045a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103013:	8b 0d 08 27 12 80    	mov    0x80122708,%ecx
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	83 f9 00             	cmp    $0x0,%ecx
8010301f:	7e 57                	jle    80103078 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103021:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103024:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103026:	3b 15 0c 27 12 80    	cmp    0x8012270c,%edx
8010302c:	75 0b                	jne    80103039 <log_write+0x69>
8010302e:	eb 38                	jmp    80103068 <log_write+0x98>
80103030:	39 14 85 0c 27 12 80 	cmp    %edx,-0x7fedd8f4(,%eax,4)
80103037:	74 2f                	je     80103068 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103039:	83 c0 01             	add    $0x1,%eax
8010303c:	39 c1                	cmp    %eax,%ecx
8010303e:	75 f0                	jne    80103030 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103040:	89 14 85 0c 27 12 80 	mov    %edx,-0x7fedd8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103047:	83 c0 01             	add    $0x1,%eax
8010304a:	a3 08 27 12 80       	mov    %eax,0x80122708
  b->flags |= B_DIRTY; // prevent eviction
8010304f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103052:	c7 45 08 c0 26 12 80 	movl   $0x801226c0,0x8(%ebp)
}
80103059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010305c:	c9                   	leave  
  release(&log.lock);
8010305d:	e9 5e 16 00 00       	jmp    801046c0 <release>
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103068:	89 14 85 0c 27 12 80 	mov    %edx,-0x7fedd8f4(,%eax,4)
8010306f:	eb de                	jmp    8010304f <log_write+0x7f>
80103071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103078:	8b 43 08             	mov    0x8(%ebx),%eax
8010307b:	a3 0c 27 12 80       	mov    %eax,0x8012270c
  if (i == log.lh.n)
80103080:	75 cd                	jne    8010304f <log_write+0x7f>
80103082:	31 c0                	xor    %eax,%eax
80103084:	eb c1                	jmp    80103047 <log_write+0x77>
    panic("too big a transaction");
80103086:	83 ec 0c             	sub    $0xc,%esp
80103089:	68 53 78 10 80       	push   $0x80107853
8010308e:	e8 fd d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103093:	83 ec 0c             	sub    $0xc,%esp
80103096:	68 69 78 10 80       	push   $0x80107869
8010309b:	e8 f0 d2 ff ff       	call   80100390 <panic>

801030a0 <mpmain>:

extern int free_frame_cnt;
// Common CPU setup code.
static void
mpmain(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030a7:	e8 94 09 00 00       	call   80103a40 <cpuid>
801030ac:	89 c3                	mov    %eax,%ebx
801030ae:	e8 8d 09 00 00       	call   80103a40 <cpuid>
801030b3:	83 ec 04             	sub    $0x4,%esp
801030b6:	53                   	push   %ebx
801030b7:	50                   	push   %eax
801030b8:	68 84 78 10 80       	push   $0x80107884
801030bd:	e8 9e d5 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801030c2:	e8 09 29 00 00       	call   801059d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030c7:	e8 f4 08 00 00       	call   801039c0 <mycpu>
801030cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ce:	b8 01 00 00 00       	mov    $0x1,%eax
801030d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  cprintf("number of free frames: %d \n",free_frame_cnt);
801030da:	58                   	pop    %eax
801030db:	5a                   	pop    %edx
801030dc:	ff 35 b4 a5 10 80    	pushl  0x8010a5b4
801030e2:	68 98 78 10 80       	push   $0x80107898
801030e7:	e8 74 d5 ff ff       	call   80100660 <cprintf>
  scheduler();     // start running processes
801030ec:	e8 0f 0b 00 00       	call   80103c00 <scheduler>
801030f1:	eb 0d                	jmp    80103100 <mpenter>
801030f3:	90                   	nop
801030f4:	90                   	nop
801030f5:	90                   	nop
801030f6:	90                   	nop
801030f7:	90                   	nop
801030f8:	90                   	nop
801030f9:	90                   	nop
801030fa:	90                   	nop
801030fb:	90                   	nop
801030fc:	90                   	nop
801030fd:	90                   	nop
801030fe:	90                   	nop
801030ff:	90                   	nop

80103100 <mpenter>:
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103106:	e8 c5 39 00 00       	call   80106ad0 <switchkvm>
  seginit();
8010310b:	e8 30 39 00 00       	call   80106a40 <seginit>
  lapicinit();
80103110:	e8 7b f7 ff ff       	call   80102890 <lapicinit>
  mpmain();
80103115:	e8 86 ff ff ff       	call   801030a0 <mpmain>
8010311a:	66 90                	xchg   %ax,%ax
8010311c:	66 90                	xchg   %ax,%ax
8010311e:	66 90                	xchg   %ax,%ax

80103120 <main>:
{
80103120:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103124:	83 e4 f0             	and    $0xfffffff0,%esp
80103127:	ff 71 fc             	pushl  -0x4(%ecx)
8010312a:	55                   	push   %ebp
8010312b:	89 e5                	mov    %esp,%ebp
8010312d:	53                   	push   %ebx
8010312e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010312f:	83 ec 08             	sub    $0x8,%esp
80103132:	68 00 00 40 80       	push   $0x80400000
80103137:	68 e8 54 12 80       	push   $0x801254e8
8010313c:	e8 cf f2 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80103141:	e8 5a 3e 00 00       	call   80106fa0 <kvmalloc>
  mpinit();        // detect other processors
80103146:	e8 75 01 00 00       	call   801032c0 <mpinit>
  lapicinit();     // interrupt controller
8010314b:	e8 40 f7 ff ff       	call   80102890 <lapicinit>
  seginit();       // segment descriptors
80103150:	e8 eb 38 00 00       	call   80106a40 <seginit>
  picinit();       // disable pic
80103155:	e8 46 03 00 00       	call   801034a0 <picinit>
  ioapicinit();    // another interrupt controller
8010315a:	e8 d1 f0 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
8010315f:	e8 5c d8 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103164:	e8 a7 2b 00 00       	call   80105d10 <uartinit>
  pinit();         // process table
80103169:	e8 32 08 00 00       	call   801039a0 <pinit>
  tvinit();        // trap vectors
8010316e:	e8 dd 27 00 00       	call   80105950 <tvinit>
  binit();         // buffer cache
80103173:	e8 c8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103178:	e8 e3 db ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010317d:	e8 8e ee ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103182:	83 c4 0c             	add    $0xc,%esp
80103185:	68 8a 00 00 00       	push   $0x8a
8010318a:	68 8c a4 10 80       	push   $0x8010a48c
8010318f:	68 00 70 00 80       	push   $0x80007000
80103194:	e8 37 16 00 00       	call   801047d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103199:	69 05 40 2d 12 80 b0 	imul   $0xb0,0x80122d40,%eax
801031a0:	00 00 00 
801031a3:	83 c4 10             	add    $0x10,%esp
801031a6:	05 c0 27 12 80       	add    $0x801227c0,%eax
801031ab:	3d c0 27 12 80       	cmp    $0x801227c0,%eax
801031b0:	76 71                	jbe    80103223 <main+0x103>
801031b2:	bb c0 27 12 80       	mov    $0x801227c0,%ebx
801031b7:	89 f6                	mov    %esi,%esi
801031b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801031c0:	e8 fb 07 00 00       	call   801039c0 <mycpu>
801031c5:	39 d8                	cmp    %ebx,%eax
801031c7:	74 41                	je     8010320a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031c9:	e8 32 f3 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ce:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801031d3:	c7 05 f8 6f 00 80 00 	movl   $0x80103100,0x80006ff8
801031da:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031dd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801031e4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031e7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801031ec:	0f b6 03             	movzbl (%ebx),%eax
801031ef:	83 ec 08             	sub    $0x8,%esp
801031f2:	68 00 70 00 00       	push   $0x7000
801031f7:	50                   	push   %eax
801031f8:	e8 e3 f7 ff ff       	call   801029e0 <lapicstartap>
801031fd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103200:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103206:	85 c0                	test   %eax,%eax
80103208:	74 f6                	je     80103200 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010320a:	69 05 40 2d 12 80 b0 	imul   $0xb0,0x80122d40,%eax
80103211:	00 00 00 
80103214:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010321a:	05 c0 27 12 80       	add    $0x801227c0,%eax
8010321f:	39 c3                	cmp    %eax,%ebx
80103221:	72 9d                	jb     801031c0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103223:	83 ec 08             	sub    $0x8,%esp
80103226:	68 00 00 00 8e       	push   $0x8e000000
8010322b:	68 00 00 40 80       	push   $0x80400000
80103230:	e8 6b f2 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80103235:	e8 56 08 00 00       	call   80103a90 <userinit>
  mpmain();        // finish this processor's setup
8010323a:	e8 61 fe ff ff       	call   801030a0 <mpmain>
8010323f:	90                   	nop

80103240 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103245:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010324b:	53                   	push   %ebx
  e = addr+len;
8010324c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010324f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103252:	39 de                	cmp    %ebx,%esi
80103254:	72 10                	jb     80103266 <mpsearch1+0x26>
80103256:	eb 50                	jmp    801032a8 <mpsearch1+0x68>
80103258:	90                   	nop
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103260:	39 fb                	cmp    %edi,%ebx
80103262:	89 fe                	mov    %edi,%esi
80103264:	76 42                	jbe    801032a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103266:	83 ec 04             	sub    $0x4,%esp
80103269:	8d 7e 10             	lea    0x10(%esi),%edi
8010326c:	6a 04                	push   $0x4
8010326e:	68 b4 78 10 80       	push   $0x801078b4
80103273:	56                   	push   %esi
80103274:	e8 f7 14 00 00       	call   80104770 <memcmp>
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	85 c0                	test   %eax,%eax
8010327e:	75 e0                	jne    80103260 <mpsearch1+0x20>
80103280:	89 f1                	mov    %esi,%ecx
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 11             	movzbl (%ecx),%edx
8010328b:	83 c1 01             	add    $0x1,%ecx
8010328e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103290:	39 f9                	cmp    %edi,%ecx
80103292:	75 f4                	jne    80103288 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103294:	84 c0                	test   %al,%al
80103296:	75 c8                	jne    80103260 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010329b:	89 f0                	mov    %esi,%eax
8010329d:	5b                   	pop    %ebx
8010329e:	5e                   	pop    %esi
8010329f:	5f                   	pop    %edi
801032a0:	5d                   	pop    %ebp
801032a1:	c3                   	ret    
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032ab:	31 f6                	xor    %esi,%esi
}
801032ad:	89 f0                	mov    %esi,%eax
801032af:	5b                   	pop    %ebx
801032b0:	5e                   	pop    %esi
801032b1:	5f                   	pop    %edi
801032b2:	5d                   	pop    %ebp
801032b3:	c3                   	ret    
801032b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801032c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032d7:	c1 e0 08             	shl    $0x8,%eax
801032da:	09 d0                	or     %edx,%eax
801032dc:	c1 e0 04             	shl    $0x4,%eax
801032df:	85 c0                	test   %eax,%eax
801032e1:	75 1b                	jne    801032fe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032f1:	c1 e0 08             	shl    $0x8,%eax
801032f4:	09 d0                	or     %edx,%eax
801032f6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032f9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103303:	e8 38 ff ff ff       	call   80103240 <mpsearch1>
80103308:	85 c0                	test   %eax,%eax
8010330a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010330d:	0f 84 3d 01 00 00    	je     80103450 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103316:	8b 58 04             	mov    0x4(%eax),%ebx
80103319:	85 db                	test   %ebx,%ebx
8010331b:	0f 84 4f 01 00 00    	je     80103470 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103321:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103327:	83 ec 04             	sub    $0x4,%esp
8010332a:	6a 04                	push   $0x4
8010332c:	68 d1 78 10 80       	push   $0x801078d1
80103331:	56                   	push   %esi
80103332:	e8 39 14 00 00       	call   80104770 <memcmp>
80103337:	83 c4 10             	add    $0x10,%esp
8010333a:	85 c0                	test   %eax,%eax
8010333c:	0f 85 2e 01 00 00    	jne    80103470 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103342:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103349:	3c 01                	cmp    $0x1,%al
8010334b:	0f 95 c2             	setne  %dl
8010334e:	3c 04                	cmp    $0x4,%al
80103350:	0f 95 c0             	setne  %al
80103353:	20 c2                	and    %al,%dl
80103355:	0f 85 15 01 00 00    	jne    80103470 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010335b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103362:	66 85 ff             	test   %di,%di
80103365:	74 1a                	je     80103381 <mpinit+0xc1>
80103367:	89 f0                	mov    %esi,%eax
80103369:	01 f7                	add    %esi,%edi
  sum = 0;
8010336b:	31 d2                	xor    %edx,%edx
8010336d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103370:	0f b6 08             	movzbl (%eax),%ecx
80103373:	83 c0 01             	add    $0x1,%eax
80103376:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103378:	39 c7                	cmp    %eax,%edi
8010337a:	75 f4                	jne    80103370 <mpinit+0xb0>
8010337c:	84 d2                	test   %dl,%dl
8010337e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103381:	85 f6                	test   %esi,%esi
80103383:	0f 84 e7 00 00 00    	je     80103470 <mpinit+0x1b0>
80103389:	84 d2                	test   %dl,%dl
8010338b:	0f 85 df 00 00 00    	jne    80103470 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103391:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103397:	a3 a4 26 12 80       	mov    %eax,0x801226a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010339c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801033a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801033a9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033ae:	01 d6                	add    %edx,%esi
801033b0:	39 c6                	cmp    %eax,%esi
801033b2:	76 23                	jbe    801033d7 <mpinit+0x117>
    switch(*p){
801033b4:	0f b6 10             	movzbl (%eax),%edx
801033b7:	80 fa 04             	cmp    $0x4,%dl
801033ba:	0f 87 ca 00 00 00    	ja     8010348a <mpinit+0x1ca>
801033c0:	ff 24 95 f8 78 10 80 	jmp    *-0x7fef8708(,%edx,4)
801033c7:	89 f6                	mov    %esi,%esi
801033c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033d3:	39 c6                	cmp    %eax,%esi
801033d5:	77 dd                	ja     801033b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033d7:	85 db                	test   %ebx,%ebx
801033d9:	0f 84 9e 00 00 00    	je     8010347d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801033e6:	74 15                	je     801033fd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033e8:	b8 70 00 00 00       	mov    $0x70,%eax
801033ed:	ba 22 00 00 00       	mov    $0x22,%edx
801033f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033f3:	ba 23 00 00 00       	mov    $0x23,%edx
801033f8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033f9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033fc:	ee                   	out    %al,(%dx)
  }
}
801033fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103400:	5b                   	pop    %ebx
80103401:	5e                   	pop    %esi
80103402:	5f                   	pop    %edi
80103403:	5d                   	pop    %ebp
80103404:	c3                   	ret    
80103405:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103408:	8b 0d 40 2d 12 80    	mov    0x80122d40,%ecx
8010340e:	83 f9 07             	cmp    $0x7,%ecx
80103411:	7f 19                	jg     8010342c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103413:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103417:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010341d:	83 c1 01             	add    $0x1,%ecx
80103420:	89 0d 40 2d 12 80    	mov    %ecx,0x80122d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103426:	88 97 c0 27 12 80    	mov    %dl,-0x7fedd840(%edi)
      p += sizeof(struct mpproc);
8010342c:	83 c0 14             	add    $0x14,%eax
      continue;
8010342f:	e9 7c ff ff ff       	jmp    801033b0 <mpinit+0xf0>
80103434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103438:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010343c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010343f:	88 15 a0 27 12 80    	mov    %dl,0x801227a0
      continue;
80103445:	e9 66 ff ff ff       	jmp    801033b0 <mpinit+0xf0>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103450:	ba 00 00 01 00       	mov    $0x10000,%edx
80103455:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010345a:	e8 e1 fd ff ff       	call   80103240 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010345f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103464:	0f 85 a9 fe ff ff    	jne    80103313 <mpinit+0x53>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	68 b9 78 10 80       	push   $0x801078b9
80103478:	e8 13 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010347d:	83 ec 0c             	sub    $0xc,%esp
80103480:	68 d8 78 10 80       	push   $0x801078d8
80103485:	e8 06 cf ff ff       	call   80100390 <panic>
      ismp = 0;
8010348a:	31 db                	xor    %ebx,%ebx
8010348c:	e9 26 ff ff ff       	jmp    801033b7 <mpinit+0xf7>
80103491:	66 90                	xchg   %ax,%ax
80103493:	66 90                	xchg   %ax,%ax
80103495:	66 90                	xchg   %ax,%ax
80103497:	66 90                	xchg   %ax,%ax
80103499:	66 90                	xchg   %ax,%ax
8010349b:	66 90                	xchg   %ax,%ax
8010349d:	66 90                	xchg   %ax,%ax
8010349f:	90                   	nop

801034a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801034a0:	55                   	push   %ebp
801034a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034a6:	ba 21 00 00 00       	mov    $0x21,%edx
801034ab:	89 e5                	mov    %esp,%ebp
801034ad:	ee                   	out    %al,(%dx)
801034ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801034b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034b4:	5d                   	pop    %ebp
801034b5:	c3                   	ret    
801034b6:	66 90                	xchg   %ax,%ax
801034b8:	66 90                	xchg   %ax,%ax
801034ba:	66 90                	xchg   %ax,%ax
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	57                   	push   %edi
801034c4:	56                   	push   %esi
801034c5:	53                   	push   %ebx
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034db:	e8 a0 d8 ff ff       	call   80100d80 <filealloc>
801034e0:	85 c0                	test   %eax,%eax
801034e2:	89 03                	mov    %eax,(%ebx)
801034e4:	74 22                	je     80103508 <pipealloc+0x48>
801034e6:	e8 95 d8 ff ff       	call   80100d80 <filealloc>
801034eb:	85 c0                	test   %eax,%eax
801034ed:	89 06                	mov    %eax,(%esi)
801034ef:	74 3f                	je     80103530 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034f1:	e8 0a f0 ff ff       	call   80102500 <kalloc>
801034f6:	85 c0                	test   %eax,%eax
801034f8:	89 c7                	mov    %eax,%edi
801034fa:	75 54                	jne    80103550 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801034fc:	8b 03                	mov    (%ebx),%eax
801034fe:	85 c0                	test   %eax,%eax
80103500:	75 34                	jne    80103536 <pipealloc+0x76>
80103502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103508:	8b 06                	mov    (%esi),%eax
8010350a:	85 c0                	test   %eax,%eax
8010350c:	74 0c                	je     8010351a <pipealloc+0x5a>
    fileclose(*f1);
8010350e:	83 ec 0c             	sub    $0xc,%esp
80103511:	50                   	push   %eax
80103512:	e8 29 d9 ff ff       	call   80100e40 <fileclose>
80103517:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010351a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010351d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103522:	5b                   	pop    %ebx
80103523:	5e                   	pop    %esi
80103524:	5f                   	pop    %edi
80103525:	5d                   	pop    %ebp
80103526:	c3                   	ret    
80103527:	89 f6                	mov    %esi,%esi
80103529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103530:	8b 03                	mov    (%ebx),%eax
80103532:	85 c0                	test   %eax,%eax
80103534:	74 e4                	je     8010351a <pipealloc+0x5a>
    fileclose(*f0);
80103536:	83 ec 0c             	sub    $0xc,%esp
80103539:	50                   	push   %eax
8010353a:	e8 01 d9 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010353f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103541:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103544:	85 c0                	test   %eax,%eax
80103546:	75 c6                	jne    8010350e <pipealloc+0x4e>
80103548:	eb d0                	jmp    8010351a <pipealloc+0x5a>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103550:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103553:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010355a:	00 00 00 
  p->writeopen = 1;
8010355d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103564:	00 00 00 
  p->nwrite = 0;
80103567:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010356e:	00 00 00 
  p->nread = 0;
80103571:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103578:	00 00 00 
  initlock(&p->lock, "pipe");
8010357b:	68 0c 79 10 80       	push   $0x8010790c
80103580:	50                   	push   %eax
80103581:	e8 2a 0f 00 00       	call   801044b0 <initlock>
  (*f0)->type = FD_PIPE;
80103586:	8b 03                	mov    (%ebx),%eax
  return 0;
80103588:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010358b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103591:	8b 03                	mov    (%ebx),%eax
80103593:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103597:	8b 03                	mov    (%ebx),%eax
80103599:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010359d:	8b 03                	mov    (%ebx),%eax
8010359f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035a2:	8b 06                	mov    (%esi),%eax
801035a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035aa:	8b 06                	mov    (%esi),%eax
801035ac:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035b0:	8b 06                	mov    (%esi),%eax
801035b2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035b6:	8b 06                	mov    (%esi),%eax
801035b8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801035bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035be:	31 c0                	xor    %eax,%eax
}
801035c0:	5b                   	pop    %ebx
801035c1:	5e                   	pop    %esi
801035c2:	5f                   	pop    %edi
801035c3:	5d                   	pop    %ebp
801035c4:	c3                   	ret    
801035c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	56                   	push   %esi
801035d4:	53                   	push   %ebx
801035d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	53                   	push   %ebx
801035df:	e8 bc 0f 00 00       	call   801045a0 <acquire>
  if(writable){
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	85 f6                	test   %esi,%esi
801035e9:	74 45                	je     80103630 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035f1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801035f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035fb:	00 00 00 
    wakeup(&p->nread);
801035fe:	50                   	push   %eax
801035ff:	e8 fc 0b 00 00       	call   80104200 <wakeup>
80103604:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103607:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010360d:	85 d2                	test   %edx,%edx
8010360f:	75 0a                	jne    8010361b <pipeclose+0x4b>
80103611:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103617:	85 c0                	test   %eax,%eax
80103619:	74 35                	je     80103650 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010361b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010361e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103621:	5b                   	pop    %ebx
80103622:	5e                   	pop    %esi
80103623:	5d                   	pop    %ebp
    release(&p->lock);
80103624:	e9 97 10 00 00       	jmp    801046c0 <release>
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103630:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103636:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103639:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103640:	00 00 00 
    wakeup(&p->nwrite);
80103643:	50                   	push   %eax
80103644:	e8 b7 0b 00 00       	call   80104200 <wakeup>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	eb b9                	jmp    80103607 <pipeclose+0x37>
8010364e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	53                   	push   %ebx
80103654:	e8 67 10 00 00       	call   801046c0 <release>
    kfree((char*)p);
80103659:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010365c:	83 c4 10             	add    $0x10,%esp
}
8010365f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103662:	5b                   	pop    %ebx
80103663:	5e                   	pop    %esi
80103664:	5d                   	pop    %ebp
    kfree((char*)p);
80103665:	e9 b6 ec ff ff       	jmp    80102320 <kfree>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103670 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	57                   	push   %edi
80103674:	56                   	push   %esi
80103675:	53                   	push   %ebx
80103676:	83 ec 28             	sub    $0x28,%esp
80103679:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010367c:	53                   	push   %ebx
8010367d:	e8 1e 0f 00 00       	call   801045a0 <acquire>
  for(i = 0; i < n; i++){
80103682:	8b 45 10             	mov    0x10(%ebp),%eax
80103685:	83 c4 10             	add    $0x10,%esp
80103688:	85 c0                	test   %eax,%eax
8010368a:	0f 8e c9 00 00 00    	jle    80103759 <pipewrite+0xe9>
80103690:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103693:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103699:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010369f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036a2:	03 4d 10             	add    0x10(%ebp),%ecx
801036a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801036ae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801036b4:	39 d0                	cmp    %edx,%eax
801036b6:	75 71                	jne    80103729 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801036b8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036be:	85 c0                	test   %eax,%eax
801036c0:	74 4e                	je     80103710 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801036c8:	eb 3a                	jmp    80103704 <pipewrite+0x94>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	57                   	push   %edi
801036d4:	e8 27 0b 00 00       	call   80104200 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036d9:	5a                   	pop    %edx
801036da:	59                   	pop    %ecx
801036db:	53                   	push   %ebx
801036dc:	56                   	push   %esi
801036dd:	e8 6e 09 00 00       	call   80104050 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036e2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036e8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036ee:	83 c4 10             	add    $0x10,%esp
801036f1:	05 00 02 00 00       	add    $0x200,%eax
801036f6:	39 c2                	cmp    %eax,%edx
801036f8:	75 36                	jne    80103730 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036fa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103700:	85 c0                	test   %eax,%eax
80103702:	74 0c                	je     80103710 <pipewrite+0xa0>
80103704:	e8 57 03 00 00       	call   80103a60 <myproc>
80103709:	8b 40 24             	mov    0x24(%eax),%eax
8010370c:	85 c0                	test   %eax,%eax
8010370e:	74 c0                	je     801036d0 <pipewrite+0x60>
        release(&p->lock);
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	53                   	push   %ebx
80103714:	e8 a7 0f 00 00       	call   801046c0 <release>
        return -1;
80103719:	83 c4 10             	add    $0x10,%esp
8010371c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103724:	5b                   	pop    %ebx
80103725:	5e                   	pop    %esi
80103726:	5f                   	pop    %edi
80103727:	5d                   	pop    %ebp
80103728:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103729:	89 c2                	mov    %eax,%edx
8010372b:	90                   	nop
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103730:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103733:	8d 42 01             	lea    0x1(%edx),%eax
80103736:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010373c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103742:	83 c6 01             	add    $0x1,%esi
80103745:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103749:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010374c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010374f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103753:	0f 85 4f ff ff ff    	jne    801036a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103759:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010375f:	83 ec 0c             	sub    $0xc,%esp
80103762:	50                   	push   %eax
80103763:	e8 98 0a 00 00       	call   80104200 <wakeup>
  release(&p->lock);
80103768:	89 1c 24             	mov    %ebx,(%esp)
8010376b:	e8 50 0f 00 00       	call   801046c0 <release>
  return n;
80103770:	83 c4 10             	add    $0x10,%esp
80103773:	8b 45 10             	mov    0x10(%ebp),%eax
80103776:	eb a9                	jmp    80103721 <pipewrite+0xb1>
80103778:	90                   	nop
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103780 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 18             	sub    $0x18,%esp
80103789:	8b 75 08             	mov    0x8(%ebp),%esi
8010378c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010378f:	56                   	push   %esi
80103790:	e8 0b 0e 00 00       	call   801045a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010379e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037a4:	75 6a                	jne    80103810 <piperead+0x90>
801037a6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801037ac:	85 db                	test   %ebx,%ebx
801037ae:	0f 84 c4 00 00 00    	je     80103878 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037ba:	eb 2d                	jmp    801037e9 <piperead+0x69>
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c0:	83 ec 08             	sub    $0x8,%esp
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
801037c5:	e8 86 08 00 00       	call   80104050 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ca:	83 c4 10             	add    $0x10,%esp
801037cd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037d3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037d9:	75 35                	jne    80103810 <piperead+0x90>
801037db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801037e1:	85 d2                	test   %edx,%edx
801037e3:	0f 84 8f 00 00 00    	je     80103878 <piperead+0xf8>
    if(myproc()->killed){
801037e9:	e8 72 02 00 00       	call   80103a60 <myproc>
801037ee:	8b 48 24             	mov    0x24(%eax),%ecx
801037f1:	85 c9                	test   %ecx,%ecx
801037f3:	74 cb                	je     801037c0 <piperead+0x40>
      release(&p->lock);
801037f5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037fd:	56                   	push   %esi
801037fe:	e8 bd 0e 00 00       	call   801046c0 <release>
      return -1;
80103803:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103806:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103809:	89 d8                	mov    %ebx,%eax
8010380b:	5b                   	pop    %ebx
8010380c:	5e                   	pop    %esi
8010380d:	5f                   	pop    %edi
8010380e:	5d                   	pop    %ebp
8010380f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103810:	8b 45 10             	mov    0x10(%ebp),%eax
80103813:	85 c0                	test   %eax,%eax
80103815:	7e 61                	jle    80103878 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103817:	31 db                	xor    %ebx,%ebx
80103819:	eb 13                	jmp    8010382e <piperead+0xae>
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103820:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103826:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010382c:	74 1f                	je     8010384d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010382e:	8d 41 01             	lea    0x1(%ecx),%eax
80103831:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103837:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010383d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103842:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	83 c3 01             	add    $0x1,%ebx
80103848:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010384b:	75 d3                	jne    80103820 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010384d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103853:	83 ec 0c             	sub    $0xc,%esp
80103856:	50                   	push   %eax
80103857:	e8 a4 09 00 00       	call   80104200 <wakeup>
  release(&p->lock);
8010385c:	89 34 24             	mov    %esi,(%esp)
8010385f:	e8 5c 0e 00 00       	call   801046c0 <release>
  return i;
80103864:	83 c4 10             	add    $0x10,%esp
}
80103867:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386a:	89 d8                	mov    %ebx,%eax
8010386c:	5b                   	pop    %ebx
8010386d:	5e                   	pop    %esi
8010386e:	5f                   	pop    %edi
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103878:	31 db                	xor    %ebx,%ebx
8010387a:	eb d1                	jmp    8010384d <piperead+0xcd>
8010387c:	66 90                	xchg   %ax,%ax
8010387e:	66 90                	xchg   %ax,%ax

80103880 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103884:	bb 94 2d 12 80       	mov    $0x80122d94,%ebx
{
80103889:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010388c:	68 60 2d 12 80       	push   $0x80122d60
80103891:	e8 0a 0d 00 00       	call   801045a0 <acquire>
80103896:	83 c4 10             	add    $0x10,%esp
80103899:	eb 10                	jmp    801038ab <allocproc+0x2b>
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038a0:	83 c3 7c             	add    $0x7c,%ebx
801038a3:	81 fb 94 4c 12 80    	cmp    $0x80124c94,%ebx
801038a9:	73 75                	jae    80103920 <allocproc+0xa0>
    if(p->state == UNUSED)
801038ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801038ae:	85 c0                	test   %eax,%eax
801038b0:	75 ee                	jne    801038a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038b2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801038b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038c1:	8d 50 01             	lea    0x1(%eax),%edx
801038c4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801038c7:	68 60 2d 12 80       	push   $0x80122d60
  p->pid = nextpid++;
801038cc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801038d2:	e8 e9 0d 00 00       	call   801046c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038d7:	e8 24 ec ff ff       	call   80102500 <kalloc>
801038dc:	83 c4 10             	add    $0x10,%esp
801038df:	85 c0                	test   %eax,%eax
801038e1:	89 43 08             	mov    %eax,0x8(%ebx)
801038e4:	74 53                	je     80103939 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038f4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038f7:	c7 40 14 42 59 10 80 	movl   $0x80105942,0x14(%eax)
  p->context = (struct context*)sp;
801038fe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103901:	6a 14                	push   $0x14
80103903:	6a 00                	push   $0x0
80103905:	50                   	push   %eax
80103906:	e8 15 0e 00 00       	call   80104720 <memset>
  p->context->eip = (uint)forkret;
8010390b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010390e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103911:	c7 40 10 50 39 10 80 	movl   $0x80103950,0x10(%eax)
}
80103918:	89 d8                	mov    %ebx,%eax
8010391a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010391d:	c9                   	leave  
8010391e:	c3                   	ret    
8010391f:	90                   	nop
  release(&ptable.lock);
80103920:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103923:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103925:	68 60 2d 12 80       	push   $0x80122d60
8010392a:	e8 91 0d 00 00       	call   801046c0 <release>
}
8010392f:	89 d8                	mov    %ebx,%eax
  return 0;
80103931:	83 c4 10             	add    $0x10,%esp
}
80103934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103937:	c9                   	leave  
80103938:	c3                   	ret    
    p->state = UNUSED;
80103939:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103940:	31 db                	xor    %ebx,%ebx
80103942:	eb d4                	jmp    80103918 <allocproc+0x98>
80103944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010394a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103950 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103956:	68 60 2d 12 80       	push   $0x80122d60
8010395b:	e8 60 0d 00 00       	call   801046c0 <release>

  if (first) {
80103960:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	85 c0                	test   %eax,%eax
8010396a:	75 04                	jne    80103970 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010396c:	c9                   	leave  
8010396d:	c3                   	ret    
8010396e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103970:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103973:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010397a:	00 00 00 
    iinit(ROOTDEV);
8010397d:	6a 01                	push   $0x1
8010397f:	e8 0c db ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103984:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010398b:	e8 d0 f3 ff ff       	call   80102d60 <initlog>
80103990:	83 c4 10             	add    $0x10,%esp
}
80103993:	c9                   	leave  
80103994:	c3                   	ret    
80103995:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <pinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039a6:	68 11 79 10 80       	push   $0x80107911
801039ab:	68 60 2d 12 80       	push   $0x80122d60
801039b0:	e8 fb 0a 00 00       	call   801044b0 <initlock>
}
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	c9                   	leave  
801039b9:	c3                   	ret    
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <mycpu>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
801039c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039c5:	9c                   	pushf  
801039c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039c7:	f6 c4 02             	test   $0x2,%ah
801039ca:	75 5e                	jne    80103a2a <mycpu+0x6a>
  apicid = lapicid();
801039cc:	e8 bf ef ff ff       	call   80102990 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039d1:	8b 35 40 2d 12 80    	mov    0x80122d40,%esi
801039d7:	85 f6                	test   %esi,%esi
801039d9:	7e 42                	jle    80103a1d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039db:	0f b6 15 c0 27 12 80 	movzbl 0x801227c0,%edx
801039e2:	39 d0                	cmp    %edx,%eax
801039e4:	74 30                	je     80103a16 <mycpu+0x56>
801039e6:	b9 70 28 12 80       	mov    $0x80122870,%ecx
  for (i = 0; i < ncpu; ++i) {
801039eb:	31 d2                	xor    %edx,%edx
801039ed:	8d 76 00             	lea    0x0(%esi),%esi
801039f0:	83 c2 01             	add    $0x1,%edx
801039f3:	39 f2                	cmp    %esi,%edx
801039f5:	74 26                	je     80103a1d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039f7:	0f b6 19             	movzbl (%ecx),%ebx
801039fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a00:	39 c3                	cmp    %eax,%ebx
80103a02:	75 ec                	jne    801039f0 <mycpu+0x30>
80103a04:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a0a:	05 c0 27 12 80       	add    $0x801227c0,%eax
}
80103a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a12:	5b                   	pop    %ebx
80103a13:	5e                   	pop    %esi
80103a14:	5d                   	pop    %ebp
80103a15:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a16:	b8 c0 27 12 80       	mov    $0x801227c0,%eax
      return &cpus[i];
80103a1b:	eb f2                	jmp    80103a0f <mycpu+0x4f>
  panic("unknown apicid\n");
80103a1d:	83 ec 0c             	sub    $0xc,%esp
80103a20:	68 18 79 10 80       	push   $0x80107918
80103a25:	e8 66 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a2a:	83 ec 0c             	sub    $0xc,%esp
80103a2d:	68 f4 79 10 80       	push   $0x801079f4
80103a32:	e8 59 c9 ff ff       	call   80100390 <panic>
80103a37:	89 f6                	mov    %esi,%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a40 <cpuid>:
cpuid() {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a46:	e8 75 ff ff ff       	call   801039c0 <mycpu>
80103a4b:	2d c0 27 12 80       	sub    $0x801227c0,%eax
}
80103a50:	c9                   	leave  
  return mycpu()-cpus;
80103a51:	c1 f8 04             	sar    $0x4,%eax
80103a54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a5a:	c3                   	ret    
80103a5b:	90                   	nop
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a60 <myproc>:
myproc(void) {
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a67:	e8 f4 0a 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103a6c:	e8 4f ff ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103a71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a77:	e8 e4 0b 00 00       	call   80104660 <popcli>
}
80103a7c:	83 c4 04             	add    $0x4,%esp
80103a7f:	89 d8                	mov    %ebx,%eax
80103a81:	5b                   	pop    %ebx
80103a82:	5d                   	pop    %ebp
80103a83:	c3                   	ret    
80103a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a90 <userinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a97:	e8 e4 fd ff ff       	call   80103880 <allocproc>
80103a9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a9e:	a3 c0 a5 10 80       	mov    %eax,0x8010a5c0
  if((p->pgdir = setupkvm()) == 0)
80103aa3:	e8 78 34 00 00       	call   80106f20 <setupkvm>
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	89 43 04             	mov    %eax,0x4(%ebx)
80103aad:	0f 84 bd 00 00 00    	je     80103b70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ab3:	83 ec 04             	sub    $0x4,%esp
80103ab6:	68 2c 00 00 00       	push   $0x2c
80103abb:	68 60 a4 10 80       	push   $0x8010a460
80103ac0:	50                   	push   %eax
80103ac1:	e8 3a 31 00 00       	call   80106c00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ac6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ac9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103acf:	6a 4c                	push   $0x4c
80103ad1:	6a 00                	push   $0x0
80103ad3:	ff 73 18             	pushl  0x18(%ebx)
80103ad6:	e8 45 0c 00 00       	call   80104720 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103adb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ade:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ae3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ae8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aeb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aef:	8b 43 18             	mov    0x18(%ebx),%eax
80103af2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103af6:	8b 43 18             	mov    0x18(%ebx),%eax
80103af9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103afd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b01:	8b 43 18             	mov    0x18(%ebx),%eax
80103b04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b16:	8b 43 18             	mov    0x18(%ebx),%eax
80103b19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b20:	8b 43 18             	mov    0x18(%ebx),%eax
80103b23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b2d:	6a 10                	push   $0x10
80103b2f:	68 41 79 10 80       	push   $0x80107941
80103b34:	50                   	push   %eax
80103b35:	e8 c6 0d 00 00       	call   80104900 <safestrcpy>
  p->cwd = namei("/");
80103b3a:	c7 04 24 4a 79 10 80 	movl   $0x8010794a,(%esp)
80103b41:	e8 aa e3 ff ff       	call   80101ef0 <namei>
80103b46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b49:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
80103b50:	e8 4b 0a 00 00       	call   801045a0 <acquire>
  p->state = RUNNABLE;
80103b55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b5c:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
80103b63:	e8 58 0b 00 00       	call   801046c0 <release>
}
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b6e:	c9                   	leave  
80103b6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	68 28 79 10 80       	push   $0x80107928
80103b78:	e8 13 c8 ff ff       	call   80100390 <panic>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi

80103b80 <growproc>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
80103b85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b88:	e8 d3 09 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103b8d:	e8 2e fe ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103b92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b98:	e8 c3 0a 00 00       	call   80104660 <popcli>
  if(n > 0){
80103b9d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ba0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ba2:	7f 1c                	jg     80103bc0 <growproc+0x40>
  } else if(n < 0){
80103ba4:	75 3a                	jne    80103be0 <growproc+0x60>
  switchuvm(curproc);
80103ba6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ba9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bab:	53                   	push   %ebx
80103bac:	e8 3f 2f 00 00       	call   80106af0 <switchuvm>
  return 0;
80103bb1:	83 c4 10             	add    $0x10,%esp
80103bb4:	31 c0                	xor    %eax,%eax
}
80103bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb9:	5b                   	pop    %ebx
80103bba:	5e                   	pop    %esi
80103bbb:	5d                   	pop    %ebp
80103bbc:	c3                   	ret    
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bc0:	83 ec 04             	sub    $0x4,%esp
80103bc3:	01 c6                	add    %eax,%esi
80103bc5:	56                   	push   %esi
80103bc6:	50                   	push   %eax
80103bc7:	ff 73 04             	pushl  0x4(%ebx)
80103bca:	e8 71 31 00 00       	call   80106d40 <allocuvm>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	75 d0                	jne    80103ba6 <growproc+0x26>
      return -1;
80103bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bdb:	eb d9                	jmp    80103bb6 <growproc+0x36>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103be0:	83 ec 04             	sub    $0x4,%esp
80103be3:	01 c6                	add    %eax,%esi
80103be5:	56                   	push   %esi
80103be6:	50                   	push   %eax
80103be7:	ff 73 04             	pushl  0x4(%ebx)
80103bea:	e8 81 32 00 00       	call   80106e70 <deallocuvm>
80103bef:	83 c4 10             	add    $0x10,%esp
80103bf2:	85 c0                	test   %eax,%eax
80103bf4:	75 b0                	jne    80103ba6 <growproc+0x26>
80103bf6:	eb de                	jmp    80103bd6 <growproc+0x56>
80103bf8:	90                   	nop
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c00 <scheduler>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c09:	e8 b2 fd ff ff       	call   801039c0 <mycpu>
80103c0e:	8d 78 04             	lea    0x4(%eax),%edi
80103c11:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c1a:	00 00 00 
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c20:	fb                   	sti    
    acquire(&ptable.lock);
80103c21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c24:	bb 94 2d 12 80       	mov    $0x80122d94,%ebx
    acquire(&ptable.lock);
80103c29:	68 60 2d 12 80       	push   $0x80122d60
80103c2e:	e8 6d 09 00 00       	call   801045a0 <acquire>
80103c33:	83 c4 10             	add    $0x10,%esp
80103c36:	8d 76 00             	lea    0x0(%esi),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103c40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c44:	75 33                	jne    80103c79 <scheduler+0x79>
      switchuvm(p);
80103c46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c4f:	53                   	push   %ebx
80103c50:	e8 9b 2e 00 00       	call   80106af0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c55:	58                   	pop    %eax
80103c56:	5a                   	pop    %edx
80103c57:	ff 73 1c             	pushl  0x1c(%ebx)
80103c5a:	57                   	push   %edi
      p->state = RUNNING;
80103c5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c62:	e8 f4 0c 00 00       	call   8010495b <swtch>
      switchkvm();
80103c67:	e8 64 2e 00 00       	call   80106ad0 <switchkvm>
      c->proc = 0;
80103c6c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c73:	00 00 00 
80103c76:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c79:	83 c3 7c             	add    $0x7c,%ebx
80103c7c:	81 fb 94 4c 12 80    	cmp    $0x80124c94,%ebx
80103c82:	72 bc                	jb     80103c40 <scheduler+0x40>
    release(&ptable.lock);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 60 2d 12 80       	push   $0x80122d60
80103c8c:	e8 2f 0a 00 00       	call   801046c0 <release>
    sti();
80103c91:	83 c4 10             	add    $0x10,%esp
80103c94:	eb 8a                	jmp    80103c20 <scheduler+0x20>
80103c96:	8d 76 00             	lea    0x0(%esi),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <sched>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
  pushcli();
80103ca5:	e8 b6 08 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103caa:	e8 11 fd ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103caf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cb5:	e8 a6 09 00 00       	call   80104660 <popcli>
  if(!holding(&ptable.lock))
80103cba:	83 ec 0c             	sub    $0xc,%esp
80103cbd:	68 60 2d 12 80       	push   $0x80122d60
80103cc2:	e8 59 08 00 00       	call   80104520 <holding>
80103cc7:	83 c4 10             	add    $0x10,%esp
80103cca:	85 c0                	test   %eax,%eax
80103ccc:	74 4f                	je     80103d1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cce:	e8 ed fc ff ff       	call   801039c0 <mycpu>
80103cd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cda:	75 68                	jne    80103d44 <sched+0xa4>
  if(p->state == RUNNING)
80103cdc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ce0:	74 55                	je     80103d37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ce2:	9c                   	pushf  
80103ce3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ce4:	f6 c4 02             	test   $0x2,%ah
80103ce7:	75 41                	jne    80103d2a <sched+0x8a>
  intena = mycpu()->intena;
80103ce9:	e8 d2 fc ff ff       	call   801039c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103cf1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cf7:	e8 c4 fc ff ff       	call   801039c0 <mycpu>
80103cfc:	83 ec 08             	sub    $0x8,%esp
80103cff:	ff 70 04             	pushl  0x4(%eax)
80103d02:	53                   	push   %ebx
80103d03:	e8 53 0c 00 00       	call   8010495b <swtch>
  mycpu()->intena = intena;
80103d08:	e8 b3 fc ff ff       	call   801039c0 <mycpu>
}
80103d0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d19:	5b                   	pop    %ebx
80103d1a:	5e                   	pop    %esi
80103d1b:	5d                   	pop    %ebp
80103d1c:	c3                   	ret    
    panic("sched ptable.lock");
80103d1d:	83 ec 0c             	sub    $0xc,%esp
80103d20:	68 4c 79 10 80       	push   $0x8010794c
80103d25:	e8 66 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	68 78 79 10 80       	push   $0x80107978
80103d32:	e8 59 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	68 6a 79 10 80       	push   $0x8010796a
80103d3f:	e8 4c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	68 5e 79 10 80       	push   $0x8010795e
80103d4c:	e8 3f c6 ff ff       	call   80100390 <panic>
80103d51:	eb 0d                	jmp    80103d60 <fork>
80103d53:	90                   	nop
80103d54:	90                   	nop
80103d55:	90                   	nop
80103d56:	90                   	nop
80103d57:	90                   	nop
80103d58:	90                   	nop
80103d59:	90                   	nop
80103d5a:	90                   	nop
80103d5b:	90                   	nop
80103d5c:	90                   	nop
80103d5d:	90                   	nop
80103d5e:	90                   	nop
80103d5f:	90                   	nop

80103d60 <fork>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d69:	e8 f2 07 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103d6e:	e8 4d fc ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103d73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d79:	e8 e2 08 00 00       	call   80104660 <popcli>
  if((np = allocproc()) == 0){
80103d7e:	e8 fd fa ff ff       	call   80103880 <allocproc>
80103d83:	85 c0                	test   %eax,%eax
80103d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d88:	0f 84 15 01 00 00    	je     80103ea3 <fork+0x143>
80103d8e:	89 c1                	mov    %eax,%ecx
80103d90:	8b 13                	mov    (%ebx),%edx
80103d92:	8b 43 04             	mov    0x4(%ebx),%eax
  if(np->pid <= -1){
80103d95:	8b 49 10             	mov    0x10(%ecx),%ecx
80103d98:	85 c9                	test   %ecx,%ecx
80103d9a:	0f 88 c8 00 00 00    	js     80103e68 <fork+0x108>
    if((np->pgdir = copyuvm_new(curproc->pgdir, curproc->sz)) == 0){
80103da0:	83 ec 08             	sub    $0x8,%esp
80103da3:	52                   	push   %edx
80103da4:	50                   	push   %eax
80103da5:	e8 26 33 00 00       	call   801070d0 <copyuvm_new>
80103daa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dad:	83 c4 10             	add    $0x10,%esp
80103db0:	85 c0                	test   %eax,%eax
80103db2:	89 42 04             	mov    %eax,0x4(%edx)
80103db5:	0f 84 ef 00 00 00    	je     80103eaa <fork+0x14a>
  np->sz = curproc->sz;
80103dbb:	8b 03                	mov    (%ebx),%eax
80103dbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103dc0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103dc5:	89 02                	mov    %eax,(%edx)
  np->parent = curproc; 
80103dc7:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103dca:	8b 7a 18             	mov    0x18(%edx),%edi
80103dcd:	8b 73 18             	mov    0x18(%ebx),%esi
80103dd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103dd2:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103dd4:	8b 42 18             	mov    0x18(%edx),%eax
80103dd7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103dde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103de0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103de4:	85 c0                	test   %eax,%eax
80103de6:	74 13                	je     80103dfb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103de8:	83 ec 0c             	sub    $0xc,%esp
80103deb:	50                   	push   %eax
80103dec:	e8 ff cf ff ff       	call   80100df0 <filedup>
80103df1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103df4:	83 c4 10             	add    $0x10,%esp
80103df7:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dfb:	83 c6 01             	add    $0x1,%esi
80103dfe:	83 fe 10             	cmp    $0x10,%esi
80103e01:	75 dd                	jne    80103de0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103e03:	83 ec 0c             	sub    $0xc,%esp
80103e06:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e0c:	e8 4f d8 ff ff       	call   80101660 <idup>
80103e11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e1d:	6a 10                	push   $0x10
80103e1f:	53                   	push   %ebx
80103e20:	50                   	push   %eax
80103e21:	e8 da 0a 00 00       	call   80104900 <safestrcpy>
  pid = np->pid;
80103e26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e29:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
80103e30:	e8 6b 07 00 00       	call   801045a0 <acquire>
  if(fork_winner){
80103e35:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80103e3a:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80103e3d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  if(fork_winner){
80103e44:	85 c0                	test   %eax,%eax
80103e46:	75 38                	jne    80103e80 <fork+0x120>
  release(&ptable.lock);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	68 60 2d 12 80       	push   $0x80122d60
80103e50:	e8 6b 08 00 00       	call   801046c0 <release>
  return pid;
80103e55:	83 c4 10             	add    $0x10,%esp
}
80103e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e5b:	89 d8                	mov    %ebx,%eax
80103e5d:	5b                   	pop    %ebx
80103e5e:	5e                   	pop    %esi
80103e5f:	5f                   	pop    %edi
80103e60:	5d                   	pop    %ebp
80103e61:	c3                   	ret    
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e68:	83 ec 08             	sub    $0x8,%esp
80103e6b:	52                   	push   %edx
80103e6c:	50                   	push   %eax
80103e6d:	e8 7e 31 00 00       	call   80106ff0 <copyuvm>
80103e72:	e9 33 ff ff ff       	jmp    80103daa <fork+0x4a>
80103e77:	89 f6                	mov    %esi,%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  pushcli();
80103e80:	e8 db 06 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103e85:	e8 36 fb ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103e8a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e90:	e8 cb 07 00 00       	call   80104660 <popcli>
    myproc()->state=RUNNABLE;
80103e95:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
    sched();
80103e9c:	e8 ff fd ff ff       	call   80103ca0 <sched>
80103ea1:	eb a5                	jmp    80103e48 <fork+0xe8>
    return -1;
80103ea3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ea8:	eb ae                	jmp    80103e58 <fork+0xf8>
    kfree(np->kstack);
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	ff 72 08             	pushl  0x8(%edx)
80103eb0:	89 d7                	mov    %edx,%edi
    return -1;
80103eb2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103eb7:	e8 64 e4 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103ebc:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103ec3:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103eca:	83 c4 10             	add    $0x10,%esp
80103ecd:	eb 89                	jmp    80103e58 <fork+0xf8>
80103ecf:	90                   	nop

80103ed0 <exit>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ed9:	e8 82 06 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103ede:	e8 dd fa ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103ee3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ee9:	e8 72 07 00 00       	call   80104660 <popcli>
  if(curproc == initproc)
80103eee:	39 35 c0 a5 10 80    	cmp    %esi,0x8010a5c0
80103ef4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ef7:	8d 7e 68             	lea    0x68(%esi),%edi
80103efa:	0f 84 e7 00 00 00    	je     80103fe7 <exit+0x117>
    if(curproc->ofile[fd]){
80103f00:	8b 03                	mov    (%ebx),%eax
80103f02:	85 c0                	test   %eax,%eax
80103f04:	74 12                	je     80103f18 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f06:	83 ec 0c             	sub    $0xc,%esp
80103f09:	50                   	push   %eax
80103f0a:	e8 31 cf ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103f0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f15:	83 c4 10             	add    $0x10,%esp
80103f18:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f1b:	39 fb                	cmp    %edi,%ebx
80103f1d:	75 e1                	jne    80103f00 <exit+0x30>
  begin_op();
80103f1f:	e8 dc ee ff ff       	call   80102e00 <begin_op>
  iput(curproc->cwd);
80103f24:	83 ec 0c             	sub    $0xc,%esp
80103f27:	ff 76 68             	pushl  0x68(%esi)
80103f2a:	e8 91 d8 ff ff       	call   801017c0 <iput>
  end_op();
80103f2f:	e8 3c ef ff ff       	call   80102e70 <end_op>
  curproc->cwd = 0;
80103f34:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f3b:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
80103f42:	e8 59 06 00 00       	call   801045a0 <acquire>
  wakeup1(curproc->parent);
80103f47:	8b 56 14             	mov    0x14(%esi),%edx
80103f4a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4d:	b8 94 2d 12 80       	mov    $0x80122d94,%eax
80103f52:	eb 0e                	jmp    80103f62 <exit+0x92>
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f58:	83 c0 7c             	add    $0x7c,%eax
80103f5b:	3d 94 4c 12 80       	cmp    $0x80124c94,%eax
80103f60:	73 1c                	jae    80103f7e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103f62:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f66:	75 f0                	jne    80103f58 <exit+0x88>
80103f68:	3b 50 20             	cmp    0x20(%eax),%edx
80103f6b:	75 eb                	jne    80103f58 <exit+0x88>
      p->state = RUNNABLE;
80103f6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f74:	83 c0 7c             	add    $0x7c,%eax
80103f77:	3d 94 4c 12 80       	cmp    $0x80124c94,%eax
80103f7c:	72 e4                	jb     80103f62 <exit+0x92>
      p->parent = initproc;
80103f7e:	8b 0d c0 a5 10 80    	mov    0x8010a5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f84:	ba 94 2d 12 80       	mov    $0x80122d94,%edx
80103f89:	eb 10                	jmp    80103f9b <exit+0xcb>
80103f8b:	90                   	nop
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f90:	83 c2 7c             	add    $0x7c,%edx
80103f93:	81 fa 94 4c 12 80    	cmp    $0x80124c94,%edx
80103f99:	73 33                	jae    80103fce <exit+0xfe>
    if(p->parent == curproc){
80103f9b:	39 72 14             	cmp    %esi,0x14(%edx)
80103f9e:	75 f0                	jne    80103f90 <exit+0xc0>
      if(p->state == ZOMBIE)
80103fa0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fa4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fa7:	75 e7                	jne    80103f90 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa9:	b8 94 2d 12 80       	mov    $0x80122d94,%eax
80103fae:	eb 0a                	jmp    80103fba <exit+0xea>
80103fb0:	83 c0 7c             	add    $0x7c,%eax
80103fb3:	3d 94 4c 12 80       	cmp    $0x80124c94,%eax
80103fb8:	73 d6                	jae    80103f90 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fbe:	75 f0                	jne    80103fb0 <exit+0xe0>
80103fc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fc3:	75 eb                	jne    80103fb0 <exit+0xe0>
      p->state = RUNNABLE;
80103fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fcc:	eb e2                	jmp    80103fb0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fce:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103fd5:	e8 c6 fc ff ff       	call   80103ca0 <sched>
  panic("zombie exit");
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 99 79 10 80       	push   $0x80107999
80103fe2:	e8 a9 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 8c 79 10 80       	push   $0x8010798c
80103fef:	e8 9c c3 ff ff       	call   80100390 <panic>
80103ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104000 <yield>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104007:	68 60 2d 12 80       	push   $0x80122d60
8010400c:	e8 8f 05 00 00       	call   801045a0 <acquire>
  pushcli();
80104011:	e8 4a 05 00 00       	call   80104560 <pushcli>
  c = mycpu();
80104016:	e8 a5 f9 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010401b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104021:	e8 3a 06 00 00       	call   80104660 <popcli>
  myproc()->state = RUNNABLE;
80104026:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010402d:	e8 6e fc ff ff       	call   80103ca0 <sched>
  release(&ptable.lock);
80104032:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
80104039:	e8 82 06 00 00       	call   801046c0 <release>
}
8010403e:	83 c4 10             	add    $0x10,%esp
80104041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104044:	c9                   	leave  
80104045:	c3                   	ret    
80104046:	8d 76 00             	lea    0x0(%esi),%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104050 <sleep>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	8b 7d 08             	mov    0x8(%ebp),%edi
8010405c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010405f:	e8 fc 04 00 00       	call   80104560 <pushcli>
  c = mycpu();
80104064:	e8 57 f9 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80104069:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010406f:	e8 ec 05 00 00       	call   80104660 <popcli>
  if(p == 0)
80104074:	85 db                	test   %ebx,%ebx
80104076:	0f 84 87 00 00 00    	je     80104103 <sleep+0xb3>
  if(lk == 0)
8010407c:	85 f6                	test   %esi,%esi
8010407e:	74 76                	je     801040f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104080:	81 fe 60 2d 12 80    	cmp    $0x80122d60,%esi
80104086:	74 50                	je     801040d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 60 2d 12 80       	push   $0x80122d60
80104090:	e8 0b 05 00 00       	call   801045a0 <acquire>
    release(lk);
80104095:	89 34 24             	mov    %esi,(%esp)
80104098:	e8 23 06 00 00       	call   801046c0 <release>
  p->chan = chan;
8010409d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040a7:	e8 f4 fb ff ff       	call   80103ca0 <sched>
  p->chan = 0;
801040ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040b3:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
801040ba:	e8 01 06 00 00       	call   801046c0 <release>
    acquire(lk);
801040bf:	89 75 08             	mov    %esi,0x8(%ebp)
801040c2:	83 c4 10             	add    $0x10,%esp
}
801040c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c8:	5b                   	pop    %ebx
801040c9:	5e                   	pop    %esi
801040ca:	5f                   	pop    %edi
801040cb:	5d                   	pop    %ebp
    acquire(lk);
801040cc:	e9 cf 04 00 00       	jmp    801045a0 <acquire>
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e2:	e8 b9 fb ff ff       	call   80103ca0 <sched>
  p->chan = 0;
801040e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f1:	5b                   	pop    %ebx
801040f2:	5e                   	pop    %esi
801040f3:	5f                   	pop    %edi
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret    
    panic("sleep without lk");
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	68 ab 79 10 80       	push   $0x801079ab
801040fe:	e8 8d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104103:	83 ec 0c             	sub    $0xc,%esp
80104106:	68 a5 79 10 80       	push   $0x801079a5
8010410b:	e8 80 c2 ff ff       	call   80100390 <panic>

80104110 <wait>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
  pushcli();
80104115:	e8 46 04 00 00       	call   80104560 <pushcli>
  c = mycpu();
8010411a:	e8 a1 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010411f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104125:	e8 36 05 00 00       	call   80104660 <popcli>
  acquire(&ptable.lock);
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 60 2d 12 80       	push   $0x80122d60
80104132:	e8 69 04 00 00       	call   801045a0 <acquire>
80104137:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010413a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	bb 94 2d 12 80       	mov    $0x80122d94,%ebx
80104141:	eb 10                	jmp    80104153 <wait+0x43>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104148:	83 c3 7c             	add    $0x7c,%ebx
8010414b:	81 fb 94 4c 12 80    	cmp    $0x80124c94,%ebx
80104151:	73 1b                	jae    8010416e <wait+0x5e>
      if(p->parent != curproc)
80104153:	39 73 14             	cmp    %esi,0x14(%ebx)
80104156:	75 f0                	jne    80104148 <wait+0x38>
      if(p->state == ZOMBIE){
80104158:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010415c:	74 32                	je     80104190 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104161:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104166:	81 fb 94 4c 12 80    	cmp    $0x80124c94,%ebx
8010416c:	72 e5                	jb     80104153 <wait+0x43>
    if(!havekids || curproc->killed){
8010416e:	85 c0                	test   %eax,%eax
80104170:	74 74                	je     801041e6 <wait+0xd6>
80104172:	8b 46 24             	mov    0x24(%esi),%eax
80104175:	85 c0                	test   %eax,%eax
80104177:	75 6d                	jne    801041e6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104179:	83 ec 08             	sub    $0x8,%esp
8010417c:	68 60 2d 12 80       	push   $0x80122d60
80104181:	56                   	push   %esi
80104182:	e8 c9 fe ff ff       	call   80104050 <sleep>
    havekids = 0;
80104187:	83 c4 10             	add    $0x10,%esp
8010418a:	eb ae                	jmp    8010413a <wait+0x2a>
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104190:	83 ec 0c             	sub    $0xc,%esp
80104193:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104196:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104199:	e8 82 e1 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
8010419e:	5a                   	pop    %edx
8010419f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801041a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041a9:	e8 f2 2c 00 00       	call   80106ea0 <freevm>
        release(&ptable.lock);
801041ae:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
        p->pid = 0;
801041b5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041bc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041c3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041c7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041ce:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041d5:	e8 e6 04 00 00       	call   801046c0 <release>
        return pid;
801041da:	83 c4 10             	add    $0x10,%esp
}
801041dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e0:	89 f0                	mov    %esi,%eax
801041e2:	5b                   	pop    %ebx
801041e3:	5e                   	pop    %esi
801041e4:	5d                   	pop    %ebp
801041e5:	c3                   	ret    
      release(&ptable.lock);
801041e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ee:	68 60 2d 12 80       	push   $0x80122d60
801041f3:	e8 c8 04 00 00       	call   801046c0 <release>
      return -1;
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	eb e0                	jmp    801041dd <wait+0xcd>
801041fd:	8d 76 00             	lea    0x0(%esi),%esi

80104200 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
80104207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010420a:	68 60 2d 12 80       	push   $0x80122d60
8010420f:	e8 8c 03 00 00       	call   801045a0 <acquire>
80104214:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104217:	b8 94 2d 12 80       	mov    $0x80122d94,%eax
8010421c:	eb 0c                	jmp    8010422a <wakeup+0x2a>
8010421e:	66 90                	xchg   %ax,%ax
80104220:	83 c0 7c             	add    $0x7c,%eax
80104223:	3d 94 4c 12 80       	cmp    $0x80124c94,%eax
80104228:	73 1c                	jae    80104246 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010422a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010422e:	75 f0                	jne    80104220 <wakeup+0x20>
80104230:	3b 58 20             	cmp    0x20(%eax),%ebx
80104233:	75 eb                	jne    80104220 <wakeup+0x20>
      p->state = RUNNABLE;
80104235:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010423c:	83 c0 7c             	add    $0x7c,%eax
8010423f:	3d 94 4c 12 80       	cmp    $0x80124c94,%eax
80104244:	72 e4                	jb     8010422a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104246:	c7 45 08 60 2d 12 80 	movl   $0x80122d60,0x8(%ebp)
}
8010424d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104250:	c9                   	leave  
  release(&ptable.lock);
80104251:	e9 6a 04 00 00       	jmp    801046c0 <release>
80104256:	8d 76 00             	lea    0x0(%esi),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104260 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010426a:	68 60 2d 12 80       	push   $0x80122d60
8010426f:	e8 2c 03 00 00       	call   801045a0 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104277:	b8 94 2d 12 80       	mov    $0x80122d94,%eax
8010427c:	eb 0c                	jmp    8010428a <kill+0x2a>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	83 c0 7c             	add    $0x7c,%eax
80104283:	3d 94 4c 12 80       	cmp    $0x80124c94,%eax
80104288:	73 36                	jae    801042c0 <kill+0x60>
    if(p->pid == pid){
8010428a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010428d:	75 f1                	jne    80104280 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010428f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104293:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010429a:	75 07                	jne    801042a3 <kill+0x43>
        p->state = RUNNABLE;
8010429c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	68 60 2d 12 80       	push   $0x80122d60
801042ab:	e8 10 04 00 00       	call   801046c0 <release>
      return 0;
801042b0:	83 c4 10             	add    $0x10,%esp
801042b3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801042b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b8:	c9                   	leave  
801042b9:	c3                   	ret    
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042c0:	83 ec 0c             	sub    $0xc,%esp
801042c3:	68 60 2d 12 80       	push   $0x80122d60
801042c8:	e8 f3 03 00 00       	call   801046c0 <release>
  return -1;
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d8:	c9                   	leave  
801042d9:	c3                   	ret    
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e9:	bb 94 2d 12 80       	mov    $0x80122d94,%ebx
{
801042ee:	83 ec 3c             	sub    $0x3c,%esp
801042f1:	eb 24                	jmp    80104317 <procdump+0x37>
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 b2 78 10 80       	push   $0x801078b2
80104300:	e8 5b c3 ff ff       	call   80100660 <cprintf>
80104305:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104308:	83 c3 7c             	add    $0x7c,%ebx
8010430b:	81 fb 94 4c 12 80    	cmp    $0x80124c94,%ebx
80104311:	0f 83 81 00 00 00    	jae    80104398 <procdump+0xb8>
    if(p->state == UNUSED)
80104317:	8b 43 0c             	mov    0xc(%ebx),%eax
8010431a:	85 c0                	test   %eax,%eax
8010431c:	74 ea                	je     80104308 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010431e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104321:	ba bc 79 10 80       	mov    $0x801079bc,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104326:	77 11                	ja     80104339 <procdump+0x59>
80104328:	8b 14 85 1c 7a 10 80 	mov    -0x7fef85e4(,%eax,4),%edx
      state = "???";
8010432f:	b8 bc 79 10 80       	mov    $0x801079bc,%eax
80104334:	85 d2                	test   %edx,%edx
80104336:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104339:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010433c:	50                   	push   %eax
8010433d:	52                   	push   %edx
8010433e:	ff 73 10             	pushl  0x10(%ebx)
80104341:	68 c0 79 10 80       	push   $0x801079c0
80104346:	e8 15 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010434b:	83 c4 10             	add    $0x10,%esp
8010434e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104352:	75 a4                	jne    801042f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104354:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104357:	83 ec 08             	sub    $0x8,%esp
8010435a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010435d:	50                   	push   %eax
8010435e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104361:	8b 40 0c             	mov    0xc(%eax),%eax
80104364:	83 c0 08             	add    $0x8,%eax
80104367:	50                   	push   %eax
80104368:	e8 63 01 00 00       	call   801044d0 <getcallerpcs>
8010436d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104370:	8b 17                	mov    (%edi),%edx
80104372:	85 d2                	test   %edx,%edx
80104374:	74 82                	je     801042f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104376:	83 ec 08             	sub    $0x8,%esp
80104379:	83 c7 04             	add    $0x4,%edi
8010437c:	52                   	push   %edx
8010437d:	68 c1 73 10 80       	push   $0x801073c1
80104382:	e8 d9 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104387:	83 c4 10             	add    $0x10,%esp
8010438a:	39 fe                	cmp    %edi,%esi
8010438c:	75 e2                	jne    80104370 <procdump+0x90>
8010438e:	e9 65 ff ff ff       	jmp    801042f8 <procdump+0x18>
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010439b:	5b                   	pop    %ebx
8010439c:	5e                   	pop    %esi
8010439d:	5f                   	pop    %edi
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043aa:	68 34 7a 10 80       	push   $0x80107a34
801043af:	8d 43 04             	lea    0x4(%ebx),%eax
801043b2:	50                   	push   %eax
801043b3:	e8 f8 00 00 00       	call   801044b0 <initlock>
  lk->name = name;
801043b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d1:	c9                   	leave  
801043d2:	c3                   	ret    
801043d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	8d 73 04             	lea    0x4(%ebx),%esi
801043ee:	56                   	push   %esi
801043ef:	e8 ac 01 00 00       	call   801045a0 <acquire>
  while (lk->locked) {
801043f4:	8b 13                	mov    (%ebx),%edx
801043f6:	83 c4 10             	add    $0x10,%esp
801043f9:	85 d2                	test   %edx,%edx
801043fb:	74 16                	je     80104413 <acquiresleep+0x33>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104400:	83 ec 08             	sub    $0x8,%esp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	e8 46 fc ff ff       	call   80104050 <sleep>
  while (lk->locked) {
8010440a:	8b 03                	mov    (%ebx),%eax
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	85 c0                	test   %eax,%eax
80104411:	75 ed                	jne    80104400 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104413:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104419:	e8 42 f6 ff ff       	call   80103a60 <myproc>
8010441e:	8b 40 10             	mov    0x10(%eax),%eax
80104421:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104424:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104427:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010442a:	5b                   	pop    %ebx
8010442b:	5e                   	pop    %esi
8010442c:	5d                   	pop    %ebp
  release(&lk->lk);
8010442d:	e9 8e 02 00 00       	jmp    801046c0 <release>
80104432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	8d 73 04             	lea    0x4(%ebx),%esi
8010444e:	56                   	push   %esi
8010444f:	e8 4c 01 00 00       	call   801045a0 <acquire>
  lk->locked = 0;
80104454:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010445a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104461:	89 1c 24             	mov    %ebx,(%esp)
80104464:	e8 97 fd ff ff       	call   80104200 <wakeup>
  release(&lk->lk);
80104469:	89 75 08             	mov    %esi,0x8(%ebp)
8010446c:	83 c4 10             	add    $0x10,%esp
}
8010446f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104472:	5b                   	pop    %ebx
80104473:	5e                   	pop    %esi
80104474:	5d                   	pop    %ebp
  release(&lk->lk);
80104475:	e9 46 02 00 00       	jmp    801046c0 <release>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010448e:	53                   	push   %ebx
8010448f:	e8 0c 01 00 00       	call   801045a0 <acquire>
  r = lk->locked;
80104494:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104496:	89 1c 24             	mov    %ebx,(%esp)
80104499:	e8 22 02 00 00       	call   801046c0 <release>
  return r;
}
8010449e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a1:	89 f0                	mov    %esi,%eax
801044a3:	5b                   	pop    %ebx
801044a4:	5e                   	pop    %esi
801044a5:	5d                   	pop    %ebp
801044a6:	c3                   	ret    
801044a7:	66 90                	xchg   %ax,%ax
801044a9:	66 90                	xchg   %ax,%ax
801044ab:	66 90                	xchg   %ax,%ax
801044ad:	66 90                	xchg   %ax,%ax
801044af:	90                   	nop

801044b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044d1:	31 d2                	xor    %edx,%edx
{
801044d3:	89 e5                	mov    %esp,%ebp
801044d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044dc:	83 e8 08             	sub    $0x8,%eax
801044df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ec:	77 1a                	ja     80104508 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ee:	8b 58 04             	mov    0x4(%eax),%ebx
801044f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044f9:	83 fa 0a             	cmp    $0xa,%edx
801044fc:	75 e2                	jne    801044e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044fe:	5b                   	pop    %ebx
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104508:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010450b:	83 c1 28             	add    $0x28,%ecx
8010450e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104516:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104519:	39 c1                	cmp    %eax,%ecx
8010451b:	75 f3                	jne    80104510 <getcallerpcs+0x40>
}
8010451d:	5b                   	pop    %ebx
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret    

80104520 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
80104527:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010452a:	8b 02                	mov    (%edx),%eax
8010452c:	85 c0                	test   %eax,%eax
8010452e:	75 10                	jne    80104540 <holding+0x20>
}
80104530:	83 c4 04             	add    $0x4,%esp
80104533:	31 c0                	xor    %eax,%eax
80104535:	5b                   	pop    %ebx
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
80104538:	90                   	nop
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104540:	8b 5a 08             	mov    0x8(%edx),%ebx
80104543:	e8 78 f4 ff ff       	call   801039c0 <mycpu>
80104548:	39 c3                	cmp    %eax,%ebx
8010454a:	0f 94 c0             	sete   %al
}
8010454d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104550:	0f b6 c0             	movzbl %al,%eax
}
80104553:	5b                   	pop    %ebx
80104554:	5d                   	pop    %ebp
80104555:	c3                   	ret    
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 04             	sub    $0x4,%esp
80104567:	9c                   	pushf  
80104568:	5b                   	pop    %ebx
  asm volatile("cli");
80104569:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010456a:	e8 51 f4 ff ff       	call   801039c0 <mycpu>
8010456f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104575:	85 c0                	test   %eax,%eax
80104577:	75 11                	jne    8010458a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104579:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010457f:	e8 3c f4 ff ff       	call   801039c0 <mycpu>
80104584:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010458a:	e8 31 f4 ff ff       	call   801039c0 <mycpu>
8010458f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104596:	83 c4 04             	add    $0x4,%esp
80104599:	5b                   	pop    %ebx
8010459a:	5d                   	pop    %ebp
8010459b:	c3                   	ret    
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <acquire>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045a5:	e8 b6 ff ff ff       	call   80104560 <pushcli>
  if(holding(lk))
801045aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045ad:	8b 03                	mov    (%ebx),%eax
801045af:	85 c0                	test   %eax,%eax
801045b1:	0f 85 81 00 00 00    	jne    80104638 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801045b7:	ba 01 00 00 00       	mov    $0x1,%edx
801045bc:	eb 05                	jmp    801045c3 <acquire+0x23>
801045be:	66 90                	xchg   %ax,%ax
801045c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c3:	89 d0                	mov    %edx,%eax
801045c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045c8:	85 c0                	test   %eax,%eax
801045ca:	75 f4                	jne    801045c0 <acquire+0x20>
  __sync_synchronize();
801045cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045d4:	e8 e7 f3 ff ff       	call   801039c0 <mycpu>
  for(i = 0; i < 10; i++){
801045d9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801045db:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801045de:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801045e1:	89 e8                	mov    %ebp,%eax
801045e3:	90                   	nop
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045f4:	77 1a                	ja     80104610 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801045f6:	8b 58 04             	mov    0x4(%eax),%ebx
801045f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104601:	83 fa 0a             	cmp    $0xa,%edx
80104604:	75 e2                	jne    801045e8 <acquire+0x48>
}
80104606:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104609:	5b                   	pop    %ebx
8010460a:	5e                   	pop    %esi
8010460b:	5d                   	pop    %ebp
8010460c:	c3                   	ret    
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
80104610:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104613:	83 c1 28             	add    $0x28,%ecx
80104616:	8d 76 00             	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104626:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104629:	39 c8                	cmp    %ecx,%eax
8010462b:	75 f3                	jne    80104620 <acquire+0x80>
}
8010462d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104630:	5b                   	pop    %ebx
80104631:	5e                   	pop    %esi
80104632:	5d                   	pop    %ebp
80104633:	c3                   	ret    
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104638:	8b 73 08             	mov    0x8(%ebx),%esi
8010463b:	e8 80 f3 ff ff       	call   801039c0 <mycpu>
80104640:	39 c6                	cmp    %eax,%esi
80104642:	0f 85 6f ff ff ff    	jne    801045b7 <acquire+0x17>
    panic("acquire");
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 3f 7a 10 80       	push   $0x80107a3f
80104650:	e8 3b bd ff ff       	call   80100390 <panic>
80104655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <popcli>:

void
popcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104666:	9c                   	pushf  
80104667:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104668:	f6 c4 02             	test   $0x2,%ah
8010466b:	75 35                	jne    801046a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010466d:	e8 4e f3 ff ff       	call   801039c0 <mycpu>
80104672:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104679:	78 34                	js     801046af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010467b:	e8 40 f3 ff ff       	call   801039c0 <mycpu>
80104680:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104686:	85 d2                	test   %edx,%edx
80104688:	74 06                	je     80104690 <popcli+0x30>
    sti();
}
8010468a:	c9                   	leave  
8010468b:	c3                   	ret    
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104690:	e8 2b f3 ff ff       	call   801039c0 <mycpu>
80104695:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010469b:	85 c0                	test   %eax,%eax
8010469d:	74 eb                	je     8010468a <popcli+0x2a>
  asm volatile("sti");
8010469f:	fb                   	sti    
}
801046a0:	c9                   	leave  
801046a1:	c3                   	ret    
    panic("popcli - interruptible");
801046a2:	83 ec 0c             	sub    $0xc,%esp
801046a5:	68 47 7a 10 80       	push   $0x80107a47
801046aa:	e8 e1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046af:	83 ec 0c             	sub    $0xc,%esp
801046b2:	68 5e 7a 10 80       	push   $0x80107a5e
801046b7:	e8 d4 bc ff ff       	call   80100390 <panic>
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <release>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801046c8:	8b 03                	mov    (%ebx),%eax
801046ca:	85 c0                	test   %eax,%eax
801046cc:	74 0c                	je     801046da <release+0x1a>
801046ce:	8b 73 08             	mov    0x8(%ebx),%esi
801046d1:	e8 ea f2 ff ff       	call   801039c0 <mycpu>
801046d6:	39 c6                	cmp    %eax,%esi
801046d8:	74 16                	je     801046f0 <release+0x30>
    panic("release");
801046da:	83 ec 0c             	sub    $0xc,%esp
801046dd:	68 65 7a 10 80       	push   $0x80107a65
801046e2:	e8 a9 bc ff ff       	call   80100390 <panic>
801046e7:	89 f6                	mov    %esi,%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801046f0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046f7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046fe:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104703:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104709:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010470c:	5b                   	pop    %ebx
8010470d:	5e                   	pop    %esi
8010470e:	5d                   	pop    %ebp
  popcli();
8010470f:	e9 4c ff ff ff       	jmp    80104660 <popcli>
80104714:	66 90                	xchg   %ax,%ax
80104716:	66 90                	xchg   %ax,%ax
80104718:	66 90                	xchg   %ax,%ax
8010471a:	66 90                	xchg   %ax,%ax
8010471c:	66 90                	xchg   %ax,%ax
8010471e:	66 90                	xchg   %ax,%ax

80104720 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	53                   	push   %ebx
80104725:	8b 55 08             	mov    0x8(%ebp),%edx
80104728:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010472b:	f6 c2 03             	test   $0x3,%dl
8010472e:	75 05                	jne    80104735 <memset+0x15>
80104730:	f6 c1 03             	test   $0x3,%cl
80104733:	74 13                	je     80104748 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104735:	89 d7                	mov    %edx,%edi
80104737:	8b 45 0c             	mov    0xc(%ebp),%eax
8010473a:	fc                   	cld    
8010473b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010473d:	5b                   	pop    %ebx
8010473e:	89 d0                	mov    %edx,%eax
80104740:	5f                   	pop    %edi
80104741:	5d                   	pop    %ebp
80104742:	c3                   	ret    
80104743:	90                   	nop
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104748:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010474c:	c1 e9 02             	shr    $0x2,%ecx
8010474f:	89 f8                	mov    %edi,%eax
80104751:	89 fb                	mov    %edi,%ebx
80104753:	c1 e0 18             	shl    $0x18,%eax
80104756:	c1 e3 10             	shl    $0x10,%ebx
80104759:	09 d8                	or     %ebx,%eax
8010475b:	09 f8                	or     %edi,%eax
8010475d:	c1 e7 08             	shl    $0x8,%edi
80104760:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104762:	89 d7                	mov    %edx,%edi
80104764:	fc                   	cld    
80104765:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104767:	5b                   	pop    %ebx
80104768:	89 d0                	mov    %edx,%eax
8010476a:	5f                   	pop    %edi
8010476b:	5d                   	pop    %ebp
8010476c:	c3                   	ret    
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104779:	8b 75 08             	mov    0x8(%ebp),%esi
8010477c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010477f:	85 db                	test   %ebx,%ebx
80104781:	74 29                	je     801047ac <memcmp+0x3c>
    if(*s1 != *s2)
80104783:	0f b6 16             	movzbl (%esi),%edx
80104786:	0f b6 0f             	movzbl (%edi),%ecx
80104789:	38 d1                	cmp    %dl,%cl
8010478b:	75 2b                	jne    801047b8 <memcmp+0x48>
8010478d:	b8 01 00 00 00       	mov    $0x1,%eax
80104792:	eb 14                	jmp    801047a8 <memcmp+0x38>
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104798:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010479c:	83 c0 01             	add    $0x1,%eax
8010479f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801047a4:	38 ca                	cmp    %cl,%dl
801047a6:	75 10                	jne    801047b8 <memcmp+0x48>
  while(n-- > 0){
801047a8:	39 d8                	cmp    %ebx,%eax
801047aa:	75 ec                	jne    80104798 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801047ac:	5b                   	pop    %ebx
  return 0;
801047ad:	31 c0                	xor    %eax,%eax
}
801047af:	5e                   	pop    %esi
801047b0:	5f                   	pop    %edi
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret    
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801047b8:	0f b6 c2             	movzbl %dl,%eax
}
801047bb:	5b                   	pop    %ebx
      return *s1 - *s2;
801047bc:	29 c8                	sub    %ecx,%eax
}
801047be:	5e                   	pop    %esi
801047bf:	5f                   	pop    %edi
801047c0:	5d                   	pop    %ebp
801047c1:	c3                   	ret    
801047c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 45 08             	mov    0x8(%ebp),%eax
801047d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047db:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047de:	39 c3                	cmp    %eax,%ebx
801047e0:	73 26                	jae    80104808 <memmove+0x38>
801047e2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047e5:	39 c8                	cmp    %ecx,%eax
801047e7:	73 1f                	jae    80104808 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047e9:	85 f6                	test   %esi,%esi
801047eb:	8d 56 ff             	lea    -0x1(%esi),%edx
801047ee:	74 0f                	je     801047ff <memmove+0x2f>
      *--d = *--s;
801047f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801047f7:	83 ea 01             	sub    $0x1,%edx
801047fa:	83 fa ff             	cmp    $0xffffffff,%edx
801047fd:	75 f1                	jne    801047f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047ff:	5b                   	pop    %ebx
80104800:	5e                   	pop    %esi
80104801:	5d                   	pop    %ebp
80104802:	c3                   	ret    
80104803:	90                   	nop
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104808:	31 d2                	xor    %edx,%edx
8010480a:	85 f6                	test   %esi,%esi
8010480c:	74 f1                	je     801047ff <memmove+0x2f>
8010480e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104810:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104814:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104817:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010481a:	39 d6                	cmp    %edx,%esi
8010481c:	75 f2                	jne    80104810 <memmove+0x40>
}
8010481e:	5b                   	pop    %ebx
8010481f:	5e                   	pop    %esi
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    
80104822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104833:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104834:	eb 9a                	jmp    801047d0 <memmove>
80104836:	8d 76 00             	lea    0x0(%esi),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	8b 7d 10             	mov    0x10(%ebp),%edi
80104848:	53                   	push   %ebx
80104849:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010484c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010484f:	85 ff                	test   %edi,%edi
80104851:	74 2f                	je     80104882 <strncmp+0x42>
80104853:	0f b6 01             	movzbl (%ecx),%eax
80104856:	0f b6 1e             	movzbl (%esi),%ebx
80104859:	84 c0                	test   %al,%al
8010485b:	74 37                	je     80104894 <strncmp+0x54>
8010485d:	38 c3                	cmp    %al,%bl
8010485f:	75 33                	jne    80104894 <strncmp+0x54>
80104861:	01 f7                	add    %esi,%edi
80104863:	eb 13                	jmp    80104878 <strncmp+0x38>
80104865:	8d 76 00             	lea    0x0(%esi),%esi
80104868:	0f b6 01             	movzbl (%ecx),%eax
8010486b:	84 c0                	test   %al,%al
8010486d:	74 21                	je     80104890 <strncmp+0x50>
8010486f:	0f b6 1a             	movzbl (%edx),%ebx
80104872:	89 d6                	mov    %edx,%esi
80104874:	38 d8                	cmp    %bl,%al
80104876:	75 1c                	jne    80104894 <strncmp+0x54>
    n--, p++, q++;
80104878:	8d 56 01             	lea    0x1(%esi),%edx
8010487b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010487e:	39 fa                	cmp    %edi,%edx
80104880:	75 e6                	jne    80104868 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104882:	5b                   	pop    %ebx
    return 0;
80104883:	31 c0                	xor    %eax,%eax
}
80104885:	5e                   	pop    %esi
80104886:	5f                   	pop    %edi
80104887:	5d                   	pop    %ebp
80104888:	c3                   	ret    
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104890:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104894:	29 d8                	sub    %ebx,%eax
}
80104896:	5b                   	pop    %ebx
80104897:	5e                   	pop    %esi
80104898:	5f                   	pop    %edi
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	90                   	nop
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 45 08             	mov    0x8(%ebp),%eax
801048a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048ae:	89 c2                	mov    %eax,%edx
801048b0:	eb 19                	jmp    801048cb <strncpy+0x2b>
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048b8:	83 c3 01             	add    $0x1,%ebx
801048bb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801048bf:	83 c2 01             	add    $0x1,%edx
801048c2:	84 c9                	test   %cl,%cl
801048c4:	88 4a ff             	mov    %cl,-0x1(%edx)
801048c7:	74 09                	je     801048d2 <strncpy+0x32>
801048c9:	89 f1                	mov    %esi,%ecx
801048cb:	85 c9                	test   %ecx,%ecx
801048cd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801048d0:	7f e6                	jg     801048b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801048d2:	31 c9                	xor    %ecx,%ecx
801048d4:	85 f6                	test   %esi,%esi
801048d6:	7e 17                	jle    801048ef <strncpy+0x4f>
801048d8:	90                   	nop
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048e0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048e4:	89 f3                	mov    %esi,%ebx
801048e6:	83 c1 01             	add    $0x1,%ecx
801048e9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048eb:	85 db                	test   %ebx,%ebx
801048ed:	7f f1                	jg     801048e0 <strncpy+0x40>
  return os;
}
801048ef:	5b                   	pop    %ebx
801048f0:	5e                   	pop    %esi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104908:	8b 45 08             	mov    0x8(%ebp),%eax
8010490b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010490e:	85 c9                	test   %ecx,%ecx
80104910:	7e 26                	jle    80104938 <safestrcpy+0x38>
80104912:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104916:	89 c1                	mov    %eax,%ecx
80104918:	eb 17                	jmp    80104931 <safestrcpy+0x31>
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104920:	83 c2 01             	add    $0x1,%edx
80104923:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104927:	83 c1 01             	add    $0x1,%ecx
8010492a:	84 db                	test   %bl,%bl
8010492c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010492f:	74 04                	je     80104935 <safestrcpy+0x35>
80104931:	39 f2                	cmp    %esi,%edx
80104933:	75 eb                	jne    80104920 <safestrcpy+0x20>
    ;
  *s = 0;
80104935:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104938:	5b                   	pop    %ebx
80104939:	5e                   	pop    %esi
8010493a:	5d                   	pop    %ebp
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <strlen>:

int
strlen(const char *s)
{
80104940:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104941:	31 c0                	xor    %eax,%eax
{
80104943:	89 e5                	mov    %esp,%ebp
80104945:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104948:	80 3a 00             	cmpb   $0x0,(%edx)
8010494b:	74 0c                	je     80104959 <strlen+0x19>
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
80104950:	83 c0 01             	add    $0x1,%eax
80104953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104957:	75 f7                	jne    80104950 <strlen+0x10>
    ;
  return n;
}
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    

8010495b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010495b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010495f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104963:	55                   	push   %ebp
  pushl %ebx
80104964:	53                   	push   %ebx
  pushl %esi
80104965:	56                   	push   %esi
  pushl %edi
80104966:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104967:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104969:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010496b:	5f                   	pop    %edi
  popl %esi
8010496c:	5e                   	pop    %esi
  popl %ebx
8010496d:	5b                   	pop    %ebx
  popl %ebp
8010496e:	5d                   	pop    %ebp
  ret
8010496f:	c3                   	ret    

80104970 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010497a:	e8 e1 f0 ff ff       	call   80103a60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010497f:	8b 00                	mov    (%eax),%eax
80104981:	39 d8                	cmp    %ebx,%eax
80104983:	76 1b                	jbe    801049a0 <fetchint+0x30>
80104985:	8d 53 04             	lea    0x4(%ebx),%edx
80104988:	39 d0                	cmp    %edx,%eax
8010498a:	72 14                	jb     801049a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010498c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498f:	8b 13                	mov    (%ebx),%edx
80104991:	89 10                	mov    %edx,(%eax)
  return 0;
80104993:	31 c0                	xor    %eax,%eax
}
80104995:	83 c4 04             	add    $0x4,%esp
80104998:	5b                   	pop    %ebx
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret    
8010499b:	90                   	nop
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a5:	eb ee                	jmp    80104995 <fetchint+0x25>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	83 ec 04             	sub    $0x4,%esp
801049b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049ba:	e8 a1 f0 ff ff       	call   80103a60 <myproc>

  if(addr >= curproc->sz)
801049bf:	39 18                	cmp    %ebx,(%eax)
801049c1:	76 29                	jbe    801049ec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049c6:	89 da                	mov    %ebx,%edx
801049c8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801049ca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801049cc:	39 c3                	cmp    %eax,%ebx
801049ce:	73 1c                	jae    801049ec <fetchstr+0x3c>
    if(*s == 0)
801049d0:	80 3b 00             	cmpb   $0x0,(%ebx)
801049d3:	75 10                	jne    801049e5 <fetchstr+0x35>
801049d5:	eb 39                	jmp    80104a10 <fetchstr+0x60>
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049e0:	80 3a 00             	cmpb   $0x0,(%edx)
801049e3:	74 1b                	je     80104a00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049e5:	83 c2 01             	add    $0x1,%edx
801049e8:	39 d0                	cmp    %edx,%eax
801049ea:	77 f4                	ja     801049e0 <fetchstr+0x30>
    return -1;
801049ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801049f1:	83 c4 04             	add    $0x4,%esp
801049f4:	5b                   	pop    %ebx
801049f5:	5d                   	pop    %ebp
801049f6:	c3                   	ret    
801049f7:	89 f6                	mov    %esi,%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a00:	83 c4 04             	add    $0x4,%esp
80104a03:	89 d0                	mov    %edx,%eax
80104a05:	29 d8                	sub    %ebx,%eax
80104a07:	5b                   	pop    %ebx
80104a08:	5d                   	pop    %ebp
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104a10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104a12:	eb dd                	jmp    801049f1 <fetchstr+0x41>
80104a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a25:	e8 36 f0 ff ff       	call   80103a60 <myproc>
80104a2a:	8b 40 18             	mov    0x18(%eax),%eax
80104a2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a30:	8b 40 44             	mov    0x44(%eax),%eax
80104a33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a36:	e8 25 f0 ff ff       	call   80103a60 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a40:	39 c6                	cmp    %eax,%esi
80104a42:	73 1c                	jae    80104a60 <argint+0x40>
80104a44:	8d 53 08             	lea    0x8(%ebx),%edx
80104a47:	39 d0                	cmp    %edx,%eax
80104a49:	72 15                	jb     80104a60 <argint+0x40>
  *ip = *(int*)(addr);
80104a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a51:	89 10                	mov    %edx,(%eax)
  return 0;
80104a53:	31 c0                	xor    %eax,%eax
}
80104a55:	5b                   	pop    %ebx
80104a56:	5e                   	pop    %esi
80104a57:	5d                   	pop    %ebp
80104a58:	c3                   	ret    
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	eb ee                	jmp    80104a55 <argint+0x35>
80104a67:	89 f6                	mov    %esi,%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	83 ec 10             	sub    $0x10,%esp
80104a78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a7b:	e8 e0 ef ff ff       	call   80103a60 <myproc>
80104a80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a85:	83 ec 08             	sub    $0x8,%esp
80104a88:	50                   	push   %eax
80104a89:	ff 75 08             	pushl  0x8(%ebp)
80104a8c:	e8 8f ff ff ff       	call   80104a20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a91:	83 c4 10             	add    $0x10,%esp
80104a94:	85 c0                	test   %eax,%eax
80104a96:	78 28                	js     80104ac0 <argptr+0x50>
80104a98:	85 db                	test   %ebx,%ebx
80104a9a:	78 24                	js     80104ac0 <argptr+0x50>
80104a9c:	8b 16                	mov    (%esi),%edx
80104a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa1:	39 c2                	cmp    %eax,%edx
80104aa3:	76 1b                	jbe    80104ac0 <argptr+0x50>
80104aa5:	01 c3                	add    %eax,%ebx
80104aa7:	39 da                	cmp    %ebx,%edx
80104aa9:	72 15                	jb     80104ac0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104aab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aae:	89 02                	mov    %eax,(%edx)
  return 0;
80104ab0:	31 c0                	xor    %eax,%eax
}
80104ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab5:	5b                   	pop    %ebx
80104ab6:	5e                   	pop    %esi
80104ab7:	5d                   	pop    %ebp
80104ab8:	c3                   	ret    
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb eb                	jmp    80104ab2 <argptr+0x42>
80104ac7:	89 f6                	mov    %esi,%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ad9:	50                   	push   %eax
80104ada:	ff 75 08             	pushl  0x8(%ebp)
80104add:	e8 3e ff ff ff       	call   80104a20 <argint>
80104ae2:	83 c4 10             	add    $0x10,%esp
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	78 17                	js     80104b00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ae9:	83 ec 08             	sub    $0x8,%esp
80104aec:	ff 75 0c             	pushl  0xc(%ebp)
80104aef:	ff 75 f4             	pushl  -0xc(%ebp)
80104af2:	e8 b9 fe ff ff       	call   801049b0 <fetchstr>
80104af7:	83 c4 10             	add    $0x10,%esp
}
80104afa:	c9                   	leave  
80104afb:	c3                   	ret    
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b05:	c9                   	leave  
80104b06:	c3                   	ret    
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <syscall>:
[SYS_get_free_frame_cnt] sys_get_free_frame_cnt,
};

void
syscall(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b17:	e8 44 ef ff ff       	call   80103a60 <myproc>
80104b1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b1e:	8b 40 18             	mov    0x18(%eax),%eax
80104b21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b27:	83 fa 16             	cmp    $0x16,%edx
80104b2a:	77 1c                	ja     80104b48 <syscall+0x38>
80104b2c:	8b 14 85 a0 7a 10 80 	mov    -0x7fef8560(,%eax,4),%edx
80104b33:	85 d2                	test   %edx,%edx
80104b35:	74 11                	je     80104b48 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b37:	ff d2                	call   *%edx
80104b39:	8b 53 18             	mov    0x18(%ebx),%edx
80104b3c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b42:	c9                   	leave  
80104b43:	c3                   	ret    
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b4c:	50                   	push   %eax
80104b4d:	ff 73 10             	pushl  0x10(%ebx)
80104b50:	68 6d 7a 10 80       	push   $0x80107a6d
80104b55:	e8 06 bb ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104b5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b6a:	c9                   	leave  
80104b6b:	c3                   	ret    
80104b6c:	66 90                	xchg   %ax,%ax
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b76:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104b79:	83 ec 44             	sub    $0x44,%esp
80104b7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b82:	56                   	push   %esi
80104b83:	50                   	push   %eax
{
80104b84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b87:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b8a:	e8 81 d3 ff ff       	call   80101f10 <nameiparent>
80104b8f:	83 c4 10             	add    $0x10,%esp
80104b92:	85 c0                	test   %eax,%eax
80104b94:	0f 84 46 01 00 00    	je     80104ce0 <create+0x170>
    return 0;
  ilock(dp);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	89 c3                	mov    %eax,%ebx
80104b9f:	50                   	push   %eax
80104ba0:	e8 eb ca ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ba5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ba8:	83 c4 0c             	add    $0xc,%esp
80104bab:	50                   	push   %eax
80104bac:	56                   	push   %esi
80104bad:	53                   	push   %ebx
80104bae:	e8 0d d0 ff ff       	call   80101bc0 <dirlookup>
80104bb3:	83 c4 10             	add    $0x10,%esp
80104bb6:	85 c0                	test   %eax,%eax
80104bb8:	89 c7                	mov    %eax,%edi
80104bba:	74 34                	je     80104bf0 <create+0x80>
    iunlockput(dp);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	53                   	push   %ebx
80104bc0:	e8 5b cd ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104bc5:	89 3c 24             	mov    %edi,(%esp)
80104bc8:	e8 c3 ca ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104bd5:	0f 85 95 00 00 00    	jne    80104c70 <create+0x100>
80104bdb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104be0:	0f 85 8a 00 00 00    	jne    80104c70 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be9:	89 f8                	mov    %edi,%eax
80104beb:	5b                   	pop    %ebx
80104bec:	5e                   	pop    %esi
80104bed:	5f                   	pop    %edi
80104bee:	5d                   	pop    %ebp
80104bef:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104bf0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	50                   	push   %eax
80104bf8:	ff 33                	pushl  (%ebx)
80104bfa:	e8 21 c9 ff ff       	call   80101520 <ialloc>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	85 c0                	test   %eax,%eax
80104c04:	89 c7                	mov    %eax,%edi
80104c06:	0f 84 e8 00 00 00    	je     80104cf4 <create+0x184>
  ilock(ip);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	50                   	push   %eax
80104c10:	e8 7b ca ff ff       	call   80101690 <ilock>
  ip->major = major;
80104c15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c25:	b8 01 00 00 00       	mov    $0x1,%eax
80104c2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c2e:	89 3c 24             	mov    %edi,(%esp)
80104c31:	e8 aa c9 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c3e:	74 50                	je     80104c90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c40:	83 ec 04             	sub    $0x4,%esp
80104c43:	ff 77 04             	pushl  0x4(%edi)
80104c46:	56                   	push   %esi
80104c47:	53                   	push   %ebx
80104c48:	e8 e3 d1 ff ff       	call   80101e30 <dirlink>
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	85 c0                	test   %eax,%eax
80104c52:	0f 88 8f 00 00 00    	js     80104ce7 <create+0x177>
  iunlockput(dp);
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	53                   	push   %ebx
80104c5c:	e8 bf cc ff ff       	call   80101920 <iunlockput>
  return ip;
80104c61:	83 c4 10             	add    $0x10,%esp
}
80104c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c67:	89 f8                	mov    %edi,%eax
80104c69:	5b                   	pop    %ebx
80104c6a:	5e                   	pop    %esi
80104c6b:	5f                   	pop    %edi
80104c6c:	5d                   	pop    %ebp
80104c6d:	c3                   	ret    
80104c6e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	57                   	push   %edi
    return 0;
80104c74:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104c76:	e8 a5 cc ff ff       	call   80101920 <iunlockput>
    return 0;
80104c7b:	83 c4 10             	add    $0x10,%esp
}
80104c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c81:	89 f8                	mov    %edi,%eax
80104c83:	5b                   	pop    %ebx
80104c84:	5e                   	pop    %esi
80104c85:	5f                   	pop    %edi
80104c86:	5d                   	pop    %ebp
80104c87:	c3                   	ret    
80104c88:	90                   	nop
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104c90:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c95:	83 ec 0c             	sub    $0xc,%esp
80104c98:	53                   	push   %ebx
80104c99:	e8 42 c9 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c9e:	83 c4 0c             	add    $0xc,%esp
80104ca1:	ff 77 04             	pushl  0x4(%edi)
80104ca4:	68 1c 7b 10 80       	push   $0x80107b1c
80104ca9:	57                   	push   %edi
80104caa:	e8 81 d1 ff ff       	call   80101e30 <dirlink>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	78 1c                	js     80104cd2 <create+0x162>
80104cb6:	83 ec 04             	sub    $0x4,%esp
80104cb9:	ff 73 04             	pushl  0x4(%ebx)
80104cbc:	68 1b 7b 10 80       	push   $0x80107b1b
80104cc1:	57                   	push   %edi
80104cc2:	e8 69 d1 ff ff       	call   80101e30 <dirlink>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	0f 89 6e ff ff ff    	jns    80104c40 <create+0xd0>
      panic("create dots");
80104cd2:	83 ec 0c             	sub    $0xc,%esp
80104cd5:	68 0f 7b 10 80       	push   $0x80107b0f
80104cda:	e8 b1 b6 ff ff       	call   80100390 <panic>
80104cdf:	90                   	nop
    return 0;
80104ce0:	31 ff                	xor    %edi,%edi
80104ce2:	e9 ff fe ff ff       	jmp    80104be6 <create+0x76>
    panic("create: dirlink");
80104ce7:	83 ec 0c             	sub    $0xc,%esp
80104cea:	68 1e 7b 10 80       	push   $0x80107b1e
80104cef:	e8 9c b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	68 00 7b 10 80       	push   $0x80107b00
80104cfc:	e8 8f b6 ff ff       	call   80100390 <panic>
80104d01:	eb 0d                	jmp    80104d10 <argfd.constprop.0>
80104d03:	90                   	nop
80104d04:	90                   	nop
80104d05:	90                   	nop
80104d06:	90                   	nop
80104d07:	90                   	nop
80104d08:	90                   	nop
80104d09:	90                   	nop
80104d0a:	90                   	nop
80104d0b:	90                   	nop
80104d0c:	90                   	nop
80104d0d:	90                   	nop
80104d0e:	90                   	nop
80104d0f:	90                   	nop

80104d10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d1a:	89 d6                	mov    %edx,%esi
80104d1c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d1f:	50                   	push   %eax
80104d20:	6a 00                	push   $0x0
80104d22:	e8 f9 fc ff ff       	call   80104a20 <argint>
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	78 2a                	js     80104d58 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d32:	77 24                	ja     80104d58 <argfd.constprop.0+0x48>
80104d34:	e8 27 ed ff ff       	call   80103a60 <myproc>
80104d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d3c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d40:	85 c0                	test   %eax,%eax
80104d42:	74 14                	je     80104d58 <argfd.constprop.0+0x48>
  if(pfd)
80104d44:	85 db                	test   %ebx,%ebx
80104d46:	74 02                	je     80104d4a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d48:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d4a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d4c:	31 c0                	xor    %eax,%eax
}
80104d4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d51:	5b                   	pop    %ebx
80104d52:	5e                   	pop    %esi
80104d53:	5d                   	pop    %ebp
80104d54:	c3                   	ret    
80104d55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d5d:	eb ef                	jmp    80104d4e <argfd.constprop.0+0x3e>
80104d5f:	90                   	nop

80104d60 <sys_dup>:
{
80104d60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d61:	31 c0                	xor    %eax,%eax
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	56                   	push   %esi
80104d66:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d67:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d6a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d6d:	e8 9e ff ff ff       	call   80104d10 <argfd.constprop.0>
80104d72:	85 c0                	test   %eax,%eax
80104d74:	78 42                	js     80104db8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104d76:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d79:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d7b:	e8 e0 ec ff ff       	call   80103a60 <myproc>
80104d80:	eb 0e                	jmp    80104d90 <sys_dup+0x30>
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d88:	83 c3 01             	add    $0x1,%ebx
80104d8b:	83 fb 10             	cmp    $0x10,%ebx
80104d8e:	74 28                	je     80104db8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d94:	85 d2                	test   %edx,%edx
80104d96:	75 f0                	jne    80104d88 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d98:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104da2:	e8 49 c0 ff ff       	call   80100df0 <filedup>
  return fd;
80104da7:	83 c4 10             	add    $0x10,%esp
}
80104daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dad:	89 d8                	mov    %ebx,%eax
80104daf:	5b                   	pop    %ebx
80104db0:	5e                   	pop    %esi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	90                   	nop
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104db8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104dc0:	89 d8                	mov    %ebx,%eax
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
80104dc5:	c3                   	ret    
80104dc6:	8d 76 00             	lea    0x0(%esi),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <sys_read>:
{
80104dd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd1:	31 c0                	xor    %eax,%eax
{
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ddb:	e8 30 ff ff ff       	call   80104d10 <argfd.constprop.0>
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 4c                	js     80104e30 <sys_read+0x60>
80104de4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104de7:	83 ec 08             	sub    $0x8,%esp
80104dea:	50                   	push   %eax
80104deb:	6a 02                	push   $0x2
80104ded:	e8 2e fc ff ff       	call   80104a20 <argint>
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	85 c0                	test   %eax,%eax
80104df7:	78 37                	js     80104e30 <sys_read+0x60>
80104df9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dfc:	83 ec 04             	sub    $0x4,%esp
80104dff:	ff 75 f0             	pushl  -0x10(%ebp)
80104e02:	50                   	push   %eax
80104e03:	6a 01                	push   $0x1
80104e05:	e8 66 fc ff ff       	call   80104a70 <argptr>
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	78 1f                	js     80104e30 <sys_read+0x60>
  return fileread(f, p, n);
80104e11:	83 ec 04             	sub    $0x4,%esp
80104e14:	ff 75 f0             	pushl  -0x10(%ebp)
80104e17:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e1d:	e8 3e c1 ff ff       	call   80100f60 <fileread>
80104e22:	83 c4 10             	add    $0x10,%esp
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <sys_write>:
{
80104e40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e41:	31 c0                	xor    %eax,%eax
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e4b:	e8 c0 fe ff ff       	call   80104d10 <argfd.constprop.0>
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 4c                	js     80104ea0 <sys_write+0x60>
80104e54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e57:	83 ec 08             	sub    $0x8,%esp
80104e5a:	50                   	push   %eax
80104e5b:	6a 02                	push   $0x2
80104e5d:	e8 be fb ff ff       	call   80104a20 <argint>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 37                	js     80104ea0 <sys_write+0x60>
80104e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e6c:	83 ec 04             	sub    $0x4,%esp
80104e6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e72:	50                   	push   %eax
80104e73:	6a 01                	push   $0x1
80104e75:	e8 f6 fb ff ff       	call   80104a70 <argptr>
80104e7a:	83 c4 10             	add    $0x10,%esp
80104e7d:	85 c0                	test   %eax,%eax
80104e7f:	78 1f                	js     80104ea0 <sys_write+0x60>
  return filewrite(f, p, n);
80104e81:	83 ec 04             	sub    $0x4,%esp
80104e84:	ff 75 f0             	pushl  -0x10(%ebp)
80104e87:	ff 75 f4             	pushl  -0xc(%ebp)
80104e8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e8d:	e8 5e c1 ff ff       	call   80100ff0 <filewrite>
80104e92:	83 c4 10             	add    $0x10,%esp
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <sys_close>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104eb6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104eb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ebc:	e8 4f fe ff ff       	call   80104d10 <argfd.constprop.0>
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	78 2b                	js     80104ef0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ec5:	e8 96 eb ff ff       	call   80103a60 <myproc>
80104eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104ecd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ed0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ed7:	00 
  fileclose(f);
80104ed8:	ff 75 f4             	pushl  -0xc(%ebp)
80104edb:	e8 60 bf ff ff       	call   80100e40 <fileclose>
  return 0;
80104ee0:	83 c4 10             	add    $0x10,%esp
80104ee3:	31 c0                	xor    %eax,%eax
}
80104ee5:	c9                   	leave  
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <sys_fstat>:
{
80104f00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f01:	31 c0                	xor    %eax,%eax
{
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f0b:	e8 00 fe ff ff       	call   80104d10 <argfd.constprop.0>
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 2c                	js     80104f40 <sys_fstat+0x40>
80104f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f17:	83 ec 04             	sub    $0x4,%esp
80104f1a:	6a 14                	push   $0x14
80104f1c:	50                   	push   %eax
80104f1d:	6a 01                	push   $0x1
80104f1f:	e8 4c fb ff ff       	call   80104a70 <argptr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	78 15                	js     80104f40 <sys_fstat+0x40>
  return filestat(f, st);
80104f2b:	83 ec 08             	sub    $0x8,%esp
80104f2e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f31:	ff 75 f0             	pushl  -0x10(%ebp)
80104f34:	e8 d7 bf ff ff       	call   80100f10 <filestat>
80104f39:	83 c4 10             	add    $0x10,%esp
}
80104f3c:	c9                   	leave  
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <sys_link>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f56:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f59:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f5c:	50                   	push   %eax
80104f5d:	6a 00                	push   $0x0
80104f5f:	e8 6c fb ff ff       	call   80104ad0 <argstr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	0f 88 fb 00 00 00    	js     8010506a <sys_link+0x11a>
80104f6f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f72:	83 ec 08             	sub    $0x8,%esp
80104f75:	50                   	push   %eax
80104f76:	6a 01                	push   $0x1
80104f78:	e8 53 fb ff ff       	call   80104ad0 <argstr>
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	85 c0                	test   %eax,%eax
80104f82:	0f 88 e2 00 00 00    	js     8010506a <sys_link+0x11a>
  begin_op();
80104f88:	e8 73 de ff ff       	call   80102e00 <begin_op>
  if((ip = namei(old)) == 0){
80104f8d:	83 ec 0c             	sub    $0xc,%esp
80104f90:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f93:	e8 58 cf ff ff       	call   80101ef0 <namei>
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	89 c3                	mov    %eax,%ebx
80104f9f:	0f 84 ea 00 00 00    	je     8010508f <sys_link+0x13f>
  ilock(ip);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	50                   	push   %eax
80104fa9:	e8 e2 c6 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fb6:	0f 84 bb 00 00 00    	je     80105077 <sys_link+0x127>
  ip->nlink++;
80104fbc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fc1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104fc4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fc7:	53                   	push   %ebx
80104fc8:	e8 13 c6 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104fcd:	89 1c 24             	mov    %ebx,(%esp)
80104fd0:	e8 9b c7 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fd5:	58                   	pop    %eax
80104fd6:	5a                   	pop    %edx
80104fd7:	57                   	push   %edi
80104fd8:	ff 75 d0             	pushl  -0x30(%ebp)
80104fdb:	e8 30 cf ff ff       	call   80101f10 <nameiparent>
80104fe0:	83 c4 10             	add    $0x10,%esp
80104fe3:	85 c0                	test   %eax,%eax
80104fe5:	89 c6                	mov    %eax,%esi
80104fe7:	74 5b                	je     80105044 <sys_link+0xf4>
  ilock(dp);
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	50                   	push   %eax
80104fed:	e8 9e c6 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	8b 03                	mov    (%ebx),%eax
80104ff7:	39 06                	cmp    %eax,(%esi)
80104ff9:	75 3d                	jne    80105038 <sys_link+0xe8>
80104ffb:	83 ec 04             	sub    $0x4,%esp
80104ffe:	ff 73 04             	pushl  0x4(%ebx)
80105001:	57                   	push   %edi
80105002:	56                   	push   %esi
80105003:	e8 28 ce ff ff       	call   80101e30 <dirlink>
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	85 c0                	test   %eax,%eax
8010500d:	78 29                	js     80105038 <sys_link+0xe8>
  iunlockput(dp);
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	56                   	push   %esi
80105013:	e8 08 c9 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105018:	89 1c 24             	mov    %ebx,(%esp)
8010501b:	e8 a0 c7 ff ff       	call   801017c0 <iput>
  end_op();
80105020:	e8 4b de ff ff       	call   80102e70 <end_op>
  return 0;
80105025:	83 c4 10             	add    $0x10,%esp
80105028:	31 c0                	xor    %eax,%eax
}
8010502a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010502d:	5b                   	pop    %ebx
8010502e:	5e                   	pop    %esi
8010502f:	5f                   	pop    %edi
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret    
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105038:	83 ec 0c             	sub    $0xc,%esp
8010503b:	56                   	push   %esi
8010503c:	e8 df c8 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105041:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	53                   	push   %ebx
80105048:	e8 43 c6 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010504d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105052:	89 1c 24             	mov    %ebx,(%esp)
80105055:	e8 86 c5 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010505a:	89 1c 24             	mov    %ebx,(%esp)
8010505d:	e8 be c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105062:	e8 09 de ff ff       	call   80102e70 <end_op>
  return -1;
80105067:	83 c4 10             	add    $0x10,%esp
}
8010506a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010506d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5f                   	pop    %edi
80105075:	5d                   	pop    %ebp
80105076:	c3                   	ret    
    iunlockput(ip);
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	53                   	push   %ebx
8010507b:	e8 a0 c8 ff ff       	call   80101920 <iunlockput>
    end_op();
80105080:	e8 eb dd ff ff       	call   80102e70 <end_op>
    return -1;
80105085:	83 c4 10             	add    $0x10,%esp
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb 9b                	jmp    8010502a <sys_link+0xda>
    end_op();
8010508f:	e8 dc dd ff ff       	call   80102e70 <end_op>
    return -1;
80105094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105099:	eb 8f                	jmp    8010502a <sys_link+0xda>
8010509b:	90                   	nop
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_unlink>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801050a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 1c fa ff ff       	call   80104ad0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 77 01 00 00    	js     80105236 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801050bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801050c2:	e8 39 dd ff ff       	call   80102e00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050c7:	83 ec 08             	sub    $0x8,%esp
801050ca:	53                   	push   %ebx
801050cb:	ff 75 c0             	pushl  -0x40(%ebp)
801050ce:	e8 3d ce ff ff       	call   80101f10 <nameiparent>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	89 c6                	mov    %eax,%esi
801050da:	0f 84 60 01 00 00    	je     80105240 <sys_unlink+0x1a0>
  ilock(dp);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	50                   	push   %eax
801050e4:	e8 a7 c5 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050e9:	58                   	pop    %eax
801050ea:	5a                   	pop    %edx
801050eb:	68 1c 7b 10 80       	push   $0x80107b1c
801050f0:	53                   	push   %ebx
801050f1:	e8 aa ca ff ff       	call   80101ba0 <namecmp>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	0f 84 03 01 00 00    	je     80105204 <sys_unlink+0x164>
80105101:	83 ec 08             	sub    $0x8,%esp
80105104:	68 1b 7b 10 80       	push   $0x80107b1b
80105109:	53                   	push   %ebx
8010510a:	e8 91 ca ff ff       	call   80101ba0 <namecmp>
8010510f:	83 c4 10             	add    $0x10,%esp
80105112:	85 c0                	test   %eax,%eax
80105114:	0f 84 ea 00 00 00    	je     80105204 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010511a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010511d:	83 ec 04             	sub    $0x4,%esp
80105120:	50                   	push   %eax
80105121:	53                   	push   %ebx
80105122:	56                   	push   %esi
80105123:	e8 98 ca ff ff       	call   80101bc0 <dirlookup>
80105128:	83 c4 10             	add    $0x10,%esp
8010512b:	85 c0                	test   %eax,%eax
8010512d:	89 c3                	mov    %eax,%ebx
8010512f:	0f 84 cf 00 00 00    	je     80105204 <sys_unlink+0x164>
  ilock(ip);
80105135:	83 ec 0c             	sub    $0xc,%esp
80105138:	50                   	push   %eax
80105139:	e8 52 c5 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105146:	0f 8e 10 01 00 00    	jle    8010525c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010514c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105151:	74 6d                	je     801051c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105153:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105156:	83 ec 04             	sub    $0x4,%esp
80105159:	6a 10                	push   $0x10
8010515b:	6a 00                	push   $0x0
8010515d:	50                   	push   %eax
8010515e:	e8 bd f5 ff ff       	call   80104720 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105163:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105166:	6a 10                	push   $0x10
80105168:	ff 75 c4             	pushl  -0x3c(%ebp)
8010516b:	50                   	push   %eax
8010516c:	56                   	push   %esi
8010516d:	e8 fe c8 ff ff       	call   80101a70 <writei>
80105172:	83 c4 20             	add    $0x20,%esp
80105175:	83 f8 10             	cmp    $0x10,%eax
80105178:	0f 85 eb 00 00 00    	jne    80105269 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010517e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105183:	0f 84 97 00 00 00    	je     80105220 <sys_unlink+0x180>
  iunlockput(dp);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	56                   	push   %esi
8010518d:	e8 8e c7 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105192:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105197:	89 1c 24             	mov    %ebx,(%esp)
8010519a:	e8 41 c4 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010519f:	89 1c 24             	mov    %ebx,(%esp)
801051a2:	e8 79 c7 ff ff       	call   80101920 <iunlockput>
  end_op();
801051a7:	e8 c4 dc ff ff       	call   80102e70 <end_op>
  return 0;
801051ac:	83 c4 10             	add    $0x10,%esp
801051af:	31 c0                	xor    %eax,%eax
}
801051b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051b4:	5b                   	pop    %ebx
801051b5:	5e                   	pop    %esi
801051b6:	5f                   	pop    %edi
801051b7:	5d                   	pop    %ebp
801051b8:	c3                   	ret    
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051c4:	76 8d                	jbe    80105153 <sys_unlink+0xb3>
801051c6:	bf 20 00 00 00       	mov    $0x20,%edi
801051cb:	eb 0f                	jmp    801051dc <sys_unlink+0x13c>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c7 10             	add    $0x10,%edi
801051d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801051d6:	0f 83 77 ff ff ff    	jae    80105153 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051df:	6a 10                	push   $0x10
801051e1:	57                   	push   %edi
801051e2:	50                   	push   %eax
801051e3:	53                   	push   %ebx
801051e4:	e8 87 c7 ff ff       	call   80101970 <readi>
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	83 f8 10             	cmp    $0x10,%eax
801051ef:	75 5e                	jne    8010524f <sys_unlink+0x1af>
    if(de.inum != 0)
801051f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051f6:	74 d8                	je     801051d0 <sys_unlink+0x130>
    iunlockput(ip);
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	53                   	push   %ebx
801051fc:	e8 1f c7 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105201:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	56                   	push   %esi
80105208:	e8 13 c7 ff ff       	call   80101920 <iunlockput>
  end_op();
8010520d:	e8 5e dc ff ff       	call   80102e70 <end_op>
  return -1;
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521a:	eb 95                	jmp    801051b1 <sys_unlink+0x111>
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105220:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	56                   	push   %esi
80105229:	e8 b2 c3 ff ff       	call   801015e0 <iupdate>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	e9 53 ff ff ff       	jmp    80105189 <sys_unlink+0xe9>
    return -1;
80105236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523b:	e9 71 ff ff ff       	jmp    801051b1 <sys_unlink+0x111>
    end_op();
80105240:	e8 2b dc ff ff       	call   80102e70 <end_op>
    return -1;
80105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524a:	e9 62 ff ff ff       	jmp    801051b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	68 40 7b 10 80       	push   $0x80107b40
80105257:	e8 34 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010525c:	83 ec 0c             	sub    $0xc,%esp
8010525f:	68 2e 7b 10 80       	push   $0x80107b2e
80105264:	e8 27 b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105269:	83 ec 0c             	sub    $0xc,%esp
8010526c:	68 52 7b 10 80       	push   $0x80107b52
80105271:	e8 1a b1 ff ff       	call   80100390 <panic>
80105276:	8d 76 00             	lea    0x0(%esi),%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_open>:

int
sys_open(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105286:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105289:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010528c:	50                   	push   %eax
8010528d:	6a 00                	push   $0x0
8010528f:	e8 3c f8 ff ff       	call   80104ad0 <argstr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	0f 88 1d 01 00 00    	js     801053bc <sys_open+0x13c>
8010529f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052a2:	83 ec 08             	sub    $0x8,%esp
801052a5:	50                   	push   %eax
801052a6:	6a 01                	push   $0x1
801052a8:	e8 73 f7 ff ff       	call   80104a20 <argint>
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	85 c0                	test   %eax,%eax
801052b2:	0f 88 04 01 00 00    	js     801053bc <sys_open+0x13c>
    return -1;

  begin_op();
801052b8:	e8 43 db ff ff       	call   80102e00 <begin_op>

  if(omode & O_CREATE){
801052bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052c1:	0f 85 a9 00 00 00    	jne    80105370 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052c7:	83 ec 0c             	sub    $0xc,%esp
801052ca:	ff 75 e0             	pushl  -0x20(%ebp)
801052cd:	e8 1e cc ff ff       	call   80101ef0 <namei>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	85 c0                	test   %eax,%eax
801052d7:	89 c6                	mov    %eax,%esi
801052d9:	0f 84 b2 00 00 00    	je     80105391 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801052df:	83 ec 0c             	sub    $0xc,%esp
801052e2:	50                   	push   %eax
801052e3:	e8 a8 c3 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052f0:	0f 84 aa 00 00 00    	je     801053a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052f6:	e8 85 ba ff ff       	call   80100d80 <filealloc>
801052fb:	85 c0                	test   %eax,%eax
801052fd:	89 c7                	mov    %eax,%edi
801052ff:	0f 84 a6 00 00 00    	je     801053ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105305:	e8 56 e7 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010530a:	31 db                	xor    %ebx,%ebx
8010530c:	eb 0e                	jmp    8010531c <sys_open+0x9c>
8010530e:	66 90                	xchg   %ax,%ax
80105310:	83 c3 01             	add    $0x1,%ebx
80105313:	83 fb 10             	cmp    $0x10,%ebx
80105316:	0f 84 ac 00 00 00    	je     801053c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010531c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105320:	85 d2                	test   %edx,%edx
80105322:	75 ec                	jne    80105310 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105324:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105327:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010532b:	56                   	push   %esi
8010532c:	e8 3f c4 ff ff       	call   80101770 <iunlock>
  end_op();
80105331:	e8 3a db ff ff       	call   80102e70 <end_op>

  f->type = FD_INODE;
80105336:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010533c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010533f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105342:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105345:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010534c:	89 d0                	mov    %edx,%eax
8010534e:	f7 d0                	not    %eax
80105350:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105353:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105356:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105359:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010535d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105360:	89 d8                	mov    %ebx,%eax
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5f                   	pop    %edi
80105365:	5d                   	pop    %ebp
80105366:	c3                   	ret    
80105367:	89 f6                	mov    %esi,%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105376:	31 c9                	xor    %ecx,%ecx
80105378:	6a 00                	push   $0x0
8010537a:	ba 02 00 00 00       	mov    $0x2,%edx
8010537f:	e8 ec f7 ff ff       	call   80104b70 <create>
    if(ip == 0){
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105389:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010538b:	0f 85 65 ff ff ff    	jne    801052f6 <sys_open+0x76>
      end_op();
80105391:	e8 da da ff ff       	call   80102e70 <end_op>
      return -1;
80105396:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010539b:	eb c0                	jmp    8010535d <sys_open+0xdd>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053a3:	85 c9                	test   %ecx,%ecx
801053a5:	0f 84 4b ff ff ff    	je     801052f6 <sys_open+0x76>
    iunlockput(ip);
801053ab:	83 ec 0c             	sub    $0xc,%esp
801053ae:	56                   	push   %esi
801053af:	e8 6c c5 ff ff       	call   80101920 <iunlockput>
    end_op();
801053b4:	e8 b7 da ff ff       	call   80102e70 <end_op>
    return -1;
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053c1:	eb 9a                	jmp    8010535d <sys_open+0xdd>
801053c3:	90                   	nop
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	57                   	push   %edi
801053cc:	e8 6f ba ff ff       	call   80100e40 <fileclose>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	eb d5                	jmp    801053ab <sys_open+0x12b>
801053d6:	8d 76 00             	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053e6:	e8 15 da ff ff       	call   80102e00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ee:	83 ec 08             	sub    $0x8,%esp
801053f1:	50                   	push   %eax
801053f2:	6a 00                	push   $0x0
801053f4:	e8 d7 f6 ff ff       	call   80104ad0 <argstr>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	85 c0                	test   %eax,%eax
801053fe:	78 30                	js     80105430 <sys_mkdir+0x50>
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105406:	31 c9                	xor    %ecx,%ecx
80105408:	6a 00                	push   $0x0
8010540a:	ba 01 00 00 00       	mov    $0x1,%edx
8010540f:	e8 5c f7 ff ff       	call   80104b70 <create>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	74 15                	je     80105430 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010541b:	83 ec 0c             	sub    $0xc,%esp
8010541e:	50                   	push   %eax
8010541f:	e8 fc c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105424:	e8 47 da ff ff       	call   80102e70 <end_op>
  return 0;
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	31 c0                	xor    %eax,%eax
}
8010542e:	c9                   	leave  
8010542f:	c3                   	ret    
    end_op();
80105430:	e8 3b da ff ff       	call   80102e70 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010543a:	c9                   	leave  
8010543b:	c3                   	ret    
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_mknod>:

int
sys_mknod(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105446:	e8 b5 d9 ff ff       	call   80102e00 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010544b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010544e:	83 ec 08             	sub    $0x8,%esp
80105451:	50                   	push   %eax
80105452:	6a 00                	push   $0x0
80105454:	e8 77 f6 ff ff       	call   80104ad0 <argstr>
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	85 c0                	test   %eax,%eax
8010545e:	78 60                	js     801054c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105460:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105463:	83 ec 08             	sub    $0x8,%esp
80105466:	50                   	push   %eax
80105467:	6a 01                	push   $0x1
80105469:	e8 b2 f5 ff ff       	call   80104a20 <argint>
  if((argstr(0, &path)) < 0 ||
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	85 c0                	test   %eax,%eax
80105473:	78 4b                	js     801054c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105475:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105478:	83 ec 08             	sub    $0x8,%esp
8010547b:	50                   	push   %eax
8010547c:	6a 02                	push   $0x2
8010547e:	e8 9d f5 ff ff       	call   80104a20 <argint>
     argint(1, &major) < 0 ||
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	78 36                	js     801054c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010548a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010548e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105491:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105495:	ba 03 00 00 00       	mov    $0x3,%edx
8010549a:	50                   	push   %eax
8010549b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010549e:	e8 cd f6 ff ff       	call   80104b70 <create>
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	74 16                	je     801054c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054aa:	83 ec 0c             	sub    $0xc,%esp
801054ad:	50                   	push   %eax
801054ae:	e8 6d c4 ff ff       	call   80101920 <iunlockput>
  end_op();
801054b3:	e8 b8 d9 ff ff       	call   80102e70 <end_op>
  return 0;
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	31 c0                	xor    %eax,%eax
}
801054bd:	c9                   	leave  
801054be:	c3                   	ret    
801054bf:	90                   	nop
    end_op();
801054c0:	e8 ab d9 ff ff       	call   80102e70 <end_op>
    return -1;
801054c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ca:	c9                   	leave  
801054cb:	c3                   	ret    
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_chdir>:

int
sys_chdir(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	53                   	push   %ebx
801054d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054d8:	e8 83 e5 ff ff       	call   80103a60 <myproc>
801054dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054df:	e8 1c d9 ff ff       	call   80102e00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e7:	83 ec 08             	sub    $0x8,%esp
801054ea:	50                   	push   %eax
801054eb:	6a 00                	push   $0x0
801054ed:	e8 de f5 ff ff       	call   80104ad0 <argstr>
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	85 c0                	test   %eax,%eax
801054f7:	78 77                	js     80105570 <sys_chdir+0xa0>
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	ff 75 f4             	pushl  -0xc(%ebp)
801054ff:	e8 ec c9 ff ff       	call   80101ef0 <namei>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	89 c3                	mov    %eax,%ebx
8010550b:	74 63                	je     80105570 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010550d:	83 ec 0c             	sub    $0xc,%esp
80105510:	50                   	push   %eax
80105511:	e8 7a c1 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010551e:	75 30                	jne    80105550 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	53                   	push   %ebx
80105524:	e8 47 c2 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105529:	58                   	pop    %eax
8010552a:	ff 76 68             	pushl  0x68(%esi)
8010552d:	e8 8e c2 ff ff       	call   801017c0 <iput>
  end_op();
80105532:	e8 39 d9 ff ff       	call   80102e70 <end_op>
  curproc->cwd = ip;
80105537:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	31 c0                	xor    %eax,%eax
}
8010553f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105542:	5b                   	pop    %ebx
80105543:	5e                   	pop    %esi
80105544:	5d                   	pop    %ebp
80105545:	c3                   	ret    
80105546:	8d 76 00             	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	53                   	push   %ebx
80105554:	e8 c7 c3 ff ff       	call   80101920 <iunlockput>
    end_op();
80105559:	e8 12 d9 ff ff       	call   80102e70 <end_op>
    return -1;
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105566:	eb d7                	jmp    8010553f <sys_chdir+0x6f>
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105570:	e8 fb d8 ff ff       	call   80102e70 <end_op>
    return -1;
80105575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557a:	eb c3                	jmp    8010553f <sys_chdir+0x6f>
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_exec>:

int
sys_exec(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105586:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010558c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105592:	50                   	push   %eax
80105593:	6a 00                	push   $0x0
80105595:	e8 36 f5 ff ff       	call   80104ad0 <argstr>
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	85 c0                	test   %eax,%eax
8010559f:	0f 88 87 00 00 00    	js     8010562c <sys_exec+0xac>
801055a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	50                   	push   %eax
801055af:	6a 01                	push   $0x1
801055b1:	e8 6a f4 ff ff       	call   80104a20 <argint>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	78 6f                	js     8010562c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055c3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801055c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055c8:	68 80 00 00 00       	push   $0x80
801055cd:	6a 00                	push   $0x0
801055cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055d5:	50                   	push   %eax
801055d6:	e8 45 f1 ff ff       	call   80104720 <memset>
801055db:	83 c4 10             	add    $0x10,%esp
801055de:	eb 2c                	jmp    8010560c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801055e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055e6:	85 c0                	test   %eax,%eax
801055e8:	74 56                	je     80105640 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055f0:	83 ec 08             	sub    $0x8,%esp
801055f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055f6:	52                   	push   %edx
801055f7:	50                   	push   %eax
801055f8:	e8 b3 f3 ff ff       	call   801049b0 <fetchstr>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	78 28                	js     8010562c <sys_exec+0xac>
  for(i=0;; i++){
80105604:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105607:	83 fb 20             	cmp    $0x20,%ebx
8010560a:	74 20                	je     8010562c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010560c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105612:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105619:	83 ec 08             	sub    $0x8,%esp
8010561c:	57                   	push   %edi
8010561d:	01 f0                	add    %esi,%eax
8010561f:	50                   	push   %eax
80105620:	e8 4b f3 ff ff       	call   80104970 <fetchint>
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	85 c0                	test   %eax,%eax
8010562a:	79 b4                	jns    801055e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010562c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010562f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105634:	5b                   	pop    %ebx
80105635:	5e                   	pop    %esi
80105636:	5f                   	pop    %edi
80105637:	5d                   	pop    %ebp
80105638:	c3                   	ret    
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105640:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105646:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105649:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105650:	00 00 00 00 
  return exec(path, argv);
80105654:	50                   	push   %eax
80105655:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010565b:	e8 b0 b3 ff ff       	call   80100a10 <exec>
80105660:	83 c4 10             	add    $0x10,%esp
}
80105663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	90                   	nop
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_pipe>:

int
sys_pipe(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
80105675:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105676:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105679:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010567c:	6a 08                	push   $0x8
8010567e:	50                   	push   %eax
8010567f:	6a 00                	push   $0x0
80105681:	e8 ea f3 ff ff       	call   80104a70 <argptr>
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	85 c0                	test   %eax,%eax
8010568b:	0f 88 ae 00 00 00    	js     8010573f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105691:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105694:	83 ec 08             	sub    $0x8,%esp
80105697:	50                   	push   %eax
80105698:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010569b:	50                   	push   %eax
8010569c:	e8 1f de ff ff       	call   801034c0 <pipealloc>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	85 c0                	test   %eax,%eax
801056a6:	0f 88 93 00 00 00    	js     8010573f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056b1:	e8 aa e3 ff ff       	call   80103a60 <myproc>
801056b6:	eb 10                	jmp    801056c8 <sys_pipe+0x58>
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c3 01             	add    $0x1,%ebx
801056c3:	83 fb 10             	cmp    $0x10,%ebx
801056c6:	74 60                	je     80105728 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801056c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056cc:	85 f6                	test   %esi,%esi
801056ce:	75 f0                	jne    801056c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801056d0:	8d 73 08             	lea    0x8(%ebx),%esi
801056d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056da:	e8 81 e3 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056df:	31 d2                	xor    %edx,%edx
801056e1:	eb 0d                	jmp    801056f0 <sys_pipe+0x80>
801056e3:	90                   	nop
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e8:	83 c2 01             	add    $0x1,%edx
801056eb:	83 fa 10             	cmp    $0x10,%edx
801056ee:	74 28                	je     80105718 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801056f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056f4:	85 c9                	test   %ecx,%ecx
801056f6:	75 f0                	jne    801056e8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801056f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105701:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105704:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105707:	31 c0                	xor    %eax,%eax
}
80105709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010570c:	5b                   	pop    %ebx
8010570d:	5e                   	pop    %esi
8010570e:	5f                   	pop    %edi
8010570f:	5d                   	pop    %ebp
80105710:	c3                   	ret    
80105711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105718:	e8 43 e3 ff ff       	call   80103a60 <myproc>
8010571d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105724:	00 
80105725:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	ff 75 e0             	pushl  -0x20(%ebp)
8010572e:	e8 0d b7 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105733:	58                   	pop    %eax
80105734:	ff 75 e4             	pushl  -0x1c(%ebp)
80105737:	e8 04 b7 ff ff       	call   80100e40 <fileclose>
    return -1;
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105744:	eb c3                	jmp    80105709 <sys_pipe+0x99>
80105746:	66 90                	xchg   %ax,%ax
80105748:	66 90                	xchg   %ax,%ax
8010574a:	66 90                	xchg   %ax,%ax
8010574c:	66 90                	xchg   %ax,%ax
8010574e:	66 90                	xchg   %ax,%ax

80105750 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105753:	5d                   	pop    %ebp
  return fork();
80105754:	e9 07 e6 ff ff       	jmp    80103d60 <fork>
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_exit>:

int
sys_exit(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 08             	sub    $0x8,%esp
  exit();
80105766:	e8 65 e7 ff ff       	call   80103ed0 <exit>
  return 0;  // not reached
}
8010576b:	31 c0                	xor    %eax,%eax
8010576d:	c9                   	leave  
8010576e:	c3                   	ret    
8010576f:	90                   	nop

80105770 <sys_wait>:

int
sys_wait(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105773:	5d                   	pop    %ebp
  return wait();
80105774:	e9 97 e9 ff ff       	jmp    80104110 <wait>
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_kill>:

int
sys_kill(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105786:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105789:	50                   	push   %eax
8010578a:	6a 00                	push   $0x0
8010578c:	e8 8f f2 ff ff       	call   80104a20 <argint>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	85 c0                	test   %eax,%eax
80105796:	78 18                	js     801057b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	ff 75 f4             	pushl  -0xc(%ebp)
8010579e:	e8 bd ea ff ff       	call   80104260 <kill>
801057a3:	83 c4 10             	add    $0x10,%esp
}
801057a6:	c9                   	leave  
801057a7:	c3                   	ret    
801057a8:	90                   	nop
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057b5:	c9                   	leave  
801057b6:	c3                   	ret    
801057b7:	89 f6                	mov    %esi,%esi
801057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057c0 <sys_getpid>:

int
sys_getpid(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057c6:	e8 95 e2 ff ff       	call   80103a60 <myproc>
801057cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057ce:	c9                   	leave  
801057cf:	c3                   	ret    

801057d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057da:	50                   	push   %eax
801057db:	6a 00                	push   $0x0
801057dd:	e8 3e f2 ff ff       	call   80104a20 <argint>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	78 27                	js     80105810 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057e9:	e8 72 e2 ff ff       	call   80103a60 <myproc>
  if(growproc(n) < 0)
801057ee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057f3:	ff 75 f4             	pushl  -0xc(%ebp)
801057f6:	e8 85 e3 ff ff       	call   80103b80 <growproc>
801057fb:	83 c4 10             	add    $0x10,%esp
801057fe:	85 c0                	test   %eax,%eax
80105800:	78 0e                	js     80105810 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105802:	89 d8                	mov    %ebx,%eax
80105804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105807:	c9                   	leave  
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105810:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105815:	eb eb                	jmp    80105802 <sys_sbrk+0x32>
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_sleep>:

int
sys_sleep(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105824:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105827:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010582a:	50                   	push   %eax
8010582b:	6a 00                	push   $0x0
8010582d:	e8 ee f1 ff ff       	call   80104a20 <argint>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	0f 88 8a 00 00 00    	js     801058c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010583d:	83 ec 0c             	sub    $0xc,%esp
80105840:	68 a0 4c 12 80       	push   $0x80124ca0
80105845:	e8 56 ed ff ff       	call   801045a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010584a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010584d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105850:	8b 1d e0 54 12 80    	mov    0x801254e0,%ebx
  while(ticks - ticks0 < n){
80105856:	85 d2                	test   %edx,%edx
80105858:	75 27                	jne    80105881 <sys_sleep+0x61>
8010585a:	eb 54                	jmp    801058b0 <sys_sleep+0x90>
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	68 a0 4c 12 80       	push   $0x80124ca0
80105868:	68 e0 54 12 80       	push   $0x801254e0
8010586d:	e8 de e7 ff ff       	call   80104050 <sleep>
  while(ticks - ticks0 < n){
80105872:	a1 e0 54 12 80       	mov    0x801254e0,%eax
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	29 d8                	sub    %ebx,%eax
8010587c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010587f:	73 2f                	jae    801058b0 <sys_sleep+0x90>
    if(myproc()->killed){
80105881:	e8 da e1 ff ff       	call   80103a60 <myproc>
80105886:	8b 40 24             	mov    0x24(%eax),%eax
80105889:	85 c0                	test   %eax,%eax
8010588b:	74 d3                	je     80105860 <sys_sleep+0x40>
      release(&tickslock);
8010588d:	83 ec 0c             	sub    $0xc,%esp
80105890:	68 a0 4c 12 80       	push   $0x80124ca0
80105895:	e8 26 ee ff ff       	call   801046c0 <release>
      return -1;
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801058a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	68 a0 4c 12 80       	push   $0x80124ca0
801058b8:	e8 03 ee ff ff       	call   801046c0 <release>
  return 0;
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	31 c0                	xor    %eax,%eax
}
801058c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
    return -1;
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cc:	eb f4                	jmp    801058c2 <sys_sleep+0xa2>
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058d7:	68 a0 4c 12 80       	push   $0x80124ca0
801058dc:	e8 bf ec ff ff       	call   801045a0 <acquire>
  xticks = ticks;
801058e1:	8b 1d e0 54 12 80    	mov    0x801254e0,%ebx
  release(&tickslock);
801058e7:	c7 04 24 a0 4c 12 80 	movl   $0x80124ca0,(%esp)
801058ee:	e8 cd ed ff ff       	call   801046c0 <release>
  return xticks;
}
801058f3:	89 d8                	mov    %ebx,%eax
801058f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f8:	c9                   	leave  
801058f9:	c3                   	ret    
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105900 <sys_shutdown>:

int
sys_shutdown(void){
80105900:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105901:	b8 00 20 00 00       	mov    $0x2000,%eax
80105906:	ba 04 06 00 00       	mov    $0x604,%edx
8010590b:	89 e5                	mov    %esp,%ebp
8010590d:	66 ef                	out    %ax,(%dx)
  outw(0x604, 0x2000);
  return 0;
}
8010590f:	31 c0                	xor    %eax,%eax
80105911:	5d                   	pop    %ebp
80105912:	c3                   	ret    
80105913:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <sys_get_free_frame_cnt>:

extern int free_frame_cnt;
int
sys_get_free_frame_cnt(void){
80105920:	55                   	push   %ebp
  return free_frame_cnt;
80105921:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
sys_get_free_frame_cnt(void){
80105926:	89 e5                	mov    %esp,%ebp
80105928:	5d                   	pop    %ebp
80105929:	c3                   	ret    

8010592a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010592a:	1e                   	push   %ds
  pushl %es
8010592b:	06                   	push   %es
  pushl %fs
8010592c:	0f a0                	push   %fs
  pushl %gs
8010592e:	0f a8                	push   %gs
  pushal
80105930:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105931:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105935:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105937:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105939:	54                   	push   %esp
  call trap
8010593a:	e8 c1 00 00 00       	call   80105a00 <trap>
  addl $4, %esp
8010593f:	83 c4 04             	add    $0x4,%esp

80105942 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105942:	61                   	popa   
  popl %gs
80105943:	0f a9                	pop    %gs
  popl %fs
80105945:	0f a1                	pop    %fs
  popl %es
80105947:	07                   	pop    %es
  popl %ds
80105948:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105949:	83 c4 08             	add    $0x8,%esp
  iret
8010594c:	cf                   	iret   
8010594d:	66 90                	xchg   %ax,%ax
8010594f:	90                   	nop

80105950 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105950:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105951:	31 c0                	xor    %eax,%eax
{
80105953:	89 e5                	mov    %esp,%ebp
80105955:	83 ec 08             	sub    $0x8,%esp
80105958:	90                   	nop
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105960:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105967:	c7 04 c5 e2 4c 12 80 	movl   $0x8e000008,-0x7fedb31e(,%eax,8)
8010596e:	08 00 00 8e 
80105972:	66 89 14 c5 e0 4c 12 	mov    %dx,-0x7fedb320(,%eax,8)
80105979:	80 
8010597a:	c1 ea 10             	shr    $0x10,%edx
8010597d:	66 89 14 c5 e6 4c 12 	mov    %dx,-0x7fedb31a(,%eax,8)
80105984:	80 
  for(i = 0; i < 256; i++)
80105985:	83 c0 01             	add    $0x1,%eax
80105988:	3d 00 01 00 00       	cmp    $0x100,%eax
8010598d:	75 d1                	jne    80105960 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010598f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105994:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105997:	c7 05 e2 4e 12 80 08 	movl   $0xef000008,0x80124ee2
8010599e:	00 00 ef 
  initlock(&tickslock, "time");
801059a1:	68 61 7b 10 80       	push   $0x80107b61
801059a6:	68 a0 4c 12 80       	push   $0x80124ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059ab:	66 a3 e0 4e 12 80    	mov    %ax,0x80124ee0
801059b1:	c1 e8 10             	shr    $0x10,%eax
801059b4:	66 a3 e6 4e 12 80    	mov    %ax,0x80124ee6
  initlock(&tickslock, "time");
801059ba:	e8 f1 ea ff ff       	call   801044b0 <initlock>
}
801059bf:	83 c4 10             	add    $0x10,%esp
801059c2:	c9                   	leave  
801059c3:	c3                   	ret    
801059c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801059d0 <idtinit>:

void
idtinit(void)
{
801059d0:	55                   	push   %ebp
  pd[0] = size-1;
801059d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059d6:	89 e5                	mov    %esp,%ebp
801059d8:	83 ec 10             	sub    $0x10,%esp
801059db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059df:	b8 e0 4c 12 80       	mov    $0x80124ce0,%eax
801059e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059e8:	c1 e8 10             	shr    $0x10,%eax
801059eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
801059f7:	89 f6                	mov    %esi,%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
80105a06:	83 ec 1c             	sub    $0x1c,%esp
80105a09:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105a0c:	8b 47 30             	mov    0x30(%edi),%eax
80105a0f:	83 f8 40             	cmp    $0x40,%eax
80105a12:	0f 84 f0 00 00 00    	je     80105b08 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a18:	83 e8 0e             	sub    $0xe,%eax
80105a1b:	83 f8 31             	cmp    $0x31,%eax
80105a1e:	77 10                	ja     80105a30 <trap+0x30>
80105a20:	ff 24 85 08 7c 10 80 	jmp    *-0x7fef83f8(,%eax,4)
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // --------------------------------------------------------------------------------------------2

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a30:	e8 2b e0 ff ff       	call   80103a60 <myproc>
80105a35:	85 c0                	test   %eax,%eax
80105a37:	0f 84 27 02 00 00    	je     80105c64 <trap+0x264>
80105a3d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a41:	0f 84 1d 02 00 00    	je     80105c64 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a47:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a4a:	8b 57 38             	mov    0x38(%edi),%edx
80105a4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105a53:	e8 e8 df ff ff       	call   80103a40 <cpuid>
80105a58:	8b 77 34             	mov    0x34(%edi),%esi
80105a5b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a61:	e8 fa df ff ff       	call   80103a60 <myproc>
80105a66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a69:	e8 f2 df ff ff       	call   80103a60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a74:	51                   	push   %ecx
80105a75:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a76:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a79:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a7c:	56                   	push   %esi
80105a7d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
80105a7e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a81:	52                   	push   %edx
80105a82:	ff 70 10             	pushl  0x10(%eax)
80105a85:	68 c4 7b 10 80       	push   $0x80107bc4
80105a8a:	e8 d1 ab ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a8f:	83 c4 20             	add    $0x20,%esp
80105a92:	e8 c9 df ff ff       	call   80103a60 <myproc>
80105a97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a9e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aa0:	e8 bb df ff ff       	call   80103a60 <myproc>
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 1d                	je     80105ac6 <trap+0xc6>
80105aa9:	e8 b2 df ff ff       	call   80103a60 <myproc>
80105aae:	8b 50 24             	mov    0x24(%eax),%edx
80105ab1:	85 d2                	test   %edx,%edx
80105ab3:	74 11                	je     80105ac6 <trap+0xc6>
80105ab5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ab9:	83 e0 03             	and    $0x3,%eax
80105abc:	66 83 f8 03          	cmp    $0x3,%ax
80105ac0:	0f 84 5a 01 00 00    	je     80105c20 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ac6:	e8 95 df ff ff       	call   80103a60 <myproc>
80105acb:	85 c0                	test   %eax,%eax
80105acd:	74 0b                	je     80105ada <trap+0xda>
80105acf:	e8 8c df ff ff       	call   80103a60 <myproc>
80105ad4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ad8:	74 66                	je     80105b40 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ada:	e8 81 df ff ff       	call   80103a60 <myproc>
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	74 19                	je     80105afc <trap+0xfc>
80105ae3:	e8 78 df ff ff       	call   80103a60 <myproc>
80105ae8:	8b 40 24             	mov    0x24(%eax),%eax
80105aeb:	85 c0                	test   %eax,%eax
80105aed:	74 0d                	je     80105afc <trap+0xfc>
80105aef:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105af3:	83 e0 03             	and    $0x3,%eax
80105af6:	66 83 f8 03          	cmp    $0x3,%ax
80105afa:	74 35                	je     80105b31 <trap+0x131>
    exit();
}
80105afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aff:	5b                   	pop    %ebx
80105b00:	5e                   	pop    %esi
80105b01:	5f                   	pop    %edi
80105b02:	5d                   	pop    %ebp
80105b03:	c3                   	ret    
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b08:	e8 53 df ff ff       	call   80103a60 <myproc>
80105b0d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b10:	85 db                	test   %ebx,%ebx
80105b12:	0f 85 f8 00 00 00    	jne    80105c10 <trap+0x210>
    myproc()->tf = tf;
80105b18:	e8 43 df ff ff       	call   80103a60 <myproc>
80105b1d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105b20:	e8 eb ef ff ff       	call   80104b10 <syscall>
    if(myproc()->killed)
80105b25:	e8 36 df ff ff       	call   80103a60 <myproc>
80105b2a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b2d:	85 c9                	test   %ecx,%ecx
80105b2f:	74 cb                	je     80105afc <trap+0xfc>
}
80105b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b34:	5b                   	pop    %ebx
80105b35:	5e                   	pop    %esi
80105b36:	5f                   	pop    %edi
80105b37:	5d                   	pop    %ebp
      exit();
80105b38:	e9 93 e3 ff ff       	jmp    80103ed0 <exit>
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105b40:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b44:	75 94                	jne    80105ada <trap+0xda>
    yield();
80105b46:	e8 b5 e4 ff ff       	call   80104000 <yield>
80105b4b:	eb 8d                	jmp    80105ada <trap+0xda>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((tf->err & 0b111) == 0b111){   // a user process are to write on a protected page
80105b50:	8b 47 34             	mov    0x34(%edi),%eax
80105b53:	83 e0 07             	and    $0x7,%eax
80105b56:	83 f8 07             	cmp    $0x7,%eax
80105b59:	0f 85 41 ff ff ff    	jne    80105aa0 <trap+0xa0>
80105b5f:	0f 20 d3             	mov    %cr2,%ebx
      pde_t* pgdir = myproc()->pgdir;
80105b62:	e8 f9 de ff ff       	call   80103a60 <myproc>
      Handle_trap_copy_on_writing(pgdir, a);
80105b67:	83 ec 08             	sub    $0x8,%esp
80105b6a:	53                   	push   %ebx
80105b6b:	ff 70 04             	pushl  0x4(%eax)
80105b6e:	e8 3d 16 00 00       	call   801071b0 <Handle_trap_copy_on_writing>
80105b73:	83 c4 10             	add    $0x10,%esp
80105b76:	e9 25 ff ff ff       	jmp    80105aa0 <trap+0xa0>
80105b7b:	90                   	nop
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b80:	e8 bb de ff ff       	call   80103a40 <cpuid>
80105b85:	85 c0                	test   %eax,%eax
80105b87:	0f 84 a3 00 00 00    	je     80105c30 <trap+0x230>
    lapiceoi();
80105b8d:	e8 1e ce ff ff       	call   801029b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b92:	e8 c9 de ff ff       	call   80103a60 <myproc>
80105b97:	85 c0                	test   %eax,%eax
80105b99:	0f 85 0a ff ff ff    	jne    80105aa9 <trap+0xa9>
80105b9f:	e9 22 ff ff ff       	jmp    80105ac6 <trap+0xc6>
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ba8:	e8 c3 cc ff ff       	call   80102870 <kbdintr>
    lapiceoi();
80105bad:	e8 fe cd ff ff       	call   801029b0 <lapiceoi>
    break;
80105bb2:	e9 e9 fe ff ff       	jmp    80105aa0 <trap+0xa0>
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105bc0:	e8 3b 02 00 00       	call   80105e00 <uartintr>
    lapiceoi();
80105bc5:	e8 e6 cd ff ff       	call   801029b0 <lapiceoi>
    break;
80105bca:	e9 d1 fe ff ff       	jmp    80105aa0 <trap+0xa0>
80105bcf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bd0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105bd4:	8b 77 38             	mov    0x38(%edi),%esi
80105bd7:	e8 64 de ff ff       	call   80103a40 <cpuid>
80105bdc:	56                   	push   %esi
80105bdd:	53                   	push   %ebx
80105bde:	50                   	push   %eax
80105bdf:	68 6c 7b 10 80       	push   $0x80107b6c
80105be4:	e8 77 aa ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105be9:	e8 c2 cd ff ff       	call   801029b0 <lapiceoi>
    break;
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	e9 aa fe ff ff       	jmp    80105aa0 <trap+0xa0>
80105bf6:	8d 76 00             	lea    0x0(%esi),%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105c00:	e8 8b c4 ff ff       	call   80102090 <ideintr>
80105c05:	eb 86                	jmp    80105b8d <trap+0x18d>
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105c10:	e8 bb e2 ff ff       	call   80103ed0 <exit>
80105c15:	e9 fe fe ff ff       	jmp    80105b18 <trap+0x118>
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105c20:	e8 ab e2 ff ff       	call   80103ed0 <exit>
80105c25:	e9 9c fe ff ff       	jmp    80105ac6 <trap+0xc6>
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105c30:	83 ec 0c             	sub    $0xc,%esp
80105c33:	68 a0 4c 12 80       	push   $0x80124ca0
80105c38:	e8 63 e9 ff ff       	call   801045a0 <acquire>
      wakeup(&ticks);
80105c3d:	c7 04 24 e0 54 12 80 	movl   $0x801254e0,(%esp)
      ticks++;
80105c44:	83 05 e0 54 12 80 01 	addl   $0x1,0x801254e0
      wakeup(&ticks);
80105c4b:	e8 b0 e5 ff ff       	call   80104200 <wakeup>
      release(&tickslock);
80105c50:	c7 04 24 a0 4c 12 80 	movl   $0x80124ca0,(%esp)
80105c57:	e8 64 ea ff ff       	call   801046c0 <release>
80105c5c:	83 c4 10             	add    $0x10,%esp
80105c5f:	e9 29 ff ff ff       	jmp    80105b8d <trap+0x18d>
80105c64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c67:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c6a:	e8 d1 dd ff ff       	call   80103a40 <cpuid>
80105c6f:	83 ec 0c             	sub    $0xc,%esp
80105c72:	56                   	push   %esi
80105c73:	53                   	push   %ebx
80105c74:	50                   	push   %eax
80105c75:	ff 77 30             	pushl  0x30(%edi)
80105c78:	68 90 7b 10 80       	push   $0x80107b90
80105c7d:	e8 de a9 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105c82:	83 c4 14             	add    $0x14,%esp
80105c85:	68 66 7b 10 80       	push   $0x80107b66
80105c8a:	e8 01 a7 ff ff       	call   80100390 <panic>
80105c8f:	90                   	nop

80105c90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c90:	a1 c4 a5 10 80       	mov    0x8010a5c4,%eax
{
80105c95:	55                   	push   %ebp
80105c96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	74 1c                	je     80105cb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ca2:	a8 01                	test   $0x1,%al
80105ca4:	74 12                	je     80105cb8 <uartgetc+0x28>
80105ca6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cac:	0f b6 c0             	movzbl %al,%eax
}
80105caf:	5d                   	pop    %ebp
80105cb0:	c3                   	ret    
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cbd:	5d                   	pop    %ebp
80105cbe:	c3                   	ret    
80105cbf:	90                   	nop

80105cc0 <uartputc.part.0>:
uartputc(int c)
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
80105cc5:	53                   	push   %ebx
80105cc6:	89 c7                	mov    %eax,%edi
80105cc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ccd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cd2:	83 ec 0c             	sub    $0xc,%esp
80105cd5:	eb 1b                	jmp    80105cf2 <uartputc.part.0+0x32>
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	6a 0a                	push   $0xa
80105ce5:	e8 e6 cc ff ff       	call   801029d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	83 eb 01             	sub    $0x1,%ebx
80105cf0:	74 07                	je     80105cf9 <uartputc.part.0+0x39>
80105cf2:	89 f2                	mov    %esi,%edx
80105cf4:	ec                   	in     (%dx),%al
80105cf5:	a8 20                	test   $0x20,%al
80105cf7:	74 e7                	je     80105ce0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cf9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cfe:	89 f8                	mov    %edi,%eax
80105d00:	ee                   	out    %al,(%dx)
}
80105d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d04:	5b                   	pop    %ebx
80105d05:	5e                   	pop    %esi
80105d06:	5f                   	pop    %edi
80105d07:	5d                   	pop    %ebp
80105d08:	c3                   	ret    
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d10 <uartinit>:
{
80105d10:	55                   	push   %ebp
80105d11:	31 c9                	xor    %ecx,%ecx
80105d13:	89 c8                	mov    %ecx,%eax
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	57                   	push   %edi
80105d18:	56                   	push   %esi
80105d19:	53                   	push   %ebx
80105d1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d1f:	89 da                	mov    %ebx,%edx
80105d21:	83 ec 0c             	sub    $0xc,%esp
80105d24:	ee                   	out    %al,(%dx)
80105d25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d2f:	89 fa                	mov    %edi,%edx
80105d31:	ee                   	out    %al,(%dx)
80105d32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3c:	ee                   	out    %al,(%dx)
80105d3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d42:	89 c8                	mov    %ecx,%eax
80105d44:	89 f2                	mov    %esi,%edx
80105d46:	ee                   	out    %al,(%dx)
80105d47:	b8 03 00 00 00       	mov    $0x3,%eax
80105d4c:	89 fa                	mov    %edi,%edx
80105d4e:	ee                   	out    %al,(%dx)
80105d4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d54:	89 c8                	mov    %ecx,%eax
80105d56:	ee                   	out    %al,(%dx)
80105d57:	b8 01 00 00 00       	mov    $0x1,%eax
80105d5c:	89 f2                	mov    %esi,%edx
80105d5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d65:	3c ff                	cmp    $0xff,%al
80105d67:	74 5a                	je     80105dc3 <uartinit+0xb3>
  uart = 1;
80105d69:	c7 05 c4 a5 10 80 01 	movl   $0x1,0x8010a5c4
80105d70:	00 00 00 
80105d73:	89 da                	mov    %ebx,%edx
80105d75:	ec                   	in     (%dx),%al
80105d76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d7f:	bb d0 7c 10 80       	mov    $0x80107cd0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d84:	6a 00                	push   $0x0
80105d86:	6a 04                	push   $0x4
80105d88:	e8 53 c5 ff ff       	call   801022e0 <ioapicenable>
80105d8d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d90:	b8 78 00 00 00       	mov    $0x78,%eax
80105d95:	eb 13                	jmp    80105daa <uartinit+0x9a>
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105da0:	83 c3 01             	add    $0x1,%ebx
80105da3:	0f be 03             	movsbl (%ebx),%eax
80105da6:	84 c0                	test   %al,%al
80105da8:	74 19                	je     80105dc3 <uartinit+0xb3>
  if(!uart)
80105daa:	8b 15 c4 a5 10 80    	mov    0x8010a5c4,%edx
80105db0:	85 d2                	test   %edx,%edx
80105db2:	74 ec                	je     80105da0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105db4:	83 c3 01             	add    $0x1,%ebx
80105db7:	e8 04 ff ff ff       	call   80105cc0 <uartputc.part.0>
80105dbc:	0f be 03             	movsbl (%ebx),%eax
80105dbf:	84 c0                	test   %al,%al
80105dc1:	75 e7                	jne    80105daa <uartinit+0x9a>
}
80105dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc6:	5b                   	pop    %ebx
80105dc7:	5e                   	pop    %esi
80105dc8:	5f                   	pop    %edi
80105dc9:	5d                   	pop    %ebp
80105dca:	c3                   	ret    
80105dcb:	90                   	nop
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <uartputc>:
  if(!uart)
80105dd0:	8b 15 c4 a5 10 80    	mov    0x8010a5c4,%edx
{
80105dd6:	55                   	push   %ebp
80105dd7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105dd9:	85 d2                	test   %edx,%edx
{
80105ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105dde:	74 10                	je     80105df0 <uartputc+0x20>
}
80105de0:	5d                   	pop    %ebp
80105de1:	e9 da fe ff ff       	jmp    80105cc0 <uartputc.part.0>
80105de6:	8d 76 00             	lea    0x0(%esi),%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105df0:	5d                   	pop    %ebp
80105df1:	c3                   	ret    
80105df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <uartintr>:

void
uartintr(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e06:	68 90 5c 10 80       	push   $0x80105c90
80105e0b:	e8 00 aa ff ff       	call   80100810 <consoleintr>
}
80105e10:	83 c4 10             	add    $0x10,%esp
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    

80105e15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $0
80105e17:	6a 00                	push   $0x0
  jmp alltraps
80105e19:	e9 0c fb ff ff       	jmp    8010592a <alltraps>

80105e1e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $1
80105e20:	6a 01                	push   $0x1
  jmp alltraps
80105e22:	e9 03 fb ff ff       	jmp    8010592a <alltraps>

80105e27 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $2
80105e29:	6a 02                	push   $0x2
  jmp alltraps
80105e2b:	e9 fa fa ff ff       	jmp    8010592a <alltraps>

80105e30 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $3
80105e32:	6a 03                	push   $0x3
  jmp alltraps
80105e34:	e9 f1 fa ff ff       	jmp    8010592a <alltraps>

80105e39 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $4
80105e3b:	6a 04                	push   $0x4
  jmp alltraps
80105e3d:	e9 e8 fa ff ff       	jmp    8010592a <alltraps>

80105e42 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $5
80105e44:	6a 05                	push   $0x5
  jmp alltraps
80105e46:	e9 df fa ff ff       	jmp    8010592a <alltraps>

80105e4b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $6
80105e4d:	6a 06                	push   $0x6
  jmp alltraps
80105e4f:	e9 d6 fa ff ff       	jmp    8010592a <alltraps>

80105e54 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $7
80105e56:	6a 07                	push   $0x7
  jmp alltraps
80105e58:	e9 cd fa ff ff       	jmp    8010592a <alltraps>

80105e5d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e5d:	6a 08                	push   $0x8
  jmp alltraps
80105e5f:	e9 c6 fa ff ff       	jmp    8010592a <alltraps>

80105e64 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $9
80105e66:	6a 09                	push   $0x9
  jmp alltraps
80105e68:	e9 bd fa ff ff       	jmp    8010592a <alltraps>

80105e6d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e6d:	6a 0a                	push   $0xa
  jmp alltraps
80105e6f:	e9 b6 fa ff ff       	jmp    8010592a <alltraps>

80105e74 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e74:	6a 0b                	push   $0xb
  jmp alltraps
80105e76:	e9 af fa ff ff       	jmp    8010592a <alltraps>

80105e7b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e7b:	6a 0c                	push   $0xc
  jmp alltraps
80105e7d:	e9 a8 fa ff ff       	jmp    8010592a <alltraps>

80105e82 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e82:	6a 0d                	push   $0xd
  jmp alltraps
80105e84:	e9 a1 fa ff ff       	jmp    8010592a <alltraps>

80105e89 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e89:	6a 0e                	push   $0xe
  jmp alltraps
80105e8b:	e9 9a fa ff ff       	jmp    8010592a <alltraps>

80105e90 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $15
80105e92:	6a 0f                	push   $0xf
  jmp alltraps
80105e94:	e9 91 fa ff ff       	jmp    8010592a <alltraps>

80105e99 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $16
80105e9b:	6a 10                	push   $0x10
  jmp alltraps
80105e9d:	e9 88 fa ff ff       	jmp    8010592a <alltraps>

80105ea2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ea2:	6a 11                	push   $0x11
  jmp alltraps
80105ea4:	e9 81 fa ff ff       	jmp    8010592a <alltraps>

80105ea9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $18
80105eab:	6a 12                	push   $0x12
  jmp alltraps
80105ead:	e9 78 fa ff ff       	jmp    8010592a <alltraps>

80105eb2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $19
80105eb4:	6a 13                	push   $0x13
  jmp alltraps
80105eb6:	e9 6f fa ff ff       	jmp    8010592a <alltraps>

80105ebb <vector20>:
.globl vector20
vector20:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $20
80105ebd:	6a 14                	push   $0x14
  jmp alltraps
80105ebf:	e9 66 fa ff ff       	jmp    8010592a <alltraps>

80105ec4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $21
80105ec6:	6a 15                	push   $0x15
  jmp alltraps
80105ec8:	e9 5d fa ff ff       	jmp    8010592a <alltraps>

80105ecd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $22
80105ecf:	6a 16                	push   $0x16
  jmp alltraps
80105ed1:	e9 54 fa ff ff       	jmp    8010592a <alltraps>

80105ed6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $23
80105ed8:	6a 17                	push   $0x17
  jmp alltraps
80105eda:	e9 4b fa ff ff       	jmp    8010592a <alltraps>

80105edf <vector24>:
.globl vector24
vector24:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $24
80105ee1:	6a 18                	push   $0x18
  jmp alltraps
80105ee3:	e9 42 fa ff ff       	jmp    8010592a <alltraps>

80105ee8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $25
80105eea:	6a 19                	push   $0x19
  jmp alltraps
80105eec:	e9 39 fa ff ff       	jmp    8010592a <alltraps>

80105ef1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $26
80105ef3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ef5:	e9 30 fa ff ff       	jmp    8010592a <alltraps>

80105efa <vector27>:
.globl vector27
vector27:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $27
80105efc:	6a 1b                	push   $0x1b
  jmp alltraps
80105efe:	e9 27 fa ff ff       	jmp    8010592a <alltraps>

80105f03 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $28
80105f05:	6a 1c                	push   $0x1c
  jmp alltraps
80105f07:	e9 1e fa ff ff       	jmp    8010592a <alltraps>

80105f0c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $29
80105f0e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f10:	e9 15 fa ff ff       	jmp    8010592a <alltraps>

80105f15 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $30
80105f17:	6a 1e                	push   $0x1e
  jmp alltraps
80105f19:	e9 0c fa ff ff       	jmp    8010592a <alltraps>

80105f1e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $31
80105f20:	6a 1f                	push   $0x1f
  jmp alltraps
80105f22:	e9 03 fa ff ff       	jmp    8010592a <alltraps>

80105f27 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $32
80105f29:	6a 20                	push   $0x20
  jmp alltraps
80105f2b:	e9 fa f9 ff ff       	jmp    8010592a <alltraps>

80105f30 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $33
80105f32:	6a 21                	push   $0x21
  jmp alltraps
80105f34:	e9 f1 f9 ff ff       	jmp    8010592a <alltraps>

80105f39 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $34
80105f3b:	6a 22                	push   $0x22
  jmp alltraps
80105f3d:	e9 e8 f9 ff ff       	jmp    8010592a <alltraps>

80105f42 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $35
80105f44:	6a 23                	push   $0x23
  jmp alltraps
80105f46:	e9 df f9 ff ff       	jmp    8010592a <alltraps>

80105f4b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $36
80105f4d:	6a 24                	push   $0x24
  jmp alltraps
80105f4f:	e9 d6 f9 ff ff       	jmp    8010592a <alltraps>

80105f54 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $37
80105f56:	6a 25                	push   $0x25
  jmp alltraps
80105f58:	e9 cd f9 ff ff       	jmp    8010592a <alltraps>

80105f5d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $38
80105f5f:	6a 26                	push   $0x26
  jmp alltraps
80105f61:	e9 c4 f9 ff ff       	jmp    8010592a <alltraps>

80105f66 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $39
80105f68:	6a 27                	push   $0x27
  jmp alltraps
80105f6a:	e9 bb f9 ff ff       	jmp    8010592a <alltraps>

80105f6f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $40
80105f71:	6a 28                	push   $0x28
  jmp alltraps
80105f73:	e9 b2 f9 ff ff       	jmp    8010592a <alltraps>

80105f78 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $41
80105f7a:	6a 29                	push   $0x29
  jmp alltraps
80105f7c:	e9 a9 f9 ff ff       	jmp    8010592a <alltraps>

80105f81 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $42
80105f83:	6a 2a                	push   $0x2a
  jmp alltraps
80105f85:	e9 a0 f9 ff ff       	jmp    8010592a <alltraps>

80105f8a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $43
80105f8c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f8e:	e9 97 f9 ff ff       	jmp    8010592a <alltraps>

80105f93 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $44
80105f95:	6a 2c                	push   $0x2c
  jmp alltraps
80105f97:	e9 8e f9 ff ff       	jmp    8010592a <alltraps>

80105f9c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $45
80105f9e:	6a 2d                	push   $0x2d
  jmp alltraps
80105fa0:	e9 85 f9 ff ff       	jmp    8010592a <alltraps>

80105fa5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $46
80105fa7:	6a 2e                	push   $0x2e
  jmp alltraps
80105fa9:	e9 7c f9 ff ff       	jmp    8010592a <alltraps>

80105fae <vector47>:
.globl vector47
vector47:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $47
80105fb0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fb2:	e9 73 f9 ff ff       	jmp    8010592a <alltraps>

80105fb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $48
80105fb9:	6a 30                	push   $0x30
  jmp alltraps
80105fbb:	e9 6a f9 ff ff       	jmp    8010592a <alltraps>

80105fc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $49
80105fc2:	6a 31                	push   $0x31
  jmp alltraps
80105fc4:	e9 61 f9 ff ff       	jmp    8010592a <alltraps>

80105fc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $50
80105fcb:	6a 32                	push   $0x32
  jmp alltraps
80105fcd:	e9 58 f9 ff ff       	jmp    8010592a <alltraps>

80105fd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $51
80105fd4:	6a 33                	push   $0x33
  jmp alltraps
80105fd6:	e9 4f f9 ff ff       	jmp    8010592a <alltraps>

80105fdb <vector52>:
.globl vector52
vector52:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $52
80105fdd:	6a 34                	push   $0x34
  jmp alltraps
80105fdf:	e9 46 f9 ff ff       	jmp    8010592a <alltraps>

80105fe4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $53
80105fe6:	6a 35                	push   $0x35
  jmp alltraps
80105fe8:	e9 3d f9 ff ff       	jmp    8010592a <alltraps>

80105fed <vector54>:
.globl vector54
vector54:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $54
80105fef:	6a 36                	push   $0x36
  jmp alltraps
80105ff1:	e9 34 f9 ff ff       	jmp    8010592a <alltraps>

80105ff6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $55
80105ff8:	6a 37                	push   $0x37
  jmp alltraps
80105ffa:	e9 2b f9 ff ff       	jmp    8010592a <alltraps>

80105fff <vector56>:
.globl vector56
vector56:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $56
80106001:	6a 38                	push   $0x38
  jmp alltraps
80106003:	e9 22 f9 ff ff       	jmp    8010592a <alltraps>

80106008 <vector57>:
.globl vector57
vector57:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $57
8010600a:	6a 39                	push   $0x39
  jmp alltraps
8010600c:	e9 19 f9 ff ff       	jmp    8010592a <alltraps>

80106011 <vector58>:
.globl vector58
vector58:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $58
80106013:	6a 3a                	push   $0x3a
  jmp alltraps
80106015:	e9 10 f9 ff ff       	jmp    8010592a <alltraps>

8010601a <vector59>:
.globl vector59
vector59:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $59
8010601c:	6a 3b                	push   $0x3b
  jmp alltraps
8010601e:	e9 07 f9 ff ff       	jmp    8010592a <alltraps>

80106023 <vector60>:
.globl vector60
vector60:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $60
80106025:	6a 3c                	push   $0x3c
  jmp alltraps
80106027:	e9 fe f8 ff ff       	jmp    8010592a <alltraps>

8010602c <vector61>:
.globl vector61
vector61:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $61
8010602e:	6a 3d                	push   $0x3d
  jmp alltraps
80106030:	e9 f5 f8 ff ff       	jmp    8010592a <alltraps>

80106035 <vector62>:
.globl vector62
vector62:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $62
80106037:	6a 3e                	push   $0x3e
  jmp alltraps
80106039:	e9 ec f8 ff ff       	jmp    8010592a <alltraps>

8010603e <vector63>:
.globl vector63
vector63:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $63
80106040:	6a 3f                	push   $0x3f
  jmp alltraps
80106042:	e9 e3 f8 ff ff       	jmp    8010592a <alltraps>

80106047 <vector64>:
.globl vector64
vector64:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $64
80106049:	6a 40                	push   $0x40
  jmp alltraps
8010604b:	e9 da f8 ff ff       	jmp    8010592a <alltraps>

80106050 <vector65>:
.globl vector65
vector65:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $65
80106052:	6a 41                	push   $0x41
  jmp alltraps
80106054:	e9 d1 f8 ff ff       	jmp    8010592a <alltraps>

80106059 <vector66>:
.globl vector66
vector66:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $66
8010605b:	6a 42                	push   $0x42
  jmp alltraps
8010605d:	e9 c8 f8 ff ff       	jmp    8010592a <alltraps>

80106062 <vector67>:
.globl vector67
vector67:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $67
80106064:	6a 43                	push   $0x43
  jmp alltraps
80106066:	e9 bf f8 ff ff       	jmp    8010592a <alltraps>

8010606b <vector68>:
.globl vector68
vector68:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $68
8010606d:	6a 44                	push   $0x44
  jmp alltraps
8010606f:	e9 b6 f8 ff ff       	jmp    8010592a <alltraps>

80106074 <vector69>:
.globl vector69
vector69:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $69
80106076:	6a 45                	push   $0x45
  jmp alltraps
80106078:	e9 ad f8 ff ff       	jmp    8010592a <alltraps>

8010607d <vector70>:
.globl vector70
vector70:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $70
8010607f:	6a 46                	push   $0x46
  jmp alltraps
80106081:	e9 a4 f8 ff ff       	jmp    8010592a <alltraps>

80106086 <vector71>:
.globl vector71
vector71:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $71
80106088:	6a 47                	push   $0x47
  jmp alltraps
8010608a:	e9 9b f8 ff ff       	jmp    8010592a <alltraps>

8010608f <vector72>:
.globl vector72
vector72:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $72
80106091:	6a 48                	push   $0x48
  jmp alltraps
80106093:	e9 92 f8 ff ff       	jmp    8010592a <alltraps>

80106098 <vector73>:
.globl vector73
vector73:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $73
8010609a:	6a 49                	push   $0x49
  jmp alltraps
8010609c:	e9 89 f8 ff ff       	jmp    8010592a <alltraps>

801060a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $74
801060a3:	6a 4a                	push   $0x4a
  jmp alltraps
801060a5:	e9 80 f8 ff ff       	jmp    8010592a <alltraps>

801060aa <vector75>:
.globl vector75
vector75:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $75
801060ac:	6a 4b                	push   $0x4b
  jmp alltraps
801060ae:	e9 77 f8 ff ff       	jmp    8010592a <alltraps>

801060b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $76
801060b5:	6a 4c                	push   $0x4c
  jmp alltraps
801060b7:	e9 6e f8 ff ff       	jmp    8010592a <alltraps>

801060bc <vector77>:
.globl vector77
vector77:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $77
801060be:	6a 4d                	push   $0x4d
  jmp alltraps
801060c0:	e9 65 f8 ff ff       	jmp    8010592a <alltraps>

801060c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $78
801060c7:	6a 4e                	push   $0x4e
  jmp alltraps
801060c9:	e9 5c f8 ff ff       	jmp    8010592a <alltraps>

801060ce <vector79>:
.globl vector79
vector79:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $79
801060d0:	6a 4f                	push   $0x4f
  jmp alltraps
801060d2:	e9 53 f8 ff ff       	jmp    8010592a <alltraps>

801060d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $80
801060d9:	6a 50                	push   $0x50
  jmp alltraps
801060db:	e9 4a f8 ff ff       	jmp    8010592a <alltraps>

801060e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $81
801060e2:	6a 51                	push   $0x51
  jmp alltraps
801060e4:	e9 41 f8 ff ff       	jmp    8010592a <alltraps>

801060e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $82
801060eb:	6a 52                	push   $0x52
  jmp alltraps
801060ed:	e9 38 f8 ff ff       	jmp    8010592a <alltraps>

801060f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $83
801060f4:	6a 53                	push   $0x53
  jmp alltraps
801060f6:	e9 2f f8 ff ff       	jmp    8010592a <alltraps>

801060fb <vector84>:
.globl vector84
vector84:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $84
801060fd:	6a 54                	push   $0x54
  jmp alltraps
801060ff:	e9 26 f8 ff ff       	jmp    8010592a <alltraps>

80106104 <vector85>:
.globl vector85
vector85:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $85
80106106:	6a 55                	push   $0x55
  jmp alltraps
80106108:	e9 1d f8 ff ff       	jmp    8010592a <alltraps>

8010610d <vector86>:
.globl vector86
vector86:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $86
8010610f:	6a 56                	push   $0x56
  jmp alltraps
80106111:	e9 14 f8 ff ff       	jmp    8010592a <alltraps>

80106116 <vector87>:
.globl vector87
vector87:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $87
80106118:	6a 57                	push   $0x57
  jmp alltraps
8010611a:	e9 0b f8 ff ff       	jmp    8010592a <alltraps>

8010611f <vector88>:
.globl vector88
vector88:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $88
80106121:	6a 58                	push   $0x58
  jmp alltraps
80106123:	e9 02 f8 ff ff       	jmp    8010592a <alltraps>

80106128 <vector89>:
.globl vector89
vector89:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $89
8010612a:	6a 59                	push   $0x59
  jmp alltraps
8010612c:	e9 f9 f7 ff ff       	jmp    8010592a <alltraps>

80106131 <vector90>:
.globl vector90
vector90:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $90
80106133:	6a 5a                	push   $0x5a
  jmp alltraps
80106135:	e9 f0 f7 ff ff       	jmp    8010592a <alltraps>

8010613a <vector91>:
.globl vector91
vector91:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $91
8010613c:	6a 5b                	push   $0x5b
  jmp alltraps
8010613e:	e9 e7 f7 ff ff       	jmp    8010592a <alltraps>

80106143 <vector92>:
.globl vector92
vector92:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $92
80106145:	6a 5c                	push   $0x5c
  jmp alltraps
80106147:	e9 de f7 ff ff       	jmp    8010592a <alltraps>

8010614c <vector93>:
.globl vector93
vector93:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $93
8010614e:	6a 5d                	push   $0x5d
  jmp alltraps
80106150:	e9 d5 f7 ff ff       	jmp    8010592a <alltraps>

80106155 <vector94>:
.globl vector94
vector94:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $94
80106157:	6a 5e                	push   $0x5e
  jmp alltraps
80106159:	e9 cc f7 ff ff       	jmp    8010592a <alltraps>

8010615e <vector95>:
.globl vector95
vector95:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $95
80106160:	6a 5f                	push   $0x5f
  jmp alltraps
80106162:	e9 c3 f7 ff ff       	jmp    8010592a <alltraps>

80106167 <vector96>:
.globl vector96
vector96:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $96
80106169:	6a 60                	push   $0x60
  jmp alltraps
8010616b:	e9 ba f7 ff ff       	jmp    8010592a <alltraps>

80106170 <vector97>:
.globl vector97
vector97:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $97
80106172:	6a 61                	push   $0x61
  jmp alltraps
80106174:	e9 b1 f7 ff ff       	jmp    8010592a <alltraps>

80106179 <vector98>:
.globl vector98
vector98:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $98
8010617b:	6a 62                	push   $0x62
  jmp alltraps
8010617d:	e9 a8 f7 ff ff       	jmp    8010592a <alltraps>

80106182 <vector99>:
.globl vector99
vector99:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $99
80106184:	6a 63                	push   $0x63
  jmp alltraps
80106186:	e9 9f f7 ff ff       	jmp    8010592a <alltraps>

8010618b <vector100>:
.globl vector100
vector100:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $100
8010618d:	6a 64                	push   $0x64
  jmp alltraps
8010618f:	e9 96 f7 ff ff       	jmp    8010592a <alltraps>

80106194 <vector101>:
.globl vector101
vector101:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $101
80106196:	6a 65                	push   $0x65
  jmp alltraps
80106198:	e9 8d f7 ff ff       	jmp    8010592a <alltraps>

8010619d <vector102>:
.globl vector102
vector102:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $102
8010619f:	6a 66                	push   $0x66
  jmp alltraps
801061a1:	e9 84 f7 ff ff       	jmp    8010592a <alltraps>

801061a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $103
801061a8:	6a 67                	push   $0x67
  jmp alltraps
801061aa:	e9 7b f7 ff ff       	jmp    8010592a <alltraps>

801061af <vector104>:
.globl vector104
vector104:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $104
801061b1:	6a 68                	push   $0x68
  jmp alltraps
801061b3:	e9 72 f7 ff ff       	jmp    8010592a <alltraps>

801061b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $105
801061ba:	6a 69                	push   $0x69
  jmp alltraps
801061bc:	e9 69 f7 ff ff       	jmp    8010592a <alltraps>

801061c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $106
801061c3:	6a 6a                	push   $0x6a
  jmp alltraps
801061c5:	e9 60 f7 ff ff       	jmp    8010592a <alltraps>

801061ca <vector107>:
.globl vector107
vector107:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $107
801061cc:	6a 6b                	push   $0x6b
  jmp alltraps
801061ce:	e9 57 f7 ff ff       	jmp    8010592a <alltraps>

801061d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $108
801061d5:	6a 6c                	push   $0x6c
  jmp alltraps
801061d7:	e9 4e f7 ff ff       	jmp    8010592a <alltraps>

801061dc <vector109>:
.globl vector109
vector109:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $109
801061de:	6a 6d                	push   $0x6d
  jmp alltraps
801061e0:	e9 45 f7 ff ff       	jmp    8010592a <alltraps>

801061e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $110
801061e7:	6a 6e                	push   $0x6e
  jmp alltraps
801061e9:	e9 3c f7 ff ff       	jmp    8010592a <alltraps>

801061ee <vector111>:
.globl vector111
vector111:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $111
801061f0:	6a 6f                	push   $0x6f
  jmp alltraps
801061f2:	e9 33 f7 ff ff       	jmp    8010592a <alltraps>

801061f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $112
801061f9:	6a 70                	push   $0x70
  jmp alltraps
801061fb:	e9 2a f7 ff ff       	jmp    8010592a <alltraps>

80106200 <vector113>:
.globl vector113
vector113:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $113
80106202:	6a 71                	push   $0x71
  jmp alltraps
80106204:	e9 21 f7 ff ff       	jmp    8010592a <alltraps>

80106209 <vector114>:
.globl vector114
vector114:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $114
8010620b:	6a 72                	push   $0x72
  jmp alltraps
8010620d:	e9 18 f7 ff ff       	jmp    8010592a <alltraps>

80106212 <vector115>:
.globl vector115
vector115:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $115
80106214:	6a 73                	push   $0x73
  jmp alltraps
80106216:	e9 0f f7 ff ff       	jmp    8010592a <alltraps>

8010621b <vector116>:
.globl vector116
vector116:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $116
8010621d:	6a 74                	push   $0x74
  jmp alltraps
8010621f:	e9 06 f7 ff ff       	jmp    8010592a <alltraps>

80106224 <vector117>:
.globl vector117
vector117:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $117
80106226:	6a 75                	push   $0x75
  jmp alltraps
80106228:	e9 fd f6 ff ff       	jmp    8010592a <alltraps>

8010622d <vector118>:
.globl vector118
vector118:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $118
8010622f:	6a 76                	push   $0x76
  jmp alltraps
80106231:	e9 f4 f6 ff ff       	jmp    8010592a <alltraps>

80106236 <vector119>:
.globl vector119
vector119:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $119
80106238:	6a 77                	push   $0x77
  jmp alltraps
8010623a:	e9 eb f6 ff ff       	jmp    8010592a <alltraps>

8010623f <vector120>:
.globl vector120
vector120:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $120
80106241:	6a 78                	push   $0x78
  jmp alltraps
80106243:	e9 e2 f6 ff ff       	jmp    8010592a <alltraps>

80106248 <vector121>:
.globl vector121
vector121:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $121
8010624a:	6a 79                	push   $0x79
  jmp alltraps
8010624c:	e9 d9 f6 ff ff       	jmp    8010592a <alltraps>

80106251 <vector122>:
.globl vector122
vector122:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $122
80106253:	6a 7a                	push   $0x7a
  jmp alltraps
80106255:	e9 d0 f6 ff ff       	jmp    8010592a <alltraps>

8010625a <vector123>:
.globl vector123
vector123:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $123
8010625c:	6a 7b                	push   $0x7b
  jmp alltraps
8010625e:	e9 c7 f6 ff ff       	jmp    8010592a <alltraps>

80106263 <vector124>:
.globl vector124
vector124:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $124
80106265:	6a 7c                	push   $0x7c
  jmp alltraps
80106267:	e9 be f6 ff ff       	jmp    8010592a <alltraps>

8010626c <vector125>:
.globl vector125
vector125:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $125
8010626e:	6a 7d                	push   $0x7d
  jmp alltraps
80106270:	e9 b5 f6 ff ff       	jmp    8010592a <alltraps>

80106275 <vector126>:
.globl vector126
vector126:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $126
80106277:	6a 7e                	push   $0x7e
  jmp alltraps
80106279:	e9 ac f6 ff ff       	jmp    8010592a <alltraps>

8010627e <vector127>:
.globl vector127
vector127:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $127
80106280:	6a 7f                	push   $0x7f
  jmp alltraps
80106282:	e9 a3 f6 ff ff       	jmp    8010592a <alltraps>

80106287 <vector128>:
.globl vector128
vector128:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $128
80106289:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010628e:	e9 97 f6 ff ff       	jmp    8010592a <alltraps>

80106293 <vector129>:
.globl vector129
vector129:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $129
80106295:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010629a:	e9 8b f6 ff ff       	jmp    8010592a <alltraps>

8010629f <vector130>:
.globl vector130
vector130:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $130
801062a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062a6:	e9 7f f6 ff ff       	jmp    8010592a <alltraps>

801062ab <vector131>:
.globl vector131
vector131:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $131
801062ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062b2:	e9 73 f6 ff ff       	jmp    8010592a <alltraps>

801062b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $132
801062b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062be:	e9 67 f6 ff ff       	jmp    8010592a <alltraps>

801062c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $133
801062c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062ca:	e9 5b f6 ff ff       	jmp    8010592a <alltraps>

801062cf <vector134>:
.globl vector134
vector134:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $134
801062d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062d6:	e9 4f f6 ff ff       	jmp    8010592a <alltraps>

801062db <vector135>:
.globl vector135
vector135:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $135
801062dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062e2:	e9 43 f6 ff ff       	jmp    8010592a <alltraps>

801062e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $136
801062e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062ee:	e9 37 f6 ff ff       	jmp    8010592a <alltraps>

801062f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $137
801062f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062fa:	e9 2b f6 ff ff       	jmp    8010592a <alltraps>

801062ff <vector138>:
.globl vector138
vector138:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $138
80106301:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106306:	e9 1f f6 ff ff       	jmp    8010592a <alltraps>

8010630b <vector139>:
.globl vector139
vector139:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $139
8010630d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106312:	e9 13 f6 ff ff       	jmp    8010592a <alltraps>

80106317 <vector140>:
.globl vector140
vector140:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $140
80106319:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010631e:	e9 07 f6 ff ff       	jmp    8010592a <alltraps>

80106323 <vector141>:
.globl vector141
vector141:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $141
80106325:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010632a:	e9 fb f5 ff ff       	jmp    8010592a <alltraps>

8010632f <vector142>:
.globl vector142
vector142:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $142
80106331:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106336:	e9 ef f5 ff ff       	jmp    8010592a <alltraps>

8010633b <vector143>:
.globl vector143
vector143:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $143
8010633d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106342:	e9 e3 f5 ff ff       	jmp    8010592a <alltraps>

80106347 <vector144>:
.globl vector144
vector144:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $144
80106349:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010634e:	e9 d7 f5 ff ff       	jmp    8010592a <alltraps>

80106353 <vector145>:
.globl vector145
vector145:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $145
80106355:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010635a:	e9 cb f5 ff ff       	jmp    8010592a <alltraps>

8010635f <vector146>:
.globl vector146
vector146:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $146
80106361:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106366:	e9 bf f5 ff ff       	jmp    8010592a <alltraps>

8010636b <vector147>:
.globl vector147
vector147:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $147
8010636d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106372:	e9 b3 f5 ff ff       	jmp    8010592a <alltraps>

80106377 <vector148>:
.globl vector148
vector148:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $148
80106379:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010637e:	e9 a7 f5 ff ff       	jmp    8010592a <alltraps>

80106383 <vector149>:
.globl vector149
vector149:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $149
80106385:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010638a:	e9 9b f5 ff ff       	jmp    8010592a <alltraps>

8010638f <vector150>:
.globl vector150
vector150:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $150
80106391:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106396:	e9 8f f5 ff ff       	jmp    8010592a <alltraps>

8010639b <vector151>:
.globl vector151
vector151:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $151
8010639d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063a2:	e9 83 f5 ff ff       	jmp    8010592a <alltraps>

801063a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $152
801063a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063ae:	e9 77 f5 ff ff       	jmp    8010592a <alltraps>

801063b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $153
801063b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063ba:	e9 6b f5 ff ff       	jmp    8010592a <alltraps>

801063bf <vector154>:
.globl vector154
vector154:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $154
801063c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063c6:	e9 5f f5 ff ff       	jmp    8010592a <alltraps>

801063cb <vector155>:
.globl vector155
vector155:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $155
801063cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063d2:	e9 53 f5 ff ff       	jmp    8010592a <alltraps>

801063d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $156
801063d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063de:	e9 47 f5 ff ff       	jmp    8010592a <alltraps>

801063e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $157
801063e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063ea:	e9 3b f5 ff ff       	jmp    8010592a <alltraps>

801063ef <vector158>:
.globl vector158
vector158:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $158
801063f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063f6:	e9 2f f5 ff ff       	jmp    8010592a <alltraps>

801063fb <vector159>:
.globl vector159
vector159:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $159
801063fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106402:	e9 23 f5 ff ff       	jmp    8010592a <alltraps>

80106407 <vector160>:
.globl vector160
vector160:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $160
80106409:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010640e:	e9 17 f5 ff ff       	jmp    8010592a <alltraps>

80106413 <vector161>:
.globl vector161
vector161:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $161
80106415:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010641a:	e9 0b f5 ff ff       	jmp    8010592a <alltraps>

8010641f <vector162>:
.globl vector162
vector162:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $162
80106421:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106426:	e9 ff f4 ff ff       	jmp    8010592a <alltraps>

8010642b <vector163>:
.globl vector163
vector163:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $163
8010642d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106432:	e9 f3 f4 ff ff       	jmp    8010592a <alltraps>

80106437 <vector164>:
.globl vector164
vector164:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $164
80106439:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010643e:	e9 e7 f4 ff ff       	jmp    8010592a <alltraps>

80106443 <vector165>:
.globl vector165
vector165:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $165
80106445:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010644a:	e9 db f4 ff ff       	jmp    8010592a <alltraps>

8010644f <vector166>:
.globl vector166
vector166:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $166
80106451:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106456:	e9 cf f4 ff ff       	jmp    8010592a <alltraps>

8010645b <vector167>:
.globl vector167
vector167:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $167
8010645d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106462:	e9 c3 f4 ff ff       	jmp    8010592a <alltraps>

80106467 <vector168>:
.globl vector168
vector168:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $168
80106469:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010646e:	e9 b7 f4 ff ff       	jmp    8010592a <alltraps>

80106473 <vector169>:
.globl vector169
vector169:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $169
80106475:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010647a:	e9 ab f4 ff ff       	jmp    8010592a <alltraps>

8010647f <vector170>:
.globl vector170
vector170:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $170
80106481:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106486:	e9 9f f4 ff ff       	jmp    8010592a <alltraps>

8010648b <vector171>:
.globl vector171
vector171:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $171
8010648d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106492:	e9 93 f4 ff ff       	jmp    8010592a <alltraps>

80106497 <vector172>:
.globl vector172
vector172:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $172
80106499:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010649e:	e9 87 f4 ff ff       	jmp    8010592a <alltraps>

801064a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $173
801064a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064aa:	e9 7b f4 ff ff       	jmp    8010592a <alltraps>

801064af <vector174>:
.globl vector174
vector174:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $174
801064b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064b6:	e9 6f f4 ff ff       	jmp    8010592a <alltraps>

801064bb <vector175>:
.globl vector175
vector175:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $175
801064bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064c2:	e9 63 f4 ff ff       	jmp    8010592a <alltraps>

801064c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $176
801064c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064ce:	e9 57 f4 ff ff       	jmp    8010592a <alltraps>

801064d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $177
801064d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064da:	e9 4b f4 ff ff       	jmp    8010592a <alltraps>

801064df <vector178>:
.globl vector178
vector178:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $178
801064e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064e6:	e9 3f f4 ff ff       	jmp    8010592a <alltraps>

801064eb <vector179>:
.globl vector179
vector179:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $179
801064ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064f2:	e9 33 f4 ff ff       	jmp    8010592a <alltraps>

801064f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $180
801064f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064fe:	e9 27 f4 ff ff       	jmp    8010592a <alltraps>

80106503 <vector181>:
.globl vector181
vector181:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $181
80106505:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010650a:	e9 1b f4 ff ff       	jmp    8010592a <alltraps>

8010650f <vector182>:
.globl vector182
vector182:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $182
80106511:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106516:	e9 0f f4 ff ff       	jmp    8010592a <alltraps>

8010651b <vector183>:
.globl vector183
vector183:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $183
8010651d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106522:	e9 03 f4 ff ff       	jmp    8010592a <alltraps>

80106527 <vector184>:
.globl vector184
vector184:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $184
80106529:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010652e:	e9 f7 f3 ff ff       	jmp    8010592a <alltraps>

80106533 <vector185>:
.globl vector185
vector185:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $185
80106535:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010653a:	e9 eb f3 ff ff       	jmp    8010592a <alltraps>

8010653f <vector186>:
.globl vector186
vector186:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $186
80106541:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106546:	e9 df f3 ff ff       	jmp    8010592a <alltraps>

8010654b <vector187>:
.globl vector187
vector187:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $187
8010654d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106552:	e9 d3 f3 ff ff       	jmp    8010592a <alltraps>

80106557 <vector188>:
.globl vector188
vector188:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $188
80106559:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010655e:	e9 c7 f3 ff ff       	jmp    8010592a <alltraps>

80106563 <vector189>:
.globl vector189
vector189:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $189
80106565:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010656a:	e9 bb f3 ff ff       	jmp    8010592a <alltraps>

8010656f <vector190>:
.globl vector190
vector190:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $190
80106571:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106576:	e9 af f3 ff ff       	jmp    8010592a <alltraps>

8010657b <vector191>:
.globl vector191
vector191:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $191
8010657d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106582:	e9 a3 f3 ff ff       	jmp    8010592a <alltraps>

80106587 <vector192>:
.globl vector192
vector192:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $192
80106589:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010658e:	e9 97 f3 ff ff       	jmp    8010592a <alltraps>

80106593 <vector193>:
.globl vector193
vector193:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $193
80106595:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010659a:	e9 8b f3 ff ff       	jmp    8010592a <alltraps>

8010659f <vector194>:
.globl vector194
vector194:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $194
801065a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065a6:	e9 7f f3 ff ff       	jmp    8010592a <alltraps>

801065ab <vector195>:
.globl vector195
vector195:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $195
801065ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065b2:	e9 73 f3 ff ff       	jmp    8010592a <alltraps>

801065b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $196
801065b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065be:	e9 67 f3 ff ff       	jmp    8010592a <alltraps>

801065c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $197
801065c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065ca:	e9 5b f3 ff ff       	jmp    8010592a <alltraps>

801065cf <vector198>:
.globl vector198
vector198:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $198
801065d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065d6:	e9 4f f3 ff ff       	jmp    8010592a <alltraps>

801065db <vector199>:
.globl vector199
vector199:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $199
801065dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065e2:	e9 43 f3 ff ff       	jmp    8010592a <alltraps>

801065e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $200
801065e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065ee:	e9 37 f3 ff ff       	jmp    8010592a <alltraps>

801065f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $201
801065f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065fa:	e9 2b f3 ff ff       	jmp    8010592a <alltraps>

801065ff <vector202>:
.globl vector202
vector202:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $202
80106601:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106606:	e9 1f f3 ff ff       	jmp    8010592a <alltraps>

8010660b <vector203>:
.globl vector203
vector203:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $203
8010660d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106612:	e9 13 f3 ff ff       	jmp    8010592a <alltraps>

80106617 <vector204>:
.globl vector204
vector204:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $204
80106619:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010661e:	e9 07 f3 ff ff       	jmp    8010592a <alltraps>

80106623 <vector205>:
.globl vector205
vector205:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $205
80106625:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010662a:	e9 fb f2 ff ff       	jmp    8010592a <alltraps>

8010662f <vector206>:
.globl vector206
vector206:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $206
80106631:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106636:	e9 ef f2 ff ff       	jmp    8010592a <alltraps>

8010663b <vector207>:
.globl vector207
vector207:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $207
8010663d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106642:	e9 e3 f2 ff ff       	jmp    8010592a <alltraps>

80106647 <vector208>:
.globl vector208
vector208:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $208
80106649:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010664e:	e9 d7 f2 ff ff       	jmp    8010592a <alltraps>

80106653 <vector209>:
.globl vector209
vector209:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $209
80106655:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010665a:	e9 cb f2 ff ff       	jmp    8010592a <alltraps>

8010665f <vector210>:
.globl vector210
vector210:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $210
80106661:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106666:	e9 bf f2 ff ff       	jmp    8010592a <alltraps>

8010666b <vector211>:
.globl vector211
vector211:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $211
8010666d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106672:	e9 b3 f2 ff ff       	jmp    8010592a <alltraps>

80106677 <vector212>:
.globl vector212
vector212:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $212
80106679:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010667e:	e9 a7 f2 ff ff       	jmp    8010592a <alltraps>

80106683 <vector213>:
.globl vector213
vector213:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $213
80106685:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010668a:	e9 9b f2 ff ff       	jmp    8010592a <alltraps>

8010668f <vector214>:
.globl vector214
vector214:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $214
80106691:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106696:	e9 8f f2 ff ff       	jmp    8010592a <alltraps>

8010669b <vector215>:
.globl vector215
vector215:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $215
8010669d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066a2:	e9 83 f2 ff ff       	jmp    8010592a <alltraps>

801066a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $216
801066a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066ae:	e9 77 f2 ff ff       	jmp    8010592a <alltraps>

801066b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $217
801066b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066ba:	e9 6b f2 ff ff       	jmp    8010592a <alltraps>

801066bf <vector218>:
.globl vector218
vector218:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $218
801066c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066c6:	e9 5f f2 ff ff       	jmp    8010592a <alltraps>

801066cb <vector219>:
.globl vector219
vector219:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $219
801066cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066d2:	e9 53 f2 ff ff       	jmp    8010592a <alltraps>

801066d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $220
801066d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066de:	e9 47 f2 ff ff       	jmp    8010592a <alltraps>

801066e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $221
801066e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066ea:	e9 3b f2 ff ff       	jmp    8010592a <alltraps>

801066ef <vector222>:
.globl vector222
vector222:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $222
801066f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066f6:	e9 2f f2 ff ff       	jmp    8010592a <alltraps>

801066fb <vector223>:
.globl vector223
vector223:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $223
801066fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106702:	e9 23 f2 ff ff       	jmp    8010592a <alltraps>

80106707 <vector224>:
.globl vector224
vector224:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $224
80106709:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010670e:	e9 17 f2 ff ff       	jmp    8010592a <alltraps>

80106713 <vector225>:
.globl vector225
vector225:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $225
80106715:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010671a:	e9 0b f2 ff ff       	jmp    8010592a <alltraps>

8010671f <vector226>:
.globl vector226
vector226:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $226
80106721:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106726:	e9 ff f1 ff ff       	jmp    8010592a <alltraps>

8010672b <vector227>:
.globl vector227
vector227:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $227
8010672d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106732:	e9 f3 f1 ff ff       	jmp    8010592a <alltraps>

80106737 <vector228>:
.globl vector228
vector228:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $228
80106739:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010673e:	e9 e7 f1 ff ff       	jmp    8010592a <alltraps>

80106743 <vector229>:
.globl vector229
vector229:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $229
80106745:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010674a:	e9 db f1 ff ff       	jmp    8010592a <alltraps>

8010674f <vector230>:
.globl vector230
vector230:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $230
80106751:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106756:	e9 cf f1 ff ff       	jmp    8010592a <alltraps>

8010675b <vector231>:
.globl vector231
vector231:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $231
8010675d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106762:	e9 c3 f1 ff ff       	jmp    8010592a <alltraps>

80106767 <vector232>:
.globl vector232
vector232:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $232
80106769:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010676e:	e9 b7 f1 ff ff       	jmp    8010592a <alltraps>

80106773 <vector233>:
.globl vector233
vector233:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $233
80106775:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010677a:	e9 ab f1 ff ff       	jmp    8010592a <alltraps>

8010677f <vector234>:
.globl vector234
vector234:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $234
80106781:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106786:	e9 9f f1 ff ff       	jmp    8010592a <alltraps>

8010678b <vector235>:
.globl vector235
vector235:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $235
8010678d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106792:	e9 93 f1 ff ff       	jmp    8010592a <alltraps>

80106797 <vector236>:
.globl vector236
vector236:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $236
80106799:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010679e:	e9 87 f1 ff ff       	jmp    8010592a <alltraps>

801067a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $237
801067a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067aa:	e9 7b f1 ff ff       	jmp    8010592a <alltraps>

801067af <vector238>:
.globl vector238
vector238:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $238
801067b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067b6:	e9 6f f1 ff ff       	jmp    8010592a <alltraps>

801067bb <vector239>:
.globl vector239
vector239:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $239
801067bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067c2:	e9 63 f1 ff ff       	jmp    8010592a <alltraps>

801067c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $240
801067c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067ce:	e9 57 f1 ff ff       	jmp    8010592a <alltraps>

801067d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $241
801067d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067da:	e9 4b f1 ff ff       	jmp    8010592a <alltraps>

801067df <vector242>:
.globl vector242
vector242:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $242
801067e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067e6:	e9 3f f1 ff ff       	jmp    8010592a <alltraps>

801067eb <vector243>:
.globl vector243
vector243:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $243
801067ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067f2:	e9 33 f1 ff ff       	jmp    8010592a <alltraps>

801067f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $244
801067f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067fe:	e9 27 f1 ff ff       	jmp    8010592a <alltraps>

80106803 <vector245>:
.globl vector245
vector245:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $245
80106805:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010680a:	e9 1b f1 ff ff       	jmp    8010592a <alltraps>

8010680f <vector246>:
.globl vector246
vector246:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $246
80106811:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106816:	e9 0f f1 ff ff       	jmp    8010592a <alltraps>

8010681b <vector247>:
.globl vector247
vector247:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $247
8010681d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106822:	e9 03 f1 ff ff       	jmp    8010592a <alltraps>

80106827 <vector248>:
.globl vector248
vector248:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $248
80106829:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010682e:	e9 f7 f0 ff ff       	jmp    8010592a <alltraps>

80106833 <vector249>:
.globl vector249
vector249:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $249
80106835:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010683a:	e9 eb f0 ff ff       	jmp    8010592a <alltraps>

8010683f <vector250>:
.globl vector250
vector250:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $250
80106841:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106846:	e9 df f0 ff ff       	jmp    8010592a <alltraps>

8010684b <vector251>:
.globl vector251
vector251:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $251
8010684d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106852:	e9 d3 f0 ff ff       	jmp    8010592a <alltraps>

80106857 <vector252>:
.globl vector252
vector252:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $252
80106859:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010685e:	e9 c7 f0 ff ff       	jmp    8010592a <alltraps>

80106863 <vector253>:
.globl vector253
vector253:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $253
80106865:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010686a:	e9 bb f0 ff ff       	jmp    8010592a <alltraps>

8010686f <vector254>:
.globl vector254
vector254:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $254
80106871:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106876:	e9 af f0 ff ff       	jmp    8010592a <alltraps>

8010687b <vector255>:
.globl vector255
vector255:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $255
8010687d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106882:	e9 a3 f0 ff ff       	jmp    8010592a <alltraps>
80106887:	66 90                	xchg   %ax,%ax
80106889:	66 90                	xchg   %ax,%ax
8010688b:	66 90                	xchg   %ax,%ax
8010688d:	66 90                	xchg   %ax,%ax
8010688f:	90                   	nop

80106890 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106896:	89 d3                	mov    %edx,%ebx
{
80106898:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010689a:	c1 eb 16             	shr    $0x16,%ebx
8010689d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801068a0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801068a3:	8b 06                	mov    (%esi),%eax
801068a5:	a8 01                	test   $0x1,%al
801068a7:	74 27                	je     801068d0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068b4:	c1 ef 0a             	shr    $0xa,%edi
}
801068b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801068ba:	89 fa                	mov    %edi,%edx
801068bc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068c2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801068c5:	5b                   	pop    %ebx
801068c6:	5e                   	pop    %esi
801068c7:	5f                   	pop    %edi
801068c8:	5d                   	pop    %ebp
801068c9:	c3                   	ret    
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801068d0:	85 c9                	test   %ecx,%ecx
801068d2:	74 2c                	je     80106900 <walkpgdir+0x70>
801068d4:	e8 27 bc ff ff       	call   80102500 <kalloc>
801068d9:	85 c0                	test   %eax,%eax
801068db:	89 c3                	mov    %eax,%ebx
801068dd:	74 21                	je     80106900 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801068df:	83 ec 04             	sub    $0x4,%esp
801068e2:	68 00 10 00 00       	push   $0x1000
801068e7:	6a 00                	push   $0x0
801068e9:	50                   	push   %eax
801068ea:	e8 31 de ff ff       	call   80104720 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801068ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068f5:	83 c4 10             	add    $0x10,%esp
801068f8:	83 c8 07             	or     $0x7,%eax
801068fb:	89 06                	mov    %eax,(%esi)
801068fd:	eb b5                	jmp    801068b4 <walkpgdir+0x24>
801068ff:	90                   	nop
}
80106900:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106903:	31 c0                	xor    %eax,%eax
}
80106905:	5b                   	pop    %ebx
80106906:	5e                   	pop    %esi
80106907:	5f                   	pop    %edi
80106908:	5d                   	pop    %ebp
80106909:	c3                   	ret    
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106916:	89 d3                	mov    %edx,%ebx
80106918:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010691e:	83 ec 1c             	sub    $0x1c,%esp
80106921:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106924:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106928:	8b 7d 08             	mov    0x8(%ebp),%edi
8010692b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106930:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    
    *pte = pa | perm | PTE_P;
80106933:	8b 45 0c             	mov    0xc(%ebp),%eax
80106936:	29 df                	sub    %ebx,%edi
80106938:	83 c8 01             	or     $0x1,%eax
8010693b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010693e:	eb 15                	jmp    80106955 <mappages+0x45>
    if(*pte & PTE_P)
80106940:	f6 00 01             	testb  $0x1,(%eax)
80106943:	75 45                	jne    8010698a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106945:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106948:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010694b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010694d:	74 31                	je     80106980 <mappages+0x70>
      break;
    a += PGSIZE;
8010694f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106958:	b9 01 00 00 00       	mov    $0x1,%ecx
8010695d:	89 da                	mov    %ebx,%edx
8010695f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106962:	e8 29 ff ff ff       	call   80106890 <walkpgdir>
80106967:	85 c0                	test   %eax,%eax
80106969:	75 d5                	jne    80106940 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010696b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010696e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106973:	5b                   	pop    %ebx
80106974:	5e                   	pop    %esi
80106975:	5f                   	pop    %edi
80106976:	5d                   	pop    %ebp
80106977:	c3                   	ret    
80106978:	90                   	nop
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106983:	31 c0                	xor    %eax,%eax
}
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    
      panic("remap");
8010698a:	83 ec 0c             	sub    $0xc,%esp
8010698d:	68 d8 7c 10 80       	push   $0x80107cd8
80106992:	e8 f9 99 ff ff       	call   80100390 <panic>
80106997:	89 f6                	mov    %esi,%esi
80106999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069ac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801069ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069b4:	83 ec 1c             	sub    $0x1c,%esp
801069b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069ba:	39 d3                	cmp    %edx,%ebx
801069bc:	73 60                	jae    80106a1e <deallocuvm.part.0+0x7e>
801069be:	89 d6                	mov    %edx,%esi
801069c0:	eb 35                	jmp    801069f7 <deallocuvm.part.0+0x57>
801069c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801069c8:	8b 00                	mov    (%eax),%eax
801069ca:	a8 01                	test   $0x1,%al
801069cc:	74 1f                	je     801069ed <deallocuvm.part.0+0x4d>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801069ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069d3:	74 54                	je     80106a29 <deallocuvm.part.0+0x89>
        panic("kfree in deallocnvm");
      // char *v = P2V(pa);
      // kfree(v);
      // -------------------------------------------------------------------------1
      // change free to checkPage
      kfreeRefer(pa);
801069d5:	83 ec 0c             	sub    $0xc,%esp
801069d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801069db:	50                   	push   %eax
801069dc:	e8 cf bc ff ff       	call   801026b0 <kfreeRefer>
      // -------------------------------------------------------------------------2
      *pte = 0;
801069e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801069e4:	83 c4 10             	add    $0x10,%esp
801069e7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
801069ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069f3:	39 f3                	cmp    %esi,%ebx
801069f5:	73 27                	jae    80106a1e <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
801069f7:	31 c9                	xor    %ecx,%ecx
801069f9:	89 da                	mov    %ebx,%edx
801069fb:	89 f8                	mov    %edi,%eax
801069fd:	e8 8e fe ff ff       	call   80106890 <walkpgdir>
    if(!pte)
80106a02:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a04:	89 c2                	mov    %eax,%edx
    if(!pte)
80106a06:	75 c0                	jne    801069c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a08:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a0e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a14:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a1a:	39 f3                	cmp    %esi,%ebx
80106a1c:	72 d9                	jb     801069f7 <deallocuvm.part.0+0x57>
    }
  }
  return newsz;
}
80106a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a24:	5b                   	pop    %ebx
80106a25:	5e                   	pop    %esi
80106a26:	5f                   	pop    %edi
80106a27:	5d                   	pop    %ebp
80106a28:	c3                   	ret    
        panic("kfree in deallocnvm");
80106a29:	83 ec 0c             	sub    $0xc,%esp
80106a2c:	68 de 7c 10 80       	push   $0x80107cde
80106a31:	e8 5a 99 ff ff       	call   80100390 <panic>
80106a36:	8d 76 00             	lea    0x0(%esi),%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <seginit>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a46:	e8 f5 cf ff ff       	call   80103a40 <cpuid>
80106a4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106a51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a5a:	c7 80 38 28 12 80 ff 	movl   $0xffff,-0x7fedd7c8(%eax)
80106a61:	ff 00 00 
80106a64:	c7 80 3c 28 12 80 00 	movl   $0xcf9a00,-0x7fedd7c4(%eax)
80106a6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a6e:	c7 80 40 28 12 80 ff 	movl   $0xffff,-0x7fedd7c0(%eax)
80106a75:	ff 00 00 
80106a78:	c7 80 44 28 12 80 00 	movl   $0xcf9200,-0x7fedd7bc(%eax)
80106a7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a82:	c7 80 48 28 12 80 ff 	movl   $0xffff,-0x7fedd7b8(%eax)
80106a89:	ff 00 00 
80106a8c:	c7 80 4c 28 12 80 00 	movl   $0xcffa00,-0x7fedd7b4(%eax)
80106a93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a96:	c7 80 50 28 12 80 ff 	movl   $0xffff,-0x7fedd7b0(%eax)
80106a9d:	ff 00 00 
80106aa0:	c7 80 54 28 12 80 00 	movl   $0xcff200,-0x7fedd7ac(%eax)
80106aa7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106aaa:	05 30 28 12 80       	add    $0x80122830,%eax
  pd[1] = (uint)p;
80106aaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ab3:	c1 e8 10             	shr    $0x10,%eax
80106ab6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106aba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106abd:	0f 01 10             	lgdtl  (%eax)
}
80106ac0:	c9                   	leave  
80106ac1:	c3                   	ret    
80106ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ad0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ad0:	a1 e4 54 12 80       	mov    0x801254e4,%eax
{
80106ad5:	55                   	push   %ebp
80106ad6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ad8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106add:	0f 22 d8             	mov    %eax,%cr3
}
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    
80106ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <switchuvm>:
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 1c             	sub    $0x1c,%esp
80106af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106afc:	85 db                	test   %ebx,%ebx
80106afe:	0f 84 cb 00 00 00    	je     80106bcf <switchuvm+0xdf>
  if(p->kstack == 0)
80106b04:	8b 43 08             	mov    0x8(%ebx),%eax
80106b07:	85 c0                	test   %eax,%eax
80106b09:	0f 84 da 00 00 00    	je     80106be9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106b12:	85 c0                	test   %eax,%eax
80106b14:	0f 84 c2 00 00 00    	je     80106bdc <switchuvm+0xec>
  pushcli();
80106b1a:	e8 41 da ff ff       	call   80104560 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b1f:	e8 9c ce ff ff       	call   801039c0 <mycpu>
80106b24:	89 c6                	mov    %eax,%esi
80106b26:	e8 95 ce ff ff       	call   801039c0 <mycpu>
80106b2b:	89 c7                	mov    %eax,%edi
80106b2d:	e8 8e ce ff ff       	call   801039c0 <mycpu>
80106b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b35:	83 c7 08             	add    $0x8,%edi
80106b38:	e8 83 ce ff ff       	call   801039c0 <mycpu>
80106b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b40:	83 c0 08             	add    $0x8,%eax
80106b43:	ba 67 00 00 00       	mov    $0x67,%edx
80106b48:	c1 e8 18             	shr    $0x18,%eax
80106b4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106b52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106b59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b64:	83 c1 08             	add    $0x8,%ecx
80106b67:	c1 e9 10             	shr    $0x10,%ecx
80106b6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106b81:	e8 3a ce ff ff       	call   801039c0 <mycpu>
80106b86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b8d:	e8 2e ce ff ff       	call   801039c0 <mycpu>
80106b92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b96:	8b 73 08             	mov    0x8(%ebx),%esi
80106b99:	e8 22 ce ff ff       	call   801039c0 <mycpu>
80106b9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ba4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ba7:	e8 14 ce ff ff       	call   801039c0 <mycpu>
80106bac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106bb5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bbb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bc0:	0f 22 d8             	mov    %eax,%cr3
}
80106bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc6:	5b                   	pop    %ebx
80106bc7:	5e                   	pop    %esi
80106bc8:	5f                   	pop    %edi
80106bc9:	5d                   	pop    %ebp
  popcli();
80106bca:	e9 91 da ff ff       	jmp    80104660 <popcli>
    panic("switchuvm: no process");
80106bcf:	83 ec 0c             	sub    $0xc,%esp
80106bd2:	68 f2 7c 10 80       	push   $0x80107cf2
80106bd7:	e8 b4 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106bdc:	83 ec 0c             	sub    $0xc,%esp
80106bdf:	68 1d 7d 10 80       	push   $0x80107d1d
80106be4:	e8 a7 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106be9:	83 ec 0c             	sub    $0xc,%esp
80106bec:	68 08 7d 10 80       	push   $0x80107d08
80106bf1:	e8 9a 97 ff ff       	call   80100390 <panic>
80106bf6:	8d 76 00             	lea    0x0(%esi),%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <inituvm>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0c:	8b 7d 10             	mov    0x10(%ebp),%edi
80106c0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(sz >= PGSIZE)
80106c15:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
{
80106c1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(sz >= PGSIZE)
80106c1e:	77 50                	ja     80106c70 <inituvm+0x70>
  mem = kalloc();
80106c20:	e8 db b8 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106c25:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106c28:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c2a:	68 00 10 00 00       	push   $0x1000
80106c2f:	6a 00                	push   $0x0
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c31:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  memset(mem, 0, PGSIZE);
80106c37:	50                   	push   %eax
80106c38:	e8 e3 da ff ff       	call   80104720 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c3d:	58                   	pop    %eax
80106c3e:	5a                   	pop    %edx
80106c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c42:	6a 06                	push   $0x6
80106c44:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c49:	56                   	push   %esi
80106c4a:	31 d2                	xor    %edx,%edx
80106c4c:	e8 bf fc ff ff       	call   80106910 <mappages>
  memmove(mem, init, sz);
80106c51:	83 c4 0c             	add    $0xc,%esp
80106c54:	57                   	push   %edi
80106c55:	ff 75 e0             	pushl  -0x20(%ebp)
80106c58:	53                   	push   %ebx
80106c59:	e8 72 db ff ff       	call   801047d0 <memmove>
  kaddRefer(V2P(mem));
80106c5e:	89 75 08             	mov    %esi,0x8(%ebp)
80106c61:	83 c4 10             	add    $0x10,%esp
}
80106c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c67:	5b                   	pop    %ebx
80106c68:	5e                   	pop    %esi
80106c69:	5f                   	pop    %edi
80106c6a:	5d                   	pop    %ebp
  kaddRefer(V2P(mem));
80106c6b:	e9 10 b9 ff ff       	jmp    80102580 <kaddRefer>
    panic("inituvm: more than a page");
80106c70:	83 ec 0c             	sub    $0xc,%esp
80106c73:	68 31 7d 10 80       	push   $0x80107d31
80106c78:	e8 13 97 ff ff       	call   80100390 <panic>
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi

80106c80 <loaduvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106c89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c90:	0f 85 91 00 00 00    	jne    80106d27 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106c96:	8b 75 18             	mov    0x18(%ebp),%esi
80106c99:	31 db                	xor    %ebx,%ebx
80106c9b:	85 f6                	test   %esi,%esi
80106c9d:	75 1a                	jne    80106cb9 <loaduvm+0x39>
80106c9f:	eb 6f                	jmp    80106d10 <loaduvm+0x90>
80106ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106cb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106cb7:	76 57                	jbe    80106d10 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbf:	31 c9                	xor    %ecx,%ecx
80106cc1:	01 da                	add    %ebx,%edx
80106cc3:	e8 c8 fb ff ff       	call   80106890 <walkpgdir>
80106cc8:	85 c0                	test   %eax,%eax
80106cca:	74 4e                	je     80106d1a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ccc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cd1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106cd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ce1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ce4:	01 d9                	add    %ebx,%ecx
80106ce6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ceb:	57                   	push   %edi
80106cec:	51                   	push   %ecx
80106ced:	50                   	push   %eax
80106cee:	ff 75 10             	pushl  0x10(%ebp)
80106cf1:	e8 7a ac ff ff       	call   80101970 <readi>
80106cf6:	83 c4 10             	add    $0x10,%esp
80106cf9:	39 f8                	cmp    %edi,%eax
80106cfb:	74 ab                	je     80106ca8 <loaduvm+0x28>
}
80106cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d13:	31 c0                	xor    %eax,%eax
}
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
      panic("loaduvm: address should exist");
80106d1a:	83 ec 0c             	sub    $0xc,%esp
80106d1d:	68 4b 7d 10 80       	push   $0x80107d4b
80106d22:	e8 69 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106d27:	83 ec 0c             	sub    $0xc,%esp
80106d2a:	68 ec 7d 10 80       	push   $0x80107dec
80106d2f:	e8 5c 96 ff ff       	call   80100390 <panic>
80106d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d40 <allocuvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d49:	8b 45 10             	mov    0x10(%ebp),%eax
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d51:	0f 88 94 00 00 00    	js     80106deb <allocuvm+0xab>
  if(newsz < oldsz)
80106d57:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d5d:	0f 82 9d 00 00 00    	jb     80106e00 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d63:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d69:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d6f:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d72:	77 54                	ja     80106dc8 <allocuvm+0x88>
80106d74:	e9 8a 00 00 00       	jmp    80106e03 <allocuvm+0xc3>
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106d80:	83 ec 04             	sub    $0x4,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d83:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
    memset(mem, 0, PGSIZE);
80106d89:	68 00 10 00 00       	push   $0x1000
80106d8e:	6a 00                	push   $0x0
80106d90:	50                   	push   %eax
80106d91:	e8 8a d9 ff ff       	call   80104720 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d96:	58                   	pop    %eax
80106d97:	5a                   	pop    %edx
80106d98:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9b:	6a 06                	push   $0x6
80106d9d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106da2:	57                   	push   %edi
80106da3:	89 da                	mov    %ebx,%edx
80106da5:	e8 66 fb ff ff       	call   80106910 <mappages>
80106daa:	83 c4 10             	add    $0x10,%esp
80106dad:	85 c0                	test   %eax,%eax
80106daf:	78 5f                	js     80106e10 <allocuvm+0xd0>
    kaddRefer(V2P(mem));
80106db1:	83 ec 0c             	sub    $0xc,%esp
  for(; a < newsz; a += PGSIZE){
80106db4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kaddRefer(V2P(mem));
80106dba:	57                   	push   %edi
80106dbb:	e8 c0 b7 ff ff       	call   80102580 <kaddRefer>
  for(; a < newsz; a += PGSIZE){
80106dc0:	83 c4 10             	add    $0x10,%esp
80106dc3:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106dc6:	76 3b                	jbe    80106e03 <allocuvm+0xc3>
    mem = kalloc();
80106dc8:	e8 33 b7 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80106dcd:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106dcf:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106dd1:	75 ad                	jne    80106d80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106dd3:	83 ec 0c             	sub    $0xc,%esp
80106dd6:	68 69 7d 10 80       	push   $0x80107d69
80106ddb:	e8 80 98 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106de0:	83 c4 10             	add    $0x10,%esp
80106de3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de6:	39 45 10             	cmp    %eax,0x10(%ebp)
80106de9:	77 6d                	ja     80106e58 <allocuvm+0x118>
    return 0;
80106deb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df8:	5b                   	pop    %ebx
80106df9:	5e                   	pop    %esi
80106dfa:	5f                   	pop    %edi
80106dfb:	5d                   	pop    %ebp
80106dfc:	c3                   	ret    
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80106e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e09:	5b                   	pop    %ebx
80106e0a:	5e                   	pop    %esi
80106e0b:	5f                   	pop    %edi
80106e0c:	5d                   	pop    %ebp
80106e0d:	c3                   	ret    
80106e0e:	66 90                	xchg   %ax,%ax
      cprintf("allocuvm out of memory (2)\n");
80106e10:	83 ec 0c             	sub    $0xc,%esp
80106e13:	68 81 7d 10 80       	push   $0x80107d81
80106e18:	e8 43 98 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106e1d:	83 c4 10             	add    $0x10,%esp
80106e20:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e23:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e26:	76 0d                	jbe    80106e35 <allocuvm+0xf5>
80106e28:	89 c1                	mov    %eax,%ecx
80106e2a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e30:	e8 6b fb ff ff       	call   801069a0 <deallocuvm.part.0>
      kfree(mem);
80106e35:	83 ec 0c             	sub    $0xc,%esp
80106e38:	56                   	push   %esi
80106e39:	e8 e2 b4 ff ff       	call   80102320 <kfree>
      return 0;
80106e3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e45:	83 c4 10             	add    $0x10,%esp
}
80106e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e4e:	5b                   	pop    %ebx
80106e4f:	5e                   	pop    %esi
80106e50:	5f                   	pop    %edi
80106e51:	5d                   	pop    %ebp
80106e52:	c3                   	ret    
80106e53:	90                   	nop
80106e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e58:	89 c1                	mov    %eax,%ecx
80106e5a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e60:	e8 3b fb ff ff       	call   801069a0 <deallocuvm.part.0>
      return 0;
80106e65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e6c:	eb 95                	jmp    80106e03 <allocuvm+0xc3>
80106e6e:	66 90                	xchg   %ax,%ax

80106e70 <deallocuvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e7c:	39 d1                	cmp    %edx,%ecx
80106e7e:	73 10                	jae    80106e90 <deallocuvm+0x20>
}
80106e80:	5d                   	pop    %ebp
80106e81:	e9 1a fb ff ff       	jmp    801069a0 <deallocuvm.part.0>
80106e86:	8d 76 00             	lea    0x0(%esi),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e90:	89 d0                	mov    %edx,%eax
80106e92:	5d                   	pop    %ebp
80106e93:	c3                   	ret    
80106e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ea0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  

  if(pgdir == 0)
80106eac:	85 f6                	test   %esi,%esi
80106eae:	74 59                	je     80106f09 <freevm+0x69>
80106eb0:	31 c9                	xor    %ecx,%ecx
80106eb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106eb7:	89 f0                	mov    %esi,%eax
80106eb9:	e8 e2 fa ff ff       	call   801069a0 <deallocuvm.part.0>
80106ebe:	89 f3                	mov    %esi,%ebx
80106ec0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ec6:	eb 0f                	jmp    80106ed7 <freevm+0x37>
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ed3:	39 fb                	cmp    %edi,%ebx
80106ed5:	74 23                	je     80106efa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ed7:	8b 03                	mov    (%ebx),%eax
80106ed9:	a8 01                	test   $0x1,%al
80106edb:	74 f3                	je     80106ed0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106edd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106ee2:	83 ec 0c             	sub    $0xc,%esp
80106ee5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ee8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106eed:	50                   	push   %eax
80106eee:	e8 2d b4 ff ff       	call   80102320 <kfree>
80106ef3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ef6:	39 fb                	cmp    %edi,%ebx
80106ef8:	75 dd                	jne    80106ed7 <freevm+0x37>
      // pa = PTE_ADDR(pgdir[i]);
      // kfreeRefer(pa);
      // -------------------------------------------------------------------------2
    }
  }
  kfree((char*)pgdir);
80106efa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f00:	5b                   	pop    %ebx
80106f01:	5e                   	pop    %esi
80106f02:	5f                   	pop    %edi
80106f03:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f04:	e9 17 b4 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 9d 7d 10 80       	push   $0x80107d9d
80106f11:	e8 7a 94 ff ff       	call   80100390 <panic>
80106f16:	8d 76 00             	lea    0x0(%esi),%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <setupkvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	56                   	push   %esi
80106f24:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)    // 分配新的内核页面，会造成一个页面的减少。
80106f25:	e8 d6 b5 ff ff       	call   80102500 <kalloc>
80106f2a:	85 c0                	test   %eax,%eax
80106f2c:	89 c6                	mov    %eax,%esi
80106f2e:	74 42                	je     80106f72 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106f30:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f33:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f38:	68 00 10 00 00       	push   $0x1000
80106f3d:	6a 00                	push   $0x0
80106f3f:	50                   	push   %eax
80106f40:	e8 db d7 ff ff       	call   80104720 <memset>
80106f45:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f48:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f4b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f4e:	83 ec 08             	sub    $0x8,%esp
80106f51:	8b 13                	mov    (%ebx),%edx
80106f53:	ff 73 0c             	pushl  0xc(%ebx)
80106f56:	50                   	push   %eax
80106f57:	29 c1                	sub    %eax,%ecx
80106f59:	89 f0                	mov    %esi,%eax
80106f5b:	e8 b0 f9 ff ff       	call   80106910 <mappages>
80106f60:	83 c4 10             	add    $0x10,%esp
80106f63:	85 c0                	test   %eax,%eax
80106f65:	78 19                	js     80106f80 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f67:	83 c3 10             	add    $0x10,%ebx
80106f6a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f70:	75 d6                	jne    80106f48 <setupkvm+0x28>
}
80106f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f75:	89 f0                	mov    %esi,%eax
80106f77:	5b                   	pop    %ebx
80106f78:	5e                   	pop    %esi
80106f79:	5d                   	pop    %ebp
80106f7a:	c3                   	ret    
80106f7b:	90                   	nop
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	56                   	push   %esi
      return 0;
80106f84:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f86:	e8 15 ff ff ff       	call   80106ea0 <freevm>
      return 0;
80106f8b:	83 c4 10             	add    $0x10,%esp
}
80106f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f91:	89 f0                	mov    %esi,%eax
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5d                   	pop    %ebp
80106f96:	c3                   	ret    
80106f97:	89 f6                	mov    %esi,%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <kvmalloc>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fa6:	e8 75 ff ff ff       	call   80106f20 <setupkvm>
80106fab:	a3 e4 54 12 80       	mov    %eax,0x801254e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb5:	0f 22 d8             	mov    %eax,%cr3
}
80106fb8:	c9                   	leave  
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fc0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fc1:	31 c9                	xor    %ecx,%ecx
{
80106fc3:	89 e5                	mov    %esp,%ebp
80106fc5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fce:	e8 bd f8 ff ff       	call   80106890 <walkpgdir>
  if(pte == 0)
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	74 05                	je     80106fdc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106fd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fda:	c9                   	leave  
80106fdb:	c3                   	ret    
    panic("clearpteu");
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	68 ae 7d 10 80       	push   $0x80107dae
80106fe4:	e8 a7 93 ff ff       	call   80100390 <panic>
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ff9:	e8 22 ff ff ff       	call   80106f20 <setupkvm>
80106ffe:	85 c0                	test   %eax,%eax
80107000:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107003:	0f 84 a0 00 00 00    	je     801070a9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010700c:	85 c9                	test   %ecx,%ecx
8010700e:	0f 84 95 00 00 00    	je     801070a9 <copyuvm+0xb9>
80107014:	31 f6                	xor    %esi,%esi
80107016:	eb 4e                	jmp    80107066 <copyuvm+0x76>
80107018:	90                   	nop
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107020:	83 ec 04             	sub    $0x4,%esp
80107023:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010702c:	68 00 10 00 00       	push   $0x1000
80107031:	57                   	push   %edi
80107032:	50                   	push   %eax
80107033:	e8 98 d7 ff ff       	call   801047d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107038:	58                   	pop    %eax
80107039:	5a                   	pop    %edx
8010703a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010703d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107040:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107045:	53                   	push   %ebx
80107046:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010704c:	52                   	push   %edx
8010704d:	89 f2                	mov    %esi,%edx
8010704f:	e8 bc f8 ff ff       	call   80106910 <mappages>
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	85 c0                	test   %eax,%eax
80107059:	78 39                	js     80107094 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010705b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107061:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107064:	76 43                	jbe    801070a9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107066:	8b 45 08             	mov    0x8(%ebp),%eax
80107069:	31 c9                	xor    %ecx,%ecx
8010706b:	89 f2                	mov    %esi,%edx
8010706d:	e8 1e f8 ff ff       	call   80106890 <walkpgdir>
80107072:	85 c0                	test   %eax,%eax
80107074:	74 3e                	je     801070b4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107076:	8b 18                	mov    (%eax),%ebx
80107078:	f6 c3 01             	test   $0x1,%bl
8010707b:	74 44                	je     801070c1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010707d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010707f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107085:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010708b:	e8 70 b4 ff ff       	call   80102500 <kalloc>
80107090:	85 c0                	test   %eax,%eax
80107092:	75 8c                	jne    80107020 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107094:	83 ec 0c             	sub    $0xc,%esp
80107097:	ff 75 e0             	pushl  -0x20(%ebp)
8010709a:	e8 01 fe ff ff       	call   80106ea0 <freevm>
  return 0;
8010709f:	83 c4 10             	add    $0x10,%esp
801070a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801070a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070af:	5b                   	pop    %ebx
801070b0:	5e                   	pop    %esi
801070b1:	5f                   	pop    %edi
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801070b4:	83 ec 0c             	sub    $0xc,%esp
801070b7:	68 b8 7d 10 80       	push   $0x80107db8
801070bc:	e8 cf 92 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801070c1:	83 ec 0c             	sub    $0xc,%esp
801070c4:	68 d2 7d 10 80       	push   $0x80107dd2
801070c9:	e8 c2 92 ff ff       	call   80100390 <panic>
801070ce:	66 90                	xchg   %ax,%ax

801070d0 <copyuvm_new>:
//-----------------------------------------------------------------------------------------------------------------1
  
  pde_t*
  copyuvm_new(pde_t *pgdir, uint sz)
  {
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
    // cprintf("Get into copy from pid: %d ,  sz = %d\n", myproc()->pid,sz);
    // cprintf("before setupkvm in pid: %d\n", myproc()->pid);
    // make a new kernal page table directory
    // int pre,p1,p2;
    // pre = free_frame_cnt;
    if((d = setupkvm()) == 0)
801070d9:	e8 42 fe ff ff       	call   80106f20 <setupkvm>
801070de:	85 c0                	test   %eax,%eax
801070e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e3:	0f 84 9a 00 00 00    	je     80107183 <copyuvm_new+0xb3>
      return 0;
    // p1 = free_frame_cnt;
    ////// cprintf("after setupkvm in pid: %d\n", myproc()->pid);
    // copy all the PTE from parent 
    for(i = 0; i < sz; i += PGSIZE){
801070e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070ec:	85 c0                	test   %eax,%eax
801070ee:	0f 84 8f 00 00 00    	je     80107183 <copyuvm_new+0xb3>
801070f4:	8b 45 08             	mov    0x8(%ebp),%eax
801070f7:	31 db                	xor    %ebx,%ebx
801070f9:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
801070ff:	eb 21                	jmp    80107122 <copyuvm_new+0x52>
80107101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
        goto bad;
      // -----------------------------------------------------------------------------------------------------------1
      // add the reference number of the page
      kaddRefer(pa);
80107108:	83 ec 0c             	sub    $0xc,%esp
8010710b:	56                   	push   %esi
8010710c:	e8 6f b4 ff ff       	call   80102580 <kaddRefer>
80107111:	0f 22 df             	mov    %edi,%cr3
    for(i = 0; i < sz; i += PGSIZE){
80107114:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010711a:	83 c4 10             	add    $0x10,%esp
8010711d:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107120:	76 61                	jbe    80107183 <copyuvm_new+0xb3>
      if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107122:	8b 45 08             	mov    0x8(%ebp),%eax
80107125:	31 c9                	xor    %ecx,%ecx
80107127:	89 da                	mov    %ebx,%edx
80107129:	e8 62 f7 ff ff       	call   80106890 <walkpgdir>
8010712e:	85 c0                	test   %eax,%eax
80107130:	74 69                	je     8010719b <copyuvm_new+0xcb>
      if(!(*pte & PTE_P))
80107132:	8b 10                	mov    (%eax),%edx
80107134:	f6 c2 01             	test   $0x1,%dl
80107137:	74 55                	je     8010718e <copyuvm_new+0xbe>
      pa = PTE_ADDR(*pte);    
80107139:	89 d6                	mov    %edx,%esi
      flags = PTE_Clear_Val(flags);     
8010713b:	81 e2 fd 01 00 00    	and    $0x1fd,%edx
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107141:	83 ec 08             	sub    $0x8,%esp
      pa = PTE_ADDR(*pte);    
80107144:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      flags = PTE_Set_Val_Copy_on_Writing(flags);
8010714a:	80 ce 02             	or     $0x2,%dh
      *pte = pa | flags;
8010714d:	89 f1                	mov    %esi,%ecx
8010714f:	09 d1                	or     %edx,%ecx
80107151:	89 08                	mov    %ecx,(%eax)
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107156:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010715b:	52                   	push   %edx
8010715c:	56                   	push   %esi
8010715d:	89 da                	mov    %ebx,%edx
8010715f:	e8 ac f7 ff ff       	call   80106910 <mappages>
80107164:	83 c4 10             	add    $0x10,%esp
80107167:	85 c0                	test   %eax,%eax
80107169:	79 9d                	jns    80107108 <copyuvm_new+0x38>
8010716b:	0f 22 df             	mov    %edi,%cr3
    return d;

  bad:
    lcr3(V2P(pgdir));
    // lcr3(V2P(d));
    freevm(d);
8010716e:	83 ec 0c             	sub    $0xc,%esp
80107171:	ff 75 e4             	pushl  -0x1c(%ebp)
80107174:	e8 27 fd ff ff       	call   80106ea0 <freevm>
    return 0;
80107179:	83 c4 10             	add    $0x10,%esp
8010717c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  }
80107183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107189:	5b                   	pop    %ebx
8010718a:	5e                   	pop    %esi
8010718b:	5f                   	pop    %edi
8010718c:	5d                   	pop    %ebp
8010718d:	c3                   	ret    
        panic("copyuvm: page not present");
8010718e:	83 ec 0c             	sub    $0xc,%esp
80107191:	68 d2 7d 10 80       	push   $0x80107dd2
80107196:	e8 f5 91 ff ff       	call   80100390 <panic>
        panic("copyuvm: pte should exist");
8010719b:	83 ec 0c             	sub    $0xc,%esp
8010719e:	68 b8 7d 10 80       	push   $0x80107db8
801071a3:	e8 e8 91 ff ff       	call   80100390 <panic>
801071a8:	90                   	nop
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <Handle_trap_copy_on_writing>:

int Handle_trap_copy_on_writing(pde_t *pgdir, char *a){
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, flags;
  char *mem;
  if((pte = walkpgdir(myproc()->pgdir, a, 0)) == 0){
801071b9:	e8 a2 c8 ff ff       	call   80103a60 <myproc>
801071be:	8b 55 0c             	mov    0xc(%ebp),%edx
801071c1:	8b 40 04             	mov    0x4(%eax),%eax
801071c4:	31 c9                	xor    %ecx,%ecx
801071c6:	e8 c5 f6 ff ff       	call   80106890 <walkpgdir>
801071cb:	85 c0                	test   %eax,%eax
801071cd:	0f 84 b7 00 00 00    	je     8010728a <Handle_trap_copy_on_writing+0xda>
        return -1;
  }
  // cprintf("Handle trap copy on Writing address: %d in pid : %d        \n",PTE_ADDR(*pte),myproc()->pid);
  if((((*pte) & PTE_W) == 0 ) && ((((*pte) >> 9) & 0b111) == 0b001)){  // unwritable && copy_on_writing
801071d3:	8b 30                	mov    (%eax),%esi
    // kshowRefer(PTE_ADDR(*pte));
    lcr3(V2P(pgdir));

    return 1;
  }
  return 0;
801071d5:	31 ff                	xor    %edi,%edi
801071d7:	89 c3                	mov    %eax,%ebx
  if((((*pte) & PTE_W) == 0 ) && ((((*pte) >> 9) & 0b111) == 0b001)){  // unwritable && copy_on_writing
801071d9:	f7 c6 02 00 00 00    	test   $0x2,%esi
801071df:	75 0d                	jne    801071ee <Handle_trap_copy_on_writing+0x3e>
801071e1:	89 f0                	mov    %esi,%eax
801071e3:	c1 e8 09             	shr    $0x9,%eax
801071e6:	83 e0 07             	and    $0x7,%eax
801071e9:	83 f8 01             	cmp    $0x1,%eax
801071ec:	74 12                	je     80107200 <Handle_trap_copy_on_writing+0x50>
  
}
801071ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f1:	89 f8                	mov    %edi,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5f                   	pop    %edi
801071f6:	5d                   	pop    %ebp
801071f7:	c3                   	ret    
801071f8:	90                   	nop
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((mem = kalloc()) == 0){
80107200:	e8 fb b2 ff ff       	call   80102500 <kalloc>
80107205:	85 c0                	test   %eax,%eax
80107207:	89 c2                	mov    %eax,%edx
80107209:	74 6d                	je     80107278 <Handle_trap_copy_on_writing+0xc8>
    pa = PTE_ADDR(*pte);
8010720b:	89 f7                	mov    %esi,%edi
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010720d:	83 ec 04             	sub    $0x4,%esp
80107210:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107213:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107219:	68 00 10 00 00       	push   $0x1000
    flags = PTE_Clear_Val(flags);
8010721e:	81 e6 ff 01 00 00    	and    $0x1ff,%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107224:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
    flags = flags | PTE_W;
8010722a:	83 ce 02             	or     $0x2,%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010722d:	50                   	push   %eax
8010722e:	52                   	push   %edx
8010722f:	e8 9c d5 ff ff       	call   801047d0 <memmove>
    kfreeRefer(pa);       
80107234:	89 3c 24             	mov    %edi,(%esp)
80107237:	e8 74 b4 ff ff       	call   801026b0 <kfreeRefer>
    *pte = V2P(mem) | flags | PTE_P;
8010723c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010723f:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107245:	09 d6                	or     %edx,%esi
80107247:	89 f0                	mov    %esi,%eax
    kaddRefer(PTE_ADDR(*pte));
80107249:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    *pte = V2P(mem) | flags | PTE_P;
8010724f:	83 c8 01             	or     $0x1,%eax
80107252:	89 03                	mov    %eax,(%ebx)
    kaddRefer(PTE_ADDR(*pte));
80107254:	89 34 24             	mov    %esi,(%esp)
80107257:	e8 24 b3 ff ff       	call   80102580 <kaddRefer>
    lcr3(V2P(pgdir));
8010725c:	8b 45 08             	mov    0x8(%ebp),%eax
8010725f:	05 00 00 00 80       	add    $0x80000000,%eax
80107264:	0f 22 d8             	mov    %eax,%cr3
    return 1;
80107267:	bf 01 00 00 00       	mov    $0x1,%edi
8010726c:	83 c4 10             	add    $0x10,%esp
8010726f:	e9 7a ff ff ff       	jmp    801071ee <Handle_trap_copy_on_writing+0x3e>
80107274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107278:	83 ec 0c             	sub    $0xc,%esp
8010727b:	6a 00                	push   $0x0
8010727d:	e8 9e b0 ff ff       	call   80102320 <kfree>
      return 0;
80107282:	83 c4 10             	add    $0x10,%esp
80107285:	e9 64 ff ff ff       	jmp    801071ee <Handle_trap_copy_on_writing+0x3e>
        return -1;
8010728a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010728f:	e9 5a ff ff ff       	jmp    801071ee <Handle_trap_copy_on_writing+0x3e>
80107294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010729a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072a1:	31 c9                	xor    %ecx,%ecx
{
801072a3:	89 e5                	mov    %esp,%ebp
801072a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072ab:	8b 45 08             	mov    0x8(%ebp),%eax
801072ae:	e8 dd f5 ff ff       	call   80106890 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072b5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072b6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072bd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072c0:	05 00 00 00 80       	add    $0x80000000,%eax
801072c5:	83 fa 05             	cmp    $0x5,%edx
801072c8:	ba 00 00 00 00       	mov    $0x0,%edx
801072cd:	0f 45 c2             	cmovne %edx,%eax
}
801072d0:	c3                   	ret    
801072d1:	eb 0d                	jmp    801072e0 <copyout>
801072d3:	90                   	nop
801072d4:	90                   	nop
801072d5:	90                   	nop
801072d6:	90                   	nop
801072d7:	90                   	nop
801072d8:	90                   	nop
801072d9:	90                   	nop
801072da:	90                   	nop
801072db:	90                   	nop
801072dc:	90                   	nop
801072dd:	90                   	nop
801072de:	90                   	nop
801072df:	90                   	nop

801072e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
801072e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801072ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801072ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072f2:	85 db                	test   %ebx,%ebx
801072f4:	75 40                	jne    80107336 <copyout+0x56>
801072f6:	eb 70                	jmp    80107368 <copyout+0x88>
801072f8:	90                   	nop
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107300:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107303:	89 f1                	mov    %esi,%ecx
80107305:	29 d1                	sub    %edx,%ecx
80107307:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010730d:	39 d9                	cmp    %ebx,%ecx
8010730f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107312:	29 f2                	sub    %esi,%edx
80107314:	83 ec 04             	sub    $0x4,%esp
80107317:	01 d0                	add    %edx,%eax
80107319:	51                   	push   %ecx
8010731a:	57                   	push   %edi
8010731b:	50                   	push   %eax
8010731c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010731f:	e8 ac d4 ff ff       	call   801047d0 <memmove>
    len -= n;
    buf += n;
80107324:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107327:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010732a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107330:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107332:	29 cb                	sub    %ecx,%ebx
80107334:	74 32                	je     80107368 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107336:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107338:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010733b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010733e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107344:	56                   	push   %esi
80107345:	ff 75 08             	pushl  0x8(%ebp)
80107348:	e8 53 ff ff ff       	call   801072a0 <uva2ka>
    if(pa0 == 0)
8010734d:	83 c4 10             	add    $0x10,%esp
80107350:	85 c0                	test   %eax,%eax
80107352:	75 ac                	jne    80107300 <copyout+0x20>
  }
  return 0;
}
80107354:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010735c:	5b                   	pop    %ebx
8010735d:	5e                   	pop    %esi
8010735e:	5f                   	pop    %edi
8010735f:	5d                   	pop    %ebp
80107360:	c3                   	ret    
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010736b:	31 c0                	xor    %eax,%eax
}
8010736d:	5b                   	pop    %ebx
8010736e:	5e                   	pop    %esi
8010736f:	5f                   	pop    %edi
80107370:	5d                   	pop    %ebp
80107371:	c3                   	ret    
