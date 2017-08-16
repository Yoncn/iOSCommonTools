//
//  RCDataStorageMethodsViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/5/27.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "RCDataStorageMethodsViewController.h"
#import "dataModel.h"
#import "RCShowDataViewController.h"
#import "RCDatabaseListViewController.h"

@interface RCDataStorageMethodsViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation RCDataStorageMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        dataModel * model = [[dataModel alloc]init];
        model.modelName = [NSString stringWithFormat:@"%d号模型",i];
        model.modelId = [NSString stringWithFormat:@"编号%d",i];
        model.modelNumber = i;
        [_dataArray addObject:model];
    }
}







//需要将model遵循NSCoding并具备归档解档操作
- (IBAction)NSUserDefaultsSave:(id)sender {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"myData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    RCShowDataViewController *showDataVC = [[RCShowDataViewController alloc]initWithNibName:@"RCShowDataViewController" bundle:nil];
    [self.navigationController pushViewController:showDataVC animated:YES];
}

//Plist存储自定义model需要实现将model转为字典
- (IBAction)PlistSave:(id)sender {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"myData.plist"];
    NSMutableArray *saveArray = [NSMutableArray array];
    for (dataModel *model in _dataArray) {
        [saveArray addObject:[model changeModelToDictionary]];
    }
    NSLog(@"%d",[saveArray writeToFile:filePath atomically:YES]);
    RCShowDataViewController *showDataVC = [[RCShowDataViewController alloc]initWithNibName:@"RCShowDataViewController" bundle:nil];
    [self.navigationController pushViewController:showDataVC animated:YES];
}


- (IBAction)NSCodingSave:(id)sender {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"myDataCoding.plist"];
    [NSKeyedArchiver archiveRootObject:_dataArray toFile:filePath];
    RCShowDataViewController *showDataVC = [[RCShowDataViewController alloc]initWithNibName:@"RCShowDataViewController" bundle:nil];
    [self.navigationController pushViewController:showDataVC animated:YES];
}


- (IBAction)DatabaseSave:(id)sender {
    RCDatabaseListViewController *databaseVC = [[RCDatabaseListViewController alloc]initWithNibName:@"RCDatabaseListViewController" bundle:nil];
    databaseVC.dataArray = _dataArray;
    [self.navigationController pushViewController:databaseVC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
