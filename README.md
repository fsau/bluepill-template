# STM32F103 (Bluepill) Blink Template

## Importing `libopencm3`

Run:

```
git submodule add https://github.com/libopencm3/libopencm3.git
git submodule update --init --recursive
```

## Building:

`make -B -o libopencm3` for unconditionally (re)compiling everything but libopencm3, otherwise just run `make`.
