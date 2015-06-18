//
//  BookDetailViewController.m
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "BookDetailViewController.h"
#import "queries.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtItemName;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtOrderDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFreeDelivery;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentStatus;
@property (weak, nonatomic) IBOutlet UIPickerView *itemPicker;

@property (weak, nonatomic) IBOutlet UIButton *btnPickItem;
@property (weak, nonatomic) IBOutlet UIButton *btnPickStatus;



@end

@implementation BookDetailViewController
{
    NSArray* arrResults;
    NSInteger currentItemID;
    NSInteger currentBookerID;
    NSInteger currentStatusID;
    BOOL selectedItem;
    BOOL selectedStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setFieldsStatus:NO];
    [self.itemPicker setHidden:YES];
    [self.itemPicker setBackgroundColor:[UIColor grayColor]];
    [self.view bringSubviewToFront:self.itemPicker];
    _txtAddress.layer.borderWidth = 1;
    _txtAddress.layer.cornerRadius = 6;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadDetails];
    [self loadFields];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    if (editing) {
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickConfirm:)];
        
        self.navigationItem.rightBarButtonItem = doneButton;
        
        [self setFieldsStatus:YES];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
        [self setFieldsStatus:NO];
    }
}

- (void)loadDetails
{
    if (_database) {
        [_database openDatabase];
    }
    NSString* query =[NSString stringWithFormat:@"%@%ld;",LOAD_ALL_DETAILED_RECORDS, (long)self.recordID];
    NSLog(@"%@",query);
    arrResults = [NSArray arrayWithArray:[_database loadDataFromDB:[NSString stringWithFormat:@"%@%ld;",LOAD_ALL_DETAILED_RECORDS, (long)self.recordID]]];
}

- (void)loadFields
{
    if (arrResults.count>0) {
        // load fields
        NSLog(@"good here");
        _txtName.text = arrResults[0][BookerName];
        _txtPhone.text = arrResults[0][BookerPhone];
        _txtAddress.text = arrResults[0][BookerAddress];
        _txtItemName.text = arrResults[0][ItemName];
        _txtQuantity.text = arrResults[0][RecordQuantity];
        _txtPrice.text = arrResults[0][RecordSellPrice];
        _txtOrderDate.text = arrResults[0][RecordTime];

        if([arrResults[0][RecordFreeDelivery] boolValue])
        {
            _txtFreeDelivery.text = @"Free";
        }
        else
            _txtFreeDelivery.text =@"40 / KG";

        _txtCurrentStatus.text = arrResults[0][StatusDescription];
        currentBookerID = [arrResults[0][BookerID] integerValue];
        currentItemID = [arrResults[0][ItemID] integerValue];
        currentStatusID = [arrResults[0][StatusID] integerValue];
    }
}

- (void)setFieldsStatus:(BOOL)editable
{
    _txtName.enabled = editable;
    _txtAddress.editable = editable;
    _txtCurrentStatus.enabled = editable;
    _txtFreeDelivery.enabled = editable;
    _txtItemName.enabled = editable;
    _txtOrderDate.enabled = editable;
    _txtPhone.enabled = editable;
    _txtPrice.enabled = editable;
    _txtQuantity.enabled = editable;
//    
//    _btnPickItem.hidden = !editable;
//    _btnPickStatus.hidden = !editable;
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


#pragma mark - button update data
- (void)clickConfirm:(id)sender {
    NSLog([NSString stringWithFormat:UPDATE_RECORD, currentBookerID, currentItemID, [_txtQuantity.text integerValue], currentStatusID, [_txtPrice.text floatValue], [_txtFreeDelivery.text boolValue], _recordID]);
    [_database execQuery:[NSString stringWithFormat:UPDATE_RECORD, currentBookerID, currentItemID, [_txtQuantity.text integerValue], currentStatusID, [_txtPrice.text floatValue], [_txtFreeDelivery.text boolValue], _recordID]];

    [_database execQuery:[NSString stringWithFormat:UPDATE_BOOKER, _txtName.text, _txtAddress.text, _txtPhone.text, currentBookerID]];

    [self setEditing:NO animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _txtItemName ) {
        selectedItem = YES;
        selectedStatus = NO;NSLog(@"Current A");
        arrResults = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_ITEMS]];
    }
    if (textField == _txtCurrentStatus) {
        selectedStatus = YES;
        selectedItem = NO;NSLog(@"Current B");
        arrResults = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_STATUS]];
    }

    if (selectedItem || selectedStatus) {
        [textField resignFirstResponder];
        [self.itemPicker reloadAllComponents];
        self.itemPicker.hidden = NO;
    }
}
//- (IBAction)clickPickItem:(id)sender {
//    arrResults = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_ITEMS]];
//    selectedItem = YES;
//    selectedStatus = NO;
//    [_txtItemName resignFirstResponder];
//    self.itemPicker.hidden = NO;
//    [self.itemPicker reloadAllComponents];
//}
//- (IBAction)clickPickStatus:(id)sender {
//    arrResults = [NSArray arrayWithArray:[_database loadDataFromDB:LOAD_STATUS]];
//    selectedStatus = YES;
//    selectedItem = NO;
//    [_txtCurrentStatus resignFirstResponder];
//    self.itemPicker.hidden = NO;
//    [self.itemPicker reloadAllComponents];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UI Picker View
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (selectedItem) {
        _txtItemName.text = arrResults[row][ItemName];
        currentItemID = [arrResults[row][0] integerValue];
        NSLog(@"reset item id to %d", currentItemID);
    }

    else if (selectedStatus)
    {
        _txtCurrentStatus.text = arrResults[row][1];
        currentStatusID = [arrResults[row][0] integerValue];
        NSLog(@"reset status id to %d", currentStatusID);
    }

    [pickerView setHidden:YES];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"count : %d",arrResults.count);
    return  arrResults.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (selectedItem) {
        return arrResults[row][ItemName];
    }
    else if (selectedStatus)
        return arrResults[row][1];

    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
