//
//  CoreDataWorkbinObject.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
@property (nonatomic, retain) CoreDataWorkbinObject * WorkbinChild;

@end



