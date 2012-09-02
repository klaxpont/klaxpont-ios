//
//  VideoPlayerController.h
//  klaxpont
//
//  Created by François Benaiteau on 9/1/12.
//
//

#import <UIKit/UIKit.h>
#import "Dailymotion.h"

@interface VideoPlayerController : UIViewController<DailymotionPlayerDelegate>
{
    DailymotionPlayerViewController *_playerController;
}

@property(nonatomic,retain) NSString* videoId;

- (id)initWithDailymotionVideo:(NSString*)videoId;
- (void) play;
@end
