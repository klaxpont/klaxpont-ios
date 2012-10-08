//
//  TopVideosViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface TopVideosViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    NSArray *_videos;
    NSMutableDictionary *_videoThumbnails;
    NSIndexPath *selectedPath;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}
@property(nonatomic,retain) NSArray *videos;
@end
