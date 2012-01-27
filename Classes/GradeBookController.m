//
//  GradeBookController.m
//  IVLE
//
//  Created by satyam agarwala on 7/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "GradeBookController.h"


@implementation GradeBookController

@synthesize cells;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
		
		gradebookResults = [[[[IVLE instance] gradebookViewItems:[IVLE instance].selectedCourseID] objectForKey:@"Results"] retain];
		UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
		//NSLog(@"%@", gradebookResults);
	
		self.cells = [NSMutableArray array];
		
		for (int i=0; i<[gradebookResults count]; i++) {
			
			GradeBookCell *cell;
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GradeBookCell" 
														 owner:self
													   options:nil];
			cell = [nib objectAtIndex:0];
			
			cell.itemName.text = [[gradebookResults objectAtIndex:i] valueForKeyPath:@"ItemName"];
            cell.itemName.textColor = kWorkbinFontColor;
            //cell.category.text = [[gradebookResults objectAtIndex:i] valueForKeyPath:@"Category"];
			cell.marksObtained.text = [[gradebookResults objectAtIndex:i] objectForKey:@"MarksObtained"];
			cell.maxMarks.text = [[[gradebookResults objectAtIndex:i] objectForKey:@"MaxMarks"] stringValue];
			cell.averageMedianMarks.text = [[gradebookResults objectAtIndex:i] objectForKey:@"AverageMedianMarks"];
			cell.highestLowest.text = [[gradebookResults objectAtIndex:i] objectForKey:@"HighestLowestMarks"];
			cell.percentile.text = [[gradebookResults objectAtIndex:i] objectForKey:@"Percentile"];
			//cell.gradeDescription.text = [[gradebookResults objectAtIndex:i] objectForKey:@"Description"];
			cell.remark.text = [[gradebookResults objectAtIndex:i] objectForKey:@"Remark"];
			
			[self.cells addObject:cell];
		}
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Table view delegates

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return nil;
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	tableView.allowsSelection = NO;
	tableView.backgroundColor = [UIColor clearColor];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ([gradebookResults count] + 1);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([indexPath row] == 0) {
        GradeBookCell *cell;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GradeBookFirstCell" 
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
        return cell;

    }
    return [self.cells objectAtIndex:([indexPath row] - 1)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
