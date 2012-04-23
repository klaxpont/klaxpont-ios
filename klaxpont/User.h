//
//  User.h
//  klaxpont
//
//  Created by François Benaiteau on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{

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
-(BOOL)isRegistered;
@end
