//
//  SWAGIncrementalDataStore.m
//  SWAG
//
//  Created by Javier 2 on 8/26/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "SWAGIncrementalDataStore.h"
#import <AFIncrementalStore/AFIncrementalStore.h>
#import <AFIncrementalStore/AFRESTClient.h>
#import "SWAGRESTClient.h"

@implementation SWAGIncrementalDataStore

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

+ (NSManagedObjectModel *)model {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Library" withExtension:@"xcdatamodeld"]];
}

- (id <AFIncrementalStoreHTTPClient>)HTTPClient {
    return [SWAGRESTClient sharedClient];
}

+ (void)cleanLibraryWithCompletionBlock:(void (^)(BOOL success, NSDictionary *info))completionBlock
{
    [[SWAGRESTClient sharedClient] deletePath:@"clean" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"DELETE /clean succeeded");
        if (completionBlock) {
            completionBlock(YES, responseObject ? @{@"responseObject": responseObject} : nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(NO, @{@"error": error});
        } else {
            [NSException raise:@"Clean failed" format:@"Operation: %@, Error: %@", operation, error];
        }
    }];
}
+ (AFNetworkReachabilityStatus)reachabilityStatus
{
    return [[SWAGRESTClient sharedClient] networkReachabilityStatus];
}
@end
