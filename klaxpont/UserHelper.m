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

-(void) register
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(USER_PATH)]];
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"%@",self.facebookId]  forHTTPHeaderField:@"facebook_id"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request  delegate:self];
    if (connection) {
        [connection start];
    }
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"request status code %d", responseStatusCode);
    if (responseStatusCode >= 400) {
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data) {
        NSLog(@"data from klaxpont %@", data );
        NSError* error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"data from klaxpont %@",result );
        [self setKlaxpontId:[result objectForKey:@"user_id"]];
        NSLog(@"error data from klaxpont %@",error );
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error from connection %@",error );
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [connection cancel];
}
@end
