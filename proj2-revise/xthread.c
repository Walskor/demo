#include "types.h"
#include "user.h"

extern int clone(void *(*fn)(void *),void *stack,void *arg);
extern void join(int tid,void **ret_p,void **stack);
extern void thread_exit(void *ret);


int xthread_create(int * tid, void * (* start_routine)(void *), void * arg)
{
    // add your implementation here ...
    int flag;
    void *stack;
    stack = (void *)malloc(4096);
    flag = clone(start_routine, (void *)((int)stack+4096), arg);
    if(flag == -1){
        return -1;
    }
    *tid = flag;
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
   void *stack;
    join(tid, retval, &stack);
    free(stack);
    
}
