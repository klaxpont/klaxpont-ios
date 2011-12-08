//
//  ViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    MPMoviePlayerController *_moviePlayer;
}

@property (weak, nonatomic) IBOutlet UIView *preview;


@end
