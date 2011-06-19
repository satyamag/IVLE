//
//  IVLETopBar.h
//  IVLE
//
//  Created by satyam agarwala on 4/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "Constants.h"
#import "IVLESideBar.h"

@interface IVLETopBar : UIViewController {
	

	IBOutlet  UILabel *pageTitle;
	NSArray *buttons;

}

@property (nonatomic,retain) IBOutlet UILabel *pageTitle;

/* Logs out the user */

-(IBAction) logoutPressed;


@end
