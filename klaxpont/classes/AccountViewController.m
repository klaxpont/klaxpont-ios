//
//  SettingsViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserHelper.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFacebookButton) name:@"user.registered" object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateFacebookButton];
}

-(void)updateFacebookButton
{
    if ([[UserHelper default] isRegistered]) {
        [[self username] setText:nil];
        [[self username] setHidden:YES];
        [[self facebookButton] setTitle:@"Se déconnecter" forState:UIControlStateNormal];
   }else {
       [[self username] setHidden:NO];
       [[self username] setText:[UserHelper default].firstName];
       [[self facebookButton] setTitle:@"S'identifier/S'inscrire" forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setFacebookButton:nil];
    [self setUsername:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [[UserHelper default] reset];
    [self updateFacebookButton];
}

- (void)facebookLogin
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [self presentModalViewController:nav animated:YES];
   
}

@end
