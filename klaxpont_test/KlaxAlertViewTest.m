#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCMock.h> 
#import "SenTestCase+MethodSwizzling.h"

#import "KlaxAlertView.h"



SpecBegin(KlaxAlertView)

describe(@"Error Alert View", ^{

    it(@"should appear to user", ^{
        
        KlaxAlertView *alert = [[KlaxAlertView alloc] initWithError:@"test message"];
        
    });
});
SpecEnd
