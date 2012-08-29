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

    NSMutableData *_facebookPicture;
    NSString *_firstName;
    NSString *_lastName;
    NSNumber *_facebookId;
    NSNumber *_klaxpontId;// Klaxpont User id
}


@property(nonatomic, retain, setter = setFirstName:) NSString* firstName;
@property(nonatomic, retain, setter = setLastName:) NSString* lastName;
@property(nonatomic, retain, setter = setFacebookPicture:) NSMutableData* facebookPicture;
@property(nonatomic, retain, setter = setFacebookId:) NSNumber* facebookId;
@property(nonatomic, retain, setter = setKlaxpontId:) NSNumber* klaxpontId;

+(UserHelper*) default;

-(BOOL)isRegistered;
-(BOOL)acceptedDisclaimer;
-(void)acceptDisclaimer;

@end
