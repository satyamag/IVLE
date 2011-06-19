//
//  CAPModule.h
//  Demo
//
//  Created by Shyam on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Semester;

@interface CAPModule :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * CAPModuleMC;
@property (nonatomic, retain) NSString * CAPModuleGrade;
@property (nonatomic, retain) NSString * CAPModuleCode;
@property (nonatomic, retain) Semester * belongsToSemester;

@end



