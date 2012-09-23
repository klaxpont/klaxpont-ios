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

        
//        handlePublishVideoResponse {
  //          id = 505f4645bd02860e28000001;
    //    }
});

SpecEnd