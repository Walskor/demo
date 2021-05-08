#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc,char* argv[]){
	printf(1,"OS Lab 161840230: ");
	if(argc > 1){
		for(int i = 1; i < argc;++i){
			printf(1,"%s ",argv[i]);
		}
	}
	printf(1,"\n");
	exit();
}
