//
//  ModulesAnnouncements.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IVLE.h"
#import "ModulesAnnouncementsCell.h"

@interface ModulesAnnouncements : UIViewController <UITableViewDelegate, UIWebViewDelegate> {
	NSArray *announcements;
	NSMutableArray *cells;
}

@property (nonatomic, retain) NSMutableArray *cells;

@end
