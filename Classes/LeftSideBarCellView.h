//
//  TableCellView.h
//  SimpleTable
//
//  Created by Adeem on 30/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LeftSideBarCellView : UITableViewCell {
	IBOutlet UILabel *cellTextLeft;
	IBOutlet UILabel *cellTextRight;
	IBOutlet UIButton *cellButtonLeft;
	IBOutlet UIButton *cellButtonRight;
}

- (void)setLabelTextLeft:(NSString *)text;
- (void)setLabelTextRight:(NSString *)text;
- (void)setButtonImageLeft:(UIImage *)image;
- (void)setButtonImageRight:(UIImage *)image;
- (void)removeLabelLeft;
- (void)removeLabelRight;
- (void)removeButtonLeft;
- (void)removeButtonRight;

@end
