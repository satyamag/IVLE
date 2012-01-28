//
//  EventsView.m
//  IVLE
//
//  Created by Shyam on 4/8/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "EventsView.h"

@interface EventsView (PrivateMethods)

- (void)eventTapped:(UIGestureRecognizer *)gesture;
- (void)setupLabels;
- (BOOL)isValidString:(NSString *)aString;
- (void)addShadowToView:(UIView *)aView;
- (void)addBorderToView:(UIView *)aView;
- (void)removeShadowOfView:(UIView *)aView;
- (void)removeBorderOfView:(UIView *)aView;

@end

@implementation EventsView

@synthesize eventTitle, organization, delegate;

- (id)initWithEvent:(NSDictionary *)anEvent {
	
	self = [super init];
	
	if (self) {
		
		//setup variables
		event = anEvent;
		
		//NSLog(@"%@", event);
		
		eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 67)];
		organization = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 24)];
		description = [[UIWebView alloc] initWithFrame:CGRectMake(20, 87, 200, 113)];
		agenda = [[UILabel alloc] init];
		contact = [[UILabel alloc] init];
		dateTime = [[UILabel alloc] init];
		price = [[UILabel alloc] init];
		venue = [[UILabel alloc] init];
		
		[self setupLabels];
		
		NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
									   "<head> \n"
									   "<style type=\"text/css\"> \n"
									   "body {font-family: \"%@\"; font-size: %@;}\n"
									   "</style> \n"
									   "</head> \n"
									   "<body>%@</body> \n"
									   "</html>", @"helvetica", [NSNumber numberWithInt:25], [event objectForKey:@"Description"]];
		[description loadHTMLString:myDescriptionHTML baseURL:nil];
		//NSLog(@"%@", [event objectForKey:@"Description"]);
		[description setUserInteractionEnabled:NO];
		[description setScalesPageToFit:YES];
		[description setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
		
		[self.view addSubview:eventTitle];
		[self.view addSubview:organization];
		[self.view addSubview:description];
		
		viewZoomed = NO;
		
		//setup gestures
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventTapped:)];
		[tap setNumberOfTapsRequired:1];
		[self.view addGestureRecognizer:tap];
		
		//UI initialization
		//[self.view setBackgroundColor:[UIColor grayColor]];
	}
	
	return self;
}

-(UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height {
	
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	//if (alphaInfo == kCGImageAlphaNone)
	alphaInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self addBorderToView:[self view]];
	
}

#pragma mark -
#pragma mark Label helper functions

- (void)setupLabels {
	
	if ([self isValidString:[event objectForKey:@"Title"]]) {
		
		eventTitle.text = [event objectForKey:@"Title"];
	}
	else {
		eventTitle.text = @"";
	}
	
	
	if ([self isValidString:[event objectForKey:@"Organizer"]]) {
		
		organization.text = [event objectForKey:@"Organizer"];
	}
	else {
		organization.text = @"";
	}
	
	if ([self isValidString:[event objectForKey:@"Agenda"]]) {
		
		agenda.text = [@"Agenda: " stringByAppendingString:[event objectForKey:@"Agenda"]];
	}
	else {
		agenda.text = @"";
	}
	
	if ([self isValidString:[event objectForKey:@"Contact"]]) {
		
		contact.text = [@"Contact: " stringByAppendingString:[event objectForKey:@"Contact"]];
	}
	else {
		contact.text = @"";
	}
	
	if ([self isValidString:[event objectForKey:@"EventDateTime"]]) {
		
		dateTime.text = [@"Date & Time: " stringByAppendingString:[event objectForKey:@"EventDateTime"]];
	}
	else {
		dateTime.text = @"";
	}
	
	if ([self isValidString:[event objectForKey:@"Price"]]) {
		
		price.text = [@"Price: " stringByAppendingString:[event objectForKey:@"Price"]];
	}
	else {
		price.text = @"";
	}
	
	if ([self isValidString:[event objectForKey:@"Venue"]]) {
		
		venue.text = [@"Venue: " stringByAppendingString:[event objectForKey:@"Venue"]];
	}
	else {
		venue.text = @"";
	}
	
	NSArray *futuraFonts = [UIFont fontNamesForFamilyName:@"Futura"];
	[eventTitle setFont:[UIFont fontWithName:[futuraFonts objectAtIndex:1] size:17]];	
	[eventTitle setLineBreakMode:UILineBreakModeWordWrap];
	[eventTitle setNumberOfLines:3];
	
	NSArray *baskerville = [UIFont fontNamesForFamilyName:@"Baskerville"];
	
	[organization setFont:[UIFont fontWithName:[baskerville objectAtIndex:3] size:17]];
	[agenda setFont:[UIFont fontWithName:[baskerville objectAtIndex:3] size:17]];
	[contact setFont:[UIFont fontWithName:[baskerville objectAtIndex:3] size:17]];
	[dateTime setFont:[UIFont fontWithName:[baskerville objectAtIndex:3] size:17]];
	[price setFont:[UIFont fontWithName:[baskerville objectAtIndex:3] size:17]];
	[venue setFont:[UIFont fontWithName:[baskerville objectAtIndex:3] size:17]];
}

- (BOOL)isValidString:(NSString *)aString {
	
	if ([aString isKindOfClass:[NSNull class]] || [aString length] == 0 ) {
		
		return NO;
	}
	else {
		
		return YES;
	}
}

- (void)addShadowToView:(UIView *)aView {
	
	aView.layer.shadowColor = [UIColor blackColor].CGColor;
	aView.layer.shadowOpacity = 1.0;
	aView.layer.shadowRadius = 5.0;
	aView.layer.shadowOffset = CGSizeMake(0, 3);
	aView.clipsToBounds = NO;
}

- (void)addBorderToView:(UIView *)aView {
	
	aView.layer.borderColor = [UIColor grayColor].CGColor;
	aView.layer.borderWidth = 1.0f;
}

- (void)removeShadowOfView:(UIView *)aView {
	
	aView.layer.shadowColor = [UIColor clearColor].CGColor;
	aView.layer.shadowOpacity = 0.0f;
}

- (void)removeBorderOfView:(UIView *)aView {
	
	aView.layer.borderColor = [UIColor clearColor].CGColor;
	aView.layer.borderWidth = 0.0f;
}

#pragma mark -
#pragma mark Gesture functions

- (void)eventTapped:(UIGestureRecognizer *)gesture {
	
	//if view not zoomed, 
	if (!viewZoomed) {
		
		//set zoom to yes
		viewZoomed = YES;
		
		defaultFrame = CGRectMake(self.view.center.x, self.view.center.y, 256, 240);
		
		//bring view to front
		[[self.view superview] bringSubviewToFront:self.view];
		
		//then zoom view
		[UIView animateWithDuration:0.5 
						 animations:^{
							 
							 //NSLog(@"Before frame: %f, %f", description.frame.origin.x, description.frame.origin.y);
							 //NSLog(@"Superview frame: %f, %f", self.view.frame.origin.x, self.view.frame.origin.y);
							 [delegate setZoomForEventView:self.view];
							 //NSLog(@"Superview frame: %f, %f", self.view.frame.origin.x, self.view.frame.origin.y);
							 [delegate setEventsForZoomedView];
							 
							 //add shadow
							 [self addShadowToView:[self view]];
							 
							 //show other details
							 [self.view addSubview:agenda];
							 [self.view addSubview:contact];
							 [self.view addSubview:dateTime];
							 [self.view addSubview:price];
							 [self.view addSubview:venue]; 
							 
							 //make labels transparent
							 for (UILabel *label in self.view.subviews) {
								 
								 [label setBackgroundColor:[UIColor clearColor]];
							 }
							 
							 //set labels
							 [eventTitle setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + 20, 643, 24)];
							 [agenda setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + self.view.bounds.size.height - 164, 643, 24)];
							 [contact setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + self.view.bounds.size.height - 140, 643, 24)];
							 [dateTime setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + self.view.bounds.size.height - 116, 643, 24)];
							 [price setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + self.view.bounds.size.height - 92, 643, 24)];
							 [venue setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + self.view.bounds.size.height - 68, 643, 24)];
							 [organization setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + self.view.bounds.size.height - 44, 643, 24)];
							 //[description setFrame:CGRectMake(description.superview.frame.origin.x + 20, description.superview.frame.origin.y + 87, 200, 113)];
						 }
						 completion:^(BOOL finished) {
							 
							 [UIView animateWithDuration:0.5 
											  animations:^{
												  
												  [description setFrame:CGRectMake(kLabelXInset, self.view.bounds.origin.y + 44, self.view.bounds.size.width - 2*kLabelXInset, (self.view.bounds.origin.y + self.view.bounds.size.height - 188) - (self.view.bounds.origin.y + 44))];
												  [description setUserInteractionEnabled:YES];
												  [description setScalesPageToFit:NO];
												   //NSLog(@"After frame: %f %f", description.frame.origin.x, description.frame.origin.y);
											  } 
											  completion: ^(BOOL finished) {
												  
												  //add border to webview
												  [self addBorderToView:description];
											  }];
						 }];
	}
	else {
		
		//set zoom to NO
		viewZoomed = NO;
		
		//make view normal again
		[UIView animateWithDuration:0.5 
						 animations:^{
							 
							 [self.view setCenter:CGPointMake(defaultFrame.origin.x, defaultFrame.origin.y)];
							 [self.view setBounds:CGRectMake(0, 0, defaultFrame.size.width, defaultFrame.size.height)];
							 
							 [delegate setEventsForNormalView];
							 
							 //reset labels
							 [eventTitle setFrame:CGRectMake(20, 20, 200, 67)];
							 [agenda setFrame:CGRectZero];
							 [contact setFrame:CGRectZero];
							 [dateTime setFrame:CGRectZero];
							 [price setFrame:CGRectZero];
							 [venue setFrame:CGRectZero];
							 [organization setFrame:CGRectMake(20, 200, 200, 24)];
							 
							 [description setFrame:CGRectMake(20, 87, 200, 113)];
							 [description setUserInteractionEnabled:NO];
							 [description setScalesPageToFit:YES];
						 }
						 completion:^(BOOL finished){
							 
							 //remove other details
							 [agenda removeFromSuperview];
							 [contact removeFromSuperview];
							 [dateTime removeFromSuperview];
							 [price removeFromSuperview];
							 [venue removeFromSuperview];
						 }];
		
		//remove shadow
		[self removeShadowOfView:[self view]];
		
		//remove border to webview
		[self removeBorderOfView:description];
	}
	
}

#pragma mark -
#pragma mark Memory handling

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




@end
