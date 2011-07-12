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
- (NSDictionary *)getWebcastsForModule:(NSString *)courseID {
	
	IVLE *ivle = [IVLE instance];
	
	NSDictionary *webcastList = [[ivle webcasts:courseID withDuration:0 withTitleOnly:YES] objectForKey:@"Results"];
	
	return webcastList;
}

// MODIFIES:  none
// REQUIRES: valid courseID and mediaID
// EFFECTS:  returns URL of the webcast to be played (Note: play url by creating a MPMoviePLayer object)
- (NSURL *)getWebcastVideoForModule:(NSString *)courseID AndMediaID:(NSString *)mediaID {
	
	IVLE *ivle = [IVLE instance];
	
	NSArray *webcastList = [[ivle webcasts:courseID withDuration:0 withMediaID:mediaID withTitleOnly:NO] objectForKey:@"Results"];
	
	NSURL *webcastURL = [NSURL URLWithString:[[[[[[webcastList objectAtIndex:0] objectForKey:@"ItemGroups"] objectAtIndex:0] objectForKey:@"Files"] objectAtIndex:0] objectForKey:@"MP4"]];
	
	/*MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:webcastURL]];
	player.view.frame = CGRectMake(kWebcastWindowX, kWebcastWindowY, kWebcastWindowWidth, kWebcastWindowHeight);
	[player play];*/
	
	return webcastURL;
}

@end
