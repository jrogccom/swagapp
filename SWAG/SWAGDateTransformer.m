//
//  SWAGDateValueTransformer.m
//  SWAG
//
//  Created by Javier 2 on 8/29/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "SWAGDateTransformer.h"

@implementation SWAGDateTransformer

+ (Class)transformedValueClass
{
    return [NSDate class];
}

+ (NSDateFormatter *)df
{
    static dispatch_once_t pred;
    static NSDateFormatter *df = nil;
    dispatch_once(&pred, ^{
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return df;
}

- (NSDateFormatter *)df
{
    return [SWAGDateTransformer df];
}
- (id)transformedValue:(id)value
{
    if ([value isKindOfClass:[NSDate class]]) {
        return value;
    } else if ([value isKindOfClass:[NSString class]]) {
        return [self.df dateFromString:value];
    } else {
        return nil;
    }
}

- (id)reverseTransformedValue:(id)value
{
    return [self.df stringFromDate:value];
}
@end
