//
//  VersionModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionModel : NSObject
@property(nonatomic,strong)NSString *TabID;//
@property(nonatomic,strong)NSString *VersionCode;//
@property(nonatomic,strong)NSString *VersionName;//
@property(nonatomic,strong)NSString *GradeCode;//
@property(nonatomic,strong)NSString *GradeName;//
@property(nonatomic,strong)NSString *subjectCode;//
@property(nonatomic,strong)NSString *subjectName;//
@property (nonatomic,assign) int mInt_select;//是否选择1，否0

@end
//"args2": "[{\"TabID\":418,\"VersionCode\":3,\"VersionName\":\"人教新课标\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null},{\"TabID\":477,\"VersionCode\":4,\"VersionName\":\"冀教版\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null},{\"TabID\":502,\"VersionCode\":5,\"VersionName\":\"五四制-鲁教版\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null},{\"TabID\":542,\"VersionCode\":7,\"VersionName\":\"北师大版\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null},{\"TabID\":603,\"VersionCode\":13,\"VersionName\":\"沪教牛津版\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null},{\"TabID\":612,\"VersionCode\":16,\"VersionName\":\"外研新课标\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null},{\"TabID\":697,\"VersionCode\":33,\"VersionName\":\"译林牛津版\",\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":0,\"subjectName\":null}]",