//
//  Settings.m
//  klaxpont
//
//  Created by François Benaiteau on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+(NSDictionary*) content{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSDictionary *settings=[NSDictionary dictionaryWithContentsOfFile:path];
    if (settings == nil) {
        [NSException raise:@"Missing settings error" format:@"Please refer to get started documentation"];
    }
    return settings;
}

#pragma mark - Facebook

+(NSDictionary*) facebook{
   return [[[self class] content] objectForKey:@"facebook"];
}


+(NSString*) facebookApiKey{
    return [[[self class] facebook] objectForKey:@"api_key"];
}

+(NSString*) facebookApiSecret{
    return [[[self class] facebook] objectForKey:@"api_secret"];
}

#pragma mark - Dailymotion

+(NSDictionary*) dailymotion{
    return [[[self class] content] objectForKey:@"dailymotion"];
}

+(NSString*) dailymotionApiKey{
    return [[[self class] dailymotion] objectForKey:@"api_key"];
}

+(NSString*) dailymotionApiSecret{
    return [[[self class] dailymotion] objectForKey:@"api_secret"];
}


@end
