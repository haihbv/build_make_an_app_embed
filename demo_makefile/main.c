#include <stdio.h>

#define X 10
#define Y 5

int add(int a, int b)
{
	return a + b;
}

int main() 
{
	printf("Sum of two number is: %d\n", add(X, Y));
}
