#include <libopencm3/stm32/gpio.h>

__attribute__ ((section (".code_in_ram")))
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
