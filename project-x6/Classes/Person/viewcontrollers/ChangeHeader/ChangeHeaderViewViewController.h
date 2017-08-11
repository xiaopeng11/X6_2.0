//
//  ChangeHeaderViewViewController.h
//  project-x6
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeHeaderViewViewController : BaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImageView *HeaderView;
@property(nonatomic,strong)NSString *uuid;
@end
