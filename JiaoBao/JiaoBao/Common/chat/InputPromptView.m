//
//  InputPromptView.m
//  DocPlatform
//
//  Created by Perry on 14-11-4.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import "InputPromptView.h"

@interface InputPromptView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) NSArray *soundImageArray;
@end

@implementation InputPromptView

- (id) initWithSuperView:(UIView *)superView
{
    CGSize size = CGSizeMake(140, 140);
    self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self)
    {
        self.soundImageArray = [[NSMutableArray alloc] initWithObjects:@"jkt_sound_animate_8",@"jkt_sound_animate_8",@"jkt_sound_animate_7",@"jkt_sound_animate_6",@"jkt_sound_animate_5",@"jkt_sound_animate_4",@"jkt_sound_animate_3",@"jkt_sound_animate_2",@"jkt_sound_animate_1", nil];
        //
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jkt_sound_bg"]];
        [self addSubview:back];
        back.center = CGPointMake(size.width/2, size.height/2);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        self.imageView.image = [UIImage imageNamed:@"jkt_sound_animate_1"];
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height-30, 140, 14)];
        self.tipLabel.font = [UIFont systemFontOfSize:12.0f];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_tipLabel];
        
        
        [superView addSubview:self];
        self.center = CGPointMake(CGRectGetMidX(superView.bounds), CGRectGetMidY(superView.bounds));
    }
    
    return self;
}

- (void) setEvent:(UIControlEvents)event
{
    switch (event)
    {
        case UIControlEventTouchDown:
        case UIControlEventTouchDragEnter:
        case UIControlEventTouchDragInside:
            self.hidden = NO;
            self.imageView.image = [UIImage imageNamed:[self.soundImageArray objectAtIndex:_voiceLevel]];
            self.tipLabel.text = @"上划取消录音";
            break;
        case UIControlEventTouchDragExit:
        case UIControlEventTouchDragOutside:
            self.hidden = NO;
            self.imageView.image = [UIImage imageNamed:@"jkt_trash"];
            self.tipLabel.text = @"松开取消发送";
            break;
        case UIControlEventTouchUpInside:
            if (_delayToHide > 0)
            {
                self.imageView.image = [UIImage imageNamed:@"jkt_trash"];
                self.tipLabel.text = @"说话时间太短";
            }
            [self performSelector:@selector(HiddenView) withObject:nil afterDelay:_delayToHide];
            _delayToHide = 0;
            break;
        case UIControlEventTouchUpOutside:
            self.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)HiddenView
{
    [self setHidden:YES];
}

- (void) setVoiceLevel:(NSInteger)voiceLevel
{
    _voiceLevel = voiceLevel;
    self.imageView.image = [UIImage imageNamed:[self.soundImageArray objectAtIndex:_voiceLevel]];
}

@end
