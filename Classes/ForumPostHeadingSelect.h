//
//  ForumPostHeadingSelect.h
//  IVLE
//
//  Created by Satyam Agarwala on 7/14/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForumPostHeadingSelectDelegate

- (void)updateHeadingName:(NSString *)newHeading;

@end

@interface ForumPostHeadingSelect : UITableViewController {
	
	NSArray *headingInfo;
	NSString *selectedHeading;

	id <ForumPostHeadingSelectDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, strong) NSArray *headingInfo;
@property (nonatomic, strong) NSString *selectedHeading;
@property (nonatomic, unsafe_unretained) id <ForumPostHeadingSelectDelegate> delegate;;

@end
