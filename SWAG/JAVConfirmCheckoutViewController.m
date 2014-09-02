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
    // Do any additional setup after loading the view.
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
@end
