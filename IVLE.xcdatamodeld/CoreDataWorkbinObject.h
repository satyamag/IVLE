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

@property (nonatomic, retain) NSString * WorkbinObjectFileID;
@property (nonatomic, retain) NSNumber * WorkbinObjectIsFolder;
@property (nonatomic, retain) NSData * WorkbinObjectData;
@property (nonatomic, retain) NSString * WorkbinObjectFilename;
@property (nonatomic, retain) CoreDataWorkbinObject * WorkbinParent;
@property (nonatomic, retain) CoreDataWorkbin * belongsToWorkbin;
@property (nonatomic, retain) NSSet* WorkbinChild;

@end


@interface CoreDataWorkbinObject (CoreDataGeneratedAccessors)
- (void)addWorkbinChildObject:(CoreDataWorkbinObject *)value;
- (void)removeWorkbinChildObject:(CoreDataWorkbinObject *)value;
- (void)addWorkbinChild:(NSSet *)value;
- (void)removeWorkbinChild:(NSSet *)value;

@end

