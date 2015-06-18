//
//  Database.m
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import "Database.h"

@implementation Database

- (NSString *)getDBVersion
{
    return DBVersion;
}

#pragma mark - init
- (Database *)initWithDatabaseFileName:(NSString *)databaseFileName
{
    if (self = [super init]) {
        _dbFileName = databaseFileName;
        _dbtableName = nil;
        [self openDatabase];
    }
    return self;
}

- (Database *)initWithDatabaseFileName:(NSString *)databaseFileName andTableName:(NSString *)tableName
{
    if (self = [super init]) {
        _dbFileName = databaseFileName;
        _dbtableName = tableName;
        [self openDatabase];
    }
    return self;
}

#pragma mark - SQL actions
#pragma mark Open-Close Database
- (void)openDatabase
{
    if (_database) {
        return;
    }
    _fileManager = [[NSFileManager alloc]init];
    NSString* dbPath = [self getDBPath];
    NSLog(@"db path is %@", dbPath);
    if (![_fileManager fileExistsAtPath:dbPath]) {
        NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_dbFileName];

        if ([_fileManager fileExistsAtPath:defaultDBPath]) {
            [_fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:NULL];
        }
    }
    NSLog(@"Open database");
    if (sqlite3_open([dbPath UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Error: could not open database");
    }
    _fileManager = nil;
}

- (void)closeDatabase
{
    if (_database) {
        sqlite3_close(_database);
    }
    NSLog(@"database closed");
    _database = nil;
    _fileManager = nil;
}

#pragma mark database actions
- (NSString *)getDBPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDirectory = paths[0];

    return [docDirectory stringByAppendingPathComponent:_dbFileName];
}


- (void)runQuery: (const char*)query isQueryExecutable:(BOOL)queryExecutable
{
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc]init];

    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc]init];

    if (_database) {NSLog(@"check database done: %s", query);
        BOOL prepareStatementResult = sqlite3_prepare_v2(_database, query, -1, &_statement, NULL);
        NSLog(@"prepare %d", prepareStatementResult);
        if (prepareStatementResult == SQLITE_OK) {
            if (!queryExecutable) {
                NSMutableArray* arrDataRow;
                NSLog(@"going to run");
                int result = sqlite3_step(_statement);
                NSLog(@"while loop %d",result);
                while (result == SQLITE_ROW) {
                    NSLog(@"result %d", result);
                    arrDataRow = [[NSMutableArray alloc]init];

                    int totalColumns = sqlite3_column_count(_statement);
                    NSLog(@"total columns are %d", totalColumns);
                    // get through all columns and fetch data
                    for (int i = 0 ; i < totalColumns; i++) {
                        char* dbDataAsChars = (char*)sqlite3_column_text(_statement, i);

                        if (dbDataAsChars !=NULL) {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }

                        if (self.arrColumnNames.count!= totalColumns) {
                            dbDataAsChars = (char*)sqlite3_column_name(_statement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    NSLog(@"here loop");
                    
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                    result = sqlite3_step(_statement);
                }
                NSLog(@"out put is %d",result);

            }
            else // insert, update
            {NSLog(@"query is %s",query);
                if (sqlite3_step(_statement) == SQLITE_DONE) {
                    self.affectRows = sqlite3_changes(_database);

                    self.lastInsertedRowID = sqlite3_last_insert_rowid(_database);
                }
                else
                {
                    NSLog(@"db error: %s", sqlite3_errmsg(_database));
                }
            }
        }
        else
        {
            NSLog(@"database couldn't be open %s", sqlite3_errmsg(_database));
        }

        sqlite3_finalize(_statement);
    }
    //[self closeDatabase];
}

- (NSArray *)loadDataFromDB:(NSString *)query
{NSLog(@"load data from db");
    [self runQuery:[query UTF8String] isQueryExecutable:NO];

    return (NSArray*)self.arrResults;
}

/**
 *  Executes a non-select query on the SQLite database
    use SQLBind to bind the variadic parameters
 *
 *  @param query query and parameters
 *
 *  @return the number od affect rows
 */
- (void)execQuery:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
