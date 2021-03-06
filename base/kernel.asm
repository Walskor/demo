
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
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2f 10 80       	mov    $0x80102f10,%eax
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 75 10 80       	push   $0x80107560
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 05 48 00 00       	call   80104860 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
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
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 75 10 80       	push   $0x80107567
80100097:	50                   	push   %eax
80100098:	e8 b3 46 00 00       	call   80104750 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
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
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 67 48 00 00       	call   80104950 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 09 49 00 00       	call   80104a70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 46 00 00       	call   80104790 <acquiresleep>
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
80100193:	68 6e 75 10 80       	push   $0x8010756e
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
801001ae:	e8 7d 46 00 00       	call   80104830 <holdingsleep>
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
801001cc:	68 7f 75 10 80       	push   $0x8010757f
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
801001ef:	e8 3c 46 00 00       	call   80104830 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 45 00 00       	call   801047f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 40 47 00 00       	call   80104950 <acquire>
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
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 0f 48 00 00       	jmp    80104a70 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 75 10 80       	push   $0x80107586
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
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 46 00 00       	call   80104950 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
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
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 56 3b 00 00       	call   80103e20 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 35 00 00       	call   80103850 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 7c 47 00 00       	call   80104a70 <release>
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
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
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
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 1e 47 00 00       	call   80104a70 <release>
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
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
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
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 23 00 00       	call   80102760 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 75 10 80       	push   $0x8010758d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 b9 7a 10 80 	movl   $0x80107ab9,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 a3 44 00 00       	call   80104880 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 75 10 80       	push   $0x801075a1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010043a:	e8 31 5d 00 00       	call   80106170 <uartputc>
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
801004ec:	e8 7f 5c 00 00       	call   80106170 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 73 5c 00 00       	call   80106170 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 67 5c 00 00       	call   80106170 <uartputc>
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
80100524:	e8 57 46 00 00       	call   80104b80 <memmove>
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
80100541:	e8 8a 45 00 00       	call   80104ad0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 75 10 80       	push   $0x801075a5
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
801005b1:	0f b6 92 d0 75 10 80 	movzbl -0x7fef8a30(%edx),%edx
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
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 43 00 00       	call   80104950 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 24 44 00 00       	call   80104a70 <release>
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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 4c 43 00 00       	call   80104a70 <release>
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
801007d0:	ba b8 75 10 80       	mov    $0x801075b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 5b 41 00 00       	call   80104950 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 75 10 80       	push   $0x801075bf
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
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 28 41 00 00       	call   80104950 <acquire>
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
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
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
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 e3 41 00 00       	call   80104a70 <release>
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
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 b5 36 00 00       	call   80103fd0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
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
80100997:	e9 14 37 00 00       	jmp    801040b0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
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
801009c6:	68 c8 75 10 80       	push   $0x801075c8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 8b 3e 00 00       	call   80104860 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
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
80100a1c:	e8 2f 2e 00 00       	call   80103850 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 a4 21 00 00       	call   80102bd0 <begin_op>

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
80100a6f:	e8 cc 21 00 00       	call   80102c40 <end_op>
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
80100a94:	e8 27 68 00 00       	call   801072c0 <setupkvm>
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
80100af6:	e8 e5 65 00 00       	call   801070e0 <allocuvm>
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
80100b28:	e8 f3 64 00 00       	call   80107020 <loaduvm>
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
80100b72:	e8 c9 66 00 00       	call   80107240 <freevm>
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
80100b9a:	e8 a1 20 00 00       	call   80102c40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 31 65 00 00       	call   801070e0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 66 00 00       	call   80107240 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 68 20 00 00       	call   80102c40 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 75 10 80       	push   $0x801075e1
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
80100c06:	e8 55 67 00 00       	call   80107360 <clearpteu>
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
80100c39:	e8 b2 40 00 00       	call   80104cf0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 9f 40 00 00       	call   80104cf0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 4e 68 00 00       	call   801074b0 <copyout>
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
80100cc7:	e8 e4 67 00 00       	call   801074b0 <copyout>
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
80100d0a:	e8 a1 3f 00 00       	call   80104cb0 <safestrcpy>
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
80100d34:	e8 57 61 00 00       	call   80106e90 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ff 64 00 00       	call   80107240 <freevm>
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
80100d66:	68 ed 75 10 80       	push   $0x801075ed
80100d6b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d70:	e8 eb 3a 00 00       	call   80104860 <initlock>
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
80100d84:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 0f 11 80       	push   $0x80110fe0
80100d91:	e8 ba 3b 00 00       	call   80104950 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 aa 3c 00 00       	call   80104a70 <release>
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
80100dd5:	68 e0 0f 11 80       	push   $0x80110fe0
80100dda:	e8 91 3c 00 00       	call   80104a70 <release>
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
80100dfa:	68 e0 0f 11 80       	push   $0x80110fe0
80100dff:	e8 4c 3b 00 00       	call   80104950 <acquire>
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
80100e17:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1c:	e8 4f 3c 00 00       	call   80104a70 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 f4 75 10 80       	push   $0x801075f4
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
80100e4c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e51:	e8 fa 3a 00 00       	call   80104950 <acquire>
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
80100e6e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
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
80100e7c:	e9 ef 3b 00 00       	jmp    80104a70 <release>
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
80100ea0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 c3 3b 00 00       	call   80104a70 <release>
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
80100ed1:	e8 ea 24 00 00       	call   801033c0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 eb 1c 00 00       	call   80102bd0 <begin_op>
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
80100efa:	e9 41 1d 00 00       	jmp    80102c40 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 fc 75 10 80       	push   $0x801075fc
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
80100fcd:	e9 9e 25 00 00       	jmp    80103570 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 06 76 10 80       	push   $0x80107606
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
80101049:	e8 f2 1b 00 00       	call   80102c40 <end_op>
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
80101076:	e8 55 1b 00 00       	call   80102bd0 <begin_op>
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
801010ad:	e8 8e 1b 00 00       	call   80102c40 <end_op>
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
801010ed:	e9 6e 23 00 00       	jmp    80103460 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 0f 76 10 80       	push   $0x8010760f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 15 76 10 80       	push   $0x80107615
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
80101119:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
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
8010113c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
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
801011a9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 1f 76 10 80       	push   $0x8010761f
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
801011cd:	e8 ce 1b 00 00       	call   80102da0 <log_write>
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
801011f5:	e8 d6 38 00 00       	call   80104ad0 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 9e 1b 00 00       	call   80102da0 <log_write>
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
8010122a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 00 1a 11 80       	push   $0x80111a00
8010123a:	e8 11 37 00 00       	call   80104950 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
80101278:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
8010129a:	68 00 1a 11 80       	push   $0x80111a00
8010129f:	e8 cc 37 00 00       	call   80104a70 <release>

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
801012c5:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 9e 37 00 00       	call   80104a70 <release>
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
801012e2:	68 35 76 10 80       	push   $0x80107635
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
8010135e:	e8 3d 1a 00 00       	call   80102da0 <log_write>
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
801013b7:	68 45 76 10 80       	push   $0x80107645
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
801013f1:	e8 8a 37 00 00       	call   80104b80 <memmove>
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
8010141c:	68 e0 19 11 80       	push   $0x801119e0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
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
8010146a:	e8 31 19 00 00       	call   80102da0 <log_write>
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
80101484:	68 58 76 10 80       	push   $0x80107658
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 6b 76 10 80       	push   $0x8010766b
801014a1:	68 00 1a 11 80       	push   $0x80111a00
801014a6:	e8 b5 33 00 00       	call   80104860 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 72 76 10 80       	push   $0x80107672
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 8c 32 00 00       	call   80104750 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 e0 19 11 80       	push   $0x801119e0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 f8 19 11 80    	pushl  0x801119f8
801014e5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801014eb:	ff 35 f0 19 11 80    	pushl  0x801119f0
801014f1:	ff 35 ec 19 11 80    	pushl  0x801119ec
801014f7:	ff 35 e8 19 11 80    	pushl  0x801119e8
801014fd:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101503:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101509:	68 d8 76 10 80       	push   $0x801076d8
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
80101529:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
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
8010155f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
8010159e:	e8 2d 35 00 00       	call   80104ad0 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 eb 17 00 00       	call   80102da0 <log_write>
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
801015d3:	68 78 76 10 80       	push   $0x80107678
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
801015f4:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101641:	e8 3a 35 00 00       	call   80104b80 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 52 17 00 00       	call   80102da0 <log_write>
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
8010166a:	68 00 1a 11 80       	push   $0x80111a00
8010166f:	e8 dc 32 00 00       	call   80104950 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010167f:	e8 ec 33 00 00       	call   80104a70 <release>
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
801016b2:	e8 d9 30 00 00       	call   80104790 <acquiresleep>
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
801016d9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101728:	e8 53 34 00 00       	call   80104b80 <memmove>
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
8010174d:	68 90 76 10 80       	push   $0x80107690
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 8a 76 10 80       	push   $0x8010768a
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
80101783:	e8 a8 30 00 00       	call   80104830 <holdingsleep>
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
8010179f:	e9 4c 30 00 00       	jmp    801047f0 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 9f 76 10 80       	push   $0x8010769f
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
801017d0:	e8 bb 2f 00 00       	call   80104790 <acquiresleep>
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
801017ea:	e8 01 30 00 00       	call   801047f0 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017f6:	e8 55 31 00 00       	call   80104950 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 5b 32 00 00       	jmp    80104a70 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 1a 11 80       	push   $0x80111a00
80101820:	e8 2b 31 00 00       	call   80104950 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010182f:	e8 3c 32 00 00       	call   80104a70 <release>
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
80101a17:	e8 64 31 00 00       	call   80104b80 <memmove>
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
80101a4a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101b13:	e8 68 30 00 00       	call   80104b80 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 80 12 00 00       	call   80102da0 <log_write>
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
80101b5a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101bae:	e8 3d 30 00 00       	call   80104bf0 <strncmp>
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
80101c0d:	e8 de 2f 00 00       	call   80104bf0 <strncmp>
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
80101c52:	68 b9 76 10 80       	push   $0x801076b9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 a7 76 10 80       	push   $0x801076a7
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
80101c89:	e8 c2 1b 00 00       	call   80103850 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 1a 11 80       	push   $0x80111a00
80101c99:	e8 b2 2c 00 00       	call   80104950 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101ca9:	e8 c2 2d 00 00       	call   80104a70 <release>
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
80101d05:	e8 76 2e 00 00       	call   80104b80 <memmove>
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
80101d98:	e8 e3 2d 00 00       	call   80104b80 <memmove>
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
80101e8d:	e8 be 2d 00 00       	call   80104c50 <strncpy>
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
80101ecb:	68 c8 76 10 80       	push   $0x801076c8
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 c3 7d 10 80       	push   $0x80107dc3
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
80101feb:	68 34 77 10 80       	push   $0x80107734
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 2b 77 10 80       	push   $0x8010772b
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 46 77 10 80       	push   $0x80107746
8010201b:	68 80 b5 10 80       	push   $0x8010b580
80102020:	e8 3b 28 00 00       	call   80104860 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 20 3d 11 80       	mov    0x80113d20,%eax
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
8010206a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
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
80102099:	68 80 b5 10 80       	push   $0x8010b580
8010209e:	e8 ad 28 00 00       	call   80104950 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

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
80102101:	e8 ca 1e 00 00       	call   80103fd0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 b5 10 80       	push   $0x8010b580
8010211f:	e8 4c 29 00 00       	call   80104a70 <release>

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
8010213e:	e8 ed 26 00 00       	call   80104830 <holdingsleep>
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
80102163:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 b5 10 80       	push   $0x8010b580
80102178:	e8 d3 27 00 00       	call   80104950 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
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
801021a6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
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
801021c3:	68 80 b5 10 80       	push   $0x8010b580
801021c8:	53                   	push   %ebx
801021c9:	e8 52 1c 00 00       	call   80103e20 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 85 28 00 00       	jmp    80104a70 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 60 77 10 80       	push   $0x80107760
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 4a 77 10 80       	push   $0x8010774a
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 75 77 10 80       	push   $0x80107775
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
80102231:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 54 36 11 80       	mov    0x80113654,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
80102277:	68 94 77 10 80       	push   $0x80107794
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801022a2:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

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
801022c0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801022e1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801022f5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 54 36 11 80       	mov    0x80113654,%eax
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
80102336:	81 fb c8 68 11 80    	cmp    $0x801168c8,%ebx
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
80102356:	e8 75 27 00 00       	call   80104ad0 <memset>

  if(kmem.use_lock)
8010235b:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	85 d2                	test   %edx,%edx
80102366:	75 38                	jne    801023a0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102368:	a1 98 36 11 80       	mov    0x80113698,%eax
8010236d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  free_frame_cnt++;
  if(kmem.use_lock)
8010236f:	a1 94 36 11 80       	mov    0x80113694,%eax
  free_frame_cnt++;
80102374:	83 05 b4 b5 10 80 01 	addl   $0x1,0x8010b5b4
  kmem.freelist = r;
8010237b:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
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
80102390:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239a:	c9                   	leave  
    release(&kmem.lock);
8010239b:	e9 d0 26 00 00       	jmp    80104a70 <release>
    acquire(&kmem.lock);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 60 36 11 80       	push   $0x80113660
801023a8:	e8 a3 25 00 00       	call   80104950 <acquire>
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	eb b6                	jmp    80102368 <kfree+0x48>
    panic("kfree");
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 c6 77 10 80       	push   $0x801077c6
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
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dd:	39 de                	cmp    %ebx,%esi
801023df:	72 23                	jb     80102404 <freerange+0x44>
801023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023f7:	50                   	push   %eax
801023f8:	e8 23 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
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
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102418:	83 ec 08             	sub    $0x8,%esp
8010241b:	68 cc 77 10 80       	push   $0x801077cc
80102420:	68 60 36 11 80       	push   $0x80113660
80102425:	e8 36 24 00 00       	call   80104860 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102430:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102437:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102440:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102446:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244c:	39 de                	cmp    %ebx,%esi
8010244e:	72 1c                	jb     8010246c <kinit1+0x5c>
    kfree(p);
80102450:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102456:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102459:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010245f:	50                   	push   %eax
80102460:	e8 bb fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102465:	83 c4 10             	add    $0x10,%esp
80102468:	39 de                	cmp    %ebx,%esi
8010246a:	73 e4                	jae    80102450 <kinit1+0x40>
}
8010246c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010246f:	5b                   	pop    %ebx
80102470:	5e                   	pop    %esi
80102471:	5d                   	pop    %ebp
80102472:	c3                   	ret    
80102473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102488:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <kinit2+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 63 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 e4                	jae    801024a8 <kinit2+0x28>
  kmem.use_lock = 1;
801024c4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801024cb:	00 00 00 
}
801024ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d1:	5b                   	pop    %ebx
801024d2:	5e                   	pop    %esi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
801024d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024e0:	a1 94 36 11 80       	mov    0x80113694,%eax
801024e5:	85 c0                	test   %eax,%eax
801024e7:	75 27                	jne    80102510 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e9:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r){
801024ee:	85 c0                	test   %eax,%eax
801024f0:	74 16                	je     80102508 <kalloc+0x28>
    kmem.freelist = r->next;
801024f2:	8b 10                	mov    (%eax),%edx
    free_frame_cnt--;
801024f4:	83 2d b4 b5 10 80 01 	subl   $0x1,0x8010b5b4
    kmem.freelist = r->next;
801024fb:	89 15 98 36 11 80    	mov    %edx,0x80113698
80102501:	c3                   	ret    
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102508:	f3 c3                	repz ret 
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102516:	68 60 36 11 80       	push   $0x80113660
8010251b:	e8 30 24 00 00       	call   80104950 <acquire>
  r = kmem.freelist;
80102520:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r){
80102525:	83 c4 10             	add    $0x10,%esp
80102528:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010252e:	85 c0                	test   %eax,%eax
80102530:	74 0f                	je     80102541 <kalloc+0x61>
    kmem.freelist = r->next;
80102532:	8b 08                	mov    (%eax),%ecx
    free_frame_cnt--;
80102534:	83 2d b4 b5 10 80 01 	subl   $0x1,0x8010b5b4
    kmem.freelist = r->next;
8010253b:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102541:	85 d2                	test   %edx,%edx
80102543:	74 16                	je     8010255b <kalloc+0x7b>
    release(&kmem.lock);
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010254b:	68 60 36 11 80       	push   $0x80113660
80102550:	e8 1b 25 00 00       	call   80104a70 <release>
  return (char*)r;
80102555:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102558:	83 c4 10             	add    $0x10,%esp
}
8010255b:	c9                   	leave  
8010255c:	c3                   	ret    
8010255d:	66 90                	xchg   %ax,%ax
8010255f:	90                   	nop

80102560 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba 64 00 00 00       	mov    $0x64,%edx
80102565:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102566:	a8 01                	test   $0x1,%al
80102568:	0f 84 c2 00 00 00    	je     80102630 <kbdgetc+0xd0>
8010256e:	ba 60 00 00 00       	mov    $0x60,%edx
80102573:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102574:	0f b6 d0             	movzbl %al,%edx
80102577:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx

  if(data == 0xE0){
8010257d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102583:	0f 84 7f 00 00 00    	je     80102608 <kbdgetc+0xa8>
{
80102589:	55                   	push   %ebp
8010258a:	89 e5                	mov    %esp,%ebp
8010258c:	53                   	push   %ebx
8010258d:	89 cb                	mov    %ecx,%ebx
8010258f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102592:	84 c0                	test   %al,%al
80102594:	78 4a                	js     801025e0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102596:	85 db                	test   %ebx,%ebx
80102598:	74 09                	je     801025a3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010259a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010259d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025a0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025a3:	0f b6 82 00 79 10 80 	movzbl -0x7fef8700(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 00 78 10 80 	movzbl -0x7fef8800(%edx),%eax
801025b3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025b7:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
  c = charcode[shift & (CTL | SHIFT)][data];
801025bd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025c0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c3:	8b 04 85 e0 77 10 80 	mov    -0x7fef8820(,%eax,4),%eax
801025ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ce:	74 31                	je     80102601 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025d0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025d3:	83 fa 19             	cmp    $0x19,%edx
801025d6:	77 40                	ja     80102618 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025d8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025db:	5b                   	pop    %ebx
801025dc:	5d                   	pop    %ebp
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025e0:	83 e0 7f             	and    $0x7f,%eax
801025e3:	85 db                	test   %ebx,%ebx
801025e5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025e8:	0f b6 82 00 79 10 80 	movzbl -0x7fef8700(%edx),%eax
801025ef:	83 c8 40             	or     $0x40,%eax
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	f7 d0                	not    %eax
801025f7:	21 c1                	and    %eax,%ecx
    return 0;
801025f9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025fb:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
}
80102601:	5b                   	pop    %ebx
80102602:	5d                   	pop    %ebp
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102608:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010260b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010260d:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
    return 0;
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102618:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010261b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010261e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010261f:	83 f9 1a             	cmp    $0x1a,%ecx
80102622:	0f 42 c2             	cmovb  %edx,%eax
}
80102625:	5d                   	pop    %ebp
80102626:	c3                   	ret    
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102635:	c3                   	ret    
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <kbdintr>:

void
kbdintr(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102646:	68 60 25 10 80       	push   $0x80102560
8010264b:	e8 c0 e1 ff ff       	call   80100810 <consoleintr>
}
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	c9                   	leave  
80102654:	c3                   	ret    
80102655:	66 90                	xchg   %ax,%ax
80102657:	66 90                	xchg   %ax,%ax
80102659:	66 90                	xchg   %ax,%ax
8010265b:	66 90                	xchg   %ax,%ax
8010265d:	66 90                	xchg   %ax,%ax
8010265f:	90                   	nop

80102660 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c8 00 00 00    	je     80102738 <lapicinit+0xd8>
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 77                	ja     80102740 <lapicinit+0xe0>
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102720:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102726:	80 e6 10             	and    $0x10,%dh
80102729:	75 f5                	jne    80102720 <lapicinit+0xc0>
  lapic[index] = value;
8010272b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102732:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102735:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102740:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102747:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
8010274d:	e9 77 ff ff ff       	jmp    801026c9 <lapicinit+0x69>
80102752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102760:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102766:	55                   	push   %ebp
80102767:	31 c0                	xor    %eax,%eax
80102769:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010276b:	85 d2                	test   %edx,%edx
8010276d:	74 06                	je     80102775 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010276f:	8b 42 20             	mov    0x20(%edx),%eax
80102772:	c1 e8 18             	shr    $0x18,%eax
}
80102775:	5d                   	pop    %ebp
80102776:	c3                   	ret    
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027b6:	ba 70 00 00 00       	mov    $0x70,%edx
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	53                   	push   %ebx
801027be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	ba 71 00 00 00       	mov    $0x71,%edx
801027cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027dd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027e0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027e3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ee:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102803:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102809:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102810:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102813:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102816:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010281f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102828:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	b8 0b 00 00 00       	mov    $0xb,%eax
80102846:	ba 70 00 00 00       	mov    $0x70,%edx
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	ba 71 00 00 00       	mov    $0x71,%edx
80102859:	ec                   	in     (%dx),%al
8010285a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010285d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102862:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102865:	8d 76 00             	lea    0x0(%esi),%esi
80102868:	31 c0                	xor    %eax,%eax
8010286a:	89 da                	mov    %ebx,%edx
8010286c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102872:	89 ca                	mov    %ecx,%edx
80102874:	ec                   	in     (%dx),%al
80102875:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	89 da                	mov    %ebx,%edx
8010287a:	b8 02 00 00 00       	mov    $0x2,%eax
8010287f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	89 ca                	mov    %ecx,%edx
80102882:	ec                   	in     (%dx),%al
80102883:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102886:	89 da                	mov    %ebx,%edx
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
80102891:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 da                	mov    %ebx,%edx
80102896:	b8 07 00 00 00       	mov    $0x7,%eax
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
8010289f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 da                	mov    %ebx,%edx
801028a4:	b8 08 00 00 00       	mov    $0x8,%eax
801028a9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028aa:	89 ca                	mov    %ecx,%edx
801028ac:	ec                   	in     (%dx),%al
801028ad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028af:	89 da                	mov    %ebx,%edx
801028b1:	b8 09 00 00 00       	mov    $0x9,%eax
801028b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b7:	89 ca                	mov    %ecx,%edx
801028b9:	ec                   	in     (%dx),%al
801028ba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	89 ca                	mov    %ecx,%edx
801028c6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028c7:	84 c0                	test   %al,%al
801028c9:	78 9d                	js     80102868 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028cb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028cf:	89 fa                	mov    %edi,%edx
801028d1:	0f b6 fa             	movzbl %dl,%edi
801028d4:	89 f2                	mov    %esi,%edx
801028d6:	0f b6 f2             	movzbl %dl,%esi
801028d9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028dc:	89 da                	mov    %ebx,%edx
801028de:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028e4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028eb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028f2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028f9:	31 c0                	xor    %eax,%eax
801028fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	89 ca                	mov    %ecx,%edx
801028fe:	ec                   	in     (%dx),%al
801028ff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102902:	89 da                	mov    %ebx,%edx
80102904:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102907:	b8 02 00 00 00       	mov    $0x2,%eax
8010290c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	89 ca                	mov    %ecx,%edx
8010290f:	ec                   	in     (%dx),%al
80102910:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102913:	89 da                	mov    %ebx,%edx
80102915:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102918:	b8 04 00 00 00       	mov    $0x4,%eax
8010291d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291e:	89 ca                	mov    %ecx,%edx
80102920:	ec                   	in     (%dx),%al
80102921:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102924:	89 da                	mov    %ebx,%edx
80102926:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102929:	b8 07 00 00 00       	mov    $0x7,%eax
8010292e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292f:	89 ca                	mov    %ecx,%edx
80102931:	ec                   	in     (%dx),%al
80102932:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	89 da                	mov    %ebx,%edx
80102937:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010293a:	b8 08 00 00 00       	mov    $0x8,%eax
8010293f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
80102943:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 da                	mov    %ebx,%edx
80102948:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010294b:	b8 09 00 00 00       	mov    $0x9,%eax
80102950:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102951:	89 ca                	mov    %ecx,%edx
80102953:	ec                   	in     (%dx),%al
80102954:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102957:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010295a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010295d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102960:	6a 18                	push   $0x18
80102962:	50                   	push   %eax
80102963:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102966:	50                   	push   %eax
80102967:	e8 b4 21 00 00       	call   80104b20 <memcmp>
8010296c:	83 c4 10             	add    $0x10,%esp
8010296f:	85 c0                	test   %eax,%eax
80102971:	0f 85 f1 fe ff ff    	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102977:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010297b:	75 78                	jne    801029f5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010297d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102980:	89 c2                	mov    %eax,%edx
80102982:	83 e0 0f             	and    $0xf,%eax
80102985:	c1 ea 04             	shr    $0x4,%edx
80102988:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102991:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102994:	89 c2                	mov    %eax,%edx
80102996:	83 e0 0f             	and    $0xf,%eax
80102999:	c1 ea 04             	shr    $0x4,%edx
8010299c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a8:	89 c2                	mov    %eax,%edx
801029aa:	83 e0 0f             	and    $0xf,%eax
801029ad:	c1 ea 04             	shr    $0x4,%edx
801029b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029bc:	89 c2                	mov    %eax,%edx
801029be:	83 e0 0f             	and    $0xf,%eax
801029c1:	c1 ea 04             	shr    $0x4,%edx
801029c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029d0:	89 c2                	mov    %eax,%edx
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	c1 ea 04             	shr    $0x4,%edx
801029d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029de:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e4:	89 c2                	mov    %eax,%edx
801029e6:	83 e0 0f             	and    $0xf,%eax
801029e9:	c1 ea 04             	shr    $0x4,%edx
801029ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029f5:	8b 75 08             	mov    0x8(%ebp),%esi
801029f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029fb:	89 06                	mov    %eax,(%esi)
801029fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a00:	89 46 04             	mov    %eax,0x4(%esi)
80102a03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a06:	89 46 08             	mov    %eax,0x8(%esi)
80102a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a12:	89 46 10             	mov    %eax,0x10(%esi)
80102a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a25:	5b                   	pop    %ebx
80102a26:	5e                   	pop    %esi
80102a27:	5f                   	pop    %edi
80102a28:	5d                   	pop    %ebp
80102a29:	c3                   	ret    
80102a2a:	66 90                	xchg   %ax,%ax
80102a2c:	66 90                	xchg   %ax,%ax
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a30:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102a36:	85 c9                	test   %ecx,%ecx
80102a38:	0f 8e 8a 00 00 00    	jle    80102ac8 <install_trans+0x98>
{
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	57                   	push   %edi
80102a42:	56                   	push   %esi
80102a43:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a44:	31 db                	xor    %ebx,%ebx
{
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a50:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102a74:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7d:	e8 4e d6 ff ff       	call   801000d0 <bread>
80102a82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a87:	83 c4 0c             	add    $0xc,%esp
80102a8a:	68 00 02 00 00       	push   $0x200
80102a8f:	50                   	push   %eax
80102a90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a93:	50                   	push   %eax
80102a94:	e8 e7 20 00 00       	call   80104b80 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 ff d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102aa1:	89 3c 24             	mov    %edi,(%esp)
80102aa4:	e8 37 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 2f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ab1:	83 c4 10             	add    $0x10,%esp
80102ab4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102aba:	7f 94                	jg     80102a50 <install_trans+0x20>
  }
}
80102abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102abf:	5b                   	pop    %ebx
80102ac0:	5e                   	pop    %esi
80102ac1:	5f                   	pop    %edi
80102ac2:	5d                   	pop    %ebp
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ac8:	f3 c3                	repz ret 
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ad5:	83 ec 08             	sub    $0x8,%esp
80102ad8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102ade:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102af2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102af4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102af6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102af9:	7e 16                	jle    80102b11 <write_head+0x41>
80102afb:	c1 e3 02             	shl    $0x2,%ebx
80102afe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b00:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102b06:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b0a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <write_head+0x30>
  }
  bwrite(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	56                   	push   %esi
80102b15:	e8 86 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b1a:	89 34 24             	mov    %esi,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>
}
80102b22:	83 c4 10             	add    $0x10,%esp
80102b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b28:	5b                   	pop    %ebx
80102b29:	5e                   	pop    %esi
80102b2a:	5d                   	pop    %ebp
80102b2b:	c3                   	ret    
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <initlog>:
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 2c             	sub    $0x2c,%esp
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b3a:	68 00 7a 10 80       	push   $0x80107a00
80102b3f:	68 a0 36 11 80       	push   $0x801136a0
80102b44:	e8 17 1d 00 00       	call   80104860 <initlock>
  readsb(dev, &sb);
80102b49:	58                   	pop    %eax
80102b4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b e8 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b5b:	59                   	pop    %ecx
  log.dev = dev;
80102b5c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102b62:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102b68:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	5a                   	pop    %edx
80102b6e:	50                   	push   %eax
80102b6f:	53                   	push   %ebx
80102b70:	e8 5b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b75:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b7d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	c1 e3 02             	shl    $0x2,%ebx
80102b88:	31 d2                	xor    %edx,%edx
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b9d:	39 d3                	cmp    %edx,%ebx
80102b9f:	75 ef                	jne    80102b90 <initlog+0x60>
  brelse(buf);
80102ba1:	83 ec 0c             	sub    $0xc,%esp
80102ba4:	50                   	push   %eax
80102ba5:	e8 36 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102baa:	e8 81 fe ff ff       	call   80102a30 <install_trans>
  log.lh.n = 0;
80102baf:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102bb6:	00 00 00 
  write_head(); // clear the log
80102bb9:	e8 12 ff ff ff       	call   80102ad0 <write_head>
}
80102bbe:	83 c4 10             	add    $0x10,%esp
80102bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc4:	c9                   	leave  
80102bc5:	c3                   	ret    
80102bc6:	8d 76 00             	lea    0x0(%esi),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bd6:	68 a0 36 11 80       	push   $0x801136a0
80102bdb:	e8 70 1d 00 00       	call   80104950 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 a0 36 11 80       	push   $0x801136a0
80102bf0:	68 a0 36 11 80       	push   $0x801136a0
80102bf5:	e8 26 12 00 00       	call   80103e20 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bfd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102c0b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102c11:	83 c0 01             	add    $0x1,%eax
80102c14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c1a:	83 fa 1e             	cmp    $0x1e,%edx
80102c1d:	7f c9                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c22:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102c27:	68 a0 36 11 80       	push   $0x801136a0
80102c2c:	e8 3f 1e 00 00       	call   80104a70 <release>
      break;
    }
  }
}
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	68 a0 36 11 80       	push   $0x801136a0
80102c4e:	e8 fd 1c 00 00       	call   80104950 <acquire>
  log.outstanding -= 1;
80102c53:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c58:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102c5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c66:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102c6c:	0f 85 1a 01 00 00    	jne    80102d8c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c72:	85 db                	test   %ebx,%ebx
80102c74:	0f 85 ee 00 00 00    	jne    80102d68 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c7a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c7d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c84:	00 00 00 
  release(&log.lock);
80102c87:	68 a0 36 11 80       	push   $0x801136a0
80102c8c:	e8 df 1d 00 00       	call   80104a70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c91:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	85 c9                	test   %ecx,%ecx
80102c9c:	0f 8e 85 00 00 00    	jle    80102d27 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	01 d8                	add    %ebx,%eax
80102cac:	83 c0 01             	add    $0x1,%eax
80102caf:	50                   	push   %eax
80102cb0:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	58                   	pop    %eax
80102cbe:	5a                   	pop    %edx
80102cbf:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102cc6:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccf:	e8 fc d3 ff ff       	call   801000d0 <bread>
80102cd4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cd6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cd9:	83 c4 0c             	add    $0xc,%esp
80102cdc:	68 00 02 00 00       	push   $0x200
80102ce1:	50                   	push   %eax
80102ce2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ce5:	50                   	push   %eax
80102ce6:	e8 95 1e 00 00       	call   80104b80 <memmove>
    bwrite(to);  // write the log
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ad d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cf3:	89 3c 24             	mov    %edi,(%esp)
80102cf6:	e8 e5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 dd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d03:	83 c4 10             	add    $0x10,%esp
80102d06:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102d0c:	7c 94                	jl     80102ca2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d0e:	e8 bd fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d13:	e8 18 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d18:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d1f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d22:	e8 a9 fd ff ff       	call   80102ad0 <write_head>
    acquire(&log.lock);
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 a0 36 11 80       	push   $0x801136a0
80102d2f:	e8 1c 1c 00 00       	call   80104950 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d3b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 86 12 00 00       	call   80103fd0 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d51:	e8 1a 1d 00 00       	call   80104a70 <release>
80102d56:	83 c4 10             	add    $0x10,%esp
}
80102d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5c:	5b                   	pop    %ebx
80102d5d:	5e                   	pop    %esi
80102d5e:	5f                   	pop    %edi
80102d5f:	5d                   	pop    %ebp
80102d60:	c3                   	ret    
80102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d68:	83 ec 0c             	sub    $0xc,%esp
80102d6b:	68 a0 36 11 80       	push   $0x801136a0
80102d70:	e8 5b 12 00 00       	call   80103fd0 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d7c:	e8 ef 1c 00 00       	call   80104a70 <release>
80102d81:	83 c4 10             	add    $0x10,%esp
}
80102d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d87:	5b                   	pop    %ebx
80102d88:	5e                   	pop    %esi
80102d89:	5f                   	pop    %edi
80102d8a:	5d                   	pop    %ebp
80102d8b:	c3                   	ret    
    panic("log.committing");
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 04 7a 10 80       	push   $0x80107a04
80102d94:	e8 f7 d5 ff ff       	call   80100390 <panic>
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102da0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 9d 00 00 00    	jg     80102e56 <log_write+0xb6>
80102db9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 8d 00 00 00    	jge    80102e56 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 8d 00 00 00    	jle    80102e63 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 a0 36 11 80       	push   $0x801136a0
80102dde:	e8 6d 1b 00 00       	call   80104950 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 f9 00             	cmp    $0x0,%ecx
80102def:	7e 57                	jle    80102e48 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 c1                	cmp    %eax,%ecx
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c0 01             	add    $0x1,%eax
80102e1a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102e1f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e22:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2c:	c9                   	leave  
  release(&log.lock);
80102e2d:	e9 3e 1c 00 00       	jmp    80104a70 <release>
80102e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e38:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102e3f:	eb de                	jmp    80102e1f <log_write+0x7f>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8b 43 08             	mov    0x8(%ebx),%eax
80102e4b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102e50:	75 cd                	jne    80102e1f <log_write+0x7f>
80102e52:	31 c0                	xor    %eax,%eax
80102e54:	eb c1                	jmp    80102e17 <log_write+0x77>
    panic("too big a transaction");
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 13 7a 10 80       	push   $0x80107a13
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 29 7a 10 80       	push   $0x80107a29
80102e6b:	e8 20 d5 ff ff       	call   80100390 <panic>

80102e70 <mpmain>:

extern int free_frame_cnt;
// Common CPU setup code.
static void
mpmain(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 04             	sub    $0x4,%esp
  //cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
  //--------------------------------------------------------------------------
  cprintf("cpu%d: starting %d ----------------------------------  Running fsck ...\n", cpuid(), cpuid());
80102e77:	e8 b4 09 00 00       	call   80103830 <cpuid>
80102e7c:	89 c3                	mov    %eax,%ebx
80102e7e:	e8 ad 09 00 00       	call   80103830 <cpuid>
80102e83:	83 ec 04             	sub    $0x4,%esp
80102e86:	53                   	push   %ebx
80102e87:	50                   	push   %eax
80102e88:	68 44 7a 10 80       	push   $0x80107a44
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  check_fs();
80102e92:	e8 29 17 00 00       	call   801045c0 <check_fs>
  cprintf("Finish fsck ...\n", cpuid(), cpuid());
80102e97:	e8 94 09 00 00       	call   80103830 <cpuid>
80102e9c:	89 c3                	mov    %eax,%ebx
80102e9e:	e8 8d 09 00 00       	call   80103830 <cpuid>
80102ea3:	83 c4 0c             	add    $0xc,%esp
80102ea6:	53                   	push   %ebx
80102ea7:	50                   	push   %eax
80102ea8:	68 8d 7a 10 80       	push   $0x80107a8d
80102ead:	e8 ae d7 ff ff       	call   80100660 <cprintf>
  //---------------------------------------------------------------------------
  idtinit();       // load idt register
80102eb2:	e8 c9 2e 00 00       	call   80105d80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102eb7:	e8 f4 08 00 00       	call   801037b0 <mycpu>
80102ebc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ebe:	b8 01 00 00 00       	mov    $0x1,%eax
80102ec3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  cprintf("\nnumber of free frames: %d \n",free_frame_cnt);
80102eca:	58                   	pop    %eax
80102ecb:	5a                   	pop    %edx
80102ecc:	ff 35 b4 b5 10 80    	pushl  0x8010b5b4
80102ed2:	68 9e 7a 10 80       	push   $0x80107a9e
80102ed7:	e8 84 d7 ff ff       	call   80100660 <cprintf>
  
  scheduler();     // start running processes
80102edc:	e8 0f 0b 00 00       	call   801039f0 <scheduler>
80102ee1:	eb 0d                	jmp    80102ef0 <mpenter>
80102ee3:	90                   	nop
80102ee4:	90                   	nop
80102ee5:	90                   	nop
80102ee6:	90                   	nop
80102ee7:	90                   	nop
80102ee8:	90                   	nop
80102ee9:	90                   	nop
80102eea:	90                   	nop
80102eeb:	90                   	nop
80102eec:	90                   	nop
80102eed:	90                   	nop
80102eee:	90                   	nop
80102eef:	90                   	nop

80102ef0 <mpenter>:
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ef6:	e8 75 3f 00 00       	call   80106e70 <switchkvm>
  seginit();
80102efb:	e8 e0 3e 00 00       	call   80106de0 <seginit>
  lapicinit();
80102f00:	e8 5b f7 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102f05:	e8 66 ff ff ff       	call   80102e70 <mpmain>
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <main>:
{
80102f10:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f14:	83 e4 f0             	and    $0xfffffff0,%esp
80102f17:	ff 71 fc             	pushl  -0x4(%ecx)
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
80102f1d:	53                   	push   %ebx
80102f1e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f1f:	83 ec 08             	sub    $0x8,%esp
80102f22:	68 00 00 40 80       	push   $0x80400000
80102f27:	68 c8 68 11 80       	push   $0x801168c8
80102f2c:	e8 df f4 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102f31:	e8 0a 44 00 00       	call   80107340 <kvmalloc>
  mpinit();        // detect other processors
80102f36:	e8 75 01 00 00       	call   801030b0 <mpinit>
  lapicinit();     // interrupt controller
80102f3b:	e8 20 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f40:	e8 9b 3e 00 00       	call   80106de0 <seginit>
  picinit();       // disable pic
80102f45:	e8 46 03 00 00       	call   80103290 <picinit>
  ioapicinit();    // another interrupt controller
80102f4a:	e8 e1 f2 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102f4f:	e8 6c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f54:	e8 57 31 00 00       	call   801060b0 <uartinit>
  pinit();         // process table
80102f59:	e8 32 08 00 00       	call   80103790 <pinit>
  tvinit();        // trap vectors
80102f5e:	e8 9d 2d 00 00       	call   80105d00 <tvinit>
  binit();         // buffer cache
80102f63:	e8 d8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f68:	e8 f3 dd ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f6d:	e8 9e f0 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f72:	83 c4 0c             	add    $0xc,%esp
80102f75:	68 8a 00 00 00       	push   $0x8a
80102f7a:	68 8c b4 10 80       	push   $0x8010b48c
80102f7f:	68 00 70 00 80       	push   $0x80007000
80102f84:	e8 f7 1b 00 00       	call   80104b80 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f89:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80102f90:	00 00 00 
80102f93:	83 c4 10             	add    $0x10,%esp
80102f96:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f9b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80102fa0:	76 71                	jbe    80103013 <main+0x103>
80102fa2:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fb0:	e8 fb 07 00 00       	call   801037b0 <mycpu>
80102fb5:	39 d8                	cmp    %ebx,%eax
80102fb7:	74 41                	je     80102ffa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fb9:	e8 22 f5 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fbe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fc3:	c7 05 f8 6f 00 80 f0 	movl   $0x80102ef0,0x80006ff8
80102fca:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fcd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fd4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fd7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fdc:	0f b6 03             	movzbl (%ebx),%eax
80102fdf:	83 ec 08             	sub    $0x8,%esp
80102fe2:	68 00 70 00 00       	push   $0x7000
80102fe7:	50                   	push   %eax
80102fe8:	e8 c3 f7 ff ff       	call   801027b0 <lapicstartap>
80102fed:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ff0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ff6:	85 c0                	test   %eax,%eax
80102ff8:	74 f6                	je     80102ff0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102ffa:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103001:	00 00 00 
80103004:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010300a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010300f:	39 c3                	cmp    %eax,%ebx
80103011:	72 9d                	jb     80102fb0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103013:	83 ec 08             	sub    $0x8,%esp
80103016:	68 00 00 00 8e       	push   $0x8e000000
8010301b:	68 00 00 40 80       	push   $0x80400000
80103020:	e8 5b f4 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80103025:	e8 56 08 00 00       	call   80103880 <userinit>
  mpmain();        // finish this processor's setup
8010302a:	e8 41 fe ff ff       	call   80102e70 <mpmain>
8010302f:	90                   	nop

80103030 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103035:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010303b:	53                   	push   %ebx
  e = addr+len;
8010303c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010303f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103042:	39 de                	cmp    %ebx,%esi
80103044:	72 10                	jb     80103056 <mpsearch1+0x26>
80103046:	eb 50                	jmp    80103098 <mpsearch1+0x68>
80103048:	90                   	nop
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103050:	39 fb                	cmp    %edi,%ebx
80103052:	89 fe                	mov    %edi,%esi
80103054:	76 42                	jbe    80103098 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103056:	83 ec 04             	sub    $0x4,%esp
80103059:	8d 7e 10             	lea    0x10(%esi),%edi
8010305c:	6a 04                	push   $0x4
8010305e:	68 bb 7a 10 80       	push   $0x80107abb
80103063:	56                   	push   %esi
80103064:	e8 b7 1a 00 00       	call   80104b20 <memcmp>
80103069:	83 c4 10             	add    $0x10,%esp
8010306c:	85 c0                	test   %eax,%eax
8010306e:	75 e0                	jne    80103050 <mpsearch1+0x20>
80103070:	89 f1                	mov    %esi,%ecx
80103072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103078:	0f b6 11             	movzbl (%ecx),%edx
8010307b:	83 c1 01             	add    $0x1,%ecx
8010307e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103080:	39 f9                	cmp    %edi,%ecx
80103082:	75 f4                	jne    80103078 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103084:	84 c0                	test   %al,%al
80103086:	75 c8                	jne    80103050 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308b:	89 f0                	mov    %esi,%eax
8010308d:	5b                   	pop    %ebx
8010308e:	5e                   	pop    %esi
8010308f:	5f                   	pop    %edi
80103090:	5d                   	pop    %ebp
80103091:	c3                   	ret    
80103092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010309b:	31 f6                	xor    %esi,%esi
}
8010309d:	89 f0                	mov    %esi,%eax
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret    
801030a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
801030b5:	53                   	push   %ebx
801030b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030c7:	c1 e0 08             	shl    $0x8,%eax
801030ca:	09 d0                	or     %edx,%eax
801030cc:	c1 e0 04             	shl    $0x4,%eax
801030cf:	85 c0                	test   %eax,%eax
801030d1:	75 1b                	jne    801030ee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030e1:	c1 e0 08             	shl    $0x8,%eax
801030e4:	09 d0                	or     %edx,%eax
801030e6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030e9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ee:	ba 00 04 00 00       	mov    $0x400,%edx
801030f3:	e8 38 ff ff ff       	call   80103030 <mpsearch1>
801030f8:	85 c0                	test   %eax,%eax
801030fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030fd:	0f 84 3d 01 00 00    	je     80103240 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103106:	8b 58 04             	mov    0x4(%eax),%ebx
80103109:	85 db                	test   %ebx,%ebx
8010310b:	0f 84 4f 01 00 00    	je     80103260 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103111:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103117:	83 ec 04             	sub    $0x4,%esp
8010311a:	6a 04                	push   $0x4
8010311c:	68 d8 7a 10 80       	push   $0x80107ad8
80103121:	56                   	push   %esi
80103122:	e8 f9 19 00 00       	call   80104b20 <memcmp>
80103127:	83 c4 10             	add    $0x10,%esp
8010312a:	85 c0                	test   %eax,%eax
8010312c:	0f 85 2e 01 00 00    	jne    80103260 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103132:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103139:	3c 01                	cmp    $0x1,%al
8010313b:	0f 95 c2             	setne  %dl
8010313e:	3c 04                	cmp    $0x4,%al
80103140:	0f 95 c0             	setne  %al
80103143:	20 c2                	and    %al,%dl
80103145:	0f 85 15 01 00 00    	jne    80103260 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010314b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103152:	66 85 ff             	test   %di,%di
80103155:	74 1a                	je     80103171 <mpinit+0xc1>
80103157:	89 f0                	mov    %esi,%eax
80103159:	01 f7                	add    %esi,%edi
  sum = 0;
8010315b:	31 d2                	xor    %edx,%edx
8010315d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103160:	0f b6 08             	movzbl (%eax),%ecx
80103163:	83 c0 01             	add    $0x1,%eax
80103166:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103168:	39 c7                	cmp    %eax,%edi
8010316a:	75 f4                	jne    80103160 <mpinit+0xb0>
8010316c:	84 d2                	test   %dl,%dl
8010316e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103171:	85 f6                	test   %esi,%esi
80103173:	0f 84 e7 00 00 00    	je     80103260 <mpinit+0x1b0>
80103179:	84 d2                	test   %dl,%dl
8010317b:	0f 85 df 00 00 00    	jne    80103260 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103181:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103187:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010318c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103193:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103199:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010319e:	01 d6                	add    %edx,%esi
801031a0:	39 c6                	cmp    %eax,%esi
801031a2:	76 23                	jbe    801031c7 <mpinit+0x117>
    switch(*p){
801031a4:	0f b6 10             	movzbl (%eax),%edx
801031a7:	80 fa 04             	cmp    $0x4,%dl
801031aa:	0f 87 ca 00 00 00    	ja     8010327a <mpinit+0x1ca>
801031b0:	ff 24 95 00 7b 10 80 	jmp    *-0x7fef8500(,%edx,4)
801031b7:	89 f6                	mov    %esi,%esi
801031b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031c0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031c3:	39 c6                	cmp    %eax,%esi
801031c5:	77 dd                	ja     801031a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031c7:	85 db                	test   %ebx,%ebx
801031c9:	0f 84 9e 00 00 00    	je     8010326d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031d6:	74 15                	je     801031ed <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d8:	b8 70 00 00 00       	mov    $0x70,%eax
801031dd:	ba 22 00 00 00       	mov    $0x22,%edx
801031e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e3:	ba 23 00 00 00       	mov    $0x23,%edx
801031e8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031e9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ec:	ee                   	out    %al,(%dx)
  }
}
801031ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031f0:	5b                   	pop    %ebx
801031f1:	5e                   	pop    %esi
801031f2:	5f                   	pop    %edi
801031f3:	5d                   	pop    %ebp
801031f4:	c3                   	ret    
801031f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031f8:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
801031fe:	83 f9 07             	cmp    $0x7,%ecx
80103201:	7f 19                	jg     8010321c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103203:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103207:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010320d:	83 c1 01             	add    $0x1,%ecx
80103210:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103216:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
8010321c:	83 c0 14             	add    $0x14,%eax
      continue;
8010321f:	e9 7c ff ff ff       	jmp    801031a0 <mpinit+0xf0>
80103224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103228:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010322c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010322f:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
80103235:	e9 66 ff ff ff       	jmp    801031a0 <mpinit+0xf0>
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103240:	ba 00 00 01 00       	mov    $0x10000,%edx
80103245:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010324a:	e8 e1 fd ff ff       	call   80103030 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010324f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	0f 85 a9 fe ff ff    	jne    80103103 <mpinit+0x53>
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103260:	83 ec 0c             	sub    $0xc,%esp
80103263:	68 c0 7a 10 80       	push   $0x80107ac0
80103268:	e8 23 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010326d:	83 ec 0c             	sub    $0xc,%esp
80103270:	68 e0 7a 10 80       	push   $0x80107ae0
80103275:	e8 16 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010327a:	31 db                	xor    %ebx,%ebx
8010327c:	e9 26 ff ff ff       	jmp    801031a7 <mpinit+0xf7>
80103281:	66 90                	xchg   %ax,%ax
80103283:	66 90                	xchg   %ax,%ax
80103285:	66 90                	xchg   %ax,%ax
80103287:	66 90                	xchg   %ax,%ax
80103289:	66 90                	xchg   %ax,%ax
8010328b:	66 90                	xchg   %ax,%ax
8010328d:	66 90                	xchg   %ax,%ax
8010328f:	90                   	nop

80103290 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103290:	55                   	push   %ebp
80103291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103296:	ba 21 00 00 00       	mov    $0x21,%edx
8010329b:	89 e5                	mov    %esp,%ebp
8010329d:	ee                   	out    %al,(%dx)
8010329e:	ba a1 00 00 00       	mov    $0xa1,%edx
801032a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032a4:	5d                   	pop    %ebp
801032a5:	c3                   	ret    
801032a6:	66 90                	xchg   %ax,%ax
801032a8:	66 90                	xchg   %ax,%ax
801032aa:	66 90                	xchg   %ax,%ax
801032ac:	66 90                	xchg   %ax,%ax
801032ae:	66 90                	xchg   %ax,%ax

801032b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032cb:	e8 b0 da ff ff       	call   80100d80 <filealloc>
801032d0:	85 c0                	test   %eax,%eax
801032d2:	89 03                	mov    %eax,(%ebx)
801032d4:	74 22                	je     801032f8 <pipealloc+0x48>
801032d6:	e8 a5 da ff ff       	call   80100d80 <filealloc>
801032db:	85 c0                	test   %eax,%eax
801032dd:	89 06                	mov    %eax,(%esi)
801032df:	74 3f                	je     80103320 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032e1:	e8 fa f1 ff ff       	call   801024e0 <kalloc>
801032e6:	85 c0                	test   %eax,%eax
801032e8:	89 c7                	mov    %eax,%edi
801032ea:	75 54                	jne    80103340 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032ec:	8b 03                	mov    (%ebx),%eax
801032ee:	85 c0                	test   %eax,%eax
801032f0:	75 34                	jne    80103326 <pipealloc+0x76>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	74 0c                	je     8010330a <pipealloc+0x5a>
    fileclose(*f1);
801032fe:	83 ec 0c             	sub    $0xc,%esp
80103301:	50                   	push   %eax
80103302:	e8 39 db ff ff       	call   80100e40 <fileclose>
80103307:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010330a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010330d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103312:	5b                   	pop    %ebx
80103313:	5e                   	pop    %esi
80103314:	5f                   	pop    %edi
80103315:	5d                   	pop    %ebp
80103316:	c3                   	ret    
80103317:	89 f6                	mov    %esi,%esi
80103319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103320:	8b 03                	mov    (%ebx),%eax
80103322:	85 c0                	test   %eax,%eax
80103324:	74 e4                	je     8010330a <pipealloc+0x5a>
    fileclose(*f0);
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	50                   	push   %eax
8010332a:	e8 11 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010332f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103331:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103334:	85 c0                	test   %eax,%eax
80103336:	75 c6                	jne    801032fe <pipealloc+0x4e>
80103338:	eb d0                	jmp    8010330a <pipealloc+0x5a>
8010333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103340:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103343:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010334a:	00 00 00 
  p->writeopen = 1;
8010334d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103354:	00 00 00 
  p->nwrite = 0;
80103357:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010335e:	00 00 00 
  p->nread = 0;
80103361:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103368:	00 00 00 
  initlock(&p->lock, "pipe");
8010336b:	68 14 7b 10 80       	push   $0x80107b14
80103370:	50                   	push   %eax
80103371:	e8 ea 14 00 00       	call   80104860 <initlock>
  (*f0)->type = FD_PIPE;
80103376:	8b 03                	mov    (%ebx),%eax
  return 0;
80103378:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010337b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103381:	8b 03                	mov    (%ebx),%eax
80103383:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103387:	8b 03                	mov    (%ebx),%eax
80103389:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010338d:	8b 03                	mov    (%ebx),%eax
8010338f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103392:	8b 06                	mov    (%esi),%eax
80103394:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010339a:	8b 06                	mov    (%esi),%eax
8010339c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033a0:	8b 06                	mov    (%esi),%eax
801033a2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033a6:	8b 06                	mov    (%esi),%eax
801033a8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ae:	31 c0                	xor    %eax,%eax
}
801033b0:	5b                   	pop    %ebx
801033b1:	5e                   	pop    %esi
801033b2:	5f                   	pop    %edi
801033b3:	5d                   	pop    %ebp
801033b4:	c3                   	ret    
801033b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	56                   	push   %esi
801033c4:	53                   	push   %ebx
801033c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033cb:	83 ec 0c             	sub    $0xc,%esp
801033ce:	53                   	push   %ebx
801033cf:	e8 7c 15 00 00       	call   80104950 <acquire>
  if(writable){
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	85 f6                	test   %esi,%esi
801033d9:	74 45                	je     80103420 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033eb:	00 00 00 
    wakeup(&p->nread);
801033ee:	50                   	push   %eax
801033ef:	e8 dc 0b 00 00       	call   80103fd0 <wakeup>
801033f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033fd:	85 d2                	test   %edx,%edx
801033ff:	75 0a                	jne    8010340b <pipeclose+0x4b>
80103401:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103407:	85 c0                	test   %eax,%eax
80103409:	74 35                	je     80103440 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010340b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010340e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103411:	5b                   	pop    %ebx
80103412:	5e                   	pop    %esi
80103413:	5d                   	pop    %ebp
    release(&p->lock);
80103414:	e9 57 16 00 00       	jmp    80104a70 <release>
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103420:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103426:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103429:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103430:	00 00 00 
    wakeup(&p->nwrite);
80103433:	50                   	push   %eax
80103434:	e8 97 0b 00 00       	call   80103fd0 <wakeup>
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	eb b9                	jmp    801033f7 <pipeclose+0x37>
8010343e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	53                   	push   %ebx
80103444:	e8 27 16 00 00       	call   80104a70 <release>
    kfree((char*)p);
80103449:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010344c:	83 c4 10             	add    $0x10,%esp
}
8010344f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103452:	5b                   	pop    %ebx
80103453:	5e                   	pop    %esi
80103454:	5d                   	pop    %ebp
    kfree((char*)p);
80103455:	e9 c6 ee ff ff       	jmp    80102320 <kfree>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103460 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 28             	sub    $0x28,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010346c:	53                   	push   %ebx
8010346d:	e8 de 14 00 00       	call   80104950 <acquire>
  for(i = 0; i < n; i++){
80103472:	8b 45 10             	mov    0x10(%ebp),%eax
80103475:	83 c4 10             	add    $0x10,%esp
80103478:	85 c0                	test   %eax,%eax
8010347a:	0f 8e c9 00 00 00    	jle    80103549 <pipewrite+0xe9>
80103480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103483:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103489:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010348f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103492:	03 4d 10             	add    0x10(%ebp),%ecx
80103495:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103498:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010349e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034a4:	39 d0                	cmp    %edx,%eax
801034a6:	75 71                	jne    80103519 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034a8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	74 4e                	je     80103500 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034b2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034b8:	eb 3a                	jmp    801034f4 <pipewrite+0x94>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	57                   	push   %edi
801034c4:	e8 07 0b 00 00       	call   80103fd0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c9:	5a                   	pop    %edx
801034ca:	59                   	pop    %ecx
801034cb:	53                   	push   %ebx
801034cc:	56                   	push   %esi
801034cd:	e8 4e 09 00 00       	call   80103e20 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034d8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034de:	83 c4 10             	add    $0x10,%esp
801034e1:	05 00 02 00 00       	add    $0x200,%eax
801034e6:	39 c2                	cmp    %eax,%edx
801034e8:	75 36                	jne    80103520 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ea:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034f0:	85 c0                	test   %eax,%eax
801034f2:	74 0c                	je     80103500 <pipewrite+0xa0>
801034f4:	e8 57 03 00 00       	call   80103850 <myproc>
801034f9:	8b 40 24             	mov    0x24(%eax),%eax
801034fc:	85 c0                	test   %eax,%eax
801034fe:	74 c0                	je     801034c0 <pipewrite+0x60>
        release(&p->lock);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	53                   	push   %ebx
80103504:	e8 67 15 00 00       	call   80104a70 <release>
        return -1;
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103514:	5b                   	pop    %ebx
80103515:	5e                   	pop    %esi
80103516:	5f                   	pop    %edi
80103517:	5d                   	pop    %ebp
80103518:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103519:	89 c2                	mov    %eax,%edx
8010351b:	90                   	nop
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103520:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103523:	8d 42 01             	lea    0x1(%edx),%eax
80103526:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010352c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103532:	83 c6 01             	add    $0x1,%esi
80103535:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103539:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010353c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010353f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103543:	0f 85 4f ff ff ff    	jne    80103498 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103549:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010354f:	83 ec 0c             	sub    $0xc,%esp
80103552:	50                   	push   %eax
80103553:	e8 78 0a 00 00       	call   80103fd0 <wakeup>
  release(&p->lock);
80103558:	89 1c 24             	mov    %ebx,(%esp)
8010355b:	e8 10 15 00 00       	call   80104a70 <release>
  return n;
80103560:	83 c4 10             	add    $0x10,%esp
80103563:	8b 45 10             	mov    0x10(%ebp),%eax
80103566:	eb a9                	jmp    80103511 <pipewrite+0xb1>
80103568:	90                   	nop
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103570 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 18             	sub    $0x18,%esp
80103579:	8b 75 08             	mov    0x8(%ebp),%esi
8010357c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010357f:	56                   	push   %esi
80103580:	e8 cb 13 00 00       	call   80104950 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010358e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103594:	75 6a                	jne    80103600 <piperead+0x90>
80103596:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010359c:	85 db                	test   %ebx,%ebx
8010359e:	0f 84 c4 00 00 00    	je     80103668 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035a4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035aa:	eb 2d                	jmp    801035d9 <piperead+0x69>
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	83 ec 08             	sub    $0x8,%esp
801035b3:	56                   	push   %esi
801035b4:	53                   	push   %ebx
801035b5:	e8 66 08 00 00       	call   80103e20 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035ba:	83 c4 10             	add    $0x10,%esp
801035bd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035c3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035c9:	75 35                	jne    80103600 <piperead+0x90>
801035cb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035d1:	85 d2                	test   %edx,%edx
801035d3:	0f 84 8f 00 00 00    	je     80103668 <piperead+0xf8>
    if(myproc()->killed){
801035d9:	e8 72 02 00 00       	call   80103850 <myproc>
801035de:	8b 48 24             	mov    0x24(%eax),%ecx
801035e1:	85 c9                	test   %ecx,%ecx
801035e3:	74 cb                	je     801035b0 <piperead+0x40>
      release(&p->lock);
801035e5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035e8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ed:	56                   	push   %esi
801035ee:	e8 7d 14 00 00       	call   80104a70 <release>
      return -1;
801035f3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035f9:	89 d8                	mov    %ebx,%eax
801035fb:	5b                   	pop    %ebx
801035fc:	5e                   	pop    %esi
801035fd:	5f                   	pop    %edi
801035fe:	5d                   	pop    %ebp
801035ff:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103600:	8b 45 10             	mov    0x10(%ebp),%eax
80103603:	85 c0                	test   %eax,%eax
80103605:	7e 61                	jle    80103668 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103607:	31 db                	xor    %ebx,%ebx
80103609:	eb 13                	jmp    8010361e <piperead+0xae>
8010360b:	90                   	nop
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103610:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103616:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010361c:	74 1f                	je     8010363d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010361e:	8d 41 01             	lea    0x1(%ecx),%eax
80103621:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103627:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010362d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103632:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103635:	83 c3 01             	add    $0x1,%ebx
80103638:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010363b:	75 d3                	jne    80103610 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010363d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103643:	83 ec 0c             	sub    $0xc,%esp
80103646:	50                   	push   %eax
80103647:	e8 84 09 00 00       	call   80103fd0 <wakeup>
  release(&p->lock);
8010364c:	89 34 24             	mov    %esi,(%esp)
8010364f:	e8 1c 14 00 00       	call   80104a70 <release>
  return i;
80103654:	83 c4 10             	add    $0x10,%esp
}
80103657:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365a:	89 d8                	mov    %ebx,%eax
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	31 db                	xor    %ebx,%ebx
8010366a:	eb d1                	jmp    8010363d <piperead+0xcd>
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103674:	bb 74 41 11 80       	mov    $0x80114174,%ebx
{
80103679:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010367c:	68 40 41 11 80       	push   $0x80114140
80103681:	e8 ca 12 00 00       	call   80104950 <acquire>
80103686:	83 c4 10             	add    $0x10,%esp
80103689:	eb 10                	jmp    8010369b <allocproc+0x2b>
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103690:	83 c3 7c             	add    $0x7c,%ebx
80103693:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103699:	73 75                	jae    80103710 <allocproc+0xa0>
    if(p->state == UNUSED)
8010369b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010369e:	85 c0                	test   %eax,%eax
801036a0:	75 ee                	jne    80103690 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036a2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801036a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036b1:	8d 50 01             	lea    0x1(%eax),%edx
801036b4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801036b7:	68 40 41 11 80       	push   $0x80114140
  p->pid = nextpid++;
801036bc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801036c2:	e8 a9 13 00 00       	call   80104a70 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036c7:	e8 14 ee ff ff       	call   801024e0 <kalloc>
801036cc:	83 c4 10             	add    $0x10,%esp
801036cf:	85 c0                	test   %eax,%eax
801036d1:	89 43 08             	mov    %eax,0x8(%ebx)
801036d4:	74 53                	je     80103729 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036e4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036e7:	c7 40 14 f2 5c 10 80 	movl   $0x80105cf2,0x14(%eax)
  p->context = (struct context*)sp;
801036ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036f1:	6a 14                	push   $0x14
801036f3:	6a 00                	push   $0x0
801036f5:	50                   	push   %eax
801036f6:	e8 d5 13 00 00       	call   80104ad0 <memset>
  p->context->eip = (uint)forkret;
801036fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103701:	c7 40 10 40 37 10 80 	movl   $0x80103740,0x10(%eax)
}
80103708:	89 d8                	mov    %ebx,%eax
8010370a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010370d:	c9                   	leave  
8010370e:	c3                   	ret    
8010370f:	90                   	nop
  release(&ptable.lock);
80103710:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103713:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103715:	68 40 41 11 80       	push   $0x80114140
8010371a:	e8 51 13 00 00       	call   80104a70 <release>
}
8010371f:	89 d8                	mov    %ebx,%eax
  return 0;
80103721:	83 c4 10             	add    $0x10,%esp
}
80103724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103727:	c9                   	leave  
80103728:	c3                   	ret    
    p->state = UNUSED;
80103729:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103730:	31 db                	xor    %ebx,%ebx
80103732:	eb d4                	jmp    80103708 <allocproc+0x98>
80103734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010373a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103740 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103746:	68 40 41 11 80       	push   $0x80114140
8010374b:	e8 20 13 00 00       	call   80104a70 <release>

  if (first) {
80103750:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	85 c0                	test   %eax,%eax
8010375a:	75 04                	jne    80103760 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010375c:	c9                   	leave  
8010375d:	c3                   	ret    
8010375e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103760:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103763:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010376a:	00 00 00 
    iinit(ROOTDEV);
8010376d:	6a 01                	push   $0x1
8010376f:	e8 1c dd ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103774:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010377b:	e8 b0 f3 ff ff       	call   80102b30 <initlog>
80103780:	83 c4 10             	add    $0x10,%esp
}
80103783:	c9                   	leave  
80103784:	c3                   	ret    
80103785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <pinit>:
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103796:	68 19 7b 10 80       	push   $0x80107b19
8010379b:	68 40 41 11 80       	push   $0x80114140
801037a0:	e8 bb 10 00 00       	call   80104860 <initlock>
}
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	c9                   	leave  
801037a9:	c3                   	ret    
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037b0 <mycpu>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037b5:	9c                   	pushf  
801037b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037b7:	f6 c4 02             	test   $0x2,%ah
801037ba:	75 5e                	jne    8010381a <mycpu+0x6a>
  apicid = lapicid();
801037bc:	e8 9f ef ff ff       	call   80102760 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037c1:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
801037c7:	85 f6                	test   %esi,%esi
801037c9:	7e 42                	jle    8010380d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037cb:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
801037d2:	39 d0                	cmp    %edx,%eax
801037d4:	74 30                	je     80103806 <mycpu+0x56>
801037d6:	b9 50 38 11 80       	mov    $0x80113850,%ecx
  for (i = 0; i < ncpu; ++i) {
801037db:	31 d2                	xor    %edx,%edx
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
801037e0:	83 c2 01             	add    $0x1,%edx
801037e3:	39 f2                	cmp    %esi,%edx
801037e5:	74 26                	je     8010380d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037e7:	0f b6 19             	movzbl (%ecx),%ebx
801037ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037f0:	39 c3                	cmp    %eax,%ebx
801037f2:	75 ec                	jne    801037e0 <mycpu+0x30>
801037f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037fa:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
801037ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103802:	5b                   	pop    %ebx
80103803:	5e                   	pop    %esi
80103804:	5d                   	pop    %ebp
80103805:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103806:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
8010380b:	eb f2                	jmp    801037ff <mycpu+0x4f>
  panic("unknown apicid\n");
8010380d:	83 ec 0c             	sub    $0xc,%esp
80103810:	68 20 7b 10 80       	push   $0x80107b20
80103815:	e8 76 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 28 7c 10 80       	push   $0x80107c28
80103822:	e8 69 cb ff ff       	call   80100390 <panic>
80103827:	89 f6                	mov    %esi,%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <cpuid>:
cpuid() {
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103836:	e8 75 ff ff ff       	call   801037b0 <mycpu>
8010383b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103840:	c9                   	leave  
  return mycpu()-cpus;
80103841:	c1 f8 04             	sar    $0x4,%eax
80103844:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010384a:	c3                   	ret    
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103850 <myproc>:
myproc(void) {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103857:	e8 b4 10 00 00       	call   80104910 <pushcli>
  c = mycpu();
8010385c:	e8 4f ff ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103861:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103867:	e8 a4 11 00 00       	call   80104a10 <popcli>
}
8010386c:	83 c4 04             	add    $0x4,%esp
8010386f:	89 d8                	mov    %ebx,%eax
80103871:	5b                   	pop    %ebx
80103872:	5d                   	pop    %ebp
80103873:	c3                   	ret    
80103874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010387a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103880 <userinit>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103887:	e8 e4 fd ff ff       	call   80103670 <allocproc>
8010388c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010388e:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  if((p->pgdir = setupkvm()) == 0)
80103893:	e8 28 3a 00 00       	call   801072c0 <setupkvm>
80103898:	85 c0                	test   %eax,%eax
8010389a:	89 43 04             	mov    %eax,0x4(%ebx)
8010389d:	0f 84 bd 00 00 00    	je     80103960 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	68 2c 00 00 00       	push   $0x2c
801038ab:	68 60 b4 10 80       	push   $0x8010b460
801038b0:	50                   	push   %eax
801038b1:	e8 ea 36 00 00       	call   80106fa0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038b6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038bf:	6a 4c                	push   $0x4c
801038c1:	6a 00                	push   $0x0
801038c3:	ff 73 18             	pushl  0x18(%ebx)
801038c6:	e8 05 12 00 00       	call   80104ad0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038cb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038d8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038df:	8b 43 18             	mov    0x18(%ebx),%eax
801038e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038e6:	8b 43 18             	mov    0x18(%ebx),%eax
801038e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038f1:	8b 43 18             	mov    0x18(%ebx),%eax
801038f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038fc:	8b 43 18             	mov    0x18(%ebx),%eax
801038ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103910:	8b 43 18             	mov    0x18(%ebx),%eax
80103913:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010391a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010391d:	6a 10                	push   $0x10
8010391f:	68 49 7b 10 80       	push   $0x80107b49
80103924:	50                   	push   %eax
80103925:	e8 86 13 00 00       	call   80104cb0 <safestrcpy>
  p->cwd = namei("/");
8010392a:	c7 04 24 52 7b 10 80 	movl   $0x80107b52,(%esp)
80103931:	e8 ba e5 ff ff       	call   80101ef0 <namei>
80103936:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103939:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103940:	e8 0b 10 00 00       	call   80104950 <acquire>
  p->state = RUNNABLE;
80103945:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010394c:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103953:	e8 18 11 00 00       	call   80104a70 <release>
}
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395e:	c9                   	leave  
8010395f:	c3                   	ret    
    panic("userinit: out of memory?");
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 30 7b 10 80       	push   $0x80107b30
80103968:	e8 23 ca ff ff       	call   80100390 <panic>
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <growproc>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
80103975:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103978:	e8 93 0f 00 00       	call   80104910 <pushcli>
  c = mycpu();
8010397d:	e8 2e fe ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103982:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103988:	e8 83 10 00 00       	call   80104a10 <popcli>
  if(n > 0){
8010398d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103990:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103992:	7f 1c                	jg     801039b0 <growproc+0x40>
  } else if(n < 0){
80103994:	75 3a                	jne    801039d0 <growproc+0x60>
  switchuvm(curproc);
80103996:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103999:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010399b:	53                   	push   %ebx
8010399c:	e8 ef 34 00 00       	call   80106e90 <switchuvm>
  return 0;
801039a1:	83 c4 10             	add    $0x10,%esp
801039a4:	31 c0                	xor    %eax,%eax
}
801039a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039b0:	83 ec 04             	sub    $0x4,%esp
801039b3:	01 c6                	add    %eax,%esi
801039b5:	56                   	push   %esi
801039b6:	50                   	push   %eax
801039b7:	ff 73 04             	pushl  0x4(%ebx)
801039ba:	e8 21 37 00 00       	call   801070e0 <allocuvm>
801039bf:	83 c4 10             	add    $0x10,%esp
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 d0                	jne    80103996 <growproc+0x26>
      return -1;
801039c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039cb:	eb d9                	jmp    801039a6 <growproc+0x36>
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039d0:	83 ec 04             	sub    $0x4,%esp
801039d3:	01 c6                	add    %eax,%esi
801039d5:	56                   	push   %esi
801039d6:	50                   	push   %eax
801039d7:	ff 73 04             	pushl  0x4(%ebx)
801039da:	e8 31 38 00 00       	call   80107210 <deallocuvm>
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 b0                	jne    80103996 <growproc+0x26>
801039e6:	eb de                	jmp    801039c6 <growproc+0x56>
801039e8:	90                   	nop
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <scheduler>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801039f9:	e8 b2 fd ff ff       	call   801037b0 <mycpu>
801039fe:	8d 78 04             	lea    0x4(%eax),%edi
80103a01:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a03:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a0a:	00 00 00 
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103a10:	fb                   	sti    
    acquire(&ptable.lock);
80103a11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a14:	bb 74 41 11 80       	mov    $0x80114174,%ebx
    acquire(&ptable.lock);
80103a19:	68 40 41 11 80       	push   $0x80114140
80103a1e:	e8 2d 0f 00 00       	call   80104950 <acquire>
80103a23:	83 c4 10             	add    $0x10,%esp
80103a26:	8d 76 00             	lea    0x0(%esi),%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103a30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a34:	75 33                	jne    80103a69 <scheduler+0x79>
      switchuvm(p);
80103a36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103a39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a3f:	53                   	push   %ebx
80103a40:	e8 4b 34 00 00       	call   80106e90 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103a45:	58                   	pop    %eax
80103a46:	5a                   	pop    %edx
80103a47:	ff 73 1c             	pushl  0x1c(%ebx)
80103a4a:	57                   	push   %edi
      p->state = RUNNING;
80103a4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103a52:	e8 b4 12 00 00       	call   80104d0b <swtch>
      switchkvm();
80103a57:	e8 14 34 00 00       	call   80106e70 <switchkvm>
      c->proc = 0;
80103a5c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a63:	00 00 00 
80103a66:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a69:	83 c3 7c             	add    $0x7c,%ebx
80103a6c:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103a72:	72 bc                	jb     80103a30 <scheduler+0x40>
    release(&ptable.lock);
80103a74:	83 ec 0c             	sub    $0xc,%esp
80103a77:	68 40 41 11 80       	push   $0x80114140
80103a7c:	e8 ef 0f 00 00       	call   80104a70 <release>
    sti();
80103a81:	83 c4 10             	add    $0x10,%esp
80103a84:	eb 8a                	jmp    80103a10 <scheduler+0x20>
80103a86:	8d 76 00             	lea    0x0(%esi),%esi
80103a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a90 <sched>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
  pushcli();
80103a95:	e8 76 0e 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103a9a:	e8 11 fd ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103a9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa5:	e8 66 0f 00 00       	call   80104a10 <popcli>
  if(!holding(&ptable.lock))
80103aaa:	83 ec 0c             	sub    $0xc,%esp
80103aad:	68 40 41 11 80       	push   $0x80114140
80103ab2:	e8 19 0e 00 00       	call   801048d0 <holding>
80103ab7:	83 c4 10             	add    $0x10,%esp
80103aba:	85 c0                	test   %eax,%eax
80103abc:	74 4f                	je     80103b0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103abe:	e8 ed fc ff ff       	call   801037b0 <mycpu>
80103ac3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103aca:	75 68                	jne    80103b34 <sched+0xa4>
  if(p->state == RUNNING)
80103acc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ad0:	74 55                	je     80103b27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ad2:	9c                   	pushf  
80103ad3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ad4:	f6 c4 02             	test   $0x2,%ah
80103ad7:	75 41                	jne    80103b1a <sched+0x8a>
  intena = mycpu()->intena;
80103ad9:	e8 d2 fc ff ff       	call   801037b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ade:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ae1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ae7:	e8 c4 fc ff ff       	call   801037b0 <mycpu>
80103aec:	83 ec 08             	sub    $0x8,%esp
80103aef:	ff 70 04             	pushl  0x4(%eax)
80103af2:	53                   	push   %ebx
80103af3:	e8 13 12 00 00       	call   80104d0b <swtch>
  mycpu()->intena = intena;
80103af8:	e8 b3 fc ff ff       	call   801037b0 <mycpu>
}
80103afd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103b00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b09:	5b                   	pop    %ebx
80103b0a:	5e                   	pop    %esi
80103b0b:	5d                   	pop    %ebp
80103b0c:	c3                   	ret    
    panic("sched ptable.lock");
80103b0d:	83 ec 0c             	sub    $0xc,%esp
80103b10:	68 54 7b 10 80       	push   $0x80107b54
80103b15:	e8 76 c8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103b1a:	83 ec 0c             	sub    $0xc,%esp
80103b1d:	68 80 7b 10 80       	push   $0x80107b80
80103b22:	e8 69 c8 ff ff       	call   80100390 <panic>
    panic("sched running");
80103b27:	83 ec 0c             	sub    $0xc,%esp
80103b2a:	68 72 7b 10 80       	push   $0x80107b72
80103b2f:	e8 5c c8 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103b34:	83 ec 0c             	sub    $0xc,%esp
80103b37:	68 66 7b 10 80       	push   $0x80107b66
80103b3c:	e8 4f c8 ff ff       	call   80100390 <panic>
80103b41:	eb 0d                	jmp    80103b50 <fork>
80103b43:	90                   	nop
80103b44:	90                   	nop
80103b45:	90                   	nop
80103b46:	90                   	nop
80103b47:	90                   	nop
80103b48:	90                   	nop
80103b49:	90                   	nop
80103b4a:	90                   	nop
80103b4b:	90                   	nop
80103b4c:	90                   	nop
80103b4d:	90                   	nop
80103b4e:	90                   	nop
80103b4f:	90                   	nop

80103b50 <fork>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b59:	e8 b2 0d 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103b5e:	e8 4d fc ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103b63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b69:	e8 a2 0e 00 00       	call   80104a10 <popcli>
  if((np = allocproc()) == 0){
80103b6e:	e8 fd fa ff ff       	call   80103670 <allocproc>
80103b73:	85 c0                	test   %eax,%eax
80103b75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b78:	0f 84 ed 00 00 00    	je     80103c6b <fork+0x11b>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b7e:	83 ec 08             	sub    $0x8,%esp
80103b81:	ff 33                	pushl  (%ebx)
80103b83:	ff 73 04             	pushl  0x4(%ebx)
80103b86:	89 c7                	mov    %eax,%edi
80103b88:	e8 03 38 00 00       	call   80107390 <copyuvm>
80103b8d:	83 c4 10             	add    $0x10,%esp
80103b90:	85 c0                	test   %eax,%eax
80103b92:	89 47 04             	mov    %eax,0x4(%edi)
80103b95:	0f 84 d7 00 00 00    	je     80103c72 <fork+0x122>
  np->sz = curproc->sz;
80103b9b:	8b 03                	mov    (%ebx),%eax
80103b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ba0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ba2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103ba5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103ba7:	8b 79 18             	mov    0x18(%ecx),%edi
80103baa:	8b 73 18             	mov    0x18(%ebx),%esi
80103bad:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bb6:	8b 40 18             	mov    0x18(%eax),%eax
80103bb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 13                	je     80103bdb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bc8:	83 ec 0c             	sub    $0xc,%esp
80103bcb:	50                   	push   %eax
80103bcc:	e8 1f d2 ff ff       	call   80100df0 <filedup>
80103bd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bd4:	83 c4 10             	add    $0x10,%esp
80103bd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bdb:	83 c6 01             	add    $0x1,%esi
80103bde:	83 fe 10             	cmp    $0x10,%esi
80103be1:	75 dd                	jne    80103bc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103be3:	83 ec 0c             	sub    $0xc,%esp
80103be6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bec:	e8 6f da ff ff       	call   80101660 <idup>
80103bf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	53                   	push   %ebx
80103c00:	50                   	push   %eax
80103c01:	e8 aa 10 00 00       	call   80104cb0 <safestrcpy>
  pid = np->pid;
80103c06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c09:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103c10:	e8 3b 0d 00 00       	call   80104950 <acquire>
  if(fork_winner){
80103c15:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103c1a:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80103c1d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  if(fork_winner){
80103c24:	85 c0                	test   %eax,%eax
80103c26:	75 20                	jne    80103c48 <fork+0xf8>
  release(&ptable.lock);
80103c28:	83 ec 0c             	sub    $0xc,%esp
80103c2b:	68 40 41 11 80       	push   $0x80114140
80103c30:	e8 3b 0e 00 00       	call   80104a70 <release>
  return pid;
80103c35:	83 c4 10             	add    $0x10,%esp
}
80103c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3b:	89 d8                	mov    %ebx,%eax
80103c3d:	5b                   	pop    %ebx
80103c3e:	5e                   	pop    %esi
80103c3f:	5f                   	pop    %edi
80103c40:	5d                   	pop    %ebp
80103c41:	c3                   	ret    
80103c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pushcli();
80103c48:	e8 c3 0c 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103c4d:	e8 5e fb ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103c52:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c58:	e8 b3 0d 00 00       	call   80104a10 <popcli>
    myproc()->state=RUNNABLE;
80103c5d:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
    sched();
80103c64:	e8 27 fe ff ff       	call   80103a90 <sched>
80103c69:	eb bd                	jmp    80103c28 <fork+0xd8>
    return -1;
80103c6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c70:	eb c6                	jmp    80103c38 <fork+0xe8>
    kfree(np->kstack);
80103c72:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c75:	83 ec 0c             	sub    $0xc,%esp
80103c78:	ff 73 08             	pushl  0x8(%ebx)
80103c7b:	e8 a0 e6 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103c80:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c87:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c8e:	83 c4 10             	add    $0x10,%esp
80103c91:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c96:	eb a0                	jmp    80103c38 <fork+0xe8>
80103c98:	90                   	nop
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <exit>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ca9:	e8 62 0c 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103cae:	e8 fd fa ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103cb3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cb9:	e8 52 0d 00 00       	call   80104a10 <popcli>
  if(curproc == initproc)
80103cbe:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
80103cc4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103cc7:	8d 7e 68             	lea    0x68(%esi),%edi
80103cca:	0f 84 e7 00 00 00    	je     80103db7 <exit+0x117>
    if(curproc->ofile[fd]){
80103cd0:	8b 03                	mov    (%ebx),%eax
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	74 12                	je     80103ce8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103cd6:	83 ec 0c             	sub    $0xc,%esp
80103cd9:	50                   	push   %eax
80103cda:	e8 61 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103cdf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ce5:	83 c4 10             	add    $0x10,%esp
80103ce8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103ceb:	39 fb                	cmp    %edi,%ebx
80103ced:	75 e1                	jne    80103cd0 <exit+0x30>
  begin_op();
80103cef:	e8 dc ee ff ff       	call   80102bd0 <begin_op>
  iput(curproc->cwd);
80103cf4:	83 ec 0c             	sub    $0xc,%esp
80103cf7:	ff 76 68             	pushl  0x68(%esi)
80103cfa:	e8 c1 da ff ff       	call   801017c0 <iput>
  end_op();
80103cff:	e8 3c ef ff ff       	call   80102c40 <end_op>
  curproc->cwd = 0;
80103d04:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d0b:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103d12:	e8 39 0c 00 00       	call   80104950 <acquire>
  wakeup1(curproc->parent);
80103d17:	8b 56 14             	mov    0x14(%esi),%edx
80103d1a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d1d:	b8 74 41 11 80       	mov    $0x80114174,%eax
80103d22:	eb 0e                	jmp    80103d32 <exit+0x92>
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	83 c0 7c             	add    $0x7c,%eax
80103d2b:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103d30:	73 1c                	jae    80103d4e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d32:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d36:	75 f0                	jne    80103d28 <exit+0x88>
80103d38:	3b 50 20             	cmp    0x20(%eax),%edx
80103d3b:	75 eb                	jne    80103d28 <exit+0x88>
      p->state = RUNNABLE;
80103d3d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d44:	83 c0 7c             	add    $0x7c,%eax
80103d47:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103d4c:	72 e4                	jb     80103d32 <exit+0x92>
      p->parent = initproc;
80103d4e:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d54:	ba 74 41 11 80       	mov    $0x80114174,%edx
80103d59:	eb 10                	jmp    80103d6b <exit+0xcb>
80103d5b:	90                   	nop
80103d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d60:	83 c2 7c             	add    $0x7c,%edx
80103d63:	81 fa 74 60 11 80    	cmp    $0x80116074,%edx
80103d69:	73 33                	jae    80103d9e <exit+0xfe>
    if(p->parent == curproc){
80103d6b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d6e:	75 f0                	jne    80103d60 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d70:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d74:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d77:	75 e7                	jne    80103d60 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d79:	b8 74 41 11 80       	mov    $0x80114174,%eax
80103d7e:	eb 0a                	jmp    80103d8a <exit+0xea>
80103d80:	83 c0 7c             	add    $0x7c,%eax
80103d83:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103d88:	73 d6                	jae    80103d60 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d8e:	75 f0                	jne    80103d80 <exit+0xe0>
80103d90:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d93:	75 eb                	jne    80103d80 <exit+0xe0>
      p->state = RUNNABLE;
80103d95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d9c:	eb e2                	jmp    80103d80 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d9e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103da5:	e8 e6 fc ff ff       	call   80103a90 <sched>
  panic("zombie exit");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 a1 7b 10 80       	push   $0x80107ba1
80103db2:	e8 d9 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	68 94 7b 10 80       	push   $0x80107b94
80103dbf:	e8 cc c5 ff ff       	call   80100390 <panic>
80103dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103dd0 <yield>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103dd7:	68 40 41 11 80       	push   $0x80114140
80103ddc:	e8 6f 0b 00 00       	call   80104950 <acquire>
  pushcli();
80103de1:	e8 2a 0b 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103de6:	e8 c5 f9 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103deb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103df1:	e8 1a 0c 00 00       	call   80104a10 <popcli>
  myproc()->state = RUNNABLE;
80103df6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103dfd:	e8 8e fc ff ff       	call   80103a90 <sched>
  release(&ptable.lock);
80103e02:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103e09:	e8 62 0c 00 00       	call   80104a70 <release>
}
80103e0e:	83 c4 10             	add    $0x10,%esp
80103e11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e14:	c9                   	leave  
80103e15:	c3                   	ret    
80103e16:	8d 76 00             	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <sleep>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
80103e26:	83 ec 0c             	sub    $0xc,%esp
80103e29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e2f:	e8 dc 0a 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103e34:	e8 77 f9 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103e39:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e3f:	e8 cc 0b 00 00       	call   80104a10 <popcli>
  if(p == 0)
80103e44:	85 db                	test   %ebx,%ebx
80103e46:	0f 84 87 00 00 00    	je     80103ed3 <sleep+0xb3>
  if(lk == 0)
80103e4c:	85 f6                	test   %esi,%esi
80103e4e:	74 76                	je     80103ec6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e50:	81 fe 40 41 11 80    	cmp    $0x80114140,%esi
80103e56:	74 50                	je     80103ea8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e58:	83 ec 0c             	sub    $0xc,%esp
80103e5b:	68 40 41 11 80       	push   $0x80114140
80103e60:	e8 eb 0a 00 00       	call   80104950 <acquire>
    release(lk);
80103e65:	89 34 24             	mov    %esi,(%esp)
80103e68:	e8 03 0c 00 00       	call   80104a70 <release>
  p->chan = chan;
80103e6d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e70:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e77:	e8 14 fc ff ff       	call   80103a90 <sched>
  p->chan = 0;
80103e7c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e83:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
80103e8a:	e8 e1 0b 00 00       	call   80104a70 <release>
    acquire(lk);
80103e8f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e92:	83 c4 10             	add    $0x10,%esp
}
80103e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e98:	5b                   	pop    %ebx
80103e99:	5e                   	pop    %esi
80103e9a:	5f                   	pop    %edi
80103e9b:	5d                   	pop    %ebp
    acquire(lk);
80103e9c:	e9 af 0a 00 00       	jmp    80104950 <acquire>
80103ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103ea8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103eab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103eb2:	e8 d9 fb ff ff       	call   80103a90 <sched>
  p->chan = 0;
80103eb7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec1:	5b                   	pop    %ebx
80103ec2:	5e                   	pop    %esi
80103ec3:	5f                   	pop    %edi
80103ec4:	5d                   	pop    %ebp
80103ec5:	c3                   	ret    
    panic("sleep without lk");
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	68 b3 7b 10 80       	push   $0x80107bb3
80103ece:	e8 bd c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ed3:	83 ec 0c             	sub    $0xc,%esp
80103ed6:	68 ad 7b 10 80       	push   $0x80107bad
80103edb:	e8 b0 c4 ff ff       	call   80100390 <panic>

80103ee0 <wait>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 26 0a 00 00       	call   80104910 <pushcli>
  c = mycpu();
80103eea:	e8 c1 f8 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103eef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef5:	e8 16 0b 00 00       	call   80104a10 <popcli>
  acquire(&ptable.lock);
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 40 41 11 80       	push   $0x80114140
80103f02:	e8 49 0a 00 00       	call   80104950 <acquire>
80103f07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	bb 74 41 11 80       	mov    $0x80114174,%ebx
80103f11:	eb 10                	jmp    80103f23 <wait+0x43>
80103f13:	90                   	nop
80103f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f18:	83 c3 7c             	add    $0x7c,%ebx
80103f1b:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103f21:	73 1b                	jae    80103f3e <wait+0x5e>
      if(p->parent != curproc)
80103f23:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f26:	75 f0                	jne    80103f18 <wait+0x38>
      if(p->state == ZOMBIE){
80103f28:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f2c:	74 32                	je     80103f60 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f31:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f36:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
80103f3c:	72 e5                	jb     80103f23 <wait+0x43>
    if(!havekids || curproc->killed){
80103f3e:	85 c0                	test   %eax,%eax
80103f40:	74 74                	je     80103fb6 <wait+0xd6>
80103f42:	8b 46 24             	mov    0x24(%esi),%eax
80103f45:	85 c0                	test   %eax,%eax
80103f47:	75 6d                	jne    80103fb6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f49:	83 ec 08             	sub    $0x8,%esp
80103f4c:	68 40 41 11 80       	push   $0x80114140
80103f51:	56                   	push   %esi
80103f52:	e8 c9 fe ff ff       	call   80103e20 <sleep>
    havekids = 0;
80103f57:	83 c4 10             	add    $0x10,%esp
80103f5a:	eb ae                	jmp    80103f0a <wait+0x2a>
80103f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103f60:	83 ec 0c             	sub    $0xc,%esp
80103f63:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f66:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f69:	e8 b2 e3 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80103f6e:	5a                   	pop    %edx
80103f6f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f79:	e8 c2 32 00 00       	call   80107240 <freevm>
        release(&ptable.lock);
80103f7e:	c7 04 24 40 41 11 80 	movl   $0x80114140,(%esp)
        p->pid = 0;
80103f85:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f8c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f93:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f97:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f9e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fa5:	e8 c6 0a 00 00       	call   80104a70 <release>
        return pid;
80103faa:	83 c4 10             	add    $0x10,%esp
}
80103fad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb0:	89 f0                	mov    %esi,%eax
80103fb2:	5b                   	pop    %ebx
80103fb3:	5e                   	pop    %esi
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret    
      release(&ptable.lock);
80103fb6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fb9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fbe:	68 40 41 11 80       	push   $0x80114140
80103fc3:	e8 a8 0a 00 00       	call   80104a70 <release>
      return -1;
80103fc8:	83 c4 10             	add    $0x10,%esp
80103fcb:	eb e0                	jmp    80103fad <wait+0xcd>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi

80103fd0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	53                   	push   %ebx
80103fd4:	83 ec 10             	sub    $0x10,%esp
80103fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103fda:	68 40 41 11 80       	push   $0x80114140
80103fdf:	e8 6c 09 00 00       	call   80104950 <acquire>
80103fe4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe7:	b8 74 41 11 80       	mov    $0x80114174,%eax
80103fec:	eb 0c                	jmp    80103ffa <wakeup+0x2a>
80103fee:	66 90                	xchg   %ax,%ax
80103ff0:	83 c0 7c             	add    $0x7c,%eax
80103ff3:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80103ff8:	73 1c                	jae    80104016 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103ffa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ffe:	75 f0                	jne    80103ff0 <wakeup+0x20>
80104000:	3b 58 20             	cmp    0x20(%eax),%ebx
80104003:	75 eb                	jne    80103ff0 <wakeup+0x20>
      p->state = RUNNABLE;
80104005:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010400c:	83 c0 7c             	add    $0x7c,%eax
8010400f:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80104014:	72 e4                	jb     80103ffa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104016:	c7 45 08 40 41 11 80 	movl   $0x80114140,0x8(%ebp)
}
8010401d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104020:	c9                   	leave  
  release(&ptable.lock);
80104021:	e9 4a 0a 00 00       	jmp    80104a70 <release>
80104026:	8d 76 00             	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104030 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	53                   	push   %ebx
80104034:	83 ec 10             	sub    $0x10,%esp
80104037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010403a:	68 40 41 11 80       	push   $0x80114140
8010403f:	e8 0c 09 00 00       	call   80104950 <acquire>
80104044:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104047:	b8 74 41 11 80       	mov    $0x80114174,%eax
8010404c:	eb 0c                	jmp    8010405a <kill+0x2a>
8010404e:	66 90                	xchg   %ax,%ax
80104050:	83 c0 7c             	add    $0x7c,%eax
80104053:	3d 74 60 11 80       	cmp    $0x80116074,%eax
80104058:	73 36                	jae    80104090 <kill+0x60>
    if(p->pid == pid){
8010405a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010405d:	75 f1                	jne    80104050 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010405f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104063:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010406a:	75 07                	jne    80104073 <kill+0x43>
        p->state = RUNNABLE;
8010406c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104073:	83 ec 0c             	sub    $0xc,%esp
80104076:	68 40 41 11 80       	push   $0x80114140
8010407b:	e8 f0 09 00 00       	call   80104a70 <release>
      return 0;
80104080:	83 c4 10             	add    $0x10,%esp
80104083:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104088:	c9                   	leave  
80104089:	c3                   	ret    
8010408a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104090:	83 ec 0c             	sub    $0xc,%esp
80104093:	68 40 41 11 80       	push   $0x80114140
80104098:	e8 d3 09 00 00       	call   80104a70 <release>
  return -1;
8010409d:	83 c4 10             	add    $0x10,%esp
801040a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a8:	c9                   	leave  
801040a9:	c3                   	ret    
801040aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b9:	bb 74 41 11 80       	mov    $0x80114174,%ebx
{
801040be:	83 ec 3c             	sub    $0x3c,%esp
801040c1:	eb 24                	jmp    801040e7 <procdump+0x37>
801040c3:	90                   	nop
801040c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 b9 7a 10 80       	push   $0x80107ab9
801040d0:	e8 8b c5 ff ff       	call   80100660 <cprintf>
801040d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d8:	83 c3 7c             	add    $0x7c,%ebx
801040db:	81 fb 74 60 11 80    	cmp    $0x80116074,%ebx
801040e1:	0f 83 81 00 00 00    	jae    80104168 <procdump+0xb8>
    if(p->state == UNUSED)
801040e7:	8b 43 0c             	mov    0xc(%ebx),%eax
801040ea:	85 c0                	test   %eax,%eax
801040ec:	74 ea                	je     801040d8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040ee:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801040f1:	ba c4 7b 10 80       	mov    $0x80107bc4,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040f6:	77 11                	ja     80104109 <procdump+0x59>
801040f8:	8b 14 85 cc 7c 10 80 	mov    -0x7fef8334(,%eax,4),%edx
      state = "???";
801040ff:	b8 c4 7b 10 80       	mov    $0x80107bc4,%eax
80104104:	85 d2                	test   %edx,%edx
80104106:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104109:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010410c:	50                   	push   %eax
8010410d:	52                   	push   %edx
8010410e:	ff 73 10             	pushl  0x10(%ebx)
80104111:	68 c8 7b 10 80       	push   $0x80107bc8
80104116:	e8 45 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010411b:	83 c4 10             	add    $0x10,%esp
8010411e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104122:	75 a4                	jne    801040c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104124:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104127:	83 ec 08             	sub    $0x8,%esp
8010412a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010412d:	50                   	push   %eax
8010412e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104131:	8b 40 0c             	mov    0xc(%eax),%eax
80104134:	83 c0 08             	add    $0x8,%eax
80104137:	50                   	push   %eax
80104138:	e8 43 07 00 00       	call   80104880 <getcallerpcs>
8010413d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104140:	8b 17                	mov    (%edi),%edx
80104142:	85 d2                	test   %edx,%edx
80104144:	74 82                	je     801040c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104146:	83 ec 08             	sub    $0x8,%esp
80104149:	83 c7 04             	add    $0x4,%edi
8010414c:	52                   	push   %edx
8010414d:	68 a1 75 10 80       	push   $0x801075a1
80104152:	e8 09 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104157:	83 c4 10             	add    $0x10,%esp
8010415a:	39 fe                	cmp    %edi,%esi
8010415c:	75 e2                	jne    80104140 <procdump+0x90>
8010415e:	e9 65 ff ff ff       	jmp    801040c8 <procdump+0x18>
80104163:	90                   	nop
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104168:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416b:	5b                   	pop    %ebx
8010416c:	5e                   	pop    %esi
8010416d:	5f                   	pop    %edi
8010416e:	5d                   	pop    %ebp
8010416f:	c3                   	ret    

80104170 <waitdisk>:
//------------------------------------------------------------------------
#define SECTSIZE  512
// copy from bootmain.c
void 
waitdisk(void)
{
80104170:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104171:	ba f7 01 00 00       	mov    $0x1f7,%edx
80104176:	89 e5                	mov    %esp,%ebp
80104178:	90                   	nop
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104180:	ec                   	in     (%dx),%al
  // Wait for disk ready
  while((inb(0x1F7) & 0xC0) != 0x40);
80104181:	83 e0 c0             	and    $0xffffffc0,%eax
80104184:	3c 40                	cmp    $0x40,%al
80104186:	75 f8                	jne    80104180 <waitdisk+0x10>
}
80104188:	5d                   	pop    %ebp
80104189:	c3                   	ret    
8010418a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104190 <readsec>:

// copy from bootmain.c
// Read a single sector at offset into dst.
void
readsec(void *dst, uint offset)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	53                   	push   %ebx
80104195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104198:	bb f7 01 00 00       	mov    $0x1f7,%ebx
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
801041a0:	89 da                	mov    %ebx,%edx
801041a2:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
801041a3:	83 e0 c0             	and    $0xffffffc0,%eax
801041a6:	3c 40                	cmp    $0x40,%al
801041a8:	75 f6                	jne    801041a0 <readsec+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801041aa:	b8 01 00 00 00       	mov    $0x1,%eax
801041af:	ba f2 01 00 00       	mov    $0x1f2,%edx
801041b4:	ee                   	out    %al,(%dx)
801041b5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801041ba:	89 c8                	mov    %ecx,%eax
801041bc:	ee                   	out    %al,(%dx)
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
801041bd:	89 c8                	mov    %ecx,%eax
801041bf:	ba f4 01 00 00       	mov    $0x1f4,%edx
801041c4:	c1 e8 08             	shr    $0x8,%eax
801041c7:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
801041c8:	89 c8                	mov    %ecx,%eax
801041ca:	ba f5 01 00 00       	mov    $0x1f5,%edx
801041cf:	c1 e8 10             	shr    $0x10,%eax
801041d2:	ee                   	out    %al,(%dx)
  //------------------------------------------
  // E0->F0  Read from disk img 1
  outb(0x1F6, (offset >> 24) | 0xF0);
801041d3:	89 c8                	mov    %ecx,%eax
801041d5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801041da:	c1 e8 18             	shr    $0x18,%eax
801041dd:	83 c8 f0             	or     $0xfffffff0,%eax
801041e0:	ee                   	out    %al,(%dx)
801041e1:	b8 20 00 00 00       	mov    $0x20,%eax
801041e6:	89 da                	mov    %ebx,%edx
801041e8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801041e9:	ba f7 01 00 00       	mov    $0x1f7,%edx
801041ee:	66 90                	xchg   %ax,%ax
801041f0:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
801041f1:	83 e0 c0             	and    $0xffffffc0,%eax
801041f4:	3c 40                	cmp    $0x40,%al
801041f6:	75 f8                	jne    801041f0 <readsec+0x60>
  asm volatile("cld; rep insl" :
801041f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801041fb:	b9 80 00 00 00       	mov    $0x80,%ecx
80104200:	ba f0 01 00 00       	mov    $0x1f0,%edx
80104205:	fc                   	cld    
80104206:	f3 6d                	rep insl (%dx),%es:(%edi)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
  insl(0x1F0, dst, SECTSIZE/4);
}
80104208:	5b                   	pop    %ebx
80104209:	5f                   	pop    %edi
8010420a:	5d                   	pop    %ebp
8010420b:	c3                   	ret    
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104210 <Writesec>:

// Write a single sector at offset into dst.
void
Writesec(void *dst, uint offset)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	53                   	push   %ebx
80104215:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104218:	bb f7 01 00 00       	mov    $0x1f7,%ebx
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
80104220:	89 da                	mov    %ebx,%edx
80104222:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
80104223:	83 e0 c0             	and    $0xffffffc0,%eax
80104226:	3c 40                	cmp    $0x40,%al
80104228:	75 f6                	jne    80104220 <Writesec+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010422a:	b8 01 00 00 00       	mov    $0x1,%eax
8010422f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80104234:	ee                   	out    %al,(%dx)
80104235:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010423a:	89 c8                	mov    %ecx,%eax
8010423c:	ee                   	out    %al,(%dx)
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
8010423d:	89 c8                	mov    %ecx,%eax
8010423f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80104244:	c1 e8 08             	shr    $0x8,%eax
80104247:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
80104248:	89 c8                	mov    %ecx,%eax
8010424a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010424f:	c1 e8 10             	shr    $0x10,%eax
80104252:	ee                   	out    %al,(%dx)
  //------------------------------------------
  // E0->F0  Read from disk img 1
  outb(0x1F6, (offset >> 24) | 0xF0);
80104253:	89 c8                	mov    %ecx,%eax
80104255:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010425a:	c1 e8 18             	shr    $0x18,%eax
8010425d:	83 c8 f0             	or     $0xfffffff0,%eax
80104260:	ee                   	out    %al,(%dx)
80104261:	b8 30 00 00 00       	mov    $0x30,%eax
80104266:	89 da                	mov    %ebx,%edx
80104268:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104269:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010426e:	66 90                	xchg   %ax,%ax
80104270:	ec                   	in     (%dx),%al
  while((inb(0x1F7) & 0xC0) != 0x40);
80104271:	83 e0 c0             	and    $0xffffffc0,%eax
80104274:	3c 40                	cmp    $0x40,%al
80104276:	75 f8                	jne    80104270 <Writesec+0x60>
  asm volatile("cld; rep insl" :
80104278:	8b 7d 08             	mov    0x8(%ebp),%edi
8010427b:	b9 80 00 00 00       	mov    $0x80,%ecx
80104280:	ba f0 01 00 00       	mov    $0x1f0,%edx
80104285:	fc                   	cld    
80104286:	f3 6d                	rep insl (%dx),%es:(%edi)
  outb(0x1F7, 0x30);  // cmd 0x30 - write sectors

  // Read data.
  waitdisk();
  insl(0x1F0, dst, SECTSIZE/4);
}
80104288:	5b                   	pop    %ebx
80104289:	5f                   	pop    %edi
8010428a:	5d                   	pop    %ebp
8010428b:	c3                   	ret    
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <readblock>:

// copy from bootmain.c
void 
readblock(char* pa, uint count, uint offset)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	8b 7d 10             	mov    0x10(%ebp),%edi
80104298:	53                   	push   %ebx
  char* epa;

  epa = pa + count;
80104299:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010429c:	8b 5d 08             	mov    0x8(%ebp),%ebx

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
8010429f:	89 f8                	mov    %edi,%eax

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
801042a1:	c1 ef 09             	shr    $0x9,%edi
  pa -= offset % SECTSIZE;
801042a4:	25 ff 01 00 00       	and    $0x1ff,%eax
  epa = pa + count;
801042a9:	01 de                	add    %ebx,%esi
  offset = (offset / SECTSIZE) + 1;
801042ab:	83 c7 01             	add    $0x1,%edi
  pa -= offset % SECTSIZE;
801042ae:	29 c3                	sub    %eax,%ebx

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
801042b0:	39 de                	cmp    %ebx,%esi
801042b2:	76 1a                	jbe    801042ce <readblock+0x3e>
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    readsec(pa, offset);
801042b8:	57                   	push   %edi
801042b9:	53                   	push   %ebx
  for(; pa < epa; pa += SECTSIZE, offset++)
801042ba:	81 c3 00 02 00 00    	add    $0x200,%ebx
801042c0:	83 c7 01             	add    $0x1,%edi
    readsec(pa, offset);
801042c3:	e8 c8 fe ff ff       	call   80104190 <readsec>
  for(; pa < epa; pa += SECTSIZE, offset++)
801042c8:	39 de                	cmp    %ebx,%esi
801042ca:	58                   	pop    %eax
801042cb:	5a                   	pop    %edx
801042cc:	77 ea                	ja     801042b8 <readblock+0x28>
}
801042ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d1:	5b                   	pop    %ebx
801042d2:	5e                   	pop    %esi
801042d3:	5f                   	pop    %edi
801042d4:	5d                   	pop    %ebp
801042d5:	c3                   	ret    
801042d6:	8d 76 00             	lea    0x0(%esi),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <writeblock>:

int flag[250];

void 
writeblock(char* pa, uint count, uint offset)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	8b 7d 10             	mov    0x10(%ebp),%edi
801042e8:	53                   	push   %ebx
  char* epa;

  epa = pa + count;
801042e9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
801042ec:	8b 5d 08             	mov    0x8(%ebp),%ebx

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
801042ef:	89 f8                	mov    %edi,%eax

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
801042f1:	c1 ef 09             	shr    $0x9,%edi
  pa -= offset % SECTSIZE;
801042f4:	25 ff 01 00 00       	and    $0x1ff,%eax
  epa = pa + count;
801042f9:	01 de                	add    %ebx,%esi
  offset = (offset / SECTSIZE) + 1;
801042fb:	83 c7 01             	add    $0x1,%edi
  pa -= offset % SECTSIZE;
801042fe:	29 c3                	sub    %eax,%ebx

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
80104300:	39 de                	cmp    %ebx,%esi
80104302:	76 1a                	jbe    8010431e <writeblock+0x3e>
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    Writesec(pa, offset);
80104308:	57                   	push   %edi
80104309:	53                   	push   %ebx
  for(; pa < epa; pa += SECTSIZE, offset++)
8010430a:	81 c3 00 02 00 00    	add    $0x200,%ebx
80104310:	83 c7 01             	add    $0x1,%edi
    Writesec(pa, offset);
80104313:	e8 f8 fe ff ff       	call   80104210 <Writesec>
  for(; pa < epa; pa += SECTSIZE, offset++)
80104318:	39 de                	cmp    %ebx,%esi
8010431a:	58                   	pop    %eax
8010431b:	5a                   	pop    %edx
8010431c:	77 ea                	ja     80104308 <writeblock+0x28>
}
8010431e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104321:	5b                   	pop    %ebx
80104322:	5e                   	pop    %esi
80104323:	5f                   	pop    %edi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
80104326:	8d 76 00             	lea    0x0(%esi),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <dfs>:
#define ROOTINO 1  // root i-number
#define BSIZE 512  // block size
#define ENTNUM  BSIZE/sizeof(struct dirent)

void
dfs(const char* name, const struct dinode* inode,int depth){
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	81 ec 1c 14 00 00    	sub    $0x141c,%esp
  // single block
  char single[4096];

  // inode
  struct dinode INODES[8]; 
  if(inode->type == T_DIR){
8010433c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010433f:	66 83 38 01          	cmpw   $0x1,(%eax)
80104343:	74 0b                	je     80104350 <dfs+0x20>
      i+=4;
    }
  }else{
      //cprintf("%s\n",name);
  }
}
80104345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104348:	5b                   	pop    %ebx
80104349:	5e                   	pop    %esi
8010434a:	5f                   	pop    %edi
8010434b:	5d                   	pop    %ebp
8010434c:	c3                   	ret    
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
80104350:	8d 70 0c             	lea    0xc(%eax),%esi
80104353:	83 c0 3c             	add    $0x3c,%eax
80104356:	89 85 e4 eb ff ff    	mov    %eax,-0x141c(%ebp)
8010435c:	eb 11                	jmp    8010436f <dfs+0x3f>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	83 c6 04             	add    $0x4,%esi
    for(int i = 0; i < NDIRECT; i++){
80104363:	3b b5 e4 eb ff ff    	cmp    -0x141c(%ebp),%esi
80104369:	0f 84 f1 00 00 00    	je     80104460 <dfs+0x130>
      addr = inode->addrs[i];
8010436f:	8b 06                	mov    (%esi),%eax
      if(0 == addr) continue;
80104371:	85 c0                	test   %eax,%eax
80104373:	74 eb                	je     80104360 <dfs+0x30>
      readblock(&db[0],BSIZE,(addr-1) * BSIZE);
80104375:	05 ff ff 7f 00       	add    $0x7fffff,%eax
8010437a:	8d bd ea ed ff ff    	lea    -0x1216(%ebp),%edi
80104380:	8d 9d ea ef ff ff    	lea    -0x1016(%ebp),%ebx
80104386:	c1 e0 09             	shl    $0x9,%eax
80104389:	50                   	push   %eax
8010438a:	8d 85 e8 ed ff ff    	lea    -0x1218(%ebp),%eax
80104390:	68 00 02 00 00       	push   $0x200
80104395:	50                   	push   %eax
80104396:	e8 f5 fe ff ff       	call   80104290 <readblock>
        dfs(entry->name,next_inode,depth+1);
8010439b:	8b 45 10             	mov    0x10(%ebp),%eax
8010439e:	89 b5 e0 eb ff ff    	mov    %esi,-0x1420(%ebp)
801043a4:	83 c4 0c             	add    $0xc,%esp
801043a7:	89 fe                	mov    %edi,%esi
801043a9:	83 c0 01             	add    $0x1,%eax
801043ac:	89 c7                	mov    %eax,%edi
801043ae:	66 90                	xchg   %ax,%ax
        if(strncmp(entry->name,".",1)==0||
801043b0:	83 ec 04             	sub    $0x4,%esp
801043b3:	6a 01                	push   $0x1
801043b5:	68 d2 7b 10 80       	push   $0x80107bd2
801043ba:	56                   	push   %esi
801043bb:	e8 30 08 00 00       	call   80104bf0 <strncmp>
801043c0:	83 c4 10             	add    $0x10,%esp
801043c3:	85 c0                	test   %eax,%eax
801043c5:	74 79                	je     80104440 <dfs+0x110>
        strncmp(entry->name,"..",2)==0||
801043c7:	83 ec 04             	sub    $0x4,%esp
801043ca:	6a 02                	push   $0x2
801043cc:	68 d1 7b 10 80       	push   $0x80107bd1
801043d1:	56                   	push   %esi
801043d2:	e8 19 08 00 00       	call   80104bf0 <strncmp>
        if(strncmp(entry->name,".",1)==0||
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	85 c0                	test   %eax,%eax
801043dc:	74 62                	je     80104440 <dfs+0x110>
        entry->inum==1){
801043de:	0f b7 46 fe          	movzwl -0x2(%esi),%eax
        strncmp(entry->name,"..",2)==0||
801043e2:	66 83 f8 01          	cmp    $0x1,%ax
801043e6:	74 58                	je     80104440 <dfs+0x110>
        readblock((char*)(&INODES),BSIZE,BSIZE+(entry->inum/8 * BSIZE));
801043e8:	66 c1 e8 03          	shr    $0x3,%ax
801043ec:	83 ec 04             	sub    $0x4,%esp
801043ef:	0f b7 c0             	movzwl %ax,%eax
801043f2:	83 c0 01             	add    $0x1,%eax
801043f5:	c1 e0 09             	shl    $0x9,%eax
801043f8:	50                   	push   %eax
801043f9:	8d 85 e8 eb ff ff    	lea    -0x1418(%ebp),%eax
801043ff:	68 00 02 00 00       	push   $0x200
80104404:	50                   	push   %eax
80104405:	e8 86 fe ff ff       	call   80104290 <readblock>
        struct dinode* next_inode = &INODES[entry->inum%8];
8010440a:	0f b7 4e fe          	movzwl -0x2(%esi),%ecx
8010440e:	8d 95 e8 eb ff ff    	lea    -0x1418(%ebp),%edx
        dfs(entry->name,next_inode,depth+1);
80104414:	83 c4 0c             	add    $0xc,%esp
80104417:	57                   	push   %edi
        struct dinode* next_inode = &INODES[entry->inum%8];
80104418:	89 c8                	mov    %ecx,%eax
        flag[entry->inum] = 1;
8010441a:	c7 04 8d 40 3d 11 80 	movl   $0x1,-0x7feec2c0(,%ecx,4)
80104421:	01 00 00 00 
        struct dinode* next_inode = &INODES[entry->inum%8];
80104425:	83 e0 07             	and    $0x7,%eax
80104428:	c1 e0 06             	shl    $0x6,%eax
8010442b:	01 d0                	add    %edx,%eax
        dfs(entry->name,next_inode,depth+1);
8010442d:	50                   	push   %eax
8010442e:	56                   	push   %esi
8010442f:	e8 fc fe ff ff       	call   80104330 <dfs>
80104434:	83 c4 10             	add    $0x10,%esp
80104437:	89 f6                	mov    %esi,%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104440:	83 c6 10             	add    $0x10,%esi
      for(int j = 0; j < ENTNUM; j++,entry++){
80104443:	39 de                	cmp    %ebx,%esi
80104445:	0f 85 65 ff ff ff    	jne    801043b0 <dfs+0x80>
8010444b:	8b b5 e0 eb ff ff    	mov    -0x1420(%ebp),%esi
80104451:	83 c6 04             	add    $0x4,%esi
    for(int i = 0; i < NDIRECT; i++){
80104454:	3b b5 e4 eb ff ff    	cmp    -0x141c(%ebp),%esi
8010445a:	0f 85 0f ff ff ff    	jne    8010436f <dfs+0x3f>
    addr = inode->addrs[NDIRECT];
80104460:	8b 45 0c             	mov    0xc(%ebp),%eax
80104463:	8b 40 3c             	mov    0x3c(%eax),%eax
    if(addr == 0) return;
80104466:	85 c0                	test   %eax,%eax
80104468:	0f 84 d7 fe ff ff    	je     80104345 <dfs+0x15>
    readblock(&single[0],4096,(addr-1) * BSIZE);
8010446e:	05 ff ff 7f 00       	add    $0x7fffff,%eax
80104473:	83 ec 04             	sub    $0x4,%esp
        readblock((char*)(&INODES),BSIZE,BSIZE+(entry->inum/8 * BSIZE));
80104476:	8d bd e8 eb ff ff    	lea    -0x1418(%ebp),%edi
    readblock(&single[0],4096,(addr-1) * BSIZE);
8010447c:	c1 e0 09             	shl    $0x9,%eax
8010447f:	50                   	push   %eax
80104480:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
80104486:	68 00 10 00 00       	push   $0x1000
8010448b:	50                   	push   %eax
8010448c:	e8 ff fd ff ff       	call   80104290 <readblock>
    for(int i = 0;i < inode->size;){
80104491:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
80104497:	83 c4 10             	add    $0x10,%esp
8010449a:	c7 85 e4 eb ff ff 00 	movl   $0x0,-0x141c(%ebp)
801044a1:	00 00 00 
801044a4:	89 85 dc eb ff ff    	mov    %eax,-0x1424(%ebp)
801044aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ad:	8b 95 e4 eb ff ff    	mov    -0x141c(%ebp),%edx
801044b3:	8b 8d dc eb ff ff    	mov    -0x1424(%ebp),%ecx
801044b9:	8b 40 08             	mov    0x8(%eax),%eax
801044bc:	39 d0                	cmp    %edx,%eax
801044be:	0f 86 81 fe ff ff    	jbe    80104345 <dfs+0x15>
      if(addr == 0) continue;
801044c4:	85 c9                	test   %ecx,%ecx
801044c6:	74 f4                	je     801044bc <dfs+0x18c>
      readblock(&db[0],BSIZE,(addr - 1) * BSIZE);
801044c8:	8b 85 e4 eb ff ff    	mov    -0x141c(%ebp),%eax
801044ce:	83 ec 04             	sub    $0x4,%esp
801044d1:	8d b5 ea ed ff ff    	lea    -0x1216(%ebp),%esi
801044d7:	8d 9d ea ef ff ff    	lea    -0x1016(%ebp),%ebx
801044dd:	c1 e0 0c             	shl    $0xc,%eax
801044e0:	8d 84 05 e7 ef 7f 00 	lea    0x7fefe7(%ebp,%eax,1),%eax
801044e7:	c1 e0 09             	shl    $0x9,%eax
801044ea:	50                   	push   %eax
801044eb:	8d 85 e8 ed ff ff    	lea    -0x1218(%ebp),%eax
801044f1:	68 00 02 00 00       	push   $0x200
801044f6:	50                   	push   %eax
801044f7:	e8 94 fd ff ff       	call   80104290 <readblock>
        dfs(entry->name,next_inode,depth+1); 
801044fc:	8b 45 10             	mov    0x10(%ebp),%eax
801044ff:	83 c4 10             	add    $0x10,%esp
80104502:	83 c0 01             	add    $0x1,%eax
80104505:	89 85 e0 eb ff ff    	mov    %eax,-0x1420(%ebp)
8010450b:	90                   	nop
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(strncmp(entry->name,".",1)==0||
80104510:	83 ec 04             	sub    $0x4,%esp
80104513:	6a 01                	push   $0x1
80104515:	68 d2 7b 10 80       	push   $0x80107bd2
8010451a:	56                   	push   %esi
8010451b:	e8 d0 06 00 00       	call   80104bf0 <strncmp>
80104520:	83 c4 10             	add    $0x10,%esp
80104523:	85 c0                	test   %eax,%eax
80104525:	74 69                	je     80104590 <dfs+0x260>
        strncmp(entry->name,"..",2)==0||
80104527:	83 ec 04             	sub    $0x4,%esp
8010452a:	6a 02                	push   $0x2
8010452c:	68 d1 7b 10 80       	push   $0x80107bd1
80104531:	56                   	push   %esi
80104532:	e8 b9 06 00 00       	call   80104bf0 <strncmp>
        if(strncmp(entry->name,".",1)==0||
80104537:	83 c4 10             	add    $0x10,%esp
8010453a:	85 c0                	test   %eax,%eax
8010453c:	74 52                	je     80104590 <dfs+0x260>
        entry->inum==1){
8010453e:	0f b7 46 fe          	movzwl -0x2(%esi),%eax
        strncmp(entry->name,"..",2)==0||
80104542:	66 83 f8 01          	cmp    $0x1,%ax
80104546:	74 48                	je     80104590 <dfs+0x260>
        readblock((char*)(&INODES),BSIZE,BSIZE+(entry->inum/8 * BSIZE));
80104548:	66 c1 e8 03          	shr    $0x3,%ax
8010454c:	83 ec 04             	sub    $0x4,%esp
8010454f:	0f b7 c0             	movzwl %ax,%eax
80104552:	83 c0 01             	add    $0x1,%eax
80104555:	c1 e0 09             	shl    $0x9,%eax
80104558:	50                   	push   %eax
80104559:	68 00 02 00 00       	push   $0x200
8010455e:	57                   	push   %edi
8010455f:	e8 2c fd ff ff       	call   80104290 <readblock>
        struct dinode* next_inode = &INODES[entry->inum%8];
80104564:	0f b7 4e fe          	movzwl -0x2(%esi),%ecx
        dfs(entry->name,next_inode,depth+1); 
80104568:	83 c4 0c             	add    $0xc,%esp
8010456b:	ff b5 e0 eb ff ff    	pushl  -0x1420(%ebp)
        struct dinode* next_inode = &INODES[entry->inum%8];
80104571:	89 c8                	mov    %ecx,%eax
        flag[entry->inum] = 1;
80104573:	c7 04 8d 40 3d 11 80 	movl   $0x1,-0x7feec2c0(,%ecx,4)
8010457a:	01 00 00 00 
        struct dinode* next_inode = &INODES[entry->inum%8];
8010457e:	83 e0 07             	and    $0x7,%eax
80104581:	c1 e0 06             	shl    $0x6,%eax
80104584:	01 f8                	add    %edi,%eax
        dfs(entry->name,next_inode,depth+1); 
80104586:	50                   	push   %eax
80104587:	56                   	push   %esi
80104588:	e8 a3 fd ff ff       	call   80104330 <dfs>
8010458d:	83 c4 10             	add    $0x10,%esp
80104590:	83 c6 10             	add    $0x10,%esi
      for(int j = 0; j < ENTNUM; j++,entry++){
80104593:	39 de                	cmp    %ebx,%esi
80104595:	0f 85 75 ff ff ff    	jne    80104510 <dfs+0x1e0>
      i+=4;
8010459b:	83 85 e4 eb ff ff 04 	addl   $0x4,-0x141c(%ebp)
801045a2:	81 85 dc eb ff ff 00 	addl   $0x4000,-0x1424(%ebp)
801045a9:	40 00 00 
801045ac:	e9 f9 fe ff ff       	jmp    801044aa <dfs+0x17a>
801045b1:	eb 0d                	jmp    801045c0 <check_fs>
801045b3:	90                   	nop
801045b4:	90                   	nop
801045b5:	90                   	nop
801045b6:	90                   	nop
801045b7:	90                   	nop
801045b8:	90                   	nop
801045b9:	90                   	nop
801045ba:	90                   	nop
801045bb:	90                   	nop
801045bc:	90                   	nop
801045bd:	90                   	nop
801045be:	90                   	nop
801045bf:	90                   	nop

801045c0 <check_fs>:

void check_fs()
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	56                   	push   %esi
801045c5:	53                   	push   %ebx
    readsec(pa, offset);
801045c6:	8d 85 cc fd ff ff    	lea    -0x234(%ebp),%eax
  int checkFlag = 0;
    // False Num
  int Fnum = 0;

  readblock((char*)(&sb),BSIZE,0);
  readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE);
801045cc:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
{
801045d2:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  flag[ROOTINO] = 1;
801045d8:	c7 05 44 3d 11 80 01 	movl   $0x1,0x80113d44
801045df:	00 00 00 
    readsec(pa, offset);
801045e2:	6a 01                	push   $0x1
801045e4:	50                   	push   %eax
801045e5:	e8 a6 fb ff ff       	call   80104190 <readsec>
  readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE);
801045ea:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
801045f0:	83 c0 01             	add    $0x1,%eax
801045f3:	c1 e0 09             	shl    $0x9,%eax
801045f6:	50                   	push   %eax
801045f7:	68 00 02 00 00       	push   $0x200
801045fc:	53                   	push   %ebx
801045fd:	e8 8e fc ff ff       	call   80104290 <readblock>
  struct dinode * root = &INODE[1];
  dfs("/",root,1);
80104602:	8d 85 28 fe ff ff    	lea    -0x1d8(%ebp),%eax
80104608:	6a 01                	push   $0x1
8010460a:	50                   	push   %eax
8010460b:	68 52 7b 10 80       	push   $0x80107b52
80104610:	e8 1b fd ff ff       	call   80104330 <dfs>

  for(int i = 1; i < sb.ninodes; i++){
80104615:	83 c4 20             	add    $0x20,%esp
80104618:	83 bd d4 fd ff ff 01 	cmpl   $0x1,-0x22c(%ebp)
8010461f:	0f 86 13 01 00 00    	jbe    80104738 <check_fs+0x178>
  int checkFlag = 0;
80104625:	c7 85 c4 fd ff ff 00 	movl   $0x0,-0x23c(%ebp)
8010462c:	00 00 00 
  int Fnum = 0;
8010462f:	31 f6                	xor    %esi,%esi
  for(int i = 1; i < sb.ninodes; i++){
80104631:	bf 01 00 00 00       	mov    $0x1,%edi
80104636:	8d 76 00             	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(i % 8 == 0){
      readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE + i / 8 * BSIZE);
    }
    check = &INODE[i % 8];
    if(!flag[i] && check->type != 0){
80104640:	8b 04 bd 40 3d 11 80 	mov    -0x7feec2c0(,%edi,4),%eax
80104647:	85 c0                	test   %eax,%eax
80104649:	75 13                	jne    8010465e <check_fs+0x9e>
    check = &INODE[i % 8];
8010464b:	89 fa                	mov    %edi,%edx
8010464d:	83 e2 07             	and    $0x7,%edx
    if(!flag[i] && check->type != 0){
80104650:	c1 e2 06             	shl    $0x6,%edx
80104653:	66 83 bc 15 e8 fd ff 	cmpw   $0x0,-0x218(%ebp,%edx,1)
8010465a:	ff 00 
8010465c:	75 42                	jne    801046a0 <check_fs+0xe0>
  for(int i = 1; i < sb.ninodes; i++){
8010465e:	83 c7 01             	add    $0x1,%edi
80104661:	39 bd d4 fd ff ff    	cmp    %edi,-0x22c(%ebp)
80104667:	0f 86 a3 00 00 00    	jbe    80104710 <check_fs+0x150>
    if(i % 8 == 0){
8010466d:	f7 c7 07 00 00 00    	test   $0x7,%edi
80104673:	75 cb                	jne    80104640 <check_fs+0x80>
      readblock((char*)(&INODE),BSIZE,BSIZE + (sb.nlog) * BSIZE + i / 8 * BSIZE);
80104675:	8b 8d d8 fd ff ff    	mov    -0x228(%ebp),%ecx
8010467b:	89 fa                	mov    %edi,%edx
8010467d:	83 ec 04             	sub    $0x4,%esp
80104680:	c1 fa 03             	sar    $0x3,%edx
80104683:	8d 54 11 01          	lea    0x1(%ecx,%edx,1),%edx
80104687:	c1 e2 09             	shl    $0x9,%edx
8010468a:	52                   	push   %edx
8010468b:	68 00 02 00 00       	push   $0x200
80104690:	53                   	push   %ebx
80104691:	e8 fa fb ff ff       	call   80104290 <readblock>
80104696:	83 c4 10             	add    $0x10,%esp
80104699:	eb a5                	jmp    80104640 <check_fs+0x80>
8010469b:	90                   	nop
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      Fnum = Fnum + 1;
      checkFlag = 1;
      cprintf("\nfsck: inode %d is allocated but is not referenced by any dir!",i);
801046a0:	83 ec 08             	sub    $0x8,%esp
801046a3:	89 95 c4 fd ff ff    	mov    %edx,-0x23c(%ebp)
      Fnum = Fnum + 1;
801046a9:	83 c6 01             	add    $0x1,%esi
      cprintf("\nfsck: inode %d is allocated but is not referenced by any dir!",i);
801046ac:	57                   	push   %edi
801046ad:	68 50 7c 10 80       	push   $0x80107c50
801046b2:	e8 a9 bf ff ff       	call   80100660 <cprintf>
      check->type = 0;
801046b7:	8b 95 c4 fd ff ff    	mov    -0x23c(%ebp),%edx
801046bd:	31 c9                	xor    %ecx,%ecx
      writeblock((char*)(&INODE),512,BSIZE + (sb.nlog) * BSIZE + (i / 8) * BSIZE);
801046bf:	83 c4 0c             	add    $0xc,%esp
      check->type = 0;
801046c2:	66 89 8c 15 e8 fd ff 	mov    %cx,-0x218(%ebp,%edx,1)
801046c9:	ff 
      writeblock((char*)(&INODE),512,BSIZE + (sb.nlog) * BSIZE + (i / 8) * BSIZE);
801046ca:	8b 8d d8 fd ff ff    	mov    -0x228(%ebp),%ecx
801046d0:	89 fa                	mov    %edi,%edx
801046d2:	c1 fa 03             	sar    $0x3,%edx
  for(int i = 1; i < sb.ninodes; i++){
801046d5:	83 c7 01             	add    $0x1,%edi
      writeblock((char*)(&INODE),512,BSIZE + (sb.nlog) * BSIZE + (i / 8) * BSIZE);
801046d8:	8d 54 11 01          	lea    0x1(%ecx,%edx,1),%edx
801046dc:	c1 e2 09             	shl    $0x9,%edx
801046df:	52                   	push   %edx
801046e0:	68 00 02 00 00       	push   $0x200
801046e5:	53                   	push   %ebx
801046e6:	e8 f5 fb ff ff       	call   801042e0 <writeblock>
      cprintf("Fixing ... done");
801046eb:	c7 04 24 d4 7b 10 80 	movl   $0x80107bd4,(%esp)
801046f2:	e8 69 bf ff ff       	call   80100660 <cprintf>
801046f7:	83 c4 10             	add    $0x10,%esp
  for(int i = 1; i < sb.ninodes; i++){
801046fa:	39 bd d4 fd ff ff    	cmp    %edi,-0x22c(%ebp)
      checkFlag = 1;
80104700:	c7 85 c4 fd ff ff 01 	movl   $0x1,-0x23c(%ebp)
80104707:	00 00 00 
  for(int i = 1; i < sb.ninodes; i++){
8010470a:	0f 87 5d ff ff ff    	ja     8010466d <check_fs+0xad>
    }
  }
  if(checkFlag){
80104710:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
80104716:	85 c0                	test   %eax,%eax
80104718:	74 1e                	je     80104738 <check_fs+0x178>
    cprintf("\nfsck completed. Fixed %d inodes and freed %d disk blocks. ",Fnum,Fnum);
8010471a:	83 ec 04             	sub    $0x4,%esp
8010471d:	56                   	push   %esi
8010471e:	56                   	push   %esi
8010471f:	68 90 7c 10 80       	push   $0x80107c90
80104724:	e8 37 bf ff ff       	call   80100660 <cprintf>
80104729:	83 c4 10             	add    $0x10,%esp
  }else{
    cprintf(" fsck: no problem found. ");
  }
8010472c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010472f:	5b                   	pop    %ebx
80104730:	5e                   	pop    %esi
80104731:	5f                   	pop    %edi
80104732:	5d                   	pop    %ebp
80104733:	c3                   	ret    
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" fsck: no problem found. ");
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 e4 7b 10 80       	push   $0x80107be4
80104740:	e8 1b bf ff ff       	call   80100660 <cprintf>
80104745:	83 c4 10             	add    $0x10,%esp
80104748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474b:	5b                   	pop    %ebx
8010474c:	5e                   	pop    %esi
8010474d:	5f                   	pop    %edi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret    

80104750 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010475a:	68 e4 7c 10 80       	push   $0x80107ce4
8010475f:	8d 43 04             	lea    0x4(%ebx),%eax
80104762:	50                   	push   %eax
80104763:	e8 f8 00 00 00       	call   80104860 <initlock>
  lk->name = name;
80104768:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010476b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104771:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104774:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010477b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010477e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104781:	c9                   	leave  
80104782:	c3                   	ret    
80104783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
8010479f:	e8 ac 01 00 00       	call   80104950 <acquire>
  while (lk->locked) {
801047a4:	8b 13                	mov    (%ebx),%edx
801047a6:	83 c4 10             	add    $0x10,%esp
801047a9:	85 d2                	test   %edx,%edx
801047ab:	74 16                	je     801047c3 <acquiresleep+0x33>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801047b0:	83 ec 08             	sub    $0x8,%esp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	e8 66 f6 ff ff       	call   80103e20 <sleep>
  while (lk->locked) {
801047ba:	8b 03                	mov    (%ebx),%eax
801047bc:	83 c4 10             	add    $0x10,%esp
801047bf:	85 c0                	test   %eax,%eax
801047c1:	75 ed                	jne    801047b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047c9:	e8 82 f0 ff ff       	call   80103850 <myproc>
801047ce:	8b 40 10             	mov    0x10(%eax),%eax
801047d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047da:	5b                   	pop    %ebx
801047db:	5e                   	pop    %esi
801047dc:	5d                   	pop    %ebp
  release(&lk->lk);
801047dd:	e9 8e 02 00 00       	jmp    80104a70 <release>
801047e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047f8:	83 ec 0c             	sub    $0xc,%esp
801047fb:	8d 73 04             	lea    0x4(%ebx),%esi
801047fe:	56                   	push   %esi
801047ff:	e8 4c 01 00 00       	call   80104950 <acquire>
  lk->locked = 0;
80104804:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010480a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104811:	89 1c 24             	mov    %ebx,(%esp)
80104814:	e8 b7 f7 ff ff       	call   80103fd0 <wakeup>
  release(&lk->lk);
80104819:	89 75 08             	mov    %esi,0x8(%ebp)
8010481c:	83 c4 10             	add    $0x10,%esp
}
8010481f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104822:	5b                   	pop    %ebx
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
  release(&lk->lk);
80104825:	e9 46 02 00 00       	jmp    80104a70 <release>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010483e:	53                   	push   %ebx
8010483f:	e8 0c 01 00 00       	call   80104950 <acquire>
  r = lk->locked;
80104844:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104846:	89 1c 24             	mov    %ebx,(%esp)
80104849:	e8 22 02 00 00       	call   80104a70 <release>
  return r;
}
8010484e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104851:	89 f0                	mov    %esi,%eax
80104853:	5b                   	pop    %ebx
80104854:	5e                   	pop    %esi
80104855:	5d                   	pop    %ebp
80104856:	c3                   	ret    
80104857:	66 90                	xchg   %ax,%ax
80104859:	66 90                	xchg   %ax,%ax
8010485b:	66 90                	xchg   %ax,%ax
8010485d:	66 90                	xchg   %ax,%ax
8010485f:	90                   	nop

80104860 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104866:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010486f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104872:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	90                   	nop
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104880:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104881:	31 d2                	xor    %edx,%edx
{
80104883:	89 e5                	mov    %esp,%ebp
80104885:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104886:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010488c:	83 e8 08             	sub    $0x8,%eax
8010488f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104890:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104896:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010489c:	77 1a                	ja     801048b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010489e:	8b 58 04             	mov    0x4(%eax),%ebx
801048a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801048a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801048a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048a9:	83 fa 0a             	cmp    $0xa,%edx
801048ac:	75 e2                	jne    80104890 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048ae:	5b                   	pop    %ebx
801048af:	5d                   	pop    %ebp
801048b0:	c3                   	ret    
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801048bb:	83 c1 28             	add    $0x28,%ecx
801048be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801048c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048c9:	39 c1                	cmp    %eax,%ecx
801048cb:	75 f3                	jne    801048c0 <getcallerpcs+0x40>
}
801048cd:	5b                   	pop    %ebx
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret    

801048d0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
801048d7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801048da:	8b 02                	mov    (%edx),%eax
801048dc:	85 c0                	test   %eax,%eax
801048de:	75 10                	jne    801048f0 <holding+0x20>
}
801048e0:	83 c4 04             	add    $0x4,%esp
801048e3:	31 c0                	xor    %eax,%eax
801048e5:	5b                   	pop    %ebx
801048e6:	5d                   	pop    %ebp
801048e7:	c3                   	ret    
801048e8:	90                   	nop
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801048f0:	8b 5a 08             	mov    0x8(%edx),%ebx
801048f3:	e8 b8 ee ff ff       	call   801037b0 <mycpu>
801048f8:	39 c3                	cmp    %eax,%ebx
801048fa:	0f 94 c0             	sete   %al
}
801048fd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104900:	0f b6 c0             	movzbl %al,%eax
}
80104903:	5b                   	pop    %ebx
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	8d 76 00             	lea    0x0(%esi),%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104917:	9c                   	pushf  
80104918:	5b                   	pop    %ebx
  asm volatile("cli");
80104919:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010491a:	e8 91 ee ff ff       	call   801037b0 <mycpu>
8010491f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104925:	85 c0                	test   %eax,%eax
80104927:	75 11                	jne    8010493a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104929:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010492f:	e8 7c ee ff ff       	call   801037b0 <mycpu>
80104934:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010493a:	e8 71 ee ff ff       	call   801037b0 <mycpu>
8010493f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104946:	83 c4 04             	add    $0x4,%esp
80104949:	5b                   	pop    %ebx
8010494a:	5d                   	pop    %ebp
8010494b:	c3                   	ret    
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104950 <acquire>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104955:	e8 b6 ff ff ff       	call   80104910 <pushcli>
  if(holding(lk))
8010495a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010495d:	8b 03                	mov    (%ebx),%eax
8010495f:	85 c0                	test   %eax,%eax
80104961:	0f 85 81 00 00 00    	jne    801049e8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104967:	ba 01 00 00 00       	mov    $0x1,%edx
8010496c:	eb 05                	jmp    80104973 <acquire+0x23>
8010496e:	66 90                	xchg   %ax,%ax
80104970:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104973:	89 d0                	mov    %edx,%eax
80104975:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104978:	85 c0                	test   %eax,%eax
8010497a:	75 f4                	jne    80104970 <acquire+0x20>
  __sync_synchronize();
8010497c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104981:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104984:	e8 27 ee ff ff       	call   801037b0 <mycpu>
  for(i = 0; i < 10; i++){
80104989:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010498b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010498e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104991:	89 e8                	mov    %ebp,%eax
80104993:	90                   	nop
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104998:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010499e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049a4:	77 1a                	ja     801049c0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801049a6:	8b 58 04             	mov    0x4(%eax),%ebx
801049a9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801049ac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801049af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049b1:	83 fa 0a             	cmp    $0xa,%edx
801049b4:	75 e2                	jne    80104998 <acquire+0x48>
}
801049b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b9:	5b                   	pop    %ebx
801049ba:	5e                   	pop    %esi
801049bb:	5d                   	pop    %ebp
801049bc:	c3                   	ret    
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049c3:	83 c1 28             	add    $0x28,%ecx
801049c6:	8d 76 00             	lea    0x0(%esi),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049d9:	39 c8                	cmp    %ecx,%eax
801049db:	75 f3                	jne    801049d0 <acquire+0x80>
}
801049dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049e0:	5b                   	pop    %ebx
801049e1:	5e                   	pop    %esi
801049e2:	5d                   	pop    %ebp
801049e3:	c3                   	ret    
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801049e8:	8b 73 08             	mov    0x8(%ebx),%esi
801049eb:	e8 c0 ed ff ff       	call   801037b0 <mycpu>
801049f0:	39 c6                	cmp    %eax,%esi
801049f2:	0f 85 6f ff ff ff    	jne    80104967 <acquire+0x17>
    panic("acquire");
801049f8:	83 ec 0c             	sub    $0xc,%esp
801049fb:	68 ef 7c 10 80       	push   $0x80107cef
80104a00:	e8 8b b9 ff ff       	call   80100390 <panic>
80104a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <popcli>:

void
popcli(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a16:	9c                   	pushf  
80104a17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a18:	f6 c4 02             	test   $0x2,%ah
80104a1b:	75 35                	jne    80104a52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a1d:	e8 8e ed ff ff       	call   801037b0 <mycpu>
80104a22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a29:	78 34                	js     80104a5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a2b:	e8 80 ed ff ff       	call   801037b0 <mycpu>
80104a30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a36:	85 d2                	test   %edx,%edx
80104a38:	74 06                	je     80104a40 <popcli+0x30>
    sti();
}
80104a3a:	c9                   	leave  
80104a3b:	c3                   	ret    
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a40:	e8 6b ed ff ff       	call   801037b0 <mycpu>
80104a45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	74 eb                	je     80104a3a <popcli+0x2a>
  asm volatile("sti");
80104a4f:	fb                   	sti    
}
80104a50:	c9                   	leave  
80104a51:	c3                   	ret    
    panic("popcli - interruptible");
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	68 f7 7c 10 80       	push   $0x80107cf7
80104a5a:	e8 31 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	68 0e 7d 10 80       	push   $0x80107d0e
80104a67:	e8 24 b9 ff ff       	call   80100390 <panic>
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <release>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104a78:	8b 03                	mov    (%ebx),%eax
80104a7a:	85 c0                	test   %eax,%eax
80104a7c:	74 0c                	je     80104a8a <release+0x1a>
80104a7e:	8b 73 08             	mov    0x8(%ebx),%esi
80104a81:	e8 2a ed ff ff       	call   801037b0 <mycpu>
80104a86:	39 c6                	cmp    %eax,%esi
80104a88:	74 16                	je     80104aa0 <release+0x30>
    panic("release");
80104a8a:	83 ec 0c             	sub    $0xc,%esp
80104a8d:	68 15 7d 10 80       	push   $0x80107d15
80104a92:	e8 f9 b8 ff ff       	call   80100390 <panic>
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104aa0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104aa7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104aae:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ab3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ab9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104abc:	5b                   	pop    %ebx
80104abd:	5e                   	pop    %esi
80104abe:	5d                   	pop    %ebp
  popcli();
80104abf:	e9 4c ff ff ff       	jmp    80104a10 <popcli>
80104ac4:	66 90                	xchg   %ax,%ax
80104ac6:	66 90                	xchg   %ax,%ax
80104ac8:	66 90                	xchg   %ax,%ax
80104aca:	66 90                	xchg   %ax,%ax
80104acc:	66 90                	xchg   %ax,%ax
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104adb:	f6 c2 03             	test   $0x3,%dl
80104ade:	75 05                	jne    80104ae5 <memset+0x15>
80104ae0:	f6 c1 03             	test   $0x3,%cl
80104ae3:	74 13                	je     80104af8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ae5:	89 d7                	mov    %edx,%edi
80104ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aea:	fc                   	cld    
80104aeb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104aed:	5b                   	pop    %ebx
80104aee:	89 d0                	mov    %edx,%eax
80104af0:	5f                   	pop    %edi
80104af1:	5d                   	pop    %ebp
80104af2:	c3                   	ret    
80104af3:	90                   	nop
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104af8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104afc:	c1 e9 02             	shr    $0x2,%ecx
80104aff:	89 f8                	mov    %edi,%eax
80104b01:	89 fb                	mov    %edi,%ebx
80104b03:	c1 e0 18             	shl    $0x18,%eax
80104b06:	c1 e3 10             	shl    $0x10,%ebx
80104b09:	09 d8                	or     %ebx,%eax
80104b0b:	09 f8                	or     %edi,%eax
80104b0d:	c1 e7 08             	shl    $0x8,%edi
80104b10:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b12:	89 d7                	mov    %edx,%edi
80104b14:	fc                   	cld    
80104b15:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104b17:	5b                   	pop    %ebx
80104b18:	89 d0                	mov    %edx,%eax
80104b1a:	5f                   	pop    %edi
80104b1b:	5d                   	pop    %ebp
80104b1c:	c3                   	ret    
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi

80104b20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
80104b25:	53                   	push   %ebx
80104b26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b29:	8b 75 08             	mov    0x8(%ebp),%esi
80104b2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b2f:	85 db                	test   %ebx,%ebx
80104b31:	74 29                	je     80104b5c <memcmp+0x3c>
    if(*s1 != *s2)
80104b33:	0f b6 16             	movzbl (%esi),%edx
80104b36:	0f b6 0f             	movzbl (%edi),%ecx
80104b39:	38 d1                	cmp    %dl,%cl
80104b3b:	75 2b                	jne    80104b68 <memcmp+0x48>
80104b3d:	b8 01 00 00 00       	mov    $0x1,%eax
80104b42:	eb 14                	jmp    80104b58 <memcmp+0x38>
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b48:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b4c:	83 c0 01             	add    $0x1,%eax
80104b4f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104b54:	38 ca                	cmp    %cl,%dl
80104b56:	75 10                	jne    80104b68 <memcmp+0x48>
  while(n-- > 0){
80104b58:	39 d8                	cmp    %ebx,%eax
80104b5a:	75 ec                	jne    80104b48 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b5c:	5b                   	pop    %ebx
  return 0;
80104b5d:	31 c0                	xor    %eax,%eax
}
80104b5f:	5e                   	pop    %esi
80104b60:	5f                   	pop    %edi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b68:	0f b6 c2             	movzbl %dl,%eax
}
80104b6b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b6c:	29 c8                	sub    %ecx,%eax
}
80104b6e:	5e                   	pop    %esi
80104b6f:	5f                   	pop    %edi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 45 08             	mov    0x8(%ebp),%eax
80104b88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b8b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b8e:	39 c3                	cmp    %eax,%ebx
80104b90:	73 26                	jae    80104bb8 <memmove+0x38>
80104b92:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b95:	39 c8                	cmp    %ecx,%eax
80104b97:	73 1f                	jae    80104bb8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b99:	85 f6                	test   %esi,%esi
80104b9b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b9e:	74 0f                	je     80104baf <memmove+0x2f>
      *--d = *--s;
80104ba0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ba4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ba7:	83 ea 01             	sub    $0x1,%edx
80104baa:	83 fa ff             	cmp    $0xffffffff,%edx
80104bad:	75 f1                	jne    80104ba0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104baf:	5b                   	pop    %ebx
80104bb0:	5e                   	pop    %esi
80104bb1:	5d                   	pop    %ebp
80104bb2:	c3                   	ret    
80104bb3:	90                   	nop
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104bb8:	31 d2                	xor    %edx,%edx
80104bba:	85 f6                	test   %esi,%esi
80104bbc:	74 f1                	je     80104baf <memmove+0x2f>
80104bbe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104bc0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104bc4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104bc7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104bca:	39 d6                	cmp    %edx,%esi
80104bcc:	75 f2                	jne    80104bc0 <memmove+0x40>
}
80104bce:	5b                   	pop    %ebx
80104bcf:	5e                   	pop    %esi
80104bd0:	5d                   	pop    %ebp
80104bd1:	c3                   	ret    
80104bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104be3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104be4:	eb 9a                	jmp    80104b80 <memmove>
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104bf8:	53                   	push   %ebx
80104bf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bff:	85 ff                	test   %edi,%edi
80104c01:	74 2f                	je     80104c32 <strncmp+0x42>
80104c03:	0f b6 01             	movzbl (%ecx),%eax
80104c06:	0f b6 1e             	movzbl (%esi),%ebx
80104c09:	84 c0                	test   %al,%al
80104c0b:	74 37                	je     80104c44 <strncmp+0x54>
80104c0d:	38 c3                	cmp    %al,%bl
80104c0f:	75 33                	jne    80104c44 <strncmp+0x54>
80104c11:	01 f7                	add    %esi,%edi
80104c13:	eb 13                	jmp    80104c28 <strncmp+0x38>
80104c15:	8d 76 00             	lea    0x0(%esi),%esi
80104c18:	0f b6 01             	movzbl (%ecx),%eax
80104c1b:	84 c0                	test   %al,%al
80104c1d:	74 21                	je     80104c40 <strncmp+0x50>
80104c1f:	0f b6 1a             	movzbl (%edx),%ebx
80104c22:	89 d6                	mov    %edx,%esi
80104c24:	38 d8                	cmp    %bl,%al
80104c26:	75 1c                	jne    80104c44 <strncmp+0x54>
    n--, p++, q++;
80104c28:	8d 56 01             	lea    0x1(%esi),%edx
80104c2b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c2e:	39 fa                	cmp    %edi,%edx
80104c30:	75 e6                	jne    80104c18 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c32:	5b                   	pop    %ebx
    return 0;
80104c33:	31 c0                	xor    %eax,%eax
}
80104c35:	5e                   	pop    %esi
80104c36:	5f                   	pop    %edi
80104c37:	5d                   	pop    %ebp
80104c38:	c3                   	ret    
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c40:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104c44:	29 d8                	sub    %ebx,%eax
}
80104c46:	5b                   	pop    %ebx
80104c47:	5e                   	pop    %esi
80104c48:	5f                   	pop    %edi
80104c49:	5d                   	pop    %ebp
80104c4a:	c3                   	ret    
80104c4b:	90                   	nop
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	8b 45 08             	mov    0x8(%ebp),%eax
80104c58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c5e:	89 c2                	mov    %eax,%edx
80104c60:	eb 19                	jmp    80104c7b <strncpy+0x2b>
80104c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c68:	83 c3 01             	add    $0x1,%ebx
80104c6b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c6f:	83 c2 01             	add    $0x1,%edx
80104c72:	84 c9                	test   %cl,%cl
80104c74:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c77:	74 09                	je     80104c82 <strncpy+0x32>
80104c79:	89 f1                	mov    %esi,%ecx
80104c7b:	85 c9                	test   %ecx,%ecx
80104c7d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c80:	7f e6                	jg     80104c68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c82:	31 c9                	xor    %ecx,%ecx
80104c84:	85 f6                	test   %esi,%esi
80104c86:	7e 17                	jle    80104c9f <strncpy+0x4f>
80104c88:	90                   	nop
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c90:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c94:	89 f3                	mov    %esi,%ebx
80104c96:	83 c1 01             	add    $0x1,%ecx
80104c99:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c9b:	85 db                	test   %ebx,%ebx
80104c9d:	7f f1                	jg     80104c90 <strncpy+0x40>
  return os;
}
80104c9f:	5b                   	pop    %ebx
80104ca0:	5e                   	pop    %esi
80104ca1:	5d                   	pop    %ebp
80104ca2:	c3                   	ret    
80104ca3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
80104cb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80104cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104cbe:	85 c9                	test   %ecx,%ecx
80104cc0:	7e 26                	jle    80104ce8 <safestrcpy+0x38>
80104cc2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104cc6:	89 c1                	mov    %eax,%ecx
80104cc8:	eb 17                	jmp    80104ce1 <safestrcpy+0x31>
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104cd0:	83 c2 01             	add    $0x1,%edx
80104cd3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104cd7:	83 c1 01             	add    $0x1,%ecx
80104cda:	84 db                	test   %bl,%bl
80104cdc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104cdf:	74 04                	je     80104ce5 <safestrcpy+0x35>
80104ce1:	39 f2                	cmp    %esi,%edx
80104ce3:	75 eb                	jne    80104cd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ce5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ce8:	5b                   	pop    %ebx
80104ce9:	5e                   	pop    %esi
80104cea:	5d                   	pop    %ebp
80104ceb:	c3                   	ret    
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <strlen>:

int
strlen(const char *s)
{
80104cf0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cf1:	31 c0                	xor    %eax,%eax
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104cf8:	80 3a 00             	cmpb   $0x0,(%edx)
80104cfb:	74 0c                	je     80104d09 <strlen+0x19>
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
80104d00:	83 c0 01             	add    $0x1,%eax
80104d03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d07:	75 f7                	jne    80104d00 <strlen+0x10>
    ;
  return n;
}
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    

80104d0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104d13:	55                   	push   %ebp
  pushl %ebx
80104d14:	53                   	push   %ebx
  pushl %esi
80104d15:	56                   	push   %esi
  pushl %edi
80104d16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d19:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104d1b:	5f                   	pop    %edi
  popl %esi
80104d1c:	5e                   	pop    %esi
  popl %ebx
80104d1d:	5b                   	pop    %ebx
  popl %ebp
80104d1e:	5d                   	pop    %ebp
  ret
80104d1f:	c3                   	ret    

80104d20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
80104d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d2a:	e8 21 eb ff ff       	call   80103850 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d2f:	8b 00                	mov    (%eax),%eax
80104d31:	39 d8                	cmp    %ebx,%eax
80104d33:	76 1b                	jbe    80104d50 <fetchint+0x30>
80104d35:	8d 53 04             	lea    0x4(%ebx),%edx
80104d38:	39 d0                	cmp    %edx,%eax
80104d3a:	72 14                	jb     80104d50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3f:	8b 13                	mov    (%ebx),%edx
80104d41:	89 10                	mov    %edx,(%eax)
  return 0;
80104d43:	31 c0                	xor    %eax,%eax
}
80104d45:	83 c4 04             	add    $0x4,%esp
80104d48:	5b                   	pop    %ebx
80104d49:	5d                   	pop    %ebp
80104d4a:	c3                   	ret    
80104d4b:	90                   	nop
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d55:	eb ee                	jmp    80104d45 <fetchint+0x25>
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
80104d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d6a:	e8 e1 ea ff ff       	call   80103850 <myproc>

  if(addr >= curproc->sz)
80104d6f:	39 18                	cmp    %ebx,(%eax)
80104d71:	76 29                	jbe    80104d9c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d76:	89 da                	mov    %ebx,%edx
80104d78:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d7a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d7c:	39 c3                	cmp    %eax,%ebx
80104d7e:	73 1c                	jae    80104d9c <fetchstr+0x3c>
    if(*s == 0)
80104d80:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d83:	75 10                	jne    80104d95 <fetchstr+0x35>
80104d85:	eb 39                	jmp    80104dc0 <fetchstr+0x60>
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d90:	80 3a 00             	cmpb   $0x0,(%edx)
80104d93:	74 1b                	je     80104db0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d95:	83 c2 01             	add    $0x1,%edx
80104d98:	39 d0                	cmp    %edx,%eax
80104d9a:	77 f4                	ja     80104d90 <fetchstr+0x30>
    return -1;
80104d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104da1:	83 c4 04             	add    $0x4,%esp
80104da4:	5b                   	pop    %ebx
80104da5:	5d                   	pop    %ebp
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104db0:	83 c4 04             	add    $0x4,%esp
80104db3:	89 d0                	mov    %edx,%eax
80104db5:	29 d8                	sub    %ebx,%eax
80104db7:	5b                   	pop    %ebx
80104db8:	5d                   	pop    %ebp
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104dc0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104dc2:	eb dd                	jmp    80104da1 <fetchstr+0x41>
80104dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104dd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dd5:	e8 76 ea ff ff       	call   80103850 <myproc>
80104dda:	8b 40 18             	mov    0x18(%eax),%eax
80104ddd:	8b 55 08             	mov    0x8(%ebp),%edx
80104de0:	8b 40 44             	mov    0x44(%eax),%eax
80104de3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104de6:	e8 65 ea ff ff       	call   80103850 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104deb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ded:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104df0:	39 c6                	cmp    %eax,%esi
80104df2:	73 1c                	jae    80104e10 <argint+0x40>
80104df4:	8d 53 08             	lea    0x8(%ebx),%edx
80104df7:	39 d0                	cmp    %edx,%eax
80104df9:	72 15                	jb     80104e10 <argint+0x40>
  *ip = *(int*)(addr);
80104dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104e01:	89 10                	mov    %edx,(%eax)
  return 0;
80104e03:	31 c0                	xor    %eax,%eax
}
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e15:	eb ee                	jmp    80104e05 <argint+0x35>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
80104e25:	83 ec 10             	sub    $0x10,%esp
80104e28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104e2b:	e8 20 ea ff ff       	call   80103850 <myproc>
80104e30:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104e32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e35:	83 ec 08             	sub    $0x8,%esp
80104e38:	50                   	push   %eax
80104e39:	ff 75 08             	pushl  0x8(%ebp)
80104e3c:	e8 8f ff ff ff       	call   80104dd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e41:	83 c4 10             	add    $0x10,%esp
80104e44:	85 c0                	test   %eax,%eax
80104e46:	78 28                	js     80104e70 <argptr+0x50>
80104e48:	85 db                	test   %ebx,%ebx
80104e4a:	78 24                	js     80104e70 <argptr+0x50>
80104e4c:	8b 16                	mov    (%esi),%edx
80104e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e51:	39 c2                	cmp    %eax,%edx
80104e53:	76 1b                	jbe    80104e70 <argptr+0x50>
80104e55:	01 c3                	add    %eax,%ebx
80104e57:	39 da                	cmp    %ebx,%edx
80104e59:	72 15                	jb     80104e70 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e5e:	89 02                	mov    %eax,(%edx)
  return 0;
80104e60:	31 c0                	xor    %eax,%eax
}
80104e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e65:	5b                   	pop    %ebx
80104e66:	5e                   	pop    %esi
80104e67:	5d                   	pop    %ebp
80104e68:	c3                   	ret    
80104e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e75:	eb eb                	jmp    80104e62 <argptr+0x42>
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e89:	50                   	push   %eax
80104e8a:	ff 75 08             	pushl  0x8(%ebp)
80104e8d:	e8 3e ff ff ff       	call   80104dd0 <argint>
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	85 c0                	test   %eax,%eax
80104e97:	78 17                	js     80104eb0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e99:	83 ec 08             	sub    $0x8,%esp
80104e9c:	ff 75 0c             	pushl  0xc(%ebp)
80104e9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104ea2:	e8 b9 fe ff ff       	call   80104d60 <fetchstr>
80104ea7:	83 c4 10             	add    $0x10,%esp
}
80104eaa:	c9                   	leave  
80104eab:	c3                   	ret    
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <syscall>:
[SYS_get_free_frame_cnt] sys_get_free_frame_cnt,
};

void
syscall(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	53                   	push   %ebx
80104ec4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ec7:	e8 84 e9 ff ff       	call   80103850 <myproc>
80104ecc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ece:	8b 40 18             	mov    0x18(%eax),%eax
80104ed1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ed4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ed7:	83 fa 16             	cmp    $0x16,%edx
80104eda:	77 1c                	ja     80104ef8 <syscall+0x38>
80104edc:	8b 14 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%edx
80104ee3:	85 d2                	test   %edx,%edx
80104ee5:	74 11                	je     80104ef8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104ee7:	ff d2                	call   *%edx
80104ee9:	8b 53 18             	mov    0x18(%ebx),%edx
80104eec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ef2:	c9                   	leave  
80104ef3:	c3                   	ret    
80104ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ef8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ef9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104efc:	50                   	push   %eax
80104efd:	ff 73 10             	pushl  0x10(%ebx)
80104f00:	68 1d 7d 10 80       	push   $0x80107d1d
80104f05:	e8 56 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104f0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f1a:	c9                   	leave  
80104f1b:	c3                   	ret    
80104f1c:	66 90                	xchg   %ax,%ax
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f26:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104f29:	83 ec 44             	sub    $0x44,%esp
80104f2c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104f2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104f32:	56                   	push   %esi
80104f33:	50                   	push   %eax
{
80104f34:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104f37:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f3a:	e8 d1 cf ff ff       	call   80101f10 <nameiparent>
80104f3f:	83 c4 10             	add    $0x10,%esp
80104f42:	85 c0                	test   %eax,%eax
80104f44:	0f 84 46 01 00 00    	je     80105090 <create+0x170>
    return 0;
  ilock(dp);
80104f4a:	83 ec 0c             	sub    $0xc,%esp
80104f4d:	89 c3                	mov    %eax,%ebx
80104f4f:	50                   	push   %eax
80104f50:	e8 3b c7 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104f55:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104f58:	83 c4 0c             	add    $0xc,%esp
80104f5b:	50                   	push   %eax
80104f5c:	56                   	push   %esi
80104f5d:	53                   	push   %ebx
80104f5e:	e8 5d cc ff ff       	call   80101bc0 <dirlookup>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	89 c7                	mov    %eax,%edi
80104f6a:	74 34                	je     80104fa0 <create+0x80>
    iunlockput(dp);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	53                   	push   %ebx
80104f70:	e8 ab c9 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104f75:	89 3c 24             	mov    %edi,(%esp)
80104f78:	e8 13 c7 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104f85:	0f 85 95 00 00 00    	jne    80105020 <create+0x100>
80104f8b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f90:	0f 85 8a 00 00 00    	jne    80105020 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f99:	89 f8                	mov    %edi,%eax
80104f9b:	5b                   	pop    %ebx
80104f9c:	5e                   	pop    %esi
80104f9d:	5f                   	pop    %edi
80104f9e:	5d                   	pop    %ebp
80104f9f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104fa0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104fa4:	83 ec 08             	sub    $0x8,%esp
80104fa7:	50                   	push   %eax
80104fa8:	ff 33                	pushl  (%ebx)
80104faa:	e8 71 c5 ff ff       	call   80101520 <ialloc>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	89 c7                	mov    %eax,%edi
80104fb6:	0f 84 e8 00 00 00    	je     801050a4 <create+0x184>
  ilock(ip);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	50                   	push   %eax
80104fc0:	e8 cb c6 ff ff       	call   80101690 <ilock>
  ip->major = major;
80104fc5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104fc9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104fcd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104fd1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104fd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104fda:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104fde:	89 3c 24             	mov    %edi,(%esp)
80104fe1:	e8 fa c5 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104fe6:	83 c4 10             	add    $0x10,%esp
80104fe9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104fee:	74 50                	je     80105040 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ff0:	83 ec 04             	sub    $0x4,%esp
80104ff3:	ff 77 04             	pushl  0x4(%edi)
80104ff6:	56                   	push   %esi
80104ff7:	53                   	push   %ebx
80104ff8:	e8 33 ce ff ff       	call   80101e30 <dirlink>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	0f 88 8f 00 00 00    	js     80105097 <create+0x177>
  iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	53                   	push   %ebx
8010500c:	e8 0f c9 ff ff       	call   80101920 <iunlockput>
  return ip;
80105011:	83 c4 10             	add    $0x10,%esp
}
80105014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105017:	89 f8                	mov    %edi,%eax
80105019:	5b                   	pop    %ebx
8010501a:	5e                   	pop    %esi
8010501b:	5f                   	pop    %edi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	57                   	push   %edi
    return 0;
80105024:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105026:	e8 f5 c8 ff ff       	call   80101920 <iunlockput>
    return 0;
8010502b:	83 c4 10             	add    $0x10,%esp
}
8010502e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105031:	89 f8                	mov    %edi,%eax
80105033:	5b                   	pop    %ebx
80105034:	5e                   	pop    %esi
80105035:	5f                   	pop    %edi
80105036:	5d                   	pop    %ebp
80105037:	c3                   	ret    
80105038:	90                   	nop
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105040:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	53                   	push   %ebx
80105049:	e8 92 c5 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010504e:	83 c4 0c             	add    $0xc,%esp
80105051:	ff 77 04             	pushl  0x4(%edi)
80105054:	68 d2 7b 10 80       	push   $0x80107bd2
80105059:	57                   	push   %edi
8010505a:	e8 d1 cd ff ff       	call   80101e30 <dirlink>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	78 1c                	js     80105082 <create+0x162>
80105066:	83 ec 04             	sub    $0x4,%esp
80105069:	ff 73 04             	pushl  0x4(%ebx)
8010506c:	68 d1 7b 10 80       	push   $0x80107bd1
80105071:	57                   	push   %edi
80105072:	e8 b9 cd ff ff       	call   80101e30 <dirlink>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	0f 89 6e ff ff ff    	jns    80104ff0 <create+0xd0>
      panic("create dots");
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	68 af 7d 10 80       	push   $0x80107daf
8010508a:	e8 01 b3 ff ff       	call   80100390 <panic>
8010508f:	90                   	nop
    return 0;
80105090:	31 ff                	xor    %edi,%edi
80105092:	e9 ff fe ff ff       	jmp    80104f96 <create+0x76>
    panic("create: dirlink");
80105097:	83 ec 0c             	sub    $0xc,%esp
8010509a:	68 bb 7d 10 80       	push   $0x80107dbb
8010509f:	e8 ec b2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	68 a0 7d 10 80       	push   $0x80107da0
801050ac:	e8 df b2 ff ff       	call   80100390 <panic>
801050b1:	eb 0d                	jmp    801050c0 <argfd.constprop.0>
801050b3:	90                   	nop
801050b4:	90                   	nop
801050b5:	90                   	nop
801050b6:	90                   	nop
801050b7:	90                   	nop
801050b8:	90                   	nop
801050b9:	90                   	nop
801050ba:	90                   	nop
801050bb:	90                   	nop
801050bc:	90                   	nop
801050bd:	90                   	nop
801050be:	90                   	nop
801050bf:	90                   	nop

801050c0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
801050c5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801050c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050ca:	89 d6                	mov    %edx,%esi
801050cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cf:	50                   	push   %eax
801050d0:	6a 00                	push   $0x0
801050d2:	e8 f9 fc ff ff       	call   80104dd0 <argint>
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	85 c0                	test   %eax,%eax
801050dc:	78 2a                	js     80105108 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050e2:	77 24                	ja     80105108 <argfd.constprop.0+0x48>
801050e4:	e8 67 e7 ff ff       	call   80103850 <myproc>
801050e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050ec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050f0:	85 c0                	test   %eax,%eax
801050f2:	74 14                	je     80105108 <argfd.constprop.0+0x48>
  if(pfd)
801050f4:	85 db                	test   %ebx,%ebx
801050f6:	74 02                	je     801050fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801050f8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801050fa:	89 06                	mov    %eax,(%esi)
  return 0;
801050fc:	31 c0                	xor    %eax,%eax
}
801050fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105101:	5b                   	pop    %ebx
80105102:	5e                   	pop    %esi
80105103:	5d                   	pop    %ebp
80105104:	c3                   	ret    
80105105:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510d:	eb ef                	jmp    801050fe <argfd.constprop.0+0x3e>
8010510f:	90                   	nop

80105110 <sys_dup>:
{
80105110:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105111:	31 c0                	xor    %eax,%eax
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	56                   	push   %esi
80105116:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105117:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010511a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010511d:	e8 9e ff ff ff       	call   801050c0 <argfd.constprop.0>
80105122:	85 c0                	test   %eax,%eax
80105124:	78 42                	js     80105168 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105126:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105129:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010512b:	e8 20 e7 ff ff       	call   80103850 <myproc>
80105130:	eb 0e                	jmp    80105140 <sys_dup+0x30>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105138:	83 c3 01             	add    $0x1,%ebx
8010513b:	83 fb 10             	cmp    $0x10,%ebx
8010513e:	74 28                	je     80105168 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105140:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105144:	85 d2                	test   %edx,%edx
80105146:	75 f0                	jne    80105138 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105148:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010514c:	83 ec 0c             	sub    $0xc,%esp
8010514f:	ff 75 f4             	pushl  -0xc(%ebp)
80105152:	e8 99 bc ff ff       	call   80100df0 <filedup>
  return fd;
80105157:	83 c4 10             	add    $0x10,%esp
}
8010515a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010515d:	89 d8                	mov    %ebx,%eax
8010515f:	5b                   	pop    %ebx
80105160:	5e                   	pop    %esi
80105161:	5d                   	pop    %ebp
80105162:	c3                   	ret    
80105163:	90                   	nop
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105168:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010516b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105170:	89 d8                	mov    %ebx,%eax
80105172:	5b                   	pop    %ebx
80105173:	5e                   	pop    %esi
80105174:	5d                   	pop    %ebp
80105175:	c3                   	ret    
80105176:	8d 76 00             	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_read>:
{
80105180:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105181:	31 c0                	xor    %eax,%eax
{
80105183:	89 e5                	mov    %esp,%ebp
80105185:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105188:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010518b:	e8 30 ff ff ff       	call   801050c0 <argfd.constprop.0>
80105190:	85 c0                	test   %eax,%eax
80105192:	78 4c                	js     801051e0 <sys_read+0x60>
80105194:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105197:	83 ec 08             	sub    $0x8,%esp
8010519a:	50                   	push   %eax
8010519b:	6a 02                	push   $0x2
8010519d:	e8 2e fc ff ff       	call   80104dd0 <argint>
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	85 c0                	test   %eax,%eax
801051a7:	78 37                	js     801051e0 <sys_read+0x60>
801051a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ac:	83 ec 04             	sub    $0x4,%esp
801051af:	ff 75 f0             	pushl  -0x10(%ebp)
801051b2:	50                   	push   %eax
801051b3:	6a 01                	push   $0x1
801051b5:	e8 66 fc ff ff       	call   80104e20 <argptr>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	78 1f                	js     801051e0 <sys_read+0x60>
  return fileread(f, p, n);
801051c1:	83 ec 04             	sub    $0x4,%esp
801051c4:	ff 75 f0             	pushl  -0x10(%ebp)
801051c7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ca:	ff 75 ec             	pushl  -0x14(%ebp)
801051cd:	e8 8e bd ff ff       	call   80100f60 <fileread>
801051d2:	83 c4 10             	add    $0x10,%esp
}
801051d5:	c9                   	leave  
801051d6:	c3                   	ret    
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <sys_write>:
{
801051f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051f1:	31 c0                	xor    %eax,%eax
{
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051fb:	e8 c0 fe ff ff       	call   801050c0 <argfd.constprop.0>
80105200:	85 c0                	test   %eax,%eax
80105202:	78 4c                	js     80105250 <sys_write+0x60>
80105204:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105207:	83 ec 08             	sub    $0x8,%esp
8010520a:	50                   	push   %eax
8010520b:	6a 02                	push   $0x2
8010520d:	e8 be fb ff ff       	call   80104dd0 <argint>
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	85 c0                	test   %eax,%eax
80105217:	78 37                	js     80105250 <sys_write+0x60>
80105219:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521c:	83 ec 04             	sub    $0x4,%esp
8010521f:	ff 75 f0             	pushl  -0x10(%ebp)
80105222:	50                   	push   %eax
80105223:	6a 01                	push   $0x1
80105225:	e8 f6 fb ff ff       	call   80104e20 <argptr>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 c0                	test   %eax,%eax
8010522f:	78 1f                	js     80105250 <sys_write+0x60>
  return filewrite(f, p, n);
80105231:	83 ec 04             	sub    $0x4,%esp
80105234:	ff 75 f0             	pushl  -0x10(%ebp)
80105237:	ff 75 f4             	pushl  -0xc(%ebp)
8010523a:	ff 75 ec             	pushl  -0x14(%ebp)
8010523d:	e8 ae bd ff ff       	call   80100ff0 <filewrite>
80105242:	83 c4 10             	add    $0x10,%esp
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_close>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105266:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105269:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010526c:	e8 4f fe ff ff       	call   801050c0 <argfd.constprop.0>
80105271:	85 c0                	test   %eax,%eax
80105273:	78 2b                	js     801052a0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105275:	e8 d6 e5 ff ff       	call   80103850 <myproc>
8010527a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010527d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105280:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105287:	00 
  fileclose(f);
80105288:	ff 75 f4             	pushl  -0xc(%ebp)
8010528b:	e8 b0 bb ff ff       	call   80100e40 <fileclose>
  return 0;
80105290:	83 c4 10             	add    $0x10,%esp
80105293:	31 c0                	xor    %eax,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_fstat>:
{
801052b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052b1:	31 c0                	xor    %eax,%eax
{
801052b3:	89 e5                	mov    %esp,%ebp
801052b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052b8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052bb:	e8 00 fe ff ff       	call   801050c0 <argfd.constprop.0>
801052c0:	85 c0                	test   %eax,%eax
801052c2:	78 2c                	js     801052f0 <sys_fstat+0x40>
801052c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c7:	83 ec 04             	sub    $0x4,%esp
801052ca:	6a 14                	push   $0x14
801052cc:	50                   	push   %eax
801052cd:	6a 01                	push   $0x1
801052cf:	e8 4c fb ff ff       	call   80104e20 <argptr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	78 15                	js     801052f0 <sys_fstat+0x40>
  return filestat(f, st);
801052db:	83 ec 08             	sub    $0x8,%esp
801052de:	ff 75 f4             	pushl  -0xc(%ebp)
801052e1:	ff 75 f0             	pushl  -0x10(%ebp)
801052e4:	e8 27 bc ff ff       	call   80100f10 <filestat>
801052e9:	83 c4 10             	add    $0x10,%esp
}
801052ec:	c9                   	leave  
801052ed:	c3                   	ret    
801052ee:	66 90                	xchg   %ax,%ax
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_link>:
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
80105305:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105306:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105309:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010530c:	50                   	push   %eax
8010530d:	6a 00                	push   $0x0
8010530f:	e8 6c fb ff ff       	call   80104e80 <argstr>
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
80105319:	0f 88 fb 00 00 00    	js     8010541a <sys_link+0x11a>
8010531f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105322:	83 ec 08             	sub    $0x8,%esp
80105325:	50                   	push   %eax
80105326:	6a 01                	push   $0x1
80105328:	e8 53 fb ff ff       	call   80104e80 <argstr>
8010532d:	83 c4 10             	add    $0x10,%esp
80105330:	85 c0                	test   %eax,%eax
80105332:	0f 88 e2 00 00 00    	js     8010541a <sys_link+0x11a>
  begin_op();
80105338:	e8 93 d8 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
8010533d:	83 ec 0c             	sub    $0xc,%esp
80105340:	ff 75 d4             	pushl  -0x2c(%ebp)
80105343:	e8 a8 cb ff ff       	call   80101ef0 <namei>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	89 c3                	mov    %eax,%ebx
8010534f:	0f 84 ea 00 00 00    	je     8010543f <sys_link+0x13f>
  ilock(ip);
80105355:	83 ec 0c             	sub    $0xc,%esp
80105358:	50                   	push   %eax
80105359:	e8 32 c3 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105366:	0f 84 bb 00 00 00    	je     80105427 <sys_link+0x127>
  ip->nlink++;
8010536c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105371:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105374:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105377:	53                   	push   %ebx
80105378:	e8 63 c2 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010537d:	89 1c 24             	mov    %ebx,(%esp)
80105380:	e8 eb c3 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105385:	58                   	pop    %eax
80105386:	5a                   	pop    %edx
80105387:	57                   	push   %edi
80105388:	ff 75 d0             	pushl  -0x30(%ebp)
8010538b:	e8 80 cb ff ff       	call   80101f10 <nameiparent>
80105390:	83 c4 10             	add    $0x10,%esp
80105393:	85 c0                	test   %eax,%eax
80105395:	89 c6                	mov    %eax,%esi
80105397:	74 5b                	je     801053f4 <sys_link+0xf4>
  ilock(dp);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	50                   	push   %eax
8010539d:	e8 ee c2 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	8b 03                	mov    (%ebx),%eax
801053a7:	39 06                	cmp    %eax,(%esi)
801053a9:	75 3d                	jne    801053e8 <sys_link+0xe8>
801053ab:	83 ec 04             	sub    $0x4,%esp
801053ae:	ff 73 04             	pushl  0x4(%ebx)
801053b1:	57                   	push   %edi
801053b2:	56                   	push   %esi
801053b3:	e8 78 ca ff ff       	call   80101e30 <dirlink>
801053b8:	83 c4 10             	add    $0x10,%esp
801053bb:	85 c0                	test   %eax,%eax
801053bd:	78 29                	js     801053e8 <sys_link+0xe8>
  iunlockput(dp);
801053bf:	83 ec 0c             	sub    $0xc,%esp
801053c2:	56                   	push   %esi
801053c3:	e8 58 c5 ff ff       	call   80101920 <iunlockput>
  iput(ip);
801053c8:	89 1c 24             	mov    %ebx,(%esp)
801053cb:	e8 f0 c3 ff ff       	call   801017c0 <iput>
  end_op();
801053d0:	e8 6b d8 ff ff       	call   80102c40 <end_op>
  return 0;
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	31 c0                	xor    %eax,%eax
}
801053da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053dd:	5b                   	pop    %ebx
801053de:	5e                   	pop    %esi
801053df:	5f                   	pop    %edi
801053e0:	5d                   	pop    %ebp
801053e1:	c3                   	ret    
801053e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	56                   	push   %esi
801053ec:	e8 2f c5 ff ff       	call   80101920 <iunlockput>
    goto bad;
801053f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	53                   	push   %ebx
801053f8:	e8 93 c2 ff ff       	call   80101690 <ilock>
  ip->nlink--;
801053fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105402:	89 1c 24             	mov    %ebx,(%esp)
80105405:	e8 d6 c1 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010540a:	89 1c 24             	mov    %ebx,(%esp)
8010540d:	e8 0e c5 ff ff       	call   80101920 <iunlockput>
  end_op();
80105412:	e8 29 d8 ff ff       	call   80102c40 <end_op>
  return -1;
80105417:	83 c4 10             	add    $0x10,%esp
}
8010541a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010541d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105422:	5b                   	pop    %ebx
80105423:	5e                   	pop    %esi
80105424:	5f                   	pop    %edi
80105425:	5d                   	pop    %ebp
80105426:	c3                   	ret    
    iunlockput(ip);
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	53                   	push   %ebx
8010542b:	e8 f0 c4 ff ff       	call   80101920 <iunlockput>
    end_op();
80105430:	e8 0b d8 ff ff       	call   80102c40 <end_op>
    return -1;
80105435:	83 c4 10             	add    $0x10,%esp
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	eb 9b                	jmp    801053da <sys_link+0xda>
    end_op();
8010543f:	e8 fc d7 ff ff       	call   80102c40 <end_op>
    return -1;
80105444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105449:	eb 8f                	jmp    801053da <sys_link+0xda>
8010544b:	90                   	nop
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_unlink>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105456:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105459:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 1c fa ff ff       	call   80104e80 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 77 01 00 00    	js     801055e6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010546f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105472:	e8 59 d7 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105477:	83 ec 08             	sub    $0x8,%esp
8010547a:	53                   	push   %ebx
8010547b:	ff 75 c0             	pushl  -0x40(%ebp)
8010547e:	e8 8d ca ff ff       	call   80101f10 <nameiparent>
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	89 c6                	mov    %eax,%esi
8010548a:	0f 84 60 01 00 00    	je     801055f0 <sys_unlink+0x1a0>
  ilock(dp);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	50                   	push   %eax
80105494:	e8 f7 c1 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105499:	58                   	pop    %eax
8010549a:	5a                   	pop    %edx
8010549b:	68 d2 7b 10 80       	push   $0x80107bd2
801054a0:	53                   	push   %ebx
801054a1:	e8 fa c6 ff ff       	call   80101ba0 <namecmp>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	0f 84 03 01 00 00    	je     801055b4 <sys_unlink+0x164>
801054b1:	83 ec 08             	sub    $0x8,%esp
801054b4:	68 d1 7b 10 80       	push   $0x80107bd1
801054b9:	53                   	push   %ebx
801054ba:	e8 e1 c6 ff ff       	call   80101ba0 <namecmp>
801054bf:	83 c4 10             	add    $0x10,%esp
801054c2:	85 c0                	test   %eax,%eax
801054c4:	0f 84 ea 00 00 00    	je     801055b4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054ca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054cd:	83 ec 04             	sub    $0x4,%esp
801054d0:	50                   	push   %eax
801054d1:	53                   	push   %ebx
801054d2:	56                   	push   %esi
801054d3:	e8 e8 c6 ff ff       	call   80101bc0 <dirlookup>
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	85 c0                	test   %eax,%eax
801054dd:	89 c3                	mov    %eax,%ebx
801054df:	0f 84 cf 00 00 00    	je     801055b4 <sys_unlink+0x164>
  ilock(ip);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	50                   	push   %eax
801054e9:	e8 a2 c1 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054f6:	0f 8e 10 01 00 00    	jle    8010560c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105501:	74 6d                	je     80105570 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105503:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105506:	83 ec 04             	sub    $0x4,%esp
80105509:	6a 10                	push   $0x10
8010550b:	6a 00                	push   $0x0
8010550d:	50                   	push   %eax
8010550e:	e8 bd f5 ff ff       	call   80104ad0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105513:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105516:	6a 10                	push   $0x10
80105518:	ff 75 c4             	pushl  -0x3c(%ebp)
8010551b:	50                   	push   %eax
8010551c:	56                   	push   %esi
8010551d:	e8 4e c5 ff ff       	call   80101a70 <writei>
80105522:	83 c4 20             	add    $0x20,%esp
80105525:	83 f8 10             	cmp    $0x10,%eax
80105528:	0f 85 eb 00 00 00    	jne    80105619 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010552e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105533:	0f 84 97 00 00 00    	je     801055d0 <sys_unlink+0x180>
  iunlockput(dp);
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	56                   	push   %esi
8010553d:	e8 de c3 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105542:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105547:	89 1c 24             	mov    %ebx,(%esp)
8010554a:	e8 91 c0 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010554f:	89 1c 24             	mov    %ebx,(%esp)
80105552:	e8 c9 c3 ff ff       	call   80101920 <iunlockput>
  end_op();
80105557:	e8 e4 d6 ff ff       	call   80102c40 <end_op>
  return 0;
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	31 c0                	xor    %eax,%eax
}
80105561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105564:	5b                   	pop    %ebx
80105565:	5e                   	pop    %esi
80105566:	5f                   	pop    %edi
80105567:	5d                   	pop    %ebp
80105568:	c3                   	ret    
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105570:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105574:	76 8d                	jbe    80105503 <sys_unlink+0xb3>
80105576:	bf 20 00 00 00       	mov    $0x20,%edi
8010557b:	eb 0f                	jmp    8010558c <sys_unlink+0x13c>
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
80105580:	83 c7 10             	add    $0x10,%edi
80105583:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105586:	0f 83 77 ff ff ff    	jae    80105503 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010558c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010558f:	6a 10                	push   $0x10
80105591:	57                   	push   %edi
80105592:	50                   	push   %eax
80105593:	53                   	push   %ebx
80105594:	e8 d7 c3 ff ff       	call   80101970 <readi>
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	83 f8 10             	cmp    $0x10,%eax
8010559f:	75 5e                	jne    801055ff <sys_unlink+0x1af>
    if(de.inum != 0)
801055a1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055a6:	74 d8                	je     80105580 <sys_unlink+0x130>
    iunlockput(ip);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	53                   	push   %ebx
801055ac:	e8 6f c3 ff ff       	call   80101920 <iunlockput>
    goto bad;
801055b1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	56                   	push   %esi
801055b8:	e8 63 c3 ff ff       	call   80101920 <iunlockput>
  end_op();
801055bd:	e8 7e d6 ff ff       	call   80102c40 <end_op>
  return -1;
801055c2:	83 c4 10             	add    $0x10,%esp
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ca:	eb 95                	jmp    80105561 <sys_unlink+0x111>
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801055d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	56                   	push   %esi
801055d9:	e8 02 c0 ff ff       	call   801015e0 <iupdate>
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	e9 53 ff ff ff       	jmp    80105539 <sys_unlink+0xe9>
    return -1;
801055e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055eb:	e9 71 ff ff ff       	jmp    80105561 <sys_unlink+0x111>
    end_op();
801055f0:	e8 4b d6 ff ff       	call   80102c40 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fa:	e9 62 ff ff ff       	jmp    80105561 <sys_unlink+0x111>
      panic("isdirempty: readi");
801055ff:	83 ec 0c             	sub    $0xc,%esp
80105602:	68 dd 7d 10 80       	push   $0x80107ddd
80105607:	e8 84 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	68 cb 7d 10 80       	push   $0x80107dcb
80105614:	e8 77 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	68 ef 7d 10 80       	push   $0x80107def
80105621:	e8 6a ad ff ff       	call   80100390 <panic>
80105626:	8d 76 00             	lea    0x0(%esi),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_open>:

int
sys_open(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
80105635:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105636:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105639:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010563c:	50                   	push   %eax
8010563d:	6a 00                	push   $0x0
8010563f:	e8 3c f8 ff ff       	call   80104e80 <argstr>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
80105649:	0f 88 1d 01 00 00    	js     8010576c <sys_open+0x13c>
8010564f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105652:	83 ec 08             	sub    $0x8,%esp
80105655:	50                   	push   %eax
80105656:	6a 01                	push   $0x1
80105658:	e8 73 f7 ff ff       	call   80104dd0 <argint>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	0f 88 04 01 00 00    	js     8010576c <sys_open+0x13c>
    return -1;

  begin_op();
80105668:	e8 63 d5 ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
8010566d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105671:	0f 85 a9 00 00 00    	jne    80105720 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105677:	83 ec 0c             	sub    $0xc,%esp
8010567a:	ff 75 e0             	pushl  -0x20(%ebp)
8010567d:	e8 6e c8 ff ff       	call   80101ef0 <namei>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	89 c6                	mov    %eax,%esi
80105689:	0f 84 b2 00 00 00    	je     80105741 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	50                   	push   %eax
80105693:	e8 f8 bf ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056a0:	0f 84 aa 00 00 00    	je     80105750 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056a6:	e8 d5 b6 ff ff       	call   80100d80 <filealloc>
801056ab:	85 c0                	test   %eax,%eax
801056ad:	89 c7                	mov    %eax,%edi
801056af:	0f 84 a6 00 00 00    	je     8010575b <sys_open+0x12b>
  struct proc *curproc = myproc();
801056b5:	e8 96 e1 ff ff       	call   80103850 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ba:	31 db                	xor    %ebx,%ebx
801056bc:	eb 0e                	jmp    801056cc <sys_open+0x9c>
801056be:	66 90                	xchg   %ax,%ax
801056c0:	83 c3 01             	add    $0x1,%ebx
801056c3:	83 fb 10             	cmp    $0x10,%ebx
801056c6:	0f 84 ac 00 00 00    	je     80105778 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801056cc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056d0:	85 d2                	test   %edx,%edx
801056d2:	75 ec                	jne    801056c0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056d4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056d7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801056db:	56                   	push   %esi
801056dc:	e8 8f c0 ff ff       	call   80101770 <iunlock>
  end_op();
801056e1:	e8 5a d5 ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
801056e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056ef:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056f2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056f5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056fc:	89 d0                	mov    %edx,%eax
801056fe:	f7 d0                	not    %eax
80105700:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105703:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105706:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105709:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010570d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105710:	89 d8                	mov    %ebx,%eax
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5f                   	pop    %edi
80105715:	5d                   	pop    %ebp
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105726:	31 c9                	xor    %ecx,%ecx
80105728:	6a 00                	push   $0x0
8010572a:	ba 02 00 00 00       	mov    $0x2,%edx
8010572f:	e8 ec f7 ff ff       	call   80104f20 <create>
    if(ip == 0){
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105739:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010573b:	0f 85 65 ff ff ff    	jne    801056a6 <sys_open+0x76>
      end_op();
80105741:	e8 fa d4 ff ff       	call   80102c40 <end_op>
      return -1;
80105746:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010574b:	eb c0                	jmp    8010570d <sys_open+0xdd>
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105750:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105753:	85 c9                	test   %ecx,%ecx
80105755:	0f 84 4b ff ff ff    	je     801056a6 <sys_open+0x76>
    iunlockput(ip);
8010575b:	83 ec 0c             	sub    $0xc,%esp
8010575e:	56                   	push   %esi
8010575f:	e8 bc c1 ff ff       	call   80101920 <iunlockput>
    end_op();
80105764:	e8 d7 d4 ff ff       	call   80102c40 <end_op>
    return -1;
80105769:	83 c4 10             	add    $0x10,%esp
8010576c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105771:	eb 9a                	jmp    8010570d <sys_open+0xdd>
80105773:	90                   	nop
80105774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105778:	83 ec 0c             	sub    $0xc,%esp
8010577b:	57                   	push   %edi
8010577c:	e8 bf b6 ff ff       	call   80100e40 <fileclose>
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	eb d5                	jmp    8010575b <sys_open+0x12b>
80105786:	8d 76 00             	lea    0x0(%esi),%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_mkdir>:

int
sys_mkdir(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105796:	e8 35 d4 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010579b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 d7 f6 ff ff       	call   80104e80 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 30                	js     801057e0 <sys_mkdir+0x50>
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	6a 00                	push   $0x0
801057ba:	ba 01 00 00 00       	mov    $0x1,%edx
801057bf:	e8 5c f7 ff ff       	call   80104f20 <create>
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
801057c9:	74 15                	je     801057e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057cb:	83 ec 0c             	sub    $0xc,%esp
801057ce:	50                   	push   %eax
801057cf:	e8 4c c1 ff ff       	call   80101920 <iunlockput>
  end_op();
801057d4:	e8 67 d4 ff ff       	call   80102c40 <end_op>
  return 0;
801057d9:	83 c4 10             	add    $0x10,%esp
801057dc:	31 c0                	xor    %eax,%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    
    end_op();
801057e0:	e8 5b d4 ff ff       	call   80102c40 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_mknod>:

int
sys_mknod(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057f6:	e8 d5 d3 ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fe:	83 ec 08             	sub    $0x8,%esp
80105801:	50                   	push   %eax
80105802:	6a 00                	push   $0x0
80105804:	e8 77 f6 ff ff       	call   80104e80 <argstr>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	85 c0                	test   %eax,%eax
8010580e:	78 60                	js     80105870 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105810:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105813:	83 ec 08             	sub    $0x8,%esp
80105816:	50                   	push   %eax
80105817:	6a 01                	push   $0x1
80105819:	e8 b2 f5 ff ff       	call   80104dd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	85 c0                	test   %eax,%eax
80105823:	78 4b                	js     80105870 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105825:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105828:	83 ec 08             	sub    $0x8,%esp
8010582b:	50                   	push   %eax
8010582c:	6a 02                	push   $0x2
8010582e:	e8 9d f5 ff ff       	call   80104dd0 <argint>
     argint(1, &major) < 0 ||
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	78 36                	js     80105870 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010583a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010583e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105841:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105845:	ba 03 00 00 00       	mov    $0x3,%edx
8010584a:	50                   	push   %eax
8010584b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010584e:	e8 cd f6 ff ff       	call   80104f20 <create>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	74 16                	je     80105870 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	50                   	push   %eax
8010585e:	e8 bd c0 ff ff       	call   80101920 <iunlockput>
  end_op();
80105863:	e8 d8 d3 ff ff       	call   80102c40 <end_op>
  return 0;
80105868:	83 c4 10             	add    $0x10,%esp
8010586b:	31 c0                	xor    %eax,%eax
}
8010586d:	c9                   	leave  
8010586e:	c3                   	ret    
8010586f:	90                   	nop
    end_op();
80105870:	e8 cb d3 ff ff       	call   80102c40 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_chdir>:

int
sys_chdir(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	53                   	push   %ebx
80105885:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105888:	e8 c3 df ff ff       	call   80103850 <myproc>
8010588d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010588f:	e8 3c d3 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105894:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105897:	83 ec 08             	sub    $0x8,%esp
8010589a:	50                   	push   %eax
8010589b:	6a 00                	push   $0x0
8010589d:	e8 de f5 ff ff       	call   80104e80 <argstr>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 77                	js     80105920 <sys_chdir+0xa0>
801058a9:	83 ec 0c             	sub    $0xc,%esp
801058ac:	ff 75 f4             	pushl  -0xc(%ebp)
801058af:	e8 3c c6 ff ff       	call   80101ef0 <namei>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	89 c3                	mov    %eax,%ebx
801058bb:	74 63                	je     80105920 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	50                   	push   %eax
801058c1:	e8 ca bd ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ce:	75 30                	jne    80105900 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	53                   	push   %ebx
801058d4:	e8 97 be ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
801058d9:	58                   	pop    %eax
801058da:	ff 76 68             	pushl  0x68(%esi)
801058dd:	e8 de be ff ff       	call   801017c0 <iput>
  end_op();
801058e2:	e8 59 d3 ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
801058e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	31 c0                	xor    %eax,%eax
}
801058ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5d                   	pop    %ebp
801058f5:	c3                   	ret    
801058f6:	8d 76 00             	lea    0x0(%esi),%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	53                   	push   %ebx
80105904:	e8 17 c0 ff ff       	call   80101920 <iunlockput>
    end_op();
80105909:	e8 32 d3 ff ff       	call   80102c40 <end_op>
    return -1;
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb d7                	jmp    801058ef <sys_chdir+0x6f>
80105918:	90                   	nop
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105920:	e8 1b d3 ff ff       	call   80102c40 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592a:	eb c3                	jmp    801058ef <sys_chdir+0x6f>
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_exec>:

int
sys_exec(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
80105935:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105936:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010593c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105942:	50                   	push   %eax
80105943:	6a 00                	push   $0x0
80105945:	e8 36 f5 ff ff       	call   80104e80 <argstr>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	0f 88 87 00 00 00    	js     801059dc <sys_exec+0xac>
80105955:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010595b:	83 ec 08             	sub    $0x8,%esp
8010595e:	50                   	push   %eax
8010595f:	6a 01                	push   $0x1
80105961:	e8 6a f4 ff ff       	call   80104dd0 <argint>
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	85 c0                	test   %eax,%eax
8010596b:	78 6f                	js     801059dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010596d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105973:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105976:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105978:	68 80 00 00 00       	push   $0x80
8010597d:	6a 00                	push   $0x0
8010597f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105985:	50                   	push   %eax
80105986:	e8 45 f1 ff ff       	call   80104ad0 <memset>
8010598b:	83 c4 10             	add    $0x10,%esp
8010598e:	eb 2c                	jmp    801059bc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105990:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105996:	85 c0                	test   %eax,%eax
80105998:	74 56                	je     801059f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010599a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801059a6:	52                   	push   %edx
801059a7:	50                   	push   %eax
801059a8:	e8 b3 f3 ff ff       	call   80104d60 <fetchstr>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	85 c0                	test   %eax,%eax
801059b2:	78 28                	js     801059dc <sys_exec+0xac>
  for(i=0;; i++){
801059b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059b7:	83 fb 20             	cmp    $0x20,%ebx
801059ba:	74 20                	je     801059dc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059bc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059c2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801059c9:	83 ec 08             	sub    $0x8,%esp
801059cc:	57                   	push   %edi
801059cd:	01 f0                	add    %esi,%eax
801059cf:	50                   	push   %eax
801059d0:	e8 4b f3 ff ff       	call   80104d20 <fetchint>
801059d5:	83 c4 10             	add    $0x10,%esp
801059d8:	85 c0                	test   %eax,%eax
801059da:	79 b4                	jns    80105990 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
801059e8:	c3                   	ret    
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801059f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059f6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801059f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a00:	00 00 00 00 
  return exec(path, argv);
80105a04:	50                   	push   %eax
80105a05:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a0b:	e8 00 b0 ff ff       	call   80100a10 <exec>
80105a10:	83 c4 10             	add    $0x10,%esp
}
80105a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a16:	5b                   	pop    %ebx
80105a17:	5e                   	pop    %esi
80105a18:	5f                   	pop    %edi
80105a19:	5d                   	pop    %ebp
80105a1a:	c3                   	ret    
80105a1b:	90                   	nop
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_pipe>:

int
sys_pipe(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
80105a25:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a26:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a29:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a2c:	6a 08                	push   $0x8
80105a2e:	50                   	push   %eax
80105a2f:	6a 00                	push   $0x0
80105a31:	e8 ea f3 ff ff       	call   80104e20 <argptr>
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	0f 88 ae 00 00 00    	js     80105aef <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a41:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a44:	83 ec 08             	sub    $0x8,%esp
80105a47:	50                   	push   %eax
80105a48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a4b:	50                   	push   %eax
80105a4c:	e8 5f d8 ff ff       	call   801032b0 <pipealloc>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	0f 88 93 00 00 00    	js     80105aef <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a5c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a5f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a61:	e8 ea dd ff ff       	call   80103850 <myproc>
80105a66:	eb 10                	jmp    80105a78 <sys_pipe+0x58>
80105a68:	90                   	nop
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a70:	83 c3 01             	add    $0x1,%ebx
80105a73:	83 fb 10             	cmp    $0x10,%ebx
80105a76:	74 60                	je     80105ad8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a78:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a7c:	85 f6                	test   %esi,%esi
80105a7e:	75 f0                	jne    80105a70 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a80:	8d 73 08             	lea    0x8(%ebx),%esi
80105a83:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a8a:	e8 c1 dd ff ff       	call   80103850 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a8f:	31 d2                	xor    %edx,%edx
80105a91:	eb 0d                	jmp    80105aa0 <sys_pipe+0x80>
80105a93:	90                   	nop
80105a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a98:	83 c2 01             	add    $0x1,%edx
80105a9b:	83 fa 10             	cmp    $0x10,%edx
80105a9e:	74 28                	je     80105ac8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105aa0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105aa4:	85 c9                	test   %ecx,%ecx
80105aa6:	75 f0                	jne    80105a98 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105aa8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105aaf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ab4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ab7:	31 c0                	xor    %eax,%eax
}
80105ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105abc:	5b                   	pop    %ebx
80105abd:	5e                   	pop    %esi
80105abe:	5f                   	pop    %edi
80105abf:	5d                   	pop    %ebp
80105ac0:	c3                   	ret    
80105ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105ac8:	e8 83 dd ff ff       	call   80103850 <myproc>
80105acd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ad4:	00 
80105ad5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	ff 75 e0             	pushl  -0x20(%ebp)
80105ade:	e8 5d b3 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105ae3:	58                   	pop    %eax
80105ae4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ae7:	e8 54 b3 ff ff       	call   80100e40 <fileclose>
    return -1;
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af4:	eb c3                	jmp    80105ab9 <sys_pipe+0x99>
80105af6:	66 90                	xchg   %ax,%ax
80105af8:	66 90                	xchg   %ax,%ax
80105afa:	66 90                	xchg   %ax,%ax
80105afc:	66 90                	xchg   %ax,%ax
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b03:	5d                   	pop    %ebp
  return fork();
80105b04:	e9 47 e0 ff ff       	jmp    80103b50 <fork>
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_exit>:

int
sys_exit(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b16:	e8 85 e1 ff ff       	call   80103ca0 <exit>
  return 0;  // not reached
}
80105b1b:	31 c0                	xor    %eax,%eax
80105b1d:	c9                   	leave  
80105b1e:	c3                   	ret    
80105b1f:	90                   	nop

80105b20 <sys_wait>:

int
sys_wait(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b23:	5d                   	pop    %ebp
  return wait();
80105b24:	e9 b7 e3 ff ff       	jmp    80103ee0 <wait>
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_kill>:

int
sys_kill(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b39:	50                   	push   %eax
80105b3a:	6a 00                	push   $0x0
80105b3c:	e8 8f f2 ff ff       	call   80104dd0 <argint>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	78 18                	js     80105b60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4e:	e8 dd e4 ff ff       	call   80104030 <kill>
80105b53:	83 c4 10             	add    $0x10,%esp
}
80105b56:	c9                   	leave  
80105b57:	c3                   	ret    
80105b58:	90                   	nop
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    
80105b67:	89 f6                	mov    %esi,%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_getpid>:

int
sys_getpid(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b76:	e8 d5 dc ff ff       	call   80103850 <myproc>
80105b7b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b7e:	c9                   	leave  
80105b7f:	c3                   	ret    

80105b80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b8a:	50                   	push   %eax
80105b8b:	6a 00                	push   $0x0
80105b8d:	e8 3e f2 ff ff       	call   80104dd0 <argint>
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	85 c0                	test   %eax,%eax
80105b97:	78 27                	js     80105bc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b99:	e8 b2 dc ff ff       	call   80103850 <myproc>
  if(growproc(n) < 0)
80105b9e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ba1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ba3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ba6:	e8 c5 dd ff ff       	call   80103970 <growproc>
80105bab:	83 c4 10             	add    $0x10,%esp
80105bae:	85 c0                	test   %eax,%eax
80105bb0:	78 0e                	js     80105bc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bb2:	89 d8                	mov    %ebx,%eax
80105bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb7:	c9                   	leave  
80105bb8:	c3                   	ret    
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bc5:	eb eb                	jmp    80105bb2 <sys_sbrk+0x32>
80105bc7:	89 f6                	mov    %esi,%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bd0 <sys_sleep>:

int
sys_sleep(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bda:	50                   	push   %eax
80105bdb:	6a 00                	push   $0x0
80105bdd:	e8 ee f1 ff ff       	call   80104dd0 <argint>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	0f 88 8a 00 00 00    	js     80105c77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	68 80 60 11 80       	push   $0x80116080
80105bf5:	e8 56 ed ff ff       	call   80104950 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bfd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105c00:	8b 1d c0 68 11 80    	mov    0x801168c0,%ebx
  while(ticks - ticks0 < n){
80105c06:	85 d2                	test   %edx,%edx
80105c08:	75 27                	jne    80105c31 <sys_sleep+0x61>
80105c0a:	eb 54                	jmp    80105c60 <sys_sleep+0x90>
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c10:	83 ec 08             	sub    $0x8,%esp
80105c13:	68 80 60 11 80       	push   $0x80116080
80105c18:	68 c0 68 11 80       	push   $0x801168c0
80105c1d:	e8 fe e1 ff ff       	call   80103e20 <sleep>
  while(ticks - ticks0 < n){
80105c22:	a1 c0 68 11 80       	mov    0x801168c0,%eax
80105c27:	83 c4 10             	add    $0x10,%esp
80105c2a:	29 d8                	sub    %ebx,%eax
80105c2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c2f:	73 2f                	jae    80105c60 <sys_sleep+0x90>
    if(myproc()->killed){
80105c31:	e8 1a dc ff ff       	call   80103850 <myproc>
80105c36:	8b 40 24             	mov    0x24(%eax),%eax
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	74 d3                	je     80105c10 <sys_sleep+0x40>
      release(&tickslock);
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	68 80 60 11 80       	push   $0x80116080
80105c45:	e8 26 ee ff ff       	call   80104a70 <release>
      return -1;
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	68 80 60 11 80       	push   $0x80116080
80105c68:	e8 03 ee ff ff       	call   80104a70 <release>
  return 0;
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	31 c0                	xor    %eax,%eax
}
80105c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
    return -1;
80105c77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7c:	eb f4                	jmp    80105c72 <sys_sleep+0xa2>
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
80105c84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c87:	68 80 60 11 80       	push   $0x80116080
80105c8c:	e8 bf ec ff ff       	call   80104950 <acquire>
  xticks = ticks;
80105c91:	8b 1d c0 68 11 80    	mov    0x801168c0,%ebx
  release(&tickslock);
80105c97:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80105c9e:	e8 cd ed ff ff       	call   80104a70 <release>
  return xticks;
}
80105ca3:	89 d8                	mov    %ebx,%eax
80105ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca8:	c9                   	leave  
80105ca9:	c3                   	ret    
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <sys_shutdown>:

int
sys_shutdown(void){
80105cb0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cb1:	b8 00 20 00 00       	mov    $0x2000,%eax
80105cb6:	ba 04 06 00 00       	mov    $0x604,%edx
80105cbb:	89 e5                	mov    %esp,%ebp
80105cbd:	66 ef                	out    %ax,(%dx)
  outw(0x604, 0x2000);
  return 0;
}
80105cbf:	31 c0                	xor    %eax,%eax
80105cc1:	5d                   	pop    %ebp
80105cc2:	c3                   	ret    
80105cc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_get_free_frame_cnt>:

extern int free_frame_cnt;
int
sys_get_free_frame_cnt(void){
80105cd0:	55                   	push   %ebp
  return free_frame_cnt;
80105cd1:	a1 b4 b5 10 80       	mov    0x8010b5b4,%eax
sys_get_free_frame_cnt(void){
80105cd6:	89 e5                	mov    %esp,%ebp
80105cd8:	5d                   	pop    %ebp
80105cd9:	c3                   	ret    

80105cda <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cda:	1e                   	push   %ds
  pushl %es
80105cdb:	06                   	push   %es
  pushl %fs
80105cdc:	0f a0                	push   %fs
  pushl %gs
80105cde:	0f a8                	push   %gs
  pushal
80105ce0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ce1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ce5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ce7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ce9:	54                   	push   %esp
  call trap
80105cea:	e8 c1 00 00 00       	call   80105db0 <trap>
  addl $4, %esp
80105cef:	83 c4 04             	add    $0x4,%esp

80105cf2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105cf2:	61                   	popa   
  popl %gs
80105cf3:	0f a9                	pop    %gs
  popl %fs
80105cf5:	0f a1                	pop    %fs
  popl %es
80105cf7:	07                   	pop    %es
  popl %ds
80105cf8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cf9:	83 c4 08             	add    $0x8,%esp
  iret
80105cfc:	cf                   	iret   
80105cfd:	66 90                	xchg   %ax,%ax
80105cff:	90                   	nop

80105d00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d01:	31 c0                	xor    %eax,%eax
{
80105d03:	89 e5                	mov    %esp,%ebp
80105d05:	83 ec 08             	sub    $0x8,%esp
80105d08:	90                   	nop
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d10:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d17:	c7 04 c5 c2 60 11 80 	movl   $0x8e000008,-0x7fee9f3e(,%eax,8)
80105d1e:	08 00 00 8e 
80105d22:	66 89 14 c5 c0 60 11 	mov    %dx,-0x7fee9f40(,%eax,8)
80105d29:	80 
80105d2a:	c1 ea 10             	shr    $0x10,%edx
80105d2d:	66 89 14 c5 c6 60 11 	mov    %dx,-0x7fee9f3a(,%eax,8)
80105d34:	80 
  for(i = 0; i < 256; i++)
80105d35:	83 c0 01             	add    $0x1,%eax
80105d38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d3d:	75 d1                	jne    80105d10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d3f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105d44:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d47:	c7 05 c2 62 11 80 08 	movl   $0xef000008,0x801162c2
80105d4e:	00 00 ef 
  initlock(&tickslock, "time");
80105d51:	68 fe 7d 10 80       	push   $0x80107dfe
80105d56:	68 80 60 11 80       	push   $0x80116080
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d5b:	66 a3 c0 62 11 80    	mov    %ax,0x801162c0
80105d61:	c1 e8 10             	shr    $0x10,%eax
80105d64:	66 a3 c6 62 11 80    	mov    %ax,0x801162c6
  initlock(&tickslock, "time");
80105d6a:	e8 f1 ea ff ff       	call   80104860 <initlock>
}
80105d6f:	83 c4 10             	add    $0x10,%esp
80105d72:	c9                   	leave  
80105d73:	c3                   	ret    
80105d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105d80 <idtinit>:

void
idtinit(void)
{
80105d80:	55                   	push   %ebp
  pd[0] = size-1;
80105d81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d86:	89 e5                	mov    %esp,%ebp
80105d88:	83 ec 10             	sub    $0x10,%esp
80105d8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d8f:	b8 c0 60 11 80       	mov    $0x801160c0,%eax
80105d94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d98:	c1 e8 10             	shr    $0x10,%eax
80105d9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105da2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
80105db5:	53                   	push   %ebx
80105db6:	83 ec 1c             	sub    $0x1c,%esp
80105db9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105dbc:	8b 47 30             	mov    0x30(%edi),%eax
80105dbf:	83 f8 40             	cmp    $0x40,%eax
80105dc2:	0f 84 f0 00 00 00    	je     80105eb8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105dc8:	83 e8 20             	sub    $0x20,%eax
80105dcb:	83 f8 1f             	cmp    $0x1f,%eax
80105dce:	77 10                	ja     80105de0 <trap+0x30>
80105dd0:	ff 24 85 a4 7e 10 80 	jmp    *-0x7fef815c(,%eax,4)
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105de0:	e8 6b da ff ff       	call   80103850 <myproc>
80105de5:	85 c0                	test   %eax,%eax
80105de7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105dea:	0f 84 14 02 00 00    	je     80106004 <trap+0x254>
80105df0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105df4:	0f 84 0a 02 00 00    	je     80106004 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dfa:	0f 20 d1             	mov    %cr2,%ecx
80105dfd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e00:	e8 2b da ff ff       	call   80103830 <cpuid>
80105e05:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e08:	8b 47 34             	mov    0x34(%edi),%eax
80105e0b:	8b 77 30             	mov    0x30(%edi),%esi
80105e0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e11:	e8 3a da ff ff       	call   80103850 <myproc>
80105e16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e19:	e8 32 da ff ff       	call   80103850 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e1e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e21:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e24:	51                   	push   %ecx
80105e25:	53                   	push   %ebx
80105e26:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105e27:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e2a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e2d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e2e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e31:	52                   	push   %edx
80105e32:	ff 70 10             	pushl  0x10(%eax)
80105e35:	68 60 7e 10 80       	push   $0x80107e60
80105e3a:	e8 21 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105e3f:	83 c4 20             	add    $0x20,%esp
80105e42:	e8 09 da ff ff       	call   80103850 <myproc>
80105e47:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e4e:	e8 fd d9 ff ff       	call   80103850 <myproc>
80105e53:	85 c0                	test   %eax,%eax
80105e55:	74 1d                	je     80105e74 <trap+0xc4>
80105e57:	e8 f4 d9 ff ff       	call   80103850 <myproc>
80105e5c:	8b 50 24             	mov    0x24(%eax),%edx
80105e5f:	85 d2                	test   %edx,%edx
80105e61:	74 11                	je     80105e74 <trap+0xc4>
80105e63:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e67:	83 e0 03             	and    $0x3,%eax
80105e6a:	66 83 f8 03          	cmp    $0x3,%ax
80105e6e:	0f 84 4c 01 00 00    	je     80105fc0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e74:	e8 d7 d9 ff ff       	call   80103850 <myproc>
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 0b                	je     80105e88 <trap+0xd8>
80105e7d:	e8 ce d9 ff ff       	call   80103850 <myproc>
80105e82:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e86:	74 68                	je     80105ef0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e88:	e8 c3 d9 ff ff       	call   80103850 <myproc>
80105e8d:	85 c0                	test   %eax,%eax
80105e8f:	74 19                	je     80105eaa <trap+0xfa>
80105e91:	e8 ba d9 ff ff       	call   80103850 <myproc>
80105e96:	8b 40 24             	mov    0x24(%eax),%eax
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	74 0d                	je     80105eaa <trap+0xfa>
80105e9d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ea1:	83 e0 03             	and    $0x3,%eax
80105ea4:	66 83 f8 03          	cmp    $0x3,%ax
80105ea8:	74 37                	je     80105ee1 <trap+0x131>
    exit();
}
80105eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ead:	5b                   	pop    %ebx
80105eae:	5e                   	pop    %esi
80105eaf:	5f                   	pop    %edi
80105eb0:	5d                   	pop    %ebp
80105eb1:	c3                   	ret    
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105eb8:	e8 93 d9 ff ff       	call   80103850 <myproc>
80105ebd:	8b 58 24             	mov    0x24(%eax),%ebx
80105ec0:	85 db                	test   %ebx,%ebx
80105ec2:	0f 85 e8 00 00 00    	jne    80105fb0 <trap+0x200>
    myproc()->tf = tf;
80105ec8:	e8 83 d9 ff ff       	call   80103850 <myproc>
80105ecd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ed0:	e8 eb ef ff ff       	call   80104ec0 <syscall>
    if(myproc()->killed)
80105ed5:	e8 76 d9 ff ff       	call   80103850 <myproc>
80105eda:	8b 48 24             	mov    0x24(%eax),%ecx
80105edd:	85 c9                	test   %ecx,%ecx
80105edf:	74 c9                	je     80105eaa <trap+0xfa>
}
80105ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee4:	5b                   	pop    %ebx
80105ee5:	5e                   	pop    %esi
80105ee6:	5f                   	pop    %edi
80105ee7:	5d                   	pop    %ebp
      exit();
80105ee8:	e9 b3 dd ff ff       	jmp    80103ca0 <exit>
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105ef0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105ef4:	75 92                	jne    80105e88 <trap+0xd8>
    yield();
80105ef6:	e8 d5 de ff ff       	call   80103dd0 <yield>
80105efb:	eb 8b                	jmp    80105e88 <trap+0xd8>
80105efd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105f00:	e8 2b d9 ff ff       	call   80103830 <cpuid>
80105f05:	85 c0                	test   %eax,%eax
80105f07:	0f 84 c3 00 00 00    	je     80105fd0 <trap+0x220>
    lapiceoi();
80105f0d:	e8 6e c8 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f12:	e8 39 d9 ff ff       	call   80103850 <myproc>
80105f17:	85 c0                	test   %eax,%eax
80105f19:	0f 85 38 ff ff ff    	jne    80105e57 <trap+0xa7>
80105f1f:	e9 50 ff ff ff       	jmp    80105e74 <trap+0xc4>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f28:	e8 13 c7 ff ff       	call   80102640 <kbdintr>
    lapiceoi();
80105f2d:	e8 4e c8 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f32:	e8 19 d9 ff ff       	call   80103850 <myproc>
80105f37:	85 c0                	test   %eax,%eax
80105f39:	0f 85 18 ff ff ff    	jne    80105e57 <trap+0xa7>
80105f3f:	e9 30 ff ff ff       	jmp    80105e74 <trap+0xc4>
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f48:	e8 53 02 00 00       	call   801061a0 <uartintr>
    lapiceoi();
80105f4d:	e8 2e c8 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f52:	e8 f9 d8 ff ff       	call   80103850 <myproc>
80105f57:	85 c0                	test   %eax,%eax
80105f59:	0f 85 f8 fe ff ff    	jne    80105e57 <trap+0xa7>
80105f5f:	e9 10 ff ff ff       	jmp    80105e74 <trap+0xc4>
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f68:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105f6c:	8b 77 38             	mov    0x38(%edi),%esi
80105f6f:	e8 bc d8 ff ff       	call   80103830 <cpuid>
80105f74:	56                   	push   %esi
80105f75:	53                   	push   %ebx
80105f76:	50                   	push   %eax
80105f77:	68 08 7e 10 80       	push   $0x80107e08
80105f7c:	e8 df a6 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105f81:	e8 fa c7 ff ff       	call   80102780 <lapiceoi>
    break;
80105f86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f89:	e8 c2 d8 ff ff       	call   80103850 <myproc>
80105f8e:	85 c0                	test   %eax,%eax
80105f90:	0f 85 c1 fe ff ff    	jne    80105e57 <trap+0xa7>
80105f96:	e9 d9 fe ff ff       	jmp    80105e74 <trap+0xc4>
80105f9b:	90                   	nop
80105f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105fa0:	e8 eb c0 ff ff       	call   80102090 <ideintr>
80105fa5:	e9 63 ff ff ff       	jmp    80105f0d <trap+0x15d>
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fb0:	e8 eb dc ff ff       	call   80103ca0 <exit>
80105fb5:	e9 0e ff ff ff       	jmp    80105ec8 <trap+0x118>
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105fc0:	e8 db dc ff ff       	call   80103ca0 <exit>
80105fc5:	e9 aa fe ff ff       	jmp    80105e74 <trap+0xc4>
80105fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 80 60 11 80       	push   $0x80116080
80105fd8:	e8 73 e9 ff ff       	call   80104950 <acquire>
      wakeup(&ticks);
80105fdd:	c7 04 24 c0 68 11 80 	movl   $0x801168c0,(%esp)
      ticks++;
80105fe4:	83 05 c0 68 11 80 01 	addl   $0x1,0x801168c0
      wakeup(&ticks);
80105feb:	e8 e0 df ff ff       	call   80103fd0 <wakeup>
      release(&tickslock);
80105ff0:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80105ff7:	e8 74 ea ff ff       	call   80104a70 <release>
80105ffc:	83 c4 10             	add    $0x10,%esp
80105fff:	e9 09 ff ff ff       	jmp    80105f0d <trap+0x15d>
80106004:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106007:	e8 24 d8 ff ff       	call   80103830 <cpuid>
8010600c:	83 ec 0c             	sub    $0xc,%esp
8010600f:	56                   	push   %esi
80106010:	53                   	push   %ebx
80106011:	50                   	push   %eax
80106012:	ff 77 30             	pushl  0x30(%edi)
80106015:	68 2c 7e 10 80       	push   $0x80107e2c
8010601a:	e8 41 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010601f:	83 c4 14             	add    $0x14,%esp
80106022:	68 03 7e 10 80       	push   $0x80107e03
80106027:	e8 64 a3 ff ff       	call   80100390 <panic>
8010602c:	66 90                	xchg   %ax,%ax
8010602e:	66 90                	xchg   %ax,%ax

80106030 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106030:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
{
80106035:	55                   	push   %ebp
80106036:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106038:	85 c0                	test   %eax,%eax
8010603a:	74 1c                	je     80106058 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010603c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106041:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106042:	a8 01                	test   $0x1,%al
80106044:	74 12                	je     80106058 <uartgetc+0x28>
80106046:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010604b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010604c:	0f b6 c0             	movzbl %al,%eax
}
8010604f:	5d                   	pop    %ebp
80106050:	c3                   	ret    
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010605d:	5d                   	pop    %ebp
8010605e:	c3                   	ret    
8010605f:	90                   	nop

80106060 <uartputc.part.0>:
uartputc(int c)
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	57                   	push   %edi
80106064:	56                   	push   %esi
80106065:	53                   	push   %ebx
80106066:	89 c7                	mov    %eax,%edi
80106068:	bb 80 00 00 00       	mov    $0x80,%ebx
8010606d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106072:	83 ec 0c             	sub    $0xc,%esp
80106075:	eb 1b                	jmp    80106092 <uartputc.part.0+0x32>
80106077:	89 f6                	mov    %esi,%esi
80106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	6a 0a                	push   $0xa
80106085:	e8 16 c7 ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	83 eb 01             	sub    $0x1,%ebx
80106090:	74 07                	je     80106099 <uartputc.part.0+0x39>
80106092:	89 f2                	mov    %esi,%edx
80106094:	ec                   	in     (%dx),%al
80106095:	a8 20                	test   $0x20,%al
80106097:	74 e7                	je     80106080 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106099:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010609e:	89 f8                	mov    %edi,%eax
801060a0:	ee                   	out    %al,(%dx)
}
801060a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a4:	5b                   	pop    %ebx
801060a5:	5e                   	pop    %esi
801060a6:	5f                   	pop    %edi
801060a7:	5d                   	pop    %ebp
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <uartinit>:
{
801060b0:	55                   	push   %ebp
801060b1:	31 c9                	xor    %ecx,%ecx
801060b3:	89 c8                	mov    %ecx,%eax
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	57                   	push   %edi
801060b8:	56                   	push   %esi
801060b9:	53                   	push   %ebx
801060ba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801060bf:	89 da                	mov    %ebx,%edx
801060c1:	83 ec 0c             	sub    $0xc,%esp
801060c4:	ee                   	out    %al,(%dx)
801060c5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801060ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060cf:	89 fa                	mov    %edi,%edx
801060d1:	ee                   	out    %al,(%dx)
801060d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060dc:	ee                   	out    %al,(%dx)
801060dd:	be f9 03 00 00       	mov    $0x3f9,%esi
801060e2:	89 c8                	mov    %ecx,%eax
801060e4:	89 f2                	mov    %esi,%edx
801060e6:	ee                   	out    %al,(%dx)
801060e7:	b8 03 00 00 00       	mov    $0x3,%eax
801060ec:	89 fa                	mov    %edi,%edx
801060ee:	ee                   	out    %al,(%dx)
801060ef:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060f4:	89 c8                	mov    %ecx,%eax
801060f6:	ee                   	out    %al,(%dx)
801060f7:	b8 01 00 00 00       	mov    $0x1,%eax
801060fc:	89 f2                	mov    %esi,%edx
801060fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106104:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106105:	3c ff                	cmp    $0xff,%al
80106107:	74 5a                	je     80106163 <uartinit+0xb3>
  uart = 1;
80106109:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
80106110:	00 00 00 
80106113:	89 da                	mov    %ebx,%edx
80106115:	ec                   	in     (%dx),%al
80106116:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010611b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010611c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010611f:	bb 24 7f 10 80       	mov    $0x80107f24,%ebx
  ioapicenable(IRQ_COM1, 0);
80106124:	6a 00                	push   $0x0
80106126:	6a 04                	push   $0x4
80106128:	e8 b3 c1 ff ff       	call   801022e0 <ioapicenable>
8010612d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106130:	b8 78 00 00 00       	mov    $0x78,%eax
80106135:	eb 13                	jmp    8010614a <uartinit+0x9a>
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106140:	83 c3 01             	add    $0x1,%ebx
80106143:	0f be 03             	movsbl (%ebx),%eax
80106146:	84 c0                	test   %al,%al
80106148:	74 19                	je     80106163 <uartinit+0xb3>
  if(!uart)
8010614a:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
80106150:	85 d2                	test   %edx,%edx
80106152:	74 ec                	je     80106140 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106154:	83 c3 01             	add    $0x1,%ebx
80106157:	e8 04 ff ff ff       	call   80106060 <uartputc.part.0>
8010615c:	0f be 03             	movsbl (%ebx),%eax
8010615f:	84 c0                	test   %al,%al
80106161:	75 e7                	jne    8010614a <uartinit+0x9a>
}
80106163:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106166:	5b                   	pop    %ebx
80106167:	5e                   	pop    %esi
80106168:	5f                   	pop    %edi
80106169:	5d                   	pop    %ebp
8010616a:	c3                   	ret    
8010616b:	90                   	nop
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106170 <uartputc>:
  if(!uart)
80106170:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
{
80106176:	55                   	push   %ebp
80106177:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106179:	85 d2                	test   %edx,%edx
{
8010617b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010617e:	74 10                	je     80106190 <uartputc+0x20>
}
80106180:	5d                   	pop    %ebp
80106181:	e9 da fe ff ff       	jmp    80106060 <uartputc.part.0>
80106186:	8d 76 00             	lea    0x0(%esi),%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106190:	5d                   	pop    %ebp
80106191:	c3                   	ret    
80106192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061a0 <uartintr>:

void
uartintr(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061a6:	68 30 60 10 80       	push   $0x80106030
801061ab:	e8 60 a6 ff ff       	call   80100810 <consoleintr>
}
801061b0:	83 c4 10             	add    $0x10,%esp
801061b3:	c9                   	leave  
801061b4:	c3                   	ret    

801061b5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $0
801061b7:	6a 00                	push   $0x0
  jmp alltraps
801061b9:	e9 1c fb ff ff       	jmp    80105cda <alltraps>

801061be <vector1>:
.globl vector1
vector1:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $1
801061c0:	6a 01                	push   $0x1
  jmp alltraps
801061c2:	e9 13 fb ff ff       	jmp    80105cda <alltraps>

801061c7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $2
801061c9:	6a 02                	push   $0x2
  jmp alltraps
801061cb:	e9 0a fb ff ff       	jmp    80105cda <alltraps>

801061d0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $3
801061d2:	6a 03                	push   $0x3
  jmp alltraps
801061d4:	e9 01 fb ff ff       	jmp    80105cda <alltraps>

801061d9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $4
801061db:	6a 04                	push   $0x4
  jmp alltraps
801061dd:	e9 f8 fa ff ff       	jmp    80105cda <alltraps>

801061e2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $5
801061e4:	6a 05                	push   $0x5
  jmp alltraps
801061e6:	e9 ef fa ff ff       	jmp    80105cda <alltraps>

801061eb <vector6>:
.globl vector6
vector6:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $6
801061ed:	6a 06                	push   $0x6
  jmp alltraps
801061ef:	e9 e6 fa ff ff       	jmp    80105cda <alltraps>

801061f4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $7
801061f6:	6a 07                	push   $0x7
  jmp alltraps
801061f8:	e9 dd fa ff ff       	jmp    80105cda <alltraps>

801061fd <vector8>:
.globl vector8
vector8:
  pushl $8
801061fd:	6a 08                	push   $0x8
  jmp alltraps
801061ff:	e9 d6 fa ff ff       	jmp    80105cda <alltraps>

80106204 <vector9>:
.globl vector9
vector9:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $9
80106206:	6a 09                	push   $0x9
  jmp alltraps
80106208:	e9 cd fa ff ff       	jmp    80105cda <alltraps>

8010620d <vector10>:
.globl vector10
vector10:
  pushl $10
8010620d:	6a 0a                	push   $0xa
  jmp alltraps
8010620f:	e9 c6 fa ff ff       	jmp    80105cda <alltraps>

80106214 <vector11>:
.globl vector11
vector11:
  pushl $11
80106214:	6a 0b                	push   $0xb
  jmp alltraps
80106216:	e9 bf fa ff ff       	jmp    80105cda <alltraps>

8010621b <vector12>:
.globl vector12
vector12:
  pushl $12
8010621b:	6a 0c                	push   $0xc
  jmp alltraps
8010621d:	e9 b8 fa ff ff       	jmp    80105cda <alltraps>

80106222 <vector13>:
.globl vector13
vector13:
  pushl $13
80106222:	6a 0d                	push   $0xd
  jmp alltraps
80106224:	e9 b1 fa ff ff       	jmp    80105cda <alltraps>

80106229 <vector14>:
.globl vector14
vector14:
  pushl $14
80106229:	6a 0e                	push   $0xe
  jmp alltraps
8010622b:	e9 aa fa ff ff       	jmp    80105cda <alltraps>

80106230 <vector15>:
.globl vector15
vector15:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $15
80106232:	6a 0f                	push   $0xf
  jmp alltraps
80106234:	e9 a1 fa ff ff       	jmp    80105cda <alltraps>

80106239 <vector16>:
.globl vector16
vector16:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $16
8010623b:	6a 10                	push   $0x10
  jmp alltraps
8010623d:	e9 98 fa ff ff       	jmp    80105cda <alltraps>

80106242 <vector17>:
.globl vector17
vector17:
  pushl $17
80106242:	6a 11                	push   $0x11
  jmp alltraps
80106244:	e9 91 fa ff ff       	jmp    80105cda <alltraps>

80106249 <vector18>:
.globl vector18
vector18:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $18
8010624b:	6a 12                	push   $0x12
  jmp alltraps
8010624d:	e9 88 fa ff ff       	jmp    80105cda <alltraps>

80106252 <vector19>:
.globl vector19
vector19:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $19
80106254:	6a 13                	push   $0x13
  jmp alltraps
80106256:	e9 7f fa ff ff       	jmp    80105cda <alltraps>

8010625b <vector20>:
.globl vector20
vector20:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $20
8010625d:	6a 14                	push   $0x14
  jmp alltraps
8010625f:	e9 76 fa ff ff       	jmp    80105cda <alltraps>

80106264 <vector21>:
.globl vector21
vector21:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $21
80106266:	6a 15                	push   $0x15
  jmp alltraps
80106268:	e9 6d fa ff ff       	jmp    80105cda <alltraps>

8010626d <vector22>:
.globl vector22
vector22:
  pushl $0
8010626d:	6a 00                	push   $0x0
  pushl $22
8010626f:	6a 16                	push   $0x16
  jmp alltraps
80106271:	e9 64 fa ff ff       	jmp    80105cda <alltraps>

80106276 <vector23>:
.globl vector23
vector23:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $23
80106278:	6a 17                	push   $0x17
  jmp alltraps
8010627a:	e9 5b fa ff ff       	jmp    80105cda <alltraps>

8010627f <vector24>:
.globl vector24
vector24:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $24
80106281:	6a 18                	push   $0x18
  jmp alltraps
80106283:	e9 52 fa ff ff       	jmp    80105cda <alltraps>

80106288 <vector25>:
.globl vector25
vector25:
  pushl $0
80106288:	6a 00                	push   $0x0
  pushl $25
8010628a:	6a 19                	push   $0x19
  jmp alltraps
8010628c:	e9 49 fa ff ff       	jmp    80105cda <alltraps>

80106291 <vector26>:
.globl vector26
vector26:
  pushl $0
80106291:	6a 00                	push   $0x0
  pushl $26
80106293:	6a 1a                	push   $0x1a
  jmp alltraps
80106295:	e9 40 fa ff ff       	jmp    80105cda <alltraps>

8010629a <vector27>:
.globl vector27
vector27:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $27
8010629c:	6a 1b                	push   $0x1b
  jmp alltraps
8010629e:	e9 37 fa ff ff       	jmp    80105cda <alltraps>

801062a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $28
801062a5:	6a 1c                	push   $0x1c
  jmp alltraps
801062a7:	e9 2e fa ff ff       	jmp    80105cda <alltraps>

801062ac <vector29>:
.globl vector29
vector29:
  pushl $0
801062ac:	6a 00                	push   $0x0
  pushl $29
801062ae:	6a 1d                	push   $0x1d
  jmp alltraps
801062b0:	e9 25 fa ff ff       	jmp    80105cda <alltraps>

801062b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $30
801062b7:	6a 1e                	push   $0x1e
  jmp alltraps
801062b9:	e9 1c fa ff ff       	jmp    80105cda <alltraps>

801062be <vector31>:
.globl vector31
vector31:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $31
801062c0:	6a 1f                	push   $0x1f
  jmp alltraps
801062c2:	e9 13 fa ff ff       	jmp    80105cda <alltraps>

801062c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $32
801062c9:	6a 20                	push   $0x20
  jmp alltraps
801062cb:	e9 0a fa ff ff       	jmp    80105cda <alltraps>

801062d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $33
801062d2:	6a 21                	push   $0x21
  jmp alltraps
801062d4:	e9 01 fa ff ff       	jmp    80105cda <alltraps>

801062d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $34
801062db:	6a 22                	push   $0x22
  jmp alltraps
801062dd:	e9 f8 f9 ff ff       	jmp    80105cda <alltraps>

801062e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $35
801062e4:	6a 23                	push   $0x23
  jmp alltraps
801062e6:	e9 ef f9 ff ff       	jmp    80105cda <alltraps>

801062eb <vector36>:
.globl vector36
vector36:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $36
801062ed:	6a 24                	push   $0x24
  jmp alltraps
801062ef:	e9 e6 f9 ff ff       	jmp    80105cda <alltraps>

801062f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $37
801062f6:	6a 25                	push   $0x25
  jmp alltraps
801062f8:	e9 dd f9 ff ff       	jmp    80105cda <alltraps>

801062fd <vector38>:
.globl vector38
vector38:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $38
801062ff:	6a 26                	push   $0x26
  jmp alltraps
80106301:	e9 d4 f9 ff ff       	jmp    80105cda <alltraps>

80106306 <vector39>:
.globl vector39
vector39:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $39
80106308:	6a 27                	push   $0x27
  jmp alltraps
8010630a:	e9 cb f9 ff ff       	jmp    80105cda <alltraps>

8010630f <vector40>:
.globl vector40
vector40:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $40
80106311:	6a 28                	push   $0x28
  jmp alltraps
80106313:	e9 c2 f9 ff ff       	jmp    80105cda <alltraps>

80106318 <vector41>:
.globl vector41
vector41:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $41
8010631a:	6a 29                	push   $0x29
  jmp alltraps
8010631c:	e9 b9 f9 ff ff       	jmp    80105cda <alltraps>

80106321 <vector42>:
.globl vector42
vector42:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $42
80106323:	6a 2a                	push   $0x2a
  jmp alltraps
80106325:	e9 b0 f9 ff ff       	jmp    80105cda <alltraps>

8010632a <vector43>:
.globl vector43
vector43:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $43
8010632c:	6a 2b                	push   $0x2b
  jmp alltraps
8010632e:	e9 a7 f9 ff ff       	jmp    80105cda <alltraps>

80106333 <vector44>:
.globl vector44
vector44:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $44
80106335:	6a 2c                	push   $0x2c
  jmp alltraps
80106337:	e9 9e f9 ff ff       	jmp    80105cda <alltraps>

8010633c <vector45>:
.globl vector45
vector45:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $45
8010633e:	6a 2d                	push   $0x2d
  jmp alltraps
80106340:	e9 95 f9 ff ff       	jmp    80105cda <alltraps>

80106345 <vector46>:
.globl vector46
vector46:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $46
80106347:	6a 2e                	push   $0x2e
  jmp alltraps
80106349:	e9 8c f9 ff ff       	jmp    80105cda <alltraps>

8010634e <vector47>:
.globl vector47
vector47:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $47
80106350:	6a 2f                	push   $0x2f
  jmp alltraps
80106352:	e9 83 f9 ff ff       	jmp    80105cda <alltraps>

80106357 <vector48>:
.globl vector48
vector48:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $48
80106359:	6a 30                	push   $0x30
  jmp alltraps
8010635b:	e9 7a f9 ff ff       	jmp    80105cda <alltraps>

80106360 <vector49>:
.globl vector49
vector49:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $49
80106362:	6a 31                	push   $0x31
  jmp alltraps
80106364:	e9 71 f9 ff ff       	jmp    80105cda <alltraps>

80106369 <vector50>:
.globl vector50
vector50:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $50
8010636b:	6a 32                	push   $0x32
  jmp alltraps
8010636d:	e9 68 f9 ff ff       	jmp    80105cda <alltraps>

80106372 <vector51>:
.globl vector51
vector51:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $51
80106374:	6a 33                	push   $0x33
  jmp alltraps
80106376:	e9 5f f9 ff ff       	jmp    80105cda <alltraps>

8010637b <vector52>:
.globl vector52
vector52:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $52
8010637d:	6a 34                	push   $0x34
  jmp alltraps
8010637f:	e9 56 f9 ff ff       	jmp    80105cda <alltraps>

80106384 <vector53>:
.globl vector53
vector53:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $53
80106386:	6a 35                	push   $0x35
  jmp alltraps
80106388:	e9 4d f9 ff ff       	jmp    80105cda <alltraps>

8010638d <vector54>:
.globl vector54
vector54:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $54
8010638f:	6a 36                	push   $0x36
  jmp alltraps
80106391:	e9 44 f9 ff ff       	jmp    80105cda <alltraps>

80106396 <vector55>:
.globl vector55
vector55:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $55
80106398:	6a 37                	push   $0x37
  jmp alltraps
8010639a:	e9 3b f9 ff ff       	jmp    80105cda <alltraps>

8010639f <vector56>:
.globl vector56
vector56:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $56
801063a1:	6a 38                	push   $0x38
  jmp alltraps
801063a3:	e9 32 f9 ff ff       	jmp    80105cda <alltraps>

801063a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $57
801063aa:	6a 39                	push   $0x39
  jmp alltraps
801063ac:	e9 29 f9 ff ff       	jmp    80105cda <alltraps>

801063b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $58
801063b3:	6a 3a                	push   $0x3a
  jmp alltraps
801063b5:	e9 20 f9 ff ff       	jmp    80105cda <alltraps>

801063ba <vector59>:
.globl vector59
vector59:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $59
801063bc:	6a 3b                	push   $0x3b
  jmp alltraps
801063be:	e9 17 f9 ff ff       	jmp    80105cda <alltraps>

801063c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $60
801063c5:	6a 3c                	push   $0x3c
  jmp alltraps
801063c7:	e9 0e f9 ff ff       	jmp    80105cda <alltraps>

801063cc <vector61>:
.globl vector61
vector61:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $61
801063ce:	6a 3d                	push   $0x3d
  jmp alltraps
801063d0:	e9 05 f9 ff ff       	jmp    80105cda <alltraps>

801063d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $62
801063d7:	6a 3e                	push   $0x3e
  jmp alltraps
801063d9:	e9 fc f8 ff ff       	jmp    80105cda <alltraps>

801063de <vector63>:
.globl vector63
vector63:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $63
801063e0:	6a 3f                	push   $0x3f
  jmp alltraps
801063e2:	e9 f3 f8 ff ff       	jmp    80105cda <alltraps>

801063e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $64
801063e9:	6a 40                	push   $0x40
  jmp alltraps
801063eb:	e9 ea f8 ff ff       	jmp    80105cda <alltraps>

801063f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $65
801063f2:	6a 41                	push   $0x41
  jmp alltraps
801063f4:	e9 e1 f8 ff ff       	jmp    80105cda <alltraps>

801063f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $66
801063fb:	6a 42                	push   $0x42
  jmp alltraps
801063fd:	e9 d8 f8 ff ff       	jmp    80105cda <alltraps>

80106402 <vector67>:
.globl vector67
vector67:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $67
80106404:	6a 43                	push   $0x43
  jmp alltraps
80106406:	e9 cf f8 ff ff       	jmp    80105cda <alltraps>

8010640b <vector68>:
.globl vector68
vector68:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $68
8010640d:	6a 44                	push   $0x44
  jmp alltraps
8010640f:	e9 c6 f8 ff ff       	jmp    80105cda <alltraps>

80106414 <vector69>:
.globl vector69
vector69:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $69
80106416:	6a 45                	push   $0x45
  jmp alltraps
80106418:	e9 bd f8 ff ff       	jmp    80105cda <alltraps>

8010641d <vector70>:
.globl vector70
vector70:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $70
8010641f:	6a 46                	push   $0x46
  jmp alltraps
80106421:	e9 b4 f8 ff ff       	jmp    80105cda <alltraps>

80106426 <vector71>:
.globl vector71
vector71:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $71
80106428:	6a 47                	push   $0x47
  jmp alltraps
8010642a:	e9 ab f8 ff ff       	jmp    80105cda <alltraps>

8010642f <vector72>:
.globl vector72
vector72:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $72
80106431:	6a 48                	push   $0x48
  jmp alltraps
80106433:	e9 a2 f8 ff ff       	jmp    80105cda <alltraps>

80106438 <vector73>:
.globl vector73
vector73:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $73
8010643a:	6a 49                	push   $0x49
  jmp alltraps
8010643c:	e9 99 f8 ff ff       	jmp    80105cda <alltraps>

80106441 <vector74>:
.globl vector74
vector74:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $74
80106443:	6a 4a                	push   $0x4a
  jmp alltraps
80106445:	e9 90 f8 ff ff       	jmp    80105cda <alltraps>

8010644a <vector75>:
.globl vector75
vector75:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $75
8010644c:	6a 4b                	push   $0x4b
  jmp alltraps
8010644e:	e9 87 f8 ff ff       	jmp    80105cda <alltraps>

80106453 <vector76>:
.globl vector76
vector76:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $76
80106455:	6a 4c                	push   $0x4c
  jmp alltraps
80106457:	e9 7e f8 ff ff       	jmp    80105cda <alltraps>

8010645c <vector77>:
.globl vector77
vector77:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $77
8010645e:	6a 4d                	push   $0x4d
  jmp alltraps
80106460:	e9 75 f8 ff ff       	jmp    80105cda <alltraps>

80106465 <vector78>:
.globl vector78
vector78:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $78
80106467:	6a 4e                	push   $0x4e
  jmp alltraps
80106469:	e9 6c f8 ff ff       	jmp    80105cda <alltraps>

8010646e <vector79>:
.globl vector79
vector79:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $79
80106470:	6a 4f                	push   $0x4f
  jmp alltraps
80106472:	e9 63 f8 ff ff       	jmp    80105cda <alltraps>

80106477 <vector80>:
.globl vector80
vector80:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $80
80106479:	6a 50                	push   $0x50
  jmp alltraps
8010647b:	e9 5a f8 ff ff       	jmp    80105cda <alltraps>

80106480 <vector81>:
.globl vector81
vector81:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $81
80106482:	6a 51                	push   $0x51
  jmp alltraps
80106484:	e9 51 f8 ff ff       	jmp    80105cda <alltraps>

80106489 <vector82>:
.globl vector82
vector82:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $82
8010648b:	6a 52                	push   $0x52
  jmp alltraps
8010648d:	e9 48 f8 ff ff       	jmp    80105cda <alltraps>

80106492 <vector83>:
.globl vector83
vector83:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $83
80106494:	6a 53                	push   $0x53
  jmp alltraps
80106496:	e9 3f f8 ff ff       	jmp    80105cda <alltraps>

8010649b <vector84>:
.globl vector84
vector84:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $84
8010649d:	6a 54                	push   $0x54
  jmp alltraps
8010649f:	e9 36 f8 ff ff       	jmp    80105cda <alltraps>

801064a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $85
801064a6:	6a 55                	push   $0x55
  jmp alltraps
801064a8:	e9 2d f8 ff ff       	jmp    80105cda <alltraps>

801064ad <vector86>:
.globl vector86
vector86:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $86
801064af:	6a 56                	push   $0x56
  jmp alltraps
801064b1:	e9 24 f8 ff ff       	jmp    80105cda <alltraps>

801064b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $87
801064b8:	6a 57                	push   $0x57
  jmp alltraps
801064ba:	e9 1b f8 ff ff       	jmp    80105cda <alltraps>

801064bf <vector88>:
.globl vector88
vector88:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $88
801064c1:	6a 58                	push   $0x58
  jmp alltraps
801064c3:	e9 12 f8 ff ff       	jmp    80105cda <alltraps>

801064c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $89
801064ca:	6a 59                	push   $0x59
  jmp alltraps
801064cc:	e9 09 f8 ff ff       	jmp    80105cda <alltraps>

801064d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $90
801064d3:	6a 5a                	push   $0x5a
  jmp alltraps
801064d5:	e9 00 f8 ff ff       	jmp    80105cda <alltraps>

801064da <vector91>:
.globl vector91
vector91:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $91
801064dc:	6a 5b                	push   $0x5b
  jmp alltraps
801064de:	e9 f7 f7 ff ff       	jmp    80105cda <alltraps>

801064e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $92
801064e5:	6a 5c                	push   $0x5c
  jmp alltraps
801064e7:	e9 ee f7 ff ff       	jmp    80105cda <alltraps>

801064ec <vector93>:
.globl vector93
vector93:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $93
801064ee:	6a 5d                	push   $0x5d
  jmp alltraps
801064f0:	e9 e5 f7 ff ff       	jmp    80105cda <alltraps>

801064f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $94
801064f7:	6a 5e                	push   $0x5e
  jmp alltraps
801064f9:	e9 dc f7 ff ff       	jmp    80105cda <alltraps>

801064fe <vector95>:
.globl vector95
vector95:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $95
80106500:	6a 5f                	push   $0x5f
  jmp alltraps
80106502:	e9 d3 f7 ff ff       	jmp    80105cda <alltraps>

80106507 <vector96>:
.globl vector96
vector96:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $96
80106509:	6a 60                	push   $0x60
  jmp alltraps
8010650b:	e9 ca f7 ff ff       	jmp    80105cda <alltraps>

80106510 <vector97>:
.globl vector97
vector97:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $97
80106512:	6a 61                	push   $0x61
  jmp alltraps
80106514:	e9 c1 f7 ff ff       	jmp    80105cda <alltraps>

80106519 <vector98>:
.globl vector98
vector98:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $98
8010651b:	6a 62                	push   $0x62
  jmp alltraps
8010651d:	e9 b8 f7 ff ff       	jmp    80105cda <alltraps>

80106522 <vector99>:
.globl vector99
vector99:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $99
80106524:	6a 63                	push   $0x63
  jmp alltraps
80106526:	e9 af f7 ff ff       	jmp    80105cda <alltraps>

8010652b <vector100>:
.globl vector100
vector100:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $100
8010652d:	6a 64                	push   $0x64
  jmp alltraps
8010652f:	e9 a6 f7 ff ff       	jmp    80105cda <alltraps>

80106534 <vector101>:
.globl vector101
vector101:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $101
80106536:	6a 65                	push   $0x65
  jmp alltraps
80106538:	e9 9d f7 ff ff       	jmp    80105cda <alltraps>

8010653d <vector102>:
.globl vector102
vector102:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $102
8010653f:	6a 66                	push   $0x66
  jmp alltraps
80106541:	e9 94 f7 ff ff       	jmp    80105cda <alltraps>

80106546 <vector103>:
.globl vector103
vector103:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $103
80106548:	6a 67                	push   $0x67
  jmp alltraps
8010654a:	e9 8b f7 ff ff       	jmp    80105cda <alltraps>

8010654f <vector104>:
.globl vector104
vector104:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $104
80106551:	6a 68                	push   $0x68
  jmp alltraps
80106553:	e9 82 f7 ff ff       	jmp    80105cda <alltraps>

80106558 <vector105>:
.globl vector105
vector105:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $105
8010655a:	6a 69                	push   $0x69
  jmp alltraps
8010655c:	e9 79 f7 ff ff       	jmp    80105cda <alltraps>

80106561 <vector106>:
.globl vector106
vector106:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $106
80106563:	6a 6a                	push   $0x6a
  jmp alltraps
80106565:	e9 70 f7 ff ff       	jmp    80105cda <alltraps>

8010656a <vector107>:
.globl vector107
vector107:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $107
8010656c:	6a 6b                	push   $0x6b
  jmp alltraps
8010656e:	e9 67 f7 ff ff       	jmp    80105cda <alltraps>

80106573 <vector108>:
.globl vector108
vector108:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $108
80106575:	6a 6c                	push   $0x6c
  jmp alltraps
80106577:	e9 5e f7 ff ff       	jmp    80105cda <alltraps>

8010657c <vector109>:
.globl vector109
vector109:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $109
8010657e:	6a 6d                	push   $0x6d
  jmp alltraps
80106580:	e9 55 f7 ff ff       	jmp    80105cda <alltraps>

80106585 <vector110>:
.globl vector110
vector110:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $110
80106587:	6a 6e                	push   $0x6e
  jmp alltraps
80106589:	e9 4c f7 ff ff       	jmp    80105cda <alltraps>

8010658e <vector111>:
.globl vector111
vector111:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $111
80106590:	6a 6f                	push   $0x6f
  jmp alltraps
80106592:	e9 43 f7 ff ff       	jmp    80105cda <alltraps>

80106597 <vector112>:
.globl vector112
vector112:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $112
80106599:	6a 70                	push   $0x70
  jmp alltraps
8010659b:	e9 3a f7 ff ff       	jmp    80105cda <alltraps>

801065a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $113
801065a2:	6a 71                	push   $0x71
  jmp alltraps
801065a4:	e9 31 f7 ff ff       	jmp    80105cda <alltraps>

801065a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $114
801065ab:	6a 72                	push   $0x72
  jmp alltraps
801065ad:	e9 28 f7 ff ff       	jmp    80105cda <alltraps>

801065b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $115
801065b4:	6a 73                	push   $0x73
  jmp alltraps
801065b6:	e9 1f f7 ff ff       	jmp    80105cda <alltraps>

801065bb <vector116>:
.globl vector116
vector116:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $116
801065bd:	6a 74                	push   $0x74
  jmp alltraps
801065bf:	e9 16 f7 ff ff       	jmp    80105cda <alltraps>

801065c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $117
801065c6:	6a 75                	push   $0x75
  jmp alltraps
801065c8:	e9 0d f7 ff ff       	jmp    80105cda <alltraps>

801065cd <vector118>:
.globl vector118
vector118:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $118
801065cf:	6a 76                	push   $0x76
  jmp alltraps
801065d1:	e9 04 f7 ff ff       	jmp    80105cda <alltraps>

801065d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $119
801065d8:	6a 77                	push   $0x77
  jmp alltraps
801065da:	e9 fb f6 ff ff       	jmp    80105cda <alltraps>

801065df <vector120>:
.globl vector120
vector120:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $120
801065e1:	6a 78                	push   $0x78
  jmp alltraps
801065e3:	e9 f2 f6 ff ff       	jmp    80105cda <alltraps>

801065e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $121
801065ea:	6a 79                	push   $0x79
  jmp alltraps
801065ec:	e9 e9 f6 ff ff       	jmp    80105cda <alltraps>

801065f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $122
801065f3:	6a 7a                	push   $0x7a
  jmp alltraps
801065f5:	e9 e0 f6 ff ff       	jmp    80105cda <alltraps>

801065fa <vector123>:
.globl vector123
vector123:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $123
801065fc:	6a 7b                	push   $0x7b
  jmp alltraps
801065fe:	e9 d7 f6 ff ff       	jmp    80105cda <alltraps>

80106603 <vector124>:
.globl vector124
vector124:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $124
80106605:	6a 7c                	push   $0x7c
  jmp alltraps
80106607:	e9 ce f6 ff ff       	jmp    80105cda <alltraps>

8010660c <vector125>:
.globl vector125
vector125:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $125
8010660e:	6a 7d                	push   $0x7d
  jmp alltraps
80106610:	e9 c5 f6 ff ff       	jmp    80105cda <alltraps>

80106615 <vector126>:
.globl vector126
vector126:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $126
80106617:	6a 7e                	push   $0x7e
  jmp alltraps
80106619:	e9 bc f6 ff ff       	jmp    80105cda <alltraps>

8010661e <vector127>:
.globl vector127
vector127:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $127
80106620:	6a 7f                	push   $0x7f
  jmp alltraps
80106622:	e9 b3 f6 ff ff       	jmp    80105cda <alltraps>

80106627 <vector128>:
.globl vector128
vector128:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $128
80106629:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010662e:	e9 a7 f6 ff ff       	jmp    80105cda <alltraps>

80106633 <vector129>:
.globl vector129
vector129:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $129
80106635:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010663a:	e9 9b f6 ff ff       	jmp    80105cda <alltraps>

8010663f <vector130>:
.globl vector130
vector130:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $130
80106641:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106646:	e9 8f f6 ff ff       	jmp    80105cda <alltraps>

8010664b <vector131>:
.globl vector131
vector131:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $131
8010664d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106652:	e9 83 f6 ff ff       	jmp    80105cda <alltraps>

80106657 <vector132>:
.globl vector132
vector132:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $132
80106659:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010665e:	e9 77 f6 ff ff       	jmp    80105cda <alltraps>

80106663 <vector133>:
.globl vector133
vector133:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $133
80106665:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010666a:	e9 6b f6 ff ff       	jmp    80105cda <alltraps>

8010666f <vector134>:
.globl vector134
vector134:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $134
80106671:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106676:	e9 5f f6 ff ff       	jmp    80105cda <alltraps>

8010667b <vector135>:
.globl vector135
vector135:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $135
8010667d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106682:	e9 53 f6 ff ff       	jmp    80105cda <alltraps>

80106687 <vector136>:
.globl vector136
vector136:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $136
80106689:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010668e:	e9 47 f6 ff ff       	jmp    80105cda <alltraps>

80106693 <vector137>:
.globl vector137
vector137:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $137
80106695:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010669a:	e9 3b f6 ff ff       	jmp    80105cda <alltraps>

8010669f <vector138>:
.globl vector138
vector138:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $138
801066a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066a6:	e9 2f f6 ff ff       	jmp    80105cda <alltraps>

801066ab <vector139>:
.globl vector139
vector139:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $139
801066ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066b2:	e9 23 f6 ff ff       	jmp    80105cda <alltraps>

801066b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $140
801066b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066be:	e9 17 f6 ff ff       	jmp    80105cda <alltraps>

801066c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $141
801066c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066ca:	e9 0b f6 ff ff       	jmp    80105cda <alltraps>

801066cf <vector142>:
.globl vector142
vector142:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $142
801066d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066d6:	e9 ff f5 ff ff       	jmp    80105cda <alltraps>

801066db <vector143>:
.globl vector143
vector143:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $143
801066dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066e2:	e9 f3 f5 ff ff       	jmp    80105cda <alltraps>

801066e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $144
801066e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066ee:	e9 e7 f5 ff ff       	jmp    80105cda <alltraps>

801066f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $145
801066f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066fa:	e9 db f5 ff ff       	jmp    80105cda <alltraps>

801066ff <vector146>:
.globl vector146
vector146:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $146
80106701:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106706:	e9 cf f5 ff ff       	jmp    80105cda <alltraps>

8010670b <vector147>:
.globl vector147
vector147:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $147
8010670d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106712:	e9 c3 f5 ff ff       	jmp    80105cda <alltraps>

80106717 <vector148>:
.globl vector148
vector148:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $148
80106719:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010671e:	e9 b7 f5 ff ff       	jmp    80105cda <alltraps>

80106723 <vector149>:
.globl vector149
vector149:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $149
80106725:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010672a:	e9 ab f5 ff ff       	jmp    80105cda <alltraps>

8010672f <vector150>:
.globl vector150
vector150:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $150
80106731:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106736:	e9 9f f5 ff ff       	jmp    80105cda <alltraps>

8010673b <vector151>:
.globl vector151
vector151:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $151
8010673d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106742:	e9 93 f5 ff ff       	jmp    80105cda <alltraps>

80106747 <vector152>:
.globl vector152
vector152:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $152
80106749:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010674e:	e9 87 f5 ff ff       	jmp    80105cda <alltraps>

80106753 <vector153>:
.globl vector153
vector153:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $153
80106755:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010675a:	e9 7b f5 ff ff       	jmp    80105cda <alltraps>

8010675f <vector154>:
.globl vector154
vector154:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $154
80106761:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106766:	e9 6f f5 ff ff       	jmp    80105cda <alltraps>

8010676b <vector155>:
.globl vector155
vector155:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $155
8010676d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106772:	e9 63 f5 ff ff       	jmp    80105cda <alltraps>

80106777 <vector156>:
.globl vector156
vector156:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $156
80106779:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010677e:	e9 57 f5 ff ff       	jmp    80105cda <alltraps>

80106783 <vector157>:
.globl vector157
vector157:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $157
80106785:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010678a:	e9 4b f5 ff ff       	jmp    80105cda <alltraps>

8010678f <vector158>:
.globl vector158
vector158:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $158
80106791:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106796:	e9 3f f5 ff ff       	jmp    80105cda <alltraps>

8010679b <vector159>:
.globl vector159
vector159:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $159
8010679d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067a2:	e9 33 f5 ff ff       	jmp    80105cda <alltraps>

801067a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $160
801067a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067ae:	e9 27 f5 ff ff       	jmp    80105cda <alltraps>

801067b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $161
801067b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067ba:	e9 1b f5 ff ff       	jmp    80105cda <alltraps>

801067bf <vector162>:
.globl vector162
vector162:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $162
801067c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067c6:	e9 0f f5 ff ff       	jmp    80105cda <alltraps>

801067cb <vector163>:
.globl vector163
vector163:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $163
801067cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067d2:	e9 03 f5 ff ff       	jmp    80105cda <alltraps>

801067d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $164
801067d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067de:	e9 f7 f4 ff ff       	jmp    80105cda <alltraps>

801067e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $165
801067e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067ea:	e9 eb f4 ff ff       	jmp    80105cda <alltraps>

801067ef <vector166>:
.globl vector166
vector166:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $166
801067f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067f6:	e9 df f4 ff ff       	jmp    80105cda <alltraps>

801067fb <vector167>:
.globl vector167
vector167:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $167
801067fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106802:	e9 d3 f4 ff ff       	jmp    80105cda <alltraps>

80106807 <vector168>:
.globl vector168
vector168:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $168
80106809:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010680e:	e9 c7 f4 ff ff       	jmp    80105cda <alltraps>

80106813 <vector169>:
.globl vector169
vector169:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $169
80106815:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010681a:	e9 bb f4 ff ff       	jmp    80105cda <alltraps>

8010681f <vector170>:
.globl vector170
vector170:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $170
80106821:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106826:	e9 af f4 ff ff       	jmp    80105cda <alltraps>

8010682b <vector171>:
.globl vector171
vector171:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $171
8010682d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106832:	e9 a3 f4 ff ff       	jmp    80105cda <alltraps>

80106837 <vector172>:
.globl vector172
vector172:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $172
80106839:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010683e:	e9 97 f4 ff ff       	jmp    80105cda <alltraps>

80106843 <vector173>:
.globl vector173
vector173:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $173
80106845:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010684a:	e9 8b f4 ff ff       	jmp    80105cda <alltraps>

8010684f <vector174>:
.globl vector174
vector174:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $174
80106851:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106856:	e9 7f f4 ff ff       	jmp    80105cda <alltraps>

8010685b <vector175>:
.globl vector175
vector175:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $175
8010685d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106862:	e9 73 f4 ff ff       	jmp    80105cda <alltraps>

80106867 <vector176>:
.globl vector176
vector176:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $176
80106869:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010686e:	e9 67 f4 ff ff       	jmp    80105cda <alltraps>

80106873 <vector177>:
.globl vector177
vector177:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $177
80106875:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010687a:	e9 5b f4 ff ff       	jmp    80105cda <alltraps>

8010687f <vector178>:
.globl vector178
vector178:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $178
80106881:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106886:	e9 4f f4 ff ff       	jmp    80105cda <alltraps>

8010688b <vector179>:
.globl vector179
vector179:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $179
8010688d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106892:	e9 43 f4 ff ff       	jmp    80105cda <alltraps>

80106897 <vector180>:
.globl vector180
vector180:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $180
80106899:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010689e:	e9 37 f4 ff ff       	jmp    80105cda <alltraps>

801068a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $181
801068a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068aa:	e9 2b f4 ff ff       	jmp    80105cda <alltraps>

801068af <vector182>:
.globl vector182
vector182:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $182
801068b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068b6:	e9 1f f4 ff ff       	jmp    80105cda <alltraps>

801068bb <vector183>:
.globl vector183
vector183:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $183
801068bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068c2:	e9 13 f4 ff ff       	jmp    80105cda <alltraps>

801068c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $184
801068c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068ce:	e9 07 f4 ff ff       	jmp    80105cda <alltraps>

801068d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $185
801068d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068da:	e9 fb f3 ff ff       	jmp    80105cda <alltraps>

801068df <vector186>:
.globl vector186
vector186:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $186
801068e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068e6:	e9 ef f3 ff ff       	jmp    80105cda <alltraps>

801068eb <vector187>:
.globl vector187
vector187:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $187
801068ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068f2:	e9 e3 f3 ff ff       	jmp    80105cda <alltraps>

801068f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $188
801068f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068fe:	e9 d7 f3 ff ff       	jmp    80105cda <alltraps>

80106903 <vector189>:
.globl vector189
vector189:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $189
80106905:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010690a:	e9 cb f3 ff ff       	jmp    80105cda <alltraps>

8010690f <vector190>:
.globl vector190
vector190:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $190
80106911:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106916:	e9 bf f3 ff ff       	jmp    80105cda <alltraps>

8010691b <vector191>:
.globl vector191
vector191:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $191
8010691d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106922:	e9 b3 f3 ff ff       	jmp    80105cda <alltraps>

80106927 <vector192>:
.globl vector192
vector192:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $192
80106929:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010692e:	e9 a7 f3 ff ff       	jmp    80105cda <alltraps>

80106933 <vector193>:
.globl vector193
vector193:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $193
80106935:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010693a:	e9 9b f3 ff ff       	jmp    80105cda <alltraps>

8010693f <vector194>:
.globl vector194
vector194:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $194
80106941:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106946:	e9 8f f3 ff ff       	jmp    80105cda <alltraps>

8010694b <vector195>:
.globl vector195
vector195:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $195
8010694d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106952:	e9 83 f3 ff ff       	jmp    80105cda <alltraps>

80106957 <vector196>:
.globl vector196
vector196:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $196
80106959:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010695e:	e9 77 f3 ff ff       	jmp    80105cda <alltraps>

80106963 <vector197>:
.globl vector197
vector197:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $197
80106965:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010696a:	e9 6b f3 ff ff       	jmp    80105cda <alltraps>

8010696f <vector198>:
.globl vector198
vector198:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $198
80106971:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106976:	e9 5f f3 ff ff       	jmp    80105cda <alltraps>

8010697b <vector199>:
.globl vector199
vector199:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $199
8010697d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106982:	e9 53 f3 ff ff       	jmp    80105cda <alltraps>

80106987 <vector200>:
.globl vector200
vector200:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $200
80106989:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010698e:	e9 47 f3 ff ff       	jmp    80105cda <alltraps>

80106993 <vector201>:
.globl vector201
vector201:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $201
80106995:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010699a:	e9 3b f3 ff ff       	jmp    80105cda <alltraps>

8010699f <vector202>:
.globl vector202
vector202:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $202
801069a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069a6:	e9 2f f3 ff ff       	jmp    80105cda <alltraps>

801069ab <vector203>:
.globl vector203
vector203:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $203
801069ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069b2:	e9 23 f3 ff ff       	jmp    80105cda <alltraps>

801069b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $204
801069b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069be:	e9 17 f3 ff ff       	jmp    80105cda <alltraps>

801069c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $205
801069c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069ca:	e9 0b f3 ff ff       	jmp    80105cda <alltraps>

801069cf <vector206>:
.globl vector206
vector206:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $206
801069d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069d6:	e9 ff f2 ff ff       	jmp    80105cda <alltraps>

801069db <vector207>:
.globl vector207
vector207:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $207
801069dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069e2:	e9 f3 f2 ff ff       	jmp    80105cda <alltraps>

801069e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $208
801069e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069ee:	e9 e7 f2 ff ff       	jmp    80105cda <alltraps>

801069f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $209
801069f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069fa:	e9 db f2 ff ff       	jmp    80105cda <alltraps>

801069ff <vector210>:
.globl vector210
vector210:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $210
80106a01:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a06:	e9 cf f2 ff ff       	jmp    80105cda <alltraps>

80106a0b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $211
80106a0d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a12:	e9 c3 f2 ff ff       	jmp    80105cda <alltraps>

80106a17 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $212
80106a19:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a1e:	e9 b7 f2 ff ff       	jmp    80105cda <alltraps>

80106a23 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $213
80106a25:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a2a:	e9 ab f2 ff ff       	jmp    80105cda <alltraps>

80106a2f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $214
80106a31:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a36:	e9 9f f2 ff ff       	jmp    80105cda <alltraps>

80106a3b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $215
80106a3d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a42:	e9 93 f2 ff ff       	jmp    80105cda <alltraps>

80106a47 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $216
80106a49:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a4e:	e9 87 f2 ff ff       	jmp    80105cda <alltraps>

80106a53 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $217
80106a55:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a5a:	e9 7b f2 ff ff       	jmp    80105cda <alltraps>

80106a5f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $218
80106a61:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a66:	e9 6f f2 ff ff       	jmp    80105cda <alltraps>

80106a6b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $219
80106a6d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a72:	e9 63 f2 ff ff       	jmp    80105cda <alltraps>

80106a77 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $220
80106a79:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a7e:	e9 57 f2 ff ff       	jmp    80105cda <alltraps>

80106a83 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $221
80106a85:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a8a:	e9 4b f2 ff ff       	jmp    80105cda <alltraps>

80106a8f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $222
80106a91:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a96:	e9 3f f2 ff ff       	jmp    80105cda <alltraps>

80106a9b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $223
80106a9d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106aa2:	e9 33 f2 ff ff       	jmp    80105cda <alltraps>

80106aa7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $224
80106aa9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106aae:	e9 27 f2 ff ff       	jmp    80105cda <alltraps>

80106ab3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $225
80106ab5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106aba:	e9 1b f2 ff ff       	jmp    80105cda <alltraps>

80106abf <vector226>:
.globl vector226
vector226:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $226
80106ac1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ac6:	e9 0f f2 ff ff       	jmp    80105cda <alltraps>

80106acb <vector227>:
.globl vector227
vector227:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $227
80106acd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ad2:	e9 03 f2 ff ff       	jmp    80105cda <alltraps>

80106ad7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $228
80106ad9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ade:	e9 f7 f1 ff ff       	jmp    80105cda <alltraps>

80106ae3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $229
80106ae5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aea:	e9 eb f1 ff ff       	jmp    80105cda <alltraps>

80106aef <vector230>:
.globl vector230
vector230:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $230
80106af1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106af6:	e9 df f1 ff ff       	jmp    80105cda <alltraps>

80106afb <vector231>:
.globl vector231
vector231:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $231
80106afd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b02:	e9 d3 f1 ff ff       	jmp    80105cda <alltraps>

80106b07 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $232
80106b09:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b0e:	e9 c7 f1 ff ff       	jmp    80105cda <alltraps>

80106b13 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $233
80106b15:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b1a:	e9 bb f1 ff ff       	jmp    80105cda <alltraps>

80106b1f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $234
80106b21:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b26:	e9 af f1 ff ff       	jmp    80105cda <alltraps>

80106b2b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $235
80106b2d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b32:	e9 a3 f1 ff ff       	jmp    80105cda <alltraps>

80106b37 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $236
80106b39:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b3e:	e9 97 f1 ff ff       	jmp    80105cda <alltraps>

80106b43 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $237
80106b45:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b4a:	e9 8b f1 ff ff       	jmp    80105cda <alltraps>

80106b4f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $238
80106b51:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b56:	e9 7f f1 ff ff       	jmp    80105cda <alltraps>

80106b5b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $239
80106b5d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b62:	e9 73 f1 ff ff       	jmp    80105cda <alltraps>

80106b67 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $240
80106b69:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b6e:	e9 67 f1 ff ff       	jmp    80105cda <alltraps>

80106b73 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $241
80106b75:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b7a:	e9 5b f1 ff ff       	jmp    80105cda <alltraps>

80106b7f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $242
80106b81:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b86:	e9 4f f1 ff ff       	jmp    80105cda <alltraps>

80106b8b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $243
80106b8d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b92:	e9 43 f1 ff ff       	jmp    80105cda <alltraps>

80106b97 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $244
80106b99:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b9e:	e9 37 f1 ff ff       	jmp    80105cda <alltraps>

80106ba3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $245
80106ba5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106baa:	e9 2b f1 ff ff       	jmp    80105cda <alltraps>

80106baf <vector246>:
.globl vector246
vector246:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $246
80106bb1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bb6:	e9 1f f1 ff ff       	jmp    80105cda <alltraps>

80106bbb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $247
80106bbd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bc2:	e9 13 f1 ff ff       	jmp    80105cda <alltraps>

80106bc7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $248
80106bc9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bce:	e9 07 f1 ff ff       	jmp    80105cda <alltraps>

80106bd3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $249
80106bd5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bda:	e9 fb f0 ff ff       	jmp    80105cda <alltraps>

80106bdf <vector250>:
.globl vector250
vector250:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $250
80106be1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106be6:	e9 ef f0 ff ff       	jmp    80105cda <alltraps>

80106beb <vector251>:
.globl vector251
vector251:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $251
80106bed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bf2:	e9 e3 f0 ff ff       	jmp    80105cda <alltraps>

80106bf7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $252
80106bf9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bfe:	e9 d7 f0 ff ff       	jmp    80105cda <alltraps>

80106c03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $253
80106c05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c0a:	e9 cb f0 ff ff       	jmp    80105cda <alltraps>

80106c0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $254
80106c11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c16:	e9 bf f0 ff ff       	jmp    80105cda <alltraps>

80106c1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $255
80106c1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c22:	e9 b3 f0 ff ff       	jmp    80105cda <alltraps>
80106c27:	66 90                	xchg   %ax,%ax
80106c29:	66 90                	xchg   %ax,%ax
80106c2b:	66 90                	xchg   %ax,%ax
80106c2d:	66 90                	xchg   %ax,%ax
80106c2f:	90                   	nop

80106c30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c36:	89 d3                	mov    %edx,%ebx
{
80106c38:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106c3a:	c1 eb 16             	shr    $0x16,%ebx
80106c3d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106c40:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c43:	8b 06                	mov    (%esi),%eax
80106c45:	a8 01                	test   $0x1,%al
80106c47:	74 27                	je     80106c70 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c4e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c54:	c1 ef 0a             	shr    $0xa,%edi
}
80106c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c5a:	89 fa                	mov    %edi,%edx
80106c5c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c62:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c70:	85 c9                	test   %ecx,%ecx
80106c72:	74 2c                	je     80106ca0 <walkpgdir+0x70>
80106c74:	e8 67 b8 ff ff       	call   801024e0 <kalloc>
80106c79:	85 c0                	test   %eax,%eax
80106c7b:	89 c3                	mov    %eax,%ebx
80106c7d:	74 21                	je     80106ca0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c7f:	83 ec 04             	sub    $0x4,%esp
80106c82:	68 00 10 00 00       	push   $0x1000
80106c87:	6a 00                	push   $0x0
80106c89:	50                   	push   %eax
80106c8a:	e8 41 de ff ff       	call   80104ad0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c8f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c95:	83 c4 10             	add    $0x10,%esp
80106c98:	83 c8 07             	or     $0x7,%eax
80106c9b:	89 06                	mov    %eax,(%esi)
80106c9d:	eb b5                	jmp    80106c54 <walkpgdir+0x24>
80106c9f:	90                   	nop
}
80106ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ca3:	31 c0                	xor    %eax,%eax
}
80106ca5:	5b                   	pop    %ebx
80106ca6:	5e                   	pop    %esi
80106ca7:	5f                   	pop    %edi
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cb0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106cb6:	89 d3                	mov    %edx,%ebx
80106cb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cbe:	83 ec 1c             	sub    $0x1c,%esp
80106cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cc4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106cc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ccb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cd6:	29 df                	sub    %ebx,%edi
80106cd8:	83 c8 01             	or     $0x1,%eax
80106cdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cde:	eb 15                	jmp    80106cf5 <mappages+0x45>
    if(*pte & PTE_P)
80106ce0:	f6 00 01             	testb  $0x1,(%eax)
80106ce3:	75 45                	jne    80106d2a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ce5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ce8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106ceb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ced:	74 31                	je     80106d20 <mappages+0x70>
      break;
    a += PGSIZE;
80106cef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cf8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106cfd:	89 da                	mov    %ebx,%edx
80106cff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106d02:	e8 29 ff ff ff       	call   80106c30 <walkpgdir>
80106d07:	85 c0                	test   %eax,%eax
80106d09:	75 d5                	jne    80106ce0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d13:	5b                   	pop    %ebx
80106d14:	5e                   	pop    %esi
80106d15:	5f                   	pop    %edi
80106d16:	5d                   	pop    %ebp
80106d17:	c3                   	ret    
80106d18:	90                   	nop
80106d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d23:	31 c0                	xor    %eax,%eax
}
80106d25:	5b                   	pop    %ebx
80106d26:	5e                   	pop    %esi
80106d27:	5f                   	pop    %edi
80106d28:	5d                   	pop    %ebp
80106d29:	c3                   	ret    
      panic("remap");
80106d2a:	83 ec 0c             	sub    $0xc,%esp
80106d2d:	68 2c 7f 10 80       	push   $0x80107f2c
80106d32:	e8 59 96 ff ff       	call   80100390 <panic>
80106d37:	89 f6                	mov    %esi,%esi
80106d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d4c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106d4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d54:	83 ec 1c             	sub    $0x1c,%esp
80106d57:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d5a:	39 d3                	cmp    %edx,%ebx
80106d5c:	73 66                	jae    80106dc4 <deallocuvm.part.0+0x84>
80106d5e:	89 d6                	mov    %edx,%esi
80106d60:	eb 3d                	jmp    80106d9f <deallocuvm.part.0+0x5f>
80106d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106d68:	8b 10                	mov    (%eax),%edx
80106d6a:	f6 c2 01             	test   $0x1,%dl
80106d6d:	74 26                	je     80106d95 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d6f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d75:	74 58                	je     80106dcf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d77:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d7a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106d83:	52                   	push   %edx
80106d84:	e8 97 b5 ff ff       	call   80102320 <kfree>
      *pte = 0;
80106d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d8c:	83 c4 10             	add    $0x10,%esp
80106d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d95:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d9b:	39 f3                	cmp    %esi,%ebx
80106d9d:	73 25                	jae    80106dc4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d9f:	31 c9                	xor    %ecx,%ecx
80106da1:	89 da                	mov    %ebx,%edx
80106da3:	89 f8                	mov    %edi,%eax
80106da5:	e8 86 fe ff ff       	call   80106c30 <walkpgdir>
    if(!pte)
80106daa:	85 c0                	test   %eax,%eax
80106dac:	75 ba                	jne    80106d68 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106dae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106db4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106dba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dc0:	39 f3                	cmp    %esi,%ebx
80106dc2:	72 db                	jb     80106d9f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dca:	5b                   	pop    %ebx
80106dcb:	5e                   	pop    %esi
80106dcc:	5f                   	pop    %edi
80106dcd:	5d                   	pop    %ebp
80106dce:	c3                   	ret    
        panic("kfree");
80106dcf:	83 ec 0c             	sub    $0xc,%esp
80106dd2:	68 c6 77 10 80       	push   $0x801077c6
80106dd7:	e8 b4 95 ff ff       	call   80100390 <panic>
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106de0 <seginit>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106de6:	e8 45 ca ff ff       	call   80103830 <cpuid>
80106deb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106df1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106df6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dfa:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80106e01:	ff 00 00 
80106e04:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80106e0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e0e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80106e15:	ff 00 00 
80106e18:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80106e1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e22:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106e29:	ff 00 00 
80106e2c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106e33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e36:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80106e3d:	ff 00 00 
80106e40:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106e47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e4a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80106e4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e53:	c1 e8 10             	shr    $0x10,%eax
80106e56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e5d:	0f 01 10             	lgdtl  (%eax)
}
80106e60:	c9                   	leave  
80106e61:	c3                   	ret    
80106e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e70:	a1 c4 68 11 80       	mov    0x801168c4,%eax
{
80106e75:	55                   	push   %ebp
80106e76:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e78:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e7d:	0f 22 d8             	mov    %eax,%cr3
}
80106e80:	5d                   	pop    %ebp
80106e81:	c3                   	ret    
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e90 <switchuvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e9c:	85 db                	test   %ebx,%ebx
80106e9e:	0f 84 cb 00 00 00    	je     80106f6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ea4:	8b 43 08             	mov    0x8(%ebx),%eax
80106ea7:	85 c0                	test   %eax,%eax
80106ea9:	0f 84 da 00 00 00    	je     80106f89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eaf:	8b 43 04             	mov    0x4(%ebx),%eax
80106eb2:	85 c0                	test   %eax,%eax
80106eb4:	0f 84 c2 00 00 00    	je     80106f7c <switchuvm+0xec>
  pushcli();
80106eba:	e8 51 da ff ff       	call   80104910 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ebf:	e8 ec c8 ff ff       	call   801037b0 <mycpu>
80106ec4:	89 c6                	mov    %eax,%esi
80106ec6:	e8 e5 c8 ff ff       	call   801037b0 <mycpu>
80106ecb:	89 c7                	mov    %eax,%edi
80106ecd:	e8 de c8 ff ff       	call   801037b0 <mycpu>
80106ed2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ed5:	83 c7 08             	add    $0x8,%edi
80106ed8:	e8 d3 c8 ff ff       	call   801037b0 <mycpu>
80106edd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ee0:	83 c0 08             	add    $0x8,%eax
80106ee3:	ba 67 00 00 00       	mov    $0x67,%edx
80106ee8:	c1 e8 18             	shr    $0x18,%eax
80106eeb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106ef2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106ef9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106eff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f04:	83 c1 08             	add    $0x8,%ecx
80106f07:	c1 e9 10             	shr    $0x10,%ecx
80106f0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106f10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106f21:	e8 8a c8 ff ff       	call   801037b0 <mycpu>
80106f26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f2d:	e8 7e c8 ff ff       	call   801037b0 <mycpu>
80106f32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f36:	8b 73 08             	mov    0x8(%ebx),%esi
80106f39:	e8 72 c8 ff ff       	call   801037b0 <mycpu>
80106f3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f47:	e8 64 c8 ff ff       	call   801037b0 <mycpu>
80106f4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f50:	b8 28 00 00 00       	mov    $0x28,%eax
80106f55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f58:	8b 43 04             	mov    0x4(%ebx),%eax
80106f5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f60:	0f 22 d8             	mov    %eax,%cr3
}
80106f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f66:	5b                   	pop    %ebx
80106f67:	5e                   	pop    %esi
80106f68:	5f                   	pop    %edi
80106f69:	5d                   	pop    %ebp
  popcli();
80106f6a:	e9 a1 da ff ff       	jmp    80104a10 <popcli>
    panic("switchuvm: no process");
80106f6f:	83 ec 0c             	sub    $0xc,%esp
80106f72:	68 32 7f 10 80       	push   $0x80107f32
80106f77:	e8 14 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106f7c:	83 ec 0c             	sub    $0xc,%esp
80106f7f:	68 5d 7f 10 80       	push   $0x80107f5d
80106f84:	e8 07 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106f89:	83 ec 0c             	sub    $0xc,%esp
80106f8c:	68 48 7f 10 80       	push   $0x80107f48
80106f91:	e8 fa 93 ff ff       	call   80100390 <panic>
80106f96:	8d 76 00             	lea    0x0(%esi),%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <inituvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
80106fa9:	8b 75 10             	mov    0x10(%ebp),%esi
80106fac:	8b 45 08             	mov    0x8(%ebp),%eax
80106faf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106fb2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106fb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fbb:	77 49                	ja     80107006 <inituvm+0x66>
  mem = kalloc();
80106fbd:	e8 1e b5 ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106fc2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106fc5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106fc7:	68 00 10 00 00       	push   $0x1000
80106fcc:	6a 00                	push   $0x0
80106fce:	50                   	push   %eax
80106fcf:	e8 fc da ff ff       	call   80104ad0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106fd4:	58                   	pop    %eax
80106fd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fdb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fe0:	5a                   	pop    %edx
80106fe1:	6a 06                	push   $0x6
80106fe3:	50                   	push   %eax
80106fe4:	31 d2                	xor    %edx,%edx
80106fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fe9:	e8 c2 fc ff ff       	call   80106cb0 <mappages>
  memmove(mem, init, sz);
80106fee:	89 75 10             	mov    %esi,0x10(%ebp)
80106ff1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ff4:	83 c4 10             	add    $0x10,%esp
80106ff7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffd:	5b                   	pop    %ebx
80106ffe:	5e                   	pop    %esi
80106fff:	5f                   	pop    %edi
80107000:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107001:	e9 7a db ff ff       	jmp    80104b80 <memmove>
    panic("inituvm: more than a page");
80107006:	83 ec 0c             	sub    $0xc,%esp
80107009:	68 71 7f 10 80       	push   $0x80107f71
8010700e:	e8 7d 93 ff ff       	call   80100390 <panic>
80107013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107020 <loaduvm>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107029:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107030:	0f 85 91 00 00 00    	jne    801070c7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107036:	8b 75 18             	mov    0x18(%ebp),%esi
80107039:	31 db                	xor    %ebx,%ebx
8010703b:	85 f6                	test   %esi,%esi
8010703d:	75 1a                	jne    80107059 <loaduvm+0x39>
8010703f:	eb 6f                	jmp    801070b0 <loaduvm+0x90>
80107041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107048:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010704e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107054:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107057:	76 57                	jbe    801070b0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107059:	8b 55 0c             	mov    0xc(%ebp),%edx
8010705c:	8b 45 08             	mov    0x8(%ebp),%eax
8010705f:	31 c9                	xor    %ecx,%ecx
80107061:	01 da                	add    %ebx,%edx
80107063:	e8 c8 fb ff ff       	call   80106c30 <walkpgdir>
80107068:	85 c0                	test   %eax,%eax
8010706a:	74 4e                	je     801070ba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010706c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010706e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107071:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107076:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010707b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107081:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107084:	01 d9                	add    %ebx,%ecx
80107086:	05 00 00 00 80       	add    $0x80000000,%eax
8010708b:	57                   	push   %edi
8010708c:	51                   	push   %ecx
8010708d:	50                   	push   %eax
8010708e:	ff 75 10             	pushl  0x10(%ebp)
80107091:	e8 da a8 ff ff       	call   80101970 <readi>
80107096:	83 c4 10             	add    $0x10,%esp
80107099:	39 f8                	cmp    %edi,%eax
8010709b:	74 ab                	je     80107048 <loaduvm+0x28>
}
8010709d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070a5:	5b                   	pop    %ebx
801070a6:	5e                   	pop    %esi
801070a7:	5f                   	pop    %edi
801070a8:	5d                   	pop    %ebp
801070a9:	c3                   	ret    
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070b3:	31 c0                	xor    %eax,%eax
}
801070b5:	5b                   	pop    %ebx
801070b6:	5e                   	pop    %esi
801070b7:	5f                   	pop    %edi
801070b8:	5d                   	pop    %ebp
801070b9:	c3                   	ret    
      panic("loaduvm: address should exist");
801070ba:	83 ec 0c             	sub    $0xc,%esp
801070bd:	68 8b 7f 10 80       	push   $0x80107f8b
801070c2:	e8 c9 92 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801070c7:	83 ec 0c             	sub    $0xc,%esp
801070ca:	68 2c 80 10 80       	push   $0x8010802c
801070cf:	e8 bc 92 ff ff       	call   80100390 <panic>
801070d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070e0 <allocuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801070e9:	8b 7d 10             	mov    0x10(%ebp),%edi
801070ec:	85 ff                	test   %edi,%edi
801070ee:	0f 88 8e 00 00 00    	js     80107182 <allocuvm+0xa2>
  if(newsz < oldsz)
801070f4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801070f7:	0f 82 93 00 00 00    	jb     80107190 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801070fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107100:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107106:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010710c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010710f:	0f 86 7e 00 00 00    	jbe    80107193 <allocuvm+0xb3>
80107115:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107118:	8b 7d 08             	mov    0x8(%ebp),%edi
8010711b:	eb 42                	jmp    8010715f <allocuvm+0x7f>
8010711d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107120:	83 ec 04             	sub    $0x4,%esp
80107123:	68 00 10 00 00       	push   $0x1000
80107128:	6a 00                	push   $0x0
8010712a:	50                   	push   %eax
8010712b:	e8 a0 d9 ff ff       	call   80104ad0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107130:	58                   	pop    %eax
80107131:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107137:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010713c:	5a                   	pop    %edx
8010713d:	6a 06                	push   $0x6
8010713f:	50                   	push   %eax
80107140:	89 da                	mov    %ebx,%edx
80107142:	89 f8                	mov    %edi,%eax
80107144:	e8 67 fb ff ff       	call   80106cb0 <mappages>
80107149:	83 c4 10             	add    $0x10,%esp
8010714c:	85 c0                	test   %eax,%eax
8010714e:	78 50                	js     801071a0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107150:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107156:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107159:	0f 86 81 00 00 00    	jbe    801071e0 <allocuvm+0x100>
    mem = kalloc();
8010715f:	e8 7c b3 ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
80107164:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107166:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107168:	75 b6                	jne    80107120 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 a9 7f 10 80       	push   $0x80107fa9
80107172:	e8 e9 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107177:	83 c4 10             	add    $0x10,%esp
8010717a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010717d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107180:	77 6e                	ja     801071f0 <allocuvm+0x110>
}
80107182:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107185:	31 ff                	xor    %edi,%edi
}
80107187:	89 f8                	mov    %edi,%eax
80107189:	5b                   	pop    %ebx
8010718a:	5e                   	pop    %esi
8010718b:	5f                   	pop    %edi
8010718c:	5d                   	pop    %ebp
8010718d:	c3                   	ret    
8010718e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107190:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107196:	89 f8                	mov    %edi,%eax
80107198:	5b                   	pop    %ebx
80107199:	5e                   	pop    %esi
8010719a:	5f                   	pop    %edi
8010719b:	5d                   	pop    %ebp
8010719c:	c3                   	ret    
8010719d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	68 c1 7f 10 80       	push   $0x80107fc1
801071a8:	e8 b3 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801071ad:	83 c4 10             	add    $0x10,%esp
801071b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801071b3:	39 45 10             	cmp    %eax,0x10(%ebp)
801071b6:	76 0d                	jbe    801071c5 <allocuvm+0xe5>
801071b8:	89 c1                	mov    %eax,%ecx
801071ba:	8b 55 10             	mov    0x10(%ebp),%edx
801071bd:	8b 45 08             	mov    0x8(%ebp),%eax
801071c0:	e8 7b fb ff ff       	call   80106d40 <deallocuvm.part.0>
      kfree(mem);
801071c5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801071c8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801071ca:	56                   	push   %esi
801071cb:	e8 50 b1 ff ff       	call   80102320 <kfree>
      return 0;
801071d0:	83 c4 10             	add    $0x10,%esp
}
801071d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d6:	89 f8                	mov    %edi,%eax
801071d8:	5b                   	pop    %ebx
801071d9:	5e                   	pop    %esi
801071da:	5f                   	pop    %edi
801071db:	5d                   	pop    %ebp
801071dc:	c3                   	ret    
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
801071e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801071e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e6:	5b                   	pop    %ebx
801071e7:	89 f8                	mov    %edi,%eax
801071e9:	5e                   	pop    %esi
801071ea:	5f                   	pop    %edi
801071eb:	5d                   	pop    %ebp
801071ec:	c3                   	ret    
801071ed:	8d 76 00             	lea    0x0(%esi),%esi
801071f0:	89 c1                	mov    %eax,%ecx
801071f2:	8b 55 10             	mov    0x10(%ebp),%edx
801071f5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801071f8:	31 ff                	xor    %edi,%edi
801071fa:	e8 41 fb ff ff       	call   80106d40 <deallocuvm.part.0>
801071ff:	eb 92                	jmp    80107193 <allocuvm+0xb3>
80107201:	eb 0d                	jmp    80107210 <deallocuvm>
80107203:	90                   	nop
80107204:	90                   	nop
80107205:	90                   	nop
80107206:	90                   	nop
80107207:	90                   	nop
80107208:	90                   	nop
80107209:	90                   	nop
8010720a:	90                   	nop
8010720b:	90                   	nop
8010720c:	90                   	nop
8010720d:	90                   	nop
8010720e:	90                   	nop
8010720f:	90                   	nop

80107210 <deallocuvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	8b 55 0c             	mov    0xc(%ebp),%edx
80107216:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107219:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010721c:	39 d1                	cmp    %edx,%ecx
8010721e:	73 10                	jae    80107230 <deallocuvm+0x20>
}
80107220:	5d                   	pop    %ebp
80107221:	e9 1a fb ff ff       	jmp    80106d40 <deallocuvm.part.0>
80107226:	8d 76 00             	lea    0x0(%esi),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107230:	89 d0                	mov    %edx,%eax
80107232:	5d                   	pop    %ebp
80107233:	c3                   	ret    
80107234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010723a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107240 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010724c:	85 f6                	test   %esi,%esi
8010724e:	74 59                	je     801072a9 <freevm+0x69>
80107250:	31 c9                	xor    %ecx,%ecx
80107252:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107257:	89 f0                	mov    %esi,%eax
80107259:	e8 e2 fa ff ff       	call   80106d40 <deallocuvm.part.0>
8010725e:	89 f3                	mov    %esi,%ebx
80107260:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107266:	eb 0f                	jmp    80107277 <freevm+0x37>
80107268:	90                   	nop
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107270:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107273:	39 fb                	cmp    %edi,%ebx
80107275:	74 23                	je     8010729a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107277:	8b 03                	mov    (%ebx),%eax
80107279:	a8 01                	test   $0x1,%al
8010727b:	74 f3                	je     80107270 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010727d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107282:	83 ec 0c             	sub    $0xc,%esp
80107285:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107288:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010728d:	50                   	push   %eax
8010728e:	e8 8d b0 ff ff       	call   80102320 <kfree>
80107293:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107296:	39 fb                	cmp    %edi,%ebx
80107298:	75 dd                	jne    80107277 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010729a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010729d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a0:	5b                   	pop    %ebx
801072a1:	5e                   	pop    %esi
801072a2:	5f                   	pop    %edi
801072a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072a4:	e9 77 b0 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
801072a9:	83 ec 0c             	sub    $0xc,%esp
801072ac:	68 dd 7f 10 80       	push   $0x80107fdd
801072b1:	e8 da 90 ff ff       	call   80100390 <panic>
801072b6:	8d 76 00             	lea    0x0(%esi),%esi
801072b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072c0 <setupkvm>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	56                   	push   %esi
801072c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801072c5:	e8 16 b2 ff ff       	call   801024e0 <kalloc>
801072ca:	85 c0                	test   %eax,%eax
801072cc:	89 c6                	mov    %eax,%esi
801072ce:	74 42                	je     80107312 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801072d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801072d8:	68 00 10 00 00       	push   $0x1000
801072dd:	6a 00                	push   $0x0
801072df:	50                   	push   %eax
801072e0:	e8 eb d7 ff ff       	call   80104ad0 <memset>
801072e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072eb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072ee:	83 ec 08             	sub    $0x8,%esp
801072f1:	8b 13                	mov    (%ebx),%edx
801072f3:	ff 73 0c             	pushl  0xc(%ebx)
801072f6:	50                   	push   %eax
801072f7:	29 c1                	sub    %eax,%ecx
801072f9:	89 f0                	mov    %esi,%eax
801072fb:	e8 b0 f9 ff ff       	call   80106cb0 <mappages>
80107300:	83 c4 10             	add    $0x10,%esp
80107303:	85 c0                	test   %eax,%eax
80107305:	78 19                	js     80107320 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107307:	83 c3 10             	add    $0x10,%ebx
8010730a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107310:	75 d6                	jne    801072e8 <setupkvm+0x28>
}
80107312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107315:	89 f0                	mov    %esi,%eax
80107317:	5b                   	pop    %ebx
80107318:	5e                   	pop    %esi
80107319:	5d                   	pop    %ebp
8010731a:	c3                   	ret    
8010731b:	90                   	nop
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	56                   	push   %esi
      return 0;
80107324:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107326:	e8 15 ff ff ff       	call   80107240 <freevm>
      return 0;
8010732b:	83 c4 10             	add    $0x10,%esp
}
8010732e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107331:	89 f0                	mov    %esi,%eax
80107333:	5b                   	pop    %ebx
80107334:	5e                   	pop    %esi
80107335:	5d                   	pop    %ebp
80107336:	c3                   	ret    
80107337:	89 f6                	mov    %esi,%esi
80107339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107340 <kvmalloc>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107346:	e8 75 ff ff ff       	call   801072c0 <setupkvm>
8010734b:	a3 c4 68 11 80       	mov    %eax,0x801168c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107350:	05 00 00 00 80       	add    $0x80000000,%eax
80107355:	0f 22 d8             	mov    %eax,%cr3
}
80107358:	c9                   	leave  
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107360:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107361:	31 c9                	xor    %ecx,%ecx
{
80107363:	89 e5                	mov    %esp,%ebp
80107365:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736b:	8b 45 08             	mov    0x8(%ebp),%eax
8010736e:	e8 bd f8 ff ff       	call   80106c30 <walkpgdir>
  if(pte == 0)
80107373:	85 c0                	test   %eax,%eax
80107375:	74 05                	je     8010737c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107377:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010737a:	c9                   	leave  
8010737b:	c3                   	ret    
    panic("clearpteu");
8010737c:	83 ec 0c             	sub    $0xc,%esp
8010737f:	68 ee 7f 10 80       	push   $0x80107fee
80107384:	e8 07 90 ff ff       	call   80100390 <panic>
80107389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107390 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107399:	e8 22 ff ff ff       	call   801072c0 <setupkvm>
8010739e:	85 c0                	test   %eax,%eax
801073a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073a3:	0f 84 a0 00 00 00    	je     80107449 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073ac:	85 c9                	test   %ecx,%ecx
801073ae:	0f 84 95 00 00 00    	je     80107449 <copyuvm+0xb9>
801073b4:	31 f6                	xor    %esi,%esi
801073b6:	eb 4e                	jmp    80107406 <copyuvm+0x76>
801073b8:	90                   	nop
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073c0:	83 ec 04             	sub    $0x4,%esp
801073c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073cc:	68 00 10 00 00       	push   $0x1000
801073d1:	57                   	push   %edi
801073d2:	50                   	push   %eax
801073d3:	e8 a8 d7 ff ff       	call   80104b80 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801073d8:	58                   	pop    %eax
801073d9:	5a                   	pop    %edx
801073da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073e5:	53                   	push   %ebx
801073e6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801073ec:	52                   	push   %edx
801073ed:	89 f2                	mov    %esi,%edx
801073ef:	e8 bc f8 ff ff       	call   80106cb0 <mappages>
801073f4:	83 c4 10             	add    $0x10,%esp
801073f7:	85 c0                	test   %eax,%eax
801073f9:	78 39                	js     80107434 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
801073fb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107401:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107404:	76 43                	jbe    80107449 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107406:	8b 45 08             	mov    0x8(%ebp),%eax
80107409:	31 c9                	xor    %ecx,%ecx
8010740b:	89 f2                	mov    %esi,%edx
8010740d:	e8 1e f8 ff ff       	call   80106c30 <walkpgdir>
80107412:	85 c0                	test   %eax,%eax
80107414:	74 3e                	je     80107454 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107416:	8b 18                	mov    (%eax),%ebx
80107418:	f6 c3 01             	test   $0x1,%bl
8010741b:	74 44                	je     80107461 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010741d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010741f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107425:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010742b:	e8 b0 b0 ff ff       	call   801024e0 <kalloc>
80107430:	85 c0                	test   %eax,%eax
80107432:	75 8c                	jne    801073c0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107434:	83 ec 0c             	sub    $0xc,%esp
80107437:	ff 75 e0             	pushl  -0x20(%ebp)
8010743a:	e8 01 fe ff ff       	call   80107240 <freevm>
  return 0;
8010743f:	83 c4 10             	add    $0x10,%esp
80107442:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107449:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010744f:	5b                   	pop    %ebx
80107450:	5e                   	pop    %esi
80107451:	5f                   	pop    %edi
80107452:	5d                   	pop    %ebp
80107453:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107454:	83 ec 0c             	sub    $0xc,%esp
80107457:	68 f8 7f 10 80       	push   $0x80107ff8
8010745c:	e8 2f 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107461:	83 ec 0c             	sub    $0xc,%esp
80107464:	68 12 80 10 80       	push   $0x80108012
80107469:	e8 22 8f ff ff       	call   80100390 <panic>
8010746e:	66 90                	xchg   %ax,%ax

80107470 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107470:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107471:	31 c9                	xor    %ecx,%ecx
{
80107473:	89 e5                	mov    %esp,%ebp
80107475:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107478:	8b 55 0c             	mov    0xc(%ebp),%edx
8010747b:	8b 45 08             	mov    0x8(%ebp),%eax
8010747e:	e8 ad f7 ff ff       	call   80106c30 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107483:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107485:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107486:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010748d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107490:	05 00 00 00 80       	add    $0x80000000,%eax
80107495:	83 fa 05             	cmp    $0x5,%edx
80107498:	ba 00 00 00 00       	mov    $0x0,%edx
8010749d:	0f 45 c2             	cmovne %edx,%eax
}
801074a0:	c3                   	ret    
801074a1:	eb 0d                	jmp    801074b0 <copyout>
801074a3:	90                   	nop
801074a4:	90                   	nop
801074a5:	90                   	nop
801074a6:	90                   	nop
801074a7:	90                   	nop
801074a8:	90                   	nop
801074a9:	90                   	nop
801074aa:	90                   	nop
801074ab:	90                   	nop
801074ac:	90                   	nop
801074ad:	90                   	nop
801074ae:	90                   	nop
801074af:	90                   	nop

801074b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
801074b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801074bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801074bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074c2:	85 db                	test   %ebx,%ebx
801074c4:	75 40                	jne    80107506 <copyout+0x56>
801074c6:	eb 70                	jmp    80107538 <copyout+0x88>
801074c8:	90                   	nop
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801074d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074d3:	89 f1                	mov    %esi,%ecx
801074d5:	29 d1                	sub    %edx,%ecx
801074d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801074dd:	39 d9                	cmp    %ebx,%ecx
801074df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074e2:	29 f2                	sub    %esi,%edx
801074e4:	83 ec 04             	sub    $0x4,%esp
801074e7:	01 d0                	add    %edx,%eax
801074e9:	51                   	push   %ecx
801074ea:	57                   	push   %edi
801074eb:	50                   	push   %eax
801074ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801074ef:	e8 8c d6 ff ff       	call   80104b80 <memmove>
    len -= n;
    buf += n;
801074f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801074f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801074fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107500:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107502:	29 cb                	sub    %ecx,%ebx
80107504:	74 32                	je     80107538 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107506:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107508:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010750b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010750e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107514:	56                   	push   %esi
80107515:	ff 75 08             	pushl  0x8(%ebp)
80107518:	e8 53 ff ff ff       	call   80107470 <uva2ka>
    if(pa0 == 0)
8010751d:	83 c4 10             	add    $0x10,%esp
80107520:	85 c0                	test   %eax,%eax
80107522:	75 ac                	jne    801074d0 <copyout+0x20>
  }
  return 0;
}
80107524:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010752c:	5b                   	pop    %ebx
8010752d:	5e                   	pop    %esi
8010752e:	5f                   	pop    %edi
8010752f:	5d                   	pop    %ebp
80107530:	c3                   	ret    
80107531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010753b:	31 c0                	xor    %eax,%eax
}
8010753d:	5b                   	pop    %ebx
8010753e:	5e                   	pop    %esi
8010753f:	5f                   	pop    %edi
80107540:	5d                   	pop    %ebp
80107541:	c3                   	ret    
