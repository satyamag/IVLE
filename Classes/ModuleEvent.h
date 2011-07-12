//
//  ModuleEvent.h
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModuleEvent : NSObject {
	
	/*NSString *courseID, *academicYear, *dayText, *startTime, *endTime, *venue, *lessonType, *weekText, *weekCode;
	 NSNumber *semester, *classNumber, *dayCode;
	 */
	
	NSString *moduleDescription, *eventType, *ID, *location, *title;
	NSDate *date;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *moduleDescription;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *title;

/*@property (nonatomic, retain) NSString *courseID;
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
 */
//create a new module event
- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails;
- (id)init;
@end
