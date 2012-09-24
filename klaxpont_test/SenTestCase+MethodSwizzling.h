//
//  SenTestCase+MethodSwizzling.h
//  klaxpont
//
//  Created by François Benaiteau on 9/24/12.
//
//

#import <SenTestingKit/SenTestingKit.h>

@interface SenTestCase (MethodSwizzling)
- (void)swizzleMethod:(SEL)aOriginalMethod
              inClass:(Class)aOriginalClass
           withMethod:(SEL)aNewMethod
            fromClass:(Class)aNewClass
         executeBlock:(void (^)(void))aBlock;
@end
