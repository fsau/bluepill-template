CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
CPUFLAGS = -mcpu=cortex-m3 -mthumb
CFLAGS = -Wall -Wextra -g3 -Os -MD $(CPUFLAGS) -DSTM32F1 -I./libopencm3/include
LDFLAGS = $(CPUFLAGS) -nostartfiles -L./libopencm3/lib -Wl,-T,$(LDSCRIPT)
LDLIBS = -lopencm3_stm32f1 -lc -lnosys

CSRC = main.c
OBJ = $(patsubst %.c,build/%.o,$(CSRC))
TARGET = build/main
LDSCRIPT = bluepill.ld

all: $(TARGET).bin $(TARGET).dis

build:
	mkdir -p build

$(TARGET).elf: $(OBJ) libopencm3 | build
	$(CC) $(LDFLAGS) -o $@ $(OBJ) $(LDLIBS)

build/%.o: %.c | build
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: libopencm3
libopencm3:
	if [ ! -f libopencm3/Makefile ]; then \
		git submodule init; \
		git submodule update; \
	fi
	$(MAKE) -C libopencm3 lib/stm32/f1

.PHONY: clean
clean:
	-rm -rf build
	#-$(MAKE) -C libopencm3 clean

build/%.bin: build/%.elf
	$(OBJCOPY) -O binary $< $@

build/%.dis: build/%.elf
	$(OBJDUMP) -S -g $< > $@

prog: $(TARGET).bin
	st-flash write $< 0x08000000
