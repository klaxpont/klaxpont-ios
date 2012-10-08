//
//  DailymotionTokenRequest.m
//  klaxpont
//
//  Created by François Benaiteau on 10/2/12.
//
//

#import "DailymotionTokenRequest.h"
#import "AppDelegate.h"

@implementation DailymotionTokenRequest

-(id) init{
    
    self = [self initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(DAILYMOTION_API_TOKEN_PATH)]];
    if(self){
        [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

-(void) processDataResponse:(NSDictionary*)data
{
    NSLog(@"handleDailymotionTokenResponse %@", data);
    [APP_DELEGATE setDailymotionSession:data];
    
    NSNumber *timeout = [[APP_DELEGATE dailymotionSession] objectForKey:@"expires_in"];
    if (timeout) {
        //scheduling request for refreshToken to our server
        [NSTimer scheduledTimerWithTimeInterval:[timeout doubleValue] target:self selector:@selector(requestDailymotionToken) userInfo:nil repeats:NO];
    }

}

@end
