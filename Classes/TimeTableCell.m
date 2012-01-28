//
//  TimeTableCell.m
//  IVLE
//
//  Created by satyam agarwala on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "TimeTableCell.h"


@implementation TimeTableCell

@synthesize eventDate,eventType,eventTitle,backgroundImage;

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


@end
