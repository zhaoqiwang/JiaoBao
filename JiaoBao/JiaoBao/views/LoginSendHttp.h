//
//  LoginSendHttp.h
//  JiaoBao
//  注册、和登录时的发送请求
//  Created by Zqw on 14-10-20.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dm.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "define_constant.h"
#import "RSATool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "DESTool.h"
#import "utils.h"
#import "JSONKit.h"
#import "ParserJson.h"
#import "UnReadMsg_model.h"
#import "MsgDetail_FeebackList.h"
#import "SMSTreeArrayModel.h"
#import "Nav_internetAppView.h"
#import "ExchangeHttp.h"
#import "CommMsgRevicerUnitListModel.h"
#import "UnitListJsonModel.h"
#import "CommMsgUnitNotice.h"

@protocol LoginSendHttpDelegate;

@interface LoginSendHttp : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>{
    int flag_request;//判断是哪个请求的回掉,注册获取时间1，注册回调2，握手回调3，登录获取时间回调4,
    NSString *mStr_hands;//握手时，用于对比的字符串
    NSString *mStr_Register;//握手时，用于对比的字符串
    NSString *mStr_userName;//用户名
    NSString *mStr_passwd;//密码
    id<LoginSendHttpDelegate> delegate;
    int flag_skip;//是否发送window通知
    int flag_unReadMsg;//通知界面更新未读消息数量，当未读和未读回复都收到时，发送
    int mInt_forwardFlag;//切换身份时，判断是普通，还是短信
    int mInt_forwardAll;//转发时，判断是否群发
}

@property (strong,nonatomic) NSString *mStr_hands;//握手时，用于对比的字符串
@property (strong,nonatomic) NSString *mStr_Register;//握手时，用于对比的字符串
@property (assign,nonatomic) int flag_request;//判断是哪个请求的回掉
@property (strong,nonatomic) NSString *mStr_userName;//用户名
@property (strong,nonatomic) NSString *mStr_passwd;//密码
@property (strong,nonatomic) id<LoginSendHttpDelegate> delegate;
@property (assign,nonatomic) int flag_skip;//是否发送window通知
@property (assign,nonatomic) int flag_unReadMsg;//通知界面更新未读消息数量，当未读和未读回复都收到时，发送
@property (assign,nonatomic) int mInt_forwardFlag;//切换身份时，判断是普通，还是短信
@property (assign,nonatomic) int mInt_forwardAll;//转发时，判断是否群发

//单
+(LoginSendHttp *)getInstance;

//注销登录接口
-(void)loginHttpLogout;

//当注册时，向服务器获取当前时间 1登录2注册
-(void)getTime:(NSString *)flag;

//登录，先握手，再发送登录
-(void)hands_login;

//获取未读消息数量
-(void)getUnreadMessages1;

//获取未读回复数量
-(void)getUnreadMessages2;

//获取发给我的待处理信息
-(void)wait_unReadMsgWithTag:(int)tag page:(NSString *)page;

//获取自己发出的信息
-(void)getMyselfSendMsgWithPage:(NSString *)page;

//显示交流信息明细
-(void)msgDetailwithUID:(NSString *)uid page:(int)page feeBack:(NSString *)feeBack ReadFlag:(NSString *)flag;

//回复交流信息
-(void)addFeeBackWithUID:(NSString *)uid content:(NSString *)content;

//在信息详情页，点击下载文件
-(void)msgDetailDownLoadFileWithURL:(NSString *)Fileurl fileName:(NSString *)fileName;

//获取接收人列表或单位列表,flag是短信还是普通请求，all是否群发
-(void)ReceiveListWithFlag:(int)flag all:(int)all;

//切换所在单位，切换身份
-(void)changeCurUnit;

//获取自己的个人信息
-(void)getUserInfoWith:(NSString *)accID UID:(NSString *)uid;

//发表交流信息,内容                                 是否发生短信      单位加密ID                  接收班级总人数         是否短信直通车     接收者数组           判断是否转发，转发里面有字段                          附件
-(void)creatCommMsgWith:(NSString *)content SMSFlag:(int)sms unitid:(NSString *)unit classCount:(int)count grsms:(int)grsms array:(NSMutableArray *)array forwardMsgID:(NSString *)msgid access:(NSMutableArray *)arrayAccess;

//发表下发通知,内容                                是否发生短信      单位加密ID                  接收班级总人数         是否短信直通车     单位人员数组,家长，学生
-(void)creatCommMsgWith:(NSString *)content SMSFlag:(int)sms unitid:(NSString *)unit classCount:(int)count grsms:(int)grsms arrMem:(NSMutableArray *)memArr arrGen:(NSMutableArray *)genArr forwardMsgID:(NSString *)msgid;

//发表短信直通车,内容                                是否发生短信      单位加密ID                  接收班级总人数         是否短信直通车     单位人员数组,家长，学生
-(void)creatCommMsgWith:(NSString *)content SMSFlag:(int)sms unitid:(NSString *)unit classCount:(int)count grsms:(int)grsms arrMem:(NSMutableArray *)memArr arrGen:(NSMutableArray *)genArr arrStu:(NSMutableArray *)stuArr access:(NSMutableArray *)arrayAccess;

//获取事务信息接收单位列表
-(void)login_CommMsgRevicerUnitList;

//获取单位接收人
-(void)login_GetUnitRevicer:(NSString *)unitID Flag:(NSString *)flag;

//获取班级接收人
-(void)login_GetUnitClassRevicer:(NSString *)classID Flag:(NSString *)flag;
//-(void)getUnitClassRevicer:(NSString *)classID Flag:(NSString *)flag;

//获取群发权限
-(void)login_GetMsgAllReviceUnitList;

//获取群发下属单位接收对象
-(void)login_GetMsgAllRevicer_toSubUnit;

//获取群发家长的接收对象
-(void)login_GetMsgAllRevicer_toSchoolGen;

//检查版本更新
-(void)login_itunesUpdataCheck;

//获取我发送的消息列表，new        返回数量            第几页                 检索条件                    开始日期                    结束日期
-(void)login_GetMySendMsgList:(NSString *)num Page:(NSString *)page SendName:(NSString *)sendName sDate:(NSString *)sDate eDate:(NSString *)eDate;

//取发给我消息的用户列表，new        返回数量            第几页                 检索条件                    开始日期                    结束日期           阅读标志检索：不提供该参数：查全部，1：未读，2：已读未回复，3：已回复    分页标志值
-(void)login_SendToMeUserList:(NSString *)num Page:(NSString *)page SendName:(NSString *)sendName sDate:(NSString *)sDate eDate:(NSString *)eDate readFlag:(NSString *)readFlag lastId:(NSString *)lastId;

//取单个用户发给我消息列表 new       返回数量            第几页                 发送者教宝号                    开始日期                    结束日期           阅读标志检索：不提供该参数：查全部，1：未读，2：已读未回复，3：已回复    分页标志值
-(void)login_SendToMeMsgList:(NSString *)num Page:(NSString *)page senderAccId:(NSString *)accid sDate:(NSString *)sDate eDate:(NSString *)eDate readFlag:(NSString *)readFlag lastId:(NSString *)lastId;

//获取老师的关联班级
-(void)login_GetmyUserClass:(NSString *)uid Accid:(NSString *)accid;
-(void)GetCommPerm;
//获取自己的身份信息
-(void)getIdentityInformation;

@end

@protocol LoginSendHttpDelegate <NSObject>

@optional
//告知登录界面
-(void)LoginSendHttpMember:(NSString *)str;

@end
