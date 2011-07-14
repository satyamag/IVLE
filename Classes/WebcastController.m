//
//  Webcast.m
//  IVLE
//
//  Created by mac on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebcastController.h"

#define kWebcastWindowX 100
#define kWebcastWindowY 100 
#define kWebcastWindowWidth 500
#define kWebcastWindowHeight 300

@implementation WebcastController

// MODIFIES:  none
// REQUIRES: valid courseID
// EFFECTS:  returns a dictionary of webcasts for particular module

@synthesize cells;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
		
        
		webcasts = [[[[[[[IVLE instance] webcasts:[IVLE instance].selectedCourseID withDuration:0 withTitleOnly:NO] objectForKey:@"Results"] objectAtIndex:0] objectForKey:@"ItemGroups"] objectAtIndex:0] objectForKey:@"Files"];
        
		UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
		//NSLog(@"%@", webcasts);
        
		self.cells = [NSMutableArray array];
		
		for (int i=0; i<[webcasts count]; i++) {
			
			WebcastsCell *cell;
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WebcastsCell" 
														 owner:self
													   options:nil];
			cell = [nib objectAtIndex:0];
			
            MPMoviePlayerController *player_meta = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[[webcasts objectAtIndex:i] valueForKeyPath:@"MP4"]]];
            [player_meta setShouldAutoplay:NO];
            [player_meta stop];
            
            NSRange range = NSMakeRange (6, 10);
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[[webcasts objectAtIndex:i] valueForKey:@"CreateDate"] substringWithRange:range] intValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:kCFDateFormatterMediumStyle];
            
            
            
            
			cell.webcastTitle.text = [[webcasts objectAtIndex:i] valueForKeyPath:@"FileTitle"];
			cell.webcastDate.text = [formatter stringFromDate:date];
            
            NSDate *date_movie = [NSDate dateWithTimeIntervalSinceNow:[player duration]];
            [formatter setDateFormat:@"HH:mm:ss"];
			cell.webcastDuration.text = [formatter stringFromDate:date_movie];
            NSLog(@"%f", [player duration]);
			
            cell.thumbnail.image = [player_meta thumbnailImageAtTime:300.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [cell.thumbnail.layer setCornerRadius:5.0];
            [cell.thumbnail.layer  setBorderWidth:1.0];
            [cell.thumbnail.layer  setMasksToBounds:YES];
            
            [cell.thumbnail.layer  setBorderColor:[[UIColor blackColor] CGColor]];
            [cell.thumbnail.layer  setBorderWidth:1.0];
            
			[self.cells addObject:cell];
            
            [player_meta release];
            [formatter release];
		}
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
    }
    return self;
}



#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	tableView.backgroundColor = [UIColor clearColor];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ([webcasts count]);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.cells objectAtIndex:[indexPath row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *videoURL = [[webcasts objectAtIndex:[indexPath row]] valueForKeyPath:@"MP4"];
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoURL]] ;
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(movieFinishedCallback:) 
     name:MPMoviePlayerDidExitFullscreenNotification
     object:player];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(movieExitedFullScreen:) 
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    [self.view addSubview:player.view];
    [player setFullscreen:YES animated:YES];
    [player play]; 
    [cell setSelected:NO];
    
    
}

- (void) movieFinishedCallback:(NSNotification*) aNotification 
{
    
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player]; 
    
    [player.view removeFromSuperview];  
}

-(void) movieExitedFullScreen:(NSNotification*) aNotification 
{
    
    
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerDidExitFullscreenNotification
     object:player]; 
    
    [player.view removeFromSuperview];
}

//
//
//- (NSDictionary *)getWebcastsForModule:(NSString *)courseID {
//	
//	IVLE *ivle = [IVLE instance];
//	
//	NSDictionary *webcastList = [[ivle webcasts:courseID withDuration:0 withTitleOnly:YES] objectForKey:@"Results"];
//	
//	return webcastList;
//}
//
//// MODIFIES:  none
//// REQUIRES: valid courseID and mediaID
//// EFFECTS:  returns URL of the webcast to be played (Note: play url by creating a MPMoviePLayer object)
//- (NSURL *)getWebcastVideoForModule:(NSString *)courseID AndMediaID:(NSString *)mediaID {
//	
//	IVLE *ivle = [IVLE instance];
//	
//	NSArray *webcastList = [[ivle webcasts:courseID withDuration:0 withMediaID:mediaID withTitleOnly:NO] objectForKey:@"Results"];
//	
//	NSURL *webcastURL = [NSURL URLWithString:[[[[[[webcastList objectAtIndex:0] objectForKey:@"ItemGroups"] objectAtIndex:0] objectForKey:@"Files"] objectAtIndex:0] objectForKey:@"MP4"]];
//	
//	/*MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:webcastURL]];
//	player.view.frame = CGRectMake(kWebcastWindowX, kWebcastWindowY, kWebcastWindowWidth, kWebcastWindowHeight);
//	[player play];*/
//	
//	return webcastURL;
//}

@end
