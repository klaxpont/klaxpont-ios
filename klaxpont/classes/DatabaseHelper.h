//
//  DatabaseHelper.h
//  klaxpont
//
//  Created by François Benaiteau on 17/08/12.
//
//

#import <Foundation/Foundation.h>
@class Video;

@interface DatabaseHelper : NSObject

+(Video*)saveLocalVideo:(NSString*)localPath;
+(void)saveContext;
@end
