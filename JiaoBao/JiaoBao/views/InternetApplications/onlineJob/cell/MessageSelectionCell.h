//
//  MessageSelectionCell.h
//  JiaoBao
//  短信勾选自定义cell
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageSelectionCellDelegate;


@interface MessageSelectionCell : UITableViewCell
@property(weak,nonatomic)id<MessageSelectionCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *notificationBtn;//家长通知
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;//反馈
@property(nonatomic,assign)NSUInteger btnTag;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线
//短信勾选方法
- (IBAction)buttonSelectionAction:(id)sender;

@end
@protocol MessageSelectionCellDelegate <NSObject>
//短信勾选回调
-(void)MessageSelectionActionWithButtonTag0:(NSUInteger)tag0 tag1:(NSUInteger)tag1;//tag0家长通知 tag1反馈（0是没选中 1是选中）
@end