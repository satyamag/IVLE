//
//  ModulesInfoCell.h
//  IVLE
//
//  Created by Satyam Agarwala on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModulesInfoCell : UITableViewCell {
	IBOutlet UILabel *titleText;
	IBOutlet UIWebView *descriptionText;
    IBOutlet UIImageView *backgroundImage;
	BOOL finishedLoading;
}

@property (nonatomic, retain) UILabel *titleText;
@property (nonatomic, retain) UIWebView *descriptionText;
@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, assign) BOOL finishedLoading;

@end
