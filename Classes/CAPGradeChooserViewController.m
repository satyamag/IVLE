    //
//  CAPGradeChooserViewController.m
//  IVLE
//
//  Created by Shyam on 3/29/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "CAPGradeChooserViewController.h"


@implementation CAPGradeChooserViewController

@synthesize delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		gradeChooser = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
		[gradeChooser setShowsSelectionIndicator:YES];
		
		[gradeChooser setDataSource:self];
		[gradeChooser setDelegate:self];
		
		[self.view addSubview:gradeChooser];
		
		[self setContentSizeForViewInPopover:CGSizeMake(320, 320)];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[gradeChooser selectRow:4 inComponent:0 animated:YES];
}


#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
	return 19;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	switch (row) {
		case 0:
			return @"A+";
			break;
		case 1:
			return @"A";
			break;
		case 2:
			return @"A-";
			break;
		case 3:
			return @"B+";
			break;
		case 4:
			return @"B";
			break;
		case 5:
			return @"B-";
			break;
		case 6:
			return @"C+";
			break;
		case 7:
			return @"C";
			break;
		case 8:
			return @"D+";
			break;
		case 9:
			return @"D";
			break;
		case 10:
			return @"F";
			break;
		case 11:
			return @"CS";
			break;
		case 12:
			return @"CU";
			break;
		case 13:
			return @"S";
			break;
		case 14:
			return @"U";
			break;
		case 15:
			return @"W";
			break;
		case 16:
			return @"IP";
			break;
		case 17:
			return @"IC";
			break;
		case 18:
			return @"EXE";
			break;

		default:
			return @"Undefined";
			break;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	NSString *grade;
	
	switch (row) {
		case 0:
			grade = @"A+";
			break;
		case 1:
			grade = @"A";
			break;
		case 2:
			grade = @"A-";
			break;
		case 3:
			grade = @"B+";
			break;
		case 4:
			grade = @"B";
			break;
		case 5:
			grade = @"B-";
			break;
		case 6:
			grade = @"C+";
			break;
		case 7:
			grade = @"C";
			break;
		case 8:
			grade = @"D+";
			break;
		case 9:
			grade = @"D";
			break;
		case 10:
			grade = @"F";
			break;
		case 11:
			grade = @"CS";
			break;
		case 12:
			grade = @"CU";
			break;
		case 13:
			grade = @"S";
			break;
		case 14:
			grade = @"U";
			break;
		case 15:
			grade = @"W";
			break;
		case 16:
			grade = @"IP";
			break;
		case 17:
			grade = @"IC";
			break;
		case 18:
			grade = @"EXE";
			break;
			
		default:
			grade = @"Undefined";
			break;
	}
	
	[delegate userDidFinishChoosingGrade:grade];
}

#pragma mark -
#pragma mark Memory handling functions

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[gradeChooser release];
	
    [super dealloc];
}


@end
