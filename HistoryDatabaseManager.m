//
//  HistoryDatabaseManager.m
//  AddressOCR
//
//  Created by Aadesh Patel on 12/26/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import "HistoryDatabaseManager.h"
#import <sqlite3.h>

@interface HistoryDatabaseManager()

@property (nonatomic, strong) NSString *directory;
@property (nonatomic, strong) NSString *databaseName;
- (void)copyDatabaseIntoDirectory;

@property (nonatomic, strong) NSMutableArray *result;
- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)isExecutable;

@end

@implementation HistoryDatabaseManager

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _directory = [paths objectAtIndex:0];
        
        _databaseName = databaseName;
        [self copyDatabaseIntoDirectory];
    }
    
    return self;
}

- (void)copyDatabaseIntoDirectory {
    NSString *dest = [_directory stringByAppendingPathComponent:_databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dest]) {
        NSString *source = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_databaseName];
        
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:dest error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)isExecutable {
    sqlite3 *sqlite3Database;
    
    NSString *database = [_directory stringByAppendingPathComponent:_databaseName];
    
    if (_result) {
        [_result removeAllObjects];
        _result = nil;
    }
    _result = [[NSMutableArray alloc] init];
    
    if (self.columns) {
        [self.columns removeAllObjects];
        self.columns = nil;
    }
    self.columns = [[NSMutableArray alloc] init];
    
    BOOL openDatabase = sqlite3_open([database UTF8String], &sqlite3Database);
    if (openDatabase == SQLITE_OK) {
        sqlite3_stmt *stmt;
        
        BOOL prepareResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &stmt, NULL);
        if (prepareResult == SQLITE_OK) {
            if (!isExecutable) {
                NSMutableArray *rowData;
                
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    rowData = [[NSMutableArray alloc] init];
                    
                    int numOfcols = sqlite3_column_count(stmt);
                    for (int c = 0; c < numOfcols; c++) {
                        char *dataAsChar = (char *)sqlite3_column_text(stmt, c);
                        if (dataAsChar)
                            [rowData addObject:[NSString stringWithUTF8String:dataAsChar]];
                        
                        if (self.columns.count != numOfcols) {
                            dataAsChar = (char *)sqlite3_column_name(stmt, c);
                            [self.columns addObject:[NSString stringWithUTF8String:dataAsChar]];
                        }
                    }
                    
                    if (rowData.count > 0)
                        [_result addObject:rowData];
                }
            } else {
                BOOL executableQueryResults = sqlite3_step(stmt);
                
                if (executableQueryResults == SQLITE_DONE) {
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                } else
                    NSLog(@"DATABASE ERROR: %s", sqlite3_errmsg(sqlite3Database));
            }
        } else
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        
        sqlite3_finalize(stmt);
    }
    
    sqlite3_close(sqlite3Database);
}

- (NSArray *)loadData:(NSString *)query {
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    return (NSArray *)_result;
}

- (void)executeQuery:(NSString *)query {
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
