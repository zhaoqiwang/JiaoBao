//
//  SMSTreeArrayModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-12.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSTreeArrayModel : NSObject{
    NSString *name;//分组名称
    NSMutableArray *smsTree;//每个分组中的列表
}

@property (nonatomic,strong) NSString *name;//分组名称
@property (nonatomic,strong) NSMutableArray *smsTree;//每个分组中的列表

@end
