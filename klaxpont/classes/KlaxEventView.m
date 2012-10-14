//
//  KlaxEventView.m
//  klaxpont
//
//  Created by François Benaiteau on 10/13/12.
//
//

#import "KlaxEventView.h"

@implementation KlaxEventView

- (id)init
{

    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"KlaxEventView" owner:nil options:nil];
    self = [nibObjects objectAtIndex:0];
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self superview]) return;

    [UIView beginAnimations:@"switch_main_views" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft
                           forView:[self superview] cache:NO];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }
                     completion:^(BOOL complete){

                     }];


}
@end
