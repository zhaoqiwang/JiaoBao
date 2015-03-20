//
//  SendToMeUserListModel.h
//  JiaoBao
//
//  Created by Zqw on 15-2-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendToMeUserListModel : NSObject{
    NSString *LastID;//分页标志值，此标志第1页为空，从第2页起须提供。如果取第1页数据后还有后续页记录，则接口结果值中会返回该标志值 。如果返回的值 为空，则表示没有记录（已取加全部记录）。如果有返回值，则在取下一页时向接口提供该标志值。
    NSMutableArray *CommMsgList;
}

@property (nonatomic,strong) NSString *LastID;
@property (nonatomic,strong) NSMutableArray *CommMsgList;

@end
//{"LastID":"Mzk4RTA2OTc5RTk4QzYwRg","CommMsgList":[{"TabIDStr":"QkJGRDk1NDVDMDAzQUI4RA","MsgContent":"2015.2.8","RecDate":"2015-02-08T14:10:18","JiaoBaoHao":5150032,"NoReadCount":1,"NoReplyCount":2},

@interface CommMsgListModel : NSObject{
    NSString *TabIDStr;//
    NSString *MsgContent;//
    NSString *RecDate;//
    NSString *JiaoBaoHao;//
    NSString *NoReadCount;//未读数量
    NSString *NoReplyCount;//未回复数量
    NSString *UserName;
    NSString *ReadFlag;//0未读，1已读未回复，2已回复
    NSString *flag;//显示用,1是别人
}

@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *MsgContent;
@property (nonatomic,strong) NSString *RecDate;
@property (nonatomic,strong) NSString *JiaoBaoHao;
@property (nonatomic,strong) NSString *NoReadCount;
@property (nonatomic,strong) NSString *NoReplyCount;
@property (nonatomic,strong) NSString *UserName;
@property (nonatomic,strong) NSString *ReadFlag;
@property (nonatomic,strong) NSString *flag;//0证明是自己，显示用

@end