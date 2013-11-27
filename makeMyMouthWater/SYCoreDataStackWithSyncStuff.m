//
//  SYCoreDataStackWithSyncStuff.m
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 13/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "SYCoreDataStackWithSyncStuff.h"
#import <CoreData/CoreData.h>

@interface SYCoreDataStackWithSyncStuff()
@property (strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@end


@implementation SYCoreDataStackWithSyncStuff

+ (id)sharedInstance {
    static dispatch_once_t once;
    static SYCoreDataStackWithSyncStuff *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSManagedObjectContext *masterContext = super.managedObjectContext;
    if (masterContext != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^{
            [_backgroundManagedObjectContext setParentContext:masterContext];
        }];
    }
    
    return _backgroundManagedObjectContext;
}

@end
