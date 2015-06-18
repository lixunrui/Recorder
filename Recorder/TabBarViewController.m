//
//  TabBarViewController.m
//  
//
//  Created by ITL on 15/06/15.
//
//

#import "TabBarViewController.h"
#import "Database.h"

@interface TabBarViewController ()

@end

Database* _database;

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDatabase];

   // NSString* query = @"select * from Status";

//    NSArray* a = [_database loadDataFromDB:query];
//
//    for (int i = 0; i< a.count; i++) {
//        NSLog(@"out %@", a[i][1]);
//    }
//    NSLog(@"done");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - database methods
- (Database*)loadDatabase
{
    if (!_database)
        _database = [[Database alloc]initWithDatabaseFileName:@"recorder.db"];
    
    NSLog(@"tabbar here");
    return _database;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
