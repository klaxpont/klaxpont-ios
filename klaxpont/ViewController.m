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

- (IBAction)upload:(id)sender{
    if (_moviePlayer.contentURL == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                     message:@"Choose a file to upload first"
                                    delegate:nil
                           cancelButtonTitle:@"Dismiss"
                           otherButtonTitles:nil] show];

        return;
    }
    Dailymotion *dailymotion = [[Dailymotion alloc] init];
//    A session is an NSDictionary which can contain any of the following keys:
//    * - ``access_token``: a token which can be used to access the API
//    * - ``expires``: an ``NSDate`` which indicates until when the ``access_token`` remains valid
//    * - ``refresh_token``: a token used to request a new valid ``access_token`` without having to ask the end-user again and again
//    * - ``scope``: an indication on the permission scope granted by the end-user for this session

    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:@"bHhWQhFCVAZaX05eCBIaAEgSAhwVGFk",@"access_token",
                             [NSDate dateWithTimeIntervalSinceNow:36000],@"expires",
                             @"ad8dc6ef7fa4f4c163f19a00077268ed4846d623", @"refresh_token",
                             @"scope", @"manage_videos",
                             nil];
    
    [dailymotion setSession:session];
    //upload
    NSLog(@"movie path : %@", [_moviePlayer.contentURL path]);
    [dailymotion uploadFile:[_moviePlayer.contentURL path] delegate:self];
}

#pragma mark - Daylimotion Delegate methods

- (void)dailymotion:(Dailymotion *)dailymotion didReturnResult:(id)result userInfo:(NSDictionary *)userInfo{
    //NSArray *videos = [result objectForKey:@"list"];
}

/**
 * Called when an API request return an error response.
 *
 * @param dailymotion The dailymotion instance sending the message.
 * @param error The error returned by the server. NSError domaines can be one of:
 *              - DailymotionTransportErrorDomain: when the error is at transport level (network error, server error, protocol error)
 *              - DailymotionAuthErrorDomain: when the error is at the OAuth level (invalid key, unsufficient permission, etc.)
 *              - DailymotionApiErrorDomain: the the error is at the API level (see `API reference for more info
 *                <http://www.dailymotion.com/doc/api/reference.html>`_)
 * @param userInfo The dictionnary provided to the ``request:withArguments:delegate:userInfo:`` method.
 */
- (void)dailymotion:(Dailymotion *)dailymotion didReturnError:(NSError *)error userInfo:(NSDictionary *)userInfo{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)dailymotion:(Dailymotion *)dailymotion didUploadFileAtURL:(NSString *)URL;
{
    
    [dailymotion request:@"POST /me/videos"
           withArguments:[NSDictionary dictionaryWithObject:URL forKey:@"url"]
                delegate:self];
}



@end
