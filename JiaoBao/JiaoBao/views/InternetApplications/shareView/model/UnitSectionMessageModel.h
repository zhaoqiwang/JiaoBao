//
//  UnitSectionMessageModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-19.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitSectionMessageModel : NSObject{
    NSString *UnitID;//单位ID
    NSString *UnitName;//单位名称
    NSString *IsMyUnit;//单位标识，1我所在单位，2我的上级，如果同在上级和本单位，本单位优先
    NSString *MessageCount;//未读数量
    NSString *UnitType;//教育局1，学校2
    NSString *imgName;//图片
}

@property (nonatomic,strong) NSString *UnitID;//
@property (nonatomic,strong) NSString *UnitName;//
@property (nonatomic,strong) NSString *IsMyUnit;//
@property (nonatomic,strong) NSString *MessageCount;//
@property (nonatomic,strong) NSString *UnitType;
@property (nonatomic,strong) NSString *imgName;//图片

@end
//[{"UnitID":1,"UnitName":"测试单位","IsMyUnit":2,"MessageCount":0,"UnitType":1},{"UnitID":983,"UnitName":"测试单位下级","IsMyUnit":1,"MessageCount":0,"UnitType":1},{"UnitID":987,"UnitName":"测试教育局4","IsMyUnit":2,"MessageCount":0,"UnitType":1},{"UnitID":990,"UnitName":"教育局测试4","IsMyUnit":1,"MessageCount":0,"UnitType":1},{"UnitID":991,"UnitName":"学校4","IsMyUnit":1,"MessageCount":0,"UnitType":2},{"UnitID":1070,"UnitName":"支撑学校","IsMyUnit":1,"MessageCount":5,"UnitType":2}]