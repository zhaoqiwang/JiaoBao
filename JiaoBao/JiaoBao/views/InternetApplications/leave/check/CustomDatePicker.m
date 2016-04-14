//
//  CustomDatePicker.m
//  JiaoBao
//
//  Created by SongYanming on 16/4/13.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CustomDatePicker.h"
#import "dm.h"

@implementation CustomDatePicker
-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 216)];
    self.datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 216)];
    self.datePicker.delegate = self;
    [self addSubview:self.datePicker];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *currentDate =[NSDate date];
    self.dateString = [formatter stringFromDate:currentDate];
    self.monthArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    NSArray *ym = [self.dateString componentsSeparatedByString:@"-"];
    NSString *year = [ym objectAtIndex:0];
    self.yearArr = [NSMutableArray array];
    for(int i=-5;i<5;i++){
        NSString* currentYear = [NSString stringWithFormat:@"%d",[year intValue]+i];
        [self.yearArr addObject:currentYear];
    }
    return self;
}
-(NSString*)getDateString{
    if(!self.dateString){
        
    }
    return self.dateString;
}
#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.yearArr.count;
    }
    if(component == 1)
    {
        return self.monthArr.count;
        
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {

        return [self.yearArr objectAtIndex:row];
        
    }
    if(component == 1)
    {

        return [self.monthArr objectAtIndex:row];
        
    }
    return nil;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* yearStr;
    NSString* monthStr;
    if(component==0){
        yearStr = [self.yearArr objectAtIndex:row];

    }else{
        monthStr = [self.monthArr objectAtIndex:row];

    }
    self.dateString =[NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
}



@end
