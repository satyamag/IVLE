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

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *moduleDescription;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *title;

//create a new module event
- (void)createModuleEvent:(NSDictionary *)moduleTimetableDetails;
- (id)init;
@end
