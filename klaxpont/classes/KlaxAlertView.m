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


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self setDelegate:nil];
    [self hide:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
