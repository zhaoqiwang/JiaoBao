//
//  CustomDatePicker.h
//  JiaoBao
//  自定日期控件 用于只选择年月
//  Created by SongYanming on 16/4/13.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView<UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *datePicker;
@property(nonatomic,strong)NSMutableArray* yearArr;
@property(nonatomic,strong)NSArray* monthArr;
@property(nonatomic,strong)NSString *dateString;//选择的日期
-(NSString*)getDateString;//获取日期
-(NSString*)getDateString2;//获取日期

@end
