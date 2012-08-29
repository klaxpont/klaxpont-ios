//
//  Video.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSNumber * videoId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * localPath;
@property (nonatomic, retain) NSString * dailymotionVideoId;

- (UIImage*) thumbnail;
- (NSURL*) url;
- (BOOL) published;
- (BOOL) uploaded;
@end
