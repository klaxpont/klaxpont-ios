//
//  KlaxEventView.h
//  klaxpont
//
//  Created by François Benaiteau on 10/13/12.
//
//

#import <UIKit/UIKit.h>

@interface KlaxEventView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UITextView *message;

@end
