//
//  TopVideosViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Dailymotion.h"

@interface TopVideosViewController : UITableViewController<DailymotionPlayerDelegate>
{
    NSArray *_videos;
}
@end
