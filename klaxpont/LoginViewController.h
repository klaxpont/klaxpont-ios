//
//  LoginViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 8/27/12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
- (IBAction)connectFacebook:(id)sender;
@end
