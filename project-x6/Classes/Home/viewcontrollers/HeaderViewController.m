//
//  HeaderViewController.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HeaderViewController.h"
#import "HomeModel.h"
#import "PersonsModel.h"

#import "ChatViewController.h"
#import "HomeTableView.h"

#define ThirdPcentWidth ((KScreenWidth - 1) / 3)
@interface HeaderViewController ()

{
    UIView *_bgView;
    HomeTableView *_personTableView;
    double _page;
    double _pages;
}

@property(nonatomic,strong)NoDataView *noDynamicView; //没有动态提示
@property(nonatomic,assign)BOOL isConcerned;          //是否被关注
@end

@implementation HeaderViewController

- (NoDataView *)noDynamicView
{
    if (!_noDynamicView) {
        _noDynamicView = [[NoDataView alloc] initWithFrame:CGRectMake(0, _bgView.bottom, KScreenWidth, KScreenHeight - 64 - _bgView.height)];
        _noDynamicView.text = @"该用户无动态";
        [self.view addSubview:_noDynamicView];
    }
    return _noDynamicView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"个人中心"];
    
    
    //获取数据
    [self getPersonDynamicDataWithPage:1];
    //初始化子视图
    [self initSubViews];
    //是否关注
    [self judgewhetherconcerned];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"头像点击页面收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - 初始化表示图
- (void)initSubViews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130)];
    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = [UIColor whiteColor];
    
    //头像
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 45, 45)];
    UIImageView *cornView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 17.5, 50, 50)];
    cornView.image = [UIImage imageNamed:@"corner_circle"];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    
    //头像
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    NSString *headerpic = [self.dic valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = HeaderBgColorArray;
        
        int x = arc4random() % 10;
        [headerView setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = self.dic[@"name"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [headerView setTitle:lastTwoName forState:UIControlStateNormal];
        headerView.titleLabel.font = ExtitleFont;
    } else {
        NSString *usertypestring;
        if ([[self.dic allKeys] containsObject:@"userType"]) {
            usertypestring = @"userType";
        } else {
            usertypestring = @"usertype";
        }
        if ([[self.dic valueForKey:usertypestring] intValue] == 0) {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[self.dic valueForKey:@"userpic"]];
        } else {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[self.dic valueForKey:@"userpic"]];
        }
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURLString) {
            [headerView sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
            [headerView setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    [_bgView addSubview:headerView];
    [_bgView addSubview:cornView];


    //个人信息
    NSArray *personDetails = @[[_dic valueForKey:@"name"],[_dic valueForKey:@"phone"],[NSString stringWithFormat:@"%@  %@",[_dic valueForKey:@"ssgsname"],[_dic valueForKey:@"gw"]]];
    NSMutableArray *personDetail = [NSMutableArray arrayWithArray:personDetails];
    NSString *phoneString = [_dic valueForKey:@"phone"];
    if (phoneString.length == 0) {
        [personDetail removeObjectAtIndex:1];
    }
    if (personDetail.count == 2) {
        for (int i = 0; i < personDetail.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 20 + 25 * i, KScreenWidth - 75, 20)];
            label.text = personDetail[i];
            if (i < 2) {
                label.font = MainFont;
                label.textColor = [UIColor blackColor];
            } else {
                label.font = ExtitleFont;
                label.textColor = ExtraTitleColor;
            }
            [_bgView addSubview:label];
        }
    } else {
        for (int i = 0; i < personDetail.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 8 + 22 * i, KScreenWidth - 75, 20)];
            label.text = personDetail[i];
            if (i < 2) {
                label.font = MainFont;
                label.textColor = [UIColor blackColor];
            } else {
                label.font = ExtitleFont;
                label.textColor = ExtraTitleColor;
            }
            [_bgView addSubview:label];
        }
    }


    //绘制分割线
    UIView *firstLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 84.5, KScreenWidth, .5)];
    [_bgView addSubview:firstLineView];
    
    for (int i = 1; i < 3; i++) {
        UIView *secondLineView = [BasicControls drawLineWithFrame:CGRectMake(ThirdPcentWidth * i, 84, .5, 45)];
        [_bgView addSubview:secondLineView];
    }

    //个人信息功能－打电话，关注，即时消息
    NSArray *buttonLabel = @[@"拨号",@"消息",@"关注"];
    NSArray *buttonImages = @[@"g4_a",@"g4_b",@"g4_c"];
    for (int i = 0; i < buttonImages.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1300 + i;
        button.frame = CGRectMake(ThirdPcentWidth * i, 85, ThirdPcentWidth, 45);
        
        [button addTarget:self action:@selector(HeaderbuttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [button setImage:[UIImage imageNamed:buttonImages[i]] forState:UIControlStateNormal];//给button添加image
        button.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,13);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        
        [button setTitle:buttonLabel[i] forState:UIControlStateNormal];//设置button的title
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = MainFont;//title字体大小
        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        [_bgView addSubview:button];
    }
    
}

- (void)initTableView
{
    //显示列表
    _personTableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _personTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _personTableView.backgroundColor = GrayColor;
    [_personTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(HeaderViewheaderAction)];
    [_personTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(HeaderViewfooterAction)];
    _personTableView.tableHeaderView = _bgView;
    [self.view addSubview:_personTableView];
    NSMutableArray *array;
    array = [[_datalist mutableCopy] loadframeKeyWithDatalist];
    _personTableView.datalist = array;
    [_personTableView reloadData];
}

#pragma mark - 按钮事件
- (void)HeaderbuttonAction:(UIButton *)button
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    if ([[_dic valueForKey:@"name"] isEqualToString:[dic valueForKey:@"name"]]) {
        if (button.tag == 1300) {
            [BasicControls showAlertWithMsg:@"不能拨打给自己" addTarget:nil];
        } else if (button.tag == 1301) {
            [BasicControls showAlertWithMsg:@"不能发送消息给自己" addTarget:nil];
        } else {
            [BasicControls showAlertWithMsg:@"不能关注自己" addTarget:nil];
        }
    } else {
        if (button.tag == 1300) {
            //判断是否有电话
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",[_dic valueForKey:@"phone"]];
            if (phone.length == 4) {
                [BasicControls showAlertWithMsg:@"当前用户没有手机号码" addTarget:nil];
            } else {
                //打电话
                UIWebView *callWebView = [[UIWebView alloc] init];
                [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
                [self.view addSubview:callWebView];
            }
        } else if (button.tag == 1301) {
            //消息
            NSLog(@"消息");
            if ([[_dic valueForKey:@"hxflag"] intValue] == 1) {
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSString *gsdm = [[userdefaults objectForKey:X6_UserMessage] valueForKey:@"gsdm"];
                NSString *easeID = [NSString stringWithFormat:@"%@%@%@",gsdm,[_dic valueForKey:@"usertype"],[_dic valueForKey:@"phone"]];
                ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:easeID conversationType:eConversationTypeChat];
                chatVC.title = [_dic valueForKey:@"name"];
                //判断是否有联系人数据
                if ([userdefaults objectForKey:X6_Contactlist] == NULL) {
                    dispatch_group_t grouped = dispatch_group_create();
                    dispatch_group_enter(grouped);
                    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
                    NSString *personsURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_persons];
                    [XPHTTPRequestTool requestMothedWithPost:personsURL params:nil success:^(id responseObject) {
                        NSArray *contactList = [PersonsModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"userList"] ignoredKeys:@[@"phone",@"ssgs"]];

                        [self writeContactListDataWithContactlist:contactList];
                        dispatch_group_leave(grouped);
                    } failure:^(NSError *error) {
                        dispatch_group_leave(grouped);
                    }];
                    dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
                        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                        NSMutableArray *contactList = [userdefaults objectForKey:X6_Contactlist];
                        NSLog(@"%@",contactList);
                        [self.navigationController pushViewController:chatVC animated:YES];
                    });
                } else {
                    [self.navigationController pushViewController:chatVC animated:YES];

                }
            } else  {
                [BasicControls showAlertWithMsg:@"该用户还未登录" addTarget:nil];
            }

        } else {
            //关注
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
            NSString *focusURL = [NSString stringWithFormat:@"%@%@",userURL,X6_focus];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (_type) {
                [params setObject:[_dic valueForKey:@"id"] forKey:@"msguserid"];
                [params setObject:[_dic valueForKey:@"usertype"] forKey:@"msgusertype"];
            } else {
                [params setObject:[_dic valueForKey:@"senderid"] forKey:@"msguserid"];
                [params setObject:[_dic valueForKey:@"userType"] forKey:@"msgusertype"];
            }
            [XPHTTPRequestTool requestMothedWithPost:focusURL params:params success:^(id responseObject) {
                //关注成功
                UIButton *concrened = [_bgView viewWithTag:1302];
                if (_isConcerned == NO) {
                    [BasicControls showNDKNotifyWithMsg:@"您已关注" WithDuration:1 speed:1];
                    _isConcerned = YES;
                    [concrened setTitle:@"已关注" forState:UIControlStateNormal];
                    [concrened setImage:[UIImage imageNamed:@"g4_d"] forState:UIControlStateNormal];
                } else {
                    [BasicControls showNDKNotifyWithMsg:@"您已取消关注" WithDuration:1 speed:1];
                    _isConcerned = NO;
                    [concrened setTitle:@"关注" forState:UIControlStateNormal];
                    [concrened setImage:[UIImage imageNamed:@"g4_c"] forState:UIControlStateNormal];
                }
            } failure:^(NSError *error) {
            }];
        }
    }
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)HeaderViewfooterAction
{
    //判断是哪一个表示图
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [self getrefreshdataWithHead:NO];
}

- (void)HeaderViewheaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(HomeTableView *)personTableView
{
    if (personTableView.header.isRefreshing) {
        //正在下拉刷新
        //关闭
        [personTableView.header endRefreshing];
        [personTableView.footer resetNoMoreData];
    } else {
        [personTableView.footer endRefreshing];
    }
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    
    if (head == YES) {
        //是下拉刷新
        [self getPersonDynamicDataWithPage:1];
        
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getPersonDynamicDataWithPage:_page + 1];
        } else {
            [_personTableView.footer noticeNoMoreData];
        }
        
    }
}

#pragma mark - 获取数据
//获取个人动态数据
- (void)getPersonDynamicDataWithPage:(double)page
{
    NSString *userid;
    NSString *userType;
    if (_type) {
        userid = [_dic valueForKey:@"id"];
        userType = [_dic valueForKey:@"usertype"];
    } else {
        userid = [_dic valueForKey:@"senderid"];
        userType = [_dic valueForKey:@"userType"];
    }
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *personDynamicURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_personDynamic];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userid forKey:@"userid"];
    [params setObject:userType forKey:@"usertype"];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    if (!_personTableView.header.isRefreshing || !_personTableView.footer.isRefreshing) {
        [self showProgress];
    }
    [XPHTTPRequestTool requestMothedWithPost:personDynamicURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_personTableView.header.isRefreshing || _personTableView.footer.isRefreshing) {
            [self endrefreshWithTableView:_personTableView];
        }
        
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_personTableView.footer noticeNoMoreData];
        }
        
        
        if (_datalist.count == 0 || _personTableView.header.isRefreshing) {
            _datalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            _datalist = [_datalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        if (_datalist.count == 0) {
            [self noDynamicView];
            
            [self.view addSubview:_bgView];
        } else {
            if (_noDynamicView) {
                _noDynamicView.hidden = YES;
            }
            [self initTableView];
        }
 
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
        [self hideProgress];
    }];
    
}

//判断是否已经关注
- (void)judgewhetherconcerned
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *judgeconcernURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_whetherConcerned];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type) {
        [params setObject:[_dic valueForKey:@"id"] forKey:@"msguserid"];
        [params setObject:[_dic valueForKey:@"usertype"] forKey:@"msgusertype"];
    } else {
        [params setObject:[_dic valueForKey:@"senderid"] forKey:@"msguserid"];
        [params setObject:[_dic valueForKey:@"userType"] forKey:@"msgusertype"];
    }
    [XPHTTPRequestTool requestMothedWithPost:judgeconcernURL params:params success:^(id responseObject) {
        UIButton *concrened = [_bgView viewWithTag:1302];
        if ([responseObject[@"message"] isEqualToString:@"exist"]) {
            _isConcerned = YES;
            [concrened setTitle:@"已关注" forState:UIControlStateNormal];
            [concrened setImage:[UIImage imageNamed:@"g4_d"] forState:UIControlStateNormal];
        } else {
            _isConcerned = NO;
            [concrened setTitle:@"关注" forState:UIControlStateNormal];
            [concrened setImage:[UIImage imageNamed:@"g4_c"] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 将数据写入本地
- (void)writeContactListDataWithContactlist:(NSArray *)contactlist
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *gsdm = [[userdefaults objectForKey:X6_UserMessage] valueForKey:@"gsdm"];
    NSMutableArray *huanxinContacts = [NSMutableArray array];
    
    for (NSDictionary *dic in contactlist) {
        @autoreleasepool {
            NSString *headerURLString,*easeID;
            if ([[dic valueForKey:@"usertype"] intValue] == 0) {
                headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,[dic valueForKey:@"userpic"]];
            } else {
                headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,[dic valueForKey:@"userpic"]];
            }
            easeID = [NSString stringWithFormat:@"%@%@%@",gsdm,[dic valueForKey:@"usertype"],[dic valueForKey:@"phone"]];
            
            NSString *easeNickName = [dic valueForKey:@"name"];
            NSNumber *hxflag = [dic valueForKey:@"hxflag"];
            NSMutableDictionary *FBdic = [NSMutableDictionary dictionary];
            [FBdic setObject:easeID forKey:@"username"];
            [FBdic setObject:headerURLString forKey:@"avatar"];
            [FBdic setObject:easeNickName forKey:@"nickname"];
            [FBdic setObject:hxflag forKey:@"hxflag"];
            [huanxinContacts addObject:FBdic];
        }

    }
    [userdefaults setObject:huanxinContacts forKey:X6_Contactlist];
    [userdefaults synchronize];
    
}

@end
