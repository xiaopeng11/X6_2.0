//
//  ScanStringViewController.m
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ScanStringViewController.h"
#import "BaseTapSound.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanStringTableViewCell.h"

@interface ScanStringViewController ()<AVCaptureMetadataOutputObjectsDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    SystemSoundID soundID;
    float move;
    
    UITableView *_scanStringTableView;
}

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (strong,nonatomic)UIImageView  *qrView;
@property (strong,nonatomic)UIImageView *lineLabel;
@property (strong,nonatomic)NSTimer *lineTimer;
@property (strong,nonatomic)UIView *otherPlatformLoginView;


@end

@implementation ScanStringViewController

- (void)dealloc{
    if ([_lineTimer isValid]) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if (_session) {
        [_session startRunning ];
        if (_lineTimer) {
            [_lineTimer invalidate];
            _lineTimer = nil;
        }
        _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        _lineLabel.hidden = NO;
        
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //导航栏
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    naviView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
    title.text = @"扫描串号";
    title.font = TitleFont;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [naviView addSubview:title];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 25, 34, 34);
    [backButton setImage:[UIImage imageNamed:@"g3_a"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    // Do any additional setup after loading the view.
    move = 1.0;
    //扫描区域宽、高大小
    float ScanWidth = (KScreenWidth - 40);
    float ScanHeight = 89;
    //创建扫描区域框
    _qrView=[[UIImageView alloc] initWithFrame:CGRectMake(20 , 140, ScanWidth, ScanHeight)];
    _qrView.backgroundColor = [UIColor clearColor];
    _qrView.image = [UIImage imageNamed:@"QRImage.png"];
    [self.view addSubview:_qrView];
    
    _lineLabel = [[UIImageView alloc]initWithFrame:CGRectMake(_qrView.frame.origin.x+2.0, _qrView.frame.origin.y + 2.0, _qrView.frame.size.width - 4.0, 3.0)];
    _lineLabel.image = [UIImage imageNamed:@"QRLine.png"];
    [self.view  addSubview:_lineLabel];
    
    
    //半透明背景
    UIView *qrBacView = [[UIView alloc] init];//上
    qrBacView.frame = CGRectMake(0, 64, KScreenWidth, _qrView.frame.origin.y - 64);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view  addSubview:qrBacView];
    
    qrBacView = [[UIView alloc] init];//左
    qrBacView.frame = CGRectMake(0, _qrView.frame.origin.y, _qrView.frame.origin.x,ScanHeight);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view  addSubview:qrBacView];
    
    qrBacView = [[UIView alloc] init];//下
    qrBacView.frame = CGRectMake(0, _qrView.frame.origin.y + ScanHeight, KScreenWidth, KScreenHeight - _qrView.frame.origin.y - ScanHeight);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view  addSubview:qrBacView];
    
    qrBacView = [[UIView alloc] init];//右
    qrBacView.frame = CGRectMake(_qrView.frame.origin.x + ScanWidth, _qrView.frame.origin.y, KScreenWidth - _qrView.frame.origin.x - ScanWidth, ScanHeight);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    if (_scanStringDatalist.count == 0) {
        _scanStringDatalist = [NSMutableArray array];
    }
        
    [self canUseSystemCamera];

    _scanStringTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, KScreenWidth, KScreenHeight - 365) style:UITableViewStylePlain];
    _scanStringTableView.delegate =self;
    _scanStringTableView.dataSource = self;
    _scanStringTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _scanStringTableView.backgroundColor = [UIColor clearColor];
    _scanStringTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_scanStringTableView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"扫描完毕" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:Mycolor];
    sureButton.frame = CGRectMake(10, KScreenHeight - 55, KScreenWidth - 20, 45);
    sureButton.clipsToBounds = YES;
    sureButton.layer.cornerRadius = 4;
    [sureButton addTarget:self action:@selector(saveScanDatalist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - 返回
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//创建扫描
- (void)createQRView{
    
    //扫描区域宽、高大小
    float ScanWidth = (KScreenWidth - 40);
    float ScanHeight = 89;
    
    //手电筒开关
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_qrView.frame.origin.x + ScanWidth/2.0 - 20, _qrView.frame.origin.y + _qrView.frame.size.height + 20, 40, 40);
    btn.selected = NO;
    //    [btn setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    //    [btn setTitle:@"关闭闪光灯" forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"ocr_flash-off.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ocr_flash-on.png"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue ()];
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]){
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]){
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //设置扫描有效区域(上、左、下、右)
    [_output setRectOfInterest : CGRectMake (( _qrView.frame.origin.y )/ KScreenHeight,(_qrView.frame.origin.x)/ KScreenWidth , ScanHeight / KScreenHeight, (KScreenWidth - 20) / KScreenWidth)];
    // Preview
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    _preview.frame = self.view.layer.bounds ;
    [self.view.layer insertSublayer:_preview atIndex:0];
    // Start
    [_session startRunning];
    
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
}

- (void)leftButtonHaveClick:(UIButton *)sender{
    if ([_lineTimer isValid]) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)moveLine{
    float upY = _qrView.frame.origin.y + _qrView.frame.size.height - 2.0 - 3.0;
    float y = _lineLabel.frame.origin.y;
    y = y+move;
    CGRect lineFrame=CGRectMake(_lineLabel.frame.origin.x, y, _qrView.frame.size.width - 4.0, 3.0);
    _lineLabel.frame = lineFrame;
    if (y < _qrView.frame.origin.y + 2.0 || y > upY) {
        move = -move;
    }
    
}


//扫描成功后的代理方法
- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    NSString *stringValue;//扫描结果
    if ([metadataObjects count] > 0 ){
        // 停止扫描
        [_session stopRunning];
        if ([_lineTimer isValid]) {
            [_lineTimer invalidate];
            _lineTimer = nil;
            _lineLabel.hidden = YES;
        }
        [[BaseTapSound shareTapSound]playSystemSound];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        stringValue = metadataObject.stringValue ;
        
        if ([_scanStringDatalist containsObject:stringValue]) {
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"该串号已存在，是否重复添加?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_scanStringDatalist insertObject:stringValue atIndex:0];
                [_scanStringTableView reloadData];
            }];
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertcontroller addAction:cancelaction];
            [alertcontroller addAction:okaction];
            [self presentViewController:alertcontroller animated:YES completion:nil];
        } else {
            [_scanStringDatalist insertObject:stringValue atIndex:0];
            [_scanStringTableView reloadData];
        }
        [self startingQRCode];

    }
}


- (void)openOrClose:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([sender isSelected]) {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device unlockForConfiguration];
    }else{
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    }
}


- (void)canUseSystemCamera{
    if (![BaseTapSound ifCanUseSystemCamera]) {
        _lineLabel.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此应用已被禁用系统相机" message:@"请在iPhone的 \"设置->隐私->相机\" 选项中,允许 \"飞熊视频\" 访问你的相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        alert.tag = 100;
        [alert show];
    }else{
        _lineLabel.hidden = NO;
        [self createQRView];
    }
}


- (void)startingQRCode{
    if (self.session) {
        [self.session startRunning ];
        if (self.lineTimer) {
            [self.lineTimer invalidate];
            self.lineTimer = nil;
        }
        self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        self.lineLabel.hidden = NO;
    }
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scanStringDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodThingcellid = @"goodThingcellid";
    ScanStringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodThingcellid];
    if (cell == nil) {
        cell = [[ScanStringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodThingcellid];
    }
    cell.things = _scanStringDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_scanStringDatalist removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}

#pragma mark - 保存数据
- (void)saveScanDatalist
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanDatalist" object:_scanStringDatalist];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
