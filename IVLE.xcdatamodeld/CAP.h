//  CAP.h
//  IVLE
//
//  Created by Shyam on 3/28/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CAPModule;

@interface CAP :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* contains;

@end


@interface CAP (CoreDataGeneratedAccessors)
- (void)addContainsObject:(CAPModule *)value;
- (void)removeContainsObject:(CAPModule *)value;
- (void)addContains:(NSSet *)value;
- (void)removeContains:(NSSet *)value;

@end

