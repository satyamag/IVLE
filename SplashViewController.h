//
//  SplashScreen.h
//  IVLE
//
//  Created by satyam agarwala on 4/10/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SplashViewController : UIViewController {
	
	NSTimer *timer;
	UIImageView *splashImageView;

}

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UIImageView *splashImageView;


@end
