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

@property (nonatomic, retain) IBOutlet UIButton *cellButtonRight;
@property (nonatomic, retain) IBOutlet UIButton *cellButtonLeft;

/*Set button label for left button
 text: button label*/

- (void)setLabelTextLeft:(NSString *)text;

/*Set button label for right button
 text: button label*/

- (void)setLabelTextRight:(NSString *)text;

/*Set button image for left button
 image: button image*/

- (void)setButtonImageLeft:(UIImage *)image;

/*Set button image for right button
 image: button image*/

- (void)setButtonImageRight:(UIImage *)image;

/*Set tag for left button
 image: button image*/

- (void)setButtonTagLeft:(NSInteger)buttonTag;

/*Set tag for right button
 image: button image*/

- (void)setButtonTagRight:(NSInteger)buttonTag;


/* Removes button label for left buton */

- (void)removeLabelLeft;

/*Removes button label for right buton */

- (void)removeLabelRight;

/*Removes left button */

- (void)removeButtonLeft;

/*Removes right button */

- (void)removeButtonRight;

/*Returns pointer for left buton */

-(UIButton*) getCellButtonLeft;

/*Returns pointer for right buton */

-(UIButton*) getCellButtonRight;

@end
