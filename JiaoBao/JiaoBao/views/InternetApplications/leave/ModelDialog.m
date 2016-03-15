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
        
    }
    else{
        
    }
    
}

- (IBAction)cancelAction:(id)sender {
    [self _doClickCloseDialog];
}

- (IBAction)doneAction:(id)sender {
    [self.delegate startText:self.startDateTF.text endText:self.endDateTF.text];
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
    self.selectedTF.text = [formatter stringFromDate:self.datePicker.date];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.selectedTF = textField;
}
@end
