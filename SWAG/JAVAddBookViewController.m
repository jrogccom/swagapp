//
//  JAVAddBookViewController.m
//  SWAG
//
//  Created by Javier 2 on 8/25/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "JAVAddBookViewController.h"

typedef NS_ENUM(NSInteger, JAVAlertViewType)
{
    JAVIncompleteSubmissionType,
    JAVUnsavedDataType
};
@interface JAVAddBookViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bookTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorsTextField;
@property (weak, nonatomic) IBOutlet UITextField *publisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoriesTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)submitButtonPressed:(id)sender;


@end

@implementation JAVAddBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButtonPressed:(id)sender {
    if (_bookTitleTextField.text.length == 0 || _publisherTextField.text.length == 0 || _authorsTextField.text.length == 0 ||
        _categoriesTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fields missing" message:@"Please fill all fields before submitting." delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
        alertView.tag = JAVIncompleteSubmissionType;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case JAVIncompleteSubmissionType:
            
            break;
        case JAVUnsavedDataType:
            
            break;
        default:
            break;
    }
}
@end
