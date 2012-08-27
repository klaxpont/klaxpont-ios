//
//  LoginViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 8/27/12.
//
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Settings.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize facebookButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
        [self setTitle:@"Facebook"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.fbSession.isOpen) {
        // create a fresh session object

        appDelegate.fbSession = [[FBSession alloc] initWithAppID:[Settings facebookApiKey] permissions:nil urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.fbSession.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session,
                                                               FBSessionState status,
                                                               NSError *error) {
                // we recurse here, in order to update buttons and labels
                if (appDelegate.fbSession.isOpen) {
                    // TODO : add alert
                    [self dismissModalViewControllerAnimated:YES];
                }else{
                    // TODO : add alert                    
                }
                
            }];
        }
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setFacebookButton:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Actions

- (IBAction)connectFacebook:(id)sender {
    
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.fbSession.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.fbSession closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.fbSession.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.fbSession = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session,
                                                           FBSessionState status,
                                                           NSError *error) {
            // and here we make sure to update our UX according to the new session state
            if (appDelegate.fbSession.isOpen) {
                [self dismissModalViewControllerAnimated:YES];
            }
        }];
    }
}

-(void) close
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
