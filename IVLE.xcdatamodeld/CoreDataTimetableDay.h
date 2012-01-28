//
//  CoreDataTimetableDay.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CoreDataTimetable;
@class CoreDataTimetableClassInfo;

@interface CoreDataTimetableDay :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * day;
@property (nonatomic, strong) CoreDataTimetable * belongsToTimetable;
@property (nonatomic, strong) NSSet* TimetableClassInfo;

@end


@interface CoreDataTimetableDay (CoreDataGeneratedAccessors)
- (void)addTimetableClassInfoObject:(CoreDataTimetableClassInfo *)value;
- (void)removeTimetableClassInfoObject:(CoreDataTimetableClassInfo *)value;
- (void)addTimetableClassInfo:(NSSet *)value;
- (void)removeTimetableClassInfo:(NSSet *)value;

@end

