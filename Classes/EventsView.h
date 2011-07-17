//
//  EventsView.h
//  IVLE
//
//  Created by Shyam on 4/8/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TapkuLibrary.h"

#define kLabelXInset 20

@protocol EventsViewDelegate

@required

- (void)setZoomForEventView:(UIView *)aView;
// MODIFIES:  self.view
// REQUIRES: self != nil
// EFFECTS:  sets the view size for the view

- (void)setEventsForZoomedView;
// MODIFIES:  self
// REQUIRES: self != nil
// EFFECTS:  sets any attributes related to the view
			//when the view is zoomed

- (void)setEventsForNormalView;
// MODIFIES:  self
// REQUIRES: self != nil
// EFFECTS:  sets any attributes related to the view
			//when the view in not zoomed

@end


@interface EventsView : UIViewController {

	UILabel *eventTitle, *organization, *agenda, *contact, *dateTime, *price, *venue;
	
	//UILabel *eventTitle, *createdDate, *expiryDate, *ID, *URL, *isRead, *creatorName, *creatorGUID, *creatorID, *creatorEmail;
	
	UIWebView *description;
	NSDictionary *event;
	BOOL viewZoomed;
	CGRect defaultFrame;
	id <EventsViewDelegate> delegate;
}

@property (nonatomic, retain) UILabel *eventTitle;
@property (nonatomic, retain) UILabel *organization;

@property (nonatomic, assign) id <EventsViewDelegate> delegate;

- (id)initWithEvent:(NSDictionary *)anEvent;
// MODIFIES:  self
// REQUIRES: none
// EFFECTS:  returns a new instance of eventView for the given event

@end
