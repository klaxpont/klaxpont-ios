//
//  AppDelegate.h
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

}

@property (strong, nonatomic) FBSession *fbSession;
@property (strong, nonatomic) UIWindow *window;


@end
