//
//  AddsupplierViewController.m
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AddsupplierViewController.h"

@interface AddsupplierViewController ()<UITextViewDelegate>

{
    UIView *_editbgView;
    NSDictionary *_suppliermessage;
}

@end

@implementation AddsupplierViewController

- (void)dealloc
{
    self.view = nil;
    _suppliermessage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAddsupplierUI];
    
    if (_issupplier) {
        if (_supplierdic == nil) {
            [self naviTitleWhiteColorWithText:@"供应商新增"];
        } else{
            [self naviTitleWhiteColorWithText:[NSString stringWithFormat:@"供应商详情"]];
        }
    } else {
        if (_supplierdic == nil) {
            [self naviTitleWhiteColorWithText:@"客户新增"];
        } else{
            [self naviTitleWhiteColorWithText:[NSString stringWithFormat:@"客户详情"]];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (int i = 0; i < 4; i++) {
        UITextField *textfield = (UITextField *)[_editbgView viewWithTag:3100 + i];
        if ([textfield isFirstResponder]) {
            [textfield resignFirstResponder];
        }
    }
    
    
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


#pragma mark - 绘制UI
- (void)initAddsupplierUI
{
    _editbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 280)];
    _editbgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_editbgView];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5 + 45 * i, 60, 30)];
        label.font = MainFont;
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(80, 7.5 + 45 * i, KScreenWidth - 90, 30)];
        textfield.borderStyle = UITextBorderStyleNone;
        [textfield setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.textColor = ExtraTitleColor;
        textfield.font = MainFont;
        textfield.tag = 3100 + i;
        [_editbgView addSubview:textfield];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44 * (i + 1), KScreenWidth, .5)];
        [_editbgView addSubview:lineView];
        
        if (_supplierdic != nil) {
            if (i == 0) {
                textfield.text = [_supplierdic valueForKey:@"name"];
            } else if (i == 1) {
                textfield.text = [_supplierdic valueForKey:@"lxr"];
            } else if (i == 2) {
                textfield.text = [_supplierdic valueForKey:@"lxhm"];
            } else if (i == 3) {
                textfield.text = [_supplierdic valueForKey:@"dz"];
            }
        }
        if (i == 0) {
            if (_issupplier) {
                textfield.placeholder = @"请输入供应商名称";
            } else {
                textfield.placeholder = @"请输入客户名称";
            }
            label.text = @"名称";
        } else if (i == 1) {
            textfield.placeholder = @"请输入联系人";
            label.text = @"联系人";
        } else if (i == 2) {
            textfield.placeholder = @"请输入电话";
            label.text = @"电话";
        } else if (i == 3) {
            textfield.placeholder = @"请输入联系地址";
            label.text = @"地址";
        }
        [_editbgView addSubview:label];
    }
    
    UILabel *commentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5 + 180, 60, 30)];
    commentlabel.font = MainFont;
    commentlabel.text = @"备注";
    [_editbgView addSubview:commentlabel];
    
    UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(70 + 40, 7.5 + 180, KScreenWidth - 120, 85)];
    commentTextView.textAlignment = NSTextAlignmentRight;
    commentTextView.tag = 3104;
    commentTextView.font = MainFont;
    commentTextView.delegate = self;
    commentTextView.textColor = ExtraTitleColor;
    [_editbgView addSubview:commentTextView];
    
    UILabel *textplacerlabel = [[UILabel alloc] initWithFrame:CGRectMake(70 + 40, 7.5 + 185, KScreenWidth - 125, 20)];
    textplacerlabel.tag = 3105;
    textplacerlabel.font = [UIFont systemFontOfSize:14];
    textplacerlabel.textColor = ColorRGB(190, 190, 205);
    textplacerlabel.textAlignment = NSTextAlignmentRight;
    textplacerlabel.enabled = NO;//lable必须设置为不可用
    textplacerlabel.backgroundColor = [UIColor clearColor];
    [_editbgView addSubview:textplacerlabel];
    
    NSString *comment = [_supplierdic valueForKey:@"comments"];
    if (comment.length != 0) {
        commentTextView.text = comment;
        textplacerlabel.text = @"";
    } else {
        textplacerlabel.text = @"请输入备注内容";
    }
    
    
    UIButton *uploadsupplier = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadsupplier addTarget:self action:@selector(uploadsupplier) forControlEvents:UIControlEventTouchUpInside];
    uploadsupplier.frame = CGRectMake(0, 11, 30, 20);
    [uploadsupplier setTitle:@"保存" forState:UIControlStateNormal];
    uploadsupplier.titleLabel.font = RightTitleFont;
    [uploadsupplier setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:uploadsupplier];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.view addSubview:uploadsupplier];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *textplacerlabel = [_editbgView viewWithTag:3105];
    if (textView.text.length == 0) {
        textplacerlabel.text = @"请输入备注内容";
    }else{
        textplacerlabel.text = @"";
    }
}

#pragma mark - 新增供应商
- (void)uploadsupplier
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *addsupplierORcostumerURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_issupplier) {
        addsupplierORcostumerURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_addsupplier];
    } else {
        addsupplierORcostumerURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_addcustomer];
    }
    
    if (_supplierdic == nil) {
        [params setObject:@(-1) forKey:@"id"];
    } else {
        NSInteger supplierid = [[_supplierdic valueForKey:@"id"] integerValue];
        [params setObject:@(supplierid) forKey:@"id"];
    }

    UITextField *nametextfield = (UITextField *)[_editbgView viewWithTag:3100];
    UITextField *lxrtextfield = (UITextField *)[_editbgView viewWithTag:3101];
    UITextField *lxhmtextfield = (UITextField *)[_editbgView viewWithTag:3102];
    UITextField *dztextfield = (UITextField *)[_editbgView viewWithTag:3103];
    UITextView *commentTextView = (UITextView *)[_editbgView viewWithTag:3104];
    if (nametextfield.text.length == 0) {
        [BasicControls showAlertWithMsg:@"名称不能为空" addTarget:nil];
    } else if (lxrtextfield.text.length == 0) {
        [BasicControls showAlertWithMsg:@"联系人不能为空" addTarget:nil];
    } else {
        [params setObject:nametextfield.text forKey:@"name"];
        [params setObject:lxrtextfield.text forKey:@"lxr"];
        [params setObject:lxhmtextfield.text forKey:@"lxhm"];
        [params setObject:dztextfield.text forKey:@"dz"];
        [params setObject:commentTextView.text forKey:@"comments"];
        [self showProgress];
        [XPHTTPRequestTool reloadMothedWithPost:addsupplierORcostumerURL params:params success:^(id responseObject) {
            [self hideProgress];
            [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self hideProgress];
        }];
        
        
    }
}

@end
