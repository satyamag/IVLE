//
//  HomePageModuleAnnouncementCell.h
//  IVLE
//
//  Created by satyam agarwala on 4/15/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomePageModuleAnnouncementCell : UITableViewCell {
	IBOutlet UILabel *titleText;
    IBOutlet UILabel *meta;
	IBOutlet UIWebView *descriptionText;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIImageView *readIndicator;
	BOOL finishedLoading;
}

@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *meta;
@property (nonatomic, strong) UIWebView *descriptionText;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *readIndicator;
@property (nonatomic, assign) BOOL finishedLoading;

@end