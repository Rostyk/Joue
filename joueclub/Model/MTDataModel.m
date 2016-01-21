//
//  MTDataModel.m
//  rent
//
//  Created by Nick Savula on 6/4/15.
//  Copyright (c) 2015 Maliwan Technology. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MTDataModel.h"

#import "NSObject+PNCast.h"
#import "JCPostsItem.h"
#import "JCProduct.h"


@interface MTDataModel ()

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation MTDataModel

@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;

- (void)dealloc
{
    [self resetCoreData];
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext_ == nil)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        
        if (coordinator != nil)
        {
            managedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return managedObjectContext_;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel_ == nil)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MTDataModel" withExtension:@"momd"];
        managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator_ == nil)
    {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"maliwanData.sqlite"];
        
        NSError *error = nil;
        persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            // WORKAROUND: just removing old storage for convenience of development
            // TODO: simple development make merging of old database with new schema, when model becomes versioned
            NSLog(@"Error opening persistent store %@:%@", storeURL, error);
            switch ([error code])
            {
                case NSPersistentStoreIncompatibleSchemaError:
                case NSPersistentStoreIncompatibleVersionHashError:
                    
                    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
                    [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
                    
                    error = nil;
                    NSLog(@"Trying to recover by removing old storage..");
                    
                    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
                    if (!error && [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
                    {
                        NSLog(@"OK. New persistant storage was created.");
                        return persistentStoreCoordinator_;
                    };
                    
                    break;
            }
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return persistentStoreCoordinator_;
}

- (void)resetCoreData
{
    managedObjectContext_ = nil;
    managedObjectModel_ = nil;
    persistentStoreCoordinator_ = nil;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(NSPredicate *)predicate
{
    NSArray *results = [NSArray array];
    
    NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:newEntityName];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]]];
    
    if(predicate) {
        [request setPredicate:predicate];
    }

    NSError *error = nil;
    results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }
    
    return results;
}

 


-(NSManagedObject *)emptyNode:(Class)className
{
    if ([className respondsToSelector:@selector(entityName)])
    {
        NSEntityDescription *description = [self.managedObjectModel entitiesByName][[(id)className entityName]];
        
        return [[className alloc] initWithEntity:description
                  insertIntoManagedObjectContext:self.managedObjectContext];
    }
    
    return nil;
}

#pragma mark - public

+ (MTDataModel *)sharedDatabaseStorage
{
    static MTDataModel *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (!sharedInstance)
    {
        dispatch_once(&pred, ^{
            sharedInstance = [MTDataModel alloc];
            sharedInstance = [sharedInstance init];
        });
    }
    
    return sharedInstance;
}

- (NSArray *)getShellProducts {
    NSFetchRequest *allProducts = [[NSFetchRequest alloc] init];
    [allProducts setEntity:[NSEntityDescription entityForName:@"JCProduct" inManagedObjectContext:self.managedObjectContext]];
    [allProducts setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *products = [self.managedObjectContext executeFetchRequest:allProducts error:&error];
    
    return products;
}

- (void)removeDuplicates:(NSArray *)newItems {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"JCProduct" inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesPropertyValues:NO];
    NSArray *skus = [newItems valueForKey:@"sku"];
    [request setPredicate:[NSPredicate  predicateWithFormat:@"sku in %@", skus]];
    NSError *error = nil;
    NSArray *duplicates = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(duplicates.count > 0) {
        for (NSManagedObject *product in duplicates) {
            [self.managedObjectContext deleteObject:product];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        if(saveError) {
            NSLog(@"Save error: %@", [error localizedDescription]);
        }
    }
}

- (void)removeAllProducts {
    NSFetchRequest *allProducts = [[NSFetchRequest alloc] init];
    [allProducts setEntity:[NSEntityDescription entityForName:@"JCProduct" inManagedObjectContext:self.managedObjectContext]];
    [allProducts setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *cars = [self.managedObjectContext executeFetchRequest:allProducts error:&error];
    //error handling goes here
    for (NSManagedObject *car in cars) {
        [self.managedObjectContext deleteObject:car];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (void)removeAllPosts {
    NSFetchRequest *allPosts = [[NSFetchRequest alloc] init];
    [allPosts setEntity:[NSEntityDescription entityForName:@"JCPostsItem" inManagedObjectContext:self.managedObjectContext]];
    [allPosts setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *cars = [self.managedObjectContext executeFetchRequest:allPosts error:&error];
    //error handling goes here
    for (NSManagedObject *car in cars) {
        [self.managedObjectContext deleteObject:car];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)cleaerAll {
    
}

#pragma mark - parsing routines

- (NSArray *)parseItemListData:(NSData *)data
{
    NSMutableArray *result = nil;
    
    if (data != nil)
    {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class])
        {
            NSArray *rawProducts = jsonDict[@"products"];
            [[MTDataModel sharedDatabaseStorage] removeDuplicates:rawProducts];
            
            if ([rawProducts isKindOfClass:NSArray.class] && rawProducts.count > 0)
            {
                result = [NSMutableArray arrayWithCapacity:rawProducts.count];
                
                for (NSDictionary *rawProduct in rawProducts)
                {
                    JCProduct *product = (JCProduct *)[self emptyNode:JCProduct.class];
                    [product parseNode:rawProduct];
                    [result addObject:product];
                }
            }
        }
    }
    
    [self saveContext];
    return [result copy];
}

- (JCPostsItem *)parsePostsData:(NSData *)data {
    JCPostsItem *item = nil;
    if(data != nil) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (!error && [jsonDict isKindOfClass:NSDictionary.class])
        {
            JCPostsItem *item = (JCPostsItem *)[self emptyNode:JCPostsItem.class];
            [item parseNode:jsonDict];
        }

    }
    
    return item;
}

@end
