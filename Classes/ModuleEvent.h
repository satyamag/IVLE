//
//  ModuleEvent.h
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModuleEvent : NSObject {
	
	NSString *moduleDescription, *eventType, *ID, *location, *title;
	NSDate *date;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *moduleDescription;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *title;

//create a new module event
- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails;
- (id)init;
@end
