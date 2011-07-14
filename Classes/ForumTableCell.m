    //
//  ForumTableCell.m
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumTableCell.h"


@implementation ForumTableCell

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

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	NSLog(@"Webview loading!");
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
