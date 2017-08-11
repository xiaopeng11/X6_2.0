//
//  TxtViewController.h
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import <QuickLook/QuickLook.h>
@interface TxtViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

{
    UITableView *_picTableview;
    NoDataView *_notextView;
}

@property(nonatomic,strong)NSString *txtString;

@end
