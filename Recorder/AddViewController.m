//
//  AddViewController.m
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "AddViewController.h"
#import "queries.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtItemName;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFreeDelivery;
@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UIPickerView *itemPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnPickName;

@property (weak, nonatomic) IBOutlet UIButton *btnPickItem;
@property (weak, nonatomic) IBOutlet UIButton *btnPickStatus;
@property (weak, nonatomic) IBOutlet UISegmentedControl *deliveryControl;

@end

@implementation AddViewController
{
    NSInteger currentBookerID;
    NSInteger currentItemID;
    NSInteger currentStatusID;
    
    BOOL selectedBookerName;
    BOOL selectedItemName;
    BOOL selectedStatus;
    
    NSArray* arrBookers;
    NSArray* arrItems;
    NSArray* arrStatus;
    
    NSArray* arrResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    currentBookerID = 0;
    currentItemID = 0;
    currentStatusID = 0;
    if (_database) {
        [_database openDatabase];
    }
    [self.view bringSubviewToFront:_itemPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Support Methods
- (void)loadData
{
    arrBookers = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_BOOKERS]];
    arrItems = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_ITEMS]];
    arrStatus = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_STATUS]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
    [self.itemPicker setHidden:YES];
}

#pragma mark - Text Filed delegate

- (IBAction)clickPickName:(id)sender {
    arrBookers = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_BOOKERS]];

    selectedBookerName = YES;
    selectedItemName = NO;
    selectedStatus = NO;
    
    [self.itemPicker reloadAllComponents];
    [self.itemPicker setHidden:NO];
}
- (IBAction)clickPickItem:(id)sender {
    arrItems = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_ITEMS]];

    selectedItemName = YES;
    selectedBookerName = NO;
    selectedStatus = NO;
    
    [self.itemPicker reloadAllComponents];
    [self.itemPicker setHidden:NO];
}
- (IBAction)clickPickStatus:(id)sender {
    arrStatus = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_STATUS]];

    selectedStatus = YES;
    selectedBookerName = NO;
    selectedItemName = NO;
    
    [self.itemPicker reloadAllComponents];
    [self.itemPicker setHidden:NO];
}

- (IBAction)clickSave:(id)sender {
    arrResults = [NSArray arrayWithArray:[_database loadDataFromDB:[NSString stringWithFormat:SEARCH_BOOKER_WITH_PHONE, _txtPhone.text]]];

    if (arrResults.count == 0)
    {
        // cannot find the booker's phone, so we add in and add the record later
        // add the booker
        [_database execQuery:[NSString stringWithFormat:INSERT_BOOKER, _txtName.text, _txtAddress.text, _txtPhone.text]];
    }
    
    // can find the phone, which mean the booker has already exist
    // then search the item

    //        bookerID, itemID, quantity, statusID, sellPrice, freeDelivery
    [_database execQuery:[NSString stringWithFormat:INSERT_RECORD, currentBookerID, currentItemID, [_txtQuantity.text integerValue], currentStatusID, [_txtPrice.text floatValue], _deliveryControl.selectedSegmentIndex]];


    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Picker View
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (selectedBookerName) {
        _txtName.text = arrBookers[row][1];
        _txtAddress.text = arrBookers[row][2];
        _txtPhone.text = arrBookers[row][3];
        currentBookerID = [arrBookers[row][0] integerValue];
    }
    if (selectedItemName) {
        _txtItemName.text = arrItems[row][2];
        currentItemID = [arrItems[row][0] integerValue];
    }
    if (selectedStatus) {
        _txtStatus.text = arrStatus[row][1];
        currentStatusID = [arrStatus[row][0] integerValue];
    }
    [pickerView setHidden:YES];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (selectedBookerName) {
        return arrBookers.count;
    }
    if (selectedItemName) {
        return arrItems.count;
    }
    if (selectedStatus) {
        return arrStatus.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (selectedBookerName) {
        return arrBookers[row][1];
    }
    if (selectedItemName) {
        return arrItems[row][2];;
    }
    if (selectedStatus) {
        return arrStatus[row][1];;
    }
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
