//
//  VideosViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideosViewController.h"

@interface VideosViewController(Private)
- (void) retrieveVideos;
- (void) buildVideoItem:(NSDictionary*)videoInfos index:(int)position;
@end

@implementation VideosViewController
@synthesize containerView = _containerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self retrieveVideos];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - helpers

- (void) retrieveVideos{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSDictionary *settings=[NSDictionary dictionaryWithContentsOfFile:path];
    
    // Custom initialization
    Dailymotion *dailymotion = [[Dailymotion alloc] init];
    [dailymotion setGrantType:DailymotionGrantTypeClientCredentials
                   withAPIKey:[settings objectForKey:@"api_key"] secret:[settings objectForKey:@"api_secret"] scope:@"read"];
    [dailymotion request:@"/user/klaxpont/videos" withArguments:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSArray arrayWithObjects:@"id", @"title",@"thumbnail_small_url", @"url", nil], @"fields", nil] delegate:self];
}

- (void) displayVideos{
//    [[self tableView] setDataSource:self];
    [[self tableView] reloadData];
        NSLog(@"video count %d", [_videos count]);
//    for (NSDictionary *video in _videos) {
//        NSLog(@"video %@", video);
//        [self buildVideoItem:video index:([_videos indexOfObject:video])];
//    }
//    [self.containerView setContentSize:CGSizeMake(320,[_videos count]/2*230)];
}

- (void) buildVideoItem:(NSDictionary*)videoInfos index:(int)position{
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[videoInfos objectForKey:@"thumbnail_small_url"]]];
//    UIImageView *thumbnail = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imageData]];
//    CGPoint point = CGPointMake(((position % 2 == 0) ? 80 : 240),200* (lroundf(position /2)+1));
//    NSLog(@"video pos: %@", NSStringFromCGPoint(point));
//    [thumbnail setCenter:point];
//    [self.containerView addSubview:thumbnail]; 
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath > 0 && indexPath.row < [_videos count]) {
        NSDictionary *videoInfos = [_videos objectAtIndex:indexPath.row];  
        

        [cell.textLabel setText:[videoInfos objectForKey:@"title"]];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[videoInfos objectForKey:@"thumbnail_small_url"]]];
        UIImage *thumbnail = [[UIImage alloc] initWithData:imageData];
        if (thumbnail == nil) {
            NSLog(@"pas d'image");//http://klaxpont.herokuapp.com/api/dailymotion/token
            thumbnail = [UIImage imageNamed:@"default_thumbnail.jpg"];
        }
        [cell.imageView setImage:thumbnail];

    }
    return cell;

}

#pragma mark - Dailymotion delegate methods
- (void)dailymotion:(Dailymotion *)dailymotion didReturnResult:(NSDictionary *)result userInfo:(NSDictionary *)userInfo
{
    _videos = [result objectForKey:@"list"];
    [self displayVideos];
}

- (void)dailymotion:(Dailymotion *)dailymotion didReturnError:(NSError *)error userInfo:(NSDictionary *)userInfo;
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                 message:[error localizedDescription]
                                delegate:nil
                       cancelButtonTitle:@"Dismiss"
                       otherButtonTitles:nil] show];
    
}

@end
