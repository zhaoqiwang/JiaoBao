//
//  define_constant.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ONLINEJOBURL @"http://192.168.0.172:8201/AtHWPort/"//在线作业url
#define MAINURL @"http://www.jsyoa.edu8800.com/JBClient/"//网址
//#define AAAAAAA ([[dm getInstance].MainUrl length]>0?@"11111":@"http://www.jsyoa.edu8800.com/JBClient/")
//#define MAINURL @"http://www.jiaobao.net/JBClient/"//网址
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

@interface define_constant : NSObject

@end
