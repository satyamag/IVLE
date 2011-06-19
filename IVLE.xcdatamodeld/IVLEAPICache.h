//
//  IVLEAPICache.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface IVLEAPICache :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * urlWithoutAuthToken;
@property (nonatomic, retain) NSDate * date;

@end



