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
#import "KlaxAlertView.h"
#import "KlaxAppearance.h"

@interface RecordViewController ()
{
    DisclaimerViewController *_disclaimerViewController;
    VideoPickerController   *_videoPickerController;
}
@end

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Record";
        _videoPickerController = [[VideoPickerController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
    

    UILabel *catchphrase = [[UILabel alloc] init];
    [catchphrase setFrame:CGRectMake((self.view.frame.size.width/2) - 100, 60, 200, 40)];

    [catchphrase setTextAlignment:UITextAlignmentCenter];

    [catchphrase setFont: [UIFont fontWithName:DEFAULT_FONT size:40]];
    [catchphrase setText:@"Klaxponne !"];

    [self.view addSubview:catchphrase];

    
    UIImage *image = [UIImage imageNamed:@"klaxpont_logo.png"];
    UIButton *goRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [goRecordButton setImage:image forState:UIControlStateNormal];
    [goRecordButton setCenter:CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height - image.size.height)/2 + 44)];
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
    
    if(_disclaimerViewController != nil && ![[UserHelper default] acceptedDisclaimer]){
        [self presentModalViewController:_disclaimerViewController animated:YES];
    }

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
    }else{
        // TODO display error message in case device has no camera video
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.labelText = @"Loading";
//        [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
//            hud.progress = progress;
//        } completionCallback:^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }];
        
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        
//        // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
//        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
//        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
//        
//        // Set custom view mode
//        HUD.mode = MBProgressHUDModeCustomView;
//        
//        HUD.delegate = self;
//        HUD.labelText = @"Completed";
//        
//        [HUD show:YES];
//        [HUD hide:YES afterDelay:3];
        KlaxAlertView *alert = [[KlaxAlertView alloc] initWithView:self.view];
        alert.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:alert];
        alert.labelText = NSLocalizedString(@"VIDEO_CAMERA_UNAVAILABLE",nil);
        [alert show:YES];
        
    }

}

#pragma mark - Delegates

#pragma mark - VideoPickerController delegate methods
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker setDelegate:nil];
    [picker dismissModalViewControllerAnimated:YES];
    
}
- (void) moveToEditVideo:(Video*)video
{
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
    

}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // show Alert
    KlaxAlertView *alert = [[KlaxAlertView alloc] initWithView:self.view];
    alert.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:alert];
    alert.labelText = NSLocalizedString(@"SAVING_VIDEO",nil);
    [alert show:YES];

    
    [picker setDelegate:nil];
    NSLog(@"infos from dictionary : %@", info);
    
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:^{

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            Video *video = nil;
            if([info objectForKey:@"UIImagePickerControllerReferenceURL"] == nil){//no reference so that's a capture, let's save the video
                NSString *moviePath = [mediaUrl path];

                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
                    video = [DatabaseHelper saveLocalVideo:moviePath];
                }
            }
            

            // Hide the HUD in the main tread
            dispatch_async(dispatch_get_main_queue(), ^{
 

                if (video != nil){
                    [alert setLabelText:NSLocalizedString(@"VIDEO_SAVED", nil)];
                    NSLog(@"Video successfully saved!");
                    [self performSelector:@selector(moveToEditVideo:) withObject:video afterDelay:3];
                }else{
                    [alert setLabelText:NSLocalizedString(@"ERROR_SAVING_VIDEO", nil)];
                    NSLog(@"Video was not saved in db!");
                }
                [alert hide:YES afterDelay:3];
                    
                
            });
            
        });
    }];

    

}

@end
