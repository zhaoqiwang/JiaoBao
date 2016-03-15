//
//  ModelDialog.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ModelDialogDelegate;
@interface ModelDialog : UIView<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* selectedTF;
@property (weak, nonatomic) IBOutlet UITextField *startDateTF;
@property (weak, nonatomic) IBOutlet UITextField *endDateTF;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelToolAction:(id)sender;
- (IBAction)doneToolAction:(id)sender;
@property (weak,nonatomic) id<ModelDialogDelegate> delegate;



@end
@protocol ModelDialogDelegate <NSObject>
- (void)startText:(NSString*)startText endText:(NSString*)endText;

@end
