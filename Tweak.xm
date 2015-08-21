#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationIcon.h>

#import <Cephei/HBPreferences.h>

@interface SBIconModel : NSObject

- (SBApplicationIcon *)applicationIconForBundleIdentifier:(NSString *)bundleID;

@end

@interface SBIconController : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, retain) SBIconModel *model;

@end

BOOL enabled, calendar;

%hook SBIconController

- (void)_launchIcon:(SBApplicationIcon *)_icon {

	if(enabled && calendar && [_icon.application.bundleIdentifier isEqualToString:@"com.apple.mobilecal"]) {

		SBIconController *controller = [%c(SBIconController) sharedInstance];
		SBIconModel *model = controller.model; // Better than weird casts.
		SBApplicationIcon *icon = [model applicationIconForBundleIdentifier:@"com.flexibits.fantastical2.iphone"];
		%orig(icon ?: _icon);

	} else %orig(_icon);

}

%end

%ctor {

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.aehmlo.redirector"];

	[preferences registerBool:&enabled default:YES forKey:@"Enabled"];
	[preferences registerBool:&calendar default:YES forKey:@"CalendarEnabled"];

}