//
//  ModulesInfo.m
//  IVLE
//
//  Created by Satyam Agarwala on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModulesInfo.h"


@implementation ModulesInfo

@synthesize cells;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		info = [[[IVLE instance] moduleInfo:[IVLE instance].selectedCourseID withDuration:0] valueForKey:@"Results"];
		NSSortDescriptor *sortDescriptor;
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"CreatedDate"
													  ascending:NO] autorelease];
		NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		info = [[info sortedArrayUsingDescriptors:sortDescriptors] retain];
        UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
		
		self.cells = [NSMutableArray array];
		
            
		for (int i=0; i<[info count]; i++) {
			
			ModulesAnnouncementsCell *cell;
			
			
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ModulesAnnouncementsCell" 
														 owner:self
													   options:nil];
			cell = [nib objectAtIndex:0];
			
			cell.titleText.text = [[info objectAtIndex:i] valueForKeyPath:@"Title"];
            cell.titleText.textColor = kWorkbinFontColor;
            cell.meta.text = @"";
			
            NSString *formatedContent = [NSString stringWithFormat:@"<html> \n"
                                         "<head> \n"
                                         "<style type=\"text/css\"> \n"
                                         "body {font-family: \"%@\"; font-size: %@; text-align: %@}\n"
                                         "</style> \n"
                                         "</head> \n"
                                         "<body><div id='foo'>%@</div></body> \n"
                                         "</html>", @"HelveticaNeue", [NSNumber numberWithInt:kWebViewFontSize],@"justify",[[info objectAtIndex:i] valueForKey:@"Description"]];
            
			[cell.descriptionText loadHTMLString:formatedContent baseURL:nil];
			
			do {
				[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
			} while (!cell.finishedLoading);
			NSAssert(cell.finishedLoading, @"cell not finish loading");
			//	NSLog(@"%d, %f, %f", cell.finishedLoading, cell.frame.size.width, cell.frame.size.height);
            cell.descriptionText.contentMode = UIViewContentModeScaleAspectFit;
			cell.descriptionText.backgroundColor = [UIColor clearColor];
            //cell.backgroundImage.image = [UIImage imageNamed:@"module_info_announcement_cell_bg.png"];
			[self.cells addObject:cell];
			//	NSLog(@"added");
			
		}
		
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
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
	[info release];
	[cells release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	tableView.allowsSelection = NO;
	tableView.backgroundColor = [UIColor clearColor];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [info count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    return [self.cells objectAtIndex:[indexPath row]];
}

- (void)loadContent:(NSString*)string{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	ModulesAnnouncementsCell *cell = [cells objectAtIndex:[indexPath row]];
	CGFloat height = cell.descriptionText.frame.size.height + (cell.descriptionText.frame.origin.y-cell.titleText.frame.origin.y);
    CGFloat x = cell.backgroundImage.frame.origin.x;
    CGFloat y = cell.backgroundImage.frame.origin.y;
    CGFloat width = cell.backgroundImage.frame.size.width;
    
    
    cell.backgroundImage.frame = CGRectMake(x, y, width, cell.descriptionText.frame.size.height);
	return height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return nil;
}
@end
