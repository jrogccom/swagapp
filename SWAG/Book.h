//
//  Book.h
//  SWAG
//
//  Created by Javier 2 on 8/28/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *authors;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSManagedObject *publisher;

@property (nonatomic, strong) NSString *commaDelimitedAuthorsString;
@property (nonatomic, strong) NSString *commaDelimitedCategoriesString;
@property (nonatomic, strong) NSString *publisherString;
@property (nonatomic, readonly) NSMutableDictionary *extendedAttributesDictionary;

@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addAuthorsObject:(NSManagedObject *)value;
- (void)removeAuthorsObject:(NSManagedObject *)value;
- (void)addAuthors:(NSSet *)values;
- (void)removeAuthors:(NSSet *)values;

- (void)insertObject:(NSManagedObject *)value inCategoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCategoriesAtIndex:(NSUInteger)idx;
- (void)insertCategories:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCategoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCategoriesAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceCategoriesAtIndexes:(NSIndexSet *)indexes withCategories:(NSArray *)values;
- (void)addCategoriesObject:(NSManagedObject *)value;
- (void)removeCategoriesObject:(NSManagedObject *)value;
- (void)addCategories:(NSOrderedSet *)values;
- (void)removeCategories:(NSOrderedSet *)values;
@end
