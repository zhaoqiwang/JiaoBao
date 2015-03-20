//
//  MsgDetail_ReaderList.h
//  JiaoBao
//
//  Created by Zqw on 14-10-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDetail_ReaderList : NSObject{
    NSString *UserID;
    NSString *UserIDType;
    NSString *JiaoBaoHao;
    NSString *TrueName;
    NSString *SrvState;
    NSString *MCState;
    NSString *SMSState;
    NSString *PCState;
    NSString *ClassID;
    NSString *UnitID;
    NSString *flag;//是否选择1，无0
}
@property (nonatomic,strong) NSString *UserID;
@property (nonatomic,strong) NSString *UserIDType;
@property (nonatomic,strong) NSString *JiaoBaoHao;
@property (nonatomic,strong) NSString *TrueName;
@property (nonatomic,strong) NSString *SrvState;
@property (nonatomic,strong) NSString *MCState;
@property (nonatomic,strong) NSString *SMSState;
@property (nonatomic,strong) NSString *PCState;
@property (nonatomic,strong) NSString *ClassID;
@property (nonatomic,strong) NSString *UnitID;
@property (nonatomic,strong) NSString *flag;//是否选择1，无0

@end
//"ReaderList":"[{\"UserID\":6,\"UserIDType\":\"6_1\",\"JiaoBaoHao\":5150001,\"TrueName\":\"石向亮\",\"SrvState\":2,\"MCState\":1,\"SMSState\":0,\"PCState\":0,\"ClassID\":0,\"UnitID\":991}]",