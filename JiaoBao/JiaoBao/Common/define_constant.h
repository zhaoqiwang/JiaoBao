//
//  define_constant.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ONLINEJOBURL @"http://192.168.0.178:8501/AtHWPort/"//在线作业url
//#define ONLINEJOBURL @"http://192.168.0.11:8301/AtHWPort/"//在线作业url
//#define MAINURL @"http://www.jsyoa.edu8800.com/JBClient/"//网址
//#define AAAAAAA ([[dm getInstance].MainUrl length]>0?@"11111":@"http://www.jsyoa.edu8800.com/JBClient/")
#define MAINURL @"http://www.jiaobao.net/JBClient/"//网址
#define APPID @"101003" //appid
#define CLIVER @"1.0"
#define TIMEOUT 30

#define BUGFROM @"bugfrom"//bug来自于在UserDefault中的常量

#define SHOWRONGYUN 0//1显示，0不显示
#define NETWORKENABLE @"请检查当前网络"
//友盟提示中的角色信息、单位id、教宝号、哪个页面
#define UMMESSAGE [NSString stringWithFormat:@"%@--%d--%d--%@",[NSString stringWithUTF8String:object_getClassName(self)],[dm getInstance].uType,[dm getInstance].UID,[dm getInstance].jiaoBaoHao]
//来自哪个页面
#define UMPAGE [NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:object_getClassName(self)]]

//获取个人头像
#define AccIDImg [NSURL URLWithString:[NSString stringWithFormat:@"%@/ClientSrv/getfaceimg?accid=",[dm getInstance].url]]
//获取单位头像
#define UnitIDImg [NSURL URLWithString:[NSString stringWithFormat:@"%@/ClientSrv/getUnitlogo?UnitID=",[dm getInstance].url]]

//没有加入单位时，对求知的提示,账号被封
#define JoinUnit if ([dm getInstance].joinUnit==0||[dm getInstance].isCanUser==1) {if ([dm getInstance].joinUnit==0) {[MBProgressHUD showSuccess:@"必须加入单位方可进行此操作" toView:self.view];return;}else if ([dm getInstance].isCanUser==1){[MBProgressHUD showSuccess:@"您的账号已被停用求知权限" toView:self.view];return;}}
#define JoinUnitTextV if ([dm getInstance].joinUnit==0||[dm getInstance].isCanUser==1) {if ([dm getInstance].joinUnit==0) {[textView resignFirstResponder];[MBProgressHUD showSuccess:@"必须加入单位方可进行此操作" toView:self.view];return;}else if ([dm getInstance].isCanUser==1){[textView resignFirstResponder];[MBProgressHUD showSuccess:@"您的账号已被停用求知权限" toView:self.view];return;}}
#define JoinUnitTextF if ([dm getInstance].joinUnit==0||[dm getInstance].isCanUser==1) {if ([dm getInstance].joinUnit==0) {[textField resignFirstResponder];[MBProgressHUD showSuccess:@"必须加入单位方可进行此操作" toView:self.view];return;}else if ([dm getInstance].isCanUser==1){[textField resignFirstResponder];[MBProgressHUD showSuccess:@"您的账号已被停用求知权限" toView:self.view];return;}}
//没有昵称，不能对求知进行输入性操作
#define NoNickName if ([dm getInstance].NickName1.length==0) {[MBProgressHUD showError:@"请去个人中心设置昵称" toView:self.view];return;}
#define NoNickNameTextV if ([dm getInstance].NickName1.length==0) {[textView resignFirstResponder];[MBProgressHUD showSuccess:@"请去个人中心设置昵称" toView:self.view];return;}
#define NoNickNameTextF if ([dm getInstance].NickName1.length==0) {[textField resignFirstResponder];[MBProgressHUD showSuccess:@"请去个人中心设置昵称" toView:self.view];return;}

//握手通讯失败后，进行登录操作
#define Login if ([code intValue] == 8) {[MBProgressHUD hideHUD];[[LoginSendHttp getInstance] hands_login];return;}

@interface define_constant : NSObject

@end
