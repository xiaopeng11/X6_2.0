//
//  ChangeHeaderViewViewController.m
//  project-x6
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChangeHeaderViewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PersonViewController.h"
@interface ChangeHeaderViewViewController ()

@end

@implementation ChangeHeaderViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化子视图
    [self initWithSubViews];
}

/**
 *  初始化子视图
 */
- (void)initWithSubViews
{
    _HeaderView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 90) / 2, 35, 90, 90)];
    _HeaderView.clipsToBounds = YES;
    _HeaderView.layer.cornerRadius = 45;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    //员工头像地址
    NSString *headerURLString = nil;

    if ([[userInformation allKeys] containsObject:@"apppwd"]) {
        headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,[userInformation valueForKey:@"userpic"]];
    } else {
        headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,[userInformation valueForKey:@"userpic"]];
    }
    if (headerURLString) {
        [_HeaderView sd_setImageWithURL:[NSURL URLWithString:headerURLString] placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
    }
    [self.view addSubview:_HeaderView];
    
    //按钮
    NSArray *buttonTitles = @[@"拍照",@"相册",@"确定"];
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, _HeaderView.bottom + 38 + 60 * i, KScreenWidth - 100, 45);
        button.layer.cornerRadius = 4;
        button.backgroundColor = Mycolor;
        button.titleLabel.font = TitleFont;
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 600 + i;
        [button addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

#pragma mark - 按钮事件
- (void)headerAction:(UIButton *)button
{
    //创建相册控制器
    UIImagePickerController *imagepiker = [[UIImagePickerController alloc] init];
    imagepiker.delegate = self;
    imagepiker.allowsEditing = YES;
    if (button.tag == 600) {
        //拍照按钮
        imagepiker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagepiker animated:YES completion:nil];
    } else if (button.tag == 601) {
        //点击相册按钮
        imagepiker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagepiker animated:YES completion:nil];
    } else {
        //确定
        [self unloadHeaderView];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取所选的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //显示图片
    _HeaderView.image = image;

    //压缩图片大小
    image = [self imageCompressForWidth:image targetWidth:100];
    //保存在沙河中
    [self saveImage:image withName:@"image.png"];
    //上传图片
    _uuid = [[NSUUID UUID] UUIDString];
    NSString *Path = [ImageFile stringByAppendingPathComponent:@"image.png"];
    [self unloadFileWithUuid:_uuid Filepath:Path FileName:@"image.png" group:nil];
    
}


#pragma mark - 重写返回按钮
- (void)backAction:(UIButton *)button
{
    //关闭当前视图
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - unloadHeaderView
- (void)unloadHeaderView
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInformation = [NSMutableDictionary dictionaryWithDictionary:[userdefaults objectForKey:X6_UserMessage]];
    NSString *useid = [userInformation objectForKey:@"id"];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *headerImageURL;
    if ([[userInformation allKeys] containsObject:@"apppwd"]) {
        headerImageURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_changeygHeaderView];
    } else {
        headerImageURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_changeUserHeaderView];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:useid forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%@_image.png",_uuid] forKey:@"pic"];
    
    [XPHTTPRequestTool requestMothedWithPost:headerImageURL params:params success:^(id responseObject) {
        //上传成功
        [self deleteImageFile];
        //更新本地个人信息的头像地址
        
        [userInformation setObject:[NSString stringWithFormat:@"%@_image.png",_uuid] forKey:@"userpic"];
        [userdefaults setObject:userInformation forKey:X6_UserMessage];
        [userdefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeaderView" object:nil];

//        NSArray *allControllers = self.navigationController.viewControllers;
//        PersonViewController *parent = [allControllers objectAtIndex:[allControllers count]-2];
//        [parent.personTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"头像上传失败");
    }];
}



@end
