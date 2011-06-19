//
//  HomePageModuleAnnouncementCell.m
//  IVLE
//
//  Created by satyam agarwala on 4/15/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "HomePageModuleAnnouncementCell.h"


@implementation HomePageModuleAnnouncementCell

@synthesize moduleCode;
@synthesize postDate;
@synthesize postTitle;
@synthesize finishedLoading;
@synthesize descriptionText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
	self.finishedLoading = NO;
	self.descriptionText.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	NSString *output = [aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
	CGRect frame;
	frame = aWebView.frame;
	frame.size.height = [output floatValue]+15;
	
	aWebView.frame = frame;
	self.finishedLoading = YES;
}

@end
