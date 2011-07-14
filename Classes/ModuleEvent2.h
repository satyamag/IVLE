//
//  ModuleEvent2.h
//  IVLE
//
//  Created by mac on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVLE.h"

@interface ModuleEvent2 : NSObject {

	NSString *courseID, *academicYear, *dayText, *startTime, *endTime, *venue, *lessonType, *weekText, *weekCode;
	NSNumber *semester, *classNumber, *dayCode;
	NSMutableArray *classDates;
}

@property (nonatomic, retain) NSString *courseID;
@property (nonatomic, retain) NSString *academicYear;
@property (nonatomic, retain) NSString *dayText;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *venue;
@property (nonatomic, retain) NSString *lessonType;
@property (nonatomic, retain) NSString *weekText;
@property (nonatomic, retain) NSString *weekCode;
@property (nonatomic, retain) NSNumber *semester;
@property (nonatomic, retain) NSNumber *classNumber;
@property (nonatomic, retain) NSNumber *dayCode;
@property (nonatomic, retain) NSMutableArray *classDates;

- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;

@end
