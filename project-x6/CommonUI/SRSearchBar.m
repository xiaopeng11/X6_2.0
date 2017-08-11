//
//  SRSearchBar.m
//  MasterplateDemo
//
//  Created by diudiu on 15/7/23.
//  Copyright (c) 2015年 diudiu. All rights reserved.
//

#import "SRSearchBar.h"

@implementation SRSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIImage *image = [UIImage imageNamed:@"textFieldSearch"];
        image =  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        self.background = image;
        // 设置内容 -- 垂直居中
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // 设置左边显示一个放大镜
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        leftView.width = leftView.image.size.width + 10;
        leftView.height = leftView.image.size.height;
        // 设置leftView的内容居中
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        
        // 设置左边的view永远显示
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 设置右边永远显示清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc]init];
}

@end
