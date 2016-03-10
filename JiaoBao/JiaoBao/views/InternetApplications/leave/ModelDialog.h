//
//  ModelDialog.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelDialog : UIView
@property (weak, nonatomic) IBOutlet UITextField *startDateTF;
@property (weak, nonatomic) IBOutlet UITextField *endDateTF;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
