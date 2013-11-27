//
//  SYSyncEngine.m
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 13/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "SYSyncEngine.h"
#import <CoreData/CoreData.h>
#import "SYCoreDataStackWithSyncStuff.h"
#import "AFHTTPRequestOperation.h"
#import "SYHTTPClient.h"




NSString * const kSDSyncEngineInitialCompleteKey = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName = @"SDSyncEngineSyncCompleted";

@interface SYSyncEngine()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation SYSyncEngine


/*@synthesize registeredClassesToSync=_registeredClassesToSync;
@synthesize syncInProgress = _syncInProgress;*/


//Instanciation of the class
+ (SYSyncEngine *)sharedEngine {
    static SYSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SYSyncEngine alloc] init];
    });
    return sharedEngine;
}

- (void) startSync {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES];
        });
        }
}

- (void) registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if ([aClass isSubclassOfClass:[NSManagedObject class]]){
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        }
    }
}

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;

    // Create a new fetch request for the specified entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // Set the sort descriptors on the request to sort by updatedAt in descending order
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    //
    // You are only interested in 1 result so limit the request to 1
    [request setFetchLimit:1];
    [[[SYCoreDataStackWithSyncStuff sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[SYCoreDataStackWithSyncStuff sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            //
            // Set date to the fetched result
            //
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
    return date;
}


//
- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate {
    
    NSMutableArray *operations = [NSMutableArray array];
    for (NSString *className in self.registeredClassesToSync)
    {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate)
        {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        NSMutableURLRequest *request = [[SYHTTPClient sharedClient] GETRequestForAllRecordsOfClass:className updatedAfterDate:mostRecentUpdatedDate];
        AFHTTPRequestOperation *operation = [[SYHTTPClient sharedClient].requestOpManager HTTPRequestOperationWithRequest:request
                                                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                                                                                    {
                                                                                                                      if ([responseObject isKindOfClass:[NSDictionary class]])
                                                                                                                      {
                                                                                                                          //NSLog(@"Response for %@: %@", className, responseObject);
                                                                                                                          //Write JSON files to disk
                                                                                                                          [self writeJSONResponse:responseObject toDiskForClassWithName:className];
                                                                                                                      }
                                                                                                                    }
                                                                                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                                                                                                    {
                                                                                                                  NSLog(@"Request for class %@ failed with error: %@", className, error);
                                                                                                                    }];
        
        [operations addObject:operation];
    }
    
    NSArray * batchOperations = [AFURLConnectionOperation batchOfRequestOperations:operations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations)
    {
        NSLog(@"%d of %d complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations)
    {
        NSLog(@"All operations in batch complete");
        // Process JSON records into Core Data
        [self processJSONDataRecordsIntoCoreData];
    }];
    
    [[NSOperationQueue mainQueue] addOperations:batchOperations waitUntilFinished:NO];

}



////////////////////////////////////////////////////
//FILE MANAGEMENT
////////////////////////////////////////////////////

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)JSONDataRecordsDirectory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return url;
}


- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSDictionary *)response writeToFile:[fileURL path] atomically:YES]) {
        NSLog(@"Error saving response to disk, will attempt to remove NSNull values and try again.");
        // remove NSNulls and try again...
        NSArray *records = [response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [nullFreeRecord setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }
        
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES]) {
            NSLog(@"Failed all attempts to save response to disk: %@", response);
        }
    }
}

////////////////////////////////////////////////////
//SYNC MANAGEMENT
////////////////////////////////////////////////////
- (BOOL)initialSyncComplete {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSDSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSDSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//When sync operations are completed we call this method to send a notification and change the flag syncInProgress
- (void)executeSyncCompletedOperations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSDSyncEngineSyncCompletedNotificationName object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
    });
}

////////////////////////////////////////////////////
//IMPORT PROCESS INTO CORE DATA
////////////////////////////////////////////////////

- (NSDictionary *)JSONDictionaryForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortedByKey:(NSString *)key {
    NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
    NSArray *records = [JSONDictionary objectForKey:@"results"];
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                 [NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}

- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className {
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error = nil;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted) {
        NSLog(@"Unable to delete JSON Records at %@, reason: %@", url, error);
    }
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject {
    if ([key isEqualToString:@"createdAt"] || [key isEqualToString:@"updatedAt"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value objectForKey:@"__type"]) {
            NSString *dataType = [value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                [managedObject setValue:dataResponse forKey:key];
            } else {
                NSLog(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else {
        [managedObject setValue:value forKey:key];
    }
}

//Create a new record in COre Data
- (void)newManagedObjectWithClassName:(NSString *)className forRecord:(NSDictionary *)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[SYCoreDataStackWithSyncStuff sharedInstance] backgroundManagedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    [record setValue:[NSNumber numberWithInt:SDObjectSynced] forKey:@"syncStatus"];
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(NSDictionary *)record {
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}

- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(SDObjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SYCoreDataStackWithSyncStuff sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (NSArray *)managedObjectsForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SYCoreDataStackWithSyncStuff sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (objectId IN %@)", idArray];
    }
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[SYCoreDataStackWithSyncStuff sharedInstance] backgroundManagedObjectContext];
    //
    // Iterate over all registered classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        if (![self initialSyncComplete]) { // import all downloaded data to Core Data for initial sync
            //
            // If this is the initial sync then the logic is pretty simple, you will fetch the JSON data from disk
            // for the class of the current iteration and create new NSManagedObjects for each record
            //
            NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
            NSArray *records = [JSONDictionary objectForKey:@"results"];
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:className forRecord:record];
            }
        } else {
            //
            // Otherwise you need to do some more logic to determine if the record is new or has been updated.
            // First get the downloaded records from the JSON response, verify there is at least one object in
            // the data, and then fetch all records stored in Core Data whose objectId matches those from the JSON response.
            //
            NSArray *downloadedRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
            if ([downloadedRecords lastObject]) {
                //
                // Now you have a set of objects from the remote service and all of the matching objects
                // (based on objectId) from your Core Data store. Iterate over all of the downloaded records
                // from the remote service.
                //
                NSArray *storedRecords = [self managedObjectsForClass:className sortedByKey:@"objectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
                int currentIndex = 0;
                //
                // If the number of records in your Core Data store is less than the currentIndex, you know that
                // you have a potential match between the downloaded records and stored records because you sorted
                // both lists by objectId, this means that an update has come in from the remote service
                //
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;
                    
                    // Make sure we don't access an index that is out of bounds as we are iterating over both collections together
                    if ([storedRecords count] > currentIndex) {
                        storedManagedObject = [storedRecords objectAtIndex:currentIndex];
                    }
                    
                    if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                        //
                        // Do a quick spot check to validate the objectIds in fact do match, if they do update the stored
                        // object with the values received from the remote service
                        //
                        [self updateManagedObject:[storedRecords objectAtIndex:currentIndex] withRecord:record];
                    } else {
                        //
                        // Otherwise you have a new object coming in from your remote service so create a new
                        // NSManagedObject to represent this remote object locally
                        //
                        [self newManagedObjectWithClassName:className forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        //
        // Once all NSManagedObjects are created in your context you can save the context to persist the objects
        // to your persistent store. In this case though you used an NSManagedObjectContext who has a parent context
        // so all changes will be pushed to the parent context
        //
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unable to save context for class %@", className);
            }
        }];
        
        //
        // You are now done with the downloaded JSON responses so you can delete them to clean up after yourself,
        // then call your -executeSyncCompletedOperations to save off your master context and set the
        // syncInProgress flag to NO
        //
        [self deleteJSONDataRecordsForClassWithName:className];
        [self executeSyncCompletedOperations];
    }
}
////////////////////////////////////////////////////
//RECORD TRANSLATION
////////////////////////////////////////////////////

- (void)initializeDateFormatter {
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString {
    [self initializeDateFormatter];
    // NSDateFormatter does not like ISO 8601 so strip the milliseconds and timezone
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-5)];
    
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date {
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-1)];
    // add milliseconds and put Z back on
    dateString = [dateString stringByAppendingFormat:@".000Z"];
    
    return dateString;
}

@end
