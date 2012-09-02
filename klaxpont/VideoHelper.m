//
//  VideoHelper.m
//  klaxpont
//
//  Created by François Benaiteau on 8/26/12.
//
//

#import "VideoHelper.h"
#import "Video.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VideoHelper



+(void)openVideo:(Video*)video from:(UIViewController*)viewController
{
    if(video.url){
        // open Video
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL: video.url];
        [player setTitle:video.title];
        [player.moviePlayer prepareToPlay];
        
        
        [viewController presentMoviePlayerViewControllerAnimated:player];
    }else{
        NSLog(@"no file found");
    }
}

@end
