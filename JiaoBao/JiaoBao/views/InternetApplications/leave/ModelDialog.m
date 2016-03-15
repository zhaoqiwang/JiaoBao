//
//  ModelDialog.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ModelDialog.h"


@implementation ModelDialog
- (void)awakeFromNib {
    self.selectedTF = [[UITextField alloc]init];
    self.selectedTF.delegate = self;
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
        [formatter setDateFormat:@"yyyy-mm-dd"];
        self.startDateTF.text = [NSString stringWithFormat:@"开始时间:%@ 8:30:00",[formatter stringFromDate:date]];
self.endDateTF.text = [NSString stringWithFormat:@"结束时间:%@ 17:30:00",[formatter stringFromDate:date]];
        
    }
    
}

- (IBAction)cancelAction:(id)sender {
    [self _doClickCloseDialog];
}

- (IBAction)doneAction:(id)sender {
    self.model.mStr_startTime = self.startDateTF.text;
    self.model.mStr_endTime = self.endDateTF.text;
    [self.delegate LeaveNowModel:self.model flag:self.flag row:self.row];
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
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    [self.selectedTF resignFirstResponder];
    if([self.selectedTF.text isEqual:self.startDateTF]){
           self.selectedTF.text = [NSString stringWithFormat:@"开始时间:%@",[formatter stringFromDate:self.datePicker.date]];
    }else{
        self.selectedTF.text = [NSString stringWithFormat:@"结束时间:%@",[formatter stringFromDate:self.datePicker.date]];

    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.selectedTF = textField;
}
@end
