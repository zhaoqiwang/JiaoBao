//
//  CustomDatePicker.h
//  JiaoBao
//
//  Created by SongYanming on 16/4/13.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView<UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *datePicker;
@property(nonatomic,strong)NSMutableArray* yearArr;
@property(nonatomic,strong)NSArray* monthArr;
@property(nonatomic,strong)NSString *dateString;
-(NSString*)getDateString;

@end
