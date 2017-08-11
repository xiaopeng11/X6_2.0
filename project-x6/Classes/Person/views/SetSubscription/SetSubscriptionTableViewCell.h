//
//  SetSubscriptionTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSubscriptionTableViewCell : UITableViewCell

{
    UILabel *_SetSubscriptionLabel;
    UILabel *_SetSubscriptionTimeGroup;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
