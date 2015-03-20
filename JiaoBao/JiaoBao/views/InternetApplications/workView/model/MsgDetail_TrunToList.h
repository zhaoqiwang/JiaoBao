//
//  MsgDetail_TrunToList.h
//  JiaoBao
//
//  Created by Zqw on 14-10-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDetail_TrunToList : NSObject{
    NSString *UserID;
    NSString *JiaoBaoHao;
    NSString *UnitType;
    NSString *UnitID;
    NSString *Who;
}
@property (nonatomic,strong) NSString *UserID;
@property (nonatomic,strong) NSString *JiaoBaoHao;
@property (nonatomic,strong) NSString *UnitType;
@property (nonatomic,strong) NSString *UnitID;
@property (nonatomic,strong) NSString *Who;

@end
//"TrunToList":"[{\"UserID\":6,\"JiaoBaoHao\":5150001,\"UnitType\":1,\"UnitID\":991,\"Who\":\"tomem\"}]",