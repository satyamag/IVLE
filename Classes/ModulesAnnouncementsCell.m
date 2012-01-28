//
//  ModulesAnnouncementsCell.m
//  IVLE
//
//  Created by Lee Sing Jie on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModulesAnnouncementsCell.h"


@implementation ModulesAnnouncementsCell

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



- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	//NSLog(@"Webview loading!");
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
