//
//  HomePageModuleAnnouncementCell.h
//  IVLE
//
//  Created by satyam agarwala on 4/15/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomePageModuleAnnouncementCell : UITableViewCell <UIWebViewDelegate, UITextFieldDelegate>{
	IBOutlet UILabel *moduleCode;
	IBOutlet UILabel *postDate;
	IBOutlet UILabel *postTitle;
	IBOutlet UIWebView *descriptionText;
	BOOL finishedLoading;
}

@property (nonatomic, retain) UILabel *moduleCode;
@property (nonatomic, retain) UILabel *postDate;
@property (nonatomic, retain) UILabel *postTitle;
@property (nonatomic, retain) UIWebView *descriptionText;
@property (nonatomic, assign) BOOL finishedLoading;
@end