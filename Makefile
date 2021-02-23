# SPDX-License-Identifier: GPL-2.0
#
# Makefile for the ntfs3 filesystem support.
#
ifneq ($(KERNELRELEASE),)
obj-$(CONFIG_NTFS3_FS) += ntfs3.o

ntfs3-y :=	attrib.o \
		attrlist.o \
		bitfunc.o \
		bitmap.o \
		dir.o \
		fsntfs.o \
		frecord.o \
		file.o \
		fslog.o \
		inode.o \
		index.o \
		lznt.o \
		namei.o \
		record.o \
		run.o \
		super.o \
		upcase.o \
		xattr.o
else
# Called from external kernel module build

KERNELRELEASE	?= $(shell uname -r)
KDIR	?= /lib/modules/${KERNELRELEASE}/build
MDIR	?= /lib/modules/${KERNELRELEASE}
PWD	:= $(shell pwd)

export CONFIG_NTFS3_FS := m

ntfs3-$(CONFIG_NTFS3_LZX_XPRESS) += $(addprefix lib/,\
		decompress_common.o \
		lzx_decompress.o \
		xpress_decompress.o \
		)

ccflags-$(CONFIG_NTFS3_LZX_XPRESS) += -DCONFIG_NTFS3_LZX_XPRESS
ccflags-$(CONFIG_NTFS3_FS_POSIX_ACL) += -DCONFIG_NTFS3_FS_POSIX_ACL

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install: ntfs3.ko
	rm -f ${MDIR}/kernel/fs/ntfs3/ntfs3.ko
	install -m644 -b -D ntfs3.ko ${MDIR}/kernel/fs/ntfs3/ntfs3.ko
	depmod -aq

uninstall:
	rm -rf ${MDIR}/kernel/fs/ntfs3
	depmod -aq

endif

.PHONY : all clean install uninstal
