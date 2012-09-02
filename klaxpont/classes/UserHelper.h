//
//  UserHelper.h
//  klaxpont
//
//  Created by François Benaiteau on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// using this helper user approach
// see http://rogchap.com/2011/07/12/simple-user-helper-for-ios/


#import <Foundation/Foundation.h>

@interface UserHelper : NSObject
{
    NSUserDefaults *_defaults;

    NSString *_firstName;
    NSString *_lastName;
    NSNumber *_facebookId;
    NSNumber *_klaxpontId;// Klaxpont User id
    BOOL _disclaimer;
}


@property(nonatomic, retain) NSString* firstName;
@property(nonatomic, retain) NSString* lastName;
@property(nonatomic, retain) NSNumber* facebookId;
@property(nonatomic, retain) NSNumber* klaxpontId;


+(UserHelper*) default;

- (void) load;
- (void) save;
- (void) reset;

-(BOOL)isRegistered;
-(BOOL)acceptedDisclaimer;
-(void)acceptDisclaimer;
-(void)reset;
@end
