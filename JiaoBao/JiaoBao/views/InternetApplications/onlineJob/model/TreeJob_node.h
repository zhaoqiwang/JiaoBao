//
//  TreeJob_node.h
//  JiaoBao
//  发布作业的每个节点
//  Created by Zqw on 15/10/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeJob_node : NSObject

@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) int type; //节点类型
@property (nonatomic) int faType; //父节点
@property (nonatomic) id nodeData;//当前节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点
@property (nonatomic,assign) int mInt_index;//每个节点在全局中的索引
//@property (nonatomic) int readflag;//阅读标记
//@property (nonatomic,strong) NSString *UID;//交流时，单位ID
//@property (nonatomic,assign) int mInt_select;//是否被选中，默认0，选中为1
@property (nonatomic,assign) int flag;//节点标记，当前节点是哪个，主要是一级列表
//@property (nonatomic,strong) NSString *nodeFlag;//当前数据的唯一标识，循环计算是否点击用

@end
