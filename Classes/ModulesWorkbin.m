//
//  ModulesWorkbin.m
//  IVLE
//
//  Created by Lee Sing Jie on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "ModulesWorkbin.h"


@implementation ModulesWorkbin

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
	
	
	//Create Buttons 
	
	
	
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    managedObjectContext = [[[ModulesFetcher sharedInstance] managedObjectContext] retain];
    
    IVLE *ivle = [IVLE instance];
    
    stack = [[NSMutableArray array] retain];
    
    if ([IVLE instance].selectedCourseID) {
        NSDictionary *workbin = [ivle workbin:[IVLE instance].selectedCourseID withDuration:0 withWorkbinID:nil withTitle:NO];
        selectedFolderID = 0;
        
        if ([[[workbin valueForKey:@"Results"] valueForKey:@"Folders"] count] > 0) {
            
            workbinDatasource = [[[[workbin valueForKey:@"Results"] valueForKey:@"Folders"] objectAtIndex:0] retain];
            
            currentDirectoryName = [[[[workbin valueForKey:@"Results"] valueForKey:@"Title"] objectAtIndex:0] retain];
        }
    }
    
    UIImage *bgImage = [UIImage imageNamed:@"IVLE_second_bar_modules_workbin_bg.png"];
    
    
    buttons = [[NSMutableArray array] retain];
    [self redrawButtons];
    self.view.backgroundColor = [UIColor clearColor] ;
    directoryStructure.backgroundColor = [UIColor colorWithPatternImage:bgImage] ;
    table.backgroundColor = [UIColor clearColor];
    
    supportedExtOfFiles = [[NSSet setWithObjects:@"ppt", @"pptx", @"docx", @"doc", @"pdf", @"xls", @"xlsx", nil] retain];
}

- (void)redrawButtons{
	[self removeAllButtons];
	[self drawAllButtons];
}

- (void)drawAllButtons{
	
	UIButton *currentDirectoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	
	
	UIImage *bgImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
	
	
	currentDirectoryButton.tag = -1;
	
	if ([stack count] == 0) {
		currentDirectoryButton.frame = CGRectMake(0,200, kWorkbinButtonWidth, kWorkbinButtonHeight);
		currentDirectoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
		currentDirectoryButton.titleLabel.alpha = 0.5;
		//		[currentDirectoryButton setTitleColor:[UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		[currentDirectoryButton setTitle:@"← Please select a module" forState:UIControlStateNormal];
		[currentDirectoryButton setBackgroundImage:bgImage forState:UIControlStateDisabled];
		[currentDirectoryButton setEnabled:NO];
	} else{
		currentDirectoryButton.frame = CGRectMake(0,5, kWorkbinButtonWidth, kWorkbinButtonHeight);
		currentDirectoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
		//		[currentDirectoryButton setTitleColor:[UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		[currentDirectoryButton setTitle:currentDirectoryName forState:UIControlStateNormal];
		[currentDirectoryButton setBackgroundImage:bgImage forState:UIControlStateNormal];
	}
	
	[currentDirectoryButton addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:currentDirectoryButton];
	
	
	
	[buttons addObject:currentDirectoryButton];
	
	for(int i=0;i< [workbinDatasource count];i++){
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		
		btn.frame = CGRectMake(0,45+i*40, kWorkbinButtonWidth, kWorkbinButtonHeight);
		
		btn.tag = i;
		
		[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
		//		[btn setTitleColor:[UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[btn setTitle:[[workbinDatasource objectAtIndex:i] valueForKey:@"FolderName"] forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont systemFontOfSize:16];
		
		[btn addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
		[buttons addObject:btn];
		
	}	
}

- (void)removeAllButtons{
	while ([buttons count]) {
		[[buttons lastObject] removeFromSuperview];
		[buttons removeLastObject];
	}
	
}

- (void)btnClicked:(id)sender{
	if ([sender tag] == -1) {
		workbinDatasource = [[self stackPop] retain];
		selectedFolderID = 0;
		[self redrawButtons];
	}else {
		selectedFolderID = [sender tag];
	}
	[table reloadData];
	
}

- (void)closeClicked:(id)sender{
	[[sender superview] removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
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
	
	[stack release];
	[supportedExtOfFiles release];
    [super dealloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	if ([indexPath row] >= [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count]) {
		int filesCount = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count];
		//display folders
		cell.textLabel.text = [[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Folders"] objectAtIndex:[indexPath row]-filesCount] valueForKey:@"FolderName"];
		//		cell.textLabel.textColor = [UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0] ;
		cell.detailTextLabel.text = @"Folder";
		
	} else {
		//display files
		cell.textLabel.text = [[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] objectAtIndex:[indexPath row]] valueForKey:@"FileName"];
		//		cell.textLabel.textColor = [UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0];
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		cell.detailTextLabel.text = [[[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] objectAtIndex:[indexPath row]] valueForKey:@"FileName"] pathExtension];
		
	}
	
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int returnRow = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count] + [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Folders"] count] ;
	return returnRow;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//	NSLog(@"row:%d", [indexPath row]);
	//	NSLog(@"data%d", [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count]);
	if ([indexPath row] >= [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count]) {
		
		int previousDirectoryFilesCount = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count];
		
		currentDirectoryName = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"FolderName"] retain];
		[self stackPush:workbinDatasource];
		workbinDatasource = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Folders"] retain];
		
		selectedFolderID = [indexPath row] - previousDirectoryFilesCount ;
		
		[table reloadData];
		[self redrawButtons];
		return;
	}	
	
	NSArray *file = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] objectAtIndex:[indexPath row]];
	
	if (![supportedExtOfFiles containsObject:[[file valueForKey:@"FileName"] pathExtension]]) {
		[[[[UIAlertView alloc] initWithTitle:@"File not supported" 
								   message:[NSString stringWithFormat:@".%@ is not supported.", [[file valueForKey:@"FileName"] pathExtension]] 
								  delegate:nil 
						 cancelButtonTitle:@"Ok" 
						 otherButtonTitles:nil] autorelease] show];
		return;
	}
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	spinner.center = CGPointMake(1024/2, 748/2);
	
	[spinner startAnimating];
	[self.view addSubview:spinner];
	
	ModulesWorkbinWebview *webVC = [[ModulesWorkbinWebview alloc] initWithRequest:[[IVLE instance] workbinGetFile:[file valueForKey:@"ID"] withExtension:[[file valueForKey:@"FileName"] pathExtension]]];
	
	[spinner removeFromSuperview];
	
	[spinner release];
	
	webVC.wantsFullScreenLayout = YES;
	webVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	webVC.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:webVC animated:YES];
}

- (void)stackPush:(NSArray*)arrayData{
	[stack addObject:arrayData];
}

- (NSArray*)stackPop{
	if ([stack count] == 0) {
		NSAssert(0, @"stack is 0");
	}
	NSArray* returnStack = [NSArray arrayWithArray:[stack lastObject]];
	[stack removeLastObject];
	
	return returnStack;
}



@end
