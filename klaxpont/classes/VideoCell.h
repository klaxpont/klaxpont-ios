//
//  VideoCell.h
//  klaxpont
//
//  Created by François Benaiteau on 17/08/12.
//
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
