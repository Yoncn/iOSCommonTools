//
//  RCCreateQRCodeViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/4/20.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "RCCreateQRCodeViewController.h"

@interface RCCreateQRCodeViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfieldFirstKey;
@property (weak, nonatomic) IBOutlet UITextField *textfieldFirstValue;
@property (weak, nonatomic) IBOutlet UITextField *textfieldSecondKey;
@property (weak, nonatomic) IBOutlet UITextField *textfieldSecondValue;
@property (weak, nonatomic) IBOutlet UITextField *textfieldThirdKey;
@property (weak, nonatomic) IBOutlet UITextField *textfieldThirdValue;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RCCreateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生成二维码";
}



- (IBAction)createQRCodeImage:(id)sender {
    if (self.textfieldFirstKey.text.length || self.textfieldSecondKey.text.length || self.textfieldThirdKey.text.length) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.textfieldFirstKey.text.length) {
            [dic setObject:self.textfieldFirstValue.text forKey:self.textfieldFirstKey.text];
        }
        if (self.textfieldSecondKey.text.length) {
            [dic setObject:self.textfieldSecondValue.text forKey:self.textfieldSecondKey.text];
        }
        if (self.textfieldThirdKey.text.length) {
            [dic setObject:self.textfieldThirdValue.text forKey:self.textfieldThirdKey.text];
        }
        self.imageView.image = [self createNonInterpolatedUIImageWithsize:80 WithDictionary:dic];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请至少输入一对键值对" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}


- (UIImage *)createNonInterpolatedUIImageWithsize:(CGFloat)widthAndHeight WithDictionary:(NSDictionary *)userDic{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDic options:NSJSONWritingPrettyPrinted error:nil];
    [filter setValue:data forKeyPath:@"InputMessage"];
    CIImage *ciImage = [filter outputImage];
    
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
