//
//  CoreDataTimetable.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CoreDataTimetableDay;

@interface CoreDataTimetable :  NSManagedObject  
{
}

@property (nonatomic, strong) NSSet* TimetableDay;

@end


@interface CoreDataTimetable (CoreDataGeneratedAccessors)
- (void)addTimetableDayObject:(CoreDataTimetableDay *)value;
- (void)removeTimetableDayObject:(CoreDataTimetableDay *)value;
- (void)addTimetableDay:(NSSet *)value;
- (void)removeTimetableDay:(NSSet *)value;

@end

