#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include "blink.h"

int main(void)
{
    rcc_clock_setup_pll(&rcc_hse_configs[RCC_CLOCK_HSE8_72MHZ]);
    rcc_periph_clock_enable(RCC_GPIOC);
    gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ, GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);

    blink();
    return 0;
}
