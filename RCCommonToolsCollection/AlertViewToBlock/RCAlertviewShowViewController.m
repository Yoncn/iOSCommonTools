//
//  RCAlertviewShowViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/5/22.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "RCAlertviewShowViewController.h"
#import "UIAlertView+block.h"

@interface RCAlertviewShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation RCAlertviewShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}






- (IBAction)showAlertviewBlock:(id)sender {
    __weak RCAlertviewShowViewController *weakSelf = self;
    [UIAlertView initBlockWithTitle:@"title" message:@"内容内容内容" cancleButtonTitle:@"myCancel" OtherButtonsArray:@[@"一号位",@"二号位"] clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            weakSelf.showLabel.text = @"用户点击了取消";
        } else if (buttonIndex == 1) {
            weakSelf.showLabel.text = @"用户点击了一号位";
        } else if (buttonIndex == 2) {
            weakSelf.showLabel.text = @"用户点击了二号位";
        }
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
