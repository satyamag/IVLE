//
//  ForumSubThreadTable.h
//  IVLE
//
//  Created by Satyam Agarwala on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "ForumTableCell.h"
#import "ForumMainThreadTable.h"

@protocol ForumSubThreadTableDelegate

@required

- (void)updateMainThreadTableView:(NSArray *)tableDataSource andIndexPath:(NSIndexPath *)indexPath;
//update the subthread table view with this newTable

- (void)displayThreadContent:(NSString *)content andPostID:(NSString*)postID;
//sent new content to the Forum controller to update the content in the textfield

- (void)updateSubThreadTableView:(NSArray *)children andPreviousTable:(id)previousTable;
//update the subthread table view with this newTable

@end


@interface ForumSubThreadTable : UITableViewController <UITableViewDelegate, UIWebViewDelegate> {

	NSArray *tableDataSource;
	NSMutableArray *cells;
    
    ForumTableCell *selectedCell;
    ForumSubThreadTable *previousTable;
	
	id <ForumSubThreadTableDelegate> delegate;
}

@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) ForumSubThreadTable *previousTable;
@property (nonatomic, retain) ForumTableCell *selectedCell;
@property (nonatomic, assign) id <ForumSubThreadTableDelegate> delegate;

-(void) updateContentView;
@end
