//
//  PRChatTableCell.m
//  DocPlatform
//
//  Created by Perry on 14-9-26.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import "PRChatTableCell.h"
//#import "NSString+Extension.h"
//#import "NSDate+Extension.h"
#import "ExtendButton.h"

@interface PRChatTableCell () <PRChatControlDelegate>
@property (weak, nonatomic) id<PRChatTableCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *headImageView;           // 头像
@property (strong, nonatomic) UILabel *nameLabel;                   // 用户名/昵称/
@property (strong, nonatomic) UILabel *timeLabel;                   // 时间
@property (strong, nonatomic) UIImageView *unreadImagView;          // 未读
@property (strong, nonatomic) UIActivityIndicatorView *aiv;         // 发送中状态
@property (strong, nonatomic) UIButton *failedButton;              // 发送失败状态
@end

@implementation PRChatTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PRChatTableCellDelegate>)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // test
        self.backgroundColor = [UIColor clearColor];
        //self.layer.borderWidth = 2;
        //self.layer.borderColor = GrayColorBB.CGColor;
        // Initialization code
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected)
    {
        self.chatControl.alpha = 0.8;
    }
    else
    {
        self.chatControl.alpha = 1.0;
    }
}

- (void) prepareForReuse
{
    /*
    [self.headImageView removeFromSuperview];
    [self.chatControl removeFromSuperview];
    [self.nameLabel removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    [self.unreadImagView removeFromSuperview];
    
    self.headImageView = nil;
    self.chatControl = nil;
    self.nameLabel = nil;
    self.timeLabel = nil;
    self.unreadImagView = nil;
     */
    
    // 将关联的cell设置成nil
    self.chatFrame.cell = nil;
    
}

- (void) updateSendingStatus
{
    PRSendStatus status = [self.chatFrame sendStatus];
    switch (status) {
        case PRSendStatusSending:
            [self.aiv startAnimating];
            self.failedButton.hidden = YES;
            break;
        case PRSendStatusFail:
            [self.aiv stopAnimating];
            self.failedButton.hidden = NO;
            break;
        default:
            [self.aiv stopAnimating];
            self.failedButton.hidden = YES;
            break;
    }
}

- (void) updatePlayingStatus
{
    if ([_chatFrame isKindOfClass:[PRAudioChatFrame class]])
    {
        PRAudioChatFrame *audioFrame = (PRAudioChatFrame *)_chatFrame;
        if (audioFrame.playing)
        {
            // 播放动画
            [((PRAudioControl*)self.chatControl) startAnimation];
        }
        else
        {
            // 结束动画
            [((PRAudioControl*)self.chatControl) stopAnimation];
        }
    }
}

- (void) updateReadStatus
{
    if ([_chatFrame isKindOfClass:[PRAudioChatFrame class]])
    {
        if (_chatFrame.unread)
        {
            // 显示未读标志
            self.unreadImagView.hidden = NO;
        }
        else
        {
            // 隐藏未读标志
            self.unreadImagView.hidden = YES;
        }
    }
}

- (void) setChatFrame:(PRChatFrame *)chartFrame
{
    _chatFrame = chartFrame;
    _chatFrame.cell = self;    //关联frame与cell
    
    [self initializer];
}
// 初始化控件
- (void)initializer
{
    //创建头像
    if (nil == _headImageView)
    {
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:headView];
        self.headImageView = headView;
        self.headImageView.layer.cornerRadius = 20;
        self.headImageView.clipsToBounds = YES;
    }
    
    if (PRChatTypeMe == [self.chatFrame chatType])
    {
        [self.headImageView setImageWithURL:[[self.chatFrame avatar] url] placeholderImage:[PRChatApperance sharedInstance].userHeaderImage];
    }
    else if (PRChatTypeOther == [self.chatFrame chatType])
    {
        [self.headImageView setImageWithURL:[[self.chatFrame avatar] url] placeholderImage:[PRChatApperance sharedInstance].friendHeaderImage];
    }
    
    
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
    [self.headImageView addGestureRecognizer:headerTap];
    
    //创建时间
    if ([self.chatFrame needShowTime])
    {
        if (nil == _timeLabel)
        {
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.textColor = GrayColor99;
            timeLabel.font = [UIFont systemFontOfSize:12.0];
            
            [self.contentView addSubview:timeLabel];
            self.timeLabel = timeLabel;
        }
        else
        {
            self.timeLabel.hidden = NO;
        }
    }
    else
    {
        self.timeLabel.hidden = YES;
    }
    
    //创建聊天内容
    if ([self.chatFrame isKindOfClass:[PRTextChatFrame class]])
    {
        if (nil == _chatControl)
        {
            PRTextControl *textControl = [[PRTextControl alloc] initWithFrame:CGRectZero delegate:self];
            self.chatControl = textControl;
        }

        PRTextChatFrame *textFrame = (PRTextChatFrame *)_chatFrame;
        [(PRTextControl *)_chatControl setText:textFrame.text];
    }
    else if ([self.chatFrame isKindOfClass:[PRImageChatFrame class]])
    {
        if (nil == _chatControl)
        {
            PRImageControl *imageControl = [[PRImageControl alloc] initWithFrame:CGRectZero delegate:self];
            self.chatControl = imageControl;
        }
        
        PRImageChatFrame *imageFrame = (PRImageChatFrame *)_chatFrame;
        [(PRImageControl *)_chatControl setImageWithURLString:imageFrame.thumbnailURL placeholderImage:[UIImage imageNamed:@"IMDefault"]];
    }
    else if ([self.chatFrame isKindOfClass:[PRAudioChatFrame class]])
    {
        if (nil == _chatControl)
        {
            PRAudioControl *audioControl = [[PRAudioControl alloc] initWithFrame:CGRectZero delegate:self];
            self.chatControl = audioControl;
        }
        PRAudioChatFrame *audioFrame = (PRAudioChatFrame *)_chatFrame;
        [(PRAudioControl *)_chatControl setAudioWithURLString:audioFrame.audioUrl totalTime:audioFrame.totalTime];
    }
    
    [self.contentView addSubview:self.chatControl];
    
    UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
    [self.chatControl addGestureRecognizer:contentTap];
    
    UILongPressGestureRecognizer *contentLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentLongPressed:)];
    [self.chatControl addGestureRecognizer:contentLongPress];
    
    // 名字
    if ([self.chatFrame needShowName])
    {
        if (nil == _nameLabel)
        {
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:nameLabel];
            
            self.nameLabel = nameLabel;
        }
        
        
        if (PRChatTypeMe == [self.chatFrame chatType])
        {
            self.nameLabel.textAlignment = NSTextAlignmentRight;
        }
        else if (PRChatTypeOther == [self.chatFrame chatType])
        {
            self.nameLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        self.nameLabel.textColor = GrayColor99;
        self.nameLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    // 未读标志
    if ([self.chatFrame unread])
    {
        if (nil == _unreadImagView)
        {
            UIImageView *unreadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            unreadImageView.layer.cornerRadius = 4;
            unreadImageView.backgroundColor = RedColor;
            unreadImageView.clipsToBounds = YES;
            
            [self.contentView addSubview:unreadImageView];
            
            self.unreadImagView = unreadImageView;
        }
        else
        {
            self.unreadImagView.hidden = NO;
        }
        
    }
    else
    {
        self.unreadImagView.hidden = YES;
    }
    
    // loading控件
    if (nil == _aiv)
    {
        self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.aiv hidesWhenStopped];
        self.aiv.hidden = YES;
        [self addSubview:_aiv];
    }
    
    
    // 失败控件
    if (nil == _failedButton)
    {
        UIImage *failImage = [UIImage imageNamed:@"jkt_sendfail"];
        ExtendButton *failedButton = [ExtendButton buttonWithType:UIButtonTypeCustom];
        [failedButton setImage:failImage forState:UIControlStateNormal];
        failedButton.frame = CGRectMake(0, 0, failImage.size.width, failImage.size.height);
        failedButton.extendSize = CGSizeMake(44, 44);
        [failedButton addTarget:self action:@selector(failedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.failedButton = failedButton;
        self.failedButton.hidden = YES;
        [self addSubview:_failedButton];
    }
    
}



- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    
    CGFloat headOffsetY = 15;
    if ([self.chatFrame needShowTime])
    {
        headOffsetY = 50;
        
        self.timeLabel.frame = CGRectMake(15, 15, size.width-30, 21);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        dateFormatter.locale = locale;
        [dateFormatter setDateFormat:@"yyyy-MM-dd H:mm:ss"];
        
        self.timeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.chatFrame.timeInterval]];
    }
    
    CGSize controlSize = [self.chatFrame controlSize];
    
    CGFloat controlOffsetY = headOffsetY;
    if (PRChatTypeMe == [self.chatFrame chatType])
    {
        self.headImageView.frame = CGRectMake(size.width-10/*左边距*/-40/*图片宽*/, headOffsetY, 40, 40);
        
        if ([self.chatFrame needShowName])
        {
            self.nameLabel.frame = CGRectMake(PRChatControlEndMargin, headOffsetY, size.width-PRChatControlEndMargin-PRChatControlStartMargin-PRChatControlAnchorWidth, 21);
            controlOffsetY = headOffsetY + 25;
        }
        
        self.chatControl.frame = CGRectMake(size.width-PRChatControlStartMargin-controlSize.width, controlOffsetY, controlSize.width, controlSize.height);
        
        if ([self.chatFrame unread])
        {
            self.unreadImagView.frame = CGRectMake(self.chatControl.frame.origin.x-10/*未读红点与control的间距*/-8, controlOffsetY, 8, 8);
        }
        
        self.aiv.center = CGPointMake(self.chatControl.frame.origin.x - 20, CGRectGetMidY(self.chatControl.frame));
        self.failedButton.center = self.aiv.center;
        
        [self updateSendingStatus];
    }
    else if (PRChatTypeOther == [self.chatFrame chatType])
    {
        self.headImageView.frame = CGRectMake(10, headOffsetY, 40, 40);
        
        if ([self.chatFrame needShowName])
        {
            self.nameLabel.frame = CGRectMake(PRChatControlStartMargin, headOffsetY, size.width-PRChatControlEndMargin-PRChatControlStartMargin-PRChatControlAnchorWidth, 21);
            controlOffsetY = headOffsetY + 25;
        }
        
        self.chatControl.frame = CGRectMake(PRChatControlStartMargin, controlOffsetY, controlSize.width, controlSize.height);
        
        if ([self.chatFrame unread])
        {
            self.unreadImagView.frame = CGRectMake(self.chatControl.frame.origin.x+self.chatControl.frame.size.width+10/*未读红点与control的间距*/, controlOffsetY, 8, 8);
        }
        
        self.aiv.center = CGPointMake(self.chatControl.frame.origin.x+self.chatControl.frame.size.width + 20, CGRectGetMidY(self.chatControl.frame));
        self.failedButton.center = self.aiv.center;
        
        [self updateSendingStatus];
    }
}


// 图片资源下载成功后，通知外面调整大小
- (void) controlShouldChangeSize:(PRChatControl *)control
{
    
}


#pragma mark - IBAction Methods
- (void) headerTapped:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized)
    {
        if ([_delegate respondsToSelector:@selector(cellDidTappedHeader:)])
        {
            [_delegate cellDidTappedHeader:self];
        }
    }
    
}

- (void) contentTapped:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized)
    {
        if ([_delegate respondsToSelector:@selector(cellDidTappedContent:)])
        {
            [_delegate cellDidTappedContent:self];
        }
    }
}

- (void) contentLongPressed:(UILongPressGestureRecognizer *)tapGesture
{
    switch (tapGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            if ([_delegate respondsToSelector:@selector(cellDidLongPressedContent:contentRect:)])
            {
                [_delegate cellDidLongPressedContent:self contentRect:self.chatControl.frame];
            }
            break;
        default:
            break;
    }
}


- (void) failedButtonTapped:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellDidTappedFailedButton:)])
    {
        [_delegate cellDidTappedFailedButton:self];
    }
}

#pragma mark - PRChatControlDelegate Methods
- (PRChatType) chatType
{
    return [self.chatFrame chatType];
}

- (NSInteger) numberOfLines
{
    return [self.chatFrame numberOfLines];
}

- (void) control:(PRChatControl *)control shouldChangeSize:(CGSize)imageSize
{
    if ([self.chatFrame isKindOfClass:[PRImageChatFrame class]])
    {
        [((PRImageChatFrame *)self.chatFrame) setImageSize:imageSize];
    }
}


@end
