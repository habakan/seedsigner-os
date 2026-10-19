################################################################################
#
# wamr
#
################################################################################

WAMR_VERSION = 2.4.5
WAMR_SITE = $(call github,bytecodealliance,wasm-micro-runtime,WAMR-$(WAMR_VERSION))
WAMR_LICENSE = Apache-2.0 WITH LLVM-exception
WAMR_LICENSE_FILES = LICENSE
WAMR_SUBDIR = product-mini/platforms/linux

# The configuration bitwasm-signer tests against (its Makefile's libiwasm)
WAMR_CONF_OPTS = \
	-DWAMR_BUILD_INTERP=1 -DWAMR_BUILD_FAST_INTERP=0 -DWAMR_BUILD_DEBUG_INTERP=0 \
	-DWAMR_BUILD_AOT=0 -DWAMR_BUILD_JIT=0 -DWAMR_BUILD_SIMD=0 \
	-DWAMR_BUILD_LIBC_BUILTIN=0 -DWAMR_BUILD_LIBC_WASI=0 -DBUILD_SHARED_LIBS=ON

ifeq ($(BR2_aarch64),y)
WAMR_CONF_OPTS += -DWAMR_BUILD_TARGET=AARCH64
else ifeq ($(BR2_ARM_CPU_ARMV6),y)
WAMR_CONF_OPTS += -DWAMR_BUILD_TARGET=ARMV6$(if $(BR2_ARM_EABIHF),_VFP)
else
WAMR_CONF_OPTS += -DWAMR_BUILD_TARGET=ARMV7$(if $(BR2_ARM_EABIHF),_VFP)
endif

# Only the library: the iwasm command line and the CMake package are not needed on the device
define WAMR_REMOVE_EXTRAS
	rm -rf $(TARGET_DIR)/usr/bin/iwasm $(TARGET_DIR)/usr/lib/cmake/iwasm
endef
WAMR_POST_INSTALL_TARGET_HOOKS += WAMR_REMOVE_EXTRAS

$(eval $(cmake-package))
