//
//  XPPhotoView.m
//  project-x6
//
//  Created by Apple on 16/5/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XPPhotoView.h"
@interface XPPhotoView ()

@property (nonatomic, weak) UIImageView *gifView;

@end
@implementation XPPhotoView

- (void)setPicURLString:(NSString *)picURLString
{
    _picURLString = picURLString;
    
    [self sd_setImageWithURL:[NSURL URLWithString:picURLString] placeholderImage:[UIImage imageNamed:@"defalut"]];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //允许用户进行交换
        self.userInteractionEnabled = YES;
        //图片不缩放
        self.contentMode = UIViewContentModeScaleAspectFill;
        //裁剪图片，超出部分裁剪掉
        self.clipsToBounds = YES;
    
    }
    return self;
}

@end
