//
//  ModuleList.h
//  IVLE
//
//  Created by Shyam on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface ModuleList :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * Code;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSNumber * Credit;

@end



