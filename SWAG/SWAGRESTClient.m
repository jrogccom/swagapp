//
//  SWAGRESTClient.m
//  SWAG
//
//  Created by Javier Osorio on 8/27/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "SWAGRESTClient.h"

static NSString * const kBaseURLString = @"http://prolific-interview.herokuapp.com/53f4eb9b001f0f000704ea35/";

@interface SWAGRESTClient ()
@property (strong, nonatomic) NSSet *entityExclusionSet;
@end
@implementation SWAGRESTClient

+ (SWAGRESTClient *)sharedClient {
    static SWAGRESTClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (NSSet *)entityExclusionSet
{
    if (!_entityExclusionSet) {
        _entityExclusionSet = [NSSet setWithArray:@[@"author", @"category", @"publisher"]];
    }
    return _entityExclusionSet;
}

#pragma - AFIncrementalClient protocol

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID inManagedObjectContext:(NSManagedObjectContext *)context
{
    return ![self.entityExclusionSet containsObject:objectID.entity.name];
}

- (NSMutableURLRequest *)requestForInsertedObject:(NSManagedObject *)insertedObject
{
    if ([self.entityExclusionSet containsObject:insertedObject.entity.name]) {
        return nil;
    } else {
        return [super requestForInsertedObject:insertedObject];
    }
}

- (NSMutableURLRequest *)requestForUpdatedObject:(NSManagedObject *)updatedObject
{
    if ([self.entityExclusionSet containsObject:updatedObject.entity.name]) {
        return nil;
    } else {
        return [super requestForUpdatedObject:updatedObject];
    }
}

- (NSMutableURLRequest *)requestForDeletedObject:(NSManagedObject *)deletedObject
{
    if ([self.entityExclusionSet containsObject:deletedObject.entity.name]) {
        return nil;
    } else {
        return [super requestForDeletedObject:deletedObject];
    }
}
//- req
@end
