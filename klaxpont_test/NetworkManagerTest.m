#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "NetworkManager.h"

SpecBegin(NetworkManager)

describe(@"NetworkManager", ^{
  
    it(@"should get an instance", ^{
        // This is an example block. Place your assertions here.
        NetworkManager *manager = [NetworkManager sharedManager];
        expect(manager).notTo.beNil();
    });

    it(@"should download image and return it", ^{
        // This is an example block. Place your assertions here.
        NetworkManager *manager = [NetworkManager sharedManager];
        NSString *url = @"http://static2.dmcdn.net/static/video/733/701/22107337:jpeg_preview_source.jpg?20110812101650";
        UIImage * image = [manager downloadImage:url];
        expect(image).notTo.beNil();
        expect(image).beKindOf([UIImage class]);
        
    });
    
    
//        handlePublishVideoResponse {
  //          id = 505f4645bd02860e28000001;
    //    }
    //
});

SpecEnd