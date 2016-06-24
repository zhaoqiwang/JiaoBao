//
//  Mode_Selection_Cell.h
//  JiaoBao
//  模式选择自定义cell
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ModelSelectionCellDelegate;
@interface Mode_Selection_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *characterButton;//个性
@property (weak, nonatomic) IBOutlet UIButton *sameButton;//统一
@property (weak, nonatomic) IBOutlet UIButton *customButton;//自定义
@property(weak,nonatomic)id<ModelSelectionCellDelegate>delegate;
- (IBAction)modeSelectionAction:(id)sender;//选择模式方法
@property (weak, nonatomic) IBOutlet UIButton *abButton;//AB卷

@end
//选择模式代理
@protocol ModelSelectionCellDelegate <NSObject>
-(void)modeSelectionActionWithButtonTag:(NSUInteger)tag;//0个性 1统一 2自定义
@end