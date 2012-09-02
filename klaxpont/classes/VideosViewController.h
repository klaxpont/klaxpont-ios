//
//  VideosViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dailymotion.h"

@interface VideosViewController : UITableViewController<DailymotionDelegate, UITableViewDataSource>
{
    NSArray *_videos;
}
@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@end
