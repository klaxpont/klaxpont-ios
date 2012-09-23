//
//  EditViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 18/08/12.
//
//

#import "EditViewController.h"
#import "DatabaseHelper.h"
#import "VideoHelper.h"
#import "UserHelper.h"
#import "LoginViewController.h"
#import "NetworkManager.h"

@interface EditViewController ()

@end

@implementation EditViewController
@synthesize previewImageView;
@synthesize actionButton;
@synthesize titleTextField;
@synthesize editedVideo;
@synthesize locationSwitch;
@synthesize locationLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Nouvelle Vidéo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!editedVideo)
        return;
    
    NSLog(@"video : %d", [self.editedVideo.videoId intValue]);
    if (self.title){
        self.title = editedVideo.title;
        [[self titleTextField] setText:editedVideo.title];
    }
    [self.previewImageView setImage:editedVideo.thumbnail];
    
    if ([self.editedVideo uploaded])
        [self.actionButton setTitle:@"Publier" forState:UIControlStateNormal];
    if([self.editedVideo published])
        [self.actionButton setHidden:YES];
}

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [self setPreviewImageView:nil];
    [self setActionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setEditedVideo:(Video *)editedVideo
{
    if (self.editedVideo.latitude && self.editedVideo.longitude)
    {
        self.locationLabel.text = [NSString stringWithFormat:@"φ:%.4F, λ:%.4F",
                                   [self.editedVideo.latitude doubleValue],
                                   [self.editedVideo.longitude doubleValue]];
        
        [self.locationSwitch setEnabled:YES];
    }
    else
        [self.locationSwitch setEnabled:NO];
}

#pragma mark - Actions

- (IBAction)upload:(id)sender {
    [DatabaseHelper saveContext];


    if (![[UserHelper default] isRegistered]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [[nav navigationBar] setBarStyle:UIBarStyleBlack];
        
        [[self navigationController] presentModalViewController:nav animated:YES];
        return;
    }
    
    if([self.editedVideo title]){
        //send video
        if(![self.editedVideo uploaded])
            [[NetworkManager sharedManager] uploadVideo:self.editedVideo];
        else if (![self.editedVideo published])
            [[NetworkManager sharedManager] publishVideo:self.editedVideo];
        else{
            // update video infos
            NSLog(@"update video infos");
        }

    }else
        NSLog(@"missing title");
        // TODO: alert
    
    // Check if switch button was used and for necessary location info update
    if (_editedVideoLatitude && [_editedVideoLatitude doubleValue] != [self.editedVideo.latitude doubleValue])
    {
        self.editedVideo.latitude = _editedVideoLatitude;
        self.editedVideo.longitude = _editedVideoLongitude;
        
        // Re-save the video
        [DatabaseHelper saveContext];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // handling video action
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:nil];
        if(CGRectContainsPoint(self.previewImageView.frame, point)){
            [VideoHelper openVideo:self.editedVideo from:self];
            break;
        }
    }
    // Dismiss the keyboard when the view outside the text field is touched.
    [self.titleTextField resignFirstResponder];

    [super touchesBegan:touches withEvent:event];
}

- (IBAction)manageLocation:(id)sender
{
    // Check for existing video in edition
    if (self.editedVideo && self.locationSwitch.enabled)
    {
        if (self.locationSwitch.isOn && !self.editedVideo.latitude)
        {
            self.editedVideo.latitude = _editedVideoLatitude;
            self.editedVideo.longitude = _editedVideoLongitude;
            
            _editedVideoLatitude = nil;
            _editedVideoLongitude = nil;
            
            self.locationLabel.text = [NSString stringWithFormat:@"φ:%.4F, λ:%.4F",
                                       [self.editedVideo.latitude doubleValue],
                                       [self.editedVideo.longitude doubleValue]];

        }
        else if (!self.locationSwitch.isOn && _editedVideoLatitude)
        {
            // Cache current video location values
            _editedVideoLatitude = self.editedVideo.latitude;
            _editedVideoLongitude = self.editedVideo.longitude;
            
            // Reset the coordiates values
            self.editedVideo.latitude = nil;
            self.editedVideo.longitude = nil;
            
            self.locationLabel.text = @"";
        }
    }
}

#pragma mark - Animations

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    // see http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-text-field
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma  mark - UITextField  delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.titleTextField) {
		[textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    editedVideo.title = [self.titleTextField text];
    [DatabaseHelper saveContext];
}

@end
