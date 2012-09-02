//
//  DisclaimerViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <UIKit/UIKit.h>

@interface DisclaimerViewController : UIViewController

- (IBAction)deny:(id)sender;
- (IBAction)accept:(id)sender;

//@property(nonatomic, retain) id onAcceptBlock;
//@property(nonatomic, retain) id onDenyBlock;
@property (nonatomic, copy) void (^onDenyBlock)(void);
@property (nonatomic, copy) void (^onAcceptBlock)(void);
@end
