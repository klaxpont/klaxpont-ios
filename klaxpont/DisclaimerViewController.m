//
//  DisclaimerViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import "DisclaimerViewController.h"


@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

@synthesize onAcceptBlock;
@synthesize onDenyBlock;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)deny:(id)sender
{

    [self onDenyBlock]();
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)accept:(id)sender
{

    [self onAcceptBlock]();
    [self dismissModalViewControllerAnimated:YES];
}
@end
