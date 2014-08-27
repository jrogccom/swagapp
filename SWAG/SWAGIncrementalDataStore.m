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
#warning method incomplete
    return nil;
}

@end
