//
//  CustomDatePicker.h
//  JiaoBao
//  自定日期控件 
//  Created by SongYanming on 16/4/13.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView<UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *datePicker;//日期选择控件
@property(nonatomic,strong)NSMutableArray* yearArr;//选择年的数组
@property(nonatomic,strong)NSArray* monthArr;//选择月的数组
@property(nonatomic,strong)NSString *dateString;//选择的日期
@property(nonatomic,strong)NSString *dateString2;//选择的日期

-(NSString*)getDateString;//获取日期（yyyy-MM）
-(NSString*)getDateString2;//获取日期（yyyy-MM-01）

@end
