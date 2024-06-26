CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
READELF = $(CROSS_COMPILE)readelf
NM = $(CROSS_COMPILE)nm
SIZE = $(CROSS_COMPILE)size
CPUFLAGS = -mcpu=cortex-m3 -mthumb
CFLAGS = -Wall -Wextra -g3 -Os -MD $(CPUFLAGS) -DSTM32F1 -I./libopencm3/include -Imodules
LDFLAGS = $(CPUFLAGS) -nostartfiles -L./libopencm3/lib -Wl,-T,$(LDSCRIPT) -Wl,-Map,$(TARGET).map
LDLIBS = -lopencm3_stm32f1 -lc -lnosys

CSRC = $(wildcard modules/*.c) main.c 
OBJ = $(patsubst %.c,build/%.o,$(CSRC))
TARGET = build/main
LDSCRIPT = bluepill.ld

all: libopencm3 $(TARGET).bin $(TARGET).dis $(TARGET).sym $(TARGET).size $(TARGET).map $(TARGET).elf.txt

build:
	mkdir -p build
	mkdir -p build/modules

$(TARGET).elf: $(OBJ) $(LDSCRIPT) | build
	$(CC) $(LDFLAGS) -o $@ $(OBJ) $(LDLIBS)

build/%.o: %.c | build
	$(CC) $(CFLAGS) -c $< -o $@

-include $(OBJ:.o=.d)

build/%.bin: build/%.elf
	$(OBJCOPY) -O binary $< $@

build/%.dis: build/%.elf
	$(OBJDUMP) -S -g $< > $@

build/%.sym: build/%.elf
	$(NM) $< > $@

build/%.size: build/%.elf
	$(SIZE) $< > $@

build/%.elf.txt: build/%.elf
	$(READELF) -a $< > $@

.PHONY: libopencm3 clean prog

libopencm3:
	if [ ! -f libopencm3/Makefile ]; then \
		git submodule init; \
		git submodule update; \
	fi
	$(MAKE) -C libopencm3 lib/stm32/f1

clean:
	-rm -r build
	#-$(MAKE) -C libopencm3 clean

prog: $(TARGET).bin
	st-flash write $< 0x08000000
