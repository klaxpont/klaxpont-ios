//
//  DatabaseHelper.m
//  klaxpont
//
//  Created by François Benaiteau on 17/08/12.
//
//

#import "DatabaseHelper.h"
#import "Video.h"
#import "AppDelegate.h"

@implementation DatabaseHelper


+(Video*)saveLocalVideo:(NSString*)localPath
{
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    Video *recordedVideo = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Video"
                            inManagedObjectContext:context];
    
    
    [recordedVideo setLocalPath:localPath];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return nil;
    }
    return recordedVideo;
}

@end
