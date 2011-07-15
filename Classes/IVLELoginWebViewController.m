//
//  IVLELoginViewController.m
//  IVLELogin
//
//  Created by Yasmin Musthafa on 5/27/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IVLELoginWebViewController.h"

@implementation IVLELoginWebViewController

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];

	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

	NSString *redirectUrlString = @"http://ivle.nus.edu.sg/api/login/login_result.ashx";
	NSString *authFormatString = @"https://ivle.nus.edu.sg/api/login/?apikey=%@";

	 NSString *urlString = [NSString stringWithFormat:authFormatString, kAPIKey, redirectUrlString];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
	[webView loadRequest:request];	   

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
    NSString *urlString = request.URL.absoluteString;
	
    [self checkForAccessToken:urlString];  	

    return TRUE;
}


-(void)checkForAccessToken:(NSString *)urlString {

	NSError *error;
	IVLE *ivleInstance = [IVLE instance];	

	NSRegularExpression *regex = [NSRegularExpression 
								  regularExpressionWithPattern:@"r=(.*)" 
								  options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = 
		[regex firstMatchInString:urlString 
						  options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *success = [urlString substringWithRange:accessTokenRange];
            success = [success 
						   stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
						
			if ([success isEqualToString:@"0"]) {
				NSURL *responseURL = [NSURL URLWithString:urlString];

				NSString *token = [NSString stringWithContentsOfURL:responseURL 
														   encoding:NSASCIIStringEncoding
															  error:&error];
				
                [ivleInstance setAuthToken:token];
                
				//save token to file
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *path = [documentsDirectory stringByAppendingPathComponent:@"authToken.txt"];
				NSString *string = [IVLE instance].authenticationToken;
				BOOL ok = [string writeToFile:path atomically:YES
									 encoding:NSUTF8StringEncoding error:&error];
				if (!ok) {
					// an error occurred
					NSLog(@"Error writing file at %@\n%@",
						  path, [error localizedFailureReason]);
				}
                
                [[ModulesFetcher sharedInstance] setUserID:[ivleInstance getAndSetUserName]];
                [self dismissModalViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetupHomePageComponents object:nil];
			}        
        }
	}
}

- (void)dealloc {
    self.webView = nil;
    [super dealloc];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
