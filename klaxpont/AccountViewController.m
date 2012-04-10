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
@synthesize facebookButton;
@synthesize facebookLabel;

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
    
    [self updateFacebookButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFacebookProfile) name:@"facebookDidLogin" object:nil];

}

-(void)updateFacebookButton
{
    NSString *firstName = [[NSUserDefaults  standardUserDefaults] objectForKey:@"facebook_first_name"];
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    if ([[appDelegate facebook] isSessionValid]) {
        if (firstName) {
            [[self facebookLabel] setText:[NSString stringWithFormat:@"Connecté comme %@", firstName]];
        }else {
            [[self facebookLabel] setText:nil];
        }

        [[self facebookButton] setTitle:@"Se déconnecter" forState:UIControlStateNormal];              
    }else {
        [[self facebookLabel] setText:@"not connected"];
        [[self facebookButton] setTitle:@"Se connecter" forState:UIControlStateNormal];


    }
}

-(void)requestFacebookProfile{
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];

}

- (void)viewDidUnload
{
    [self setFacebookButton:nil];
    [self setFacebookLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)connectFacebook:(id)sender {

   if ([[APP_DELEGATE facebook] isSessionValid]) 
       [self facebookLogout];
   else
       [self facebookLogin];
    
    
    [self updateFacebookButton];
}

- (void)facebookLogin
{
  [[APP_DELEGATE facebook] authorize:nil];

}

- (void)facebookLogout
{
    [[APP_DELEGATE facebook] logout];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"facebook_first_name"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"facebook_id"];    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Facebook delegate methods
- (void)requestLoading:(FBRequest *)request
{
    //display loading
}
- (void) request:(FBRequest *)request didLoad:(id)result
{

    NSDictionary *identity = (NSDictionary*)result;
    NSLog(@"response %@", identity);
    // save it to nsuserdefaults for now but should we use core datwa instead?
    [[NSUserDefaults standardUserDefaults] setObject:[identity objectForKey:@"first_name"] forKey:@"facebook_first_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[identity objectForKey:@"id"] forKey:@"facebook_id"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateFacebookButton];

}
@end
