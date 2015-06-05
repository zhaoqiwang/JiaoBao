//
//  PersonalSpaceModel.h
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalSpaceModel : NSObject{
    NSString *mStr_trueName;//真实姓名或标题
    NSString *mStr_nickName;//昵称或标题对应的值
}

@property (nonatomic,strong) NSString *mStr_trueName;//真实姓名或标题
@property (nonatomic,strong) NSString *mStr_nickName;//昵称或标题对应的值

@end
