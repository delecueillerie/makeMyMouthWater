//
//  CategoryDrink.h
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 11/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CategoryDrink : NSManagedObject

@property (nonatomic, retain) NSString * containing;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * syncStatus;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSDate * updatedAt;

@end
