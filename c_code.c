#include "c_code.h"
#include <stdio.h>

int c_sum(int a, int b)
{
	printf("in C module\n");    // Just to 100% confirm we are triggering this code
	return a+b;
}
