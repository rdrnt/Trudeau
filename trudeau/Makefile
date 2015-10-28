include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = trudeau
trudeau_FILES = trdRootListController.m
trudeau_INSTALL_PATH = /Library/PreferenceBundles
trudeau_FRAMEWORKS = UIKit
trudeau_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/trudeau.plist$(ECHO_END)
