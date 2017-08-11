//
//  KnowledgeTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusModel.h"
@interface KnowledgeTableViewCell : UITableViewCell

{
    UILabel *_name;
    UILabel *_comment;
    UILabel *_timeLabel;
    UIButton *_download;
    UIProgressView *_progressView;
    float _progress;
    NSTimer *_timer;
}


@property(nonatomic,strong)FocusModel *model;


@end
