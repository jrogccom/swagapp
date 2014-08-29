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

@import CoreData;

@interface JAVMasterViewController () {
    NSMutableArray *_objects;
}
@property (weak, nonatomic) NSManagedObjectModel *model;
@property (weak, nonatomic) NSManagedObjectContext *context;
@end

@implementation JAVMasterViewController

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
    [self fetchBooks];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
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
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Book *book = _objects[indexPath.row];
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
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (IBAction)unwoundFromAddItem:(UIStoryboardSegue *)segueBack
{
    
}
@end
