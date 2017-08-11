//
//  HomeModel.h
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//


@interface HomeModel : NSObject




/*

 
 
 {
 message = ok;
 type = success;
 vo =     {
 allowapp = 1;
 apppwd = 123456;
 bm = 1214124;
 comments = "";
 csrq = "";
 cxts = 0;
 gsdm = 001;
 gw = "\U8425\U4e1a\U5458";
 gzfa = 0;
 id = 23;
 isdelete = 0;
 khlx = null;
 lzrq = "";
 name = "\U5f20\U4e09";
 phone = 18013574010;
 rzrq = "";
 sfzh = "";
 ssgs = 00010001;
 ssgsid = 46;
 ssgsname = "\U5357\U4eac\U5206\U516c\U53f8";
 userpic = "8C1E8766-D354-D5CF-F1AC-F0D0A2145F77_501bbabcc8840.jpg";
 xl = null;
 yxbz = 0;
 zz = "";
 };
 }
 
 
 
 {
 content = "\U6d4b\U5f0f\U4e00\U4e0b";
 fileprop = "[{\"name\":\"41FC3151-5E25-C2B9-3755-F4DF74243E77_bell.png\",\"comment\":\"11111\"},{\"name\":\"41FC3151-5E25-C2B9-3755-F4DF74243E77_pk.png\",\"comment\":\"\"},{\"name\":\"41FC3151-5E25-C2B9-3755-F4DF74243E77_excel70.png\",\"comment\":\"\"}]";
 fsrq = "2015-11-11 12:49:10";
 gw = "\U7cfb\U7edf\U7ba1\U7406\U5458";
 id = 396;
 name = 001;
 phone = 13961458289342343453454534534534;
 senderid = 1;
 ssgsname = "\U76c8\U5efa\U4fe1\U606f\U79d1\U6280\U6709\U9650\U516c\U53f8";
 userType = 0;
 userpic = "C514F200-2980-3DB6-D7AB-0F7E331A6562_sent_message111.png";
 zdrdm = 1;
 },
 
 content = "\U54c8\U54c8\U54c8\U54c8";
 fileprop = "";
 fsrq = "2015-12-15 10:48:58";
 gw = "\U8425\U4e1a\U5458";
 id = 430;
 issc = 0;
 name = "\U5f20\U4e09";
 phone = 18013574010;
 replayCount = 0;
 senderid = 23;
 ssgsname = "\U5357\U4eac\U5206\U516c\U53f8";
 userType = 1;
 userpic = "1A793855-A1B8-4DC0-99BD-6E655A275666_image.png";
 zdrdm = 23;

 
 
 */


@property(nonatomic,copy)NSString *name;       //发布人姓名
@property(nonatomic,copy)NSNumber *messageid;  //消息id
@property(nonatomic,copy)NSNumber *zdrdm;      //发布人代码
@property(nonatomic,copy)NSString *fsrq;       //发布时间
@property(nonatomic,copy)NSNumber *userType;   //用户类型
@property(nonatomic,copy)NSString *content;    //内容
@property(nonatomic,copy)NSString *fileprop;    //消息附件
@property(nonatomic,copy)NSString *ssgsname;   //发布人所属部门
@property(nonatomic,copy)NSString *gw;         //发布人岗位
@property(nonatomic,copy)NSString *userpic;    //发布人头像文件名
@property(nonatomic,copy)NSNumber *phone;      //发布人电话
@property(nonatomic,copy)NSNumber *replayCount;
@property(nonatomic,copy)NSNumber *senderid;
@property(nonatomic,copy)NSNumber *issc;    //是否收藏
@property(nonatomic,copy)NSNumber *hxflag;
@property(nonatomic,copy)NSNumber *msgtype;   //消息类型  0:公开；1：非公开；其余：推送信息

@end
