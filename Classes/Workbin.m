//
//  Workbin.m
//  IVLE
//
//  Created by satyam agarwala on 7/4/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "Workbin.h"

@interface Workbin (PrivateMethods)

- (void)refreshRightScreen:(NSNotification*)notification;

@end


@implementation Workbin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        splitVC = [[UISplitViewController alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRightScreen:) name:kNotificationRefreshRightScreen object:nil];
    
    leftBar = [[IVLESideBar alloc] init];
    return self;
}

- (void)refreshRightScreen:(NSNotification*)notification{

    splitVC.viewControllers = [NSArray arrayWithObjects:leftBar,[[notification object] objectAtIndex:0], nil];

}

//-(void) viewWillAppear:(BOOL)animated {
//    
//    //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
//    
//    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
//    //-- Rotate the view
//    CGAffineTransform toLandscape = CGAffineTransformMakeRotation(90.0 * M_PI / 180.0);
//    toLandscape = CGAffineTransformTranslate(toLandscape, +90.0, +90.0 );
//    [self.view setTransform:toLandscape];
//}

- (void) viewDidLoad {

    self.view.frame = CGRectMake(0, 0, 748, 1024);
    splitVC.view.frame = CGRectMake(0, 0, 748, 1024);

	ModulesWorkbin* rightBar = [[ModulesWorkbin alloc] init];
    
    splitVC.viewControllers = [NSArray arrayWithObjects:leftBar, rightBar, nil];
	
	//load background image for split view
	UIImage *backgroundImage = [UIImage imageNamed:@"modules_workbin_3rd_column.png"];
	splitVC.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	
	[splitVC setValue:[NSNumber numberWithFloat:200.0] forKey:@"_masterColumnWidth"];
    [self.view addSubview:splitVC.view];
}

- (void)dealloc
{
    [splitVC release];
    [leftBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
