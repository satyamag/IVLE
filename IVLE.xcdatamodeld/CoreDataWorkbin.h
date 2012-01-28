//
//  CoreDataWorkbin.h
//  IVLE
//
//  Created by Shyam on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CoreDataWorkbinObject;

@interface CoreDataWorkbin :  NSManagedObject  
{
}

@property (nonatomic, strong) NSSet* contains;
@property (nonatomic, strong) NSManagedObject * belongsToModule;

@end


@interface CoreDataWorkbin (CoreDataGeneratedAccessors)
- (void)addContainsObject:(CoreDataWorkbinObject *)value;
- (void)removeContainsObject:(CoreDataWorkbinObject *)value;
- (void)addContains:(NSSet *)value;
- (void)removeContains:(NSSet *)value;

@end

