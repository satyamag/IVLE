//
//  ModulesWorkbin.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "CoreDataWorkbin.h"

#import "CoreDataWorkbinObject.h"
#import "ModulesFetcher.h"
#import "ModulesWorkbinWebview.h"
#import "IVLESideBar.h"

#define kDebugWorkbinData 0
#define kWorkbinButtonWidth 235
#define kWorkbinButtonHeight 40


@interface ModulesWorkbin : UIViewController {
	IBOutlet UITableView *table;
	IBOutlet UIView *directoryStructure;
	NSInteger selectedFolderID;
	NSArray *workbinDatasource;
	NSMutableArray *buttons;
	NSManagedObjectContext *managedObjectContext;

	NSString *currentDirectoryName;
	@private
	NSMutableArray *stack;
	NSSet *supportedExtOfFiles;
    
    UISplitViewController* splitVC;
}

/*drawing workbin leftnavi buttons*/
-(void)drawAllButtons;

/*remove all workbin leftnavi buttons*/
-(void)removeAllButtons;

/*remove and draw all workbin leftnavi buttons*/
-(void)redrawButtons;

/*stack push of array*/
- (void)stackPush:(NSArray*)arrayData;

/*stack pop of array*/
- (NSArray*)stackPop;
@end
