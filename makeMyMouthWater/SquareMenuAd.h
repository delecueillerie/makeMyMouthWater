//
//  SquareMenuAd.h
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 11/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SquareMenuAd : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSData * media;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSDate * updatedAt;

@end
