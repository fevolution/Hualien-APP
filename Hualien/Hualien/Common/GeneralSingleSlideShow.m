//
//  GeneralSingleSlideShow.m
//  Hualien
//
//  Created by Chunta chen on 6/24/15.
//  Copyright (c) 2015 Chen ChunTa. All rights reserved.
//

#import "GeneralSingleSlideShow.h"
#import <MediaPlayer/MediaPlayer.h>
@interface GeneralSingleSlideShow ()
{
    __weak id<IGeneralSingleSlideShow> delegate;
    MPMoviePlayerController* iPlayer;
}
@property(weak)IBOutlet UIButton* uiClose;
@end

@implementation GeneralSingleSlideShow

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setImageContent:(NSString*)file
{
    UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:file]];
    [self.view addSubview:view];
    view.frame = self.view.frame;
    [self.view bringSubviewToFront:self.uiClose];
}

- (void)setVideoContent:(NSString*)file
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"mov" inDirectory:nil];
    iPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    iPlayer.movieSourceType = MPMovieSourceTypeFile;
    iPlayer.view.frame = self.view.frame;
    [iPlayer setScalingMode:MPMovieScalingModeAspectFill];
    iPlayer.controlStyle = MPMovieControlStyleEmbedded;
    [self.view addSubview:iPlayer.view];
    [iPlayer prepareToPlay];
    iPlayer.shouldAutoplay = NO;
    [self.view bringSubviewToFront:self.uiClose];
}

#pragma mark - VideoPlayer Delegate
-(void)moviePlayerLoadStateChanged:(NSNotification*)notif
{
    if( MPMoviePlaybackStateStopped == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateStopped");
    }
    if (MPMoviePlaybackStatePlaying == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStatePlaying");
    }
    if (MPMoviePlaybackStatePaused == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStatePaused");
    }
    if (MPMoviePlaybackStateInterrupted == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateInterrupted");
    }
    if (MPMoviePlaybackStateSeekingForward == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateSeekingForward");
    }
    if (MPMoviePlaybackStateSeekingBackward == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateSeekingBackward");
    }
    if((iPlayer.loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
    {
        //if load state is ready to play
        //iReadyToPlay = YES;
        [iPlayer play];
    }
}

-(void)setDelegate:(id<IGeneralSingleSlideShow>)del
{
    delegate = del;
}

-(IBAction)onClose:(id)sender
{
    [delegate onSingleSlideShowClose];
    [iPlayer stop];
    [iPlayer.view removeFromSuperview];
}
@end
