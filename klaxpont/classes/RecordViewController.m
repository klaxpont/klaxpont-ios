//
//  RecordViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import "RecordViewController.h"
#import "UserHelper.h"
#import "DisclaimerViewController.h"
#import "VideoPickerController.h"
#import "DatabaseHelper.h"
#import "EditViewController.h"

@interface RecordViewController ()
{
    DisclaimerViewController *_disclaimerViewController;
    VideoPickerController   *_videoPickerController;
}

/*!
 *
 */
- (void)startStandardUpdates;

@end

@implementation RecordViewController

@synthesize location = _location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Record";
        _videoPickerController = [[VideoPickerController alloc] init];
        
        _location = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
    

    
    
    
    UIImage *image = [UIImage imageNamed:@"klaxon.png"];
    UIButton *goRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [goRecordButton setImage:image forState:UIControlStateNormal];
    [goRecordButton setCenter:CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height - image.size.height)/2)];
    [goRecordButton addTarget:self action:@selector(showRecorder) forControlEvents:UIControlEventTouchUpInside];
    
//    [goRecordButton setTitle:@"RECORD" forState:UIControlStateNormal];
    [self.view addSubview:goRecordButton];
    
    
    
    if(![[UserHelper default] acceptedDisclaimer]){
        _disclaimerViewController = DisclaimerViewController.new;
        
        [_disclaimerViewController setOnAcceptBlock:^{
            [[UserHelper default] acceptDisclaimer];
        }];
        
        [_disclaimerViewController setOnDenyBlock:^{
            UITabBarController *tabBar = ((UITabBarController*)self.parentViewController);
            tabBar.selectedIndex = TABBAR_TOPVIDEOS_INDEX;// go to videbas
        }];
    }

}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start the location feature in order to prompt user authorization
    [self startStandardUpdates];
    
    // Pause the service as position is only requested when starting recording
    if (_locationManager)
        [_locationManager stopUpdatingLocation];
    
    if(_disclaimerViewController != nil && ![[UserHelper default] acceptedDisclaimer]){
        [self presentModalViewController:_disclaimerViewController animated:YES];
    }

}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop the location feature
    if(_locationManager)
        [_locationManager stopUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

-(void) showRecorder
{
    // TODO recheck this condition if necessary
    if([VideoPickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            [_videoPickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [_videoPickerController setShowsCameraControls:YES];
        [_videoPickerController setDelegate:self];
        [self presentModalViewController:_videoPickerController animated:YES];
        
        // Start the location service update to save video position
        _storeLocation = YES;
        [self startStandardUpdates];
        
    }else{
        // TODO display error message in case device has no camera video
    }

}

- (void)startStandardUpdates
{
    // Create the location manager if necessary
    if (nil == _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        // Set a movement threshold for new events
        _locationManager.distanceFilter = 10;
    }
    
    // Reset previous session stored location
    _location = nil;
    
    [_locationManager startUpdatingLocation];
}

#pragma mark - Delegates

#pragma mark - VideoPickerController delegate methods
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker setDelegate:nil];
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker setDelegate:nil];
    NSLog(@"infos from dictionary : %@", info);
    
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:^{
        if([info objectForKey:@"UIImagePickerControllerReferenceURL"] == nil){//no reference so that's a capture, let's save the video
            NSString *moviePath = [mediaUrl path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
                Video *video = [DatabaseHelper saveLocalVideo:moviePath];
                if (video != nil){
                    NSLog(@"Video successfully saved!");
                    
                    // Manage video location
                    if (_location != nil)
                    {
                        video.latitude = [NSNumber numberWithDouble:_location.coordinate.latitude];
                        video.longitude = [NSNumber numberWithDouble:_location.coordinate.longitude];
                    }
                    
                    UITabBarController *tabBar = ((UITabBarController*)self.parentViewController);
                    
                    UIView * fromView = self.view;
                    UIView * toView = [[tabBar.viewControllers objectAtIndex:TABBAR_MYVIDEOS_INDEX] view];
                    
                    // Transition using a page curl.
                    [UIView transitionFromView:fromView
                                        toView:toView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionCurlUp
                                    completion:^(BOOL finished) {
                                        if (finished) {
                                            tabBar.selectedIndex = TABBAR_MYVIDEOS_INDEX;// go to videbas
                                            
                                            EditViewController *editController = EditViewController.new;
                                            [editController setEditedVideo:video];
                                            UINavigationController *nav = (UINavigationController *)tabBar.selectedViewController;
                                            [nav pushViewController:editController animated:YES];
                                        }
                                    }];

                }else
                    NSLog(@"Video was not saved in db!");
            }
        }
    }];
}

#pragma mark - CLLocationManager delegate methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // Store the location event time
    _lastLocationEventDate = newLocation.timestamp;
    
    // Check for useful location event
    NSTimeInterval howRecent = [_lastLocationEventDate timeIntervalSinceNow];
    if (_storeLocation && abs(howRecent) < 15.0)
    {
        // Store the received location
        _location = newLocation;
        
        _storeLocation = NO;
        
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
    }
}

@end
