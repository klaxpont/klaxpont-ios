//
//  SettingsViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBRequest.h"
#import "User.h"

#define FACEBOOK_PROFILE_PATH  @"me"
#define FACEBOOK_PROFILE_PICTURE_PATH  @"me/picture"

@interface AccountViewController : UIViewController<FBRequestDelegate>
{
    User *_user;
    NSMutableData *_facebookImageData;
}
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
- (IBAction)connectFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *facebookPicture;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end
