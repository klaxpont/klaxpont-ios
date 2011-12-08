//
//  ViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "VideoPickerController.h"

@implementation ViewController

@synthesize preview = _preview;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _moviePlayer = [[MPMoviePlayerController alloc] init];     
    [_moviePlayer.view setFrame:_preview.frame];
    [self.view  addSubview:_moviePlayer.view];
}

- (void)viewDidUnload
{
    [self setPreview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ChooseVideo"])
	{
		VideoPickerController    *videoViewController = (VideoPickerController*)segue.destinationViewController;
		[videoViewController setDelegate:self];
	}
    
  	if ([segue.identifier isEqualToString:@"RecordVideo"])
    {
    	VideoPickerController    *videoViewController = (VideoPickerController*)segue.destinationViewController;
		[videoViewController setDelegate:self];
        if([VideoPickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [videoViewController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [videoViewController setShowsCameraControls:YES];  
        }


    }
}
#pragma mark - VideoPickerController delegate methods
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    NSLog(@"infos from dictionary : %@", info);
    
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    
    if([info objectForKey:@"UIImagePickerControllerReferenceURL"] == nil){//no reference so that's a capture, let's save the video
        NSString *moviePath = [mediaUrl path];        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
        }
    }

    if (mediaUrl) {
        [_moviePlayer setContentURL:mediaUrl];
    }

}
#pragma mark - Actions

- (IBAction)play:(id)sender {
   [_moviePlayer play];
}
@end
