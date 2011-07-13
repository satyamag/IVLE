//
//  GradeBookController.h
//  IVLE
//
//  Created by satyam agarwala on 7/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModulesAnnouncementsCell.h"
#import "IVLE.h"
#import "GradeBookCell.h"

@interface GradeBookController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
	NSArray *gradebookResults;
	NSMutableArray *cells;
}

@property (nonatomic, retain) NSMutableArray *cells;

@end
