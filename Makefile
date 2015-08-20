export TARGET=iphone:clang:latest:8.0
export ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Redirector
Redirector_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
