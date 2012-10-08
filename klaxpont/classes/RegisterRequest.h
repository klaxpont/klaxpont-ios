//
//  RegisterRequest.h
//  klaxpont
//
//  Created by François Benaiteau on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface RegisterRequest : NSMutableURLRequest
-(void) processDataResponse:(NSData*)data;
@end
