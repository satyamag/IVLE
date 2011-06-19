//
//  IVLELogin.h
//  IVLE
//
//  Created by satyam agarwala on 4/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"

@interface IVLELoginNew : UIViewController {
	IBOutlet UITextField *nusnetID;
	IBOutlet UITextField *password;
	IBOutlet UITextField *domain;
}

@property (nonatomic, retain) UITextField *nusnetID;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITextField *domain;

- (IBAction)loginClicked;
- (IBAction)cancelClicked;

@end
