//
//  ModuleEvent2.m
//  IVLE
//
//  Created by mac on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleEvent2.h"

@interface ModuleEvent2 (PrivateMethods)

- (NSDate *)setStartDate:(NSDate *)aDate;
- (void)setWeekOffset;

@end


@implementation ModuleEvent2

@synthesize courseID, academicYear, dayText, startTime, endTime, venue, lessonType, weekText, weekCode;
@synthesize semester, classNumber, dayCode;
@synthesize classDates;

- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate {
	
	//NSLog(@"%@", moduleTimetableDetails);
	
	courseID = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"ModuleCode"]];
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
	
	//NSLog(@"%@", [[IVLE instance] CodeTableWeekTypes]);
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed 
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first 
	// iterating date then times would go up and down based on daylight savings.
	
	startDate = [self setStartDate:startDate];
	
	NSDateComponents *dateOffset = [[NSDateComponents alloc] init];
	if ([weekCode isEqualToString:@"0"]) {
		[dateOffset setDay:7];
	}
	else if ([weekCode isEqualToString:@"1"]) {
		[dateOffset setDay:14];
	}
	else if	([weekCode isEqualToString:@"2"]) {
		[dateOffset setDay:14];
		startDate = [NSDate dateWithTimeInterval:604800 sinceDate:startDate];
	}
	
	classDates = [[NSMutableArray alloc] init];
	
	for (NSDate *currentDate = startDate; [currentDate compare:endDate] != NSOrderedDescending; currentDate = [cal dateByAddingComponents:dateOffset toDate:currentDate options:0]) {
		
		[classDates addObject:currentDate];
	}
	
	//NSLog(@"%@", classDates);
}

- (NSDate *)setStartDate:(NSDate *)aDate {
	
	if ([dayText isEqualToString:@"Monday"]) {
		return aDate;
	}
	else if ([dayText isEqualToString:@"Tuesday"]) {
		return [NSDate dateWithTimeInterval:86400 sinceDate:aDate];
	}
	else if ([dayText isEqualToString:@"Wednesday"]) {
		return [NSDate dateWithTimeInterval:86400*2 sinceDate:aDate];
	}
	else if ([dayText isEqualToString:@"Thursday"]) {
		return [NSDate dateWithTimeInterval:86400*3 sinceDate:aDate];
	}
	else if ([dayText isEqualToString:@"Friday"]) {
		return [NSDate dateWithTimeInterval:86400*4 sinceDate:aDate];
	}
	else if ([dayText isEqualToString:@"Saturday"]) {
		return [NSDate dateWithTimeInterval:86400*5 sinceDate:aDate];
	}
	else if ([dayText isEqualToString:@"Sunday"]) {
		return [NSDate dateWithTimeInterval:86400*6 sinceDate:aDate];
	}
	
	return nil;
}

- (void)setWeekOffset {
	
}


@end
