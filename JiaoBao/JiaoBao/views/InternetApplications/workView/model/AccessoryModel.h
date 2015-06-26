//
//  AccessoryModel.h
//  JiaoBao
//
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessoryModel : NSObject{
    NSString *mStr_name;//文件名称
    int mInt_select;//文件是否勾选，0无，1选
}

@property (nonatomic,strong) NSString *mStr_name;//文件名称
@property (nonatomic,assign) int mInt_select;//文件是否勾选，0无，1选
@property(nonatomic,strong)NSString *pathStr;//附件文件路径
@property(nonatomic,strong)NSDictionary *fileAttributeDic;//保存文件属性的字典

@end
