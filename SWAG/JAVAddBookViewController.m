//
//  JAVAddBookViewController.m
//  SWAG
//
//  Created by Javier 2 on 8/25/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "JAVAddBookViewController.h"
#import "JAVEntryItem.h"

typedef NS_ENUM(NSInteger, JAVAlertViewType)
{
    JAVIncompleteSubmissionType,
    JAVUnsavedDataType
};

typedef NS_ENUM(NSInteger, JAVButtonTag)
{
    JAVSubmitTag,
    JAVCancelTag
};

@interface JAVAddBookViewController ()
{
    BOOL _addingEntry;
}
@property (weak, nonatomic) IBOutlet UITextField *bookTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorsTextField;
@property (weak, nonatomic) IBOutlet UITextField *publisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoriesTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
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
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fields missing" message:@"Please fill all fields before submitting." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alertView.tag = JAVIncompleteSubmissionType;
        [alertView show];
    } else {
        _addingEntry = YES;
        [self performSegueWithIdentifier:@"backToMaster" sender:sender];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Entry not submitted" message:@"Information not saved and will be lost." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Return", nil];
    alertView.tag = JAVUnsavedDataType;
    [alertView show];
}

- (NSDictionary *)collectedData
{
    if (_addingEntry) {
    
    NSString *title = _bookTitleTextField.text.copy;
    NSString *publisherName = _publisherTextField.text.copy;
    NSString *categoriesList = _categoriesTextField.text.copy;
    NSString *authorsList = _authorsTextField.text.copy;
    
    return @{@"title": title, @"authorsList": authorsList, @"categoriesList": categoriesList, @"publisherName": publisherName};
    } else {
        return nil;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case JAVUnsavedDataType:
            switch (buttonIndex) {
                case 0:
                    NSLog(@"option 0");
                    break;
                case 1:
                    NSLog(@"option 1");
                    _addingEntry = NO;
                    [self performSegueWithIdentifier:@"backToMaster" sender:nil];
                    // SEGUE BACK
                    break;
                default:
                    break;
            } break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

#pragma mark - keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];*/
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect kbFrame = [self.scrollView.superview convertRect:[(NSValue *)aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    if (CGRectGetMinY(kbFrame) < CGRectGetMaxY(self.scrollView.frame)) {
        [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, CGRectGetMinY(kbFrame) - CGRectGetMinY(self.scrollView.frame))];
        self.scrollView.scrollEnabled = YES;
    }
    
    
}



@end
