//
//  SplashScreen.h
//  IVLE
//
//  Created by satyam agarwala on 4/10/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashViewController : UIViewController {
	
	NSTimer *timer;
	UIImageView *splashImageView;
	
}

@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,retain) UIImageView *splashImageView;


@end
