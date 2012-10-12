//
//  VideoPlayerController.m
//  klaxpont
//
//  Created by François Benaiteau on 9/1/12.
//
//

#import "VideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerController ()

@end

@implementation VideoPlayerController
@synthesize videoId = _videoId;

- (id)initWithDailymotionVideo:(NSString*)videoId
{
    self = [super init];
    if (self) {
        // Custom initialization
        _videoId = videoId;
    }
    return self;
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    _playerController = [[DailymotionPlayerViewController alloc] initWithVideo:_videoId];
    _playerController.delegate = self;
    
    [_playerController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    //    [_playerController setFullscreen:NO];
    [self.view addSubview:_playerController.view];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_playerController pause];
    _playerController.delegate = nil;
    _playerController = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Actions

- (void) setVideoId:(NSString *)videoId {
    _videoId = videoId;
    [_playerController load:_videoId];
}

- (void) play
{
    if (_playerController && _videoId) {
        [_playerController play];
    }

}

#pragma mark - Dailymotion delegate methods


- (void)dailymotionPlayer:(DailymotionPlayerViewController *)player didReceiveEvent:(NSString *)eventName
{
    NSLog(@"dailymotion event %@", eventName);

    if ([eventName isEqualToString:@"apiready"])
    {
        [player play];
    }

    if ([eventName isEqualToString:@"ended"])
    {
        // TODO: Add rating
    }
}

@end
