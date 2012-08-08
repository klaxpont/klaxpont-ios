//
//  AppDelegate.h
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"   

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>
{
    Facebook *_facebook;
}

@property (nonatomic, retain) Facebook *facebook;
@property (strong, nonatomic) UIWindow *window;


@end
