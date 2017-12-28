//
//  PRChatFrame.m
//  DocPlatform
//
//  Created by Perry on 14-9-26.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import "PRChatFrame.h"
#import "PRChatTableCell.h"

#define AppSize [UIScreen mainScreen].applicationFrame.size

#define PRChatControlMaxWidth (AppSize.width - PRChatControlStartMargin - PRChatControlEndMargin - PRChatTextStartMargin - PRChatTextEndMargin)


const CGSize PRChatDefaultImageSize = {109, 100};

@interface PRChatFrame ()
{
    
}
@end

@implementation PRChatFrame

- (id) init
{
    self = [super init];
    if (self)
    {
        _unread = NO;
    }
    
    return self;
}

- (void) setUnread:(BOOL)unread
{
    _unread = unread;
    
    [self.cell updateReadStatus];
}

- (void) setSendStatus:(PRSendStatus)sendStatus
{
    _sendStatus = sendStatus;
    
    [self.cell performSelectorOnMainThread:@selector(updateSendingStatus) withObject:nil waitUntilDone:NO];
}


- (CGSize) cellSize
{
    if (0 == _controlSize.width)
    {
        [self controlSize];
    }
    
    CGFloat height = _controlSize.height+15+5;
    if ([self needShowTime])
    {
        height += 35;
    }
    if ([self needShowName])
    {
        height += 25;
    }
    return CGSizeMake(AppSize.width, height);
}

- (CGSize) controlSize
{
    return CGSizeZero;
}

- (NSInteger) numberOfLines
{
    return 1;
}


- (BOOL) needShowTime
{
    if ([_delegate respondsToSelector:@selector(needShowTime:)])
    {
        _timeShowing = [_delegate needShowTime:self];
    }
    
    return _timeShowing;
}

- (PRChatType) chatType
{
    return [_delegate chatType:self];
}

- (BOOL) needShowName
{
    if ([_delegate respondsToSelector:@selector(needShowName:)])
    {
        [_delegate needShowName:self];
    }
    return NO;
}


- (NSString *) name
{
    if ([_delegate respondsToSelector:@selector(showName:)])
    {
        return [_delegate showName:self];
    }
    
    return nil;
}


- (NSString *) avatar
{
    if ([_delegate respondsToSelector:@selector(avatarString:)])
    {
        return [_delegate avatarString:self];
    }
    
    return nil;
}

@end


@implementation PRTextChatFrame

//- (CGSize) cellSize
//{
//    if (0 == _controlSize.width)
//    {
//        [self controlSize];
//    }
//    
//    CGFloat height = _controlSize.height+15+5;
//    if ([self needShowTime])
//    {
//        height += 35;
//    }
//    if ([self needShowName])
//    {
//        height += 25;
//    }
//    return CGSizeMake(AppSize.width, height);
//}

- (CGSize) controlSize
{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(PRChatControlMaxWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    _numberOfLines = ceilf(rect.size.height/18);
    
    _controlSize = CGSizeMake(ceilf(rect.size.width)+PRChatTextStartMargin+PRChatTextEndMargin, ceilf(rect.size.height)+PRChatTextTopMargin+PRChatTextBottomMargin);
    
    // 如果只有一行，默认高度是40
    if (1 == _numberOfLines)
    {
        _controlSize.height = 40;
    }
    
    return _controlSize;
}

- (NSInteger) numberOfLines
{
    return _numberOfLines;
}

@end

@implementation PRImageChatFrame

//- (CGSize) cellSize
//{
//    if (0 == _controlSize.width)
//    {
//        [self controlSize];
//    }
//    
//    return CGSizeMake(AppSize.width, _controlSize.height+15+5);
//}

- (CGSize) controlSize
{
    if (0 == _controlSize.width)
    {
        _controlSize = PRChatDefaultImageSize;
    }
    
    return _controlSize;
}

- (void) setImageSize:(CGSize)imageSize
{
#warning TODO 未实现图片大小适配的逻辑
    return;
    //_controlSize = CGSizeMake(imageSize.width+PRChatImageStartMargin+PRChatImageEndMargin, imageSize.height+PRChatImageTopMargin+PRChatTextBottomMargin);
    CGSize size = CGSizeZero;
    if (imageSize.width < 100 && imageSize.height < 100)
    {
        //
    }
    if (size.width > size.height)
    {
        _controlSize.width = 100;
        _controlSize.height = PRChatDefaultImageSize.width/imageSize.width * PRChatDefaultImageSize.height;
    }
    else
    {
        
    }
}

- (BOOL) isLocalAddress
{
    if ([_originImageURL hasPrefix:@"http://"])
    {
        return NO;
    }
    
    return YES;
}

@end

@implementation PRAudioChatFrame

- (CGSize) controlSize
{
    _controlSize = CGSizeMake(96, 40);
    
    if (_totalTime <= 10)
    {
        _controlSize.width = 96;
    }
    else if (_totalTime > 10 && _totalTime <= 20)
    {
        _controlSize.width = 96+25;
    }
    else if (_totalTime > 20 && _totalTime <= 30)
    {
        _controlSize.width = 96+35;
    }
    else if (_totalTime > 30 && _totalTime <= 40)
    {
        _controlSize.width = 96+45;
    }
    else if (_totalTime > 40 && _totalTime <= 50)
    {
        _controlSize.width = 96+55;
    }
    else if (_totalTime > 50 && _totalTime <= 60)
    {
        _controlSize.width = 96+60;
    }
    else
    {
        _controlSize.width = 156;
    }
    
    
    return _controlSize;
}

- (void) setPlaying:(BOOL)playing
{
    _playing = playing;
    
    [self.cell updatePlayingStatus];
}

- (BOOL) isLocalAddress
{
    if ([_audioUrl hasPrefix:@"http"])
    {
        return NO;
    }
    
    return YES;
}

@end

@implementation PRVideoChatFrame
@end