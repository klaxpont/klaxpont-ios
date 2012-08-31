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
#import "VideoHelper.h"
#import "AppDelegate.h"

@interface TopVideosViewController ()
{
    DailymotionPlayerViewController *_playerController;
}
-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TopVideosViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Les Vidébas";
        _videos = [[NetworkManager sharedManager] retrieveVideos];
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
    NSLog(@"%@",video);
    [[(VideoCell*)cell titleLabel] setText:[video objectForKey:@"title"]];
//    [[(VideoCell*)cell thumbnailView] setImage:[video thumbnail]];
    [(VideoCell*)cell setAccessoryType:UITableViewCellAccessoryNone];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *video = [_videos objectAtIndex:indexPath.row];
//    NSString *videoUrl = [video objectForKey:@"video_url"];
    NSString *videoId = [video objectForKey:@"dailymotion_video_id"];
    if(_playerController == nil) {
        Dailymotion *dailymotion = [[Dailymotion alloc] init];
        //todo handle missing session
        [dailymotion setSession:[APP_DELEGATE dailymotionSession]];

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES],@"fullscreen",
                                [NSNumber numberWithBool:YES],@"autoplay",
                                nil];
        _playerController = [dailymotion player:videoId params:params];
        _playerController.delegate = self;
    }
    [_playerController load:videoId];
    [self presentModalViewController:_playerController animated:YES];
//    [VideoHelper openDailymotionVideo:videoUrl from:self];
}

- (void)dailymotionPlayer:(DailymotionPlayerViewController *)player didReceiveEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"ended"])
    {
        [player dismissModalViewControllerAnimated:YES];
//        progressBar.value = player.currentTime / player.duration;
    }
}

@end
