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

#define VIDEO_CELL_IDENTIFIER @"VideoCellIdentifier"

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
    self = [super initWithStyle:UITableViewStyleGrouped];
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
    UINib *videoCellNib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    [self.tableView registerNib:videoCellNib forCellReuseIdentifier:VIDEO_CELL_IDENTIFIER];
//    self.tableView.rowHeight = (UITableViewCell*)videoCellNib..frame.size.height;
	self.tableView.layer.cornerRadius = 5.0;

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height) arrowImageName:@"blackArrow.png" textColor:[UIColor blackColor]];
        [view setBackgroundColor:[UIColor whiteColor]];
        // TODO: handle translation
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    [self egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
    _videoThumbnails = [[NSMutableDictionary alloc] init];
    [self reloadTableViewDataSource];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRowFromNotification:) name:DOWNLOAD_IMAGE_NOTIFICATION object:nil];

    
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
    NSDictionary *video = [_videos objectAtIndex:[indexPath row]];
    if(video){
        [[(VideoCell*)cell titleLabel] setText:[video objectForKey:@"title"]];
        [[(VideoCell*)cell thumbnailView] setImage:[video objectForKey:@"thumbnail"]];
    }
}
-(void) refreshRowFromNotification:(NSNotification*) notification
{
    //refresh  the cell for incomming image
    NSDictionary *dict = [notification userInfo];
    NSNumber *row = [dict objectForKey:@"index"];
 
    NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:row.integerValue inSection:0];
    NSArray *rows = [NSArray arrayWithObject:rowIndex];
    [self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];
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
    static NSString *cellIdentifier = VIDEO_CELL_IDENTIFIER;
    VideoCell *cell = (VideoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell.
    UIFont *font = [[[UILabel appearance] font] fontWithSize:16.0];
    [[cell titleLabel] setFont:font];

    cell.thumbnailView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    cell.thumbnailView.layer.borderWidth = 1.0f; //make border 1px thick

    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
    UITableViewCell *cell = [nib objectAtIndex:0];
    NSUInteger height = cell.frame.size.height;
    return height;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedPath && indexPath.row == selectedPath.row)
        selectedPath = nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPath = indexPath;
    
    NSDictionary *video = [_videos objectAtIndex:indexPath.row];
    NSString *videoId = [video objectForKey:@"dailymotion_video_id"];

    VideoCell* cell = (VideoCell*)[tableView cellForRowAtIndexPath:indexPath];



    if (controller == nil) {
        controller = [[VideoPlayerController alloc] initWithDailymotionVideo:videoId];
        [self.view addSubview:controller.view];      
        [controller.view setHidden:YES];
    }else{
        if(![controller.videoId isEqualToString:videoId])
            [controller setVideoId:videoId];
    }
    // TODO see when to stop it, delegate of videoplayer...
    [[cell spinner] startAnimating];

    [controller play];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    // download videos
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _reloading = YES;
        _videos = [[NetworkManager sharedManager] retrieveVideos];


        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];           
            [self doneLoadingTableViewData];
        });
    });
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed	
}

#pragma mark - Manually refresh view update

- (void)egoRefreshScrollViewDataSourceStartManualLoading:(UIScrollView *)scrollView {
    // faint the scrollView in order to trigger the loading
    [scrollView setContentOffset:CGPointMake(0, -70)];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
