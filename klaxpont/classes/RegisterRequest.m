//
//  RegisterRequest.m
//  klaxpont
//
//  Created by François Benaiteau on 10/2/12.
//
//

#import "RegisterRequest.h"
#import "UserHelper.h"

@implementation RegisterRequest

-(id) init{

    self = [self initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(USER_PATH)]];
    if(self){

        [self setHTTPMethod:@"POST"];
    
        NSData *data = [[NSString stringWithFormat:@"facebook_id=%@", [UserHelper default].facebookId] dataUsingEncoding:NSUTF8StringEncoding];
        [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [self setHTTPBody:data];
    }
    return self;
}



-(void) processDataResponse:(NSDictionary*)data
{
    NSLog(@"handleUserRegistrationResponse %@", data);
    [[UserHelper default] setKlaxpontId:[data objectForKey:@"user_id"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REGISTERED_NOTIFICATION object:nil];

}
@end
