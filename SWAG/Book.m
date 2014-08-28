//
//  Book.m
//  SWAG
//
//  Created by Javier 2 on 8/28/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "Book.h"


@implementation Book

@dynamic title;
@dynamic authors;
@dynamic categories;
@dynamic publisher;

- (NSString *)commaDelimitedAuthorsString
{
    return [[self.authors array] componentsJoinedByString:@", "];
}

- (NSString *) commaDelimitedCategoriesString
{
    return [[self.categories allObjects] componentsJoinedByString:@", "];
}

- (NSString *) publisherString
{
    return [self.publisher valueForKey:@"name"];
}


- (void)setCommaDelimitedAuthorsString:(NSString *)commaDelimitedAuthorsString
{
    NSString *fullNameKey = @"fullName";
    NSMutableArray *orderedAuthorsArray = [[commaDelimitedAuthorsString componentsSeparatedByString:@", "] mutableCopy];
    NSMutableOrderedSet *orderedAuthorsSet = [NSMutableOrderedSet orderedSetWithArray:orderedAuthorsArray];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"author"];
    request.predicate = [NSPredicate predicateWithFormat:@"fullName IN $NAME_LIST", orderedAuthorsArray];
    NSError *err;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&err];
    NSMutableDictionary *authorsDictionary = [NSMutableDictionary new];
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [orderedAuthorsArray removeObject:[obj valueForKey:fullNameKey]];
        authorsDictionary[[obj valueForKey:fullNameKey]] = obj;
    }];
    for (NSString *fullNameString in orderedAuthorsArray) {
        NSManagedObject *newAuthor = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"author" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [newAuthor setValue:fullNameString forKey:fullNameKey];
        authorsDictionary[[newAuthor valueForKey:fullNameKey]] = newAuthor;
    }
    [orderedAuthorsSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [orderedAuthorsSet replaceObjectAtIndex:idx withObject:authorsDictionary[obj]];
    }];
    [self setAuthors:orderedAuthorsSet];
    
}

- (void)setCommaDelimitedCategoriesString:(NSString *)commaDelimitedCategoriesString
{
    NSString *nameKey = @"name";
    NSMutableSet *categoriesSet = [NSMutableSet setWithArray:[commaDelimitedCategoriesString componentsSeparatedByString:@", "]];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"category"];
    request.predicate = [NSPredicate predicateWithFormat:@"name IN $NAME_LIST", categoriesSet];
    
    NSError *err;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&err];
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([categoriesSet containsObject:[obj valueForKey:nameKey]]) {
            [categoriesSet removeObject:[obj valueForKey:nameKey]];
        }
    }];
    [categoriesSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSManagedObject *newCategory = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"category" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [newCategory setValue:obj forKey:nameKey];
        [categoriesSet removeObject:obj];
        [categoriesSet addObject:newCategory];
    }];
    [categoriesSet unionSet:[NSSet setWithArray:results]];
    self.categories = categoriesSet;
}

- (void)setPublisherString:(NSString *)publisherString
{
    NSError *err;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"publisher"];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", publisherString];
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&err];
    if (results) {
        self.publisher = results[0];
    } else {
        NSManagedObject *newPublisher = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"publisher" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [newPublisher setValue:publisherString forKey:@"name"];
        self.publisher = newPublisher;
    }
}

- (NSMutableDictionary *) extendedAttributesDictionary
{
    return @{@"authors":[self commaDelimitedAuthorsString], @"categories": [self commaDelimitedCategoriesString], @"publisher": [self publisherString]}.mutableCopy;
}
@end
