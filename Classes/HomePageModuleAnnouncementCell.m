//
//  HomePageModuleAnnouncementCell.m
//  IVLE
//
//  Created by satyam agarwala on 4/15/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "HomePageModuleAnnouncementCell.h"


@implementation HomePageModuleAnnouncementCell

@synthesize titleText;
@synthesize meta;
@synthesize finishedLoading;
@synthesize descriptionText;
@synthesize backgroundImage;
@synthesize readIndicator;

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


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
	CGRect frame;
	frame = webView.frame;
	frame.size.height = [output floatValue]+15;
	
	webView.frame = frame;
	self.finishedLoading = YES;
}

@end
