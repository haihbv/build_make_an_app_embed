#include <stdio.h>
#include "sys.h"

#define RCC_BASE_ADDR 0x40021000
#define RCC_APB2ENR (*(volatile uint32_t *)(RCC_BASE_ADDR + 0x18))

#define GPIOA_BASE_ADDR 0x40010800
#define GPIOA_CRL (*(volatile uint32_t *)(GPIOA_BASE_ADDR + 0x00))
#define GPIOA_ODR (*(volatile uint32_t *)(GPIOA_BASE_ADDR + 0x0C))

int main()
{
	// enable clock
	RCC_APB2ENR |= (1 << 2);
	
	// configuration GPIOA - Pin 0
	// Reset and set mode output push-pull, 50MHz - 0011b = 0x03h
	systick_init();
	GPIOA_CRL &= ~(0xF << 0);  // Clear 4 bits for pin 0
	GPIOA_CRL |= (0x3 << 0);   // Set mode: output 50MHz, push-pull
	
	while (1)
	{
		GPIOA_ODR |= (1 << 0);
		delay_ms(1000);
		GPIOA_ODR &= ~(1 << 0);
		delay_ms(1000);
	}
}
