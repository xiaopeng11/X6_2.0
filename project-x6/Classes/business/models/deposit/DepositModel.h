//
//  DepositModel.h
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepositDetailModel.h"

/*
 message = ok;
 page = 1;
 pages = 1;
 records = 2;
 rows =     (
 {
 comments = "";
 djh = YYK000000024;
 fsrq = "2016-03-22";
 jsrdm = 39;
 jsrmc =             {
 allowapp = 0;
 apppwd = 1234567;
 bm = NJ5H007;
 cbqx = 0;
 comments = "";
 csrq = "";
 cxts = 0;
 gsdm = 001;
 gw = "\U8425\U4e1a\U5458";
 gzfa = 0;
 id = 39;
 isdelete = 0;
 khlx = null;
 lzrq = "";
 msgflag = 1;
 name = "\U5434\U5b97\U5b89";
 phone = 18013574011;
 rzrq = "";
 sex = 0;
 sfzh = "";
 ssgsid = 97;
 sxrq = "2016-02-25 11:51:55";
 sxrq1 = "";
  = "dc677025-78b5-4923-b05f-2ab36acec059_headphoto.png";
 xl = null;
 yxbz = 0;
 zz = "";
 };
 rows =             (
 );
 ssgsid = 49;
 ssgsname =             {
 bm = 0001000500010001;
 cj = 4;
 ckdm = 0;
 dhhm = "";
 dz = "";
 fzr = "";
 fzrdm = 0;
 gsdm = 001;
 id = 49;
 isdelete = 0;
 lx = 3;
 lxr = "";
 name = "\U4eba\U6c11\U4e2d\U8def\U5e97";
 pbm = 000100050001;
 sortid = 0;
 swh = "";
 yxbz = 0;
 };
 sumje = 40000;
 zdrdm = 1;
 zdrmc =             {
 bindkh = 0;
 comment = "";
 dlcs = 0;
 groupid = 1;
 gsdm = 001;
 gysqx = 0;
 id = 1;
 introduction = "";
 isdelete = 0;
 khqx = 0;
 mailbox = 13961458289342343453454534534534;
 mflag = 1;
 msgflag = 1;
 name = 001;
 phone = 18013574012;
 pwd = 123456;
 sex = 0;
 skinflag = 0;
 ssgsid = 2;
 sxrq = "2016-03-12 17:49:37";
 sxrq1 = "";
 telephone = 13961458289342343453454534534534;
 userpic = "e797a9f6-52d4-4aad-8949-5e6b87ae3e65_headphoto.png";
 utype = 1;
 yxbz = 0;
 };
 zdrq = "2016-03-22 15:15:46";
 },
 {
 comments = "\U5c0f\U5ba2\U6237";
 djh = YYK000000025;
 fsrq = "2016-03-22";
 jsrdm = 34;
 jsrmc =             {
 allowapp = 0;
 apppwd = 123456;
 bm = NJ5H001;
 cbqx = 0;
 comments = "";
 csrq = "";
 cxts = 0;
 gsdm = 001;
 gw = "\U8425\U4e1a\U5458";
 gzfa = 0;
 id = 34;
 isdelete = 0;
 khlx = null;
 lzrq = "";
 msgflag = 1;
 name = "\U5f20\U73b2\U73b2";
 phone = 18626196187;
 rzrq = "";
 sex = 0;
 sfzh = "";
 ssgsid = 97;
 sxrq = "2016-02-02 10:10:53";
 sxrq1 = "";
 userpic = "f47960f8-d140-4026-bc60-a2f0e6bc4f53_headphoto.png";
 xl = null;
 yxbz = 0;
 zz = "";
 };
 rows =             (
 );
 ssgsid = 43;
 ssgsname =             {
 bm = 000100030001;
 cj = 3;
 ckdm = 0;
 dhhm = "";
 dz = "";
 fzr = "";
 fzrdm = 0;
 gsdm = 001;
 id = 43;
 isdelete = 0;
 lx = 3;
 lxr = "";
 name = "\U6c9b\U53bf\U95e8\U5e97";
 pbm = 00010003;
 sortid = 0;
 swh = "";
 yxbz = 1;
 };
 sumje = 10000;
 zdrdm = 1;
 zdrmc =             {
 bindkh = 0;
 comment = "";
 dlcs = 0;
 groupid = 1;
 gsdm = 001;
 gysqx = 0;
 id = 1;
 introduction = "";
 isdelete = 0;
 khqx = 0;
 mailbox = 13961458289342343453454534534534;
 mflag = 1;
 msgflag = 1;
 name = 001;
 phone = 18013574012;
 pwd = 123456;
 sex = 0;
 skinflag = 0;
 ssgsid = 2;
 sxrq = "2016-03-12 17:49:37";
 sxrq1 = "";
 telephone = 13961458289342343453454534534534;
 userpic = "e797a9f6-52d4-4aad-8949-5e6b87ae3e65_headphoto.png";
 utype = 1;
 yxbz = 0;
 };
 zdrq = "2016-03-22 15:30:44";
 }
 );
 type = success;
 }

 */
@interface DepositModel : NSObject

@property(nonatomic,copy)NSString *djh;       //单据号
@property(nonatomic,copy)NSString *fsrq;      //日期
@property(nonatomic,copy)NSNumber *ssgsid;    //门店id
@property(nonatomic,copy)NSString *ssgsname;  //门店名称
@property(nonatomic,copy)NSNumber *jsrdm;     //经办人ID
@property(nonatomic,copy)NSString *jsrmc;     //经办人名称
@property(nonatomic,copy)NSNumber *zdrdm;     //制单人ID
@property(nonatomic,copy)NSString *zdrmc;     //制单人名称
@property(nonatomic,copy)NSString *zdrq;      //制单日期
@property(nonatomic,copy)NSString *comments;  //备注
@property(nonatomic,copy)NSArray *rows;       //明细


@end
