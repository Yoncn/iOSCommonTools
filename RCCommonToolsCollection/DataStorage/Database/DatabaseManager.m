//
//  DatabaseManager.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/6/5.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "DatabaseManager.h"
#import <sqlite3.h>

@implementation DatabaseManager
{
    sqlite3 *db;
}

+ (instancetype)shareManager {
    static DatabaseManager *databaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[DatabaseManager alloc]init];
    });
    return databaseManager;
}

//是否能打开数据库
- (BOOL)openDatabaseWithDBName:(NSString *)DBName {
    NSString *documentUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [documentUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",DBName]];
    BOOL result = sqlite3_open(fileName.UTF8String, &db);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"打开成功,数据库地址：\n%@",fileName);
    });
    if (result == SQLITE_OK) {
        NSLog(@"打开成功");
        return YES;
    } else {
        NSLog(@"打开失败");
        return NO;
    }
}

//创建表
- (void)createTableWithName:(NSString *)tableName inDB:(NSString *)dbName{
    if ([[DatabaseManager shareManager] openDatabaseWithDBName:dbName]) {
        char *errmsg = NULL;
        NSString *sqliteString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer PRIMARY KEY AUTOINCREMENT, modelName text NOT NULL, modelId text NOT NULL, modelNumber integer NOT NULL);",tableName];
        sqlite3_exec(db, sqliteString.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"创建表失败：%s",errmsg);
        } else {
            NSLog(@"创建表成功");
        }
    }
}

//增
- (BOOL)insertDataToDB:(NSString *)dbName andTableName:(NSString *)tableName withModel:(dataModel *)model {
    if ([[DatabaseManager shareManager] openDatabaseWithDBName:dbName]) {
        NSString *sqliteString = [NSString stringWithFormat:@"INSERT INTO %@(modelName,modelId,modelNumber) VALUES ('%@','%@',%d)",tableName,model.modelName,model.modelId,model.modelNumber];
        char *errmsg = NULL;
        sqlite3_exec(db, sqliteString.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@插入失败\n%s",model.modelName,errmsg);
            return NO;
        } else {
            NSLog(@"%@插入成功",model.modelName);
            return YES;
        }
    }
    return NO;
}

//删 ---- 删表 : drop table if exists 表名 ;  --- 删除表数据 ：delete from t_student;
- (BOOL)deleteDataInDB:(NSString *)dbName andTableName:(NSString *)tableName withModelName:(NSString *)modelName {
    if ([[DatabaseManager shareManager] openDatabaseWithDBName:dbName]) {
        NSString *sqliteString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE modelName = '%@'",tableName,modelName];
        char *errmsg = NULL;
        sqlite3_exec(db, sqliteString.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@删除失败",modelName);
            return NO;
        } else {
            NSLog(@"%@删除成功",modelName);
            return YES;
        }
    }
    return NO;
}


//改
- (BOOL)updateDataInDB:(NSString *)dbName andTableName:(NSString *)tableName withChangemodelName:(NSString *)modelName toModel:(dataModel *)newModel {
    if ([[DatabaseManager shareManager] openDatabaseWithDBName:dbName]) {
        NSString *sqliteString = [NSString stringWithFormat:@"UPDATE %@ set modelId = '%@',modelName = '%@',modelNumber = %d WHERE modelName = '%@'",tableName,newModel.modelId,newModel.modelName,newModel.modelNumber,modelName];
        char *errmsg = NULL;
        sqlite3_exec(db, sqliteString.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@修改失败--%@",modelName,[NSString stringWithUTF8String:errmsg]);
            return NO;
        } else {
            NSLog(@"%@修改成功",modelName);
            return YES;
        }
    }
    return NO;
}

//查
- (NSArray *)selectModelName:(NSString *)modelName InDBName:(NSString *)dbName andTableName:(NSString *)tableName {
    NSMutableArray *resultArray = nil;
    if ([[DatabaseManager shareManager] openDatabaseWithDBName:dbName]) {
        NSString *sqliteString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE modelName = '%@'",tableName,modelName];
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(db, sqliteString.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
            NSLog(@"查询语句没问题");
            
            resultArray = [NSMutableArray array];
            
            //每调一次sqlite3_step函数，stmt就会指向下一条记录
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                //取出第0列的值(序号)
                int ID = sqlite3_column_int(stmt, 0);
                //取出第1列的值
                const unsigned char *name = sqlite3_column_text(stmt, 1);
                //取出第2列的值
                const unsigned char *Id = sqlite3_column_text(stmt, 2);
                //取出第3列的值
                int number = sqlite3_column_int(stmt, 3);
                
                dataModel *model = [[dataModel alloc]init];
                model.modelName = [NSString stringWithUTF8String:(const char*)name];
                model.modelId = [NSString stringWithUTF8String:(const char*)Id];
                model.modelNumber = number;
                [resultArray addObject:model];
            }
        } else {
            NSLog(@"查询语句有问题--%d",sqlite3_prepare_v2(db, sqliteString.UTF8String, -1, &stmt, NULL));
        }
    }
    return resultArray;
}











@end
