//
//  DatabaseManager.h
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/6/5.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataModel.h"

@interface DatabaseManager : NSObject
+ (instancetype)shareManager;


- (BOOL)openDatabaseWithDBName:(NSString *)DBName;
- (void)createTableWithName:(NSString *)tableName inDB:(NSString *)dbName;
- (BOOL)insertDataToDB:(NSString *)dbName andTableName:(NSString *)tableName withModel:(dataModel *)model;
- (BOOL)deleteDataInDB:(NSString *)dbName andTableName:(NSString *)tableName withModelName:(NSString *)modelName;
- (BOOL)updateDataInDB:(NSString *)dbName andTableName:(NSString *)tableName withChangemodelName:(NSString *)modelName toModel:(dataModel *)newModel;
- (NSArray *)selectModelName:(NSString *)modelName InDBName:(NSString *)dbName andTableName:(NSString *)tableName;
@end
