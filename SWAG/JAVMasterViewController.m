//
//  JAVMasterViewController.m
//  SWAG
//
//  Created by Javier 2 on 8/24/14.
//  Copyright (c) 2014 JavHimself. All rights reserved.
//

#import "JAVMasterViewController.h"
#import "JAVDetailViewController.h"
#import "JAVAddBookViewController.h"
#import "JAVAppDelegate.h"
#import "Book.h"
#import "SWAGIncrementalDataStore.h"

//@import CoreData;


NS_ENUM(NSInteger, AlertViewTag) {
    AlertViewDeleteRowsTag = 0,
    AlertViewUnreachableWarningTag = 33
};

@interface JAVMasterViewController () {
    NSMutableArray *_objects;
    BOOL _editingModeOn;
}
@property (weak, nonatomic) NSManagedObjectModel *model;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic, readonly) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly) AFNetworkReachabilityStatus reachabilityStatus;
- (IBAction)longPressOnTableView:(id)sender;
- (IBAction)refresh:(UIRefreshControl *)sender;
@end

@implementation JAVMasterViewController

/*- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}*/


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchRemoteValues:) name:AFIncrementalStoreContextDidFetchRemoteValues object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    NSError *err;
    [self.fetchedResultsController performFetch:&err];
    if (err) {
        [NSException raise:@"Error fetching" format:@"Error: %@", err.localizedDescription];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Core-Data-related methods

- (NSManagedObjectModel *)model
{
    if (!_model) {
        _model = [ (JAVAppDelegate *)[UIApplication sharedApplication].delegate managedObjectModel];
    }
    return _model;
}

- (BOOL)saveContext
{
    NSError *err;
    BOOL success = [self.fetchedResultsController.managedObjectContext save:&err];
    if (!success) {
        [NSException raise:@"Saving failed." format:@"Error: %@", err.localizedDescription];
    }
    return success;
}

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(JAVAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    }
    return _context;
}


#pragma mark - Table View

- (IBAction)refresh:(UIRefreshControl *)sender
{
    if (self.reachabilityStatus != AFNetworkReachabilityStatusNotReachable && self.reachabilityStatus != AFNetworkReachabilityStatusUnknown)
    {
        NSError *err;
        [self.fetchedResultsController performFetch:&err];
    } else
    {
        [sender endRefreshing];
        [self presentUnreachabilityStatusAlertView];
    }
    
}


- (IBAction)longPressOnTableView:(UILongPressGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete library" otherButtonTitles:@"Reload library", nil];
            [actionSheet showInView:self.view];
            
        } break;
        default:
            break;
    }
    
}


- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (void)toggleEditingMode
{
    _editingModeOn = _editingModeOn ? NO : YES;
    [self.tableView setEditing:_editingModeOn animated:YES];
    
}

- (IBAction)editButtonPressed:(id)sender
{
    [self toggleEditingMode];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
    //return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.authorsList;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:book];
        [self saveContext];
        
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark - Segue-related methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[segue destinationViewController] setBook:object];
    }
}

- (void)insertNewBookWithAttributes:(NSDictionary *)attributes
{
    Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.context] ;
    [newBook.entity.attributesByName enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (attributes[key]) {
            [newBook setValue:attributes[key] forKey:key];
        }
    }];
    //[self.fetchedResultsController.managedObjectContext insertObject:newBook];
    [self saveContext];
    //[_objects addObject:newBook];
    //[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (IBAction)unwindFromAddItem:(UIStoryboardSegue *)segueBack
{
    JAVAddBookViewController *addVC = segueBack.sourceViewController;
    if (addVC.collectedData) {
        [self insertNewBookWithAttributes:addVC.collectedData];
    }
    
}

- (void)checkoutBook:(Book *)book withCheckoutInfo:(NSDictionary *)checkoutInfo
{
    NSString *checkoutName = [NSString stringWithFormat:@"%@, %@", checkoutInfo[@"lastName"], checkoutInfo[@"firstName"]];
    book.lastCheckedOutBy = checkoutName;
    book.lastCheckedOut = [NSDate date];
    [self saveContext];
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue *)segueBack
{
    NSDictionary *transactionInfo = [segueBack.sourceViewController valueForKey:@"transactionInfo"];
    Book *book = transactionInfo[@"book"];
    if (transactionInfo[@"checkoutInfo"]) {
        [self checkoutBook:book withCheckoutInfo:transactionInfo[@"checkoutInfo"]];
    }
}



#pragma mark - NSFetchedRequestController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

/*
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}
*/




#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 0 for Facebook, 1 for Twitter
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete all rows" message:@"Do you want to empty out your library?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        alertView.tag = AlertViewDeleteRowsTag;
        [alertView show];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        NSError *err;
        [self.fetchedResultsController performFetch:&err];
    } else {}
}

#pragma mark - UIAlertviewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case AlertViewDeleteRowsTag:
                if (buttonIndex == alertView.cancelButtonIndex) {
                    
                } else if (buttonIndex == alertView.firstOtherButtonIndex) {
                    for (Book *book in self.fetchedResultsController.fetchedObjects) {
                        [self.fetchedResultsController.managedObjectContext deleteObject:book];
                    }
                    [self saveContext];
                }else {
                    
                }
            break;
        case AlertViewUnreachableWarningTag:
            break;
        default:
            break;
    }
    
}

#pragma mark - Notifications

- (void)didFetchRemoteValues:(NSNotification *)aNotification
{
    [self.refreshControl endRefreshing];
    
}

- (void)reachabilityStatusChanged:(NSNotification *)aNotification
{
    AFNetworkReachabilityStatus status = [aNotification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            [self presentUnreachabilityStatusAlertView];
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self presentUnreachabilityStatusAlertView];
            break;
        default:
            break;
    }
}

#pragma mark - Misc

- (void)presentUnreachabilityStatusAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network not reachable" message:@"Verify in your settings that the network is enabled and that internet access is available." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    alertView.tag = AlertViewUnreachableWarningTag;
    [alertView show];
}

- (AFNetworkReachabilityStatus)reachabilityStatus
{
    return [SWAGIncrementalDataStore reachabilityStatus];
}
@end
