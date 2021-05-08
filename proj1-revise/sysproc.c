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
  int arg;
  int ctrl;
  // for(int i = 0 ; i < 40;i++){
  //   argint(i,&arg);
  //   cprintf("%d  :  %d\n",i,arg);
  // }
  if(argint(0,&ctrl) < 0){
    return -1;
  } 
  if(argint(1,&arg) < 0){
    return -1;
  }  // the function argument is defined in file syscall.c
  if(ctrl == 1){
    cprintf("Leaving with code %d\n",arg);
  }
  outw(0x604, 0x2000);
  return 0;
}

int 
sys_fork_winner(void){

  if(argint(0,&winner)<0)
    return -1;
  return 0;
}