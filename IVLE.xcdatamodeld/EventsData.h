//
//  EventsData.h
//  IVLE
//
//  Created by Shyam on 4/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface EventsData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * agenda;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * eventDateTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSNumber * isUserEvent;
@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * organizer;

@end



