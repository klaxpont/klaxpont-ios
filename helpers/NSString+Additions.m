//
//  NSString+Additions.m
//  klaxpont
//
//  Created by François Benaiteau on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(BOOL)isEmpty{
 
    if (((NSNull *) self == [NSNull null]) || (self == nil) ) {
        return YES;
    }
    NSString *string = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;  

}
@end
