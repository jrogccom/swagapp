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

@interface JAVMasterViewController () {
    NSMutableArray *_objects;
    BOOL _editingModeOn;
}
@property (weak, nonatomic) NSManagedObjectModel *model;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (IBAction)longPressOnTableView:(id)sender;
@end

@implementation JAVMasterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController.delegate = self;
        //NSError *err;
        //[self.fetchedResultsController performFetch:&err];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchRemoteValues:) name:AFIncrementalStoreContextDidFetchRemoteValues object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSManagedObjectModel *)model
{
    if (!_model) {
        _model = [ (JAVAppDelegate *)[UIApplication sharedApplication].delegate managedObjectModel];
    }
    return _model;
}


- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(JAVAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    }
    return _context;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
- (void)fetchBooks
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    NSError *err;
    _objects = [[self.context executeFetchRequest:request error:&err] mutableCopy];
    if (err) {
        [NSException raise:@"Results not fetched." format:@"Error: %@", err.localizedDescription];
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *err;
    [self.fetchedResultsController performFetch:&err];
    if (err) {
        [NSException raise:@"Error fetching" format:@"Error: %@", err.localizedDescription];
    }
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear: ran");
    [self fetchBooks];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

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
    [self.fetchedResultsController.managedObjectContext insertObject:newBook];
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
    // [self saveContext];
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue *)segueBack
{
    NSDictionary *transactionInfo = [segueBack.sourceViewController valueForKey:@"transactionInfo"];
    Book *book = transactionInfo[@"book"];
    if (transactionInfo[@"checkoutInfo"]) {
        [self checkoutBook:book withCheckoutInfo:transactionInfo[@"checkoutInfo"]];
    }
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

#pragma mark - NSFetchedRequestController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

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

#pragma mark - notifications

- (void)didFetchRemoteValues:(NSNotification *)aNotification
{
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        NSError *err;
        [self.fetchedResultsController performFetch:&err];
    } else {
        [self.tableView reloadData];
    }
}

- (IBAction)longPressOnTableView:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete all rows" message:@"Do you want to empty out your library?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alertView show];
}

#pragma mark - UIAlertviewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        
    } else if (buttonIndex == alertView.firstOtherButtonIndex) {
        [SWAGIncrementalDataStore cleanLibraryWithCompletionBlock:^(BOOL success, NSDictionary *info) {
            if (success) [self.fetchedResultsController performFetch:nil];
        }];
    } else {
    
    }
}
@end
