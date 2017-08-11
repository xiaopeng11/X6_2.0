//
//  WriteViewController.m
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "WriteViewController.h"
#import "ZLPhoto.h"

#import "StockViewController.h"

#import "GwsViewController.h"
#import "GwsPersonsViewController.h"

#import "CompanysViewController.h"
#import "CompanyPersonsViewController.h"

#define imageWidth ((KScreenWidth - 20 - 15) / 4.0)
@interface WriteViewController ()<ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UITextViewDelegate>


{
    UITextView *_textView;    //输入式图
}

@property(nonatomic,strong)UILabel *atPersonsLabel; //@的联系人文本
@property(nonatomic,copy)UIView *toolView;        //工具栏式图
@property(nonatomic,strong)UISwipeGestureRecognizer *downSwip;  //下拉手势
@property(nonatomic,strong)NSMutableArray *assets;    //图片数组
@property(nonatomic,weak)UIView *imagview;
@property(nonatomic,copy)NSArray *personslist;
@end

@implementation WriteViewController

- (void)dealloc
{
    //销毁监听事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _textView.delegate  = nil;
    _downSwip  = nil;
    
}

- (NSMutableArray *)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (UILabel *)atPersonsLabel
{
    if (_personslist.count != 0) {
        NSString *personString = [NSString string];
        for (NSDictionary *personDic in _personslist) {
            if (personString.length != 0) {
                personString = [NSString stringWithFormat:@"%@,@%@",personString,personDic[@"name"]];
            } else {
                personString = [NSString stringWithFormat:@"@%@",personDic[@"name"]];
            }
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:MainFont};
        CGSize size = [personString boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        _atPersonsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, KScreenWidth - 20, size.height)];
        _atPersonsLabel.numberOfLines = 0;
        _atPersonsLabel.textColor = Mycolor;
        _atPersonsLabel.font = MainFont;
        _atPersonsLabel.text = personString;
        [self.view addSubview:_atPersonsLabel];
    }
    
    return _atPersonsLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
    [self atPersonsLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"发布动态"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHidden:) name:UIKeyboardWillHideNotification object:nil];
    //监听岗位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personsList:) name:@"gwsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personsList:) name:@"gwPersonList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personsList:) name:@"companysList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personsList:) name:@"companyPersonList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personsList:) name:@"stockList" object:nil];
    
    @autoreleasepool {
        //初始化子视图
        [self initViews];
    }
    
}

#pragma mark -  键盘监听事件
- (void)keyboardwillShow:(NSNotification *)noti
{
    //获取键盘的高度
    CGFloat boardHeight = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //获取键盘的大小
    float duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _toolView.transform = CGAffineTransformMakeTranslation(0, - boardHeight);
    }];
    

    [_textView addGestureRecognizer:_downSwip];
    
}

- (void)keyboardwillHidden:(NSNotification *)noti
{
    float duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _toolView.transform = CGAffineTransformIdentity;
    }];
    [_textView removeGestureRecognizer:_downSwip];

}

#pragma mark - 监听通知
- (void)personsList:(NSNotification *)notif
{
    _personslist = nil;
    _personslist = notif.object;
}


#pragma mark - 初始化子视图
- (void)initViews
{
    //输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 190)];
    _textView.delegate = self;
    _textView.clipsToBounds = YES;
    _textView.layer.cornerRadius = 10;
    _textView.font = MainFont;
    [self.view addSubview:_textView];
    
    //图片视图
    CGSize size = CGSizeZero;
    if (_personslist.count != 0) {
        NSString *personString = [NSString string];
        for (NSDictionary *personDic in _personslist) {
            if (personString.length != 0) {
                personString = [NSString stringWithFormat:@"%@,@%@",personString,personDic[@"name"]];
            } else {
                personString = [NSString stringWithFormat:@"@%@",personDic[@"name"]];
            }
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:MainFont};
        size = [personString boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    }
    UIView *imageviews = [[UIView alloc] initWithFrame:CGRectMake(10, 200 + size.height + 30, KScreenWidth - 20, imageWidth)];
    [self.view addSubview:imageviews];
    self.imagview = imageviews;
    [self reloadImageview];
   
    //添加下拉手势
    _downSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwip:)];
    _downSwip.direction = UISwipeGestureRecognizerDirectionDown;
    
    //工具栏式图
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 45, KScreenWidth, 45)];
    _toolView.backgroundColor = GrayColor;
    [self.view addSubview:_toolView];
    
    //添加按钮
    NSArray *buttonNames = @[@"l2_g",@"l2_h",@"g2_c"];
    for (int i = 0; i < buttonNames.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(34 + 50 * i, 10, 30, 25);
        [button setImage:[UIImage imageNamed:buttonNames[i]] forState:UIControlStateNormal];
        button.tag = 300 + i;
        [button addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:button];
    }
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(KScreenWidth - 60, 7.5, 50, 30);
    [playButton setBackgroundColor:ColorRGB(188, 196, 200)];
    playButton.clipsToBounds = YES;
    playButton.layer.cornerRadius = 4;
    playButton.tag = 1993;
    [playButton setTitle:@"发布" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:playButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"写动态页面收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
    
}

#pragma mark - reloadImageview
- (void)reloadImageview
{
    //把视图中的子视图移除
    [self.imagview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 设置图片的张数
    NSUInteger column = 4;
    
    //当上传的图片少于4张时，添加按钮
    NSUInteger assetCount = 0;
    if (self.assets.count < 4) {
        assetCount = self.assets.count + 1;
    } else {
        assetCount = self.assets.count;
    }
    
    for (int i = 0; i < assetCount; i++) {
        NSInteger col = i % column;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.frame = CGRectMake((imageWidth + 5) * col, 1, imageWidth, imageWidth);
        
        if (i == self.assets.count) {

        } else {
            //本地取得照片
            [button setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.imagview addSubview:button];
    }
    
}



//打开本地相册
- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickVC = [[ZLPhotoPickerViewController alloc] init];
    pickVC.maxCount = 4 - self.assets.count;
    pickVC.status = PickerViewShowStatusSavePhotos;
    
    pickVC.callBack = ^(NSArray *status){
        [self.assets addObjectsFromArray:status];
        [self reloadImageview];
        // NSLog(@"%@",status);
        for (int i = 0; i < status.count; i++) {
            id value = status[i];
            NSLog(@"%@",value);
        }
    };
    [pickVC showPickerVc:self];
}

//打开照相机
- (void)openCamera{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVc.maxCount = 4 - self.assets.count;
    cameraVc.callback = ^(NSArray *cameras){
        [self.assets addObjectsFromArray:cameras];
        [self reloadImageview];
        NSLog(@"%@",cameras);
    };
    [cameraVc showPickerVc:self];
}

- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    //pickerBrowser.toView = btn;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.assets.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [self.assets objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    UIButton *btn = self.imagview.subviews[indexPath.row];
    photo.toView = btn.imageView;
    // 缩略图
    photo.thumbImage = btn.imageView.image;
    return photo;
}



#pragma mark - 向下清扫
- (void)downSwip:(UISwipeGestureRecognizer *)swip
{
    [_textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 按钮事件
- (void)toolAction:(UIButton *)button
{
    //设置代理对象
    if (button.tag == 301) {
        //点击的是拍照
        if (self.assets.count == 4) {
            [BasicControls showAlertWithMsg:@"当前最多只能发布4张图片" addTarget:nil];
        } else {
            [self openCamera];
        }
    } else if (button.tag == 300) {
        //点击的是相册
        if (self.assets.count == 4) {
            [BasicControls showAlertWithMsg:@"当前最多只能发布4张图片" addTarget:nil];
        } else {
            [self openLocalPhoto];
        }
    } else {
        NSLog(@"点击了添加联系人的按钮");
        StockViewController *stockVC = [[StockViewController alloc] init];
        if (_personslist.count != 0) {
            [_atPersonsLabel removeFromSuperview];
            _personslist = nil;
        }
        stockVC.type = YES;
        [self.navigationController pushViewController:stockVC animated:YES];
    }
}

- (void)playAction:(UIButton *)button
{
    //判断是否有图片，有图片先上传图片，没有图片直接发送消息
    //判断文本字数是否在限制内
    if (_textView.text.length == 0) {
        [BasicControls showAlertWithMsg:@"您还没有输入文本" addTarget:nil];
    } else if (_textView.text.length > 300) {
        [BasicControls showAlertWithMsg:@"您输入的文本不能大于300个字节" addTarget:nil];
    } else {
        if (self.assets.count == 0) {
            //没有图片
            [self sendMessageWithEnbaleFile:NO];
        } else {
            [self sendMessageWithEnbaleFile:YES];
        }
    }
   
}

#pragma mark - 发送消息
- (void)sendMessageWithEnbaleFile:(BOOL)enableFile;
{
    
    [_textView resignFirstResponder];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *message = [userdefaults objectForKey:X6_UserMessage];
    NSNumber *gsdm = [message valueForKey:@"gsdm"];
    NSString *baseurl = [userdefaults objectForKey:X6_UseUrl];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    //消息体结构
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
    [messageDic setObject:@(-1) forKey:@"id"];
    [messageDic setObject:gsdm forKey:@"gsdm"];
    [messageDic setObject:_textView.text forKey:@"msgcontent"];
    [messageDic setObject:@"" forKey:@"fileprop"];
    [messageDic setObject:@(0) forKey:@"zdrdm"];
    [messageDic setObject:@"" forKey:@"zdrq"];
    [messageDic setObject:@(0) forKey:@"xgrdm"];
    [messageDic setObject:@"" forKey:@"xgrq"];
    [messageDic setObject:@(0) forKey:@"isdelete"];
    [messageDic setObject:@(0) forKey:@"usertype"];
    
    //用户结构数组－－字典
    NSArray *userArray = [NSArray array];
    if (_personslist.count != 0) {
        userArray = _personslist;
        [messageDic setObject:@(1) forKey:@"msgtype"];
    } else {
        [messageDic setObject:@(0) forKey:@"msgtype"];
    }
    
    //文件结构体－－字典
    NSMutableArray *fileArray = [NSMutableArray array];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:messageDic forKey:@"msgMain"];
    [dic setObject:userArray forKey:@"userList"];
    [dic setObject:uuid forKey:@"uuid"];
    
    [self showProgress];

    NSString *sendMessgaeURL = [NSString stringWithFormat:@"%@%@",baseurl,X6_sendMessage];
    //创建线程组－－等待上传图片完成再发布动态
    dispatch_group_t grouped = dispatch_group_create();
    if (enableFile == YES) {
        //先上传文件
        for (int i = 0; i < self.assets.count; i++) {
            UIImage *image = nil;
            if ([self.assets[i] isKindOfClass:[ZLPhotoAssets class]]) {
                image = [self.assets[i] originImage];
            } else {
                image = [self.assets[i] photoImage];
            }
            //上传图片
            NSString *filename = [NSString stringWithFormat:@"fileImage%d.png",i];
            [self saveImage:image withName:filename];
             NSString *filepath = [ImageFile stringByAppendingPathComponent:filename];
            [self unloadFileWithUuid:uuid Filepath:filepath FileName:filename group:grouped];
            //添加到发送列表
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:filename forKey:@"name"];
            [dic setObject:@"" forKey:@"comment"];
            [dic setObject:uuid forKey:@"uuid"];
            [dic setObject:@(0) forKey:@"zdrdm"];
            [dic setObject:@"" forKey:@"zdrq"];
            [fileArray addObject:dic];
        }
        
    }

    dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
        [dic setObject:fileArray forKey:@"fileList"];
        //装换成jsonString
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [params setObject:string forKey:@"postdata"];
        [self showProgressTitle:@"发布中..."];
        [XPHTTPRequestTool requestMothedWithPost:sendMessgaeURL params:params success:^(id responseObject) {
            NSLog(@"发布成功");
            [self hideProgress];
            _personslist = nil;
            [self deleteImageFile];
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"发布成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertcontroller addAction:cancelaction];
            [alertcontroller addAction:okaction];
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
            //发送通知刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableview" object:nil];
            

        } failure:^(NSError *error) {
            [self hideProgress];
        }];
    });

}






#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UIButton *button = [_toolView viewWithTag:1993];
    if (_textView.text.length != 0) {
        [button setBackgroundColor:Mycolor];
    } else {
        [button setBackgroundColor:ColorRGB(188, 196, 200)];
    }
}

@end
