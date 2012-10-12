#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCMock.h> 
#import "NetworkManager.h"
#import "UserHelper.h"
#import "SenTestCase+MethodSwizzling.h"


@interface NetworkManagerTest : SenTestCase

@end

@implementation NetworkManagerTest

- (NSData*) fakeDataWithContentsOfURL:(NSURL*)url{
    // assumes requested image is klaxon.png
    return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"klaxon" ofType:@"png"]];
}

- (NSData*) noDataWithContentsOfURL:(NSURL*)url{
    return nil;
}
@end


SpecBegin(NetworkManager)

describe(@"downloading an Image", ^{
    __block NetworkManager *manager = nil;

    beforeAll(^{
      manager = [NetworkManager sharedManager];
    });
    
    it(@"should get an instance", ^{
        // This is an example block. Place your assertions here.
        expect(manager).notTo.beNil();
    });

    it(@"should return default image in case of error", ^{
        UIImage *defaultImage = [UIImage imageNamed:DEFAULT_THUMBNAIL];
        
        __block UIImage *image = nil;
        // faking the url request
        [self swizzleMethod:@selector(dataWithContentsOfURL:)     inClass:[NSData class]
                 withMethod:@selector(noDataWithContentsOfURL:) fromClass:[NetworkManagerTest class]
               executeBlock:^{
                   image = [manager downloadImage:nil];
               }];
        
        expect(image).notTo.beNil();
        // testing data instead of pointer with UIImageRepresentation
        expect(UIImageJPEGRepresentation(image, 1.0)).equal(UIImageJPEGRepresentation(defaultImage, 1.0));
    });

    it(@"should return requested image", ^{
        UIImage *defaultImage = [UIImage imageNamed:DEFAULT_THUMBNAIL];
        UIImage *expectedImage = [UIImage imageNamed:@"klaxon.png"];

        __block UIImage *image = nil;
        // faking the url request
        [self swizzleMethod:@selector(dataWithContentsOfURL:)     inClass:[NSData class]
                 withMethod:@selector(fakeDataWithContentsOfURL:) fromClass:[NetworkManagerTest class]
               executeBlock:^{
                   image = [manager downloadImage:nil];
               }];
       
        expect(image).notTo.beNil();
        // testing data instead of pointer with UIImageRepresentation
        expect(UIImageJPEGRepresentation(image, 1.0)).notTo.equal(UIImageJPEGRepresentation(defaultImage, 1.0));
        expect(UIImagePNGRepresentation(image)).equal(UIImagePNGRepresentation(expectedImage));
    });
    
    it(@"should store the image with its filename", ^{
        UIImage *expectedImage = [UIImage imageNamed:@"klaxon.png"];
        
        __block UIImage *image = nil;
        // faking the url request
        [self swizzleMethod:@selector(dataWithContentsOfURL:)     inClass:[NSData class]
                 withMethod:@selector(fakeDataWithContentsOfURL:) fromClass:[NetworkManagerTest class]
               executeBlock:^{
                   image = [manager downloadImage:@"klaxon.png"];
               }];
        ;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [paths objectAtIndex:0];
        
        NSString *filePath =  [cachePath stringByAppendingPathComponent:@"klaxon.png"];
        expect([[NSFileManager defaultManager] fileExistsAtPath:filePath]).beTruthy();
    });
});


describe(@"register an User", ^{
    __block NetworkManager *manager = nil;
    
    beforeAll(^{
        manager = [NetworkManager sharedManager];
    });
    
    pending(@"should send facebook ID along the request", ^{
        // TODO 1)don't really send the request
        // TODO 2)assert headers and params are well set
        
        id userMock = [OCMockObject partialMockForObject:[UserHelper default]];
        [[[userMock stub] andReturn:@"123"] facebookId];

        id mockConnection = [OCMockObject partialMockForObject:NSURLConnection.new];
//        id mockConnection = [OCMockObject mockForClass:[NSURLConnection class]];
        [(NSURLConnection*)[mockConnection expect] start];


        [manager register];
        [mockConnection verify];
        [userMock verify];
        expect([UserHelper default].klaxpontId).will.notTo.beNil();
    });
    pending(@"should parse the response and set klaxpontId", ^{});
    
});
SpecEnd
