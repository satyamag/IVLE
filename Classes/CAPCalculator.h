//
//  CAPCalculator.h
//  IVLE
//
//  Created by Shyam on 3/27/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "Semester.h"
#import "CAP.h"
#import "CAPModule.h"
#import "ModulesFetcher.h"
#import "CAPGradeChooserViewController.h"
#import "CAPSemChooserViewController.h"
#import "S7GraphView.h"
#import "CAPAddModuleViewController.h"
#import "Element.h"
#import "DocumentRoot.h"
#import "ModuleList.h"

#define kPopoverWidth 320
#define kPopoverHeight 320

#define kGradePopoverX 400
#define kGradePopoverY -30

#define kSemPopoverX 400
#define kSemPopoverY 2

#define kGraphViewX 10
#define kGraphViewY 0
#define kGraphViewWidth 625	
#define kGraphViewHeight 350
#import "Constants.h"
@interface CAPCalculator : UIViewController <UITableViewDataSource, UITableViewDelegate, S7GraphViewDataSource, CAPAddModuleDelegate> {
	
	IVLE *ivleInterface;
	NSMutableArray *moduleObjects;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *semesterObjects;
	UIPopoverController *addModulePopover;
	
	NSArray *buttonsArray;
	
	IBOutlet UITableView *modulesTableView;
	UIButton *addModuleButton;
	IBOutlet UILabel *capLabel;
	IBOutlet UITextField *capOffset, *numberOfMCsCompleted;
	
	S7GraphView *graphView;
	IBOutlet UIView *SAPGraphView;	//holder for S7GraphView
	CGRect graphRect;
}

@property (nonatomic, readonly) int modulesCompleted;
@property (nonatomic, readonly) int MCsCompleted;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)addNewModuleButtonPressed:(id)sender;
//adds a new module to the CAP list

- (IBAction)refreshModuleList;
//refresh the list of modules

- (IBAction)homeButtonPressed;
//returns to the home screen
@end
