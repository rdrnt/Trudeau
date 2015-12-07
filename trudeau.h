#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import "MediaRemote.h"

@interface UIColor (Priv)
+(UIColor *)systemPinkColor;
@end

@interface _UIBackdropView : UIView
-(id)initWithStyle:(int)style;
@end

@interface MusicNowPlayingItemViewController : UIViewController 

@end

@interface MusicMiniPlayerViewController : UIViewController

@end

@interface MusicMiniPlayerBackgroundView : UIView

@end