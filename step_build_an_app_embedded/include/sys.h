#ifndef SYSTEM_TICK_H
#define SYSTEM_TICK_H

#include <stdint.h>

#define SYSTEM_CORE_8MHZ
// #define SYSTEM_CORE_24MHZ
// #define SYSTEM_CORE_36MHZ
// #define SYSTEM_CORE_72MHZ

#ifdef SYSTEM_CORE_8MHZ
#define SYSTEM_CORE_CLOCK 8000
#endif

#ifdef SYSTEM_CORE_24MHZ
#define SYSTEM_CORE_CLOCK 24000
#endif

#ifdef SYSTEM_CORE_36MHZ
#define SYSTEM_CORE_CLOCK 36000
#endif

#ifdef SYSTEM_CORE_72MHZ
#define SYSTEM_CORE_CLOCK 72000
#endif

typedef struct
{
	volatile uint32_t CTRL;
	volatile uint32_t LOAD;
	volatile uint32_t VAL;
	volatile uint32_t CALIB;
} SysTick_TypeDef;

#define SYSTICK ((SysTick_TypeDef *)0xE000E010Ul)

extern volatile uint32_t tick;

void systick_init(void);
uint32_t millis(void);
void delay_ms(uint32_t ms);
void delay_us(uint8_t us);

#endif /* SYSTEM_TICK_H*/
