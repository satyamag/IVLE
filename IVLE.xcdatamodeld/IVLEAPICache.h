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

@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSString * urlWithoutAuthToken;
@property (nonatomic, strong) NSDate * date;

@end



