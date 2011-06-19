//
//  IVLEAPICache.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface IVLEAPICache :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * dictionary;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * urlWithoutAPIKey;

@end



