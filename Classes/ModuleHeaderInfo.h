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
	NSString *__unsafe_unretained moduleName;
	NSString *__unsafe_unretained moduleID;
}

@property (assign) BOOL open;
@property (strong) ModuleHeader* headerView;
@property (unsafe_unretained) NSString *moduleName;
@property (unsafe_unretained) NSString *moduleID;

@end
