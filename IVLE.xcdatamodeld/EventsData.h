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

@property (nonatomic, strong) NSString * agenda;
@property (nonatomic, strong) NSString * venue;
@property (nonatomic, strong) NSString * contact;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * eventDateTime;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * eventDescription;
@property (nonatomic, strong) NSNumber * isUserEvent;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * organizer;

@end



