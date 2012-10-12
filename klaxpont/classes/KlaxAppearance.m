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
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"black_sample@2x"]]];

    // Labels and Texts 
    UILabel *labelAppearance = [UILabel appearance];
    [labelAppearance setTextColor:[UIColor blackColor]];
    [labelAppearance setFont:generalFont];
    [[UITextView appearance] setFont:generalFont];

    // General Buttons
    UIButton *buttonAppearance = [UIButton appearance];
    [buttonAppearance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    // tab bar
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont fontWithName:DEFAULT_FONT size:16], UITextAttributeFont,
      nil]
                                             forState:UIControlStateNormal];
    


    
}

@end
