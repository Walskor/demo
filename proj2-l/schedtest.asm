
_schedtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void busy_computing(){
   fib(30);
}


int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 50             	sub    $0x50,%esp

        int i,pid;
        int fd[7][2];
        char c;
        printf(1,"================================\n");
  14:	68 1c 0a 00 00       	push   $0xa1c
  19:	6a 01                	push   $0x1
  1b:	e8 20 06 00 00       	call   640 <printf>
        pid=getpid();
  20:	e8 1d 05 00 00       	call   542 <getpid>
  25:	89 c3                	mov    %eax,%ebx
        set_priority(pid,1);
  27:	58                   	pop    %eax
  28:	5a                   	pop    %edx
  29:	6a 01                	push   $0x1
  2b:	53                   	push   %ebx
  2c:	e8 51 05 00 00       	call   582 <set_priority>
        printf(1,"Parent (pid=%d, prior=%d)\n",pid,1);
  31:	6a 01                	push   $0x1
  33:	53                   	push   %ebx
        for(i=0;i<6;i++){
  34:	31 db                	xor    %ebx,%ebx
        printf(1,"Parent (pid=%d, prior=%d)\n",pid,1);
  36:	68 64 0a 00 00       	push   $0xa64
  3b:	6a 01                	push   $0x1
  3d:	e8 fe 05 00 00       	call   640 <printf>
  42:	83 c4 20             	add    $0x20,%esp
                pipe(fd[i]);
  45:	8d 44 dd b0          	lea    -0x50(%ebp,%ebx,8),%eax
  49:	83 ec 0c             	sub    $0xc,%esp
  4c:	50                   	push   %eax
  4d:	e8 80 04 00 00       	call   4d2 <pipe>
                if((pid=fork())==0){
  52:	e8 63 04 00 00       	call   4ba <fork>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	89 c7                	mov    %eax,%edi
  5e:	0f 84 39 01 00 00    	je     19d <main+0x19d>
                        close(fd[i][1]);//close write end
                        read(fd[i][0],&c,1);
                        busy_computing();
                        exit();
                }else{
                        close(fd[i][0]);//parent close read end
  64:	83 ec 0c             	sub    $0xc,%esp
  67:	ff 74 dd b0          	pushl  -0x50(%ebp,%ebx,8)
  6b:	e8 7a 04 00 00       	call   4ea <close>
                        set_priority(pid,i%3+1);
  70:	5e                   	pop    %esi
  71:	58                   	pop    %eax
  72:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
  77:	89 de                	mov    %ebx,%esi
  79:	f7 e3                	mul    %ebx
        for(i=0;i<6;i++){
  7b:	83 c3 01             	add    $0x1,%ebx
                        set_priority(pid,i%3+1);
  7e:	d1 ea                	shr    %edx
  80:	8d 04 52             	lea    (%edx,%edx,2),%eax
  83:	29 c6                	sub    %eax,%esi
  85:	83 c6 01             	add    $0x1,%esi
  88:	56                   	push   %esi
  89:	57                   	push   %edi
  8a:	e8 f3 04 00 00       	call   582 <set_priority>
                        printf(1,"Child (pid=%d, prior=%d) created!\n",pid,i%3+1);
  8f:	56                   	push   %esi
  90:	57                   	push   %edi
  91:	68 40 0a 00 00       	push   $0xa40
  96:	6a 01                	push   $0x1
  98:	e8 a3 05 00 00       	call   640 <printf>
        for(i=0;i<6;i++){
  9d:	83 c4 20             	add    $0x20,%esp
  a0:	83 fb 06             	cmp    $0x6,%ebx
  a3:	75 a0                	jne    45 <main+0x45>
                }
        }
        pipe(fd[6]);
  a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  a8:	83 ec 0c             	sub    $0xc,%esp
  ab:	50                   	push   %eax
  ac:	e8 21 04 00 00       	call   4d2 <pipe>
        if((pid=fork())==0){//default priority
  b1:	e8 04 04 00 00       	call   4ba <fork>
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	85 c0                	test   %eax,%eax
  bb:	89 c3                	mov    %eax,%ebx
  bd:	75 32                	jne    f1 <main+0xf1>
                //child
                close(fd[i][1]);//close write end
  bf:	83 ec 0c             	sub    $0xc,%esp
  c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  c5:	e8 20 04 00 00       	call   4ea <close>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	b9 1d 00 00 00       	mov    $0x1d,%ecx
  d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 return fib(i-1)+fib(i-2);
  d8:	83 ec 0c             	sub    $0xc,%esp
  db:	51                   	push   %ecx
  dc:	e8 0f 01 00 00       	call   1f0 <fib>
  e1:	83 e9 02             	sub    $0x2,%ecx
  e4:	83 c4 10             	add    $0x10,%esp
 if(i<=1)return i;
  e7:	83 f9 ff             	cmp    $0xffffffff,%ecx
  ea:	75 ec                	jne    d8 <main+0xd8>
                        exit();
  ec:	e8 d1 03 00 00       	call   4c2 <exit>
                busy_computing();
                exit();
        }else{
                close(fd[i][0]);//close read end
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 e0             	pushl  -0x20(%ebp)
  f7:	8d 7d ec             	lea    -0x14(%ebp),%edi
  fa:	8d 75 af             	lea    -0x51(%ebp),%esi
  fd:	e8 e8 03 00 00       	call   4ea <close>
                printf(1,"Child (pid=%d, prior=%d) created!\n",pid,2);
 102:	6a 02                	push   $0x2
 104:	53                   	push   %ebx
 105:	8d 5d b4             	lea    -0x4c(%ebp),%ebx
 108:	68 40 0a 00 00       	push   $0xa40
 10d:	6a 01                	push   $0x1
 10f:	e8 2c 05 00 00       	call   640 <printf>
        }
        printf(1,"================================\n");
 114:	83 c4 18             	add    $0x18,%esp
 117:	68 1c 0a 00 00       	push   $0xa1c
 11c:	6a 01                	push   $0x1
 11e:	e8 1d 05 00 00       	call   640 <printf>
        enable_sched_display(1);
 123:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12a:	e8 5b 04 00 00       	call   58a <enable_sched_display>
 12f:	83 c4 10             	add    $0x10,%esp
 132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        //parent wake up all children
        for(i=0;i<7;i++){
        c='a';
        write(fd[i][1],&c,1);
 138:	83 ec 04             	sub    $0x4,%esp
        c='a';
 13b:	c6 45 af 61          	movb   $0x61,-0x51(%ebp)
 13f:	83 c3 08             	add    $0x8,%ebx
        write(fd[i][1],&c,1);
 142:	6a 01                	push   $0x1
 144:	56                   	push   %esi
 145:	ff 73 f8             	pushl  -0x8(%ebx)
 148:	e8 95 03 00 00       	call   4e2 <write>
        close(fd[i][1]);
 14d:	59                   	pop    %ecx
 14e:	ff 73 f8             	pushl  -0x8(%ebx)
 151:	e8 94 03 00 00       	call   4ea <close>
        for(i=0;i<7;i++){
 156:	83 c4 10             	add    $0x10,%esp
 159:	39 df                	cmp    %ebx,%edi
 15b:	75 db                	jne    138 <main+0x138>
        }


        for(i=0;i<7;i++)
                wait();
 15d:	e8 68 03 00 00       	call   4ca <wait>
 162:	e8 63 03 00 00       	call   4ca <wait>
 167:	e8 5e 03 00 00       	call   4ca <wait>
 16c:	e8 59 03 00 00       	call   4ca <wait>
 171:	e8 54 03 00 00       	call   4ca <wait>
 176:	e8 4f 03 00 00       	call   4ca <wait>
 17b:	e8 4a 03 00 00       	call   4ca <wait>
        enable_sched_display(0);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	6a 00                	push   $0x0
 185:	e8 00 04 00 00       	call   58a <enable_sched_display>
        printf(1,"\n");
 18a:	58                   	pop    %eax
 18b:	5a                   	pop    %edx
 18c:	68 7d 0a 00 00       	push   $0xa7d
 191:	6a 01                	push   $0x1
 193:	e8 a8 04 00 00       	call   640 <printf>
        exit();
 198:	e8 25 03 00 00       	call   4c2 <exit>
                        close(fd[i][1]);//close write end
 19d:	83 ec 0c             	sub    $0xc,%esp
 1a0:	ff 74 dd b4          	pushl  -0x4c(%ebp,%ebx,8)
 1a4:	e8 41 03 00 00       	call   4ea <close>
                        read(fd[i][0],&c,1);
 1a9:	8d 45 af             	lea    -0x51(%ebp),%eax
 1ac:	83 c4 0c             	add    $0xc,%esp
 1af:	6a 01                	push   $0x1
 1b1:	50                   	push   %eax
 1b2:	ff 74 dd b0          	pushl  -0x50(%ebp,%ebx,8)
 1b6:	e8 1f 03 00 00       	call   4da <read>
 1bb:	83 c4 10             	add    $0x10,%esp
 1be:	b9 1d 00 00 00       	mov    $0x1d,%ecx
 1c3:	90                   	nop
 1c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 return fib(i-1)+fib(i-2);
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	51                   	push   %ecx
 1cc:	e8 1f 00 00 00       	call   1f0 <fib>
 1d1:	83 e9 02             	sub    $0x2,%ecx
 1d4:	83 c4 10             	add    $0x10,%esp
 if(i<=1)return i;
 1d7:	83 f9 ff             	cmp    $0xffffffff,%ecx
 1da:	75 ec                	jne    1c8 <main+0x1c8>
 1dc:	e9 0b ff ff ff       	jmp    ec <main+0xec>
 1e1:	66 90                	xchg   %ax,%ax
 1e3:	66 90                	xchg   %ax,%ax
 1e5:	66 90                	xchg   %ax,%ax
 1e7:	66 90                	xchg   %ax,%ax
 1e9:	66 90                	xchg   %ax,%ax
 1eb:	66 90                	xchg   %ax,%ax
 1ed:	66 90                	xchg   %ax,%ax
 1ef:	90                   	nop

000001f0 <fib>:
int fib(int i){
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
 if(i<=1)return i;
 1f6:	31 f6                	xor    %esi,%esi
int fib(int i){
 1f8:	83 ec 1c             	sub    $0x1c,%esp
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 if(i<=1)return i;
 1fe:	83 f8 01             	cmp    $0x1,%eax
 201:	7e 2e                	jle    231 <fib+0x41>
 203:	8d 50 fe             	lea    -0x2(%eax),%edx
 206:	8d 78 fd             	lea    -0x3(%eax),%edi
 209:	8d 58 ff             	lea    -0x1(%eax),%ebx
 20c:	89 d0                	mov    %edx,%eax
 20e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 211:	83 e0 fe             	and    $0xfffffffe,%eax
 214:	29 c7                	sub    %eax,%edi
 return fib(i-1)+fib(i-2);
 216:	83 ec 0c             	sub    $0xc,%esp
 219:	53                   	push   %ebx
 21a:	83 eb 02             	sub    $0x2,%ebx
 21d:	e8 ce ff ff ff       	call   1f0 <fib>
 222:	83 c4 10             	add    $0x10,%esp
 225:	01 c6                	add    %eax,%esi
 if(i<=1)return i;
 227:	39 fb                	cmp    %edi,%ebx
 229:	75 eb                	jne    216 <fib+0x26>
 22b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 22e:	83 e0 01             	and    $0x1,%eax
}
 231:	8d 65 f4             	lea    -0xc(%ebp),%esp
 234:	01 f0                	add    %esi,%eax
 236:	5b                   	pop    %ebx
 237:	5e                   	pop    %esi
 238:	5f                   	pop    %edi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    
 23b:	90                   	nop
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <busy_computing>:
void busy_computing(){
 240:	55                   	push   %ebp
 241:	b9 1d 00 00 00       	mov    $0x1d,%ecx
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 08             	sub    $0x8,%esp
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 return fib(i-1)+fib(i-2);
 250:	83 ec 0c             	sub    $0xc,%esp
 253:	51                   	push   %ecx
 254:	e8 97 ff ff ff       	call   1f0 <fib>
 259:	83 e9 02             	sub    $0x2,%ecx
 25c:	83 c4 10             	add    $0x10,%esp
 if(i<=1)return i;
 25f:	83 f9 ff             	cmp    $0xffffffff,%ecx
 262:	75 ec                	jne    250 <busy_computing+0x10>
}
 264:	c9                   	leave  
 265:	c3                   	ret    
 266:	66 90                	xchg   %ax,%ax
 268:	66 90                	xchg   %ax,%ax
 26a:	66 90                	xchg   %ax,%ax
 26c:	66 90                	xchg   %ax,%ax
 26e:	66 90                	xchg   %ax,%ax

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27a:	89 c2                	mov    %eax,%edx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 280:	83 c1 01             	add    $0x1,%ecx
 283:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 287:	83 c2 01             	add    $0x1,%edx
 28a:	84 db                	test   %bl,%bl
 28c:	88 5a ff             	mov    %bl,-0x1(%edx)
 28f:	75 ef                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 291:	5b                   	pop    %ebx
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 29a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	0f b6 19             	movzbl (%ecx),%ebx
 2b0:	84 c0                	test   %al,%al
 2b2:	75 1c                	jne    2d0 <strcmp+0x30>
 2b4:	eb 2a                	jmp    2e0 <strcmp+0x40>
 2b6:	8d 76 00             	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2c6:	83 c1 01             	add    $0x1,%ecx
 2c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2cc:	84 c0                	test   %al,%al
 2ce:	74 10                	je     2e0 <strcmp+0x40>
 2d0:	38 d8                	cmp    %bl,%al
 2d2:	74 ec                	je     2c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2d4:	29 d8                	sub    %ebx,%eax
}
 2d6:	5b                   	pop    %ebx
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2e2:	29 d8                	sub    %ebx,%eax
}
 2e4:	5b                   	pop    %ebx
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    
 2e7:	89 f6                	mov    %esi,%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <strlen>:

uint
strlen(char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2f6:	80 39 00             	cmpb   $0x0,(%ecx)
 2f9:	74 15                	je     310 <strlen+0x20>
 2fb:	31 d2                	xor    %edx,%edx
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
 300:	83 c2 01             	add    $0x1,%edx
 303:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 307:	89 d0                	mov    %edx,%eax
 309:	75 f5                	jne    300 <strlen+0x10>
    ;
  return n;
}
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    
 30d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 310:	31 c0                	xor    %eax,%eax
}
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    
 314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 31a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 d7                	mov    %edx,%edi
 32f:	fc                   	cld    
 330:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 332:	89 d0                	mov    %edx,%eax
 334:	5f                   	pop    %edi
 335:	5d                   	pop    %ebp
 336:	c3                   	ret    
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 34a:	0f b6 10             	movzbl (%eax),%edx
 34d:	84 d2                	test   %dl,%dl
 34f:	74 1d                	je     36e <strchr+0x2e>
    if(*s == c)
 351:	38 d3                	cmp    %dl,%bl
 353:	89 d9                	mov    %ebx,%ecx
 355:	75 0d                	jne    364 <strchr+0x24>
 357:	eb 17                	jmp    370 <strchr+0x30>
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 360:	38 ca                	cmp    %cl,%dl
 362:	74 0c                	je     370 <strchr+0x30>
  for(; *s; s++)
 364:	83 c0 01             	add    $0x1,%eax
 367:	0f b6 10             	movzbl (%eax),%edx
 36a:	84 d2                	test   %dl,%dl
 36c:	75 f2                	jne    360 <strchr+0x20>
      return (char*)s;
  return 0;
 36e:	31 c0                	xor    %eax,%eax
}
 370:	5b                   	pop    %ebx
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    
 373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	31 f6                	xor    %esi,%esi
 388:	89 f3                	mov    %esi,%ebx
{
 38a:	83 ec 1c             	sub    $0x1c,%esp
 38d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 390:	eb 2f                	jmp    3c1 <gets+0x41>
 392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 398:	8d 45 e7             	lea    -0x19(%ebp),%eax
 39b:	83 ec 04             	sub    $0x4,%esp
 39e:	6a 01                	push   $0x1
 3a0:	50                   	push   %eax
 3a1:	6a 00                	push   $0x0
 3a3:	e8 32 01 00 00       	call   4da <read>
    if(cc < 1)
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	85 c0                	test   %eax,%eax
 3ad:	7e 1c                	jle    3cb <gets+0x4b>
      break;
    buf[i++] = c;
 3af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b3:	83 c7 01             	add    $0x1,%edi
 3b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3b9:	3c 0a                	cmp    $0xa,%al
 3bb:	74 23                	je     3e0 <gets+0x60>
 3bd:	3c 0d                	cmp    $0xd,%al
 3bf:	74 1f                	je     3e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3c1:	83 c3 01             	add    $0x1,%ebx
 3c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3c7:	89 fe                	mov    %edi,%esi
 3c9:	7c cd                	jl     398 <gets+0x18>
 3cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    
 3db:	90                   	nop
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e0:	8b 75 08             	mov    0x8(%ebp),%esi
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	01 de                	add    %ebx,%esi
 3e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 3ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f0:	5b                   	pop    %ebx
 3f1:	5e                   	pop    %esi
 3f2:	5f                   	pop    %edi
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    
 3f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <stat>:

int
stat(char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	pushl  0x8(%ebp)
 40d:	e8 f0 00 00 00       	call   502 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	pushl  0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f3 00 00 00       	call   51a <fstat>
  close(fd);
 427:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	e8 b9 00 00 00       	call   4ea <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f be 11             	movsbl (%ecx),%edx
 45a:	8d 42 d0             	lea    -0x30(%edx),%eax
 45d:	3c 09                	cmp    $0x9,%al
  n = 0;
 45f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 464:	77 1f                	ja     485 <atoi+0x35>
 466:	8d 76 00             	lea    0x0(%esi),%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 470:	8d 04 80             	lea    (%eax,%eax,4),%eax
 473:	83 c1 01             	add    $0x1,%ecx
 476:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 47a:	0f be 11             	movsbl (%ecx),%edx
 47d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	5b                   	pop    %ebx
 486:	5d                   	pop    %ebp
 487:	c3                   	ret    
 488:	90                   	nop
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000490 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	56                   	push   %esi
 494:	53                   	push   %ebx
 495:	8b 5d 10             	mov    0x10(%ebp),%ebx
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	85 db                	test   %ebx,%ebx
 4a0:	7e 14                	jle    4b6 <memmove+0x26>
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4b2:	39 d3                	cmp    %edx,%ebx
 4b4:	75 f2                	jne    4a8 <memmove+0x18>
  return vdst;
}
 4b6:	5b                   	pop    %ebx
 4b7:	5e                   	pop    %esi
 4b8:	5d                   	pop    %ebp
 4b9:	c3                   	ret    

000004ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ba:	b8 01 00 00 00       	mov    $0x1,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <exit>:
SYSCALL(exit)
 4c2:	b8 02 00 00 00       	mov    $0x2,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <wait>:
SYSCALL(wait)
 4ca:	b8 03 00 00 00       	mov    $0x3,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <pipe>:
SYSCALL(pipe)
 4d2:	b8 04 00 00 00       	mov    $0x4,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <read>:
SYSCALL(read)
 4da:	b8 05 00 00 00       	mov    $0x5,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <write>:
SYSCALL(write)
 4e2:	b8 10 00 00 00       	mov    $0x10,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <close>:
SYSCALL(close)
 4ea:	b8 15 00 00 00       	mov    $0x15,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <kill>:
SYSCALL(kill)
 4f2:	b8 06 00 00 00       	mov    $0x6,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <exec>:
SYSCALL(exec)
 4fa:	b8 07 00 00 00       	mov    $0x7,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <open>:
SYSCALL(open)
 502:	b8 0f 00 00 00       	mov    $0xf,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mknod>:
SYSCALL(mknod)
 50a:	b8 11 00 00 00       	mov    $0x11,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <unlink>:
SYSCALL(unlink)
 512:	b8 12 00 00 00       	mov    $0x12,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <fstat>:
SYSCALL(fstat)
 51a:	b8 08 00 00 00       	mov    $0x8,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <link>:
SYSCALL(link)
 522:	b8 13 00 00 00       	mov    $0x13,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <mkdir>:
SYSCALL(mkdir)
 52a:	b8 14 00 00 00       	mov    $0x14,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <chdir>:
SYSCALL(chdir)
 532:	b8 09 00 00 00       	mov    $0x9,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <dup>:
SYSCALL(dup)
 53a:	b8 0a 00 00 00       	mov    $0xa,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <getpid>:
SYSCALL(getpid)
 542:	b8 0b 00 00 00       	mov    $0xb,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <sbrk>:
SYSCALL(sbrk)
 54a:	b8 0c 00 00 00       	mov    $0xc,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <sleep>:
SYSCALL(sleep)
 552:	b8 0d 00 00 00       	mov    $0xd,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <uptime>:
SYSCALL(uptime)
 55a:	b8 0e 00 00 00       	mov    $0xe,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <shutdown>:
SYSCALL(shutdown)
 562:	b8 16 00 00 00       	mov    $0x16,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <clone>:
SYSCALL(clone)
 56a:	b8 17 00 00 00       	mov    $0x17,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <join>:
SYSCALL(join)
 572:	b8 18 00 00 00       	mov    $0x18,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <thread_exit>:
SYSCALL(thread_exit)
 57a:	b8 19 00 00 00       	mov    $0x19,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <set_priority>:
SYSCALL(set_priority)
 582:	b8 1a 00 00 00       	mov    $0x1a,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <enable_sched_display>:
 58a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    
 592:	66 90                	xchg   %ax,%ax
 594:	66 90                	xchg   %ax,%ax
 596:	66 90                	xchg   %ax,%ax
 598:	66 90                	xchg   %ax,%ax
 59a:	66 90                	xchg   %ax,%ax
 59c:	66 90                	xchg   %ax,%ax
 59e:	66 90                	xchg   %ax,%ax

000005a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a9:	85 d2                	test   %edx,%edx
{
 5ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 5ae:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5b0:	79 76                	jns    628 <printint+0x88>
 5b2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5b6:	74 70                	je     628 <printint+0x88>
    x = -xx;
 5b8:	f7 d8                	neg    %eax
    neg = 1;
 5ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5c1:	31 f6                	xor    %esi,%esi
 5c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5c6:	eb 0a                	jmp    5d2 <printint+0x32>
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5d0:	89 fe                	mov    %edi,%esi
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	8d 7e 01             	lea    0x1(%esi),%edi
 5d7:	f7 f1                	div    %ecx
 5d9:	0f b6 92 88 0a 00 00 	movzbl 0xa88(%edx),%edx
  }while((x /= base) != 0);
 5e0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5e2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5e5:	75 e9                	jne    5d0 <printint+0x30>
  if(neg)
 5e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ea:	85 c0                	test   %eax,%eax
 5ec:	74 08                	je     5f6 <printint+0x56>
    buf[i++] = '-';
 5ee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5f3:	8d 7e 02             	lea    0x2(%esi),%edi
 5f6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5fa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
 600:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	83 ee 01             	sub    $0x1,%esi
 609:	6a 01                	push   $0x1
 60b:	53                   	push   %ebx
 60c:	57                   	push   %edi
 60d:	88 45 d7             	mov    %al,-0x29(%ebp)
 610:	e8 cd fe ff ff       	call   4e2 <write>

  while(--i >= 0)
 615:	83 c4 10             	add    $0x10,%esp
 618:	39 de                	cmp    %ebx,%esi
 61a:	75 e4                	jne    600 <printint+0x60>
    putc(fd, buf[i]);
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 628:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 62f:	eb 90                	jmp    5c1 <printint+0x21>
 631:	eb 0d                	jmp    640 <printf>
 633:	90                   	nop
 634:	90                   	nop
 635:	90                   	nop
 636:	90                   	nop
 637:	90                   	nop
 638:	90                   	nop
 639:	90                   	nop
 63a:	90                   	nop
 63b:	90                   	nop
 63c:	90                   	nop
 63d:	90                   	nop
 63e:	90                   	nop
 63f:	90                   	nop

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 75 0c             	mov    0xc(%ebp),%esi
 64c:	0f b6 1e             	movzbl (%esi),%ebx
 64f:	84 db                	test   %bl,%bl
 651:	0f 84 b3 00 00 00    	je     70a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 657:	8d 45 10             	lea    0x10(%ebp),%eax
 65a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 65d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 65f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 662:	eb 2f                	jmp    693 <printf+0x53>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 668:	83 f8 25             	cmp    $0x25,%eax
 66b:	0f 84 a7 00 00 00    	je     718 <printf+0xd8>
  write(fd, &c, 1);
 671:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 674:	83 ec 04             	sub    $0x4,%esp
 677:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 67a:	6a 01                	push   $0x1
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 5d fe ff ff       	call   4e2 <write>
 685:	83 c4 10             	add    $0x10,%esp
 688:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 68b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 68f:	84 db                	test   %bl,%bl
 691:	74 77                	je     70a <printf+0xca>
    if(state == 0){
 693:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 695:	0f be cb             	movsbl %bl,%ecx
 698:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 69b:	74 cb                	je     668 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69d:	83 ff 25             	cmp    $0x25,%edi
 6a0:	75 e6                	jne    688 <printf+0x48>
      if(c == 'd'){
 6a2:	83 f8 64             	cmp    $0x64,%eax
 6a5:	0f 84 05 01 00 00    	je     7b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6b1:	83 f9 70             	cmp    $0x70,%ecx
 6b4:	74 72                	je     728 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6b6:	83 f8 73             	cmp    $0x73,%eax
 6b9:	0f 84 99 00 00 00    	je     758 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bf:	83 f8 63             	cmp    $0x63,%eax
 6c2:	0f 84 08 01 00 00    	je     7d0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	0f 84 ef 00 00 00    	je     7c0 <printf+0x180>
  write(fd, &c, 1);
 6d1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6d4:	83 ec 04             	sub    $0x4,%esp
 6d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6db:	6a 01                	push   $0x1
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 fc fd ff ff       	call   4e2 <write>
 6e6:	83 c4 0c             	add    $0xc,%esp
 6e9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ef:	6a 01                	push   $0x1
 6f1:	50                   	push   %eax
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6f8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6fa:	e8 e3 fd ff ff       	call   4e2 <write>
  for(i = 0; fmt[i]; i++){
 6ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 706:	84 db                	test   %bl,%bl
 708:	75 89                	jne    693 <printf+0x53>
    }
  }
}
 70a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5f                   	pop    %edi
 710:	5d                   	pop    %ebp
 711:	c3                   	ret    
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 718:	bf 25 00 00 00       	mov    $0x25,%edi
 71d:	e9 66 ff ff ff       	jmp    688 <printf+0x48>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 728:	83 ec 0c             	sub    $0xc,%esp
 72b:	b9 10 00 00 00       	mov    $0x10,%ecx
 730:	6a 00                	push   $0x0
 732:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	8b 17                	mov    (%edi),%edx
 73a:	e8 61 fe ff ff       	call   5a0 <printint>
        ap++;
 73f:	89 f8                	mov    %edi,%eax
 741:	83 c4 10             	add    $0x10,%esp
      state = 0;
 744:	31 ff                	xor    %edi,%edi
        ap++;
 746:	83 c0 04             	add    $0x4,%eax
 749:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 74c:	e9 37 ff ff ff       	jmp    688 <printf+0x48>
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 75b:	8b 08                	mov    (%eax),%ecx
        ap++;
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 763:	85 c9                	test   %ecx,%ecx
 765:	0f 84 8e 00 00 00    	je     7f9 <printf+0x1b9>
        while(*s != 0){
 76b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 76e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 770:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 772:	84 c0                	test   %al,%al
 774:	0f 84 0e ff ff ff    	je     688 <printf+0x48>
 77a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 77d:	89 de                	mov    %ebx,%esi
 77f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 782:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 785:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 788:	83 ec 04             	sub    $0x4,%esp
          s++;
 78b:	83 c6 01             	add    $0x1,%esi
 78e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 791:	6a 01                	push   $0x1
 793:	57                   	push   %edi
 794:	53                   	push   %ebx
 795:	e8 48 fd ff ff       	call   4e2 <write>
        while(*s != 0){
 79a:	0f b6 06             	movzbl (%esi),%eax
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	84 c0                	test   %al,%al
 7a2:	75 e4                	jne    788 <printf+0x148>
 7a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7a7:	31 ff                	xor    %edi,%edi
 7a9:	e9 da fe ff ff       	jmp    688 <printf+0x48>
 7ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b8:	6a 01                	push   $0x1
 7ba:	e9 73 ff ff ff       	jmp    732 <printf+0xf2>
 7bf:	90                   	nop
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 7c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7c9:	6a 01                	push   $0x1
 7cb:	e9 21 ff ff ff       	jmp    6f1 <printf+0xb1>
        putc(fd, *ap);
 7d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7d6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7d8:	6a 01                	push   $0x1
        ap++;
 7da:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7e3:	50                   	push   %eax
 7e4:	ff 75 08             	pushl  0x8(%ebp)
 7e7:	e8 f6 fc ff ff       	call   4e2 <write>
        ap++;
 7ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7f2:	31 ff                	xor    %edi,%edi
 7f4:	e9 8f fe ff ff       	jmp    688 <printf+0x48>
          s = "(null)";
 7f9:	bb 7f 0a 00 00       	mov    $0xa7f,%ebx
        while(*s != 0){
 7fe:	b8 28 00 00 00       	mov    $0x28,%eax
 803:	e9 72 ff ff ff       	jmp    77a <printf+0x13a>
 808:	66 90                	xchg   %ax,%ax
 80a:	66 90                	xchg   %ax,%ax
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 e4 0d 00 00       	mov    0xde4,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	39 c8                	cmp    %ecx,%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	73 32                	jae    860 <free+0x50>
 82e:	39 d1                	cmp    %edx,%ecx
 830:	72 04                	jb     836 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	39 d0                	cmp    %edx,%eax
 834:	72 32                	jb     868 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 836:	8b 73 fc             	mov    -0x4(%ebx),%esi
 839:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83c:	39 fa                	cmp    %edi,%edx
 83e:	74 30                	je     870 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 840:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 843:	8b 50 04             	mov    0x4(%eax),%edx
 846:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 849:	39 f1                	cmp    %esi,%ecx
 84b:	74 3a                	je     887 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 84d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 84f:	a3 e4 0d 00 00       	mov    %eax,0xde4
}
 854:	5b                   	pop    %ebx
 855:	5e                   	pop    %esi
 856:	5f                   	pop    %edi
 857:	5d                   	pop    %ebp
 858:	c3                   	ret    
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 d0                	cmp    %edx,%eax
 862:	72 04                	jb     868 <free+0x58>
 864:	39 d1                	cmp    %edx,%ecx
 866:	72 ce                	jb     836 <free+0x26>
{
 868:	89 d0                	mov    %edx,%eax
 86a:	eb bc                	jmp    828 <free+0x18>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 870:	03 72 04             	add    0x4(%edx),%esi
 873:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 12                	mov    (%edx),%edx
 87a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 50 04             	mov    0x4(%eax),%edx
 880:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 883:	39 f1                	cmp    %esi,%ecx
 885:	75 c6                	jne    84d <free+0x3d>
    p->s.size += bp->s.size;
 887:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 88a:	a3 e4 0d 00 00       	mov    %eax,0xde4
    p->s.size += bp->s.size;
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 892:	8b 53 f8             	mov    -0x8(%ebx),%edx
 895:	89 10                	mov    %edx,(%eax)
}
 897:	5b                   	pop    %ebx
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret    
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 15 e4 0d 00 00    	mov    0xde4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 78 07             	lea    0x7(%eax),%edi
 8b5:	c1 ef 03             	shr    $0x3,%edi
 8b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8bb:	85 d2                	test   %edx,%edx
 8bd:	0f 84 9d 00 00 00    	je     960 <malloc+0xc0>
 8c3:	8b 02                	mov    (%edx),%eax
 8c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8c8:	39 cf                	cmp    %ecx,%edi
 8ca:	76 6c                	jbe    938 <malloc+0x98>
 8cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8e1:	eb 0e                	jmp    8f1 <malloc+0x51>
 8e3:	90                   	nop
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ea:	8b 48 04             	mov    0x4(%eax),%ecx
 8ed:	39 f9                	cmp    %edi,%ecx
 8ef:	73 47                	jae    938 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f1:	39 05 e4 0d 00 00    	cmp    %eax,0xde4
 8f7:	89 c2                	mov    %eax,%edx
 8f9:	75 ed                	jne    8e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	56                   	push   %esi
 8ff:	e8 46 fc ff ff       	call   54a <sbrk>
  if(p == (char*)-1)
 904:	83 c4 10             	add    $0x10,%esp
 907:	83 f8 ff             	cmp    $0xffffffff,%eax
 90a:	74 1c                	je     928 <malloc+0x88>
  hp->s.size = nu;
 90c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 90f:	83 ec 0c             	sub    $0xc,%esp
 912:	83 c0 08             	add    $0x8,%eax
 915:	50                   	push   %eax
 916:	e8 f5 fe ff ff       	call   810 <free>
  return freep;
 91b:	8b 15 e4 0d 00 00    	mov    0xde4,%edx
      if((p = morecore(nunits)) == 0)
 921:	83 c4 10             	add    $0x10,%esp
 924:	85 d2                	test   %edx,%edx
 926:	75 c0                	jne    8e8 <malloc+0x48>
        return 0;
  }
}
 928:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 92b:	31 c0                	xor    %eax,%eax
}
 92d:	5b                   	pop    %ebx
 92e:	5e                   	pop    %esi
 92f:	5f                   	pop    %edi
 930:	5d                   	pop    %ebp
 931:	c3                   	ret    
 932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 938:	39 cf                	cmp    %ecx,%edi
 93a:	74 54                	je     990 <malloc+0xf0>
        p->s.size -= nunits;
 93c:	29 f9                	sub    %edi,%ecx
 93e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 941:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 944:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 947:	89 15 e4 0d 00 00    	mov    %edx,0xde4
}
 94d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 950:	83 c0 08             	add    $0x8,%eax
}
 953:	5b                   	pop    %ebx
 954:	5e                   	pop    %esi
 955:	5f                   	pop    %edi
 956:	5d                   	pop    %ebp
 957:	c3                   	ret    
 958:	90                   	nop
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 e4 0d 00 00 e8 	movl   $0xde8,0xde4
 967:	0d 00 00 
 96a:	c7 05 e8 0d 00 00 e8 	movl   $0xde8,0xde8
 971:	0d 00 00 
    base.s.size = 0;
 974:	b8 e8 0d 00 00       	mov    $0xde8,%eax
 979:	c7 05 ec 0d 00 00 00 	movl   $0x0,0xdec
 980:	00 00 00 
 983:	e9 44 ff ff ff       	jmp    8cc <malloc+0x2c>
 988:	90                   	nop
 989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb b1                	jmp    947 <malloc+0xa7>
 996:	66 90                	xchg   %ax,%ax
 998:	66 90                	xchg   %ax,%ax
 99a:	66 90                	xchg   %ax,%ax
 99c:	66 90                	xchg   %ax,%ax
 99e:	66 90                	xchg   %ax,%ax

000009a0 <xthread_create>:
extern void join(int tid,void **ret_p,void **stack);
extern void thread_exit(void *ret);


int xthread_create(int * tid, void * (* start_routine)(void *), void * arg)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	83 ec 14             	sub    $0x14,%esp
    // add your implementation here ...
    void * stack = (void *)malloc(4096);
 9a6:	68 00 10 00 00       	push   $0x1000
 9ab:	e8 f0 fe ff ff       	call   8a0 <malloc>
    // printf(1,"malloc loc is %d",stack);

    (*tid) = clone(start_routine, (void*)((int)stack+4096), arg);
 9b0:	83 c4 0c             	add    $0xc,%esp
 9b3:	05 00 10 00 00       	add    $0x1000,%eax
 9b8:	ff 75 10             	pushl  0x10(%ebp)
 9bb:	50                   	push   %eax
 9bc:	ff 75 0c             	pushl  0xc(%ebp)
 9bf:	e8 a6 fb ff ff       	call   56a <clone>
 9c4:	8b 55 08             	mov    0x8(%ebp),%edx
    // printf(1,"tid: %d \n", *tid);
    // printf(1,"\nstack %d create : %d \n",*tid,(int)stack+4096);
    if(*tid < 0)
 9c7:	83 c4 10             	add    $0x10,%esp
    (*tid) = clone(start_routine, (void*)((int)stack+4096), arg);
 9ca:	89 02                	mov    %eax,(%edx)
        return -1;
    return 1;
 9cc:	c1 f8 1f             	sar    $0x1f,%eax
 9cf:	83 c8 01             	or     $0x1,%eax
}
 9d2:	c9                   	leave  
 9d3:	c3                   	ret    
 9d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000009e0 <xthread_exit>:


void xthread_exit(void * ret_val_p)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
    // add your implementation here ...
   thread_exit(ret_val_p);
}
 9e3:	5d                   	pop    %ebp
   thread_exit(ret_val_p);
 9e4:	e9 91 fb ff ff       	jmp    57a <thread_exit>
 9e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009f0 <xthread_join>:


void xthread_join(int tid, void ** retval)
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	83 ec 1c             	sub    $0x1c,%esp
    // add your implementation here ...
    void * stack;
    join(tid, retval, &stack);
 9f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9f9:	50                   	push   %eax
 9fa:	ff 75 0c             	pushl  0xc(%ebp)
 9fd:	ff 75 08             	pushl  0x8(%ebp)
 a00:	e8 6d fb ff ff       	call   572 <join>

    free((void *)((int)stack-4096));
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	2d 00 10 00 00       	sub    $0x1000,%eax
 a0d:	89 04 24             	mov    %eax,(%esp)
 a10:	e8 fb fd ff ff       	call   810 <free>
}
 a15:	83 c4 10             	add    $0x10,%esp
 a18:	c9                   	leave  
 a19:	c3                   	ret    
