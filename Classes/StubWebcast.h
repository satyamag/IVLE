//
//  StubWebcast.h
//  IVLE
//
//  Created by mac on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface StubWebcast : NSObject {

}

- (NSDictionary *)getWebcastsForModule:(NSString *)courseID;

- (UIView *)getWebcastVideoForModule:(NSString *)courseID AndMediaID:(NSString *)mediaID;

@end
