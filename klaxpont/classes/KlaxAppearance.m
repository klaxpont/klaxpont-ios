//
//  KlaxAppearence.m
//  klaxpont
//
//  Created by François Benaiteau on 9/11/12.
//
//

#import "KlaxAppearance.h"

@implementation KlaxAppearance

+(void)applyStyle
{
    UIFont *generalFont = [UIFont fontWithName:DEFAULT_FONT size:20];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:DEFAULT_FONT size:24]}];

    
    UILabel *labelAppearance = [UILabel appearance];
    [labelAppearance setFont:generalFont];
    [[UITextView appearance] setFont:generalFont];
    [labelAppearance setTextColor:[UIColor blackColor]];

    
    [[UILabel appearanceWhenContainedIn:[UITabBar class], nil]
     setFont:[UIFont fontWithName:DEFAULT_FONT size:14]];

    UIButton *buttonAppearance = [UIButton appearance];
    [buttonAppearance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

@end
