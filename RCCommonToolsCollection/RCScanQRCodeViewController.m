//
//  RCScanQRCodeViewController.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/4/20.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "RCScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScanWidth 0.48*ScreenWidth

@interface RCScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    CAShapeLayer *cropLayer;
}
@property (nonatomic,strong)AVCaptureDevice *QRDevice;
@property (nonatomic,strong)AVCaptureDeviceInput *QRInput;
@property (nonatomic,strong)AVCaptureMetadataOutput *QROutput;
@property (nonatomic,strong)AVCaptureSession *QRSession;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *QRPreview;
@end

@implementation RCScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"扫描二维码";
    [self configUI];
}



- (void)configUI {
    CGRect ScanFrame = CGRectMake((ScreenWidth-ScanWidth)/2, 0.18*ScreenHeight, ScanWidth, ScanWidth);
    [self setCropRect:ScanFrame andFullRect:self.view.bounds andFillColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScanFrame.origin.y-13-15, ScreenWidth, 15)];
    warningLabel.text = @"请把二维码放入框内";
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:warningLabel];
    
    for (int i =0; i < 4; i++) {
        CGRect crossFrame = CGRectMake((ScreenWidth-ScanWidth)/2+(i%2==0?(-5):ScanWidth-(28-5)), 0.18*ScreenHeight+(i<2?(-5):ScanWidth), 28, 5);
        CGRect verticalFrame = CGRectMake((ScreenWidth-ScanWidth)/2+(i%2==0?(-5):ScanWidth), 0.18*ScreenHeight+(i<2?(-5):ScanWidth-(28-5)), 5, 28);
        UIView *crossView = [[UIView alloc]initWithFrame:crossFrame];
        crossView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:crossView];
        UIView *verticalView = [[UIView alloc]initWithFrame:verticalFrame];
        verticalView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:verticalView];
    }
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        AVAuthorizationStatus currentStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (currentStatus == AVAuthorizationStatusNotDetermined) {
            NSLog(@"用户尚未选择是否开启权限");
        } else if (currentStatus == AVAuthorizationStatusRestricted) {
            NSLog(@"此应用没有被授权");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有权限" message:@"您需要在设置中打开相机权限才可以继续操作\n点击设置去修改" delegate:self cancelButtonTitle:@"不开权限" otherButtonTitles:@"设置", nil];
            alert.tag = 222;
            [alert show];
            return;
        } else if (currentStatus == AVAuthorizationStatusDenied) {
            NSLog(@"此应用已被用户拒绝授权");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有权限" message:@"您需要在设置中打开相机权限才可以继续操作\n点击设置去修改" delegate:self cancelButtonTitle:@"不开权限" otherButtonTitles:@"设置", nil];
            alert.tag = 222;
            [alert show];
            return;
        } else if (currentStatus == AVAuthorizationStatusAuthorized) {
            NSLog(@"用户同意授权");
        }
        
    }
    
    
    [self setAVCaptureSetting];
}

-(void)setAVCaptureSetting {
    _QRDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _QRInput = [AVCaptureDeviceInput deviceInputWithDevice:self.QRDevice error:nil];
    _QROutput = [[AVCaptureMetadataOutput alloc]init];
    [_QROutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _QRSession = [[AVCaptureSession alloc]init];
    [_QRSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_QRSession canAddInput:_QRInput]) {
        [_QRSession addInput:_QRInput];
    }
    if ([_QRSession canAddOutput:_QROutput]) {
        [_QRSession addOutput:_QROutput];
    }
    _QROutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    _QRPreview = [AVCaptureVideoPreviewLayer layerWithSession:_QRSession];
    _QRPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _QRPreview.frame = self.view.bounds;
    [self.view.layer insertSublayer:_QRPreview atIndex:0];
    
    [_QROutput setRectOfInterest:CGRectMake((0.18*ScreenHeight)/ScreenHeight,((ScreenWidth-ScanWidth)/2)/ScreenWidth,ScanWidth/ScreenHeight,ScanWidth/ScreenWidth)];
    
    [_QRSession startRunning];
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue = [NSString string];
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"%@",stringValue);
        [_QRSession stopRunning];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"二维码信息" message:stringValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 1111;
        [alert show];
    }
}


- (void)setCropRect:(CGRect)cropRect andFullRect:(CGRect)fullRect andFillColor:(UIColor *)color {
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, fullRect);
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    cropLayer.strokeColor = [UIColor clearColor].CGColor;
    [cropLayer setFillColor:color.CGColor];
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 1111) {
            [_QRSession startRunning];
        }
    } else if (buttonIndex == 1) {
        if (alertView.tag == 222) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
