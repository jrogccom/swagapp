//
//  JAVEntryItem.m
//  SWAG
//
//  Created by Javier Osorio on 8/25/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "JAVEntryItem.h"

@implementation JAVEntryItem

- (NSDate *)lastCheckedOut
{
    return (NSDate *)_checkoutHistory.lastObject;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.publisher = [aDecoder decodeObjectForKey:@"publisher"];
        self.authors = [aDecoder decodeObjectForKey:@"authors"];
        self.categories = [aDecoder decodeObjectForKey:@"categories"];
        self.checkoutHistory = [aDecoder decodeObjectForKey:@"checkoutHistory"];
        self.entryNumber = [aDecoder decodeObjectForKey:@"entryNumber"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.publisher forKey:@"publisher"];
    [coder encodeObject:self.categories forKey:@"categories"];
    [coder encodeObject:self.entryNumber forKey:@"entryNumber"];
    [coder encodeObject:self.checkoutHistory forKey:@"checkoutHistory"];
    [coder encodeObject:self.authors forKey:@"authors"];
}
@end
