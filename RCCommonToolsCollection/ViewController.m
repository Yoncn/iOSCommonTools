//
//  ViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/4/20.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "ViewController.h"
#import "RCCreateQRCodeViewController.h"
#import "RCScanQRCodeViewController.h"
#import "RCAlertviewShowViewController.h"
#import "RCDataStorageMethodsViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *commomToolsArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常用工具汇总";
    _commomToolsArray = @[@"生成二维码",@"扫描二维码",@"封装alertview的delegate成block",@"存储包含自定义model的数组"];
    [self.tableView reloadData];
    

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commomToolsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _commomToolsArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_commomToolsArray[indexPath.row] isEqualToString:@"生成二维码"]) {
        [self createQRCode];
    } else if ([_commomToolsArray[indexPath.row] isEqualToString:@"扫描二维码"]) {
        [self scanQRCode];
    } else if ([_commomToolsArray[indexPath.row] isEqualToString:@"封装alertview的delegate成block"]) {
        [self alertviewToBlock];
    } else if ([_commomToolsArray[indexPath.row] isEqualToString:@"存储包含自定义model的数组"]) {
        [self dataStorageMethods];
    }
}

#pragma mark ---------- Action
-(void)createQRCode
{
    RCCreateQRCodeViewController *createQRCodeVC = [[RCCreateQRCodeViewController alloc]initWithNibName:@"RCCreateQRCodeViewController" bundle:nil];
    [self.navigationController pushViewController:createQRCodeVC animated:YES];
}

-(void)scanQRCode
{
    RCScanQRCodeViewController *scanQRCodeVC = [[RCScanQRCodeViewController alloc]init];
    [self.navigationController pushViewController:scanQRCodeVC animated:YES];
}

- (void)alertviewToBlock {
    RCAlertviewShowViewController *alertviewBlockVC = [[RCAlertviewShowViewController alloc]initWithNibName:@"RCAlertviewShowViewController" bundle:nil];
    [self.navigationController pushViewController:alertviewBlockVC animated:YES];
}

- (void)dataStorageMethods {
    RCDataStorageMethodsViewController *dataStorageVC = [[RCDataStorageMethodsViewController alloc]initWithNibName:@"RCDataStorageMethodsViewController" bundle:nil];
    [self.navigationController pushViewController:dataStorageVC animated:YES];
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
