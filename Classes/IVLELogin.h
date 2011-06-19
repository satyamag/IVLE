//
//  IVLELogin.h
//  IVLE
//
//  Created by Lee Sing Jie on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"


@interface IVLELogin : UIViewController {
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
