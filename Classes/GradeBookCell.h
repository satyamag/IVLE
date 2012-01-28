//
//  GradeBookCell.h
//  IVLE
//
//  Created by satyam agarwala on 7/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GradeBookCell : UITableViewCell {
    
	IBOutlet UILabel *averageMedianMarks,  *highestLowest, *itemName, *marksObtained, *maxMarks, *percentile, *remark;
}

@property (nonatomic, strong) UILabel *averageMedianMarks;
@property (nonatomic, strong) UILabel *highestLowest;
@property (nonatomic, strong) UILabel *itemName;
@property (nonatomic, strong) UILabel *marksObtained;
@property (nonatomic, strong) UILabel *maxMarks;
@property (nonatomic, strong) UILabel *percentile;
@property (nonatomic, strong) UILabel *remark;

@end
