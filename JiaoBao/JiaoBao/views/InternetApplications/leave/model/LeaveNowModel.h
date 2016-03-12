//
//  LeaveNowModel.h
//  JiaoBao
//  请假界面，区分是哪个cell
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveNowModel : NSObject

@property (nonatomic,assign) int mInt_flag;//判断是哪个cell，0选人，1理由选择，2理由填写，3时间，4添加时间段，5提交
@property (nonatomic,strong) NSString *mStr_name;//名称
@property (nonatomic,strong) NSString *mStr_value;//选择的值，开始时间
@property (nonatomic,strong) NSString *mStr_value1;//选择的值，结束时间

@end
