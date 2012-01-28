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

@property (nonatomic, strong) IBOutlet UIView *mainThreadTable;
@property (nonatomic, strong) IBOutlet UIView *subThreadTable;
@property (nonatomic, strong) IBOutlet UIWebView *contentDisplay;
@property (nonatomic, strong) NSString *currentHeadingID;
@property (nonatomic, strong) NSString *currentHeadingName;
@property (nonatomic, strong) NSString *currentPostID;


- (IBAction)postNewThread:(id)sender;
@end

