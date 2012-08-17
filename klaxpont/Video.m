//
//  Video.m
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//
#import <AVFoundation/AVFoundation.h>
#import "Video.h"

@implementation Video

@dynamic videoId;
@dynamic title;
@dynamic latitude;
@dynamic longitude;
@dynamic localPath;


- (UIImage*) thumbnail
{
    UIImage *thumbnailImage = [self loadImage];
    if(thumbnailImage == nil)
        thumbnailImage = [UIImage imageNamed:@"klaxon.png"];
    
    return thumbnailImage;
}


- (UIImage*)loadImage {
    if (self.localPath == nil)
        return nil;

    NSURL *url = [NSURL fileURLWithPath:self.localPath];

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;

    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    NSLog(@"err==%@, imageRef==%@", err, imgRef);
    
    return [[UIImage alloc] initWithCGImage:imgRef];
    
}

@end
