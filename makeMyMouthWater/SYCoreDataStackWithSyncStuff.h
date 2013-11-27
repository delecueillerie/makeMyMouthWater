//
//  SYCoreDataStackWithSyncStuff.h
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 13/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "DBCoreDataStack.h"

@interface SYCoreDataStackWithSyncStuff : DBCoreDataStack

+ (id)sharedInstance;
- (NSManagedObjectContext *)backgroundManagedObjectContext;

@end
