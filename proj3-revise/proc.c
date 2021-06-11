#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "stat.h"

#include "proc.h"
#include "spinlock.h"
#define SEM_SIZE 100
#define NULL 0
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

//semaphore
struct semaphore{
  struct spinlock lock;
  int value;             
  int used;        
  struct proc_list *procList;
  int length;
};

struct proc_list{
  int id;
  int used;
  struct proc *proc;
  struct proc_list *next;
};

// Massage trans
struct MSGstate{
  int id;
  int pid;
  int used;
  int positive;
  int target;
  int sid; //semaphore id
  int data[3];
  struct MSGstate *next;
};

struct semaphore semaphores[SEM_SIZE];
struct spinlock semaphores_lock;
struct spinlock PLlock;
struct spinlock MSlock;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
void* malloc(uint);
void free(void*);

// void*
// malloc(uint nbytes)
// {
//   Header *p, *prevp;
//   uint nunits;

//   nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
//   if((prevp = freep) == 0){
//     base.s.ptr = freep = prevp = &base;
//     base.s.size = 0;
//   }
//   for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
//     if(p->s.size >= nunits){
//       if(p->s.size == nunits)
//         prevp->s.ptr = p->s.ptr;
//       else {
//         p->s.size -= nunits;
//         p += p->s.size;
//         p->s.size = nunits;
//       }
//       freep = prevp;
//       return (void*)(p + 1);
//     }
//     if(p == freep)
//       if((p = morecore(nunits)) == 0)
//         return 0;
//   }
// }


// void
// free(void *ap)
// {
//   Header *bp, *p;

//   bp = (Header*)ap - 1;
//   for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
//     if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
//       break;
//   if(bp + bp->s.size == p->s.ptr){
//     bp->s.size += p->s.ptr->s.size;
//     bp->s.ptr = p->s.ptr->s.ptr;
//   } else
//     bp->s.ptr = p->s.ptr;
//   if(p + p->s.size == bp){
//     p->s.size += bp->s.size;
//     p->s.ptr = bp->s.ptr;
//   } else
//     p->s.ptr = bp;
//   freep = p;
// }

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

struct proc_list PL[1000];
struct MSGstate MS[1000];

struct proc_list *
PLalloc(){
  acquire(&PLlock);
  int i;
  for(i = 0 ; i < 1000; i++){
    if(PL[i].used == 0){
      goto found;
    }
  }
  release(&PLlock);
  return NULL;

found:
  PL[i].used = 1;
  release(&PLlock);
  return &PL[i];
}

struct MSGstate *
MSalloc(){
  acquire(&MSlock);
  int i;
  for(i = 0 ; i < 1000; i++){
    if(MS[i].used == 0){
      goto found;
    }
  }
  release(&MSlock);
  return NULL;

found:
  MS[i].used = 1;
  release(&MSlock);
  return &MS[i];
}

int
PLfree(struct proc_list *pl){
  acquire(&PLlock);
  pl->used = 0;
  release(&PLlock);
  return 1;
}

int
MSfree(struct MSGstate *ms){
  acquire(&MSlock);
  ms->used = 0;
  release(&MSlock);
  return 1;
}

int            
alloc_sem(int v)
{
  if(v < 0) return -1;
  int index;
  acquire(&semaphores_lock);
  for(index = 0; index < SEM_SIZE; index++){
    if(semaphores[index].used == 0){
      semaphores[index].used = 1;
      semaphores[index].value = v;
      semaphores[index].procList = NULL;
      semaphores[index].length = 0;
      initlock(&semaphores[index].lock,"sem");
      release(&semaphores_lock);
      return index;
    }
  }
  release(&semaphores_lock);
  return -1;
}

int             
wait_sem(int i)
{
  if(i < 0 || i >= SEM_SIZE) return -1;
  if(semaphores[i].used == 0) return -1;
  acquire(&semaphores[i].lock);
  semaphores[i].value--;
  // cprintf("----------------------------%d value --  now value is %d\n", i,semaphores[i].value);
  if(semaphores[i].value < 0){
    struct proc_list *p = semaphores[i].procList;
    // p = (struct proc_list *)Dmalloc(0);
    if(semaphores[i].length == 0) {
      semaphores[i].procList= PLalloc();
      p = semaphores[i].procList;
    }else{
      while(p->next != NULL) p = p->next;
      p->next = PLalloc();
      p = p->next;
    }
    if(p == NULL) return -1;
    semaphores[i].length += 1;
    p->proc = myproc();
    p->next = NULL;
    // p = semaphores[i].procList;
    // cprintf("---------------------\n---------------------now waiting : ");
    // while(p != NULL) {
    //   cprintf("-%d-",p->proc->pid);
    //   p = p->next;
    // }
    // cprintf("    count is %d\n",semaphores[i].length);
    sleep(myproc(), &semaphores[i].lock);
  }
  
  release(&semaphores[i].lock);
  return 1;
}

int             
signal_sem(int i)
{
  if(i < 0 || i >= SEM_SIZE) return -1;
  if(semaphores[i].used == 0) return -1;
  acquire(&semaphores[i].lock);
  semaphores[i].value++;
  // cprintf("----------------------------%d value ++  now value is %d\n", i,semaphores[i].value);
  if(semaphores[i].value <= 0){
    wakeup(semaphores[i].procList->proc);
    struct proc_list *p = semaphores[i].procList;
    semaphores[i].procList = p->next;
    PLfree(p);
    semaphores[i].length -- ;
    // p = semaphores[i].procList;
    // cprintf("---------------------\n---------------------now waiting : ");
    // while(p != NULL) {
    //   cprintf("-%d-",p->proc->pid);
    //   p = p->next;
    // }
    // cprintf("    count is %d\n",semaphores[i].length);
  }
  release(&semaphores[i].lock);
  return 1;
}

int             
dealloc_sem(int i)
{
  if(i < 0 || i >= SEM_SIZE) return -1;
  if(semaphores[i].used == 0) return -1;
  acquire(&semaphores[i].lock);
  if(semaphores[i].used == 1){
    semaphores[i].used = 0;
    while(semaphores[i].procList != NULL)
    {
      kill(semaphores[i].procList->proc->pid);
      struct proc_list *p = semaphores[i].procList;
      semaphores[i].procList = p->next;
      PLfree(p);
    }
  }
  release(&semaphores[i].lock);
  return 1;
}

struct MSGstate * Msend[NPROC];
struct MSGstate * Mrecv[NPROC];
struct spinlock Msg_lock;

void initMsg(){
  initlock(&Msg_lock,"msg_lock");
  initlock(&semaphores_lock,"sem");
  initlock(&PLlock,"proclist_lock");
  for(int i = 0 ; i < 1000; i++){
    PL[i].used = 0;
    PL[i].id = i;
    MS[i].id = i;
    MS[i].used = 0;
  }
  initlock(&MSlock,"massage_lock");
  for(int i = 0; i < NPROC; i++){
      Msend[i] = NULL;
      Mrecv[i] = NULL;
  }
  return;
}

// get the location in ptable by pid
int
getProcNum(int pidd)
{
  struct proc *p;

  acquire(&ptable.lock);
  int num = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++,num++){
    if(p->pid == pidd){
      release(&ptable.lock);
      return num;
    }
  }
  release(&ptable.lock);
  return -1;
}

int       
msg_send(int pid, int a, int b, int c){
  int found = getProcNum(pid);
  int semaphore;
  if(found < 0) 
    return -1;

  acquire(&Msg_lock);
  int now_pid = myproc()->pid;
  int myNum = getProcNum(now_pid);
  struct MSGstate *p = Mrecv[found];
  // int flag = 1;
  // cprintf("in %d sending is %d   \n",pid,Mrecv[found]);
  for(; p != NULL ; p = p->next){  // if the target is waiting for receiving
    // flag = 0;
    if(p->positive == 1 && p->pid == pid){
      // cprintf("get inside send positive %d--->%d   found: %d\n",now_pid, pid, found);
      p->data[0] = a;
      p->data[1] = b;
      p->data[2] = c;
      p->target = now_pid;   //set the target to be the process
      signal_sem(p->sid);
      release(&Msg_lock);
      return 1;
    }
  }
  // if(flag) cprintf("get nothing %d--->%d  found : %d\n",now_pid, pid, found);
  // cprintf("get outside send positive %d--->%d\n",now_pid, pid);
  struct MSGstate *myp = Msend[myNum];
  p = Mrecv[found];
  semaphore = alloc_sem(0);
  if(semaphore == -1) return -1;
  
  if(Mrecv[found] == NULL){   // set a nagetive receive for the target
    Mrecv[found] = MSalloc();
    p = Mrecv[found];
  }else{
    
    for(; p->next !=NULL; p = p->next);
    p->next = MSalloc();   
    p = p->next;
  }
  if(p == NULL) return -1;
  p->pid = pid;
  p->positive = 0;
  p->data[0] = a;
  p->data[1] = b;
  p->data[2] = c;
  p->target = myNum;
  p->sid = semaphore;
  p->next = NULL;

  Msend[myNum] =  MSalloc();   
  myp = Msend[myNum];
  if(myp == NULL) return -1;
  myp->pid = now_pid;  // set a positive send for the process itself
  myp->positive = 1;
  myp->data[0] = a;
  myp->data[1] = b;
  myp->data[2] = c;
  myp->target = found;
  myp->sid = semaphore;
  release(&Msg_lock);

  wait_sem(semaphore);

  acquire(&Msg_lock);
  MSfree(myp);
  Msend[myNum] = NULL;
  dealloc_sem(semaphore);
  release(&Msg_lock);

  return 1;
}

int            
msg_receive(int* a, int* b, int* c){
  int i;
  int target;
  int now_pid= myproc()->pid;
  int flag = 0;
  int semaphore;
  int myNum = getProcNum(now_pid);
  struct MSGstate * pre_p = Mrecv[myNum];
  struct MSGstate * p = Mrecv[myNum];

  acquire(&Msg_lock);

  for(i = 0; p != NULL; p = p->next ,flag = 1, i++){  // if other process has sent some msg
      if(flag) pre_p = pre_p->next;
      if(p->pid == now_pid && p->positive == 0){
        *a = p->data[0];
        *b = p->data[1];
        *c = p->data[2];
        // cprintf("now recieve %d \n",*a);
        target = p->target;
        semaphore = p->sid;
        if(i == 0) Mrecv[myNum] = p->next;
        else{
          pre_p->next = p->next;
        }
        MSfree(p);
        signal_sem(semaphore);
        release(&Msg_lock);
        return target;
      }
  }
  
  for(i = 0; p != NULL; p = p->next ,flag = 1, i++){  // if other process has sent some msg
      if(flag) pre_p = pre_p->next;
      if(p->pid != now_pid){
        if(i == 0) Mrecv[myNum] = p->next;
        else{
          pre_p->next = p->next;
        }
        MSfree(p);
      }
  }
  semaphore = alloc_sem(0);
  if(semaphore == -1){
    release(&Msg_lock);
    return -1;
  } 
  if(Mrecv[myNum]==NULL){
    Mrecv[myNum] = MSalloc();
    // cprintf("\n----------------want things pid: %d myNUM: %d\n\n",now_pid, myNum);
    p = Mrecv[myNum];
  }else{
    pre_p->next = MSalloc();
    p = pre_p->next;
  }
  if(p == NULL) {
    cprintf("allocate wrong\n");
    return -1;
  }

  p->pid = now_pid;
  p->positive = 1;
  p->sid = semaphore;
  p->target = myNum;
  p->next = NULL;

  // cprintf("in %d recv is %d   \n",now_pid,Mrecv[myNum]->pid);
  release(&Msg_lock);
  // cprintf("%d  in waiting\n",p->pid);
  wait_sem(semaphore);
  acquire(&Msg_lock);
  // cprintf("%d  finish waiting\n",p->pid);
  *a = p->data[0];
  *b = p->data[1];
  *c = p->data[2];
  target = p->target;
  if(i == 0) Mrecv[myNum] = p->next;
  else{
       pre_p->next = p->next;
      }
  MSfree(p);
  dealloc_sem(semaphore);
  release(&Msg_lock);
  return target;
}