//
//  ModuleEvent.m
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleEvent.h"

@interface ModuleEvent (PrivateMethods)

- (BOOL)isValidString:(NSString *)aString;
- (NSDate *)convertJSONDateToNSDateForDate:(NSString *)aDateInJSON;

@end

@implementation ModuleEvent

@synthesize date, moduleDescription, eventType, ID, location, title;

- (id)init {
	
	self = [super init];
	
	if (self) {
		
	}
	
	return self;
}

- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails {
	

	if ([self isValidString:[moduleTimetableDetails objectForKey:@"Date"]]) {
		
		//date = [[NSDate alloc] init];
		date = [[self convertJSONDateToNSDateForDate:[moduleTimetableDetails objectForKey:@"Date"]] retain];
	}
	if ([self isValidString:[moduleTimetableDetails objectForKey:@"Description"]]) {
		
		moduleDescription = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"Description"]];
	}
	if ([self isValidString:[moduleTimetableDetails objectForKey:@"EventType"]]) {
		
		eventType = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"EventType"]];
	}
	if ([self isValidString:[moduleTimetableDetails objectForKey:@"ID"]]) {
		
		ID = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"ID"]];
	}
	if ([self isValidString:[moduleTimetableDetails objectForKey:@"Location"]]) {
		
		location = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"Location"]];
	}
	if ([self isValidString:[moduleTimetableDetails objectForKey:@"Title"]]) {
		
		title = [[NSString alloc] initWithString:[moduleTimetableDetails objectForKey:@"Title"]];
	}
}

#pragma mark -
#pragma mark Private methods

- (BOOL)isValidString:(NSString *)aString {
	
	if ([aString isKindOfClass:[NSNull class]] || [aString length] == 0 ) {
		
		return NO;
	}
	else {
		
		return YES;
	}
}

- (NSDate *)convertJSONDateToNSDateForDate:(NSString *)aDateInJSON {
	
	/*
	 * This will convert DateTime (.NET) object serialized as JSON by WCF to a NSDate object.
	 */
	
	// Input string is something like: "/Date(1292851800000+0100)/" where
	// 1292851800000 is milliseconds since 1970 and +0100 is the timezone
	NSString *inputString = aDateInJSON;
	
	// This will tell number of seconds to add according to your default timezone
	// Note: if you don't care about timezone changes, just delete/comment it out
	NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	
	// A range of NSMakeRange(6, 10) will generate "1292851800" from "/Date(1292851800000+0100)/"
	// as in example above. We crop additional three zeros, because "dateWithTimeIntervalSince1970:"
	// wants seconds, not milliseconds; since 1 second is equal to 1000 milliseconds, this will work.
	// Note: if you don't care about timezone changes, just chop out "dateByAddingTimeInterval:offset" part
	NSDate *convertedDate = [[NSDate dateWithTimeIntervalSince1970:
							  [[inputString substringWithRange:NSMakeRange(6, 10)] intValue]]
							 dateByAddingTimeInterval:offset];
	/*
	 // You can just stop here if all you care is a NSDate object from inputString,
	 // or see below on how to get a nice string representation from that date:
	 
	 // static is nice if you will use same formatter again and again (for example in table cells)
	 static NSDateFormatter *dateFormatter = nil;
	 if (dateFormatter == nil) {
	 dateFormatter = [[NSDateFormatter alloc] init];
	 [dateFormatter setDateStyle:NSDateFormatterShortStyle];
	 [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	 
	 // If you're okay with the default NSDateFormatterShortStyle then comment out two lines below
	 // or if you want four digit year, then this will do it:
	 NSString *fourDigitYearFormat = [[dateFormatter dateFormat]
	 stringByReplacingOccurrencesOfString:@"yy"
	 withString:@"yyyy"];
	 [dateFormatter setDateFormat:fourDigitYearFormat];
	 }
	 
	 // There you have it:
	 NSString *outputString = [dateFormatter stringFromDate:date];
	 */
	return convertedDate;
}

#pragma mark -
#pragma mark Memory handling functions

- (void)dealloc {
	
	[date release];
	[moduleDescription release];
	[eventType release];
	[ID release];
	[location release];
	[title release];
	
	[super dealloc];
}

@end
