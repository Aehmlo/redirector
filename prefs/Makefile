include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Redirector
Redirector_FILES = RDORootListController.m
Redirector_INSTALL_PATH = /Library/PreferenceBundles
Redirector_FRAMEWORKS = UIKit
Redirector_PRIVATE_FRAMEWORKS = Preferences
Redirector_LIBRARIES = cepheiprefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Redirector.plist$(ECHO_END)
