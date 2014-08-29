//
//  SWAGRESTClient.m
//  SWAG
//
//  Created by Javier Osorio on 8/27/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "SWAGRESTClient.h"
#import "Book.h"

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
        _entityExclusionSet = [NSSet setWithArray:@[@"Author", @"Category", @"Publisher"]];
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

- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes ofManagedObject:(NSManagedObject *)managedObject
{
    NSMutableDictionary *mutableAttributes = (NSMutableDictionary *)[super representationOfAttributes:attributes ofManagedObject:managedObject];
    return mutableAttributes;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship forObjectWithID:(NSManagedObjectID *)objectID inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *muttableAttributes = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    return muttableAttributes;
}

- (id)representationOrArrayOfRepresentationsOfEntity:(NSEntityDescription *)entity fromResponseObject:(id)responseObject
{
    id representation = [super representationOrArrayOfRepresentationsOfEntity:entity fromResponseObject:responseObject];
    if ([self.entityExclusionSet containsObject:entity.name]) {
        return nil;
    }
    return representation;
}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    /*
    if ([entity.name isEqualToString:@"Book"]) {
        NSMutableDictionary *mRepresentation = [[NSMutableDictionary alloc] init];
        mRepresentation[@"authors"] = [NSMutableArray new];
        for (NSString *name in [representation[@"author"] componentsSeparatedByString:@", "]) {
            [mRepresentation[@"authors"] addObject:@{@"fullName": name}];
        }
        mRepresentation[@"categories"] = [NSMutableArray new];
        for (NSString *name in [representation[@"categories"] componentsSeparatedByString:@", "]) {
            [mRepresentation[@"categories"] addObject:@{@"name": name}];
        }
#warning Data curations necessary.  Publisher empty in first record.
        mRepresentation[@"publisher"] = @{@"name": representation[@"publisher"] ? representation[@"publisher"] : @"PUBLISHER_NOT_FOUND"};
        return mRepresentation;
    } else {
        return [super representationsForRelationshipsFromRepresentation:representation ofEntity:entity fromResponse:response];
    }
     */
    return nil;
}

- (NSMutableURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest withContext:(NSManagedObjectContext *)context
{
    if ([self.entityExclusionSet containsObject:fetchRequest.entityName]) {
        return nil;
    } else {
        return [super requestForFetchRequest:fetchRequest withContext:context];
    }
}

@end
