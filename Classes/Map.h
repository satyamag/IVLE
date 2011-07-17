//
//  Map.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IVLE.h"
#import "NewEvent.h"

#define kMapNUSLatitude 1.297809
#define kMapNUSLongitude 103.777488
#define kMapNUSSpan 0.008
#define kMapPopOverWidth 400
#define kMapPopOverHeight 370

@interface Map : UIViewController <MKMapViewDelegate, NewEventDelegate, UIPopoverControllerDelegate> {
	IBOutlet MKMapView *mapView;
	UIPopoverController *popAddEvents;
	MKPointAnnotation *annotationLastAdded;
	BOOL addMode;
	IBOutlet UIButton *closeButton;
	
}
- (id)initWithAddEventMode:(BOOL)addEventMode;
- (IBAction)closeModal;
@end
