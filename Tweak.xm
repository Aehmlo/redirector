#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBIconModel.h>

#import <Cephei/HBPreferences.h>

BOOL enabled, calendar, weather;

%group iOS5

%hook SBIconController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)_launchIcon:(SBApplicationIcon *)_icon {

	if(enabled && weather && [_icon.application.displayIdentifier isEqualToString:@"com.apple.weather"]) {

		SBIconController *controller = [%c(SBIconController) sharedInstance];
		SBApplicationIcon *icon = [controller.model applicationIconForDisplayIdentifier:@"com.skymotion.skymotion"];
		%orig(icon ?: _icon);

	} else %orig(_icon);

}

#pragma clang diagnostic pop

%end

%end

%group iOS8

%hook SBIconController

- (void)_launchIcon:(SBApplicationIcon *)_icon {

	if(enabled && calendar && [_icon.application.bundleIdentifier isEqualToString:@"com.apple.mobilecal"]) {

		SBIconController *controller = [%c(SBIconController) sharedInstance];
		SBIconModel *model = controller.model; // Better than weird casts.
		SBApplicationIcon *icon = [model applicationIconForBundleIdentifier:@"com.flexibits.fantastical2.iphone"];
		%orig(icon ?: _icon);

	} else if(enabled && weather && [_icon.application.bundleIdentifier isEqualToString:@"com.apple.weather"]) {

		SBIconController *controller = [%c(SBIconController) sharedInstance];
		SBApplicationIcon *icon = [controller.model applicationIconForBundleIdentifier:@"com.offcoast.weatherline"];
		%orig(icon ?: _icon);

	} else %orig(_icon);

}

%end

%end

%ctor {

	HBLogDebug(@"Redirector: injecting!");

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.aehmlo.redirector"];

	[preferences registerBool:&enabled default:YES forKey:@"Enabled"];
	[preferences registerBool:&calendar default:YES forKey:@"CalendarEnabled"];
	[preferences registerBool:&weather default:YES forKey:@"WeatherEnabled"];

	if([%c(SBiconModel) instancesRespondToSelector:@selector(applicationIconForBundleIdentifier:)]) {
		HBLogDebug(@"Redirector: Loading iOS 8 version.");
		%init(iOS8);
	} else if([%c(SBIconModel) instancesRespondToSelector:@selector(applicationIconForDisplayIdentifier:)]) {
		HBLogDebug(@"Redirector: Loading iOS 5/6/7 version.");
		%init(iOS5);
	}

}