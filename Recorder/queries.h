//
//  queries.h
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#ifndef Recorder_queries_h
#define Recorder_queries_h

typedef enum
{
    RecordID = 0,
    BookerName = 1,
    ItemName = 2,
    RecordQuantity = 3,
    StatusDescription = 4,
    BookerAddress = 5,
    BookerPhone = 6,
    RecordSellPrice = 7,
    RecordTime = 8,
    RecordFreeDelivery = 9,
    BookerID = 10,
    ItemID = 11,
    StatusID = 12
}QuerySequence;

typedef enum
{
    TaskBooker,
    TaskItem,
}TaskName;

typedef enum
{
    ViewOptionsAdd,
    ViewOptionsView,
}ViewOptions;


#define LOAD_ALL_RECORDS_ID @"select id from record;"

#define LOAD_ITEMS @"select itemid, purchasePrice, name from items;"
#define LOAD_ITEM_WITH_ID @"SELECT * FROM items where itemid = %d;"


#define LOAD_STATUS @"select * from status;"

#define LOAD_BOOKERS @"select * from booker;"
#define LOAD_BOOKER_WITH_ID @"select * from booker where bookerID=%d;"

#define LOAD_ALL_BASIC_RECORDS @"select record.id, booker.name as BookName, items.name as ItemName, record.quantity as Quantity, Status.description as CurrentStatus from booker, record, items,Status where booker.bookerID = record.bookerID and record.itemID = items.itemID and record.statusID = status.statusID;"

#define LOAD_ALL_DETAILED_RECORDS @"select record.id, booker.name as BookName, items.name as ItemName, record.quantity as Quantity, Status.description as CurrentStatus, booker.address as BookerAddress, booker.contactNum as BookerPhone, Record.sellprice as RecordSellPrice, record.timestamp as RecordTime, record.freedelivery as RecordFreeDelivery, booker.bookerid, items.itemid, status.statusid from booker, record, items,Status where booker.bookerID = record.bookerID and record.itemID = items.itemID and record.statusID = status.statusID and record.id="

#define UPDATE_RECORD @"update record set bookerid =%d, itemID=%d, quantity = %d, statusID=%d, sellPrice=%f, freeDelivery=%d where id = %d;"

#define UPDATE_BOOKER @"update booker set name='%@', address = '%@', contactNum='%@' where bookerid = %d;"

#define UPDATE_ITEM @"update items set name = '%@', purchasePrice= %f where itemid=%d;"

#define INSERT_BOOKER @"INSERT INTO booker (name, address, contactNum) VALUES ('%@', '%@', '%@');"

#define INSERT_RECORD @"INSERT INTO record (bookerID, itemID, quantity, statusID, sellPrice, freeDelivery) VALUES (%d, %d, %d, %d, %f, %d);"

#define INSERT_BOOKER @"INSERT into booker (name, address, contactNum) VALUES ('%@', '%@', '%@');"

#define INSERT_ITEM @"INSERT INTO items (name, purchasePrice) VALUES ('%@', %f);"

#define DELETE_ROW_FROM_RECORD_AT @"delete from record where id = %d;"

#define DELETE_ROW_FROM_BOOKER_AT @"delete from booker where bookerid= %d;"

#define DELETE_ROW_FROM_ITEM_AT @"delete from item where itemid = %d;"

#define SEARCH_BOOKER_WITH_PHONE @"select * from booker where contactNum='%@'"

#endif
