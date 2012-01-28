    //
//  ModulesWorkbinWebview.m
//  IVLE
//
//  Created by Lee Sing Jie on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModulesWorkbinWebview.h"


@implementation ModulesWorkbinWebview
@synthesize web;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest*)requestOfWorkbin{
	self = [super init];
	
	request = requestOfWorkbin;
	
	return self;
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Custom initialization.
	
	//self.web.scalesPageToFit = YES;
	
	//web.backgroundColor = [UIColor clearColor];
	//self.web.delegate = self;
	
	[web loadRequest:request];
	//NSLog(@"webviewvc loaded");
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;//(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	if (kDebugWorkbinWebview) {
		NSLog(@"shouldStartLoadWithRequest");
	}
	return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	if (kDebugWorkbinWebview) {
		NSLog(@"webViewDidFinishLoad");
	}
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	if (kDebugWorkbinWebview) {
		NSLog(@"webViewDidStartLoad");

	}
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	if (kDebugWorkbinWebview) {
		NSLog(@"didFailLoadWithError");
	}
}
- (IBAction)dismissModal{
	//[self remove]
	[self dismissModalViewControllerAnimated:YES];
}
@end
