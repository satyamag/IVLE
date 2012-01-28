//
//  ForumTableCell.h
//  IVLE
//
//  Created by Satyam Agarwala on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForumTableCell : UITableViewCell {
	
	IBOutlet UILabel *titleText;
    IBOutlet UILabel *metaText;
    IBOutlet UIImageView *readIndicator;
    IBOutlet UIImageView *staffIndicator;
}

@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *metaText;
@property (nonatomic, strong) UIImageView *readIndicator;
@property (nonatomic, strong) UIImageView *staffIndicator;

@end
