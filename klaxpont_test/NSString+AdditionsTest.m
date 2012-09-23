#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "NSString+Additions.h"

SpecBegin(NSString)

describe(@"NSString+Additions", ^{
    
    it(@"normal string should return false", ^{
        NSString *stringToTest = @"test";
        expect([stringToTest isEmpty]).beFalsy();
    });

    
    it(@"nil string should return true", ^{
        NSString *stringToTest = nil;
        expect([stringToTest isEmpty]).equal(0);
        expect([NSString isStringEmpty:stringToTest]).beTruthy();
    });

    
    it(@"empty string should return true", ^{
        NSString *stringToTest = @"";
        expect([stringToTest isEmpty]).beTruthy();
    });

});

SpecEnd