#include <libopencm3/stm32/gpio.h>

// __attribute__ ((section (".ramtext*")))
void blink(void)
{
    for (;;)
    {
        GPIOC_BRR = GPIO13;
        for (int i = 0; i < 1e6; i++)
        {
            __asm__("nop");
        }
        GPIOC_BSRR = GPIO13;
        for (int i = 0; i < 1e6; i++)
        {
            __asm__("nop");
        }
    }
}
