//
//  ManagementTableViewController.m
//  Recorder
//
//  Created by ITL on 17/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "ManagementTableViewController.h"
#import "ManagementDetailsViewController.h"

@interface ManagementTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableManagement;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAddItem;

@end

@implementation ManagementTableViewController
{
    NSArray* arrResults;
    NSInteger currentID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [self.tableManagement reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    if (_taskName == TaskBooker) {
        arrResults = [_database loadDataFromDB:LOAD_BOOKERS];
    }
    else if (_taskName == TaskItem)
    {
        arrResults = [_database loadDataFromDB:LOAD_ITEMS];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return arrResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_taskName) {
        case TaskItem:
            return 44;
            break;
        case TaskBooker:
            return 66;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    switch (_taskName) {
        case TaskBooker:
            cell.textLabel.text = arrResults[indexPath.row][1];
            cell.detailTextLabel.text = arrResults[indexPath.row][2];
            break;
        case TaskItem:
            cell.textLabel.text = arrResults[indexPath.row][2];
            cell.detailTextLabel.text = arrResults[indexPath.row][1];
            break;

        default:
            break;
    }

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (_taskName) {
            case TaskBooker:
                [_database execQuery:[NSString stringWithFormat: DELETE_ROW_FROM_BOOKER_AT, arrResults[indexPath.row][0]]];
                [self loadData];
                break;
            case TaskItem:
                [_database execQuery:[NSString stringWithFormat:DELETE_ROW_FROM_ITEM_AT, arrResults[indexPath.row][0]]];
            default:
                break;
        }

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailsManager"]) {
        ManagementDetailsViewController* detailsView = [segue destinationViewController];

        NSIndexPath* path = [self.tableManagement indexPathForSelectedRow];

        detailsView.database = _database;
        detailsView.taskType = _taskName;
        detailsView.ID = [arrResults[path.row][0] integerValue];
        detailsView.option = ViewOptionsView;
    }

    if ([segue.identifier isEqualToString:@"addNewItem"]) {
        ManagementDetailsViewController* detailsView = [segue destinationViewController];
        detailsView.database = _database;
        detailsView.taskType = _taskName;
        detailsView.option = ViewOptionsAdd;
    }
}


@end
