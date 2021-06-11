
_threadtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    
}

/************************** main() *****************************/
int main(int argc, char *argv[])
{ 
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
   
    tc1();
  11:	e8 ea 00 00 00       	call   100 <tc1>
       
    

   tc2();
  16:	e8 85 01 00 00       	call   1a0 <tc2>


    tc3();      
  1b:	e8 10 02 00 00       	call   230 <tc3>
      
    exit();
  20:	e8 0d 05 00 00       	call   532 <exit>
  25:	66 90                	xchg   %ax,%ax
  27:	66 90                	xchg   %ax,%ax
  29:	66 90                	xchg   %ax,%ax
  2b:	66 90                	xchg   %ax,%ax
  2d:	66 90                	xchg   %ax,%ax
  2f:	90                   	nop

00000030 <tfunc>:
void * tfunc(void *arg){
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 ec 14             	sub    $0x14,%esp
    xthread_exit((void *)0);
  36:	6a 00                	push   $0x0
  38:	e8 13 0a 00 00       	call   a50 <xthread_exit>
}
  3d:	31 c0                	xor    %eax,%eax
  3f:	c9                   	leave  
  40:	c3                   	ret    
  41:	eb 0d                	jmp    50 <tc2_func>
  43:	90                   	nop
  44:	90                   	nop
  45:	90                   	nop
  46:	90                   	nop
  47:	90                   	nop
  48:	90                   	nop
  49:	90                   	nop
  4a:	90                   	nop
  4b:	90                   	nop
  4c:	90                   	nop
  4d:	90                   	nop
  4e:	90                   	nop
  4f:	90                   	nop

00000050 <tc2_func>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 14             	sub    $0x14,%esp
    sleep(100); // 1 second    
  56:	6a 64                	push   $0x64
  58:	e8 65 05 00 00       	call   5c2 <sleep>
}
  5d:	b8 23 01 00 00       	mov    $0x123,%eax
  62:	c9                   	leave  
  63:	c3                   	ret    
  64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000070 <tc_func2>:
void * tc_func2(void *arg){
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	83 ec 10             	sub    $0x10,%esp
  77:	8b 5d 08             	mov    0x8(%ebp),%ebx
    count++;
  7a:	83 05 58 10 00 00 01 	addl   $0x1,0x1058
    sleep(100);
  81:	6a 64                	push   $0x64
  83:	e8 3a 05 00 00       	call   5c2 <sleep>
    printf(1,"Child thread %d: count=%d\n",(int)arg,count);
  88:	ff 35 58 10 00 00    	pushl  0x1058
  8e:	53                   	push   %ebx
  8f:	68 8c 0a 00 00       	push   $0xa8c
  94:	6a 01                	push   $0x1
  96:	e8 15 06 00 00       	call   6b0 <printf>
    return (void *) ((int)arg)+1;
  9b:	8d 43 01             	lea    0x1(%ebx),%eax
}
  9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a1:	c9                   	leave  
  a2:	c3                   	ret    
  a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000b0 <tc_func1>:
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	83 ec 10             	sub    $0x10,%esp
  b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
   count++;
  ba:	83 05 58 10 00 00 01 	addl   $0x1,0x1058
   sleep(100); // 1 second
  c1:	6a 64                	push   $0x64
  c3:	e8 fa 04 00 00       	call   5c2 <sleep>
   printf(1, "Child thread %d: count=%d\n", (int)arg, count);
  c8:	ff 35 58 10 00 00    	pushl  0x1058
  ce:	53                   	push   %ebx
  cf:	68 8c 0a 00 00       	push   $0xa8c
    int n = a + b;
  d4:	83 c3 01             	add    $0x1,%ebx
   printf(1, "Child thread %d: count=%d\n", (int)arg, count);
  d7:	6a 01                	push   $0x1
  d9:	e8 d2 05 00 00       	call   6b0 <printf>
    xthread_exit((void *)n);
  de:	83 c4 14             	add    $0x14,%esp
  e1:	53                   	push   %ebx
  e2:	e8 69 09 00 00       	call   a50 <xthread_exit>
}
  e7:	31 c0                	xor    %eax,%eax
  e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ec:	c9                   	leave  
  ed:	c3                   	ret    
  ee:	66 90                	xchg   %ax,%ax

000000f0 <add_then_exit>:
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
    xthread_exit((void *)n);
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	01 45 08             	add    %eax,0x8(%ebp)
}
  f9:	5d                   	pop    %ebp
    xthread_exit((void *)n);
  fa:	e9 51 09 00 00       	jmp    a50 <xthread_exit>
  ff:	90                   	nop

00000100 <tc1>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 20             	sub    $0x20,%esp
    printf(1, "\n-------------------- Test Return Value --------------------\n");
 106:	68 bc 0a 00 00       	push   $0xabc
 10b:	6a 01                	push   $0x1
    int tid_1 = 0, tid_2 = 0, ret1,ret2;
 10d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 114:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    printf(1, "\n-------------------- Test Return Value --------------------\n");
 11b:	e8 90 05 00 00       	call   6b0 <printf>
    xthread_create(&tid_1, tc_func1, (void *)1);
 120:	8d 45 e8             	lea    -0x18(%ebp),%eax
 123:	83 c4 0c             	add    $0xc,%esp
    count = 0;
 126:	c7 05 58 10 00 00 00 	movl   $0x0,0x1058
 12d:	00 00 00 
    xthread_create(&tid_1, tc_func1, (void *)1);
 130:	6a 01                	push   $0x1
 132:	68 b0 00 00 00       	push   $0xb0
 137:	50                   	push   %eax
 138:	e8 d3 08 00 00       	call   a10 <xthread_create>
    xthread_create(&tid_2, tc_func2, (void *)2);
 13d:	8d 45 ec             	lea    -0x14(%ebp),%eax
 140:	83 c4 0c             	add    $0xc,%esp
 143:	6a 02                	push   $0x2
 145:	68 70 00 00 00       	push   $0x70
 14a:	50                   	push   %eax
 14b:	e8 c0 08 00 00       	call   a10 <xthread_create>
    xthread_join(tid_1,(void **)&ret1);
 150:	58                   	pop    %eax
 151:	8d 45 f0             	lea    -0x10(%ebp),%eax
    count++;
 154:	83 05 58 10 00 00 01 	addl   $0x1,0x1058
    xthread_join(tid_1,(void **)&ret1);
 15b:	5a                   	pop    %edx
 15c:	50                   	push   %eax
 15d:	ff 75 e8             	pushl  -0x18(%ebp)
 160:	e8 fb 08 00 00       	call   a60 <xthread_join>
    printf(1, "Main thread: thread 1 returned %d\n",ret1);
 165:	83 c4 0c             	add    $0xc,%esp
 168:	ff 75 f0             	pushl  -0x10(%ebp)
 16b:	68 fc 0a 00 00       	push   $0xafc
 170:	6a 01                	push   $0x1
 172:	e8 39 05 00 00       	call   6b0 <printf>
    xthread_join(tid_2,(void **)&ret2);
 177:	59                   	pop    %ecx
 178:	58                   	pop    %eax
 179:	8d 45 f4             	lea    -0xc(%ebp),%eax
 17c:	50                   	push   %eax
 17d:	ff 75 ec             	pushl  -0x14(%ebp)
 180:	e8 db 08 00 00       	call   a60 <xthread_join>
    printf(1, "Main thread: thread 2 returned %d\n",ret2);
 185:	83 c4 0c             	add    $0xc,%esp
 188:	ff 75 f4             	pushl  -0xc(%ebp)
 18b:	68 20 0b 00 00       	push   $0xb20
 190:	6a 01                	push   $0x1
 192:	e8 19 05 00 00       	call   6b0 <printf>
}
 197:	83 c4 10             	add    $0x10,%esp
 19a:	c9                   	leave  
 19b:	c3                   	ret    
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <tc2>:
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
 1a5:	83 ec 18             	sub    $0x18,%esp
    printf(1, "\n-------------------- Test Stack Space --------------------\n");
 1a8:	68 44 0b 00 00       	push   $0xb44
 1ad:	6a 01                	push   $0x1
 1af:	e8 fc 04 00 00       	call   6b0 <printf>
    ptr1 = malloc(1);
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 50 07 00 00       	call   910 <malloc>
 1c0:	89 c6                	mov    %eax,%esi
    xthread_create(&tid, tc2_func, (void *)0);
 1c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
 1c5:	83 c4 0c             	add    $0xc,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	68 50 00 00 00       	push   $0x50
 1cf:	50                   	push   %eax
 1d0:	e8 3b 08 00 00       	call   a10 <xthread_create>
    xthread_join(tid, &ret_val);
 1d5:	58                   	pop    %eax
 1d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 1d9:	5a                   	pop    %edx
 1da:	50                   	push   %eax
 1db:	ff 75 f0             	pushl  -0x10(%ebp)
 1de:	e8 7d 08 00 00       	call   a60 <xthread_join>
    ptr2 = malloc(1);
 1e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ea:	e8 21 07 00 00       	call   910 <malloc>
 1ef:	89 c3                	mov    %eax,%ebx
    printf(1, "ptr1 - ptr2 = %d\nReturn value %x\n", ptr1 - ptr2,ret_val);      
 1f1:	89 f0                	mov    %esi,%eax
 1f3:	ff 75 f4             	pushl  -0xc(%ebp)
 1f6:	29 d8                	sub    %ebx,%eax
 1f8:	50                   	push   %eax
 1f9:	68 84 0b 00 00       	push   $0xb84
 1fe:	6a 01                	push   $0x1
 200:	e8 ab 04 00 00       	call   6b0 <printf>
    if (ptr1)
 205:	83 c4 20             	add    $0x20,%esp
 208:	85 f6                	test   %esi,%esi
 20a:	74 0c                	je     218 <tc2+0x78>
        free(ptr1);
 20c:	83 ec 0c             	sub    $0xc,%esp
 20f:	56                   	push   %esi
 210:	e8 6b 06 00 00       	call   880 <free>
 215:	83 c4 10             	add    $0x10,%esp
    if (ptr2)
 218:	85 db                	test   %ebx,%ebx
 21a:	74 0c                	je     228 <tc2+0x88>
        free(ptr2);    
 21c:	83 ec 0c             	sub    $0xc,%esp
 21f:	53                   	push   %ebx
 220:	e8 5b 06 00 00       	call   880 <free>
 225:	83 c4 10             	add    $0x10,%esp
}
 228:	8d 65 f8             	lea    -0x8(%ebp),%esp
 22b:	5b                   	pop    %ebx
 22c:	5e                   	pop    %esi
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
 22f:	90                   	nop

00000230 <tc3>:
void tc3(void){
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
 235:	83 ec 18             	sub    $0x18,%esp
    printf(1, "\n-------------------- Test Thread Count --------------------\n");
 238:	68 a8 0b 00 00       	push   $0xba8
 23d:	6a 01                	push   $0x1
 23f:	e8 6c 04 00 00       	call   6b0 <printf>
    if(fork()==0){
 244:	e8 e1 02 00 00       	call   52a <fork>
 249:	83 c4 10             	add    $0x10,%esp
 24c:	85 c0                	test   %eax,%eax
 24e:	74 44                	je     294 <tc3+0x64>
    wait();
 250:	e8 e5 02 00 00       	call   53a <wait>
    int count=0,tid;
 255:	31 db                	xor    %ebx,%ebx
 257:	8d 75 f4             	lea    -0xc(%ebp),%esi
    while(xthread_create(&tid,tfunc,(void *)0)>0){
 25a:	eb 07                	jmp    263 <tc3+0x33>
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count++;
 260:	83 c3 01             	add    $0x1,%ebx
    while(xthread_create(&tid,tfunc,(void *)0)>0){
 263:	83 ec 04             	sub    $0x4,%esp
 266:	6a 00                	push   $0x0
 268:	68 30 00 00 00       	push   $0x30
 26d:	56                   	push   %esi
 26e:	e8 9d 07 00 00       	call   a10 <xthread_create>
 273:	83 c4 10             	add    $0x10,%esp
 276:	85 c0                	test   %eax,%eax
 278:	7f e6                	jg     260 <tc3+0x30>
    printf(1,"Parent process created %d threads\n",count);
 27a:	83 ec 04             	sub    $0x4,%esp
 27d:	53                   	push   %ebx
 27e:	68 0c 0c 00 00       	push   $0xc0c
 283:	6a 01                	push   $0x1
 285:	e8 26 04 00 00       	call   6b0 <printf>
}
 28a:	83 c4 10             	add    $0x10,%esp
 28d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 290:	5b                   	pop    %ebx
 291:	5e                   	pop    %esi
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	8d 75 f4             	lea    -0xc(%ebp),%esi
 297:	89 c3                	mov    %eax,%ebx
        while(xthread_create(&tid,tfunc,(void *)0)>0){
 299:	83 ec 04             	sub    $0x4,%esp
 29c:	6a 00                	push   $0x0
 29e:	68 30 00 00 00       	push   $0x30
 2a3:	56                   	push   %esi
 2a4:	e8 67 07 00 00       	call   a10 <xthread_create>
 2a9:	83 c4 10             	add    $0x10,%esp
 2ac:	85 c0                	test   %eax,%eax
 2ae:	7e 18                	jle    2c8 <tc3+0x98>
            count++;
 2b0:	83 c3 01             	add    $0x1,%ebx
            printf(1,"Count : %d, tid: %d\n",count, tid);
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	53                   	push   %ebx
 2b7:	68 a7 0a 00 00       	push   $0xaa7
 2bc:	6a 01                	push   $0x1
 2be:	e8 ed 03 00 00       	call   6b0 <printf>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	eb d1                	jmp    299 <tc3+0x69>
        printf(1,"Child process created %d threads\n",count);
 2c8:	50                   	push   %eax
 2c9:	53                   	push   %ebx
 2ca:	68 e8 0b 00 00       	push   $0xbe8
 2cf:	6a 01                	push   $0x1
 2d1:	e8 da 03 00 00       	call   6b0 <printf>
        exit();
 2d6:	e8 57 02 00 00       	call   532 <exit>
 2db:	66 90                	xchg   %ax,%ax
 2dd:	66 90                	xchg   %ax,%ax
 2df:	90                   	nop

000002e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ea:	89 c2                	mov    %eax,%edx
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2f0:	83 c1 01             	add    $0x1,%ecx
 2f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2f7:	83 c2 01             	add    $0x1,%edx
 2fa:	84 db                	test   %bl,%bl
 2fc:	88 5a ff             	mov    %bl,-0x1(%edx)
 2ff:	75 ef                	jne    2f0 <strcpy+0x10>
    ;
  return os;
}
 301:	5b                   	pop    %ebx
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    
 304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 30a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 55 08             	mov    0x8(%ebp),%edx
 317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 31a:	0f b6 02             	movzbl (%edx),%eax
 31d:	0f b6 19             	movzbl (%ecx),%ebx
 320:	84 c0                	test   %al,%al
 322:	75 1c                	jne    340 <strcmp+0x30>
 324:	eb 2a                	jmp    350 <strcmp+0x40>
 326:	8d 76 00             	lea    0x0(%esi),%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 330:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 333:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 336:	83 c1 01             	add    $0x1,%ecx
 339:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 33c:	84 c0                	test   %al,%al
 33e:	74 10                	je     350 <strcmp+0x40>
 340:	38 d8                	cmp    %bl,%al
 342:	74 ec                	je     330 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 344:	29 d8                	sub    %ebx,%eax
}
 346:	5b                   	pop    %ebx
 347:	5d                   	pop    %ebp
 348:	c3                   	ret    
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 350:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 352:	29 d8                	sub    %ebx,%eax
}
 354:	5b                   	pop    %ebx
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	89 f6                	mov    %esi,%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <strlen>:

uint
strlen(char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 366:	80 39 00             	cmpb   $0x0,(%ecx)
 369:	74 15                	je     380 <strlen+0x20>
 36b:	31 d2                	xor    %edx,%edx
 36d:	8d 76 00             	lea    0x0(%esi),%esi
 370:	83 c2 01             	add    $0x1,%edx
 373:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 377:	89 d0                	mov    %edx,%eax
 379:	75 f5                	jne    370 <strlen+0x10>
    ;
  return n;
}
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 380:	31 c0                	xor    %eax,%eax
}
 382:	5d                   	pop    %ebp
 383:	c3                   	ret    
 384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 38a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000390 <memset>:

void*
memset(void *dst, int c, uint n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 397:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 d7                	mov    %edx,%edi
 39f:	fc                   	cld    
 3a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3a2:	89 d0                	mov    %edx,%eax
 3a4:	5f                   	pop    %edi
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
 3a7:	89 f6                	mov    %esi,%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strchr>:

char*
strchr(const char *s, char c)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 3ba:	0f b6 10             	movzbl (%eax),%edx
 3bd:	84 d2                	test   %dl,%dl
 3bf:	74 1d                	je     3de <strchr+0x2e>
    if(*s == c)
 3c1:	38 d3                	cmp    %dl,%bl
 3c3:	89 d9                	mov    %ebx,%ecx
 3c5:	75 0d                	jne    3d4 <strchr+0x24>
 3c7:	eb 17                	jmp    3e0 <strchr+0x30>
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d0:	38 ca                	cmp    %cl,%dl
 3d2:	74 0c                	je     3e0 <strchr+0x30>
  for(; *s; s++)
 3d4:	83 c0 01             	add    $0x1,%eax
 3d7:	0f b6 10             	movzbl (%eax),%edx
 3da:	84 d2                	test   %dl,%dl
 3dc:	75 f2                	jne    3d0 <strchr+0x20>
      return (char*)s;
  return 0;
 3de:	31 c0                	xor    %eax,%eax
}
 3e0:	5b                   	pop    %ebx
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    
 3e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <gets>:

char*
gets(char *buf, int max)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f6:	31 f6                	xor    %esi,%esi
 3f8:	89 f3                	mov    %esi,%ebx
{
 3fa:	83 ec 1c             	sub    $0x1c,%esp
 3fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 400:	eb 2f                	jmp    431 <gets+0x41>
 402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 408:	8d 45 e7             	lea    -0x19(%ebp),%eax
 40b:	83 ec 04             	sub    $0x4,%esp
 40e:	6a 01                	push   $0x1
 410:	50                   	push   %eax
 411:	6a 00                	push   $0x0
 413:	e8 32 01 00 00       	call   54a <read>
    if(cc < 1)
 418:	83 c4 10             	add    $0x10,%esp
 41b:	85 c0                	test   %eax,%eax
 41d:	7e 1c                	jle    43b <gets+0x4b>
      break;
    buf[i++] = c;
 41f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 423:	83 c7 01             	add    $0x1,%edi
 426:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 429:	3c 0a                	cmp    $0xa,%al
 42b:	74 23                	je     450 <gets+0x60>
 42d:	3c 0d                	cmp    $0xd,%al
 42f:	74 1f                	je     450 <gets+0x60>
  for(i=0; i+1 < max; ){
 431:	83 c3 01             	add    $0x1,%ebx
 434:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 437:	89 fe                	mov    %edi,%esi
 439:	7c cd                	jl     408 <gets+0x18>
 43b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 440:	c6 03 00             	movb   $0x0,(%ebx)
}
 443:	8d 65 f4             	lea    -0xc(%ebp),%esp
 446:	5b                   	pop    %ebx
 447:	5e                   	pop    %esi
 448:	5f                   	pop    %edi
 449:	5d                   	pop    %ebp
 44a:	c3                   	ret    
 44b:	90                   	nop
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 450:	8b 75 08             	mov    0x8(%ebp),%esi
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	01 de                	add    %ebx,%esi
 458:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 45a:	c6 03 00             	movb   $0x0,(%ebx)
}
 45d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 460:	5b                   	pop    %ebx
 461:	5e                   	pop    %esi
 462:	5f                   	pop    %edi
 463:	5d                   	pop    %ebp
 464:	c3                   	ret    
 465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <stat>:

int
stat(char *n, struct stat *st)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	56                   	push   %esi
 474:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 475:	83 ec 08             	sub    $0x8,%esp
 478:	6a 00                	push   $0x0
 47a:	ff 75 08             	pushl  0x8(%ebp)
 47d:	e8 f0 00 00 00       	call   572 <open>
  if(fd < 0)
 482:	83 c4 10             	add    $0x10,%esp
 485:	85 c0                	test   %eax,%eax
 487:	78 27                	js     4b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 489:	83 ec 08             	sub    $0x8,%esp
 48c:	ff 75 0c             	pushl  0xc(%ebp)
 48f:	89 c3                	mov    %eax,%ebx
 491:	50                   	push   %eax
 492:	e8 f3 00 00 00       	call   58a <fstat>
  close(fd);
 497:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 49a:	89 c6                	mov    %eax,%esi
  close(fd);
 49c:	e8 b9 00 00 00       	call   55a <close>
  return r;
 4a1:	83 c4 10             	add    $0x10,%esp
}
 4a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4a7:	89 f0                	mov    %esi,%eax
 4a9:	5b                   	pop    %ebx
 4aa:	5e                   	pop    %esi
 4ab:	5d                   	pop    %ebp
 4ac:	c3                   	ret    
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4b5:	eb ed                	jmp    4a4 <stat+0x34>
 4b7:	89 f6                	mov    %esi,%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004c0 <atoi>:

int
atoi(const char *s)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	53                   	push   %ebx
 4c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4c7:	0f be 11             	movsbl (%ecx),%edx
 4ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 4cd:	3c 09                	cmp    $0x9,%al
  n = 0;
 4cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 4d4:	77 1f                	ja     4f5 <atoi+0x35>
 4d6:	8d 76 00             	lea    0x0(%esi),%esi
 4d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 4e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4e3:	83 c1 01             	add    $0x1,%ecx
 4e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4ea:	0f be 11             	movsbl (%ecx),%edx
 4ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4f0:	80 fb 09             	cmp    $0x9,%bl
 4f3:	76 eb                	jbe    4e0 <atoi+0x20>
  return n;
}
 4f5:	5b                   	pop    %ebx
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
 4f8:	90                   	nop
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000500 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
 505:	8b 5d 10             	mov    0x10(%ebp),%ebx
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 50e:	85 db                	test   %ebx,%ebx
 510:	7e 14                	jle    526 <memmove+0x26>
 512:	31 d2                	xor    %edx,%edx
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 518:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 51c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 51f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 522:	39 d3                	cmp    %edx,%ebx
 524:	75 f2                	jne    518 <memmove+0x18>
  return vdst;
}
 526:	5b                   	pop    %ebx
 527:	5e                   	pop    %esi
 528:	5d                   	pop    %ebp
 529:	c3                   	ret    

0000052a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52a:	b8 01 00 00 00       	mov    $0x1,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <exit>:
SYSCALL(exit)
 532:	b8 02 00 00 00       	mov    $0x2,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <wait>:
SYSCALL(wait)
 53a:	b8 03 00 00 00       	mov    $0x3,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <pipe>:
SYSCALL(pipe)
 542:	b8 04 00 00 00       	mov    $0x4,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <read>:
SYSCALL(read)
 54a:	b8 05 00 00 00       	mov    $0x5,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <write>:
SYSCALL(write)
 552:	b8 10 00 00 00       	mov    $0x10,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <close>:
SYSCALL(close)
 55a:	b8 15 00 00 00       	mov    $0x15,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <kill>:
SYSCALL(kill)
 562:	b8 06 00 00 00       	mov    $0x6,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <exec>:
SYSCALL(exec)
 56a:	b8 07 00 00 00       	mov    $0x7,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <open>:
SYSCALL(open)
 572:	b8 0f 00 00 00       	mov    $0xf,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <mknod>:
SYSCALL(mknod)
 57a:	b8 11 00 00 00       	mov    $0x11,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <unlink>:
SYSCALL(unlink)
 582:	b8 12 00 00 00       	mov    $0x12,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <fstat>:
SYSCALL(fstat)
 58a:	b8 08 00 00 00       	mov    $0x8,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <link>:
SYSCALL(link)
 592:	b8 13 00 00 00       	mov    $0x13,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <mkdir>:
SYSCALL(mkdir)
 59a:	b8 14 00 00 00       	mov    $0x14,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <chdir>:
SYSCALL(chdir)
 5a2:	b8 09 00 00 00       	mov    $0x9,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <dup>:
SYSCALL(dup)
 5aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <getpid>:
SYSCALL(getpid)
 5b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <sbrk>:
SYSCALL(sbrk)
 5ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <sleep>:
SYSCALL(sleep)
 5c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <uptime>:
SYSCALL(uptime)
 5ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <shutdown>:
SYSCALL(shutdown)
 5d2:	b8 16 00 00 00       	mov    $0x16,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <clone>:
SYSCALL(clone)
 5da:	b8 17 00 00 00       	mov    $0x17,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <join>:
SYSCALL(join)
 5e2:	b8 18 00 00 00       	mov    $0x18,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <thread_exit>:
SYSCALL(thread_exit)
 5ea:	b8 19 00 00 00       	mov    $0x19,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <set_priority>:
SYSCALL(set_priority)
 5f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <enable_sched_display>:
 5fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    
 602:	66 90                	xchg   %ax,%ax
 604:	66 90                	xchg   %ax,%ax
 606:	66 90                	xchg   %ax,%ax
 608:	66 90                	xchg   %ax,%ax
 60a:	66 90                	xchg   %ax,%ax
 60c:	66 90                	xchg   %ax,%ax
 60e:	66 90                	xchg   %ax,%ax

00000610 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 619:	85 d2                	test   %edx,%edx
{
 61b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 61e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 620:	79 76                	jns    698 <printint+0x88>
 622:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 626:	74 70                	je     698 <printint+0x88>
    x = -xx;
 628:	f7 d8                	neg    %eax
    neg = 1;
 62a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 631:	31 f6                	xor    %esi,%esi
 633:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 636:	eb 0a                	jmp    642 <printint+0x32>
 638:	90                   	nop
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 640:	89 fe                	mov    %edi,%esi
 642:	31 d2                	xor    %edx,%edx
 644:	8d 7e 01             	lea    0x1(%esi),%edi
 647:	f7 f1                	div    %ecx
 649:	0f b6 92 38 0c 00 00 	movzbl 0xc38(%edx),%edx
  }while((x /= base) != 0);
 650:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 652:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 655:	75 e9                	jne    640 <printint+0x30>
  if(neg)
 657:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 65a:	85 c0                	test   %eax,%eax
 65c:	74 08                	je     666 <printint+0x56>
    buf[i++] = '-';
 65e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 663:	8d 7e 02             	lea    0x2(%esi),%edi
 666:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 66a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 66d:	8d 76 00             	lea    0x0(%esi),%esi
 670:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 673:	83 ec 04             	sub    $0x4,%esp
 676:	83 ee 01             	sub    $0x1,%esi
 679:	6a 01                	push   $0x1
 67b:	53                   	push   %ebx
 67c:	57                   	push   %edi
 67d:	88 45 d7             	mov    %al,-0x29(%ebp)
 680:	e8 cd fe ff ff       	call   552 <write>

  while(--i >= 0)
 685:	83 c4 10             	add    $0x10,%esp
 688:	39 de                	cmp    %ebx,%esi
 68a:	75 e4                	jne    670 <printint+0x60>
    putc(fd, buf[i]);
}
 68c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68f:	5b                   	pop    %ebx
 690:	5e                   	pop    %esi
 691:	5f                   	pop    %edi
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    
 694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 698:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 69f:	eb 90                	jmp    631 <printint+0x21>
 6a1:	eb 0d                	jmp    6b0 <printf>
 6a3:	90                   	nop
 6a4:	90                   	nop
 6a5:	90                   	nop
 6a6:	90                   	nop
 6a7:	90                   	nop
 6a8:	90                   	nop
 6a9:	90                   	nop
 6aa:	90                   	nop
 6ab:	90                   	nop
 6ac:	90                   	nop
 6ad:	90                   	nop
 6ae:	90                   	nop
 6af:	90                   	nop

000006b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 6bc:	0f b6 1e             	movzbl (%esi),%ebx
 6bf:	84 db                	test   %bl,%bl
 6c1:	0f 84 b3 00 00 00    	je     77a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 6c7:	8d 45 10             	lea    0x10(%ebp),%eax
 6ca:	83 c6 01             	add    $0x1,%esi
  state = 0;
 6cd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 6cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6d2:	eb 2f                	jmp    703 <printf+0x53>
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6d8:	83 f8 25             	cmp    $0x25,%eax
 6db:	0f 84 a7 00 00 00    	je     788 <printf+0xd8>
  write(fd, &c, 1);
 6e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6e4:	83 ec 04             	sub    $0x4,%esp
 6e7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 6ea:	6a 01                	push   $0x1
 6ec:	50                   	push   %eax
 6ed:	ff 75 08             	pushl  0x8(%ebp)
 6f0:	e8 5d fe ff ff       	call   552 <write>
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 6fb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6ff:	84 db                	test   %bl,%bl
 701:	74 77                	je     77a <printf+0xca>
    if(state == 0){
 703:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 705:	0f be cb             	movsbl %bl,%ecx
 708:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 70b:	74 cb                	je     6d8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 70d:	83 ff 25             	cmp    $0x25,%edi
 710:	75 e6                	jne    6f8 <printf+0x48>
      if(c == 'd'){
 712:	83 f8 64             	cmp    $0x64,%eax
 715:	0f 84 05 01 00 00    	je     820 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 71b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 721:	83 f9 70             	cmp    $0x70,%ecx
 724:	74 72                	je     798 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 726:	83 f8 73             	cmp    $0x73,%eax
 729:	0f 84 99 00 00 00    	je     7c8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72f:	83 f8 63             	cmp    $0x63,%eax
 732:	0f 84 08 01 00 00    	je     840 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 738:	83 f8 25             	cmp    $0x25,%eax
 73b:	0f 84 ef 00 00 00    	je     830 <printf+0x180>
  write(fd, &c, 1);
 741:	8d 45 e7             	lea    -0x19(%ebp),%eax
 744:	83 ec 04             	sub    $0x4,%esp
 747:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 74b:	6a 01                	push   $0x1
 74d:	50                   	push   %eax
 74e:	ff 75 08             	pushl  0x8(%ebp)
 751:	e8 fc fd ff ff       	call   552 <write>
 756:	83 c4 0c             	add    $0xc,%esp
 759:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 75c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 75f:	6a 01                	push   $0x1
 761:	50                   	push   %eax
 762:	ff 75 08             	pushl  0x8(%ebp)
 765:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 768:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 76a:	e8 e3 fd ff ff       	call   552 <write>
  for(i = 0; fmt[i]; i++){
 76f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 773:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 776:	84 db                	test   %bl,%bl
 778:	75 89                	jne    703 <printf+0x53>
    }
  }
}
 77a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 77d:	5b                   	pop    %ebx
 77e:	5e                   	pop    %esi
 77f:	5f                   	pop    %edi
 780:	5d                   	pop    %ebp
 781:	c3                   	ret    
 782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 788:	bf 25 00 00 00       	mov    $0x25,%edi
 78d:	e9 66 ff ff ff       	jmp    6f8 <printf+0x48>
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 798:	83 ec 0c             	sub    $0xc,%esp
 79b:	b9 10 00 00 00       	mov    $0x10,%ecx
 7a0:	6a 00                	push   $0x0
 7a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	8b 17                	mov    (%edi),%edx
 7aa:	e8 61 fe ff ff       	call   610 <printint>
        ap++;
 7af:	89 f8                	mov    %edi,%eax
 7b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7b4:	31 ff                	xor    %edi,%edi
        ap++;
 7b6:	83 c0 04             	add    $0x4,%eax
 7b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7bc:	e9 37 ff ff ff       	jmp    6f8 <printf+0x48>
 7c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7cb:	8b 08                	mov    (%eax),%ecx
        ap++;
 7cd:	83 c0 04             	add    $0x4,%eax
 7d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 7d3:	85 c9                	test   %ecx,%ecx
 7d5:	0f 84 8e 00 00 00    	je     869 <printf+0x1b9>
        while(*s != 0){
 7db:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 7de:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 7e0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 7e2:	84 c0                	test   %al,%al
 7e4:	0f 84 0e ff ff ff    	je     6f8 <printf+0x48>
 7ea:	89 75 d0             	mov    %esi,-0x30(%ebp)
 7ed:	89 de                	mov    %ebx,%esi
 7ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7f2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 7f5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7f8:	83 ec 04             	sub    $0x4,%esp
          s++;
 7fb:	83 c6 01             	add    $0x1,%esi
 7fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 801:	6a 01                	push   $0x1
 803:	57                   	push   %edi
 804:	53                   	push   %ebx
 805:	e8 48 fd ff ff       	call   552 <write>
        while(*s != 0){
 80a:	0f b6 06             	movzbl (%esi),%eax
 80d:	83 c4 10             	add    $0x10,%esp
 810:	84 c0                	test   %al,%al
 812:	75 e4                	jne    7f8 <printf+0x148>
 814:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 817:	31 ff                	xor    %edi,%edi
 819:	e9 da fe ff ff       	jmp    6f8 <printf+0x48>
 81e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	b9 0a 00 00 00       	mov    $0xa,%ecx
 828:	6a 01                	push   $0x1
 82a:	e9 73 ff ff ff       	jmp    7a2 <printf+0xf2>
 82f:	90                   	nop
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
 833:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 836:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 839:	6a 01                	push   $0x1
 83b:	e9 21 ff ff ff       	jmp    761 <printf+0xb1>
        putc(fd, *ap);
 840:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 843:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 846:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 848:	6a 01                	push   $0x1
        ap++;
 84a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 84d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 850:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 853:	50                   	push   %eax
 854:	ff 75 08             	pushl  0x8(%ebp)
 857:	e8 f6 fc ff ff       	call   552 <write>
        ap++;
 85c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 85f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 862:	31 ff                	xor    %edi,%edi
 864:	e9 8f fe ff ff       	jmp    6f8 <printf+0x48>
          s = "(null)";
 869:	bb 30 0c 00 00       	mov    $0xc30,%ebx
        while(*s != 0){
 86e:	b8 28 00 00 00       	mov    $0x28,%eax
 873:	e9 72 ff ff ff       	jmp    7ea <printf+0x13a>
 878:	66 90                	xchg   %ax,%ax
 87a:	66 90                	xchg   %ax,%ax
 87c:	66 90                	xchg   %ax,%ax
 87e:	66 90                	xchg   %ax,%ax

00000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 881:	a1 5c 10 00 00       	mov    0x105c,%eax
{
 886:	89 e5                	mov    %esp,%ebp
 888:	57                   	push   %edi
 889:	56                   	push   %esi
 88a:	53                   	push   %ebx
 88b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 88e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 898:	39 c8                	cmp    %ecx,%eax
 89a:	8b 10                	mov    (%eax),%edx
 89c:	73 32                	jae    8d0 <free+0x50>
 89e:	39 d1                	cmp    %edx,%ecx
 8a0:	72 04                	jb     8a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a2:	39 d0                	cmp    %edx,%eax
 8a4:	72 32                	jb     8d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ac:	39 fa                	cmp    %edi,%edx
 8ae:	74 30                	je     8e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8b3:	8b 50 04             	mov    0x4(%eax),%edx
 8b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8b9:	39 f1                	cmp    %esi,%ecx
 8bb:	74 3a                	je     8f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8bd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8bf:	a3 5c 10 00 00       	mov    %eax,0x105c
}
 8c4:	5b                   	pop    %ebx
 8c5:	5e                   	pop    %esi
 8c6:	5f                   	pop    %edi
 8c7:	5d                   	pop    %ebp
 8c8:	c3                   	ret    
 8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	39 d0                	cmp    %edx,%eax
 8d2:	72 04                	jb     8d8 <free+0x58>
 8d4:	39 d1                	cmp    %edx,%ecx
 8d6:	72 ce                	jb     8a6 <free+0x26>
{
 8d8:	89 d0                	mov    %edx,%eax
 8da:	eb bc                	jmp    898 <free+0x18>
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 8e0:	03 72 04             	add    0x4(%edx),%esi
 8e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e6:	8b 10                	mov    (%eax),%edx
 8e8:	8b 12                	mov    (%edx),%edx
 8ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8ed:	8b 50 04             	mov    0x4(%eax),%edx
 8f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8f3:	39 f1                	cmp    %esi,%ecx
 8f5:	75 c6                	jne    8bd <free+0x3d>
    p->s.size += bp->s.size;
 8f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8fa:	a3 5c 10 00 00       	mov    %eax,0x105c
    p->s.size += bp->s.size;
 8ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 902:	8b 53 f8             	mov    -0x8(%ebx),%edx
 905:	89 10                	mov    %edx,(%eax)
}
 907:	5b                   	pop    %ebx
 908:	5e                   	pop    %esi
 909:	5f                   	pop    %edi
 90a:	5d                   	pop    %ebp
 90b:	c3                   	ret    
 90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000910 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	57                   	push   %edi
 914:	56                   	push   %esi
 915:	53                   	push   %ebx
 916:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 919:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 91c:	8b 15 5c 10 00 00    	mov    0x105c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 922:	8d 78 07             	lea    0x7(%eax),%edi
 925:	c1 ef 03             	shr    $0x3,%edi
 928:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 92b:	85 d2                	test   %edx,%edx
 92d:	0f 84 9d 00 00 00    	je     9d0 <malloc+0xc0>
 933:	8b 02                	mov    (%edx),%eax
 935:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 938:	39 cf                	cmp    %ecx,%edi
 93a:	76 6c                	jbe    9a8 <malloc+0x98>
 93c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 942:	bb 00 10 00 00       	mov    $0x1000,%ebx
 947:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 94a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 951:	eb 0e                	jmp    961 <malloc+0x51>
 953:	90                   	nop
 954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 958:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 95a:	8b 48 04             	mov    0x4(%eax),%ecx
 95d:	39 f9                	cmp    %edi,%ecx
 95f:	73 47                	jae    9a8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 961:	39 05 5c 10 00 00    	cmp    %eax,0x105c
 967:	89 c2                	mov    %eax,%edx
 969:	75 ed                	jne    958 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 96b:	83 ec 0c             	sub    $0xc,%esp
 96e:	56                   	push   %esi
 96f:	e8 46 fc ff ff       	call   5ba <sbrk>
  if(p == (char*)-1)
 974:	83 c4 10             	add    $0x10,%esp
 977:	83 f8 ff             	cmp    $0xffffffff,%eax
 97a:	74 1c                	je     998 <malloc+0x88>
  hp->s.size = nu;
 97c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 97f:	83 ec 0c             	sub    $0xc,%esp
 982:	83 c0 08             	add    $0x8,%eax
 985:	50                   	push   %eax
 986:	e8 f5 fe ff ff       	call   880 <free>
  return freep;
 98b:	8b 15 5c 10 00 00    	mov    0x105c,%edx
      if((p = morecore(nunits)) == 0)
 991:	83 c4 10             	add    $0x10,%esp
 994:	85 d2                	test   %edx,%edx
 996:	75 c0                	jne    958 <malloc+0x48>
        return 0;
  }
}
 998:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 99b:	31 c0                	xor    %eax,%eax
}
 99d:	5b                   	pop    %ebx
 99e:	5e                   	pop    %esi
 99f:	5f                   	pop    %edi
 9a0:	5d                   	pop    %ebp
 9a1:	c3                   	ret    
 9a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9a8:	39 cf                	cmp    %ecx,%edi
 9aa:	74 54                	je     a00 <malloc+0xf0>
        p->s.size -= nunits;
 9ac:	29 f9                	sub    %edi,%ecx
 9ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9b4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9b7:	89 15 5c 10 00 00    	mov    %edx,0x105c
}
 9bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9c0:	83 c0 08             	add    $0x8,%eax
}
 9c3:	5b                   	pop    %ebx
 9c4:	5e                   	pop    %esi
 9c5:	5f                   	pop    %edi
 9c6:	5d                   	pop    %ebp
 9c7:	c3                   	ret    
 9c8:	90                   	nop
 9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 9d0:	c7 05 5c 10 00 00 60 	movl   $0x1060,0x105c
 9d7:	10 00 00 
 9da:	c7 05 60 10 00 00 60 	movl   $0x1060,0x1060
 9e1:	10 00 00 
    base.s.size = 0;
 9e4:	b8 60 10 00 00       	mov    $0x1060,%eax
 9e9:	c7 05 64 10 00 00 00 	movl   $0x0,0x1064
 9f0:	00 00 00 
 9f3:	e9 44 ff ff ff       	jmp    93c <malloc+0x2c>
 9f8:	90                   	nop
 9f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a00:	8b 08                	mov    (%eax),%ecx
 a02:	89 0a                	mov    %ecx,(%edx)
 a04:	eb b1                	jmp    9b7 <malloc+0xa7>
 a06:	66 90                	xchg   %ax,%ax
 a08:	66 90                	xchg   %ax,%ax
 a0a:	66 90                	xchg   %ax,%ax
 a0c:	66 90                	xchg   %ax,%ax
 a0e:	66 90                	xchg   %ax,%ax

00000a10 <xthread_create>:
extern void join(int tid,void **ret_p,void **stack);
extern void thread_exit(void *ret);


int xthread_create(int * tid, void * (* start_routine)(void *), void * arg)
{
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	83 ec 14             	sub    $0x14,%esp
    // add your implementation here ...
    void * stack = (void *)malloc(4096);
 a16:	68 00 10 00 00       	push   $0x1000
 a1b:	e8 f0 fe ff ff       	call   910 <malloc>
    // printf(1,"malloc loc is %d",stack);

    (*tid) = clone(start_routine, (void*)((int)stack+4096), arg);
 a20:	83 c4 0c             	add    $0xc,%esp
 a23:	05 00 10 00 00       	add    $0x1000,%eax
 a28:	ff 75 10             	pushl  0x10(%ebp)
 a2b:	50                   	push   %eax
 a2c:	ff 75 0c             	pushl  0xc(%ebp)
 a2f:	e8 a6 fb ff ff       	call   5da <clone>
 a34:	8b 55 08             	mov    0x8(%ebp),%edx
    // printf(1,"tid: %d \n", *tid);
    // printf(1,"\nstack %d create : %d \n",*tid,(int)stack+4096);
    if(*tid < 0)
 a37:	83 c4 10             	add    $0x10,%esp
    (*tid) = clone(start_routine, (void*)((int)stack+4096), arg);
 a3a:	89 02                	mov    %eax,(%edx)
        return -1;
    return 1;
 a3c:	c1 f8 1f             	sar    $0x1f,%eax
 a3f:	83 c8 01             	or     $0x1,%eax
}
 a42:	c9                   	leave  
 a43:	c3                   	ret    
 a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a50 <xthread_exit>:


void xthread_exit(void * ret_val_p)
{
 a50:	55                   	push   %ebp
 a51:	89 e5                	mov    %esp,%ebp
    // add your implementation here ...
   thread_exit(ret_val_p);
}
 a53:	5d                   	pop    %ebp
   thread_exit(ret_val_p);
 a54:	e9 91 fb ff ff       	jmp    5ea <thread_exit>
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a60 <xthread_join>:


void xthread_join(int tid, void ** retval)
{
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	83 ec 1c             	sub    $0x1c,%esp
    // add your implementation here ...
    void * stack;
    join(tid, retval, &stack);
 a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a69:	50                   	push   %eax
 a6a:	ff 75 0c             	pushl  0xc(%ebp)
 a6d:	ff 75 08             	pushl  0x8(%ebp)
 a70:	e8 6d fb ff ff       	call   5e2 <join>

    free((void *)((int)stack-4096));
 a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a78:	2d 00 10 00 00       	sub    $0x1000,%eax
 a7d:	89 04 24             	mov    %eax,(%esp)
 a80:	e8 fb fd ff ff       	call   880 <free>
}
 a85:	83 c4 10             	add    $0x10,%esp
 a88:	c9                   	leave  
 a89:	c3                   	ret    
