//
//  FriendSpaceModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendSpaceModel : NSObject{
    NSString *TabID;//
    NSString *Actjiaobaohao;//
    NSString *Friendjiaobaohao;//好友的jiaobaohao
    NSString *GroupID;//好友所在组，该字段是组的ID
    NSString *Remark;//备注：我对好友的一个备注
    NSString *NickName;//别名，我对好友的命名
    NSString *LinkFirendsTabID;//
    NSString *LastLogDatetime;//好友最后登录时间
}

@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *Actjiaobaohao;
@property (nonatomic,strong) NSString *Friendjiaobaohao;
@property (nonatomic,strong) NSString *GroupID;
@property (nonatomic,strong) NSString *Remark;
@property (nonatomic,strong) NSString *NickName;
@property (nonatomic,strong) NSString *LinkFirendsTabID;
@property (nonatomic,strong) NSString *LastLogDatetime;

@end

//好友
//[{"TabID":1310,"Actjiaobaohao":5150028,"Friendjiaobaohao":5150114,"GroupID":0,"Remark":null,"NickName":null,"LinkFirendsTabID":655,"LastLogDatetime":"0001-01-01T00:00:00"},

//关注人
//[{"TabID":389,"CreateByjiaobaohao":5150028,"InterestFirendsjiaobaohao":5150030,"CreateDatetime":"2014-11-23T18:22:39","GroupID":0}]