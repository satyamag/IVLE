//
//  ModulesWorkbinCell.h
//  IVLE
//
//  Created by satyam agarwala on 7/8/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModulesWorkbinCell : UITableViewCell {
    
    IBOutlet UILabel *fileName;
    IBOutlet UILabel *fileSize;
    IBOutlet UIImageView *fileType;
    
}

@property (nonatomic, retain) UILabel *fileName;
@property (nonatomic, retain) UILabel *fileSize;
@property (nonatomic, retain) UIImageView *fileType;

@end
