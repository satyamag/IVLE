//
//  ForumPostNew.h
//  IVLE
//
//  Created by QIN HUAJUN on 7/14/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumPostHeadingSelect.h"
#import "Constants.h"

@protocol ForumPostNewDelegate

-(void)postNewThreadWithHeading:(NSString *)headingName title:(NSString *)titleName body:(NSString *)postBody;

-(NSString*) getHeadingName;
@end


@interface ForumPostNew : UIViewController {
	
//	IBOutlet UITableView *headingTableView;
	IBOutlet UITextField *postTitle;
	IBOutlet UITextView *postBody;
	IBOutlet UILabel *heading;
    
	NSString *headingName;
	NSArray *headingList;
	
	id <ForumPostNewDelegate> delegate;

}

//@property (nonatomic, retain) IBOutlet UITableView *headingTableView;
@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UITextField *postTitle;
@property (nonatomic, retain) IBOutlet UITextView *postBody;
@property (nonatomic, retain) NSString *headingName;
@property (nonatomic, retain) NSArray *headingList;
@property (nonatomic, assign) id <ForumPostNewDelegate> delegate;

@end
