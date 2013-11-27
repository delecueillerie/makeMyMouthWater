//
//  SYHTTPRequestOperation.h
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 12/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface SYHTTPClient : NSObject
+ (SYHTTPClient *)sharedClient;
- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOpManager;
@end
