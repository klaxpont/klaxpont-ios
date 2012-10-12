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
@synthesize spinner;


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

    self.backgroundColor = selected ? SELECTED_BACKGROUND_COLOR : BACKGROUND_COLOR;
    [[self titleLabel] setTextColor: (selected ? SELECTED_COLOR : DEFAULT_COLOR)];

}


@end
