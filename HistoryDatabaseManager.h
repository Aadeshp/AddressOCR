//
//  HistoryDatabaseManager.h
//  AddressOCR
//
//  Created by Aadesh Patel on 12/26/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryDatabaseManager : NSObject

- (instancetype)initWithDatabaseName:(NSString *)databaseName;

@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

- (NSArray *)loadData:(NSString *)query;
- (void)executeQuery:(NSString *)query;

@end
