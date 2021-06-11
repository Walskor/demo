#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_shutdown(void){
  outw(0x604, 0x2000);
  return 0;
}

// int clone(void * (*fn)(void *), void *stack, void *arg)
int 
sys_clone(void){
  int func, stack, arg;
  if(argint(0 , &func) < 0){
    return 0;
  }
  if(argint(1 , &stack) < 0){
    return 0;
  }
  if(argint(2 , &arg) < 0){
    return 0;
  }
  // fork
  return clone((void *)func,(void *)stack,(void *)arg);
}

// void join(int tid, void ** ret_p, void ** stack)
int
sys_join(void){
  int tid, ret_p, stack;
  if(argint(0 , &tid) < 0){
    return 0;
  }
  if(argint(1 , &ret_p) < 0){
    return 0;
  }
  if(argint(2 , &stack) < 0){
    return 0;
  }
  return join(tid,(void **)ret_p, (void **)stack);
}

// void thread_exit(void *ret);
int 
sys_thread_exit(void){
  int ret;
  if(argint(0 , &ret) < 0){
    return 0;
  }

  return thread_exit((void *)ret);
}

int 
sys_set_priority(void){
  int pid, prior;
  if(argint(0 , &pid) < 0){
    return 0;
  }
  if(argint(1 , &prior) < 0){
    return 0;
  }
  return set_priority(pid, prior);
}

int
sys_enable_sched_display(void){
  int i;
  if(argint(0 , &i) < 0){
    return 0;
  }
  return enable_sched_display(i);
}
