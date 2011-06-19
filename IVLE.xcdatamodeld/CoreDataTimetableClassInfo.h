//
//  CoreDataTimetableClassInfo.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CoreDataTimetableDay;

@interface CoreDataTimetableClassInfo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * moduleCode;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * classType;
@property (nonatomic, retain) NSString * classLocation;
@property (nonatomic, retain) NSString * eventIdentifier;
@property (nonatomic, retain) CoreDataTimetableDay * belongsToTimetableDay;


@end



