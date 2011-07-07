//
//  Map.m
//  IVLE
//
//  Created by Lee Sing Jie on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

- (id)initWithAddEventMode:(BOOL)addEventMode{
	self = [super init];
	if (self) {
		addMode = YES;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSLog(@"map viewdidload, %@", self);
    [super viewDidLoad];
	mapView.showsUserLocation = YES;
	
	MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(kMapNUSLatitude, kMapNUSLongitude);
    MKCoordinateSpan span = {kMapNUSSpan, kMapNUSSpan};
    region.span = span;
	mapView.delegate = self;
	mapView.mapType = MKMapTypeHybrid;
	
	
    [mapView setRegion:region animated:YES];
	if (addMode) {
		closeButton.alpha = 1;
		closeButton.enabled = YES;
		UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
		gesture.minimumPressDuration = 0.3;
		[mapView addGestureRecognizer:gesture];
		[gesture release];
		
	} else {
		closeButton.alpha = 0.0;
		closeButton.enabled = NO;
		NSArray * result = [[[IVLE instance] userEventsGet:24] valueForKey:@"result"];
		for (int i=0; i < [result count]; i++) {
			annotationLastAdded = [[MKPointAnnotation alloc] init];
			annotationLastAdded.coordinate = CLLocationCoordinate2DMake([[[result objectAtIndex:i] valueForKey:@"latitude"] floatValue], [[[result objectAtIndex:i] valueForKey:@"longitude"] floatValue] );
			annotationLastAdded.title = [[result objectAtIndex:i] valueForKey:@"title"];
			//	point.title = @"New Event?";
			[mapView addAnnotation:annotationLastAdded];
		}
	}
}

- (IBAction)closeModal{
	//[self dismissModalViewControllerAnimated:YES];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture{
	if ([gesture state] == UIGestureRecognizerStateBegan) {
		annotationLastAdded = [[MKPointAnnotation alloc] init];
		CLLocationCoordinate2D coord = [mapView convertPoint:[gesture locationInView:[gesture view]]
										toCoordinateFromView:mapView];
		annotationLastAdded.coordinate = coord;
		//	point.title = @"New Event?";
		[mapView addAnnotation:annotationLastAdded];
		//	[mapView selectAnnotation:point animated:FALSE];
		//[point release];
		NewEvent *eventPopOver = [[NewEvent alloc] init];
		eventPopOver.delegate = self;
		popAddEvents = [[UIPopoverController alloc] initWithContentViewController:eventPopOver];
		popAddEvents.popoverContentSize = CGSizeMake(kMapPopOverWidth, kMapPopOverHeight);
		popAddEvents.delegate = self;
		[mapView setCenterCoordinate:coord animated:YES];
		
		//	[mapView setRegion:region animated:YES];
		[popAddEvents presentPopoverFromRect:CGRectMake(CGRectGetMidX(mapView.frame),CGRectGetMidY(mapView.frame),1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
	}
}

- (void)userAddedEventWith:(NSString *)title Description:(NSString *)description Contact:(NSString *)contact DateTime:(NSString *)dateTime Organizer:(NSString *)organizer Price:(NSString *)price Venue:(NSString *)venue Agenda:(NSString *)agenda {
	
	//	NSLog(@"%@ %@ %@ %@ %@ %@ %@", title, description, contact, dateTime, organizer, price, venue, agenda);
	//call api to store event
	[[IVLE instance] userEventsCreate:organizer withContact:contact withTitle:title withDescription:description withPrice:price atLocation:[mapView centerCoordinate]];
	//[self dismissModalViewControllerAnimated:YES];
	
	//	NSLog(@"%@", [[[[[IVLE instance] userEventsGet:1] valueForKey:@"result"] lastObject] valueForKey:@"title"]);
	
	annotationLastAdded.title = [[[[[IVLE instance] userEventsGet:1] valueForKey:@"result"] lastObject] valueForKey:@"title"];
	[mapView selectAnnotation:annotationLastAdded animated:YES];
	[annotationLastAdded release];
	[popAddEvents dismissPopoverAnimated:YES];
}

- (void)userCancelledAddingEvents {
	
	[mapView removeAnnotation:annotationLastAdded];
	[popAddEvents dismissPopoverAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
	[mapView removeAnnotation:annotationLastAdded];
	[annotationLastAdded release];
	//	;
	[popoverController release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapViewLocal viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if ([annotation isKindOfClass:[MKUserLocation class]]){
		return nil;
	}
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapViewLocal dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	if(pinView == nil) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
	} else {
		pinView.annotation = annotation;
	}
	pinView.canShowCallout = YES;
	return pinView;
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
    mapView.delegate = nil;
	
	//[mapView release];
	[super dealloc];
	
}
@end
