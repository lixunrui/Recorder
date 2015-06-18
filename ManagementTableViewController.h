//
//  ManagementTableViewController.h
//  Recorder
//
//  Created by ITL on 17/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "queries.h"

@interface ManagementTableViewController : UITableViewController

@property Database* database;
@property TaskName taskName;

@end
