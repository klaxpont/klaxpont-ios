//
//  ViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Dailymotion.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DailymotionDelegate, MBProgressHUDDelegate>{
    MPMoviePlayerController *_moviePlayer;
    MBProgressHUD           *_spinner;
    __weak IBOutlet UITextView *descriptionField;
    __weak IBOutlet UITextField *titleField;
    NSString                *_videoTitle;
    NSString                *_videoId;
    NSDictionary *dailymotionSession;
}

@property (weak, nonatomic) IBOutlet UIView *preview;



@end
