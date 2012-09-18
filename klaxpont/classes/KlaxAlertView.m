//
//  KlaxAlertView.m
//  klaxpont
//
//  Created by François Benaiteau on 9/12/12.
//
//

#import "KlaxAlertView.h"

@implementation KlaxAlertView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setRemoveFromSuperViewOnHide:YES];
    }
    return self;
}


-(id)initWithError:(NSString*)errorMessage
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        // TODO custom image
        UIImageView *errorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];


        [self setCustomView:errorView];
        self.dimBackground = YES;
        // TODO custom title
        self.labelText = @"Error";
        self.detailsLabelText = errorMessage;
        // the following will refresh display: needDisplay
        self.mode = MBProgressHUDModeCustomView;
    }
    return self;
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegate:nil];
    [self hide:YES];
}


@end
