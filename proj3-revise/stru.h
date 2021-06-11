#include "spinlock.h"

//semaphore
struct semaphore{
  struct spinlock lock;
  int value;             
  int used;        
  struct proc_list *procList;
  int length;
};

struct proc_list{
  struct proc *proc;
  struct proc_list *next;
};

// Massage trans
struct MSGstate{
  int pid;
  int positive;
  int target;
  int sid; //semaphore id
  int data[3];
  struct MSGstate *next;
};