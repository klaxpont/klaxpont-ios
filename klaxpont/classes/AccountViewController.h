//
//  SettingsViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *username;

- (IBAction)connectFacebook:(id)sender;
@end
