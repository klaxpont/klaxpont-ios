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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)edit:(id)sender {
}
@end
