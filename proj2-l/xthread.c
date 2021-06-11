#include "types.h"
#include "user.h"

extern int clone(void *(*fn)(void *),void *stack,void *arg);
extern void join(int tid,void **ret_p,void **stack);
extern void thread_exit(void *ret);


int xthread_create(int * tid, void * (* start_routine)(void *), void * arg)
{
    // add your implementation here ...
    void * stack = (void *)malloc(4096);
    // printf(1,"malloc loc is %d",stack);

    (*tid) = clone(start_routine, (void*)((int)stack+4096), arg);
    // printf(1,"tid: %d \n", *tid);
    // printf(1,"\nstack %d create : %d \n",*tid,(int)stack+4096);
    if(*tid < 0)
        return -1;
    return 1;
}


void xthread_exit(void * ret_val_p)
{
    // add your implementation here ...
   thread_exit(ret_val_p);
}


void xthread_join(int tid, void ** retval)
{
    // add your implementation here ...
    void * stack;
    join(tid, retval, &stack);

    free((void *)((int)stack-4096));
}
