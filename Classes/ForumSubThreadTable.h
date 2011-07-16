//
//  ForumSubThreadTable.h
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
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

- (void)displayThreadContent:(UIWebView *)content;
//sent new content to the Forum controller to update the content in the textfield

- (void)updateSubThreadTableView:(NSArray *)children;
//update the subthread table view with this newTable

@end


@interface ForumSubThreadTable : UITableViewController <UITableViewDelegate, UIWebViewDelegate> {

	NSArray *tableDataSource;
	NSMutableArray *cells;
    
    ForumTableCell *selectedCell;
	
	id <ForumSubThreadTableDelegate> delegate;
}

@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) ForumTableCell *selectedCell;
@property (nonatomic, assign) id <ForumSubThreadTableDelegate> delegate;

@end
