//
//  ForumPostNew.h
//  IVLE
//
//  Created by Satyam Agarwala on 7/14/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumPostHeadingSelect.h"
#import "Constants.h"

@protocol ForumPostNewDelegate

-(void)postNewThreadWithHeading:(NSString *)headingName title:(NSString *)titleName body:(NSString *)postBody;
-(void)postNewReplyWithTitle:(NSString *)titleName body:(NSString *)postBody;
-(NSString*) getHeadingName;
@end


@interface ForumPostNew : UIViewController {
	
//	IBOutlet UITableView *headingTableView;
	IBOutlet UITextField *postTitle;
	IBOutlet UITextView *postBody;
	IBOutlet UILabel *heading;
    
	NSString *headingName;
	NSArray *headingList;
    
    BOOL isReply;
	
	id <ForumPostNewDelegate> __unsafe_unretained delegate;

}

//@property (nonatomic, retain) IBOutlet UITableView *headingTableView;
@property (nonatomic, strong) IBOutlet UILabel *heading;
@property (nonatomic, strong) IBOutlet UITextField *postTitle;
@property (nonatomic, strong) IBOutlet UITextView *postBody;
@property (nonatomic, strong) NSString *headingName;
@property (nonatomic, strong) NSArray *headingList;
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, unsafe_unretained) id <ForumPostNewDelegate> delegate;

@end
