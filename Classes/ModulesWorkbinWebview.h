//
//  ModulesWorkbinWebview.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"

#define kDebugWorkbinWebview 0

@interface ModulesWorkbinWebview : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView* web;
	NSURLRequest *request;
}

@property (nonatomic, retain) IBOutlet UIWebView *web;

/*webview init with request of the NSURLRequest
 REQUIRES:valid Request*/
 
- (id)initWithRequest:(NSURLRequest*)requestOfWorkbin;

//dismisses current webview
- (IBAction)dismissModal;
@end
