//
//  ChangePositionLabelView.m
//  跑马灯
//
//  Created by Apple on 2016/12/6.
//  Copyright © 2016年 耿岩. All rights reserved.
//

#import "ChangePositionLabelView.h"

@implementation ChangePositionLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor= [UIColor clearColor];
        //定义视图大小
        UIView *viewAnima = [[UIView alloc] initWithFrame:frame];
        self.viewAnima = viewAnima;
        self.viewAnima.clipsToBounds = YES;
        
        //定义视图容器
        [self addSubview:self.viewAnima];
        
        // 启动NSTimer定时器来改变UIImageView的位置
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self selector:@selector(changePos)
                                                    userInfo:nil repeats:YES];
        
    }
    return self;
}


- (void)changePos
{
    CGPoint curPos = self.customLab.center;
    // 当curPos的x坐标已经超过了屏幕的宽度
    float bgWidth = self.viewAnima.frame.size.width;
    float labelWidth = self.customLab.frame.size.width;
    if(curPos.x < bgWidth - (labelWidth / 2.0)) {
        // 控制蝴蝶再次从屏幕左侧开始移动
        self.customLab.center = CGPointMake(labelWidth / 2, 10.5);
    } else {
        //通过修改iv的center属性来改变iv控件的位置
        self.customLab.center = CGPointMake(curPos.x - 1, 10.5);
    }
}


- (void)setLabelString:(NSString *)LabelString
{
    if (_LabelString != LabelString) {
        _LabelString = LabelString;

        if (self.customLab != nil) {
            [self.customLab removeFromSuperview];
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:ExtitleFont};
        CGSize size = [LabelString boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 20)];
        [customLab setTextColor:[UIColor whiteColor]];
        customLab.textAlignment = NSTextAlignmentRight;
        customLab.font = ExtitleFont;
        self.customLab = customLab;
        [self.customLab setText:LabelString];

        //添加视图
        [self.viewAnima addSubview:customLab];
        
        
        if (size.width <= self.viewAnima.frame.size.width) {
            [self.timer setFireDate:[NSDate distantFuture]];
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self selector:@selector(changePos)
                                                        userInfo:nil repeats:YES];
            [self.timer setFireDate:[NSDate distantPast]];
        }
    }
}

@end
