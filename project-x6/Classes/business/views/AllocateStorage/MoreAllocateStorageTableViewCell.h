//
//  MoreAllocateStorageTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreAllocateStorageTableViewCell : UITableViewCell

{
    UIView *_MoreAllocateStorageBgView;
    UILabel *_goodName;    //商品名称
    UILabel *_MoreGoodMessageLabel;
    UIImageView *_moreListImageView; //更多
    
    UILabel *_goodNum;     //商品数量
    UILabel *_goodMoney;   //商品金额
    
}

@property(nonatomic,copy)NSDictionary *dic;
@end
