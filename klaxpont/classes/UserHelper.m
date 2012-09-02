//
//  UserHelper.m
//  klaxpont
//
//  Created by François Benaiteau on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserHelper.h"

@implementation UserHelper

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize facebookId = _facebookId;
@synthesize klaxpontId = _klaxpontId;



static NSString *kcurrentUser = @"currentUser";

#pragma mark - Initialization

+(UserHelper *) default {
    static UserHelper *helper = nil;
    
    if (helper == nil) {
        helper = [[UserHelper alloc] init];
        [helper load];
    }
    
    return helper;
}

-(id)init
{
    if(self = [super init])
    {
        _defaults = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}
#pragma mark - 
- (void) load
{
    _firstName = [_defaults objectForKey:@"facebook_first_name"];
    _lastName = [_defaults objectForKey:@"facebook_last_name"];
    _klaxpontId = [_defaults objectForKey:@"klaxpont_id"];
    _disclaimer = [_defaults boolForKey:@"accepted_disclaimer"];
}

- (void) save
{
    [_defaults setObject:self.klaxpontId forKey:@"klaxpont_id"];
    [_defaults setObject:self.firstName forKey:@"facebook_first_name"];
    [_defaults setObject:self.lastName forKey:@"facebook_last_name"];
    [_defaults setObject:self.facebookId forKey:@"facebook_id"];

    [_defaults setBool:_disclaimer forKey:@"accepted_disclaimer"];
    [_defaults synchronize];

}

-(void)reset
{
    _firstName = nil;
    _lastName = nil;
    _klaxpontId = nil;
    _disclaimer = NO;
}

#pragma mark - Methods

-(BOOL)isRegistered
{
    return _klaxpontId != nil;
}

-(BOOL)acceptedDisclaimer
{
    return _disclaimer;
}

-(void)acceptDisclaimer
{
    _disclaimer = YES;
}


@end
