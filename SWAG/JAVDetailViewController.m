//
//  JAVDetailViewController.m
//  SWAG
//
//  Created by Javier 2 on 8/24/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "JAVDetailViewController.h"
#import "Book.h"

@interface JAVDetailViewController ()
{
    BOOL _checkoutDidOccur;
}
@property (weak, nonatomic) IBOutlet UITextView *bookInfoTextView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) NSString *infoText;
- (void)configureView;
- (IBAction)checkoutButtonPressed:(id)sender;
@end

@implementation JAVDetailViewController

#pragma mark - Managing the detail item

- (void)setBook:(Book *)newDetailItem
{
    if (_book != newDetailItem) {
        _book = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.book) {
        self.detailDescriptionLabel.text = [self.book description];
        [self setInfoTextFromBook:self.book];
        self.bookInfoTextView.text = self.infoText;
    }
}

- (void)setInfoTextFromBook:(Book *)book
{
    NSString *infoText = [NSString stringWithFormat:
                          @"%@\n"
                          "%@\n"
                          "Publisher: %@\n"
                          "Tags: %@\n"
                          "Last Checked Out:\n%@",
                          book.title,
                          book.authorsList,
                          book.publisherName,
                          book.categoriesList,
                          book.lastCheckedOut ? [NSString stringWithFormat:@"%@ @ %@", book.lastCheckedOutBy, book.lastCheckedOut] : @"Check me out!."
                          ];
    self.infoText = infoText;
}
- (IBAction)checkoutButtonPressed:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_checkoutDidOccur) {
        [self performSegueWithIdentifier:@"backToMaster" sender:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirmCheckoutControllerDone:(UIStoryboardSegue *)segueBack
{
    NSDictionary *checkoutInfo = [segueBack.sourceViewController valueForKey:@"checkoutInfoDict"];
    if (checkoutInfo) {
        self.transactionInfo[@"checkoutInfo"] = checkoutInfo;
        _checkoutDidOccur = YES;
        //[self performSegueWithIdentifier:@"backToMaster" sender:nil];
    }
}

- (NSMutableDictionary *)transactionInfo
{
    if (!_transactionInfo) {
        _transactionInfo = [[NSMutableDictionary alloc] init];
        _transactionInfo[@"book"] = self.book;
    }
    return  _transactionInfo;
}

@end
