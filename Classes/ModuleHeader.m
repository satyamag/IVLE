    //
//  ModuleHeader.m
//  IVLE
//
//  Created by satyam agarwala on 3/30/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//  DONT DELETE THIS ONE


#import "ModuleHeader.h"
#import <QuartzCore/QuartzCore.h>

@implementation ModuleHeader

static ModuleHeader *openHeader;
static  UIImage *backgroundImage;
static UIImage *backgroundImageSelected;

@synthesize titleLabel, disclosureButton, delegate, module,open;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

-(id)initWithFrame:(CGRect)frame title:(NSString*)title module:(NSInteger)moduleNumber delegate:(id <ModuleHeaderDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    open = NO;
	
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
		
        delegate = aDelegate;        
        self.userInteractionEnabled = YES;
        
		openHeader = nil;
        backgroundImage = [UIImage imageNamed:@"cell_background.png"];
		backgroundImageSelected= [UIImage imageNamed:@"cell_background.png"];
		
        // Create and configure the title label.
        module = moduleNumber;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 50.0);
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 10.0;
        titleLabelFrame.size.width -= 45.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
		titleLabel.textColor = kWorkbinFontColor;
		
        

//        titleLabel.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        [self addSubview:titleLabel];
        
        
        // Create and configure the disclosure button.
        disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disclosureButton.frame = CGRectMake(170.0, 10.0, 30.0, 30.0);
        [disclosureButton setImage:[UIImage imageNamed:@"disclosure_indicator_closed.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"disclosure_indicator_open.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
		
		titleLabel.backgroundColor = [UIColor clearColor];
        //NSLog(@"%f",self.frame.size.height);
		self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
             
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;

    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (disclosureButton.selected) {
            if ([delegate respondsToSelector:@selector(moduleHeader:moduleOpened:)]) {
                [delegate moduleHeader:self moduleOpened:module];
				
				self.backgroundColor = [UIColor colorWithPatternImage:backgroundImageSelected];
				titleLabel.textColor = kWorkbinFontCompColor;
				
				if (openHeader) {
					openHeader.titleLabel.textColor = kWorkbinFontColor;

					openHeader.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
					
					openHeader = self;
				}
				else {
					openHeader = self;
				}

            }
        }
        else {
            if ([delegate respondsToSelector:@selector(moduleHeader:moduleClosed:)]) {
                [delegate moduleHeader:self moduleClosed:module];
				self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
				titleLabel.textColor = kWorkbinFontColor;

				openHeader = nil;
            }
        }
    }
}






@end
