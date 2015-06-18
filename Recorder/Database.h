//
//  Database.h
//  Recorder
//
//  Created by ITL on 15/06/15.
//  Copyright (c) 2015 Raymond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

static NSString* const DBVersion = @"1.0.0";

@interface Database : NSObject
{
    sqlite3* _database;
    sqlite3_stmt* _statement;
    NSString* _dbtableName;
    NSString* _dbFileName;
    NSFileManager* _fileManager;
}

@property (nonatomic, strong) NSMutableArray* arrResults;
@property (nonatomic, strong) NSMutableArray* arrColumnNames;
@property (nonatomic) int affectRows;
@property (nonatomic) long long lastInsertedRowID;

- (Database*)initWithDatabaseFileName:(NSString*) databaseFileName;
- (Database*)initWithDatabaseFileName:(NSString*)databaseFileName andTableName:(NSString*) tableName;

- (void)openDatabase;
- (void)closeDatabase;
- (NSString*)getDBVersion;
- (NSString*)getDBPath;

// SQL Queries
- (void)execQuery:(NSString*) query;

- (NSArray*)loadDataFromDB:(NSString*)query;

@end
