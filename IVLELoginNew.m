//
//  IVLELogin.m
//  IVLE
//
//  Created by satyam agarwala.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLELoginNew.h"

#define kNotificationSetWelcomeMessage @"setWelcomeMessage"
#define kNotificationSetPageTitle @"setPageTitle"


@implementation IVLELoginNew

@synthesize nusnetID;
@synthesize password;
@synthesize domain;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		UIImage *blackboardImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:blackboardImage]];
    }
    return self;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userLogin.plist"];
	 
	 NSMutableDictionary *plistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
     
	 if(plistDictionary==nil ){
		 //continue loading;
	 }
	 else {
		 domain.text = [plistDictionary objectForKey:@"domain"];
		 nusnetID.text = [plistDictionary objectForKey:@"nusnet"];
		 password.text = [plistDictionary objectForKey:@"password"];
		 [self performSelector:@selector(loginClicked) withObject:nil afterDelay:0];
	 }

	 
 }
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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


- (void)dealloc {
    [super dealloc];
}

- (IBAction)loginClicked{
	
	//Logs in the user
/*	
	NSString *domainTrimmed = [domain.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *nusnetIDTrimmed = [nusnetID.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *passwordTrimmed = [password.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	IVLE *ivleInstance = [IVLE instance];
	
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(1024/2-spinner.frame.size.width/2, 768/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
	[spinner startAnimating];
	[[self.view superview] addSubview:spinner];
	self.view.userInteractionEnabled = NO;
	
	[[ModulesFetcher sharedInstance] setUserID:nusnetIDTrimmed];
	[ivleInstance login:nusnetIDTrimmed withPassword:passwordTrimmed withDomain:domainTrimmed];
	self.view.userInteractionEnabled = YES;
	
	[spinner removeFromSuperview];
	[spinner release];
	
	
	NSString *authToken = [ivleInstance authenticationToken];
	
	
	if (authToken == nil || [authToken isEqualToString:@""]) {
		[[ModulesFetcher sharedInstance] setUserID:nil];
		[[[[UIAlertView alloc] initWithTitle:@"Login Unsuccessful" message:@"Please check your credentials and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		password.text = @"";
	}
	else {
		NSMutableArray *login = [NSMutableArray array];
		NSMutableArray *keys = [NSMutableArray array];
		
		[login addObject:nusnetIDTrimmed];
		[keys addObject:@"nusnet"];
		[login addObject:passwordTrimmed];
		[keys addObject:@"password"];
		[login addObject:domainTrimmed];
		[keys addObject:@"domain"];
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjects:login forKeys:keys];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userLogin.plist"];
		// write plist to disk
		[dict writeToFile:path atomically:YES];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetWelcomeMessage object:[[NSString stringWithString:@"Welcome "] stringByAppendingString:[ivleInstance userId]]];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReLoginSuccessful object:nil];
		[self dismissModalViewControllerAnimated:YES];
	}

*/	
	
}


- (IBAction)cancelClicked{
	[[[[UIAlertView alloc] initWithTitle:@"Offline" message:@"Working in offline mode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	[self dismissModalViewControllerAnimated:YES];
}

@end
