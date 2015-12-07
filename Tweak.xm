#import "trudeau.h"

/*Huge thanks to:
Eric, Borsato92, cj81499, winlogon0, mootjeuh, @redzrex, Jason R., CONATH, JimDotR, Boris S, Ziph0n, Andrew, /u/DervishSkater, Corporal, Acidschnee, Josh Gibson, HHumbert, Cody, Connor, @sel2by3, Shadow Games, Pixxaddict, platypusw90, echo000, Jonathan Gautreau, Blink, ShaneSparkyYYZ, kamikasky, MaxD, @tilgut, @Beezure, Matteo Piccina, josh_boothman, Moshe Siegel, Ian L, Torben, MeatyCheetos, @rauseo12, Lei33, K S LEE, @RichResk, wizage, @sekrit_, RushNY, Maortega89, @frkbmb_, Kyle, Robert, @BrianOverly, @thetomcanuck, OhSpazz, Jessyreynosa3, Jessie mejia, Jp_delon, dantesieg
*/

static BOOL enabled;
static BOOL blurEnabled;
static BOOL invertGestures;

static NSString *const TRDPrefsPath = @"/var/mobile/Library/Preferences/com.tweakbattles.trudeau.plist";
static void loadPreferences() {
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:TRDPrefsPath];

    enabled         = [dict objectForKey:@"enabled"] ? [[dict objectForKey:@"enabled"] boolValue] : TRUE;
    blurEnabled     = [dict objectForKey:@"blurEnabled"] ? [[dict objectForKey:@"blurEnabled"] boolValue] : TRUE;
    invertGestures  = [[dict objectForKey:@"invertGestures"] boolValue];

    [dict release];
}

static MPMusicPlayerController *playerC = [[[%c(MPMusicPlayerController) alloc] init] autorelease];

//Album artwork blur across the Music UI
%hook MusicMiniPlayerBackgroundView
-(void)layoutSubviews {
    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict=(__bridge NSDictionary *)(information);
        NSData *artworkData = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
        UIImage *artwork = [UIImage imageWithData:artworkData];
        UIImageView *artworkView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,artwork.size.height)];
        artworkView.image = artwork;
        [self addSubview:artworkView];

        _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2060];
        [artworkView addSubview:blurView];

        [blurView release];
        [artworkView release];
    });
}
%end

//Hooking the mini player bar in music.app
%hook MusicMiniPlayerViewController
-(void)viewDidLoad {
    %orig;

    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    if (enabled) {
        swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTrack)];
        if (invertGestures) {
            swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
        }
        else {
            swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        }
        swipeLeft.numberOfTouchesRequired = 1;
        [[self view] addGestureRecognizer:swipeLeft];

        swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTrack)];
        if (invertGestures) {
            swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
        }
        else {
            swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        }
        swipeRight.numberOfTouchesRequired = 1;
        [[self view] addGestureRecognizer:swipeRight];
    }
}

%new
-(void)nextTrack {
    [playerC skipToNextItem];
    HBLogInfo(@"Skipping...");
}

%new 
-(void)previousTrack {
    [playerC skipToPreviousItem];
    HBLogInfo(@"Go back...");
}
%end

//Add lyrics button
%hook MusicNowPlayingItemViewController
-(void)viewDidLoad {
    %orig;

    UIImage* image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/trudeau.bundle/lyrics.png"];
    CGRect frame = CGRectMake((self.view.frame.size.width - image.size.width)/2, (self.view.frame.size.height - image.size.height)/2 + 25, image.size.width + 2, image.size.height + 2);
    UIButton *lyricsButton = [[UIButton alloc] initWithFrame:frame];
    [lyricsButton setBackgroundImage:image forState:UIControlStateNormal];
    [lyricsButton addTarget:self action:@selector(openLyrics) forControlEvents:UIControlEventTouchUpInside];
    lyricsButton.backgroundColor = [UIColor clearColor];
    lyricsButton.layer.cornerRadius = 5;
    lyricsButton.layer.masksToBounds = YES;
    [[self view] addSubview:lyricsButton];
}

%new
-(void)openLyrics {
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
        searchURL = [NSString stringWithFormat:@"https://www.google.com/#q=%@+-+%@+lyrics", songLabel, artistLabel]; //hail america
        HBLogInfo(@"%@", searchURL);

        //Searching for the songs current lyrics via Safari
        SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:searchURL] entersReaderIfAvailable:NO];
        [self presentViewController:sfVC animated:YES completion:nil];
    });
}
%end

%ctor {
    loadPreferences();
}