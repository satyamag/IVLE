//
//  ModulesFetcher.h
//  
//
//  Created by Shyam Sundar on 6/29/10.
//  Copyright 2010 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModulesFetcher : NSObject 
{
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSString *userID;
}

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;

- (void)setUserID:(NSString*)user;
//returns path to application document directory
- (NSString *)applicationDocumentsDirectory;

- (void)changeCoreData;
//
// Local Database Access
//

// Checks to see if any database exists on disk
- (BOOL)databaseExists;

// Returns the NSManagedObjectContext for inserting and fetching objects into the store
- (NSManagedObjectContext *)managedObjectContext;

// Returns an array of objects already in the database for the given Entity Name and Predicate
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

// Returns an NSFetchedResultsController for a given Entity Name and Predicate
- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

@end
