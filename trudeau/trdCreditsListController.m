#include "trdCreditsListController.h"

@implementation trdCreditsListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Credits" target:self] retain];
	}

    [_specifiers retain];
	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor systemPinkColor];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor systemPinkColor];
    self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];
}
@end

@interface TRDDevCell : PSTableCell {
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UILabel *twitterHandleLabel;
    UILabel *jobLabel;
}
-(id)initWithName:(NSString *)name twitterHandle:(NSString *)handle job:(NSString *)job profileImage:(UIImage *)image;
@end

@implementation TRDDevCell

-(id)initWithName:(NSString *)name twitterHandle:(NSString *)handle job:(NSString *)job profileImage:(UIImage *)image {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TRDDevCell"];
    if (self) {
        profileImageView = [[UIImageView alloc] initWithImage:image];
        profileImageView.frame = CGRectMake(10,15,70,70);
        profileImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        profileImageView.layer.shadowOffset = CGSizeMake(0, 1);
        profileImageView.layer.shadowOpacity = 0.2;
        profileImageView.layer.shadowRadius = 1.0;
        profileImageView.clipsToBounds = NO;
        [self addSubview:profileImageView];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setText:name];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor darkGrayColor]];
        [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 30 : 20]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:nameLabel];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:profileImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20]];

        twitterHandleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [twitterHandleLabel setText:handle];
        [twitterHandleLabel setTextColor:[UIColor grayColor]];
        [twitterHandleLabel setBackgroundColor:[UIColor clearColor]];
        [twitterHandleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];
        [twitterHandleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:twitterHandleLabel];
        [twitterHandleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:twitterHandleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:profileImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:twitterHandleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

        jobLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [jobLabel setText:job];
        [jobLabel setTextColor:[UIColor grayColor]];
        [jobLabel setBackgroundColor:[UIColor clearColor]];
        [jobLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:12]];
        [jobLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:jobLabel];
        [jobLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:jobLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:profileImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:jobLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:twitterHandleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    }

    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)spec {
    UIImage *profileImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/trudeau.bundle/%@.png", [spec propertyForKey:@"imageName"]]];
    self = [self initWithName:[spec propertyForKey:@"name"] twitterHandle:[spec propertyForKey:@"handle"] job:[spec propertyForKey:@"job"] profileImage:profileImage];
    return self;
}
@end