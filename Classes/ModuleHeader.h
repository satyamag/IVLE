//
//  ModuleHeader.h
//  IVLE
//
//  Created by satyam agarwala on 3/30/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//  DONT DELETE THIS ONE

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol ModuleHeaderDelegate;



@interface ModuleHeader : UIView {

}


@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) NSInteger module;
@property (nonatomic, assign) id <ModuleHeaderDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title module:(NSInteger)moduleNumber delegate:(id <ModuleHeaderDelegate>)aDelegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end



/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol ModuleHeaderDelegate <NSObject>

@optional
-(void)moduleHeader:(ModuleHeader*)moduleHeader moduleOpened:(NSInteger)module;
-(void)moduleHeader:(ModuleHeader*)moduleHeader moduleClosed:(NSInteger)module;

@end



