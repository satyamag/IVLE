//
//  IVLESideBar.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IVLE.h"
#import "ModuleHeader.h"
#import "ModuleHeaderInfo.h"
#import "LeftSideBarCellView.h"
#import "Forum.h"
#import "IVLE.h"
#import "ModulesWorkbin.h"
#import "ModulesInfo.h"
#import "ModulesAnnouncements.h"
#import "CAPCalculator.h"
#import "Events.h"
#import "Constants.h"
#import "GradeBookController.h"
#import "WebcastController.h"

#import "Map.h"

@interface IVLESideBar : UIViewController <ModuleHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{


	IBOutlet UITableView *moduleList;
	IBOutlet LeftSideBarCellView *tableCell;
}

+(void) clear;

@end
