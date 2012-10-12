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
@dynamic dailymotionVideoId;


- (BOOL) published
{
    return ![NSString isStringEmpty:self.videoId];
}

- (BOOL) uploaded
{
    return ![NSString isStringEmpty:self.dailymotionVideoId];
}


- (UIImage*) thumbnail
{

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.imageFilename]) {
        return [[UIImage alloc] initWithContentsOfFile:self.imageFilename];
    }
    
    UIImage *thumbnailImage = [self loadImage];
    if(thumbnailImage == nil)
        thumbnailImage = [UIImage imageNamed:DEFAULT_THUMBNAIL];
    
    return thumbnailImage;
}

- (NSString*)imageFilename
{
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
   NSString *cachePath = [paths objectAtIndex:0];
   // assuming the last part of the uri iis unique otherwise you're f**k
    //TODO create md5 string from uri
   NSString *filePath =  [cachePath stringByAppendingPathComponent:[[self objectID] URIRepresentation].lastPathComponent];
   return [NSString stringWithFormat:@"%@_generated_image", filePath];
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
    UIImage *image = [[UIImage alloc] initWithCGImage:imgRef];
    if(image){
        NSError *error;
        [UIImagePNGRepresentation(image) writeToFile:self.imageFilename options:NSDataWritingAtomic error:&error];
        if(error){
            NSLog(@"%@", [error description]);
        }
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
