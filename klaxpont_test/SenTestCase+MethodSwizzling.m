//
//  SenTestCase+MethodSwizzling.m
//  klaxpont
//
//  Created by François Benaiteau on 9/24/12.
//
//

#import "SenTestCase+MethodSwizzling.h"
#include <objc/runtime.h>

@implementation SenTestCase (MethodSwizzling)
- (void)swizzleMethod:(SEL)aOriginalMethod
              inClass:(Class)aOriginalClass
           withMethod:(SEL)aNewMethod
            fromClass:(Class)aNewClass
         executeBlock:(void (^)(void))aBlock {
    Method originalMethod = class_getClassMethod(aOriginalClass, aOriginalMethod);
    Method mockMethod = class_getInstanceMethod(aNewClass, aNewMethod);
    method_exchangeImplementations(originalMethod, mockMethod);
    aBlock();
    method_exchangeImplementations(mockMethod, originalMethod);
}
@end