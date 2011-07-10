//
//  Webcast.h
//  IVLE
//
//  Created by mac on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IVLE.h"

@interface Webcast : NSObject {

}

// MODIFIES:  none
// REQUIRES: valid courseID
// EFFECTS:  returns a dictionary of webcasts for particular module
- (NSDictionary *)getWebcastsForModule:(NSString *)courseID;

// MODIFIES:  none
// REQUIRES: valid courseID and mediaID
// EFFECTS:  returns URL of the webcast to be played (Note: play url by creating a MPMoviePLayer object)
- (NSURL *)getWebcastVideoForModule:(NSString *)courseID AndMediaID:(NSString *)mediaID;

@end
