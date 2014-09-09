//
//  SWAGRESTClient.m
//  SWAG
//
//  Created by Javier Osorio on 8/27/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "SWAGRESTClient.h"
#import "Book.h"
#import <TransformerKit/TTTDateTransformers.h>

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


- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes ofManagedObject:(NSManagedObject *)managedObject
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
    NSDictionary *transformedKeysDict = @{@"authorsList": @"author", @"categoriesList": @"categories", @"publisherName": @"publisher"};
    [transformedKeysDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mutableAttributes[key]) {
            mutableAttributes[obj] = mutableAttributes[key];
            [mutableAttributes removeObjectForKey:key];
        }
    }];
    
    return mutableAttributes;
}


- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutableAttributes = [representation mutableCopy];
    NSDictionary *transformedKeysDict = @{@"author": @"authorsList", @"categories": @"categoriesList", @"publisher": @"publisherName"};
    [transformedKeysDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mutableAttributes[key]) {
            mutableAttributes[obj] = mutableAttributes[key];
            [mutableAttributes removeObjectForKey:key];
        }
    }];
    if (mutableAttributes[@"lastCheckedOut"] && ![mutableAttributes[@"lastCheckedOut"] isEqual:[NSNull null]]) {
        [mutableAttributes setValue:[[NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName] reverseTransformedValue:mutableAttributes[@"lastCheckedOut"]] forKey:@"lastCheckedOut"];
    }
    return mutableAttributes;
}

- (NSMutableURLRequest *)requestForInsertedObject:(NSManagedObject *)insertedObject
{
    NSMutableURLRequest *request = [super requestForInsertedObject:insertedObject];
    request.URL = [request.URL URLByAppendingPathComponent:@"/"]; // POST /books not working as described.  POST /books/ works instead.
    return request;
}

@end
