//
//  XPItemsControlView.h
//  project-x6
//
//  Created by Apple on 2016/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJItemsControlView.h"
typedef void (^XPItemsControlViewTapBlock)(NSInteger index,BOOL animation);

@interface XPItemsControlView : UIScrollView

@property(nonatomic,strong)WJItemsConfig *config;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)BOOL tapAnimation;//default is YES;
@property(nonatomic,readonly)NSInteger currentIndex;
@property(nonatomic,copy)XPItemsControlViewTapBlock tapItemWithIndex;


-(void)moveToIndex:(float)index; //called in scrollViewDidScroll
/*
 首次出现，需要高亮显示第二个元素,scroll: 是外部关联的scroll
 [self endMoveToIndex:2];
 [scroll scrollRectToVisible:CGRectMake(2*w, 0.0, w,h) animated:NO];
 */
-(void)endMoveToIndex:(float)index;  //called in scrollViewDidEndDecelerating



@end
