

obj-m := module.o
PWD := $(shell pwd)
KVER := $(shell uname -r)
	
default:
    make -C /lib/modules/$(KVER)/build SUBDIRS=$(PWD) modules
