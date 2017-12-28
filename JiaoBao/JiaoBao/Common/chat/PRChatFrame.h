//
//  PRChatFrame.h
//  DocPlatform
//
//  Created by Perry on 14-9-26.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRChatApperance.h"


@class PRChatTableCell;
@class PRChatFrame;

@protocol PRChatFrameDelegate <NSObject>

// 获取类型
- (PRChatType) chatType:(PRChatFrame *)frame;

@optional
// 是否需要显示用户名字/昵称
- (BOOL) needShowName:(PRChatFrame *)frame;

// 是否需要显示时间
- (BOOL) needShowTime:(PRChatFrame *)frame;

// 获取头像路径
- (NSString *) avatarString:(PRChatFrame *)frame;

// 获取显示名称
- (NSString *) showName:(PRChatFrame *)frame;
@end

// ChatCell描述Model
@interface PRChatFrame : NSObject
{
    CGSize _controlSize;
    NSInteger _numberOfLines;   // 只对textframe有效
}

@property (weak, nonatomic) id<PRChatFrameDelegate> delegate;

@property (assign, nonatomic) long long from;                   //发送者用户ID
@property (assign, nonatomic) long long to;                     //接受者用户ID

@property (assign, nonatomic) long long fromDomainID;           //发送者的domainID
@property (assign, nonatomic) long long toDomainID;             //接受者的domainID
//@property (strong, nonatomic) NSString *headUrl;                //头像
//@property (strong, nonatomic) NSString *name;                   //用户名字
@property (assign, nonatomic) NSTimeInterval timeInterval;                   //时间
@property (assign, nonatomic) BOOL unread;                      //未读， 现在对语音消息有效
@property (assign, nonatomic) PRSendStatus sendStatus;          //发送状态
@property (strong, nonatomic) id accessory;                       //附属model
@property (weak, nonatomic) PRChatTableCell *cell;              // 所关联的table cell

@property (assign, nonatomic) BOOL timeShowing;                 // 是否正在显示时间


/**
 *  获取Cell的大小
 *
 *  @return 返回Cell的大小
 */
- (CGSize) cellSize;
/**
 *  获取Control的大小
 *
 *  @return 返回Control的大小
 */
- (CGSize) controlSize;
/**
 *  获取文本的行数
 *
 *  @return 行数
 */
- (NSInteger) numberOfLines;

/**
 *  是否需要显示时间
 *
 *  @return YES or NO
 */
- (BOOL) needShowTime;

/**
 *  获取聊天类型
 *
 *  @return 聊天类型
 */
- (PRChatType) chatType;

/**
 *  是否需要显示名字/昵称
 *
 *  @return YES OR NO
 */
- (BOOL) needShowName;

/**
 *  获取名字
 *
 *  @return 名字
 */
- (NSString *) name;

/**
 *  获取头像
 *
 *  @return 返回头像的全路径
 */
- (NSString *) avatar;

@end


@interface PRTextChatFrame : PRChatFrame
@property (strong, nonatomic) NSString *text;                   //文本
@end

@interface PRImageChatFrame : PRChatFrame
@property (strong, nonatomic) NSString *thumbnailURL;            // 缩略图片路径
@property (strong, nonatomic) NSString *originImageURL;          // 原始图路径

- (BOOL) isLocalAddress;    // 资源是否是本地路径

// 图片下载成功后，需要重新计算大小
- (void) setImageSize:(CGSize)imageSize;
@end

@interface PRAudioChatFrame : PRChatFrame
@property (strong, nonatomic) NSString *audioUrl;               // 音频数据
@property (assign, nonatomic) CGFloat totalTime;                // 总时长
@property (assign, nonatomic) BOOL playing;                     // 是否播放状态

- (BOOL) isLocalAddress;    // 资源是否是本地路径
@end

@interface PRVideoChatFrame : PRChatFrame
@property (strong, nonatomic) NSString *videoUrl;               //视频路径
@end