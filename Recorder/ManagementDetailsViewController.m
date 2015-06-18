//
//  ManagementDetailsViewController.m
//  Recorder
//
//  Created by ITL on 17/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "ManagementDetailsViewController.h"

@interface ManagementDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblContact;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressOrPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtContact;


@end

@implementation ManagementDetailsViewController
{
    NSArray* arrResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    switch (_taskType) {
        case TaskBooker:
            [self loadBookerAndLayout];
            break;
        case TaskItem:
            [self loadItemsAndLayout];
        default:
            break;
    }
}

#pragma mark - load layout based on option
- (void)loadBookerAndLayout
{
    _lblAddress.hidden = NO;
    _lblContact.hidden = NO;
    _lblPrice.hidden = YES;
    _txtContact.hidden = NO;
    switch (_option) {
        case ViewOptionsAdd:
        {
            UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addBooker)];
            self.navigationItem.rightBarButtonItem = addButton;
        }
            break;
        case ViewOptionsView:
        {
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
            [self loadBookerDetail];
            [self setEditing:NO animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)loadItemsAndLayout
{
    _lblAddress.hidden = YES;
    _lblContact.hidden = YES;
    _lblPrice.hidden = NO;

    _txtContact.hidden = YES;

    switch (_option) {
        case ViewOptionsAdd:
        {
            UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addItem)];
            self.navigationItem.rightBarButtonItem = addButton;
        }
            break;
        case ViewOptionsView:
        {
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
            [self loadItemsDetail];
            [self setEditing:NO animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark Setup editing
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

#pragma mark Setup fields status
- (void)setFieldsStatus:(BOOL)editable
{
    _txtName.enabled = editable;
    _txtAddressOrPrice.enabled = editable;
    _txtContact.enabled = editable;
}

#pragma mark - Confirm button event
- (void)clickConfirm:(id)sender {

    switch (_taskType) {
        case TaskBooker:
            [_database execQuery:[NSString stringWithFormat:UPDATE_BOOKER, _txtName.text, _txtAddressOrPrice.text, _txtContact.text, _ID]];
            break;
        case TaskItem:
            [_database execQuery:[NSString stringWithFormat:UPDATE_ITEM,_txtName.text, [_txtAddressOrPrice.text floatValue], _ID]];
            break;
        default:
            break;
    }

    [self setEditing:NO animated:YES];
}

#pragma mark - Add new item
- (void)addBooker
{
    [_database execQuery:[NSString stringWithFormat:INSERT_BOOKER, _txtName.text, _txtAddressOrPrice.text, _txtContact.text]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addItem
{
    [_database execQuery:[NSString stringWithFormat:INSERT_ITEM, _txtName.text, [_txtAddressOrPrice.text floatValue]]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Load item details
- (void)loadBookerDetail
{
    arrResults = [_database loadDataFromDB:[NSString stringWithFormat:LOAD_BOOKER_WITH_ID, _ID]];
    if (arrResults.count == 0 ) {
        return;
    }
    NSString* bookerID = arrResults[0][0];
    NSString* name = arrResults[0][1];
    NSString* address = arrResults[0][2];
    NSString* phone = arrResults[0][3];

    [self loadFieldsElements:bookerID, name, address, phone,nil];
}

- (void)loadItemsDetail
{
    arrResults = [_database loadDataFromDB:[NSString stringWithFormat:LOAD_ITEM_WITH_ID, _ID]];
    if (arrResults.count == 0 ) {
        return;
    }
    NSString* itemID = arrResults[0][0];
    NSString* name = arrResults[0][2];
    float price = [arrResults[0][1] floatValue];

    [self loadFieldsElements:itemID, name, [NSString stringWithFormat:@"%f",price], nil];
}

#pragma mark - fill page fields
- (void)loadFieldsElements: (NSString*)first, ...
{
    va_list args;

    va_start(args, first);
    [self loadFields:first VAList:args];
    va_end(args);
}


// why lots of objects here in the args????
- (void)loadFields: (NSString*)argsFirst VAList:(va_list)args
{
    NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:argsFirst, nil];

    id first;
    while ((first = va_arg(args, id)) != nil) {
            [array addObject:first];
        }

    if ( array.count == 0 ) {
        return;
    }

    _txtName.text = array[1];
    _txtAddressOrPrice.text = array[2];
    if (_taskType == TaskBooker) {
        _txtContact.text = array[3];
    }
}

#pragma mark - system functions
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
}

@end
