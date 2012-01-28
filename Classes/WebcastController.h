//
//  Webcast.h
//  IVLE
//
//  Created by mac on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "IVLE.h"
#import "WebcastsCell.h"

@interface WebcastController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *table;
	NSArray *webcasts;
	NSMutableArray *cells;
    MPMoviePlayerController *player;
}

@property (nonatomic, strong) NSMutableArray *cells;

@end
