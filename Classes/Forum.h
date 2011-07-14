//
//  Forum.h
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumMainThreadTable.h"
#import "ForumSubThreadTable.h"

@interface Forum : UIViewController <ForumMainThreadTableDelegate, ForumSubThreadTableDelegate> {
	
	IBOutlet UIView *mainThreadTable;
	IBOutlet UIView *subThreadTable;
	IBOutlet UIWebView *contentDisplay;
	
	UINavigationController *mainNC;
	
}

@property (nonatomic, retain) IBOutlet UIView *mainThreadTable;
@property (nonatomic, retain) IBOutlet UIView *subThreadTable;
@property (nonatomic, retain) IBOutlet UIWebView *contentDisplay;
@property (nonatomic, retain) UINavigationController *mainNC;

@end

