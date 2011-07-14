//
//  Forum.h
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Forum : UITableViewController {
	
	IBOutlet UIView *mainThreadTable;
	IBOutlet UIView *subThreadTable;
	IBOutlet UIWebView *contentDisplay;
	
	UINavigationController *mainNC;

}

@property (nonatomic, retain) UINavigationController *mainNC;

@end
