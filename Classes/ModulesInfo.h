//
//  ModulesInfo.h
//  IVLE
//
//  Created by Satyam Agarwala on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IVLE.h"
#import "ModulesAnnouncementsCell.h"

@interface ModulesInfo : UIViewController <UITableViewDelegate, UIWebViewDelegate> {
	NSArray *info;
	NSMutableArray *cells;
}

@property (nonatomic, retain) NSMutableArray *cells;

@end
