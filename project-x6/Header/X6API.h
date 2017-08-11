//
//  X6API.h
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#ifndef X6API_h
#define X6API_h


//appstore中的代码
#define APP_URL @"http://itunes.apple.com/lookup?id=1103122494"

//主服务器上线地址和测试地址
//#define X6basemain_API @"http://192.168.1.198:80"
#define X6basemain_API @"http://www.x6pt.cn:80"

//注册（取验证吗）
#define X6register_getsmscode @"/x6RegistAction_getMobileJzm.action"
//注册（验证码校验）
#define X6register_checksmscode @"/x6RegistAction_checkMobileJzm.action"
//注册
#define X6register @"/x6RegistAction_regist.action"

//忘记密码（取验证吗）
#define X6forgetps_getsmscode @"/pwdAction_getMobileJzm.action"
//忘记密码（验证码校验）
#define X6forgetps_checksmscode @"/pwdAction_checkMobileJzm.action"
//忘记密码（修改密码）
#define X6forgetps @"/pwdAction_ModifyX6UserPwd.action"

//帮助（帮助）
#define X6_help @"/yueyue-help/index.html"

//取得客户资料
#define kehuMessage @"/x6IntefaceAction_getX6GsInfor.action"

//登陆接口
#define X6_API_loadmain [NSString stringWithFormat:@"%@/yxmain/getAppUrl.action",X6basemain_API]

#define X6_API_load @"/manageLogin.action"

//是否需要显示更新日志
#define X6_IsNeedShowIntroduce @"/xtgl/xtuserAction_updateBbh.action"

//1.首页数据
//个人的消息图片和url + 公司代码 ＋ 登陆返回数据对应的接口
#define X6_personMessage @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/msg/"
//员工头像url接口
#define X6_ygURL @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/ygpic/"
//操作员头像url接口
#define X6_czyURL @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/userpic/"
//判断是否已经关注
#define X6_whetherConcerned @"/msg/attentionAction_hadAttention.action"
//关注接口
#define X6_focus @"/msg/attentionAction_attention.action"
//消息列表
#define X6_Dynamiclist @"/msg/msgAction_getAppMsg.action"
//新消息条数
#define X6_NewMessageCount @"/msg/msgAction_getMsgNum.action"
//个人动态接口
#define X6_personDynamic @"/msg/msgAction_getUserAppMsg.action"
//发送消息接口
#define X6_sendMessage @"/msg/msgAction_sentMsg.action"
//回复列表接口
#define X6_replyList @"/msg/msgReplyAction_getMsgReply.action"
//删除消息接口
#define X6_deleteMessage @"/msg/msgAction_delMsg.action"
//收藏接口
#define X6_collection @"/msg/msgReplyAction_collectionMsg.action"
//上传接口
#define X6_unloadFile @"/servlet/uploadFile"
//回复接口
#define X6_reply @"/msg/msgReplyAction_saveMsgReply.action"


//日报
#define X6_SubscribeDay @"/xtgl/xtSubscribeAction_getXsrbHistroy.action"
//日报详情
#define X6_SubscribeDayDetail @"/xtgl/xtSubscribeAction_getXsrbByDate.action"
//日报门店详情
#define X6_SubscribeDayBystore @"/xtgl/xtSubscribeAction_getMdXsrb.action"
//日报营业员详情
#define X6_SubscribeDayBySalesClerk @"/xtgl/xtSubscribeAction_getYwyXsrb.action"

//周报
#define X6_SubscribeWeek @"/xtgl/xtSubscribeAction_getXszbHistroy.action"
//周报详情
#define X6_SubscribeWeekDetail @"/xtgl/xtSubscribeAction_getXszbByWeek.action"
//周报门店详情
#define X6_SubscribeWeekBystore @"/xtgl/xtSubscribeAction_getMdXszb.action"
//周报营业员详情
#define X6_SubscribeWeekBySalesClerk @"/xtgl/xtSubscribeAction_getYwyXszb.action"

//月报
#define X6_SubscribeMonth @"/xtgl/xtSubscribeAction_getXsybHistroy.action"
//月报详情
#define X6_SubscribeMonthDetail @"/xtgl/xtSubscribeAction_getXsybByMonth.action"
//月报门店详情
#define X6_SubscribeMonthBystore @"/xtgl/xtSubscribeAction_getMdXsyb.action"
//月报营业员详情
#define X6_SubscribeMonthBySalesClerk @"/xtgl/xtSubscribeAction_getYwyXsyb.action"


//2.联系人页面
#define X6_persons @"/xtgl/appSelectPersonAction_SelectPerson.action"



//3.业务员页面
//供应商
#define X6_supplier @"/jcxx/dmJgAction_getGysList.action"
//供应商详情
#define X6_supplierdetail @"/jcxx/dmJgAction_getGysDetail.action"
//供应商保存
#define X6_addsupplier @"/jcxx/dmJgAction_SaveGys.action"


//客户
#define X6_customer @"/jcxx/dmJgAction_getKhList.action"
//客户详情
#define X6_customerdetail @"/jcxx/dmJgAction_getKhxxDetail.action"
//客户保存
#define X6_addcustomer @"/jcxx/dmJgAction_SaveKhxx.action"
//供应商/客户删除
#define X6_deleteSupplierORCustomer @"/jcxx/dmJgAction_Delete.action"


//会员列表
#define X6_VIPList @"/hygl/hyglHyxxAction_loadList.action"
//会员新增
#define X6_NewVIP @"/hygl/hyglHyxxAction_Save.action"
//会员删除
#define X6_VIPDelete @"/hygl/hyglHyxxAction_Delete.action"
//会员详情
#define X6_VIPDetail @"/hygl/hyglHyxxAction_getDetail.action"


//一键设置考核价
#define X6_resetPrice @"/jcxx/dmPriceAction_setkhPrice.action"
//最后一次设置考核价的时间
#define X6_lastsetPrice @"/jcxx/dmPriceAction_getLastSetDate.action"


//资金收入,支出,调配
#define X6_CapitalControl @"/cw/cwZjtpAction_getList.action"

//新增资金收入
#define X6_AddCapitalIncome @"/cw/cwZjtpAction_SaveStockIn.action"

//新增资金支出
#define X6_AddCapitalExpenditure @"/cw/cwZjtpAction_SaveStockOut.action"

//新增资金调配
#define X6_AddCapitalDeployment @"/cw/cwZjtpAction_SaveStockMove.action"


//删除资金
#define X6_deleteCapitalControl @"/cw/cwZjtpAction_DeleteObj.action"

//批发银行到账
#define X6_LotBankAccount @"/cw/cwZjtpAction_getYhdzList.action"
//保存批发银行到账
#define X6_SaveLotBankAccount @"/cw/cwZjtpAction_SaveYhdz.action"

//采购订单（未审核）
#define X6_orderreviewone @"/jxc/jxcPreInStockAction_getDsList.action"
//采购审核
#define X6_examineOrder @"/jxc/jxcPreInStockAction_shBill.action"
//采购订单（审核）
#define X6_orderreviewtwo @"/jxc/jxcPreInStockAction_getYsList.action"
//采购撤审
#define X6_revokeOrder @"/jxc/jxcPreInStockAction_QxShBill.action"


//批发订单（未审核）
#define X6_wholesalenoOrder @"/jxc/jxcPreOutStockAction_getDsList.action"
//批发订单(审核)
#define X6_wholesaleOrder @"/jxc/jxcPreOutStockAction_getYsList.action"
//批发订单审核
#define X6_wholesaleexamineOrder @"/jxc/jxcPreOutStockAction_shBill.action"
//批发订单撤审
#define X6_wholesalerevokeOrder @"/jxc/jxcPreOutStockAction_QxShBill.action"


//调拨入库（待确认）
#define X6_AllocateStorageNoSure @"/jxc/jxcYrkStockAction_getWshList.action"
//调拨入库（以确认）
#define X6_AllocateStorageSured @"/jxc/jxcYrkStockAction_getYshList.action"
//调拨入库商品明细
#define X6_AllocationOfGoods @"/jxc/jxcYrkStockAction_getBillSpmx.action"
//调拨入库串号明细
#define X6_AllocationOfSerialNumberList @"/jxc/jxcYrkStockAction_getBillChmx.action"
//调拨入库确认
#define X6_AllocateStorageConfirmation @"/jxc/jxcYrkStockAction_sh.action"
//调拨入库取消
#define X6_AllocateStorageCancle @"/jxc/jxcYrkStockAction_cxsh.action"


//盘库列表
#define X6_CheckList @"/jxc/jxcPkStockAction_loadList.action"
//盘库详情
#define X6_CheckTheDetail @"/jxc/jxcPkStockAction_getDetail.action"
//盘库确认
#define X6_CheckSure @"/jxc/jxcPkStockAction_sh.action"
//盘库取消
#define X6_CheckCancle @"/jxc/jxcPkStockAction_cxsh.action"
//盘库单保存
#define X6_CheckSingleSave @"/jxc/jxcPkStockAction_Save.action"
//盘库单删除
#define X6_CheckSingleCancle @"/jxc/jxcPkStockAction_Delete.action"
//库存串号列表
#define X6_StockCode @"/jxc/jxcChxxAction_getKcchListByPage.action"


//期初盘库
#define X6_FirstCheck @"/report/reportKcRb_qcpkList.action"
//期初盘库保存
#define X6_NewFirstCheck @"/jxc/jxcQcPkAction_Save.action"

//银行存款
#define X6_deposit @"/cw/cwMddkAction_getList.action"
//银行存款保存
#define X6_savedeposit @"/cw/cwMddkAction_save.action"
//银行存款删除
#define X6_deletedeposit @"/cw/cwMddkAction_delete.action"

//银行存款新增
//银行打款(未审核)
#define X6_depositnoOrder @"/cw/cwMddkAction_getDsList.action"
//银行打款（审核）
#define X6_depositOrder @"/cw/cwMddkAction_getYsList.action"
//银行打款审核
#define X6_depositexamineOrder @"/cw/cwMddkAction_sh.action"
//银行打款撤审
#define X6_depositrevokeOrder @"/cw/cwMddkAction_qxsh.action"


//银行账户列表
#define X6_banksList @"/jcxx/dmYhzhAction_getMyDkzh.action"
//门店列表
#define X6_storesList @"/xtgl/xtGsAction_getMyMd.action"
//经办人列表
#define X6_personsList @"/jcxx/dmYgAction_getYgList.action"




//4.报表页面
//今日库存接口
#define X6_noleadertoday @"/report/reportKcRb_doSearch.action"
//库位分布
#define X6_Librarybitdistribution @"/report/reportKcRb_kwfb.action"
//我的销量接口
#define X6_noleaderMySales @"/report/reportMySell_doSearch.action"
//销量排名接口
#define X6_noleaderallSales @"/report/reportMySell_sellSort.action"
//营业款待确认日期
#define X6_BusinessSectionConfirmationDate @"/jxc/jxcOutStockAction_getUncheckList.action"
//营业款待确认详情
#define X6_BusinessSectionConfirmationDetail @"/jxc/jxcOutStockAction_getTodayList.action"
//营业款待确认
#define X6_BusinessSectionConfirmation @"/jxc/jxcOutStockAction_checkYyk.action"

//我的库存眉头
#define X6_mykucunTitle @"/jcxx/dmSplxAction_getLevel1Splx.action"
//我的库存
#define X6_mykucun @"/report/reportKcRb_doSearchManage.action"
//我的库存详情
#define X6_mykucunDetail @"/report/reportKcRb_kcDetail.action"

//今日战报
#define X6_today @"/report/reportMySell_Jrzb.action"
//今日战报详情
#define X6_todayDetail @"/report/reportMySell_JrzbDetail.action"

//今日销量
#define X6_todaySales @"/report/reportMySell_Jrxs.action"
//今日销量详情
#define X6_todaySalesDetail @"/report/reportMySell_JrxsDetail.action"

//今日营业款
#define X6_todayMoney @"/report/reportMySell_JrYjk.action"
//今日营业款详情
#define X6_todayMoneyDetail @"/report/reportMySell_JrYjkDetail.action"

//今日付款
#define X6_todayPay @"/report/reportCwAction_myfk.action"

//我的帐户
#define X6_myAcount @"/report/reportCwAction_myzh.action"

//今日存款
#define X6_todaydeposit @"/cw/cwMddkAction_getTodayList.action"

//批发战报
#define X6_WholesaleUnits @"/report/reportPfAction_pfzb.action"

//批发销量
#define X6_WholesaleSales @"/report/reportPfAction_pfxl.action"

//批发汇总
#define X6_WholesaleSummary @"/report/reportPfAction_pfhz.action"

//应收明细
#define X6_MissyReceivable @"/report/reportCwAction_myysk.action"

//今日收款
#define X6_todayReceivable @"/report/reportCwAction_mysk.action"

//今日采购
#define X6_todayPurchase @"/report/reportCgAction_jrcg.action"

//人均毛利
#define X6_PerCapitaProfit @"/report/reportBbFxAction_rjml.action"

//人均毛利排名
#define X6_PerCapitaProfitRanking @"/report/reportBbFxAction_rjmlpm.action"

//净利润排名
#define X6_NetProfitRanking @"/report/reportBbFxAction_jlrpm.action"

//周转天数分析
#define X6_TurnoverDaysAnalysis @"/report/reportBbFxAction_zztsfx.action"

//业务高峰期分析
#define X6_BusinessPeakAnalysis @"/report/reportBbFxAction_ywgf.action"

//进销对比
#define X6_InletandPinComparison @"/report/reportCgAction_jxdb.action"

//销售走势
#define X6_SalesTrend @"/report/reportBbFxAction_xszs.action"

//销售对比
#define X6_SalesComparison @"/report/reportBbFxAction_xsdb.action"

//库存占比
#define X6_InventoryAccounting @"/report/reportBbFxAction_kczb.action"

//销售占比
#define X6_SalesAccounting @"/report/reportBbFxAction_xszb.action"

//资产占比
#define X6_AssetsAccounting @"/report/reportBbFxAction_zczb.action"

//我的提醒
//异常条数
#define X6_EarlyWarningNumber @"/report/reportXttxAction_getTxcount.action"
//清除异常条数
#define X6_removeWarningNumber @"/report/reportXttxAction_removeTxcount.action"

//出库异常
#define X6_Outbound @"/report/reportXttxAction_lsckyc.action"
//出库异常详情
#define X6_Outbounddetail @"/report/reportXttxAction_lsckycDetail.action"
//出库异常明细
#define X6_OutboundMoredetail @"/report/reportXttxAction_lsckycMx.action"

//库龄逾期
#define X6_Oldlibrary @"/report/reportXttxAction_klyj.action"
//库龄逾期详细
#define X6_Oldlibrarydetail @"/report/reportXttxAction_klyjDetail.action"

//采购异常
#define X6_Purchase @"/report/reportXttxAction_cgjgyc.action"

//零售异常
#define X6_Retail @"/report/reportXttxAction_lsjgyc.action"

#define X6_ignore @"/report/reportXttxAction_txpass.action"

//应收逾期
#define X6_OverdueRecieved @"/report/reportXttxAction_ysyqtx.action"



//5.个人页面数据
//修改头像接口
//操作员
#define X6_changeUserHeaderView @"/xtgl/xtuserAction_updatePhoto.action"
//营业员
#define X6_changeygHeaderView @"/jcxx/dmYgAction_updatePhoto.action"

//订阅状态
#define X6_Subscriptionstatelist @"/xtgl/xtSubscribeAction_getSubscribeList.action"
//订阅接口
#define X6_SetSubscriptionDate @"/xtgl/xtSubscribeAction_subscribeByType.action"
//取消订阅
#define X6_deleteSetSubscriptionDate @"/xtgl/xtSubscribeAction_qxSubscribeByType.action"


//修改密码接口
#define X6_changePassword @"/xtgl/xtuserAction_modifyPwd.action"

//知识库接口
#define X6_collectionView @"/msg/msgAction_getMyKnowledge.action"

//意见反馈
#define X6_advice @"/xtgl/xtUserQuestionAction_save.action"

//6.检测权限变化
#define X6_userQXchange @"/xtgl/xtuserAction_CheckMbQxChanged.action"

#define X6_hadChangeQX @"/xtgl/xtuserAction_getMyMbSsgsAndQx.action"

//7.辅助信息
#define X6_Supplementaryinformation @"/jcxx/dmFzxxAction_getFzxxByFzlx.action"

//选择仓库
#define X6_ChooseWarehous @"/jcxx/dmJgAction_getCkList.action"

//选择商品类型
#define X6_GoodsType @"/jcxx/dmSpxxAction_getLike.action"

//选择公司
#define X6_ChooseCompany @"/xtgl/xtGsAction_getGsList.action"

//员工
#define X6_Staff @"/jcxx/dmYgAction_getdmYgList.action"

//银行账户
#define X6_BankAcount @"/jcxx/dmYhzhAction_getdmYhzhList.action"

#endif /* X6API_h */


