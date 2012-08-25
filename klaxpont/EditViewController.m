//
//  EditViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 18/08/12.
//
//

#import "EditViewController.h"
#import "DatabaseHelper.h"

@interface EditViewController ()

@end

@implementation EditViewController
@synthesize previewImageView;
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
    if (editedVideo) {
        if (self.title)
            self.title = editedVideo.title;
        [self.previewImageView setImage:editedVideo.thumbnail];
    }

}

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [self setPreviewImageView:nil];
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
    //send video
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [self.titleTextField resignFirstResponder];

    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Animations

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
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
