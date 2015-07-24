//
//  PRChatTableCell.h
//  DocPlatform
//
//  Created by Perry on 14-9-26.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRChatFrame.h"
#import "PRChatControl.h"

@class PRChatTableCell;

@protocol PRChatTableCellDelegate <NSObject>
@optional
- (void) cellDidTappedHeader:(PRChatTableCell *)cell;
- (void) cellDidTappedContent:(PRChatTableCell *)cell;
- (void) cellDidLongPressedContent:(PRChatTableCell *)cell contentRect:(CGRect)cRect;   //cRect，相对于Cell的位置
- (void) cellDidTappedFailedButton:(PRChatTableCell *)cell;
- (void) cellShouldUpdateHeight:(PRChatTableCell *)cell;
@end

@interface PRChatTableCell : UITableViewCell

@property (weak, nonatomic) PRChatFrame *chatFrame;

@property (strong, nonatomic) PRChatControl *chatControl;           // 聊天内容


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PRChatTableCellDelegate>)delegate;



// 供PRChatFrame调用
- (void) updateSendingStatus;
- (void) updatePlayingStatus;
- (void) updateReadStatus;
@end
