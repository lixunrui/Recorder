//
//  BookingViewController.m
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "BookingViewController.h"
#import "BookDetailViewController.h"
#import "AddViewController.h"
#import "Database.h"
#import "queries.h"

extern Database* _database;

@interface BookingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *bookingTable;

@end

@implementation BookingViewController
{
    NSArray* arrResults;
    NSArray* arrRecordsID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.bookingTable setEditing:editing animated:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [self loadRecordsID];
    [self.bookingTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - database methods
- (void)loadData
{
    if (_database) {
        [_database openDatabase];
    }
    NSLog(@"load data here");
    arrResults =[NSArray arrayWithArray: [_database loadDataFromDB:LOAD_ALL_BASIC_RECORDS]];
    NSLog(@"arr result numer is %d", arrResults.count);
}

- (void)loadRecordsID
{NSLog(@"arr result numer is load id here %d", arrResults.count);
    if (_database) {
        [_database openDatabase];
    }
    NSLog(@"load id");
    arrRecordsID = [NSArray arrayWithArray: [_database loadDataFromDB:LOAD_ALL_RECORDS_ID]];
    
    NSLog(@"arr result numer is load id done %d", arrResults.count);
}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"bookingCell" forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", arrResults[indexPath.row][BookerName]];// arrResults[BookerName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: Quantity:%@   Current Status: %@",arrResults[indexPath.row][ItemName], arrResults[indexPath.row][RecordQuantity], arrResults[indexPath.row][StatusDescription]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{NSLog(@"row is %d", indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_database execQuery:[NSString stringWithFormat:DELETE_ROW_FROM_RECORD_AT, [arrRecordsID[indexPath.row][0]integerValue]]];
        [self loadData];
        [self loadRecordsID];
        [self.bookingTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count is : %lu", (unsigned long)arrResults.count);
    return arrResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        BookDetailViewController* detailViewController = [segue destinationViewController];
        NSIndexPath* path  = [self.bookingTable indexPathForSelectedRow];
        
        NSInteger recordID = [arrRecordsID[path.row][0] integerValue];
        NSLog(@"path %d", path.row);
        NSLog(@"record id = %ld", recordID);
        
        detailViewController.recordID = recordID;
        detailViewController.database = _database;
        
        detailViewController.navigationItem.title = @"Record Details";
    }
    
    if ([segue.identifier isEqualToString:@"addSegue"]) {
        AddViewController* addViewController = [segue destinationViewController];
        
        addViewController.database = _database;
        
        addViewController.navigationItem.title = @"Add Record";
    }
}


@end
