//
//  ForumTableViewController.h
//  IVLE
//
//  Created by QIN HUAJUN on 3/28/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"

@protocol ForumTableViewControllerDelegate

@required

- (void)updateThreadContent:(NSString *)newContent;
//sent new content to the ForumViewController to update the content in the textfield

@end

@interface ForumTableViewController : UITableViewController {

	IVLE *ivleInterface;
	
	NSArray *tableDataSource;
	NSString *CurrentTitle;
	NSInteger CurrentLevel;
	NSString *displayContent;
	
	id <ForumTableViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSString *CurrentTitle;
@property (nonatomic, readwrite) NSInteger CurrentLevel;
@property (nonatomic, assign) NSString *displayContent;
@property (nonatomic, assign) id <ForumTableViewControllerDelegate> delegate;

@end
