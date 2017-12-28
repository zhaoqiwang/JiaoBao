//
//  PRChatControl.h
//  DocPlatform
//
//  Created by Perry on 14-9-20.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRChatApperance.h"

@class PRChatControl;

@protocol PRChatControlDelegate <NSObject>

// 图片资源下载成功后，通知外面调整大小
- (void) control:(PRChatControl *)control shouldChangeSize:(CGSize)imageSize;
- (PRChatType) chatType;
- (NSInteger) numberOfLines;
@end

@interface PRChatControl : UIView
{
    __weak id<PRChatControlDelegate> _delegate;
    PRChatType _type;
}
@property (weak, nonatomic) id<PRChatControlDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<PRChatControlDelegate>)delegate;


- (void) updateBackgroundView;
@end


@interface PRTextControl : PRChatControl
- (void) setText:(NSString *)text;
@end

@interface PRImageControl : PRChatControl
@property (strong, nonatomic) UIImageView *imageView;

- (void)setImageWithURLString:(NSString *)urlString
             placeholderImage:(UIImage *)placeholderImage;
@end

@interface PRAudioControl : PRChatControl
- (void)setAudioWithURLString:(NSString *)urlString totalTime:(CGFloat)time;

- (void) startAnimation;
- (void) stopAnimation;
@end

