//
//  ManagementDetailsViewController.h
//  Recorder
//
//  Created by ITL on 17/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "queries.h"
#import "Database.h"

@interface ManagementDetailsViewController : UIViewController

@property TaskName taskType;
@property Database* database;
@property NSInteger ID;
@property ViewOptions option;

@end
