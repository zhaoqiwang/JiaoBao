//
//  TreeView_node.h
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeView_node : NSObject{
    
}

@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) int type; //节点类型
@property (nonatomic) id nodeData;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点
@property (nonatomic) int readflag;//阅读标记
@property (nonatomic,strong) NSString *UID;//交流时，单位ID
@property (nonatomic,assign) int mInt_select;//是否被选中，默认0，选中为1
@property (nonatomic,strong) NSString *flag;//节点标记

@end
