GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 10.0.1.9
THEOS_DEVICE_PORT = 22

TARGET = iphone:clang:latest:7.0
ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppEx
AppEx_CFLAGS = -fobjc-arc
AppEx_FILES = Tweak.xmi
AppEx_LIBRARIES = substrate
AppEx_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
