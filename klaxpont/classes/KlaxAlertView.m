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

-(id)initWithMessage:(NSString*)message
{

    self = [self initWithFrame:CGRectMake(0, 44, 320, HEIGHT(self.window) - (44 + 49))];
    if (self) {
        self.dimBackground = YES;
        self.detailsLabelText = message;
        // the following will refresh display: needDisplay
        self.mode = MBProgressHUDModeCustomView;
    }
    return self;
}


-(id)initWithError:(NSString*)errorMessage
{
    self = [self initWithMessage:errorMessage];
    if (self) {
        // TODO custom image
        UIImageView *errorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        [self setCustomView:errorView];
        self.labelText = @"Error";
    }
    return self;
}



-(id)initWithInformation:(NSString*)infoMessage
{
    self = [self initWithMessage:infoMessage];
    if (self) {
        [self setCustomView:[self randomInformationView]];
        self.labelText = @"Info";
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegate:nil];
    [self hide:YES];
}

-(UIView*) randomErrorView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
}

-(UIView*) randomInformationView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
}


@end
