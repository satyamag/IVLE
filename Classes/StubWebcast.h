//
//  StubWebcast.h
//  IVLE
//
//  Created by mac on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StubWebcast : NSObject {

}

- (NSDictionary *)getWebcastsForModule:(NSString *)courseID;

- (void)getWebcastVideoForModule:(NSString *)courseID AndMediaID:(NSString *)mediaID;

@end
