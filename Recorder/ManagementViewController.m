//
//  ShippingViewController.m
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "ManagementViewController.h"
#import "ManagementTableViewController.h"
#import "Database.h"

extern Database* _database;
@interface ManagementViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnBookerManagement;
@property (weak, nonatomic) IBOutlet UIButton *btnItemManagement;
@property (weak, nonatomic) IBOutlet UIButton *btnProfitReport;

@end

@implementation ManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickProfit:(id)sender {

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"bookerManagement"]) {
        ManagementTableViewController* managementView = [segue destinationViewController];
        managementView.navigationItem.title = @"Booker Management";
        managementView.database = _database;
        managementView.taskName = TaskBooker;
    }

    if ([segue.identifier isEqualToString:@"ItemManagement"]) {
        ManagementTableViewController* managementView = [segue destinationViewController];
        managementView.navigationItem.title = @"Item Management";
        managementView.database = _database;
        managementView.taskName = TaskItem;
    }
}


@end
