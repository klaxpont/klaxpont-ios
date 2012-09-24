//
//  TopVideosViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import "TopVideosViewController.h"
#import "NetworkManager.h"
#import "Video.h"
#import "VideoCell.h"
#import "VideoPlayerController.h"

@interface TopVideosViewController ()
{
    VideoPlayerController *controller;
}
-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TopVideosViewController
@synthesize videos = _videos;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Les Vidébas";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // custom table cell
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
    UITableViewCell *cell = [nib objectAtIndex:0];
    self.tableView.rowHeight = cell.frame.size.height;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _videos = [[NetworkManager sharedManager] retrieveVideos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        
        });
    });

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _videos = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Other methods

-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", [indexPath row]);
    
    NSDictionary *video = [_videos objectAtIndex:[indexPath row]];
    if(video){
        //NSLog(@"%@",video);
        [[(VideoCell*)cell titleLabel] setText:[video objectForKey:@"title"]];
        [[(VideoCell*)cell  thumbnailView] setImage:[UIImage imageNamed:@"default_thumbnail.jpg"]];
        NSString *thumbnailUrl = [video objectForKey:@"thumbnail_url"];
        NSLog(@"thumbnail url %@", thumbnailUrl);
        __block UIImage *image = nil;
  
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
            image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                //ici, on est dans le main thread.
                [[(VideoCell*)cell  thumbnailView] setImage:image];
            });
        });
        
//        [[(VideoCell*)cell thumbnailView] setImage:];
    
       
        [(VideoCell*)cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoCellIdentifier";
    VideoCell *cell = (VideoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // have to do this because of not using storyboard or xib, or is it something else?
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
    UITableViewCell *cell = [nib objectAtIndex:0];
    if(selectedPath && indexPath.row == selectedPath.row){
        return cell.frame.size.height + 200 + 10;
    }

    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedPath && indexPath.row == selectedPath.row)
        selectedPath = nil;
    if(controller)
        [controller.view removeFromSuperview];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedPath && indexPath.row == selectedPath.row)
        return;

    NSDictionary *video = [_videos objectAtIndex:indexPath.row];
    NSString *videoId = [video objectForKey:@"dailymotion_video_id"];
    if (controller == nil) {
        controller = [[VideoPlayerController alloc] initWithDailymotionVideo:videoId];
    }else{
        [controller setVideoId:videoId];
    }
    
    selectedPath = indexPath;

    [tableView beginUpdates];    
    VideoCell* cell = (VideoCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (selectedPath && indexPath.row == selectedPath.row && controller) {
           [controller.view setFrame:CGRectMake(10, 72, 300, 200)];
            // TODO: replace hard values
            [cell.contentView addSubview:controller.view];
        }
    }

    [tableView endUpdates];

    if (controller) {
        [controller play];
    }
}

@end
