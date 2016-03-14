//
//  CheckLeaveModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckLeaveModel : NSObject
@property (nonatomic,strong) NSString *TabID;//假条记录ID
@property (nonatomic,strong) NSString *level;//审批级别，1-5（一级到五级）
@property (nonatomic,strong) NSString *userName;//审批人姓名
@property (nonatomic,strong) NSString *note;//批注
@property (nonatomic,strong) NSString *checkFlag;//1通过，2拒绝
- (NSMutableDictionary *)propertiesDic;



@end
