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

- (void)updateMainThreadTableView:(NSArray *)tableDataSource andCells:(NSMutableArray *)cells andIndexPath:(NSIndexPath *)indexPath;
//update the subthread table view with this newTable

@end


@interface ForumSubThreadTable : UITableViewController {

	NSArray *tableDataSource;
	NSMutableArray *cells;
	
	id <ForumSubThreadTableDelegate> delegate;
}

@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, assign) id <ForumSubThreadTableDelegate> delegate;

@end
