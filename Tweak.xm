#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBIconModel.h>

#import <Cephei/HBPreferences.h>

BOOL enabled, calendar, weather;
NSDictionary *redirects;

%hook SBIconController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)_launchIcon:(SBApplicationIcon *)_icon {

	if(enabled) {

		NSString *identifier;
		
		if([_icon.application respondsToSelector:@selector(displayIdentifier)]) {
			identifier = _icon.application.displayIdentifier;
		} else if([_icon.application respondsToSelector:@selector(bundleIdentifier)]) {
			identifier = _icon.application.bundleIdentifier;
		} else {
			%orig(_icon);
			return;
		}

		if(redirects[identifier]) {

			SBIconController *controller = [%c(SBIconController) sharedInstance];
			SBIconModel *model = controller.model; // Better than weird casts.
			SBApplicationIcon *icon;
			if([model respondsToSelector:@selector(applicationIconForDisplayIdentifier:)]) {
				icon = [model applicationIconForDisplayIdentifier:redirects[identifier]];
			} else if([model respondsToSelector:@selector(applicationIconForBundleIdentifier:)]) {
				icon = [model applicationIconForBundleIdentifier:redirects[identifier]];
			}
			%orig(icon ?: _icon);
			return;
		}

	}

	%orig(_icon);

}

#pragma clang diagnostic pop

%end

%ctor {

	HBLogDebug(@"Redirector: injecting!");

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.aehmlo.redirector"];

	[preferences registerBool:&enabled default:YES forKey:@"Enabled"];
	[preferences registerBool:&calendar default:YES forKey:@"CalendarEnabled"];
	[preferences registerBool:&weather default:YES forKey:@"WeatherEnabled"];

	[preferences registerObject:&redirects default:@{
		@"com.apple.weather" : @"com.offcoast.weatherline",
		@"com.apple.mobilecal" : @"com.flexibits.fantastical2.iphone"
	} forKey:@"Redirects"];

}