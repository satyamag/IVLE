//
//  Forum.h
//  IVLE
//
//  Created by Satyam Agarwala on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumMainThreadTable.h"
#import "ForumSubThreadTable.h"

@interface Forum : UIViewController <ForumMainThreadTableDelegate, ForumSubThreadTableDelegate, ForumPostNewDelegate> {
	
	IBOutlet UIView *mainThreadTable;
	IBOutlet UIView *subThreadTable;
	IBOutlet UIWebView *contentDisplay;
	IBOutlet UILabel *postThreadLabel;
    IBOutlet UIButton *postThreadButton;
    IBOutlet UIButton *postReplyButton;
    IBOutlet UILabel *postReplyLabel;
    IBOutlet UIImageView *postReplyImage;
    
    NSString *currentHeadingID;
    NSString *currentPostID;
    NSString *currentHeadingName;
	
}

@property (nonatomic, retain) IBOutlet UIView *mainThreadTable;
@property (nonatomic, retain) IBOutlet UIView *subThreadTable;
@property (nonatomic, retain) IBOutlet UIWebView *contentDisplay;
@property (nonatomic, retain) NSString *currentHeadingID;
@property (nonatomic, retain) NSString *currentHeadingName;
@property (nonatomic, retain) NSString *currentPostID;


- (IBAction)postNewThread:(id)sender;
@end

