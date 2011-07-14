//
//  ForumPostHeadingSelect.h
//  IVLE
//
//  Created by QIN HUAJUN on 7/14/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForumPostHeadingSelectDelegate

- (void)updateHeadingName:(NSString *)newHeading;

@end

@interface ForumPostHeadingSelect : UITableViewController {
	
	NSArray *headingInfo;
	NSString *selectedHeading;

	id <ForumPostHeadingSelectDelegate> delegate;
}

@property (nonatomic, retain) NSArray *headingInfo;
@property (nonatomic, retain) NSString *selectedHeading;
@property (nonatomic, assign) id <ForumPostHeadingSelectDelegate> delegate;;

@end
