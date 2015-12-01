#include "trdRootListController.h"
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation trdRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
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
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        subLabel = [[UILabel alloc] initWithFrame:underLabelFrame];
        [subLabel setNumberOfLines:1];
        subLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [subLabel setText:@"Enhance your Music experience."];
        [subLabel setBackgroundColor:[UIColor clearColor]];
        subLabel.textColor = [UIColor grayColor];
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