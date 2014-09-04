//
//  SWAGIncrementalDataStore.h
//  SWAG
//
//  Created by Javier 2 on 8/26/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "AFIncrementalStore.h"

@interface SWAGIncrementalDataStore : AFIncrementalStore
+(void)cleanLibraryWithCompletionBlock:(void (^)(BOOL success, NSDictionary *info))completionBlock;
@end
