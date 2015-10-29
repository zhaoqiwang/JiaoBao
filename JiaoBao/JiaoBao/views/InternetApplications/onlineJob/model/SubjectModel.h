//
//  SubjectModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject
@property(nonatomic,strong)NSString *TabID;//
@property(nonatomic,strong)NSString *VersionCode;//
@property(nonatomic,strong)NSString *VersionName;//
@property(nonatomic,strong)NSString *GradeCode;//
@property(nonatomic,strong)NSString *GradeName;//
@property(nonatomic,strong)NSString *subjectCode;//
@property(nonatomic,strong)NSString *subjectName;//
@property (nonatomic,assign) int mInt_select;//是否选择1，否0


@end

//"args1": "[{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":1,\"subjectName\":\"英语\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":2,\"subjectName\":\"语文\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":3,\"subjectName\":\"数学\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":4,\"subjectName\":\"历史\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":5,\"subjectName\":\"政治\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":6,\"subjectName\":\"物理\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":7,\"subjectName\":\"化学\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":8,\"subjectName\":\"地理\"},{\"TabID\":0,\"VersionCode\":0,\"VersionName\":null,\"GradeCode\":0,\"GradeName\":null,\"subjectCode\":9,\"subjectName\":\"生物\"}]",