//
//  NoDataView.m
//  project-x6
//
//  Created by Apple on 16/1/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - (215 / 3.0)) / 2.0, 10, 215 / 3.0, 229/ 3.0)];
        _imageview.image = [UIImage imageNamed:@"nodataimage"];
        [self addSubview:_imageview];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageview.bottom + 10, KScreenWidth, 50)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = _text;
        _label.textColor = [UIColor grayColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    if (_text != text) {
        _text = text;
        _label.text = _text;
    }
}

@end
