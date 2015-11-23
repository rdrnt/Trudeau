#import "MediaPlayer/MPMusicPlayerController.h"
#include <MediaPlayer/MediaPlayer.h>
#import "MediaRemote/MediaRemote.h"
#import <Foundation/Foundation.h>
#import <SpringBoard/SpringBoard.h>
#import "MediaRemote.h"
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

#import "trudeau.h"

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

    HBLogInfo(@"TRUDEAU: Loaded!");
    /* Frame info 
    float frameHeight = [self view].frame.size.height;
    float frameWidth = [self view].frame.size.width;
    */

    //Add Swipes
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTrack)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:swipeLeft];

    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTrack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:swipeRight];

    lyricsButton = [[UIButton alloc] initWithFrame:CGRectMake(0,13, 9, 20)];
    lyricsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lyricsButton setTitle:@"testing" forState:UIControlStateNormal];
    lyricsButton.titleLabel.textColor = [UIColor blueColor];
    [lyricsButton addTarget:self action:@selector(openLyrics) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:lyricsButton];

    //Blur Effect 
    /*
    if (lightblur == YES) {
    effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.alpha = 0.4;
    effectView.opaque = YES;
    effectView.frame = CGRectMake(0,0,frameWidth,frameHeight);
    [[self view] addSubview:effectView];
    }
    else if {
        effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.alpha = 0.4;
        effectView.opaque = YES;
        effectView.frame = CGRectMake(0,0,frameWidth,frameHeight);
        [[self view] addSubview:effectView];
    }
    */



}

%new
-(void)nextTrack {
    MPMusicPlayerController *playerC = [[[%c(MPMusicPlayerController) alloc] init] autorelease];
    [playerC skipToNextItem];
    HBLogInfo(@"Skipping...");
    /*
     MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    NSDictionary *dict=(__bridge NSDictionary *)(information);
    NSData *artworkData = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
    artwork = [UIImage imageWithData:artworkData];
    [self view].backgroundColor = [UIColor colorWithPatternImage:artwork];
    });
    */

}

%new 
-(void)previousTrack {
    MPMusicPlayerController *playerC = [[[%c(MPMusicPlayerController) alloc] init] autorelease];
    [playerC skipToPreviousItem];
    HBLogInfo(@"Go back...");

}

%new
-(void)openLyrics {
    HBLogInfo(@"Attempting to launch SafariVC...");
    SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://google.ca"] entersReaderIfAvailable:NO];
    [self presentViewController:sfVC animated:YES completion:nil];
}

%end

static void loadPreferences() {
    lightblur= !CFPreferencesCopyAppValue(CFSTR("lightblur"), CFSTR("com.rdrnt.trudeau")) ? YES : [(id)CFPreferencesCopyAppValue(CFSTR("lightblur"), CFSTR("com.rdrnt.trudeau")) boolValue];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPreferences,
                                CFSTR("com.rdrnt.trudeau/settingschanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
}