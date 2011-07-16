//
//  ForumTableCell.h
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForumTableCell : UITableViewCell {
	
	IBOutlet UILabel *titleText;
    IBOutlet UILabel *metaText;
    IBOutlet UIImageView *readIndicator;
    IBOutlet UIImageView *staffIndicator;
}

@property (nonatomic, retain) UILabel *titleText;
@property (nonatomic, retain) UILabel *metaText;
@property (nonatomic, retain) UIImageView *readIndicator;
@property (nonatomic, retain) UIImageView *staffIndicator;

@end
