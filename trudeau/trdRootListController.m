#include "trdRootListController.h"
#import <Social/SLComposeViewController.h>
#import <Social/SLServiceTypes.h>

@implementation trdRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

void killMusic(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    system("killall -9 Music");
    #pragma clang diagnostic pop
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor systemPinkColor];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor systemPinkColor];

    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &killMusic, CFSTR("com.tweakbattles.trudeau/settingschanged"), NULL, 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, CFSTR("com.tweakbattles.trudeau/settingschanged"), NULL);
    self.navigationController.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];
}
- (void)loadView {
    [super loadView];
    UIImage* image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/trudeau.bundle/heart@2x.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
        
    [button addTarget:self action:@selector(tweet) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:NO];
    UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //fix spacing
    UIBarButtonItem *spaceCorrection = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceCorrection.width = -16;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:spaceCorrection, heartButton, nil] animated:NO];
}

-(void)tweet
{
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeController setInitialText:@"Enhance your Music Experience with Trudeau by @_rdrnt and @xTM3x"];
    
    [self presentViewController:composeController animated:YES completion:nil];
}
@end



@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface TRDCustomHeaderView : UITableViewCell <PreferencesTableCustomView> {
    UILabel *label;
    UILabel *subLabel;
}
@end

@implementation TRDCustomHeaderView
- (id)initWithSpecifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (self) {
        int width = [[UIScreen mainScreen] bounds].size.width;
        CGRect labelFrame = CGRectMake(0, -15, width, 60);
        CGRect underLabelFrame = CGRectMake(0, 20, width, 60);
        
        label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setNumberOfLines:1];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:48];
        [label setText:@"Trudeau"];
        [label setBackgroundColor:[UIColor clearColor]];
        label.textColor = [UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        subLabel = [[UILabel alloc] initWithFrame:underLabelFrame];
        [subLabel setNumberOfLines:1];
        subLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [subLabel setText:@"Enhance your Music experience."];
        [subLabel setBackgroundColor:[UIColor clearColor]];
        subLabel.textColor = [UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1.0f];
        subLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [self addSubview:subLabel];
        
    }
    return self;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    CGFloat prefHeight = 75.0;
    return prefHeight;
}
@end