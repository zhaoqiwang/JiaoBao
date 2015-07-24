//
//  PRChatControl.m
//  DocPlatform
//
//  Created by Perry on 14-9-20.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import "PRChatControl.h"

@interface PRChatControl ()
/*
@property (strong, nonatomic) UIImageView *leftBackgroundView;
@property (strong, nonatomic) UIImageView *middleBackgroundView;
@property (strong, nonatomic) UIImageView *rightBackgroundView;
*/
@property (strong, nonatomic) UIImageView *backgroundImageView;
@end

@implementation PRChatControl
@synthesize delegate = _delegate;


- (void) setDelegate:(id<PRChatControlDelegate>)delegate
{
    _delegate = delegate;
    
    if (PRChatTypeMe == [_delegate chatType])
    {
        //self.backgroundColor = BlueColor;
    }
    else if (PRChatTypeOther == [_delegate chatType])
    {
        //self.backgroundColor = WhiteColorFF;
    }
}


- (id)initWithFrame:(CGRect)frame delegate:(id<PRChatControlDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*
        self.leftBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.middleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.rightBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_leftBackgroundView];
        [self addSubview:_middleBackgroundView];
        [self addSubview:_rightBackgroundView];
         */
        self.delegate = delegate;
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_backgroundImageView];
    }
    return self;
}

- (void) updateBackgroundView
{
    if (PRChatTypeMe == [_delegate chatType])
    {
        self.backgroundImageView.image = [[UIImage imageNamed:@"bk_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 10, 30) resizingMode:UIImageResizingModeTile];
    }
    else if (PRChatTypeOther == [_delegate chatType])
    {
        self.backgroundImageView.image = [[UIImage imageNamed:@"bk_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 30, 10, 8) resizingMode:UIImageResizingModeTile];
    }
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    [self updateBackgroundView];
    
    /*
    CGRect bounds = self.bounds;
    
    CGSize leftImageSize;
    CGSize rightImageSize;
     
    
    PRChatApperance *chatApperance = [PRChatApperance sharedInstance];
    // 左侧
    if (PRChatTypeOther == [_delegate chatType])
    {
        
        self.leftBackgroundView.image = [chatApperance leftBackgroundImageForOther];
        self.middleBackgroundView.image = [chatApperance middleBackgroundImageForOther];
        self.rightBackgroundView.image = [chatApperance rightBackgroundImageForOther];
        
        UIImage *leftImage = [chatApperance leftBackgroundImageForOther];
        UIImage *rightImage = [chatApperance rightBackgroundImageForOther];
        
        leftImageSize = leftImage.size;
        rightImageSize = rightImage.size;
        
    }
    else if (PRChatTypeMe == [_delegate chatType])   // 右侧
    {
        
        self.leftBackgroundView.image = [chatApperance leftBackgroundImageForMe];
        self.middleBackgroundView.image = [chatApperance middleBackgroundImageForMe];
        self.rightBackgroundView.image = [chatApperance rightBackgroundImageForMe];
        
        UIImage *leftImage = [chatApperance leftBackgroundImageForMe];
        UIImage *rightImage = [chatApperance rightBackgroundImageForMe];
        
        leftImageSize = leftImage.size;
        rightImageSize = rightImage.size;
        
    }
    else
    {
        
    }
    
    
    self.leftBackgroundView.frame = CGRectMake(0, 0, leftImageSize.width, bounds.size.height);
    self.middleBackgroundView.frame = CGRectMake(leftImageSize.width, 0, bounds.size.width-leftImageSize.width-rightImageSize.width, bounds.size.height);
    self.rightBackgroundView.frame = CGRectMake(bounds.size.width-rightImageSize.width, 0, rightImageSize.width, bounds.size.height);
     */
}

@end



@interface PRTextControl ()
@property (strong, nonatomic) UILabel *textLabel;
@end


@implementation PRTextControl

- (void) setText:(NSString *)text
{
    self.textLabel.text = text;
    
    // 必须要刷新下背景，因为重用的时候，很可能不调用layoutSubviews。 造成我的和对方的背景图片串掉
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<PRChatControlDelegate>)delegate
{
    self = [super initWithFrame:frame delegate:delegate];
    if (self) {
        // Initialization code
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        [self addSubview:_textLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    // 一行的时候，高度只有40
    UIEdgeInsets edgeInsets;
    if (fabs(bounds.size.height - 40.0f) < 0.1)
    {
        edgeInsets = UIEdgeInsetsMake(11, 0, 11, 0);
    }
    else
    {
        edgeInsets = UIEdgeInsetsMake(PRChatTextTopMargin, 0, PRChatTextBottomMargin, 0);
    }
    
    
    // 左侧
    if (PRChatTypeOther == [_delegate chatType])
    {
        edgeInsets.left = PRChatTextStartMargin;
        edgeInsets.right = PRChatTextEndMargin;
        self.textLabel.textColor = BlackColor33;
    }
    else if (PRChatTypeMe == [_delegate chatType])   // 右侧
    {
        edgeInsets.left = PRChatTextEndMargin;
        edgeInsets.right = PRChatTextStartMargin;
        self.textLabel.textColor = WhiteColorFF;
    }
    else
    {
        
    }
    
    self.textLabel.numberOfLines = [_delegate numberOfLines];
    //self.textLabel.backgroundColor = [UIColor greenColor];
    self.textLabel.frame = UIEdgeInsetsInsetRect(bounds, edgeInsets);
}

@end



@interface PRImageControl ()

@end

@implementation PRImageControl

- (void)setImageWithURLString:(NSString *)urlString
             placeholderImage:(UIImage *)placeholderImage
{
    if (![urlString hasPrefix:@"http"])
    {
        // 从本地读取
        UIImage *image = [UIImage imageWithContentsOfFile:urlString];
        if (image)
        {
            self.imageView.image = image;
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:@"IMFailed"];
        }
        
        [self setNeedsLayout];
        return;
    }
    
    __weak PRImageControl *weakSelf = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        if (nil == error)
        {
            // 成功得到图片
            if ([weakSelf.delegate respondsToSelector:@selector(control:shouldChangeSize:)])
            {
                [weakSelf.delegate control:weakSelf shouldChangeSize:image.size];
            }
        }
        else if (nil != error)
        {
            weakSelf.imageView.image = [UIImage imageNamed:@"IMFailed"];
        }
    }];
    
    [self setNeedsLayout];
}



- (id)initWithFrame:(CGRect)frame delegate:(id<PRChatControlDelegate>)delegate
{
    self = [super initWithFrame:frame delegate:delegate];
    if (self)
    {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(PRChatImageTopMargin, 0, PRChatImageBottomMargin, 0);
    
    if (PRChatTypeMe == [_delegate chatType])
    {
        edgeInsets.left = PRChatImageEndMargin;
        edgeInsets.right = PRChatImageStartMargin;
    }
    else if (PRChatTypeOther == [_delegate chatType])
    {
        edgeInsets.left = PRChatImageStartMargin;
        edgeInsets.right = PRChatImageEndMargin;
    }

    self.imageView.frame = UIEdgeInsetsInsetRect(self.bounds, edgeInsets);
}

@end




// 播放按钮距离的边距
//const CGFloat AudioControl_PlayIcon_Margin = 12;
// 文字距离播放按钮的距离
const CGFloat AudioControl_TimeLabel_Margin = 10;


@interface PRAudioControl()
// 播放按钮
@property (strong, nonatomic) UIImageView *playIcon;
@property (strong, nonatomic) UILabel *timeLabel;

//@property (strong, nonatomic) PRAudioLoader *audioLoader;
@end

@implementation PRAudioControl

- (void)setAudioWithURLString:(NSString *)urlString totalTime:(CGFloat)time
{
    self.timeLabel.text = [NSString stringWithFormat:@"%d''", (int)(time+0.5)];
    
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<PRChatControlDelegate>)delegate
{
    self = [super initWithFrame:frame delegate:delegate];
    if (self) {
        // Initialization code
        self.playIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        
        // 左侧
        if (PRChatTypeOther == [_delegate chatType])
        {
            self.playIcon.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"voice_0@2x.png"], [UIImage imageNamed:@"voice_blue_1@2x.png"], [UIImage imageNamed:@"voice_blue_2@2x.png"], [UIImage imageNamed:@"voice_blue_3@2x.png"], nil];
            
            self.playIcon.image = [UIImage imageNamed:@"voice_blue_3"];
        }
        else if (PRChatTypeMe == [_delegate chatType])   // 右侧
        {
            self.playIcon.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"voice_0@2x.png"], [UIImage imageNamed:@"voice_white_1@2x.png"], [UIImage imageNamed:@"voice_white_2@2x.png"], [UIImage imageNamed:@"voice_white_3@2x.png"], nil];
            
            self.playIcon.image = [UIImage imageNamed:@"voice_white_3"];
        }
        else
        {
            
        }
        
        self.playIcon.animationRepeatCount = 0;
        self.playIcon.animationDuration = 1;
        
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:15.0];
        
        [self addSubview:_playIcon];
        [self addSubview:_timeLabel];
    }
    return self;
}


- (void) startAnimation
{
    [self.playIcon startAnimating];
}

- (void) stopAnimation
{
    [self.playIcon stopAnimating];
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGSize playIconSize = self.playIcon.frame.size;
    
    // 左侧
    if (PRChatTypeOther == [_delegate chatType])
    {
        self.timeLabel.textColor = BlackColor33;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.playIcon.frame = CGRectMake(PRChatTextStartMargin, CGRectGetMidY(bounds)-playIconSize.height/2.0f, playIconSize.width, playIconSize.height);
        
        CGPoint timeLabelOrigin = CGPointMake(PRChatTextStartMargin+playIconSize.width+AudioControl_TimeLabel_Margin, CGRectGetMidY(bounds)-10.0f);
        self.timeLabel.frame = CGRectMake(timeLabelOrigin.x, timeLabelOrigin.y, bounds.size.width-timeLabelOrigin.x, 20.0);
    }
    else if (PRChatTypeMe == [_delegate chatType])   // 右侧
    {
        self.timeLabel.textColor = WhiteColorFF;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
        self.playIcon.frame = CGRectMake(bounds.size.width-PRChatTextStartMargin-playIconSize.width, CGRectGetMidY(bounds)-playIconSize.height/2.0f, playIconSize.width, playIconSize.height);
        
        CGPoint timeLabelOrigin = CGPointMake(0, CGRectGetMidY(bounds)-10.0f);
        self.timeLabel.frame = CGRectMake(timeLabelOrigin.x, timeLabelOrigin.y, bounds.size.width-timeLabelOrigin.x-playIconSize.width-PRChatTextStartMargin-AudioControl_TimeLabel_Margin, 20.0f);
        
    }
}

@end
