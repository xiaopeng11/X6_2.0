//
//  TimeGroupChooseViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TimeGroupChooseViewController.h"
#import "JPUSHService.h"

#import "CostumMorePickerView.h"
#import "CostumPickerView.h"

@interface TimeGroupChooseViewController ()

{
    UIButton *_SubscribeButton;
    CostumPickerView *_rbDatePicker;
    CostumMorePickerView *_LastDatePicker;
}
@end

@implementation TimeGroupChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"设置时间"];
    
    [self drawTimeGroupChooseUI];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"订阅" target:self action:@selector(sureTimeGroupsetSubscriptionDate)];
    
    
    

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

#pragma mark - drawTimeGroupChooseUI
- (void)drawTimeGroupChooseUI
{
    _SubscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _SubscribeButton.frame = CGRectMake(0, 228 + 20, KScreenWidth, 44);
    _SubscribeButton.backgroundColor = [UIColor whiteColor];
    _SubscribeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_SubscribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
    [_SubscribeButton setTitleColor:Mycolor forState:UIControlStateNormal];
    [_SubscribeButton addTarget:self action:@selector(deleteSetSubscriptionDate) forControlEvents:UIControlEventTouchUpInside];
    _SubscribeButton.hidden = YES;
    [self.view addSubview:_SubscribeButton];

    
    if ([self.timeSelect isEqualToString:@"选择时间"]) {
        _SubscribeButton.hidden = YES;

        NSDateFormatter *dateForm = [NSDateFormatter new];
        if (self.timeChooseType == 0) {
            [dateForm setDateFormat:@"HH:mm"];
            self.timeSelect = [dateForm stringFromDate:[NSDate date]];
        } else if (self.timeChooseType == 1) {
            [dateForm setDateFormat:@"EEE_HH"];
            NSString *string = [BasicControls turnEnglishToChineseWithWeek:[[dateForm stringFromDate:[NSDate date]] substringToIndex:2]];
            self.timeSelect = [NSString stringWithFormat:@"%@_%@:00",string,[[dateForm stringFromDate:[NSDate date]] substringFromIndex:3]];
        } else if (self.timeChooseType == 2) {
            [dateForm setDateFormat:@"dd_HH"];
            self.timeSelect = [NSString stringWithFormat:@"%@日_%@:00",[[dateForm stringFromDate:[NSDate date]] substringToIndex:2],[[dateForm stringFromDate:[NSDate date]] substringFromIndex:3]];
        }
    } else {
        _SubscribeButton.hidden = NO;
    }
    
    NSMutableArray *data = [NSMutableArray array];
    if (self.timeChooseType == 0) {
        for (int i = 8; i < 23; i++) {
            NSString *time = [NSString stringWithFormat:@"%d:00",i];
            [data addObject:time];
        }
        _rbDatePicker = [[CostumPickerView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, 228) Date:data IndexStr:self.timeSelect];
        [_rbDatePicker selectDay];
        _rbDatePicker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_rbDatePicker];
    } else {
        NSMutableArray *times = [NSMutableArray array];
        for (int i = 8; i < 23; i++) {
            NSString *time = [NSString stringWithFormat:@"%d:00",i];
            [times addObject:time];
        }
        if (self.timeChooseType == 1) {
            NSArray *weeks = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
            data = [NSMutableArray arrayWithObjects:weeks,times, nil];
            _LastDatePicker = [[CostumMorePickerView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, 228) Date:data IndexStr:self.timeSelect Key:@"_"];
            [_LastDatePicker selectDay];
            _LastDatePicker.backgroundColor = [UIColor whiteColor];
        } else {
            NSMutableArray *months = [NSMutableArray array];
            for (int i = 1; i < 32; i++) {
                NSString *month = [NSString stringWithFormat:@"%d日",i];
                [months addObject:month];
            }
            data = [NSMutableArray arrayWithObjects:months,times, nil];
            _LastDatePicker = [[CostumMorePickerView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, 228) Date:data IndexStr:self.timeSelect Key:@"_"];
            [_LastDatePicker selectDay];
            _LastDatePicker.backgroundColor = [UIColor whiteColor];
        }
        [self.view addSubview:_LastDatePicker];
        
    }

}

#pragma mark - 确定订阅
- (void)sureTimeGroupsetSubscriptionDate
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *SetSubscriptionDateURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SetSubscriptionDate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *subTime;
    if (_timeChooseType == 0) {
        [params setObject:@"xsrb" forKey:@"subtype"];
        subTime = [[_rbDatePicker.dateStr substringWithRange:NSMakeRange(0, _rbDatePicker.dateStr.length - 3)] mutableCopy];
    } else {
        NSString *dateString = _LastDatePicker.dateStr;
        if (_timeChooseType == 1) {
            [params setObject:@"xszb" forKey:@"subtype"];
            NSMutableString *week = [BasicControls turnChineseToNumWithWeek:[dateString substringToIndex:3]];
            NSString *time = [dateString substringWithRange:NSMakeRange(4, dateString.length - 7)];
            subTime = [NSString stringWithFormat:@"%@,%@",week,time];
        } else {
            [params setObject:@"xsyb" forKey:@"subtype"];
            NSArray *month = [dateString componentsSeparatedByString:@"日"];
            NSArray *time = [dateString componentsSeparatedByString:@"_"];
            NSMutableString *timeStr = [time[1] mutableCopy];
            subTime = [NSString stringWithFormat:@"%@,%@",month[0],[timeStr substringWithRange:NSMakeRange(0, timeStr.length - 3)]];
        }
    }
    [params setObject:subTime forKey:@"subTime"];
    [XPHTTPRequestTool requestMothedWithPost:SetSubscriptionDateURL params:params success:^(id responseObject) {
        //设置极光tags
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *loaddictionary = [userdefaluts valueForKey:X6_UserMessage];
            NSString *ssgs = [loaddictionary valueForKey:@"ssgs"];
            NSArray *qxlist = [userdefaluts objectForKey:X6_UserQXList];
            NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:ssgs, nil];
            for (NSDictionary *dic in qxlist) {
                if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        [set addObject:@"XJXC"];
                    }
                } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]){
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        [set addObject:@"CGJJ"];
                    }
                } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]){
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        [set addObject:@"LSXJ"];
                    }
                }
            }
            if (_timeChooseType == 0) {
                [self.JPushTag setObject:[NSString stringWithFormat:@"XSRB_%@",subTime] forKey:@"xsrb"];
            } else if (_timeChooseType == 1) {
                NSArray *week = [subTime componentsSeparatedByString:@","];
                [self.JPushTag setObject:[NSString stringWithFormat:@"XSZB_%@_%@",week[0],week[1]] forKey:@"xszb"];
            } else if (_timeChooseType == 2) {
                NSArray *month = [subTime componentsSeparatedByString:@","];
                [self.JPushTag setObject:[NSString stringWithFormat:@"XSYB_%@_%@",month[0],month[1]] forKey:@"xsyb"];
            }
            for (NSString *subscir in [self.JPushTag allValues]) {
                [set addObject:subscir];
            }
            [JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"极光的tags：%@,返回的状态吗：%d",iTags,iResCode);
            }];
        });
        if (_timeChooseType == 0) {
            [BasicControls showNDKNotifyWithMsg:@"您已成功订阅日报" WithDuration:1 speed:1];
        } else if (_timeChooseType == 1) {
            [BasicControls showNDKNotifyWithMsg:@"您已成功订阅周报" WithDuration:1 speed:1];
        } else if (_timeChooseType == 2) {
            [BasicControls showNDKNotifyWithMsg:@"您已成功订阅月报" WithDuration:1 speed:1];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {

    }];
}

//取消订阅
- (void)deleteSetSubscriptionDate
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *deleteSubscriptionDateURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_deleteSetSubscriptionDate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *string;
    if (_timeChooseType == 0) {
        string = @"xsrb";
    } else if (_timeChooseType == 1) {
        string = @"xszb";
    } else {
        string = @"xsyb";
    }
    [params setObject:string forKey:@"subtype"];
    [XPHTTPRequestTool requestMothedWithPost:deleteSubscriptionDateURL params:params success:^(id responseObject) {
        NSLog(@"取消订阅成功");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //设置极光tags
            NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *loaddictionary = [userdefaluts valueForKey:X6_UserMessage];
            NSString *ssgs = [loaddictionary valueForKey:@"ssgs"];
            NSArray *qxlist = [userdefaluts objectForKey:X6_UserQXList];
            NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:ssgs, nil];
            
            for (NSDictionary *dic in qxlist) {
                if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        [set addObject:@"XJXC"];
                    }
                } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]){
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        [set addObject:@"CGJJ"];
                    }
                } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]){
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        [set addObject:@"LSXJ"];
                    }
                }
            }
            NSMutableDictionary *pushtag = [NSMutableDictionary dictionaryWithDictionary:self.JPushTag];
            if (self.timeChooseType == 0) {
                [pushtag removeObjectForKey:@"xsrb"];
            } else if (self.timeChooseType == 1) {
                [pushtag removeObjectForKey:@"xszb"];
            } else {
                [pushtag removeObjectForKey:@"xsyb"];
            }
            for (NSMutableString *scbscri in [pushtag allValues]) {
                NSMutableString *mutDtri = [NSMutableString stringWithString:scbscri];
                if ([mutDtri containsString:@":00"]) {
                    [mutDtri replaceCharactersInRange:NSMakeRange(mutDtri.length - 3, 3) withString:@""];
                }
                [set addObject:mutDtri];
            }
            [JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"极光的tags：%@,返回的状态吗：%d",iTags,iResCode);
            }];
        });
        if (self.timeChooseType == 0) {
            [BasicControls showNDKNotifyWithMsg:@"您已取消日报订阅" WithDuration:1 speed:1];
        } else if (self.timeChooseType == 1) {
            [BasicControls showNDKNotifyWithMsg:@"您已取消周报订阅" WithDuration:1 speed:1];
        } else {
            [BasicControls showNDKNotifyWithMsg:@"您已取消月报订阅" WithDuration:1 speed:1];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

@end
