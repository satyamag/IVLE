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
	IBOutlet UIWebView *descriptionText;
	BOOL finishedLoading;
}

@property (nonatomic, retain) UILabel *titleText;
@property (nonatomic, retain) UIWebView *descriptionText;
@property (nonatomic, assign) BOOL finishedLoading;

@end
