//
//  NSMutableArray+InsertFrameKey.m
//  project-x6
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSMutableArray+InsertFrameKey.h"

@implementation NSMutableArray (InsertFrameKey)
- (NSMutableArray *)loadframeKeyWithDatalist
{
    NSMutableArray *array = [NSMutableArray array];
    //计算动态高度
    float height = 0;
    //计算文本高度
    for (NSDictionary *dic in self) {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([[dic valueForKey:@"msgtype"] integerValue] == 2 || [[dic valueForKey:@"msgtype"] integerValue] == 3 || [[dic valueForKey:@"msgtype"] integerValue] == 4) {
            height = 70;
            data[@"frame"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, height)];
            data[@"contentframe"] = [NSValue valueWithCGRect:CGRectMake((KScreenWidth -120) / 2.0, 17.5 + 10, 120, 25)];
            [array addObject:data];
        } else {
            //单元格头的高度
            float height = 10 + 15 + 39 + 10;
            //添加frame参数
            NSString *content = dic[@"content"];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 6;
            NSDictionary *attributes = @{NSFontAttributeName:MainFont,NSParagraphStyleAttributeName:paragraphStyle};
            CGSize size = [content boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            
            //单元格尾部高度
            height += size.height + 30 + 15;
            
            //判断是否有图片2
            NSString *filepropString = dic[@"fileprop"];
            //json解析
            NSArray *fileprop = [filepropString objectFromJSONString];
            if (fileprop.count != 0) {
                //有图片
                if (fileprop.count == 4) {
                    height += (PuretureSize * 2) + 5;
                } else {
                    height += PuretureSize;
                }
                height += 15;
            }
            data[@"frame"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, height)];
            data[@"contentframe"] = [NSValue valueWithCGRect:CGRectMake(10, 74, KScreenWidth - 20, size.height)];
            [array addObject:data];
        }
    }
    return array;
}
@end
