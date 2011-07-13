//
//  ModuleEvent2.m
//  IVLE
//
//  Created by mac on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleEvent2.h"


@implementation ModuleEvent2

@synthesize courseID, academicYear, dayText, startTime, endTime, venue, lessonType, weekText, weekCode;
@synthesize semester, classNumber, dayCode;

- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails {
	
	NSLog(@"%@", moduleTimetableDetails);
	
	courseID = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"CourseID"]];
	academicYear = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"AcadYear"]];
	dayText = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"DayText"]];
	startTime = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"StartTime"]];
	endTime = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"EndTime"]];
	venue = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"Venue"]];
	lessonType = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"LessonType"]];
	weekText = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"WeekText"]];
	weekCode = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"WeekCode"]];
	semester = [[NSNumber alloc] initWithInt:[[moduleTimetableDetails objectForKey:@"Semester"] intValue]];
	classNumber = [[NSNumber alloc] initWithInt:[[moduleTimetableDetails objectForKey:@"ClassNo"] intValue]];
	dayCode = [[NSNumber alloc] initWithInt:[[moduleTimetableDetails objectForKey:@"DayCode"] intValue]];
}

- (void)dealloc {
	
	[courseID release];
	[academicYear release];
	[dayText release];
	[startTime release];
	[endTime release];
	[venue release];
	[lessonType release];
	[weekCode release];
	[semester release];
	[classNumber release];
	[dayCode release];
	
	[super dealloc];
}

@end
