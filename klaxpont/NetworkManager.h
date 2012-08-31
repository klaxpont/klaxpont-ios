//
//  NetworkManager.h
//  klaxpont
//
//  Created by François Benaiteau on 8/28/12.
//
// see http://akosma.com/2011/09/20/a-proposed-architecture-for-network-bound-ios-apps/

#import <Foundation/Foundation.h>
#import "Dailymotion.h"
@class Video;

@interface NetworkManager : NSObject<NSURLConnectionDelegate, DailymotionDelegate>

+(NetworkManager *) sharedManager;

- (void) register;
- (void) uploadVideo:(Video*)video;
- (void) publishVideo:(Video*)video;
- (void) requestDailymotionToken;
- (NSArray*) retrieveVideos;
@end
