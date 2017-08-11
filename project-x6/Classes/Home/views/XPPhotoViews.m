//
//  XPPhotoViews.m
//  project-x6
//
//  Created by Apple on 16/5/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XPPhotoViews.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "XPPhotoView.h"


@implementation XPPhotoViews


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加空间
        for (int i = 0; i < 100; i++) {
            XPPhotoView *imageView = [[XPPhotoView alloc] init];
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)setPicsArray:(NSArray *)picsArray
{
    _picsArray = picsArray;
    int count = (int)self.subviews.count;
    for (int i = 0; i < count; i++) {
        XPPhotoView *imageView = self.subviews[i];
        if (i < picsArray.count) {
            imageView.hidden = NO;
            imageView.picURLString = _picsArray[i];
        } else {
            imageView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = _picwid,h = _picwid;
    CGFloat margin = 5;
    int col = 0;
    int rol = 0;
    // 计算显示出来的imageView
    if (w == ((KScreenWidth - 124) / 3.0)) {
        for (int i = 0; i < _picsArray.count; i++) {
            col = (i + 3) % 3;
            rol = i / 3;
            UIImageView *imageV = self.subviews[i];
            x = col * (h + margin);
            y = rol * (w + margin);
            imageV.frame = CGRectMake(x, y, w, h);
        }
    } else {
        int cols = _picsArray.count == 4 ? 2 : 1;
        for (int i = 0; i < _picsArray.count; i++) {
            col = i % cols;
            rol = i / cols;
            UIImageView *imageV = self.subviews[i];
            if (_picsArray.count == 4) {
                x = col * (w + margin);
                y = rol * (h + margin);
            } else {
                y = col * (w + margin);
                x = rol * (h + margin);
            }
            imageV.frame = CGRectMake(x, y, w, h);
        }
    }

}

- (void)tap:(UITapGestureRecognizer *)tap
{
    UIImageView *tapView = (UIImageView *)tap.view;
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *picURLString in self.picsArray) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:picURLString];
        photo.index = i;
        photo.srcImageView = tapView;
        [arrM addObject:photo];
        i++;
    }
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.photos = arrM;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];
    
}
@end
