//
//  SettingsViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
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
        self.title = @"Réglages";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _user = [UserHelper default];
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
    if (![[UserHelper default] isRegistered])
        [self facebookLogin];
    else
         [self facebookLogout];
//    [self updateFacebookButton];
}

- (void)facebookLogin
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [[nav navigationBar] setBarStyle:UIBarStyleBlack];
    
    [self presentModalViewController:nav animated:YES];
   
}

- (void)facebookLogout
{


    
}
#pragma mark - Requests


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

@end
