//
//  UserHelper.m
//  klaxpont
//
//  Created by François Benaiteau on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserHelper.h"

@implementation UserHelper

@synthesize facebookPicture = _facebookPicture;
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
    }
    
    return helper;
}

-(id)init
{
    if(self = [super init])
    {
        _defaults = [NSUserDefaults standardUserDefaults];
        
        _facebookPicture = [_defaults objectForKey:@"facebook_picture"];
        _firstName = [_defaults objectForKey:@"facebook_first_name"];
        _lastName = [_defaults objectForKey:@"facebook_last_name"];
        _klaxpontId = [_defaults objectForKey:@"klaxpont_id"];
    }
    return self;
}

#pragma mark - Methods

-(void)setKlaxpontId:(NSNumber*)klaxpontId
{
    _klaxpontId = klaxpontId;
    [_defaults setObject:klaxpontId forKey:@"klaxpont_id"];
    [_defaults synchronize];
    
}

-(void)setFirstName:(NSString*)firstName
{
    _firstName = firstName;
    [_defaults setObject:firstName forKey:@"facebook_first_name"];
    [_defaults synchronize];
    
}

-(void)setLastName:(NSString*)lastName
{
    _lastName = lastName;
    [_defaults setObject:lastName forKey:@"facebook_last_name"];
    [_defaults synchronize];

}

-(void)setFacebookPicture:(NSMutableData*)facebookPicture
{
    _facebookPicture = facebookPicture;
    [_defaults setObject:facebookPicture forKey:@"facebook_picture"];
    [_defaults synchronize];
    
}
-(void)setFacebookId:(NSNumber*)facebookId
{
    _facebookId = facebookId;
    [_defaults setObject:facebookId forKey:@"facebook_id"];
    [_defaults synchronize];
}

-(BOOL)isRegistered
{
    return _klaxpontId != nil;
}

-(BOOL)acceptedDisclaimer
{
    return [_defaults boolForKey:@"accepted_disclaimer"];
}

-(void)acceptDisclaimer
{
    [_defaults setBool:YES forKey:@"accepted_disclaimer"];
    [_defaults synchronize];
}

@end
