//
//  EditViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 18/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface EditViewController : UIViewController<UITextFieldDelegate>
{
    // Cache coordinates values in case of location switch use
    NSNumber *_editedVideoLatitude;
    NSNumber *_editedVideoLongitude;
}

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (nonatomic) Video *editedVideo;

- (IBAction)upload:(id)sender;
- (IBAction)manageLocation:(id)sender;
@end
