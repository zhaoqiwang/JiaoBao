//
//  Mode_Selection_Cell.h
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//模式选择自定义cell

#import <UIKit/UIKit.h>
@protocol ModelSelectionCellDelegate;
@interface Mode_Selection_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *characterButton;
@property (weak, nonatomic) IBOutlet UIButton *sameButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
@property(weak,nonatomic)id<ModelSelectionCellDelegate>delegate;
- (IBAction)modeSelectionAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *abButton;

@end
@protocol ModelSelectionCellDelegate <NSObject>
-(void)modeSelectionActionWithButtonTag:(NSUInteger)tag;//0个性 1统一 2自定义
@end