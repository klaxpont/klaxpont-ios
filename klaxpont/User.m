//
//  User.m
//  klaxpont
//
//  Created by François Benaiteau on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize facebookPicture = _facebookPicture;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize facebookId = _facebookId;
@synthesize klaxpontId = _klaxpontId;

-(id)init
{
    if(self = [super init])
    {
        _facebookPicture = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_picture"];
        _firstName = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_first_name"];
        _lastName = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_last_name"];
        _klaxpontId = [[NSUserDefaults standardUserDefaults] objectForKey:@"klaxpont_id"];
    }
    return self;
}

-(void)setKlaxpontId:(NSNumber*)klaxpontId
{
    _klaxpontId = klaxpontId;
    [[NSUserDefaults standardUserDefaults] setObject:klaxpontId forKey:@"klaxpont_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setFirstName:(NSString*)firstName
{
    _firstName = firstName;
    [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:@"facebook_first_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setLastName:(NSString*)lastName
{
    _lastName = lastName;
    [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:@"facebook_last_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)setFacebookPicture:(NSMutableData*)facebookPicture
{
    _facebookPicture = facebookPicture;
    [[NSUserDefaults standardUserDefaults] setObject:facebookPicture forKey:@"facebook_picture"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)setFacebookId:(NSNumber*)facebookId
{
    _facebookId = facebookId;
    [[NSUserDefaults standardUserDefaults] setObject:facebookId forKey:@"facebook_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isRegistered
{
    return _klaxpontId != nil;
}
@end
