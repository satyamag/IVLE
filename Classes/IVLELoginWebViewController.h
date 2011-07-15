//
//  IVLELoginViewController.h
//  IVLELogin
//
//  Created by Yasmin Musthafa on 5/27/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "IVLE.h"

@interface IVLELoginWebViewController : UIViewController <UIWebViewDelegate>{
	
	UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

-(void)checkForAccessToken:(NSString *)urlString;



@end

