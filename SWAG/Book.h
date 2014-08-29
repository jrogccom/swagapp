//
//  Book.h
//  SWAG
//
//  Created by Javier 2 on 8/29/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * authorsList;
@property (nonatomic, retain) NSString * categoriesList;
@property (nonatomic, retain) NSString * lastCheckedOutBy;
@property (nonatomic, retain) id lastCheckedOut;
@property (nonatomic, retain) NSString * publisherName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * url;

@end
