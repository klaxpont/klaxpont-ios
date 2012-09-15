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
#import "KlaxAlertView.h"

@interface EditViewController ()

@end

@implementation EditViewController
@synthesize previewImageView;
@synthesize actionButton;
@synthesize titleTextField;
@synthesize editedVideo;

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

#pragma mark - Actions

- (IBAction)upload:(id)sender {
    [DatabaseHelper saveContext];
    
    KlaxAlertView *alert = [[KlaxAlertView alloc] initWithView:self.view];
    [self.view addSubview:alert];

    // show error
    if(![self.editedVideo title]){
        [alert setLabelText:NSLocalizedString(@"ERROR_MISSING_TITLE", nil)];
        [alert show:YES];
//        [alert hide:YES afterDelay:3];
        
        NSLog(@"missing title");
        return;
    }
    
    // register
    if (![[UserHelper default] isRegistered]) {
        [alert setLabelText:NSLocalizedString(@"NEED_TO_REGISTER", nil)];
        [alert show:YES];

        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        [[self navigationController] presentModalViewController:nav animated:YES];
        return;
    }


    
    //send video
    NetworkManager *network = [NetworkManager sharedManager];
    if(![self.editedVideo uploaded]){
        [alert setLabelText:NSLocalizedString(@"VIDEO_UPLOADING", nil)];
        [alert show:YES];
//        [alert showWhileExecuting:@selector(uploadVideo:) onTarget:network withObject:self.editedVideo animated:YES];
        [[NetworkManager sharedManager] uploadVideo:self.editedVideo];
    }
    else if (![self.editedVideo published])
    {
        [alert setLabelText:NSLocalizedString(@"VIDEO_PUBLISHING", nil)];
        [alert show:YES];
//          [alert showWhileExecuting:@selector(publishVideo:) onTarget:network withObject:self.editedVideo animated:YES];
        [[NetworkManager sharedManager] publishVideo:self.editedVideo];
    }
    else{
        [alert setLabelText:NSLocalizedString(@"VIDEO_UPDATE", nil)];
        [alert show:YES];
        // update video infos
        NSLog(@"update video infos");
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
