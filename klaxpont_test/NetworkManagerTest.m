#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCMock.h> 
#import "NetworkManager.h"
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

describe(@"NetworkManager", ^{
    __block NetworkManager *manager = nil;

    beforeAll(^{
      manager = [NetworkManager sharedManager];
    });
    
    it(@"should get an instance", ^{
        // This is an example block. Place your assertions here.
        expect(manager).notTo.beNil();
    });

    it(@"should return default image in case of error", ^{
        UIImage *defaultImage = [UIImage imageNamed:@"default_thumbnail.jpg"];
        
        __block UIImage *image = nil;
        [self swizzleMethod:@selector(dataWithContentsOfURL:)     inClass:[NSData class]
                 withMethod:@selector(noDataWithContentsOfURL:) fromClass:[NetworkManagerTest class]
               executeBlock:^{
                   image = [manager downloadImage:nil];
               }];
        
        expect(image).notTo.beNil();
        expect(UIImageJPEGRepresentation(image, 1.0)).equal(UIImageJPEGRepresentation(defaultImage, 1.0));
    });

    it(@"should return an image", ^{
        UIImage *defaultImage = [UIImage imageNamed:@"default_thumbnail.jpg"];
        UIImage *expectedImage = [UIImage imageNamed:@"klaxon.png"];

        __block UIImage *image = nil;
        [self swizzleMethod:@selector(dataWithContentsOfURL:)     inClass:[NSData class]
                 withMethod:@selector(fakeDataWithContentsOfURL:) fromClass:[NetworkManagerTest class]
               executeBlock:^{
                   image = [manager downloadImage:nil];
               }];
       
        expect(image).notTo.beNil();
        expect(UIImageJPEGRepresentation(image, 1.0)).notTo.equal(UIImageJPEGRepresentation(defaultImage, 1.0));
        expect(UIImagePNGRepresentation(image)).equal(UIImagePNGRepresentation(expectedImage));
    });
    
});

SpecEnd
