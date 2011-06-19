//
//  CAPSemChooserViewController.h
//  IVLE
//
//  Created by Shyam on 3/31/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAPSemChooserDelegate

- (void)userDidFinishChoosingSem:(int)semester;
//returns the semester user finished adding

@end


@interface CAPSemChooserViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{

	IBOutlet UIPickerView *semPicker;
	
	id <CAPSemChooserDelegate> delegate;
}

@property (nonatomic, assign) id <CAPSemChooserDelegate> delegate;

@end
