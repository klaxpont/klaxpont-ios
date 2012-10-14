//
//  BaseViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 9/15/12.
//
//

#import "BaseTabBarViewController.h"
#import "KlaxAlertView.h"
#import "KlaxEventView.h"
@interface BaseTabBarViewController()
{
    KlaxEventView *_alert;
}

@end
@implementation BaseTabBarViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO handle success message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:ERROR_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTimedAlert:) name:ERROR_NOTIFICATION_WITH_ON_COMPLETE_BLOCK object:nil];
}

#pragma mark - Alert


-(void)showAlert:(NSNotification*)notification
{
    NSLog(@"notification for alert: %@", [notification userInfo]);
    if (_alert == nil) {
        _alert = KlaxEventView.new;
    }
    _alert.title.text = @"Error";
    _alert.message.text = [[notification userInfo] objectForKey:@"message"];
    
    [UIView beginAnimations:@"switch_main_views" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
                           forView:self.selectedViewController.view cache:NO];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        [self.selectedViewController.view addSubview:_alert];
    }
                     completion:^(BOOL complete){
                     }];

}

-(void)showTimedAlert:(NSNotification*)notification
{
    [self showAlert:notification];


//    [_alert hide:YES afterDelay:1];
    if ([notification object]) {
        [self performSelector:@selector(executeBlock:) withObject:[notification object] afterDelay:1];
    }
}

-(void) executeBlock:(void (^)(void))block
{
    block();
}

@end
