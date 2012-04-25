//
//  ViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "VideoPickerController.h"
#import "AccountViewController.h"
#import "User.h"
@interface ViewController()
- (void) uploading;
- (void) showSpinner;
- (void) requestDailymotionToken;
@end

@implementation ViewController

@synthesize preview = _preview;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _moviePlayer = [[MPMoviePlayerController alloc] init];     
    [_moviePlayer.view setFrame:_preview.frame];
    [self.view  addSubview:_moviePlayer.view];

    [self requestDailymotionToken];
}

- (void)viewDidUnload
{
    [self setPreview:nil];
    descriptionField = nil;
    titleField = nil;
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{   
    if(_spinner)
        [_spinner hide:YES];
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self showSpinner];
    [_moviePlayer stop];
	[super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera]) 
            {
                [videoViewController setSourceType:UIImagePickerControllerSourceTypeCamera];
                
            }

            [videoViewController setShowsCameraControls:YES];  
        }


    }
}

#pragma mark - Actions

- (IBAction)play:(id)sender {
    [_moviePlayer play];
}

- (IBAction)upload:(id)sender{
    //test if user is logged in
    User *user = User.new;
    if (![user isRegistered]){
        AccountViewController *accountViewController = [[[self tabBarController] viewControllers] objectAtIndex:2];
        [[self tabBarController] setSelectedViewController:accountViewController];
        return;
    }

    if (_moviePlayer.contentURL == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Choose a file to upload first"
                                   delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];        
        return;
    }
    if([titleField.text isEmpty]){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Put a title"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];     
            [titleField becomeFirstResponder];
        return;
    }
    if([descriptionField.text isEmpty]){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Put a description"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];  
            [descriptionField becomeFirstResponder];
        
        return;
    }
    [self uploading];
    

}
#pragma  mark - Others

- (void) uploading{

    if (dailymotionSession == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:@"Waiting for daylimotion active session, retry later please"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];        

       return;
        
    }
    NSLog(@"daylimotion session: %@", dailymotionSession);
    [self showSpinner];
    
    Dailymotion *dailymotion = [[Dailymotion alloc] init];
    [dailymotion setSession:dailymotionSession];
    
    //upload
    NSLog(@"movie path : %@", [_moviePlayer.contentURL path]);
    [dailymotion uploadFile:[_moviePlayer.contentURL path] delegate:self];

}

- (void) showSpinner{
    _spinner = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_spinner];
	
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    _spinner.delegate = self;
    [_spinner show:YES];
}


- (void) requestDailymotionToken{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(DAILYMOTION_API_TOKEN_PATH)]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [connection start];
    }
}

- (void) postVideoToKlaxpontServer
{   
    User *user = User.new;
    if (_videoId.isEmpty || ![user isRegistered]) {
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:@"No video to upload or user not registerd"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];        
        

        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(VIDEO_PATH)]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"%d", user.klaxpontId]  forHTTPHeaderField:@"user_id"];
    [request addValue:[NSString stringWithFormat:@"%@", _videoId]  forHTTPHeaderField:@"video_id"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [connection start];
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
    
    if (mediaUrl) {
        [_moviePlayer setContentURL:mediaUrl];
    }
    
    
}

#pragma mark - Daylimotion delegate methods

- (void)dailymotion:(Dailymotion *)dailymotion didReturnResult:(id)result userInfo:(NSDictionary *)userInfo{

    NSLog(@"videos %@",result);
    NSDictionary *dictionnary = (NSDictionary*)result;
    _videoId = [dictionnary objectForKey:@"id"];
    [self postVideoToKlaxpontServer];
}


- (void)dailymotion:(Dailymotion *)dailymotion didReturnError:(NSError *)error userInfo:(NSDictionary *)userInfo{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error from dailymotion"
                                                   message:[error localizedDescription]
                                                  delegate:self 
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [_spinner hide:YES];
}

- (void)dailymotion:(Dailymotion *)dailymotion didUploadFileAtURL:(NSString *)URL;
{   
    NSDictionary *videoArguments = [NSDictionary dictionaryWithObjectsAndKeys:URL,@"url",
                                                 titleField.text,@"title", 
                                                 descriptionField.text, @"description",
                                                 //@"fun", @"channel", //@todo: chcek that channel is required move it to server logic
                                                 nil];
    [_spinner hide:YES];   
    [dailymotion request:@"POST /me/videos"
           withArguments:videoArguments
                delegate:self];
}


#pragma mark MBProgressHUD delegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
}

#pragma  mark - UITextField  delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [descriptionField becomeFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



#pragma mark Requests delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"request status code %d", responseStatusCode);
    if (responseStatusCode >= 400) {
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *url = [connection.originalRequest.URL absoluteString];
    if([url hasSuffix:VIDEO_PATH]){
        NSLog(@"response %@", data);
        NSError* error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"data from klaxpont %@; data: %@",url, result );
        
    }
    else if([url hasSuffix:DAILYMOTION_API_TOKEN_PATH]){
        // @todo: 
        if (data) {
            NSError* error;
            dailymotionSession = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSNumber *timeout = [dailymotionSession objectForKey:@"expires_in"];
            
            if (timeout) {
                //scheduling request for refreshToken to our server
                [NSTimer scheduledTimerWithTimeInterval:[timeout doubleValue] target:self selector:@selector(requestDailymotionToken) userInfo:nil repeats:NO];
            }            
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *url = [connection.originalRequest.URL absoluteString];
    NSString *title = [NSString stringWithFormat:@"Error from url %@",url];
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:title
                                                   message:[error localizedDescription]
                                                  delegate:self 
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [connection cancel];    
}

@end
