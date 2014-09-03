//
//  JAVConfirmCheckoutViewController.m
//  SWAG
//
//  Created by Javier 2 on 9/1/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "JAVConfirmCheckoutViewController.h"

@interface JAVConfirmCheckoutViewController ()
{
    BOOL _shouldReturnCheckoutInfo;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
- (IBAction)confirmButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation JAVConfirmCheckoutViewController

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
    self.scrollView.contentSize = self.scrollView.frame.size;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = self.scrollView.frame.size;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (NSDictionary *)checkoutInfoDict
{
    if (_shouldReturnCheckoutInfo) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_firstNameTextField.text, @"firstName",
                                      _lastNameTextField.text, @"lastName",
                                      nil ];
        return [NSDictionary dictionaryWithDictionary:mDict];
    } else {
        return nil;
    }
    
}
- (IBAction)confirmButtonPressed:(id)sender {
    if (_firstNameTextField.text.length == 0 || _lastNameTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information Incomplete" message:@"Please fill out first and last names." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    } else {
        _shouldReturnCheckoutInfo = YES;
        [self performSegueWithIdentifier:@"backToDetail" sender:nil];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    _shouldReturnCheckoutInfo = NO;
    [self performSegueWithIdentifier:@"backToDetail" sender:nil];
}

#pragma keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil]; */
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect kbFrame = [self.scrollView.superview convertRect:[(NSValue *)aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, CGRectGetMinY(kbFrame) - CGRectGetMinY(self.scrollView.frame))];
    
}
@end
