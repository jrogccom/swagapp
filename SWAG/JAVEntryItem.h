//
//  JAVEntryItem.h
//  SWAG
//
//  Created by Javier Osorio on 8/25/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JAVEntryItem : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSOrderedSet *authors;
@property (strong, nonatomic) NSSet *categories;
@property (strong, nonatomic) NSArray *checkoutHistory;
@property (strong, nonatomic) NSNumber *entryNumber;
@property (readonly) NSDate *lastCheckedOut;

@end
