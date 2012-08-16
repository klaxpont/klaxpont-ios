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
        [_videoPickerController setDelegate:self];
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
            tabBar.selectedIndex = 2;// go to videbas
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
    if([VideoPickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            [_videoPickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [_videoPickerController setShowsCameraControls:YES];
    }else{
        // TODO display error message in case device has no camera video
    }
}

#pragma mark - Delegates

#pragma mark - VideoPickerController delegate methods
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker setDelegate:nil];
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    [picker setDelegate:nil];
    NSLog(@"infos from dictionary : %@", info);
    
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    
    if([info objectForKey:@"UIImagePickerControllerReferenceURL"] == nil){//no reference so that's a capture, let's save the video
        NSString *moviePath = [mediaUrl path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
        }
    }
    //TODO save to core data

    
    
}

@end
