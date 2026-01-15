#include "sys.h"

volatile uint32_t tick = 0;

void systick_init(void)
{
	SYSTICK->CTRL &= ~(0xffff);
	SYSTICK->VAL = 0;
	SYSTICK->LOAD = SYSTEM_CORE_CLOCK - 1;
	// 0111 = 7
	SYSTICK->CTRL |= (7 << 0);
}
inline uint32_t millis(void)
{
	return tick;
}
void delay_ms(uint32_t ms)
{
	uint32_t tmpval = millis();
	while ((millis() - tmpval) < ms)
		;
}
void delay_us(uint8_t us)
{
	uint8_t i = 0;
	for (i = 0; i < us; i++)
	{
		int cnt = 9;
		while (cnt--)
		{
			__asm volatile("nop");
		}
	}
}

void SysTick_Handler(void)
{
	++tick;
}
