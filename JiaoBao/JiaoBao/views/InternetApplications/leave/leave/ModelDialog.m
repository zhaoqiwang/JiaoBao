//
//  ModelDialog.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ModelDialog.h"
#import "MBProgressHUD+AD.h"


@implementation ModelDialog
- (void)awakeFromNib {
    self.selectedTF = self.startDateTF;
    //self.selectedTF.delegate = self;
    self.startDateTF.delegate = self;
    self.endDateTF.delegate = self;
    
    self.startDateTF.inputView = self.datePicker;
    self.endDateTF.inputView = self.datePicker;
    self.startDateTF.inputAccessoryView = self.toolBar;
    self.endDateTF.inputAccessoryView = self.toolBar;
}
//日期初始化
-(void )setUp{
    if(self.flag==0){//0是修改 1是添加
        self.startDateTF.text = [NSString stringWithFormat:@"开始时间:%@",self.model.mStr_startTime];
        self.endDateTF.text =[NSString stringWithFormat:@"结束时间:%@",self.model.mStr_endTime];
        
    }
    else{
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
        //NSDate *endDate = [date initWithTimeIntervalSinceNow:60*60];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.model.mStr_startTime = [NSString stringWithFormat:@"%@ 8:30:00",[formatter stringFromDate:date]];
        self.model.mStr_endTime = [NSString stringWithFormat:@"%@ 17:30:00",[formatter stringFromDate:date]];
        self.startDateTF.text = [NSString stringWithFormat:@"开始时间:%@",self.model.mStr_startTime];
        self.endDateTF.text = [NSString stringWithFormat:@"结束时间:%@",self.model.mStr_endTime];
        
    }
    
}
//弹出框上的取消按钮
- (IBAction)cancelAction:(id)sender {
    [self _doClickCloseDialog];
}
//弹出框上的确定按钮
- (IBAction)doneAction:(id)sender {
    //处理输入框字符串
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSArray *startArr = [self.startDateTF.text componentsSeparatedByString:@"间:"];
    NSArray *endArr = [self.endDateTF.text componentsSeparatedByString:@"间:"];
    NSString *startStr;
    NSString *endStr;
    if(startArr.count>1){
        startStr = [startArr objectAtIndex:1];
        
    }
    if(endArr.count>1){
        endStr = [endArr objectAtIndex:1];
        
    }
    
    NSDate *startDate = [dateFormatter dateFromString:startStr];
//    NSComparisonResult ComparisonResult = [startDate compare:[NSDate date]];
//    if(ComparisonResult == NSOrderedAscending){
//        [MBProgressHUD showError:@"开始时间不能小于当前时间"];
//        return;
//    }
    NSDate *endDate = [dateFormatter  dateFromString:endStr];
    //设置时间范围
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:nowDate  toDate:endDate  options:0];
    NSInteger diffMonth    = [cps month];
    if(diffMonth>=3){
        [MBProgressHUD showError:@"结束时间不能大于3个月"];
        return;
    }
    NSComparisonResult result = [endDate compare:startDate];
    if(result==NSOrderedAscending){
        [MBProgressHUD showError:@"结束时间不能小于开始时间"];
        return;
    }else if(result==NSOrderedSame){
        [MBProgressHUD showError:@"结束时间不能等于开始时间"];
        return;
    }
    self.model.mInt_flag = 3;
    self.model.mStr_startTime = startStr;
    self.model.mStr_endTime = endStr;
    //进入请假界面的回调
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveNowModel:flag:row:)]) {
        [self.delegate LeaveNowModel:self.model flag:self.flag row:self.row];
    }
    [[self.window viewWithTag:9999]removeFromSuperview];
    
}
//移除弹出框
-(void) _doClickCloseDialog  {
    [[self.window viewWithTag:9999]removeFromSuperview];
}
//toolbar上的取消按钮
- (IBAction)cancelToolAction:(id)sender {
    [self.startDateTF resignFirstResponder];
    [self.endDateTF resignFirstResponder];
}
//toolBar上的确定按钮
- (IBAction)doneToolAction:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    [self.startDateTF resignFirstResponder];
    [self.endDateTF resignFirstResponder];
    if([self.selectedTF isEqual:self.startDateTF]){
        self.startDateTF.text = [NSString stringWithFormat:@"开始时间:%@",[formatter stringFromDate:self.datePicker.date]];
        self.model.mStr_startTime = [formatter stringFromDate:self.datePicker.date];

    }else{
        self.endDateTF.text = [NSString stringWithFormat:@"结束时间:%@",[formatter stringFromDate:self.datePicker.date]];
        self.model.mStr_endTime = [formatter stringFromDate:self.datePicker.date];

    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.selectedTF = textField;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:self.model.mStr_startTime ];
    NSDate *endDate = [formatter dateFromString:self.model.mStr_endTime ];
    if([textField isEqual:self.startDateTF]){
        self.datePicker.date = startDate ;
    }else{
        self.datePicker.date = endDate ;
    }

    
    
}
@end
