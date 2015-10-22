//
//  TreeJob_class_model.h
//  JiaoBao
//  布置作业的班级选择model
//  Created by Zqw on 15/10/15.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeJob_class_model : NSObject

@property (nonatomic,strong) NSString *mStr_className;//班级名称
@property (nonatomic,assign) int mInt_class;//班级是否选择1，否0
@property (nonatomic,assign) int mInt_difficulty;//难度
@property (nonatomic,strong) NSString *mStr_tableId;//id号

@end
