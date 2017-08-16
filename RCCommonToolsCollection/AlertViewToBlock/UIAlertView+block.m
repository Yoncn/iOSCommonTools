//
//  UIAlertView+block.m
//  JusTalk
//
//  Created by rongchen on 2017/5/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIAlertView+block.h"
#import <objc/runtime.h>

const char *AlertView_Block = "AlertView_Block";
@implementation UIAlertView (block)

-(void)setClickBlock:(ClickAtIndexBlock)block{
    objc_setAssociatedObject(self, AlertView_Block, block, OBJC_ASSOCIATION_COPY);
}
-(ClickAtIndexBlock)clickBlock{
    return objc_getAssociatedObject(self, AlertView_Block);
}

+(UIAlertView *)initBlockWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons clickAtIndex:(ClickAtIndexBlock) clickAtIndex {
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:messge delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles: nil];
    alert.clickBlock = clickAtIndex;
    for (NSString *otherTitle in otherButtons) {
        [alert addButtonWithTitle:otherTitle];
    }
    [alert show];
    return alert;
}
#pragma mark   UIAlertViewDelegate
+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.clickBlock) {
        
        alertView.clickBlock(buttonIndex);
    }
}
+(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}
@end
