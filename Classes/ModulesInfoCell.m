//
//  ModulesInfoCell.m
//  IVLE
//
//  Created by Satyam Agarwala on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModulesInfoCell.h"


@implementation ModulesInfoCell

@synthesize titleText;
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
