//
//  WebcastsCell.h
//  IVLE
//
//  Created by satyam agarwala on 7/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebcastsCell : UITableViewCell {
    
    IBOutlet UIImageView *thumbnail;
    IBOutlet UILabel *webcastTitle;
    IBOutlet UILabel *webcastDuration;
    IBOutlet UILabel *webcastDate;
}

@property (nonatomic, retain) UILabel *webcastTitle;
@property (nonatomic, retain) UILabel *webcastDuration;
@property (nonatomic, retain) UILabel *webcastDate;
@property (nonatomic, retain) UIImageView *thumbnail;

@end
