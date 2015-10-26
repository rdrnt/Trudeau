#import "MediaPlayer/MPMusicPlayerController.h"
#include <MediaPlayer/MediaPlayer.h>
#import "MediaRemote/MediaRemote.h"
#import <Foundation/Foundation.h>
#import <SpringBoard/SpringBoard.h>
#import "MediaRemote.h"
#import <UIKit/UIKit.h>

static UIImage *artwork;

@interface MusicMiniPlayerViewController : UIViewController  {

}
- (void)viewDidLoad;
-(void)nextTrack;
-(void)previousTrack;
@end

@interface MPUSystemMediaControlsViewController : UIViewController {
}
@property (nonatomic, readonly) UIView *artworkView;
@end


%hook MusicMiniPlayerViewController
- (void)viewDidLoad {
    %orig;
    HBLogInfo(@"HI mom!!!");
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;


    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTrack)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:swipeLeft];

    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTrack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:swipeRight];

    /*
    SBMediaController *mc = [%c(MPMusicPlayerController) sharedInstance];
    HBLogInfo(@"The current info is %@", [mc _nowPlayingInfo]);
    */
    MPUSystemMediaControlsViewController *mediaControlsViewController=[[MPUSystemMediaControlsViewController alloc] initWithStyle:1];
    UIImageView *artwork=[mediaControlsViewController artworkView];




}

%new
-(void)nextTrack {
    MPMusicPlayerController *playerC = [[[%c(MPMusicPlayerController) alloc] init] autorelease];
    [playerC skipToNextItem];
    HBLogInfo(@"Skipping...");

     MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    NSDictionary *dict=(__bridge NSDictionary *)(information);

//then the piece above 
NSData *artworkData = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
artwork = [UIImage imageWithData:artworkData];
[self view].backgroundColor = [UIColor colorWithPatternImage:artwork];
});

}

%new 
-(void)previousTrack {
    MPMusicPlayerController *playerC = [[[%c(MPMusicPlayerController) alloc] init] autorelease];
    [playerC skipToPreviousItem];
    HBLogInfo(@"Go back...");

    [self viewDidLoad];
}
%end