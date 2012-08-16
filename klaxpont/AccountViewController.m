//
//  SettingsViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize facebookPicture;
@synthesize username;
@synthesize facebookButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _user = User.new;
    [self updateFacebookPicture];


    [self updateFacebookButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFacebookInfos) name:@"facebookDidLogin" object:nil];

}
- (void) updateFacebookPicture
{
    
    UIImage *image = [UIImage imageWithData:[_user facebookPicture]];
    [[self facebookPicture] setImage:image];
    [[self facebookPicture] setFrame:CGRectMake(10, 10, image.size.width, image.size.height)];
}
-(void)updateFacebookButton
{
    if (_user.firstName) {
        [[self username] setText:_user.firstName];
    }else {
        [[self username] setText:nil];
    }
    
//    if ([[APP_DELEGATE facebook] isSessionValid]) {
//        [[self facebookButton] setTitle:@"Se déconnecter" forState:UIControlStateNormal];              
//    }else {
//        [[self facebookButton] setTitle:@"Se connecter" forState:UIControlStateNormal];
//    }
}

- (void)viewDidUnload
{
    [self setFacebookButton:nil];

    [self setFacebookPicture:nil];
    [self setUsername:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions

- (IBAction)connectFacebook:(id)sender {

//   if ([[APP_DELEGATE facebook] isSessionValid]) 
//       [self facebookLogout];
//   else
//       [self facebookLogin];
//    
//    
//    [self updateFacebookButton];
}

- (void)facebookLogin
{
//  [[APP_DELEGATE facebook] authorize:nil];

}

- (void)facebookLogout
{
//    [[APP_DELEGATE facebook] logout];
    
}
#pragma mark - Requests

-(void)requestFacebookInfos{
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
//    [appDelegate.facebook requestWithGraphPath:FACEBOOK_PROFILE_PATH andDelegate:self];
//    [appDelegate.facebook requestWithGraphPath:FACEBOOK_PROFILE_PICTURE_PATH andDelegate:self];
}

-(void)registerUser
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(USER_PATH)]];
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"%@",_user.facebookId]  forHTTPHeaderField:@"facebook_id"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request  delegate:self];
    if (connection) {
        [connection start];
    }


}

#pragma mark Facebook delegate methods
- (void)requestLoading:(FBRequest *)request
{
    //display loading
}
- (void) request:(FBRequest *)request didLoadRawResponse:(NSData *)data{
//    if([request.url hasSuffix:FACEBOOK_PROFILE_PICTURE_PATH])
//    {
//        NSLog(@"request %@", request.url );     
//        if(_user.facebookPicture == nil)
//        {
//            _user.facebookPicture = [[NSMutableData alloc] initWithData:data];
//        }else {
//            [_user.facebookPicture appendData:data];
//        }
//
//    }
}
- (void) request:(FBRequest *)request didLoad:(id)result
{
//    if([request.url hasSuffix:FACEBOOK_PROFILE_PATH])
//    {
//        NSDictionary *identity = (NSDictionary*)result;
//        NSLog(@"response profile %@", identity); 
//
//        // save it to nsuserdefaults for now but should we use core data instead?
//        [_user setFirstName:[identity objectForKey:@"first_name"]];
//        [_user setLastName:[identity objectForKey:@"last_name"]];
//        [_user setFacebookId:[identity objectForKey:@"id"]];
//
//        [self updateFacebookButton];
//        
//        //register to klaxpont server
//        if (![_user isRegistered])
//            [self registerUser];
//    }
//    
//    else if([request.url hasSuffix:FACEBOOK_PROFILE_PICTURE_PATH])
//    {
//        [self updateFacebookPicture];
//    }   
}

#pragma mark NSURLConnection delegate methods
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
    if (data) {
        NSLog(@"data from klaxpont %@", data );
        NSError* error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"data from klaxpont %@",result );
        [_user setKlaxpontId:[result objectForKey:@"user_id"]];
       NSLog(@"error data from klaxpont %@",error );
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error from connection %@",error );
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [connection cancel];    
}
@end
