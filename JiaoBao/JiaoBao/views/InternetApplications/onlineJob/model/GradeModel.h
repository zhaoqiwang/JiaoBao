//
//  GradeModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeModel : NSObject
@property(nonatomic,strong)NSString *TabIDStr;//
@property(nonatomic,strong)NSString *TabID;//
@property(nonatomic,strong)NSString *GradeCode;//
@property(nonatomic,strong)NSString *GradeName;//
@property(nonatomic,strong)NSString *isEnable;//
@property(nonatomic,strong)NSString *orderby;//
@property (nonatomic,assign) int mInt_select;//是否选择1，否0

@end
