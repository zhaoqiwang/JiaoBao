//
//  PRChatApperance.h
//  DocPlatform
//
//  Created by Perry on 14-9-19.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const CGFloat PRChatControlStartMargin;
extern const CGFloat PRChatControlEndMargin;
extern const CGFloat PRChatControlAnchorWidth;
extern const CGFloat PRChatControlMinHeight;

extern const CGFloat PRChatTextStartMargin;  //文本离背景头部尖端的距离
extern const CGFloat PRChatTextEndMargin;     //文本离背景的尾端距离
extern const CGFloat PRChatTextTopMargin;
extern const CGFloat PRChatTextBottomMargin;

extern const CGFloat PRChatImageStartMargin;       //图片离背景头部尖端的边距
extern const CGFloat PRChatImageEndMargin;
extern const CGFloat PRChatImageTopMargin;
extern const CGFloat PRChatImageBottomMargin;

typedef NS_ENUM(NSUInteger, PRChatType)
{
    PRChatTypeNone,     //初始值
    PRChatTypeMe,       //自己的消息
    PRChatTypeOther     //别人的消息
};

/**
 *  信息发送状态
 */
typedef NS_ENUM(NSUInteger, PRSendStatus)
{
    /**
     *  正在发送中
     */
    PRSendStatusSending = 0,
    /**
     *  发送成功
     */
    PRSendStatusOK = 1,
    /**
     *  发送失败
     */
    PRSendStatusFail = -1,
    /**
     *  文件提交成功
     */
    PRSendStatusFileUploaded = 2
};

@interface PRChatApperance : NSObject
+ (PRChatApperance *) sharedInstance;

@property (strong, nonatomic) UIImage *userHeaderImage;
@property (strong, nonatomic) UIImage *friendHeaderImage;
/*
// 左侧对方的聊天窗口背景图片
@property (strong, nonatomic) UIImage *leftBackgroundImageForOther;
@property (strong, nonatomic) UIImage *middleBackgroundImageForOther;
@property (strong, nonatomic) UIImage *rightBackgroundImageForOther;

// 右侧己方的聊天窗口背景图片
@property (strong, nonatomic) UIImage *leftBackgroundImageForMe;
@property (strong, nonatomic) UIImage *middleBackgroundImageForMe;
@property (strong, nonatomic) UIImage *rightBackgroundImageForMe;

// 字体颜色
@property (strong, nonatomic) UIColor *textColorForOther;
@property (strong, nonatomic) UIColor *textColorForMe;

@property (strong, nonatomic) UIFont *textFont;

// 语音播放icon
@property (strong, nonatomic) UIImage *audioPlayIcon;       // 播放按钮
@property (strong, nonatomic) UIImage *audioPauseIcon;      // 暂停按钮
@property (strong, nonatomic) UIImage *audioPlayingIcon;    // 正在播放按钮

// 占位图片
@property (strong, nonatomic) UIImage *placeholderImage;
// 图片加载失败占位图片
@property (strong, nonatomic) UIImage *failPlaceholderImage;
*/
@end
