//
//  CoreDataWorkbinObject.h
//  IVLE
//
//  Created by Shyam on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CoreDataWorkbin;

@interface CoreDataWorkbinObject :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * WorkbinObjectFileID;
@property (nonatomic, strong) NSNumber * WorkbinObjectIsFolder;
@property (nonatomic, strong) NSData * WorkbinObjectData;
@property (nonatomic, strong) NSString * WorkbinObjectFilename;
@property (nonatomic, strong) CoreDataWorkbinObject * WorkbinParent;
@property (nonatomic, strong) CoreDataWorkbin * belongsToWorkbin;
@property (nonatomic, strong) NSSet* WorkbinChild;

@end


@interface CoreDataWorkbinObject (CoreDataGeneratedAccessors)
- (void)addWorkbinChildObject:(CoreDataWorkbinObject *)value;
- (void)removeWorkbinChildObject:(CoreDataWorkbinObject *)value;
- (void)addWorkbinChild:(NSSet *)value;
- (void)removeWorkbinChild:(NSSet *)value;

@end

