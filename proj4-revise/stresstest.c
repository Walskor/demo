
#include "types.h"
#include "user.h"

int data[4096];//4 pages; cannot put it into stack 
int
main(int argc, char *argv[]){       
    int pre,post;
    int n,i,pid;    
    // int bef,aff;
    pre=get_free_frame_cnt();
    for(n=0;n<64;n++){
      // bef = get_free_frame_cnt();
      pid=fork();
      // aff = get_free_frame_cnt();
      // printf(1,"====================  %d\n",bef-aff); 
      if(pid==0){
        // bef = get_free_frame_cnt();
        // printf(1,"\nnow turn: %d \n before data change: %d",n+1,get_free_frame_cnt());
        data[0]='a';   
        for(int i = 0 ; i < 1000000;i++);
        // aff = get_free_frame_cnt();
        // printf(1,"========== in %d , bef-aff = %d\n",n+1,bef-aff); 
        exit();
      }else if(pid<0)
        break;
      
    
    }
    printf(1,"created %d child processes\n",n);
    while(i<0xfffffff)i++; //wait for some time
    post=get_free_frame_cnt();
    while(n--)wait();
    printf(1,"pre: %d, post: %d\n",pre,post);    
    exit();
}

