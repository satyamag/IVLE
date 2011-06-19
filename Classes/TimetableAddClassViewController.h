//
//  TimetableAddClassViewController.h
//  IVLE
//
//  Created by QIN HUAJUN on 4/1/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetablePickerViewController.h"

@protocol TimetableAddClassViewControllerDelegate

- (void)addClassWithInfo:(NSDictionary *)info;

@end


@interface TimetableAddClassViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TimetablePickerViewControllerDelegate> {
	
	IBOutlet UISegmentedControl *classTypeSegment;
	IBOutlet UITableView *infoTable;	
	
	NSString *_moduleName;
	NSString *_location;
	NSString *_classType;
	NSString *_day;
	NSDate *_startTime;
	NSDate *_endTime;

	id <TimetableAddClassViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSString *_moduleName;
@property (nonatomic, retain) NSString *_location;
@property (nonatomic, retain) NSString *_classType;
@property (nonatomic, retain) NSString *_day;
@property (nonatomic, retain) NSDate *_startTime;
@property (nonatomic, retain) NSDate *_endTime;
@property (nonatomic, assign) id <TimetableAddClassViewControllerDelegate> delegate;


@end
