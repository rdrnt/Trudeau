#line 1 "Tweak.xm"
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


#include <logos/logos.h>
#include <substrate.h>
@class MPMusicPlayerController; @class MusicMiniPlayerViewController; 
static void (*_logos_orig$_ungrouped$MusicMiniPlayerViewController$viewDidLoad)(MusicMiniPlayerViewController*, SEL); static void _logos_method$_ungrouped$MusicMiniPlayerViewController$viewDidLoad(MusicMiniPlayerViewController*, SEL); static void _logos_method$_ungrouped$MusicMiniPlayerViewController$nextTrack(MusicMiniPlayerViewController*, SEL); static void _logos_method$_ungrouped$MusicMiniPlayerViewController$previousTrack(MusicMiniPlayerViewController*, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MPMusicPlayerController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MPMusicPlayerController"); } return _klass; }
#line 25 "Tweak.xm"

static void _logos_method$_ungrouped$MusicMiniPlayerViewController$viewDidLoad(MusicMiniPlayerViewController* self, SEL _cmd) {
    _logos_orig$_ungrouped$MusicMiniPlayerViewController$viewDidLoad(self, _cmd);
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

    



    MPUSystemMediaControlsViewController *mediaControlsViewController=[[MPUSystemMediaControlsViewController alloc] initWithStyle:1];
    UIImageView *artwork=[mediaControlsViewController artworkView];




}


static void _logos_method$_ungrouped$MusicMiniPlayerViewController$nextTrack(MusicMiniPlayerViewController* self, SEL _cmd) {
    MPMusicPlayerController *playerC = [[[_logos_static_class_lookup$MPMusicPlayerController() alloc] init] autorelease];
    [playerC skipToNextItem];
    HBLogInfo(@"Skipping...");

     MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    NSDictionary *dict=(__bridge NSDictionary *)(information);


NSData *artworkData = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
artwork = [UIImage imageWithData:artworkData];
[self view].backgroundColor = [UIColor colorWithPatternImage:artwork];
});

}

 
static void _logos_method$_ungrouped$MusicMiniPlayerViewController$previousTrack(MusicMiniPlayerViewController* self, SEL _cmd) {
    MPMusicPlayerController *playerC = [[[_logos_static_class_lookup$MPMusicPlayerController() alloc] init] autorelease];
    [playerC skipToPreviousItem];
    HBLogInfo(@"Go back...");

    [self viewDidLoad];
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$MusicMiniPlayerViewController = objc_getClass("MusicMiniPlayerViewController"); if (_logos_class$_ungrouped$MusicMiniPlayerViewController) {if (class_getInstanceMethod(_logos_class$_ungrouped$MusicMiniPlayerViewController, @selector(viewDidLoad))) {MSHookMessageEx(_logos_class$_ungrouped$MusicMiniPlayerViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$MusicMiniPlayerViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$MusicMiniPlayerViewController$viewDidLoad);} else {HBLogError(@"logos: message not found [%s %s]", "MusicMiniPlayerViewController", "viewDidLoad");}} else {HBLogError(@"logos: nil class %s", "MusicMiniPlayerViewController");}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MusicMiniPlayerViewController, @selector(nextTrack), (IMP)&_logos_method$_ungrouped$MusicMiniPlayerViewController$nextTrack, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MusicMiniPlayerViewController, @selector(previousTrack), (IMP)&_logos_method$_ungrouped$MusicMiniPlayerViewController$previousTrack, _typeEncoding); }} }
#line 81 "Tweak.xm"
