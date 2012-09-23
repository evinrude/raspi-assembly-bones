ARMGNU ?= arm-none-eabi

all: kernel.img

clean :
	rm -f *.o
	rm -f *.elf
	rm -f *.list
	rm -f *.img

miniuart01.o:
	$(ARMGNU)-as *.s ../common/*.s -o miniuart01.o 

miniuart01.elf: miniuart01.o 
	$(ARMGNU)-ld miniuart01.o -T map -o miniuart01.elf
	$(ARMGNU)-objdump -D miniuart01.elf > miniuart01.list

kernel.img: miniuart01.elf
	$(ARMGNU)-objcopy miniuart01.elf -O binary kernel.img
