#include "types.h"
#include "stat.h"
#include "user.h"

extern int shutdown();

int
main(int argc, char *argv[])
{
  int arg = 0;
  int ctrl = 0;
  char *number = "";
  if(argc > 1){
    number = argv[1];
    ctrl = 1;
  }
  while(strlen(number)>0){
    arg = arg * 10;
    arg+=number[0]-'0';
    number += 1;
  }
  shutdown(ctrl,arg);
  exit();
}
