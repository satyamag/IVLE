//
//  ModuleHeaderInfo.h
//  IVLE
//
//  Created by satyam agarwala on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//  DONT DELETE THIS ONE!

#import <Foundation/Foundation.h>
#import "ModuleHeader.h"

@interface ModuleHeaderInfo : NSObject {
	BOOL open;
	ModuleHeader* headerView;
	NSString *moduleName;
	NSString *moduleID;
}

@property (assign) BOOL open;
@property (retain) ModuleHeader* headerView;
@property (assign) NSString *moduleName;
@property (assign) NSString *moduleID;

@end
