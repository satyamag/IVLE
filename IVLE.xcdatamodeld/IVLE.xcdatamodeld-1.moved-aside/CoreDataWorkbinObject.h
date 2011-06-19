//
//  CoreDataWorkbinObject.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CoreDataWorkbinObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * WorkbinObjectFilename;
@property (nonatomic, retain) NSData * WorkbinObjectData;
@property (nonatomic, retain) NSNumber * WorkbinObjectIsFolder;
@property (nonatomic, retain) NSManagedObject * WorkbinChild;
@property (nonatomic, retain) NSManagedObject * belongsToWorkbin;
@property (nonatomic, retain) NSManagedObject * WorkbinParent;

@end



