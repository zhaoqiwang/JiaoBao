//
//  UserInformationModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationModel : NSObject
@property(nonatomic,strong)NSString *JiaoBaoHao;//教宝号
@property(nonatomic,strong)NSString *JiaoBaoHao2;//教宝号--如果是匿名回答，这里保存真实教宝号
@property(nonatomic,strong)NSString *NickName;//昵称
@property(nonatomic,strong)NSString *UserName;//姓名
@property(nonatomic,strong)NSString *IdFlag;//称号
@property(nonatomic,strong)NSString *State;//状态：1（正常）,0（禁用）

@end
