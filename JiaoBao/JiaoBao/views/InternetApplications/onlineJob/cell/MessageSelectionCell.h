//
//  MessageSelectionCell.h
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//短信勾选自定义cell

#import <UIKit/UIKit.h>
@protocol MessageSelectionCellDelegate;


@interface MessageSelectionCell : UITableViewCell
@property(weak,nonatomic)id<MessageSelectionCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *notificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
@property(nonatomic,assign)NSUInteger btnTag;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线

- (IBAction)buttonSelectionAction:(id)sender;

@end
@protocol MessageSelectionCellDelegate <NSObject>
-(void)MessageSelectionActionWithButtonTag0:(NSUInteger)tag0 tag1:(NSUInteger)tag1;//tag0家长通知 tag1反馈（0是没选中 1是选中）
@end