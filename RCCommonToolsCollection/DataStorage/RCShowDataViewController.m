//
//  RCShowDataViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/5/31.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "RCShowDataViewController.h"
#import "RCShowDataTableViewCell.h"
#import "dataModel.h"

static NSString *const RCShowDataTableViewCell_Id = @"RCShowDataTableViewCell";
@interface RCShowDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation RCShowDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:RCShowDataTableViewCell_Id bundle:nil] forCellReuseIdentifier:RCShowDataTableViewCell_Id];
    self.tableView.rowHeight = 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    dataModel *model = _dataSource[indexPath.row];
    RCShowDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RCShowDataTableViewCell_Id];
    cell.modelIdLabel.text = model.modelId;
    cell.modelNumberLabel.text = [NSString stringWithFormat:@"%d",model.modelNumber];
    cell.modelNameLabel.text = model.modelName;
    return cell;
}








- (IBAction)NSUserDefaultsShow:(id)sender {
    self.navigationItem.title = @"NSUserDefaults";
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"myData"];
    NSMutableArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.dataSource = [NSMutableArray arrayWithArray:dataArray];
    [self.tableView reloadData];
}


- (IBAction)PlistShow:(id)sender {
    self.navigationItem.title = @"Plist";
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"myData.plist"];
    NSMutableArray *saveArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    _dataSource = [NSMutableArray array];
    for (NSDictionary *dic in saveArray) {
        dataModel *model = [[dataModel alloc]init];
        if (dic[@"modelName"]) {
            model.modelName = dic[@"modelName"];
        }
        if (dic[@"modelId"]) {
            model.modelId = dic[@"modelId"];
        }
        if (dic[@"modelNumber"]) {
            model.modelNumber = ((NSNumber *)dic[@"modelName"]).intValue;
        }
        [_dataSource addObject:model];
    }
    [self.tableView reloadData];
}


- (IBAction)NSCodingShow:(id)sender {
    self.navigationItem.title = @"NSCoding";
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"myDataCoding.plist"];
    _dataSource = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
