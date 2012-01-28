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

@property (nonatomic, strong) UILabel *webcastTitle;
@property (nonatomic, strong) UILabel *webcastDuration;
@property (nonatomic, strong) UILabel *webcastDate;
@property (nonatomic, strong) UIImageView *thumbnail;

@end
