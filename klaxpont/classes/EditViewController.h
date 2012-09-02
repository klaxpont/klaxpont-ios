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

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (nonatomic) Video *editedVideo;

- (IBAction)upload:(id)sender;
@end
