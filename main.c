#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

static void gpio_setup(void)
{
	rcc_periph_clock_enable(RCC_GPIOC);
	gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_50_MHZ, GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);
}

int main(void)
{	
    rcc_clock_setup_pll(&rcc_hse_configs[RCC_CLOCK_HSE8_72MHZ]);
	gpio_setup();
	
	for (;;) {
        // Clear the pin
        GPIOC_BRR = GPIO13;
        for (int i = 0; i < 1e6; i++) {
            __asm__("nop");
        }
        // // Set the pin
        GPIOC_BSRR = GPIO13;
        for (int i = 0; i < 1e6; i++) {
            __asm__("nop");
        }
	}
	return 0;
}