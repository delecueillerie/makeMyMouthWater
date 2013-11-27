//
//  SYHTTPRequestOperation.m
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 12/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "SYHTTPClient.h"
#import <Parse/Parse.h>

#define kAPIBaseURLString @"https://api.parse.com/1/"
#define kAPIApplicationId @"C2XRFUHGSMgrAK1Cd3qa1DQkgDiqR4f0T2bMlu5l"
#define kAPIRestKey @"SDOjQgF3s7ACDyACeXiGxbKzx3zYbcm42Mn5vjy4"

@interface SYHTTPClient()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

@end

@implementation SYHTTPClient

////////////////////////////////////////////////////
//LAZY INSTANTIATION
////////////////////////////////////////////////////
- (AFHTTPRequestOperationManager *) requestOpManager {
if(!_requestOpManager) _requestOpManager=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:[[NSURL alloc]initWithString:kAPIBaseURLString]];
    
    _requestOpManager.requestSerializer = self.requestSerializer;
    _requestOpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    return _requestOpManager;
}

- (AFHTTPRequestSerializer *) requestSerializer {
    if (!_requestSerializer) _requestSerializer = [AFHTTPRequestSerializer serializer];
    [_requestSerializer setValue:kAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [_requestSerializer setValue:kAPIRestKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    return _requestSerializer;
}


+ (SYHTTPClient *) sharedClient {
    static SYHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SYHTTPClient alloc] init];
    });
    return sharedClient;
}

- (AFHTTPRequestOperationManager *)requestOpManagerWithBaseURL:(NSURL *)url {

    [self.requestOpManager setRequestSerializer:self.requestSerializer];
    return self.requestOpManager;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    NSMutableString *URL = [NSMutableString stringWithString:kAPIBaseURLString ];
    [URL appendString:[NSString stringWithFormat:@"classes/%@", className]];

    request = [self.requestSerializer requestWithMethod:@"GET" URLString:URL parameters:parameters];
               
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *parameters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *jsonString = [NSString stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",[dateFormatter stringFromDate:updatedDate]];
        parameters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }
    request = [self GETRequestForClass:className parameters:parameters];

    return request;
}
@end
