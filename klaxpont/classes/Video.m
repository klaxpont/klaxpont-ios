//
//  Video.m
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//
#import <AVFoundation/AVFoundation.h>
#import "Video.h"
#import "NSString+Additions.h"

@implementation Video

@dynamic videoId;
@dynamic title;
@dynamic latitude;
@dynamic longitude;
@dynamic localPath;
@dynamic dailymotionVideoId;


- (BOOL) published
{
    return (self.videoId && ![self.videoId isEmpty]);
}

- (BOOL) uploaded
{
    BOOL t= self.dailymotionVideoId == nil;
    return !t;
}


- (UIImage*) thumbnail
{
    UIImage *thumbnailImage = [self loadImage];
    if(thumbnailImage == nil)
        thumbnailImage = [UIImage imageNamed:@"klaxon.png"];
    
    return thumbnailImage;
}


- (UIImage*)loadImage
{
    if (self.localPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:self.localPath])
        return nil;

    NSURL *url = [NSURL fileURLWithPath:self.localPath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;

    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    if(err != NULL){
        NSLog(@"err==%@, imageRef==%@", err, imgRef);
        return nil;
    }
    return [[UIImage alloc] initWithCGImage:imgRef];
}

- (NSURL*) url
{
    NSURL *url = nil;

    if([[NSFileManager defaultManager] fileExistsAtPath:self.localPath]){

        url = [[NSURL alloc] initFileURLWithPath:self.localPath isDirectory:NO];
    
    }
    return url;
}

@end
