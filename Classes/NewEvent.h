//
//  NewEvent.h
//  IVLE
//
//  Created by Shyam on 4/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewEventDelegate

@required

- (void)userAddedEventWith:(NSString *)title Description:(NSString *)description Contact:(NSString *)contact DateTime:(NSString *)dateTime Organizer:(NSString *)organizer Price:(NSString *)price Venue:(NSString *)venue Agenda:(NSString *)agenda;
// MODIFIES:  none
// REQUIRES: self != nil
// EFFECTS:  gives the info of the event that the user has added

- (void)userCancelledAddingEvents;
// MODIFIES:  none
// REQUIRES: self != nil
// EFFECTS:  called when user has cancelled adding events


@end


@interface NewEvent : UIViewController {

	IBOutlet UIBarButtonItem *done;
	IBOutlet UIBarButtonItem *cancel;
	
	id <NewEventDelegate> delegate;
	
	IBOutlet UITextField *eventTitle, *contact, *dateTime, *organizer, *price, *venue, *agenda;
	IBOutlet UITextView *description;
}

@property (nonatomic, assign) id <NewEventDelegate> delegate;

- (IBAction)doneButtonPressed;
// MODIFIES:  none
// REQUIRES: self != nil
// EFFECTS:  creates and adds a new event to the server

- (IBAction)cancelButtonPressed;
// MODIFIES:  self
// REQUIRES: self != nil
// EFFECTS:  cancels the event going to be added to the server


@end
