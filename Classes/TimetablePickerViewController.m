    //
//  TimetablePickerViewController.m
//  IVLE
//
//  Created by QIN HUAJUN on 4/1/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "TimetablePickerViewController.h"


@implementation TimetablePickerViewController

@synthesize delegate, tag;

- (CGSize)contentSizeForViewInPopover
{
	return CGSizeMake(300, 432);
}

//action selector
- (void)done
{
	//NSLog(@"%@", datePicker.date);
	//format the time into string
	//NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	//formatter.dateFormat = @"hh:mm a";
	//NSString *time = [formatter stringFromDate:start.date];
	
	//update the source through delegate
	[self.delegate time:datePicker.date setFor:self.tag];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
	self.title = @"Choose Time";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
	
}


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
	[tag release];
    [super dealloc];
}


@end
