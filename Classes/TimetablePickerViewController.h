//
//  TimetablePickerViewController.h
//  IVLE
//
//  Created by QIN HUAJUN on 4/1/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimetablePickerViewControllerDelegate

- (void)time:(NSDate *)time setFor:(NSString *)tag;

@end


@interface TimetablePickerViewController : UIViewController <UIPickerViewDelegate> {
	
	id <TimetablePickerViewControllerDelegate> delegate;
	NSString *tag;
	
	IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, assign) id <TimetablePickerViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *tag;

-(void)done;

-(void)cancel;

@end
