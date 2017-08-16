//
//  RCDatabaseListViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/6/2.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "RCDatabaseListViewController.h"
#import <sqlite3.h>
#import "DatabaseManager.h"
#import "dataModel.h"

#define DBName @"sqliteTest"
#define TableName @"sqliteTestTable"

@interface RCDatabaseListViewController ()

@end

@implementation RCDatabaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}






//增
- (IBAction)SQLite3Save:(id)sender {
    //创建表和数据库
    [[DatabaseManager shareManager] createTableWithName:TableName inDB:DBName];
    //增加model进去
    for (dataModel *model in _dataArray) {
        [[DatabaseManager shareManager] insertDataToDB:DBName andTableName:TableName withModel:model];
    }
}

- (IBAction)SQLite3Delete:(id)sender {
    BOOL result = [[DatabaseManager shareManager] deleteDataInDB:DBName andTableName:TableName withModelName:@"2号模型"];
    if (result) {
        
    } else {
        
    }
}

- (IBAction)SQLite3Change:(id)sender {
    dataModel *model = [[dataModel alloc]init];
    model.modelId = @"替换1";
    model.modelName = @"替换1号模型";
    model.modelNumber = 11;
    [[DatabaseManager shareManager] updateDataInDB:DBName andTableName:TableName withChangemodelName:@"1号模型" toModel:model];
}

- (IBAction)SQLite3Search:(id)sender {
    NSArray *result = [[DatabaseManager shareManager] selectModelName:@"3号模型" InDBName:DBName andTableName:TableName];
    if (result.count > 0) {
        NSLog(@"包含这个字符串的model存在");
    } else {
        NSLog(@"包含这个字符串的model不存在");
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
