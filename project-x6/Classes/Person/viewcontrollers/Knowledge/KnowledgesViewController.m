//
//  KnowledgesViewController.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "KnowledgesViewController.h"

#import "PicsViewController.h"
#import "TxtViewController.h"

@interface KnowledgesViewController ()

@property(nonatomic,copy)NSArray *tableViewtitles;


@end

@implementation KnowledgesViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self naviTitleWhiteColorWithText:@"我的知识库"];

    NSArray *KnowledgesArray = @[@{@"image":@"w2_a",@"title":@"文档"},@{@"image":@"w2_b",@"title":@"图片"}];
    
    UIView *KnowledgesbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 89)];
    KnowledgesbgView.backgroundColor = [UIColor whiteColor];
    KnowledgesbgView.userInteractionEnabled = YES;
    [self.view addSubview:KnowledgesbgView];
    
    for (int i = 0 ; i < KnowledgesArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12 +  45 * i, 20, 20)];
        imageView.image = [UIImage imageNamed:[KnowledgesArray[i] valueForKey:@"image"]];
        [KnowledgesbgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 12 +  45 * i, 100, 20)];
        label.font = MainFont;
        label.text = [KnowledgesArray[i] valueForKey:@"title"];
        [KnowledgesbgView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 45 * i, KScreenWidth, 44);
        button.tag = 54000 + i;
        [button addTarget:self action:@selector(knowledgeAction:) forControlEvents:UIControlEventTouchUpInside];
        [KnowledgesbgView addSubview:button];
    }
    
    UIView *lianeView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [KnowledgesbgView addSubview:lianeView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"知识库收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }

}


- (void)knowledgeAction:(UIButton *)button
{
    if (button.tag == 54000) {
        TxtViewController *knowledgeVC = [[TxtViewController alloc] init];
        [self.navigationController pushViewController:knowledgeVC animated:YES];
    } else {
        PicsViewController *picsVC = [[PicsViewController alloc] init];
        [self.navigationController pushViewController:picsVC animated:YES];
    }
}

@end
