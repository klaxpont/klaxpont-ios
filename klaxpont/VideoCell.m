//
//  VideoCell.m
//  klaxpont
//
//  Created by François Benaiteau on 17/08/12.
//
//

#import "VideoCell.h"


@implementation VideoCell
@synthesize thumbnailView;
@synthesize titleLabel;
@synthesize editButton;
@synthesize videoPlaceholder;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [videoPlaceholder setHidden:YES];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
