include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Trudeau
Trudeau_FILES = Tweak.xm
Trudeau_PRIVATE_FRAMEWORKS  = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

GO_EASY_ON_ME=1

after-install::
	install.exec "killall -9 SpringBoard"
