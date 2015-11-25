#import "MediaPlayer/MPMusicPlayerController.h"
#include <MediaPlayer/MediaPlayer.h>
#import "MediaRemote/MediaRemote.h"
#import <Foundation/Foundation.h>
#import <SpringBoard/SpringBoard.h>
#import "MediaRemote.h"
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

#import "trudeau.h"

@interface UIColor (Priv)
+(UIColor*)systemPinkColor;
@end

@interface MusicMiniPlayerViewController : UIViewController  {
}
-(void)viewDidLoad;
-(void)nextTrack;
-(void)previousTrack;
@end

%hook MusicMiniPlayerViewController
- (void)viewDidLoad {
    %orig;

    HBLogInfo(@"TRUDEAU: Loaded!");


    //Add Swipes
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTrack)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:swipeLeft];

    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTrack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:swipeRight];

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

}

%new 
-(void)previousTrack {
    MPMusicPlayerController *playerC = [[[%c(MPMusicPlayerController) alloc] init] autorelease];
    [playerC skipToPreviousItem];
    HBLogInfo(@"Go back...");

}
%end

@interface MusicNowPlayingItemViewController : UIViewController
- (void)viewDidLoad;
@end

%hook MusicNowPlayingItemViewController
-(void)viewDidLoad {
    %orig;
    HBLogInfo(@"MusicNowPlayingItemViewController loaded");

    CGRect viewRect = [[self view] bounds];
    CGFloat viewWidth = viewRect.size.width;
    CGFloat viewHeight = viewRect.size.height;

    UIButton *lyricsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lyricsButton addTarget:self action:@selector(openLyrics) forControlEvents:UIControlEventTouchUpInside];
    [lyricsButton setTitle:@"Lyrics" forState:UIControlStateNormal];
    CGSize sizeForButtonString = [@"Lyrics" sizeWithFont:lyricsButton.titleLabel.font]; 
    [lyricsButton setFrame:CGRectMake(viewWidth/2,viewHeight/2, sizeForButtonString.width, sizeForButtonString.height)];
    [lyricsButton setTitleColor:[UIColor systemPinkColor] forState:UIControlStateNormal]; //systemPinkColor is the music tint color 
    [[self view] addSubview:lyricsButton];
}

%new
-(void)openLyrics {
    HBLogInfo(@"Grabbing the title");

    //grabing Song and artist
     MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict=(__bridge NSDictionary *)(information);
        NSString *tempSongLabel = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] ];
        NSString *tempArtistLabel = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] ];
        HBLogInfo(@"The song is %@ by %@", tempSongLabel, tempArtistLabel);

        //Replacing " " in songs and artist, so we can google search properly
        NSString *songLabel = [tempSongLabel stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        HBLogInfo(@"The new song for searching lyrics is %@", songLabel);
        NSString *artistLabel = [tempArtistLabel stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        HBLogInfo(@"The new song for searching lyrics is %@", artistLabel);

        //final URL we will search with
        NSString *searchURL = [[NSString alloc] init];
        searchURL = [NSString stringWithFormat:@"https://www.google.ca/#q=%@+-+%@+lyrics", songLabel, artistLabel];
        HBLogInfo(@"%@", searchURL);


        //Searching for the songs current lyrics
        SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:searchURL] entersReaderIfAvailable:NO];
        [self presentViewController:sfVC animated:YES completion:nil];

    });
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