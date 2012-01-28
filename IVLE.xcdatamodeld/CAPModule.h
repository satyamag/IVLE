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

@property (nonatomic, strong) NSNumber * CAPModuleMC;
@property (nonatomic, strong) NSString * CAPModuleGrade;
@property (nonatomic, strong) NSString * CAPModuleCode;
@property (nonatomic, strong) Semester * belongsToSemester;

@end



