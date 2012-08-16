//
//  SettingsViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHelper.h"


@interface AccountViewController : UIViewController //<FBRequestDelegate>
{
    UserHelper *_user;
    NSMutableData *_facebookImageData;
}
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
- (IBAction)connectFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *facebookPicture;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end
