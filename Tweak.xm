#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBIconModel.h>

#import <Cephei/HBPreferences.h>

BOOL enabled;
NSDictionary *redirects;

static void doTheThing(id self, SEL _cmd, SBApplicationIcon *_icon, void orig(SBIconController *, SEL, SBApplicationIcon *)) {	

	if(enabled) {

		NSString *identifier;

		if([_icon.application respondsToSelector:@selector(displayIdentifier)]) {
			identifier = _icon.application.displayIdentifier;
		} else if([_icon.application respondsToSelector:@selector(bundleIdentifier)]) {
			identifier = _icon.application.bundleIdentifier;
		} else {
			HBLogError(@"Redirector: icon's parent application object does not understand displayIdentifier or bundleIdentifier. Aborting. Please consider sending an email from Cydia for help.");
			orig(self, _cmd, _icon);
			return;
		}

		if(redirects[identifier]) {

			SBIconController *controller = [%c(SBIconController) sharedInstance];
			SBIconModel *model = controller.model; // Better than weird casts.

			SBApplicationIcon *icon = nil;
			if([model respondsToSelector:@selector(applicationIconForDisplayIdentifier:)]) {
				icon = [model applicationIconForDisplayIdentifier:redirects[identifier]];
			} else if([model respondsToSelector:@selector(applicationIconForBundleIdentifier:)]) {
				icon = [model applicationIconForBundleIdentifier:redirects[identifier]];
			}

			if(!icon) {
				HBLogWarn(@"Redirector: No target icon found for redirect %@ => %@; using tapped icon instead.", identifier, redirects[identifier]);
			}

			orig(self, _cmd, icon ?: _icon);
			return;
		}

	}

	orig(self, _cmd, _icon);

}

%hook SBIconController

- (void)_launchIcon:(SBApplicationIcon *)icon { // iOS 4–8

	doTheThing(self, _cmd, icon, &%orig);

}

- (void)launchIcon:(SBApplicationIcon *)icon { // iOS 3

	doTheThing(self, _cmd, icon, &%orig);

}

%end

%ctor {

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.aehmlo.redirector"];

	[preferences registerBool:&enabled default:YES forKey:@"Enabled"];

	[preferences registerObject:&redirects default:@{
		@"com.apple.weather" : @"com.offcoast.weatherline",
		@"com.apple.mobilecal" : @"com.flexibits.fantastical2.iphone"
	} forKey:@"Redirects"];

}