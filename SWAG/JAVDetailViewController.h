//
//  JAVDetailViewController.h
//  SWAG
//
//  Created by Javier 2 on 8/24/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;
@interface JAVDetailViewController : UIViewController

@property (strong, nonatomic) Book *book;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
