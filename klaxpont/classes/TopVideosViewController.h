//
//  TopVideosViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <UIKit/UIKit.h>


@interface TopVideosViewController : UITableViewController
{
    NSArray *_videos;
    NSIndexPath *selectedPath;
}
@property(nonatomic,retain) NSArray *videos;
@end
