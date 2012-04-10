//
//  User.m
//  klaxpont
//
//  Created by François Benaiteau on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

+(id)currentUser
{
    return [self class];
}


+(NSString*)facebookId
{
    NSLog(@"fsfds %@",  [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_id"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_id"];
}
@end
