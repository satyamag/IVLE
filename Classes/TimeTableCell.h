//
//  TimeTableCell.h
//  IVLE
//
//  Created by satyam agarwala on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimeTableCell : UITableViewCell {
    IBOutlet UILabel *eventTitle;
    IBOutlet UILabel *eventDate;
    IBOutlet UIImageView *eventType;
    IBOutlet UIImageView *backgroundImage;
}

@property (nonatomic, retain) UILabel *eventTitle;
@property (nonatomic, retain) UILabel *eventDate;
@property (nonatomic, retain) UIImageView *eventType;
@property (nonatomic, retain) UIImageView *backgroundImage;

@end
