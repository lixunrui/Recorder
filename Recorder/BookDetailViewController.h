//
//  BookDetailViewController.h
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface BookDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property NSInteger recordID;
@property Database* database;

@end
