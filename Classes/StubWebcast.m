//
//  StubWebcast.m
//  IVLE
//
//  Created by mac on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define kCourseID @"aefeaca4-f40a-4c82-9c8e-95f92c7ed0da"
#define kMediaID @"b3bdb994-ee7c-4784-bf09-3aa4d6bb656f"
#define kWebcastLink @"http://coursecast3.nus.edu.sg/Panopto/Content/Sessions/513ee01f-1fe0-4169-a120-2640eb2879b3/6788f2a7-9ea1-41a3-9f58-ae9f5850b37a-9f189653-b17e-4786-8cc3-e02a059c9899.mp4"

#import "StubWebcast.h"


@implementation StubWebcast

- (NSDictionary *)getWebcastsForModule:(NSString *)courseID {

	NSDictionary *stubDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Webcast blah blah blah", @"some media ID key"] forKeys:[NSArray arrayWithObjects:@"Webcast name", @"Media ID"]];
	
	return stubDict;
}

- (void)getWebcastVideoForModule:(NSString *)courseID AndMediaID:(NSString *)mediaID {
	 
	 MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:webcastLink];
	 player.view.frame = CGRectMake(100, 100, 500, 300);
	 [self.view addSubview:player.view];
	 [player play];
}

@end
