#include <stdio.h>
#include <stdint.h>
#include <string.h>

void hello(void)
{
	printf("Hello World :D\n");
}

typedef void (*callback_type)(void);
void hello_callback_function(void)
{
	printf("Nho em qua :(\n");
}

callback_type func = hello_callback_function;

uint8_t add(uint8_t a, uint8_t b)
{
	return a + b;
}

void (*func_ptr)() = hello;
uint8_t (*fp)(uint8_t, uint8_t) = add;

struct option_type
{
	uint8_t option1;
	uint8_t option2;
	uint8_t option3;
};

typedef struct option_type option_type;

signed main(void)
{
	for (;;)
	{
		// Select option
		char a[100];
		scanf("%s", a);
		option_type opt = {0, 0, 0};
		
		if (strcmp(a, "option1") == 0)
		{
			opt.option1 = 1;
			opt.option2 = 0;
			opt.option3 = 0;
		}
		else if (strcmp(a, "option2") == 0)
		{
			opt.option1 = 0;
			opt.option2 = 1;
			opt.option3 = 0;
		}
		else if (strcmp(a, "option3") == 0)
		{
			opt.option1 = 0;
			opt.option2 = 0;
			opt.option3 = 1;
		}
		else if (strcmp(a, "exit") == 0)
		{
			return 0;
		}

		if (opt.option1)
		{
			func_ptr();
		}
		else if (opt.option2)
		{
			printf("Tong 2 so a va b la: %d\n", fp(10, 5));
		}
		else
		{
			func();
		}
	}
}
