//
//  KnowledgeTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "KnowledgeTableViewCell.h"


@implementation KnowledgeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        self.backgroundColor = [UIColor whiteColor];
        
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
        _name.font = MainFont;
        [self.contentView addSubview:_name];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = ExtitleFont;
        _timeLabel.textColor = ExtraTitleColor;
        [self.contentView addSubview:_timeLabel];
        
        _comment = [[UILabel alloc] initWithFrame:CGRectZero];
        _comment.font = ExtitleFont;
        _comment.textColor = ExtraTitleColor;
        _comment.hidden = YES;
        [self.contentView addSubview:_comment];
        
        _download = [[UIButton alloc] initWithFrame: CGRectMake(KScreenWidth - 77, 26, 67, 28)];
        _download.clipsToBounds = YES;
        _download.layer.cornerRadius = 4;
        _download.backgroundColor = Mycolor;
        [self.contentView addSubview:_download];
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor greenColor];
        [_progressView setProgress:_progress animated:YES];
        [self.contentView addSubview:_progressView];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 79.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //判断本地是否有缓存
    NSString *filepath = [DOCSFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.model.filename]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:filepath]) {
        //添加按钮事件
        [_download setTitle:@"下载" forState:UIControlStateNormal];
        [_download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];

    } else {
        [_download setTitle:@"阅读" forState:UIControlStateNormal];
    }  
    
}

- (void)setModel:(FocusModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *comments = self.model.comment;
        if (comments.length == 0) {
            _name.frame = CGRectMake(10, 19, KScreenWidth - 10 - 80, 20);
            _name.text = self.model.shortname;
            
            
            _timeLabel.frame = CGRectMake(10, 45, _name.width, 16);
            _timeLabel.text = self.model.zdrq;
            
            _comment.hidden = YES;
        } else {
            _name.frame = CGRectMake(10, 8, KScreenWidth - 10 - 80, 20);
            _name.text = self.model.shortname;
            
            
            _timeLabel.frame = CGRectMake(10, 34, _name.width, 16);
            _timeLabel.text = self.model.zdrq;
            
            _comment.frame = CGRectMake(10, 56, _name.width, 16);
            _comment.hidden = NO;
            _comment.text = self.model.comment;
        }
    }
}


- (void)download:(UIButton *)button
{
    //创建进度条
    _progressView.frame = CGRectMake(10, 70, KScreenWidth - 80 - 80, 5);

    //新建一个空白的文件夹
    NSString *filepath = [DOCSFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.model.filename]];
    
    //构造url
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,self.model.filename];
    NSString *string = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream = [NSInputStream inputStreamWithURL:url];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filepath append:NO];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(changeprogress) userInfo:nil repeats:YES];
    //下载进度控制
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        _progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
    
    //完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        [button setTitle:@"阅读" forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        [_progressView removeFromSuperview];
        if (_timer.isValid) {
            [_timer invalidate];
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败%@",error);
        if (_timer.isValid) {
            [_timer invalidate];
        }
    }];
    
    [operation start];
}

- (void)changeprogress
{
    [_progressView setProgress:_progress];
}



@end
