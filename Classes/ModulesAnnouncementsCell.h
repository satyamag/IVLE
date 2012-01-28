//
//  ModulesAnnouncementsCell.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModulesAnnouncementsCell : UITableViewCell {
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
