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

@property (nonatomic, retain) UILabel *averageMedianMarks;
@property (nonatomic, retain) UILabel *highestLowest;
@property (nonatomic, retain) UILabel *itemName;
@property (nonatomic, retain) UILabel *marksObtained;
@property (nonatomic, retain) UILabel *maxMarks;
@property (nonatomic, retain) UILabel *percentile;
@property (nonatomic, retain) UILabel *remark;

@end
