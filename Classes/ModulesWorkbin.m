//
//  ModulesWorkbin.m
//  IVLE
//
//  Created by Lee Sing Jie on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "ModulesWorkbin.h"
@interface ModulesWorkbin (PrivateMethods)

-(NSString*) formatterFileSize:(NSString*)fileSize;

@end

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
    
    UIImage *bgImage_2nd_column = [UIImage imageNamed:@"modules_workbin_2nd_column.png"];
    UIImage *bgImage_3rd_column = [UIImage imageNamed:@"modules_workbin_3rd_column.png"];
    
    
    buttons = [[NSMutableArray array] retain];
    [self redrawButtons];
    self.view.backgroundColor = [UIColor clearColor] ;
    directoryStructure.backgroundColor = [UIColor colorWithPatternImage:bgImage_2nd_column] ;
    table.backgroundColor = [UIColor colorWithPatternImage:bgImage_3rd_column];
    
    supportedExtOfFiles = [[NSSet setWithObjects:@"ppt", @"pptx", @"docx", @"doc", @"pdf", @"xls", @"xlsx", nil] retain];
}

- (void)redrawButtons{
	[self removeAllButtons];
	[self drawAllButtons];
}

- (void)drawAllButtons{
	
	UIButton *currentDirectoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	UIImage *bgImage_2nd_column_cell_border = [UIImage imageNamed:@"modules_workbin_2nd_column_button.png"];
	UIImage *bgImage_2nd_colum_cell_no_border = [UIImage imageNamed:@"modules_workbin_cell_no_border.png"];
	
	currentDirectoryButton.tag = -1;
	[currentDirectoryButton setTitleColor:kWorkbinFontColor forState:UIControlStateNormal];
	[currentDirectoryButton addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:currentDirectoryButton];
	
	
	
	[buttons addObject:currentDirectoryButton];
	
	for(int i=0;i< [workbinDatasource count];i++){
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		
		btn.frame = CGRectMake(1,kWorkbinButtonHeight+i*kWorkbinButtonHeight, kWorkbinButtonWidth, kWorkbinButtonHeight);
		
		btn.tag = i;
		
		[btn setBackgroundImage:bgImage_2nd_column_cell_border forState:UIControlStateNormal];
        [btn setTitleColor:kWorkbinFontColor forState:UIControlStateNormal];
        //[[btn titleLabel] setFrame: CGRectMake(205.0, btn.titleLabel.frame.origin.y, btn.titleLabel.frame.size.width,btn.titleLabel.frame.size.height)];
		[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
		[btn setTitle:[[workbinDatasource objectAtIndex:i] valueForKey:@"FolderName"] forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
		
		[btn addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
		[buttons addObject:btn];
		
	}
	
    if ([stack count] == 0 && [buttons count] == 0 ) {
		currentDirectoryButton.frame = CGRectMake(1,200, kWorkbinButtonWidth, kWorkbinButtonHeight);
		currentDirectoryButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
		currentDirectoryButton.titleLabel.alpha = 0.5;
		//		[currentDirectoryButton setTitleColor:[UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		[currentDirectoryButton setTitle:@"← Please select a module" forState:UIControlStateNormal];
		[currentDirectoryButton setBackgroundImage:bgImage_2nd_colum_cell_no_border forState:UIControlStateDisabled];
		[currentDirectoryButton setEnabled:NO];
        [UIView animateWithDuration:3.0
                              delay:3.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{currentDirectoryButton.alpha = 0.0;} completion:nil];
        
	} else{
		currentDirectoryButton.frame = CGRectMake(1,0, kWorkbinButtonWidth, kWorkbinButtonHeight);
		currentDirectoryButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        
		//		[currentDirectoryButton setTitleColor:[UIColor colorWithRed:0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		[currentDirectoryButton setTitle:currentDirectoryName forState:UIControlStateNormal];
		[currentDirectoryButton setBackgroundImage:bgImage_2nd_column_cell_border forState:UIControlStateNormal];
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

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Overriden to allow any orientation.
//    return YES;//interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
//}


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

    UIImage *bgImage_2nd_column_cell_border = [UIImage imageNamed:@"modules_workbin_2nd_column_button.png"];
	
    ModulesWorkbinCell *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ModulesWorkbinCell" 
                                                 owner:self
                                               options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:bgImage_2nd_column_cell_border];
	
    if ([indexPath row] >= [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count]) {
		int filesCount = [[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] count];
		//display folders
		cell.fileName.text = [[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Folders"] objectAtIndex:[indexPath row]-filesCount] valueForKey:@"FolderName"];
		cell.fileSize.text = @"Folder";
        cell.fileType.image = [UIImage imageNamed:@"folder.png"];
        
	} else {
		//display files
		cell.fileName.text = [[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] objectAtIndex:[indexPath row]] valueForKey:@"FileName"];
        NSString *fileSize = [[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] objectAtIndex:[indexPath row]] valueForKey:@"FileSize"];
		cell.fileSize.text = [self formatterFileSize:fileSize];
        NSString *fileType = [[[[workbinDatasource objectAtIndex:selectedFolderID] valueForKey:@"Files"] objectAtIndex:[indexPath row]] valueForKey:@"FileType"];
        cell.fileType.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", fileType]];
    
	}
    cell.fileName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    cell.fileName.textColor = kWorkbinFontColor;
    cell.fileSize.textColor = kWorkbinFontColor;
	
    return cell;
}

-(NSString*) formatterFileSize:(NSString*)fileSize {
    
    
    float floatSize =  [fileSize floatValue];
    if ([fileSize floatValue]<1023)
		return([NSString stringWithFormat:@"%i bytes",[fileSize floatValue]]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
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
