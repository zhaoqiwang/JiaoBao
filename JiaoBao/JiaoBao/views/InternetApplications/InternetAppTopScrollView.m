//
//  InternetAppTopScrollView.m
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "InternetAppTopScrollView.h"

//按钮空隙
#define BUTTONGAP 40
//按钮长度
#define BUTTONWIDTH 100
//按钮高度
#define BUTTONHEIGHT 28
//滑条CONTENTSIZEX
#define CONTENTSIZEX [dm getInstance].width

#define BUTTONID (sender.tag-100)

@implementation InternetAppTopScrollView
@synthesize mArr_name,mImgV_slide,mInt_scrollViewSelectedChannelID,mInt_userSelectedChannelID,mInt_share,mInt_show,mInt_show2,mInt_theme,mInt_work_mysend,mInt_work_sendToMe;

+ (InternetAppTopScrollView *)shareInstance {
    static InternetAppTopScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 49+[dm getInstance].statusBar, [dm getInstance].width, 40)];
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, [dm getInstance].height-48, [dm getInstance].width, 48)];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //通知界面更新未读消息数量
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUnReadMsgPic) name:@"UnReadMsg" object:nil];
        //展示未读数量
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showUnReadMSG" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUnReadMSG) name:@"showUnReadMSG" object:nil];
        //分享未读数量
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareUnReadMSG" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareUnReadMSG) name:@"shareUnReadMSG" object:nil];
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = YES;
        self.contentSize = CGSizeMake([dm getInstance].width, 48);
        if (SHOWRONGYUN == 1) {
            self.mArr_name = [[NSMutableArray alloc] initWithObjects:@"交流",@"事务", @"分享",@"学校圈",@"主题", nil];
        }else{
            self.mArr_name = [[NSMutableArray alloc] initWithObjects:@" 求知 ",@"学校圈",@" 事务 ", nil];
        }
        
        mInt_userSelectedChannelID = 100;
        mInt_scrollViewSelectedChannelID = 100;
        
        [self initWithNameButtons];
    }
    return self;
}

- (void)initWithNameButtons{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    int tempWidth = [dm getInstance].width/self.mArr_name.count;
    //分割线
    UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, .5)];
    tempLab.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    [self addSubview:tempLab];
    
    for (int i = 0; i < [self.self.mArr_name count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
        [button setTag:i+100];
        if (i+100 == mInt_scrollViewSelectedChannelID) {
            button.selected = YES;
        }
        CGSize tempSize = [[self.mArr_name objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:11]];
        [button setTitle:[NSString stringWithFormat:@"%@",[self.mArr_name objectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [button setTitleColor:[UIColor colorWithRed:130/255.0 green:129/255.0 blue:130/255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:91/255.0 green:178/255.0 blue:57/255.0 alpha:1] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        //设置标题位置
//        if (i>=1) {
//            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rootTable_%d",i+2]] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rootTableSelect_%d",i+2]] forState:UIControlStateSelected];
//        }else{
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rootTable_%d",i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rootTableSelect_%d",i]] forState:UIControlStateSelected];
//        }
        
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        button.imageEdgeInsets = UIEdgeInsetsMake(4,(tempWidth-25)/2,21,(tempWidth-25)/2);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        button.titleEdgeInsets = UIEdgeInsetsMake(32, -(tempWidth-tempSize.width)/2-2, 4, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        button.titleEdgeInsets = UIEdgeInsetsMake(32, -(tempWidth-tempSize.width)/2+10, 4, 0);
//        button.imageEdgeInsets = UIEdgeInsetsMake(4,0,21,(tempWidth-25)/2);
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        button.titleEdgeInsets = UIEdgeInsetsMake(32, (tempWidth-tempSize.width)/2-2, 4, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        [self addSubview:button];
        //添加红色提醒图片
        //计算按钮中文字的坐标
//        CGSize tempSize = [[self.mArr_name objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:11]];
        UIImage *image = [UIImage imageNamed:@"top_dian"];
        UIImageView *tempImgV = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x+tempSize.width+(button.frame.size.width-tempSize.width)/2, 4, image.size.width, image.size.height)];
        [tempImgV setImage:image];
        tempImgV.tag = button.tag+100;
        tempImgV.hidden = YES;
        [self addSubview:tempImgV];
        
        D("tempImag-==%ld,%@",(long)tempImgV.tag,NSStringFromCGRect(tempImgV.frame));
    }
}

//添加未读消息红点提醒
-(void)addUnReadMsgPic{
    //第0个点
//    UIImageView *tempImaV;
//    if (SHOWRONGYUN == 1) {
//        tempImaV = (UIImageView *)[self viewWithTag:201];
//    }else{
//        tempImaV = (UIImageView *)[self viewWithTag:200];
//    }
//    if (([[dm getInstance].unReadMsg1 intValue] + [[dm getInstance].unReadMsg2 intValue])>0) {
//        tempImaV.hidden = NO;
//    } else {
//        tempImaV.hidden = YES;
//    }
}

//展示未读数量
-(void)showUnReadMSG{
    
//    UIImageView *tempImaV;
//    if (SHOWRONGYUN == 1) {
//        tempImaV = (UIImageView *)[self viewWithTag:203];
//    }else{
//        tempImaV = (UIImageView *)[self viewWithTag:202];
//    }
//    if ([dm getInstance].mImt_showUnRead>0) {
//        tempImaV.hidden = NO;
//    } else {
//        tempImaV.hidden = YES;
//    }
    
}

//分享未读数量
-(void)shareUnReadMSG{
    UIImageView *tempImaV;
    if (SHOWRONGYUN == 1) {
        tempImaV = (UIImageView *)[self viewWithTag:202];
    }else{
        tempImaV = (UIImageView *)[self viewWithTag:201];
    }
    if ([dm getInstance].mImt_shareUnRead>0) {
        tempImaV.hidden = NO;
    } else {
        tempImaV.hidden = YES;
    }
}

- (void)selectNameButton:(UIButton *)sender{
    //CheckNetWorkSelf
    //如果更换按钮
    if (sender.tag != mInt_userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:mInt_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        mInt_userSelectedChannelID = sender.tag;
    }
    [InternetAppRootScrollView shareInstance].mInt = (int)sender.tag - 100;
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.mImgV_slide setFrame:CGRectMake(sender.frame.origin.x, 38, [dm getInstance].width/self.mArr_name.count, 2)];
        } completion:^(BOOL finished) {
            if (finished) {
                //设置页出现
                //做bug服务器显示当前的哪个界面
                if(sender.tag == 100)
                {
                    NSString *nowViewStr = @"themeView";
                    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
                    
                    
                }
                if(sender.tag == 101)
                {
                    NSString *nowViewStr = @"classView";
                    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
                    

                }
                if(sender.tag == 102)
                {
                    NSString *nowViewStr = @"WorkView_new2";
                    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
                    
                }

            [[InternetAppRootScrollView shareInstance] setContentOffset:CGPointMake(BUTTONID*[dm getInstance].width, 0) animated:NO];
                //赋值滑动列表选择ID
                mInt_scrollViewSelectedChannelID = sender.tag;
                [self sendRequest];
            }
        }];
    }
    //重复点击选中按钮
    else {
        
    }
}
//
- (void)adjustScrollViewContentX:(UIButton *)sender{
    //按按钮可以调整位置
}
//当滑动scrollview停止后调用
- (void)setButtonUnSelect{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:mInt_scrollViewSelectedChannelID];
    lastButton.selected = NO;
}
//当滑动scrollview停止后调用
- (void)setButtonSelect{
    
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:mInt_scrollViewSelectedChannelID];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mImgV_slide setFrame:CGRectMake(button.frame.origin.x, 38, [dm getInstance].width/self.mArr_name.count, 2)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                button.selected = YES;
                mInt_userSelectedChannelID = button.tag;
                [self sendRequest];
            }
        }
    }];
}
//当第一次到达页面时，发送请求
-(void)sendRequest{
//    [self.timer invalidate];
//
//    self.timer = nil;

    if (SHOWRONGYUN == 1) {
        if (mInt_userSelectedChannelID == 100) {
 
            if (mInt_show == 0) {
                //获取所有单位
                [[ShareHttp getInstance] shareHttpGetUnitSectionMessagesWith:@"1" AcdID:[dm getInstance].jiaoBaoHao];
//                [[InternetAppRootScrollView shareInstance].exchangeView ProgressViewLoad];
                mInt_show = 1;
            }
        }
        else if (mInt_userSelectedChannelID == 101) {//事务
            
            if (mInt_work_sendToMe == 0&&mInt_work_mysend == 0) {
//                [[InternetAppRootScrollView shareInstance].workView.mArr_list removeAllObjects];
            }
            if (mInt_work_mysend == 0) {
                //获取我发送的消息列表
                [[LoginSendHttp getInstance] login_GetMySendMsgList:@"1" Page:@"1" SendName:@"" sDate:@"" eDate:@""];
//                [[InternetAppRootScrollView shareInstance].workView ProgressViewLoad];
                mInt_work_mysend = 1;
            }
            if (mInt_work_sendToMe == 0) {
                //取发给我消息的用户列表，new
                [[LoginSendHttp getInstance] login_SendToMeUserList:@"20" Page:@"1" SendName:@"" sDate:@"" eDate:@"" readFlag:@"" lastId:@""];
//                [[InternetAppRootScrollView shareInstance].workView ProgressViewLoad];
                mInt_work_sendToMe = 1;
            }
        }else if (mInt_userSelectedChannelID == 102) {//分享
//            if (mInt_share == 0) {
//                //获取同事、关注人、好友的分享文章
//                [[ShowHttp getInstance] showHttpGetMyShareingArth:[dm getInstance].jiaoBaoHao page:@"1" viewFlag:@"shareNew"];
//                [[InternetAppRootScrollView shareInstance].shareView ProgressViewLoad];
//                mInt_share = 1;
//            }
        }else if (mInt_userSelectedChannelID == 103){
            [[InternetAppRootScrollView shareInstance].classView tableViewDownReloadData];
            //展示
//            if (mInt_show == 0) {
//                //获取所有单位
//                [[ShareHttp getInstance] shareHttpGetUnitSectionMessagesWith:@"1" AcdID:[dm getInstance].jiaoBaoHao];
//                [[InternetAppRootScrollView shareInstance].showView ProgressViewLoad];
//            }
//            if (mInt_show2 == 0) {
//                //获取我的关注的单位
//                [[ShowHttp getInstance] showHttpGetMyAttUnit:[dm getInstance].jiaoBaoHao];
//                [[InternetAppRootScrollView shareInstance].showView ProgressViewLoad];
//            }
        }else if (mInt_userSelectedChannelID == 104){//主题
            if (mInt_theme == 0) {
                //取我关注的和我所参与的主题
                [[ThemeHttp getInstance] themeHttpEnjoyInterestList:[dm getInstance].jiaoBaoHao];
                [[InternetAppRootScrollView shareInstance].themeView ProgressViewLoad];
                mInt_theme = 1;
            }
        }
    }else{
        if (mInt_userSelectedChannelID == 100) {//求知
            if (mInt_theme == 0)
            {
                self.timer3 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateRequestSymbol3:) userInfo:nil repeats:NO];
                mInt_theme = 1;
                [[InternetAppRootScrollView shareInstance].themeView ProgressViewLoad];

            }


            
        }else if (mInt_userSelectedChannelID == 101) {//学校圈
            if (mInt_show == 0) {
                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateRequestSymbol2:) userInfo:nil repeats:NO];
                mInt_show = 1;
                [[InternetAppRootScrollView shareInstance].classView tableViewDownReloadData];
            }
            
        }else if (mInt_userSelectedChannelID == 102){//事务
            if(self.mInt_unReadMsg == 0)
            {
                self.timer0 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateRequestSymbol0:) userInfo:nil repeats:NO];
                [[LoginSendHttp getInstance] wait_unReadMsgWithTag:0 page:@"1"];
                self.mInt_unReadMsg = 1;
            }
            if (mInt_work_sendToMe == 0&&mInt_work_mysend == 0) {
                //                [[InternetAppRootScrollView shareInstance].workView.mArr_list removeAllObjects];
            }
            if (mInt_work_mysend == 0) {
                mInt_work_mysend = 1;
            }
            if (mInt_work_sendToMe == 0) {
                mInt_work_sendToMe = 1;
            }
//            if(mInt_theme == 0){
//                self.timer3 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateRequestSymbol3:) userInfo:nil repeats:NO];
//                mInt_theme = 1;
//                //取我关注的和我所参与的主题
//                [[ThemeHttp getInstance] themeHttpEnjoyInterestList:[dm getInstance].jiaoBaoHao];
//                [[InternetAppRootScrollView shareInstance].themeView ProgressViewLoad];
//            }
        }else if (mInt_userSelectedChannelID == 103){//主题
            if (mInt_theme == 0) {
                self.timer3 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateRequestSymbol3:) userInfo:nil repeats:NO];
                mInt_theme = 1;
                //取我关注的和我所参与的主题
                [[ThemeHttp getInstance] themeHttpEnjoyInterestList:[dm getInstance].jiaoBaoHao];
                [[InternetAppRootScrollView shareInstance].themeView ProgressViewLoad];
            }
        }
    }
}

-(void)updateRequestSymbol0:(id)sender
{

    self.mInt_work_mysend = 0;
    self.mInt_work_sendToMe = 0;
    self.mInt_unReadMsg = 0;
    NSTimer *timer = (NSTimer*)sender;
    [timer invalidate];
}
-(void)updateRequestSymbol1:(id)sender
{
    mInt_share = 0;
    NSTimer *timer = (NSTimer*)sender;
    [timer invalidate];

}
-(void)updateRequestSymbol2:(id)sender
{
    
    self.mInt_show = 0;
    NSTimer *timer = (NSTimer*)sender;
    [timer invalidate];
}
-(void)updateRequestSymbol3:(id)sender
{
    

    self.mInt_theme = 0;
    NSTimer *timer = (NSTimer*)sender;
    [timer invalidate];

}

@end
