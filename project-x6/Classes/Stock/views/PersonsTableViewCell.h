//
//  PersonsTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PersonsTableViewCell : UITableViewCell

{
    UILabel *_nameLabel;            //名称
    UIView *_noheaderViewView;      //没有头像的仕途
    UILabel *_headerViewLabel;      //没有头像的文本
    UIImageView *_imageView;        //头像
    UILabel *_companyLabel;         //公司岗位
}
@property(nonatomic,strong)NSDictionary *dic;     //所有的数据
@property(nonatomic,strong)NSArray *comdatalist;
@property(nonatomic,strong)NSArray *gwdatalist;  
@property(nonatomic,assign)BOOL type;       //判断当前页面的来源

@end
