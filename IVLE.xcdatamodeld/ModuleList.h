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

@property (nonatomic, retain) NSString * Code;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * Credit;

@end



