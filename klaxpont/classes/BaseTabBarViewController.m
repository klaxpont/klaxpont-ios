//
//  BaseViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 9/15/12.
//
//

#import "BaseTabBarViewController.h"
#import "KlaxAlertView.h"

@interface BaseTabBarViewController()
{
    KlaxAlertView *_alert;
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
	// Do any additional setup after loading the view.
    // TODO handle success message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:ERROR_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTimedAlert:) name:ERROR_NOTIFICATION_WITH_ON_COMPLETE_BLOCK object:nil];
}

#pragma mark - Alert

-(void)showAlert:(NSNotification*)notification
{
    NSLog(@"notification for alert: %@", [notification userInfo]);
    if (_alert == nil) {
        _alert = [[KlaxAlertView alloc] initWithError:[[notification userInfo] objectForKey:@"message"]];
        // take the whole screen to take all the touch events
        [_alert setFrame:self.view.frame];
        [_alert setCenter:self.view.center];

    }else{
        [_alert setDetailsLabelText:[[notification userInfo] objectForKey:@"message"]];
    }
    if(![_alert isDescendantOfView:self.view]){
        [self.view addSubview:_alert];
        [_alert show:YES];
    }
}

-(void)showTimedAlert:(NSNotification*)notification
{
    NSLog(@"notification for alert: %@", [notification userInfo]);
    if (_alert == nil) {
        _alert = [[KlaxAlertView alloc] initWithError:[[notification userInfo] objectForKey:@"message"]];
        // take the whole screen to take all the touch events
        [_alert setFrame:self.view.frame];
        [_alert setCenter:self.view.center];
        
    }else{
        [_alert setDetailsLabelText:[[notification userInfo] objectForKey:@"message"]];
    }
    if(![_alert isDescendantOfView:self.view]){
        [self.view addSubview:_alert];
        [_alert show:YES];
        [_alert hide:YES afterDelay:1];
        [self performSelector:@selector(executeBlock:) withObject:[notification object] afterDelay:1];
    }
}
-(void) executeBlock:(void (^)(void))block
{
    block();
}

@end
