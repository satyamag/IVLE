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

@property (nonatomic, strong) NSString *courseID;
@property (nonatomic, strong) NSString *academicYear;
@property (nonatomic, strong) NSString *dayText;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *venue;
@property (nonatomic, strong) NSString *lessonType;
@property (nonatomic, strong) NSString *weekText;
@property (nonatomic, strong) NSString *weekCode;
@property (nonatomic, strong) NSNumber *semester;
@property (nonatomic, strong) NSNumber *classNumber;
@property (nonatomic, strong) NSNumber *dayCode;
@property (nonatomic, strong) NSMutableArray *classDates;

- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;

@end
