include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = RedirectorPrefs
RedirectorPrefs_FILES = RDORootListController.m
RedirectorPrefs_INSTALL_PATH = /Library/PreferenceBundles
RedirectorPrefs_FRAMEWORKS = UIKit
RedirectorPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RedirectorPrefs.plist$(ECHO_END)
