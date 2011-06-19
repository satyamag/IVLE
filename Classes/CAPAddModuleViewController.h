//
//  CAPAddModuleViewController.h
//  IVLE
//
//  Created by Shyam on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPGradeChooserViewController.h"
#import "CAPSemChooserViewController.h"
#import "ModulesFetcher.h"
#import "ModuleList.h"

@protocol CAPAddModuleDelegate

@required

- (void)userDidFinishAddingModule:(NSString *)aModule WithMC:(NSNumber *)anMC WithGrade:(NSString *)aGrade WithSemester:(NSNumber *)aSemester;
//returns the module user finished adding

@end


@interface CAPAddModuleViewController : UITableViewController <CAPGradeChooserDelegate, CAPSemChooserDelegate, UITextFieldDelegate> {

	id <CAPAddModuleDelegate> delegate; 
	
	UITextField *moduleCode, *moduleMC;
	UILabel *moduleGrade, *moduleSem;
	
	NSArray *moduleList;
}

@property (nonatomic, assign) id <CAPAddModuleDelegate> delegate;

@end
