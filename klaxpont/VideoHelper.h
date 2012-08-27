//
//  VideoHelper.h
//  klaxpont
//
//  Created by François Benaiteau on 8/26/12.
//
//

#import <Foundation/Foundation.h>
@class Video;
@interface VideoHelper : NSObject


+(void)openVideo:(Video*)video from:(UIViewController*)viewController;
+(void)upload:(Video*)video;
@end
