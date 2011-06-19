//
//  Semester.h
//  IVLE
//
//  Created by Shyam on 3/30/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CAPModule;

@interface Semester :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * semesterNumber;
@property (nonatomic, retain) NSSet* hasModule;

@end


@interface Semester (CoreDataGeneratedAccessors)
- (void)addHasModuleObject:(CAPModule *)value;
- (void)removeHasModuleObject:(CAPModule *)value;
- (void)addHasModule:(NSSet *)value;
- (void)removeHasModule:(NSSet *)value;

@end

