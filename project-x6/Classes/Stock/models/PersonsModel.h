//
//  PersonsModel.h
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//


@interface PersonsModel : NSObject


//"userList": [
//             {
//                 "id": 24,
//                 "phone": "",
//                 "gw": "系统管理员",
//                 "name": "高邮二店",
//                 "usertype": "0",
//                 "ssgs": "0001000500010002",
//                 "userpic": ""
//             },


@property(nonatomic,copy)NSNumber *userid;      //用户id
@property(nonatomic,copy)NSNumber *phone;       // 用户电话
@property(nonatomic,copy)NSString *gw;          //用户岗位
@property(nonatomic,copy)NSString *name;        //用户名
@property(nonatomic,copy)NSNumber *usertype;       //用户类型
@property(nonatomic,copy)NSNumber *ssgs;        //所属公司的编码
@property(nonatomic,copy)NSString *userpic;    //用户头像

@end
