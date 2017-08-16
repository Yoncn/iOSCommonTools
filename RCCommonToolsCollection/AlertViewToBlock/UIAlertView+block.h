//
//  UIAlertView+block.h
//  JusTalk
//
//  Created by rongchen on 2017/5/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (block)

typedef void (^ClickAtIndexBlock)(NSInteger buttonIndex);


+(UIAlertView *)initBlockWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons clickAtIndex:(ClickAtIndexBlock) clickAtIndex;

@end
