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
    editedVideo.title = [self.titleTextField text];
    
    [DatabaseHelper saveContext];
}


#pragma  mark - UITextField  delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
