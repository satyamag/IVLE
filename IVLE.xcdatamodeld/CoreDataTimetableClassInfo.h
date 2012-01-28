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

@property (nonatomic, strong) NSDate * startTime;
@property (nonatomic, strong) NSString * moduleCode;
@property (nonatomic, strong) NSDate * endTime;
@property (nonatomic, strong) NSString * classType;
@property (nonatomic, strong) NSString * classLocation;
@property (nonatomic, strong) NSString * eventIdentifier;
@property (nonatomic, strong) CoreDataTimetableDay * belongsToTimetableDay;


@end



