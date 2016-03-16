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
    self.selectedTF = [[UITextField alloc]init];
    //self.selectedTF.delegate = self;
    self.startDateTF.delegate = self;
    self.endDateTF.delegate = self;

    self.startDateTF.inputView = self.datePicker;
    self.endDateTF.inputView = self.datePicker;
    self.startDateTF.inputAccessoryView = self.toolBar;
    self.endDateTF.inputAccessoryView = self.toolBar;
}
-(void )setUp{
    if(self.flag==0){
        self.startDateTF.text = self.model.mStr_startTime;
        self.endDateTF.text = self.model.mStr_endTime;
        
    }
    else{
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.startDateTF.text = [NSString stringWithFormat:@"开始时间:%@ 8:30:00",[formatter stringFromDate:date]];
self.endDateTF.text = [NSString stringWithFormat:@"结束时间:%@ 17:30:00",[formatter stringFromDate:date]];
        
    }
    
}

- (IBAction)cancelAction:(id)sender {
    [self _doClickCloseDialog];
}

- (IBAction)doneAction:(id)sender {
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
    NSDate *endDate = [dateFormatter  dateFromString:endStr];
    
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
    }
    self.model.mStr_startTime = self.startDateTF.text;
    self.model.mStr_endTime = self.endDateTF.text;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveNowModel:flag:row:)]) {
    [self.delegate LeaveNowModel:self.model flag:self.flag row:self.row];
    }
    [[self.window viewWithTag:9999]removeFromSuperview];

}
-(void) _doClickCloseDialog  {
    [[self.window viewWithTag:9999]removeFromSuperview];
}

- (IBAction)cancelToolAction:(id)sender {
    [self.startDateTF resignFirstResponder];
    [self.endDateTF resignFirstResponder];
}

- (IBAction)doneToolAction:(id)sender {


    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.selectedTF resignFirstResponder];
    if([self.selectedTF isEqual:self.startDateTF]){
           self.startDateTF.text = [NSString stringWithFormat:@"开始时间:%@",[formatter stringFromDate:self.datePicker.date]];
    }else{
        self.endDateTF.text = [NSString stringWithFormat:@"结束时间:%@",[formatter stringFromDate:self.datePicker.date]];

    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.selectedTF = textField;

}
@end
