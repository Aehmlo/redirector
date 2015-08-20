#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationIcon.h>

@interface SBIconModel : NSObject

- (SBApplicationIcon *)applicationIconForBundleIdentifier:(NSString *)bundleID;

@end

@interface SBIconController : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, retain) SBIconModel *model;

@end

%hook SBIconController

- (void)_launchIcon:(SBApplicationIcon *)_icon {

	if([_icon.application.bundleIdentifier isEqualToString:@"com.apple.mobilecal"]) {

		SBIconController *controller = [%c(SBIconController) sharedInstance];
		SBIconModel *model = controller.model; // Better than weird casts.
		SBApplicationIcon *icon = [model applicationIconForBundleIdentifier:@"com.flexibits.fantastical2.iphone"];
		%orig(icon ?: _icon);

	} else %orig(_icon);

}

%end