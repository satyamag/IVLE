//
//  ForumMainThreadTable.h
//  IVLE
//
//  Created by Satyam Agarwala on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "ForumTableCell.h"
#import "ForumPostNew.h"

@protocol ForumMainThreadTableDelegate

@required

- (void)displayThreadContent:(NSString *)content andPostID:(NSString*)postID;
//sent new content to the Forum controller to update the content in the textfield

- (void)updateMainThreadTableView:(id)newForumTable andHeadingID:(NSString*)headingID andHeadingName:(NSString*)headingName;

- (void)updateSubThreadTableView:(NSArray *)children andPreviousTable:(id)previousTable;
//update the subthread table view with this newTable

-(void) clearSubThreadView;
-(void) clearContentView;
-(void) enablePostingNewThread;
-(void) disablePostingNewThread;

-(void) enableReply;
-(void) disableReply;

@end

@interface ForumMainThreadTable : UITableViewController {

	NSArray *tableDataSource;
	NSMutableArray *cells;
	
	NSInteger currentLevel;
	NSString *__unsafe_unretained currentTitle;
	
	NSMutableArray *headingNames;
	NSMutableArray *headingIDs;
    
    ForumTableCell *selectedCell;
    NSString *currentHeading;
	
	id <ForumMainThreadTableDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, strong) NSArray *tableDataSource;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, readwrite) NSInteger currentLevel;
@property (nonatomic, unsafe_unretained) NSString *currentTitle;
@property (nonatomic, strong) NSMutableArray *headingNames;
@property (nonatomic, strong) NSString *currentHeading;
@property (nonatomic, strong) NSMutableArray *headingIDs;
@property (nonatomic, strong) ForumTableCell *selectedCell;
@property (nonatomic, unsafe_unretained) id <ForumMainThreadTableDelegate> delegate;

@end
