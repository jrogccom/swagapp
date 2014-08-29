//
//  SWAGDateValueTransformer.h
//  SWAG
//
//  Created by Javier 2 on 8/29/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWAGDateTransformer : NSValueTransformer

@property (readonly, weak) NSDateFormatter *df;

@end
