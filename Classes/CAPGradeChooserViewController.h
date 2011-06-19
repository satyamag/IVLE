//
//  CAPGradeChooserViewController.h
//  IVLE
//
//  Created by Shyam on 3/29/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAPGradeChooserDelegate

- (void)userDidFinishChoosingGrade:(NSString *)aGrade;
//returns the grade user finished choosing

@end


@interface CAPGradeChooserViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {

	UIPickerView *gradeChooser;
	
	id <CAPGradeChooserDelegate> delegate;
}

@property (nonatomic, assign) id <CAPGradeChooserDelegate> delegate;

@end
