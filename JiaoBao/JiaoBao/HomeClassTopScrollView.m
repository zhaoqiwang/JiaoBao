//
//  HomeClassTopScrollView.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "HomeClassTopScrollView.h"

@implementation HomeClassTopScrollView
@synthesize mArr_name,mImgV_slide,mInt_scrollViewSelectedChannelID,mInt_userSelectedChannelID;

//按钮空隙
#define BUTTONGAP 40
//按钮长度
#define BUTTONWIDTH 100
//按钮高度
#define BUTTONHEIGHT 28
//滑条CONTENTSIZEX
#define CONTENTSIZEX [dm getInstance].width

#define BUTTONID (sender.tag-100)



+ (HomeClassTopScrollView *)shareInstance {
    static HomeClassTopScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44+[dm getInstance].statusBar, [dm getInstance].width, 48)];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CMRevicer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CMRevicer:) name:@"CMRevicer" object:nil];
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = YES;
        self.contentSize = CGSizeMake([dm getInstance].width, 48);
        self.mArr_name = [[NSMutableArray alloc] initWithObjects:@"",@"", @"",@"", nil];
        
        mInt_userSelectedChannelID = 100;
        mInt_scrollViewSelectedChannelID = 100;
        self.requestSymbol0 = YES;
        self.requestSymbol1 = YES;
        self.requestSymbol2 = YES;
        self.requestSymbol3 = YES;

        
        [self initWithNameButtons];
    }
    return self;
}

- (void)initWithNameButtons
{
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
        [dm getInstance].notificationSymbol = button.tag;

        if (i+100 == mInt_scrollViewSelectedChannelID) {
            button.selected = YES;
        }
        //        CGSize tempSize = [[self.mArr_name objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:11]];
        [button setTitle:[NSString stringWithFormat:@"%@",[self.mArr_name objectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [button setTitleColor:[UIColor colorWithRed:130/255.0 green:129/255.0 blue:130/255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:91/255.0 green:178/255.0 blue:57/255.0 alpha:1] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        //设置标题位置
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"HomeClass_%d",i+1]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"HomeClass_Click_%d",i+1]] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        //        button.imageEdgeInsets = UIEdgeInsetsMake(4,(tempWidth-25)/2,21,(tempWidth-25)/2);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        //        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        //        //        button.titleEdgeInsets = UIEdgeInsetsMake(32, -(tempWidth-tempSize.width)/2-2, 4, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        //        button.titleEdgeInsets = UIEdgeInsetsMake(32, -(tempWidth-tempSize.width)/2+10, 4, 0);
        //        //        button.imageEdgeInsets = UIEdgeInsetsMake(4,0,21,(tempWidth-25)/2);
        //        //        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        //        //        button.titleEdgeInsets = UIEdgeInsetsMake(32, (tempWidth-tempSize.width)/2-2, 4, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        [self addSubview:button];
    }
}

- (void)selectNameButton:(UIButton *)sender{
    [dm getInstance].notificationSymbol = sender.tag;
    //如果更换按钮
    if (sender.tag != mInt_userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:mInt_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        mInt_userSelectedChannelID = sender.tag;
    }
    [HomeClassRootScrollView shareInstance].mInt = (int)sender.tag - 100;
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.mImgV_slide setFrame:CGRectMake(sender.frame.origin.x, 38, [dm getInstance].width/self.mArr_name.count, 2)];
            
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置页出现
                [[HomeClassRootScrollView shareInstance] setContentOffset:CGPointMake(BUTTONID*[dm getInstance].width, 0) animated:NO];
                //赋值滑动列表选择ID
                mInt_scrollViewSelectedChannelID = sender.tag;
                [self sendRequest];
                
            }
        }];
//        NSNumber *num = [NSNumber numberWithInteger:sender.tag];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHomeClass" object:num];
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
//通知界面更新，获取事务信息接收单位列表
-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
    self.mModel_unitList = noti.object;

    if([dm getInstance].notificationSymbol == 100)
    {

        
    }
    

    if([dm getInstance].notificationSymbol == 101)
    {
        self.curunitid = self.mModel_unitList.myUnit.TabIDStr;
        if(self.mModel_unitList.UnitClass.count>0)
        {
            for(int i=0;i<self.mModel_unitList.UnitClass.count;i++)
            {
                myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
                
                [[LoginSendHttp getInstance] login_GetUnitClassRevicer:unit.TabID Flag:unit.flag];
                
            }

            
        }
        else
        {
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"selSecBtn" object:nil];

        }
        
    }
    
    
    

    
}

-(void)GetUnitRevicer:(NSNotification *)noti
{
    if([dm getInstance].notificationSymbol == 101)
    {
        NSDictionary *dic = noti.object;
        NSString *unitID = [dic objectForKey:@"unitID"];
        NSArray *array = [dic objectForKey:@"array"];
        self.genseliArr = [NSMutableArray array];
        //找到当前这个单位，塞入数组

        //班级
        for (int i=0; i<self.mModel_unitList.UnitClass.count; i++)
        {
            myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
            if ([unit.TabID intValue] == [unitID intValue]) {
                unit.list = [NSMutableArray arrayWithArray:array];
                [self.dataArr addObject:unit];
            }
        }
//        for(int i=0;i<self.dataArr.count;i++)
//        {
//            myUnit *unit = [self.dataArr objectAtIndex:i];
//            for(int j=0;j<unit.list.count;j++)
//            {
//                UserListModel *model = [unit.list objectAtIndex:j];
//                for(int z=0;z<model.groupselit_selit.count;z++)
//                {
//                    
//                    groupselit_selitModel *model2 = [model.groupselit_selit objectAtIndex:z];
//                    NSLog(@"555555[%d][%d][%d] = %@",i,j,z,model2.Name);
//                }
//
//                
//            }
//
//
//
//            
//        }



        [[NSNotificationCenter defaultCenter ]postNotificationName:@"selSecBtn" object:self.dataArr];
        

        
    }



    
    
}

//当第一次到达页面时，发送请求
-(void)sendRequest{
    if([dm getInstance].notificationSymbol == 101)
    {
        if(self.requestSymbol0 == YES)
        {
            self.requestSymbol0 =NO;
        }
        
    }


    if([dm getInstance].notificationSymbol == 101)
    {
        if(self.requestSymbol1 ==YES)
        {
        [[LoginSendHttp getInstance] login_CommMsgRevicerUnitList];

        
         }
        self.requestSymbol1 = NO;
    }
    if([dm getInstance].notificationSymbol == 102)
    {
        if(self.requestSymbol2 == YES)
        {
            
            [[LoginSendHttp getInstance]ReceiveListWithFlag:0 all:1];
        }
        self.requestSymbol2 = NO;
        
    }

    if([dm getInstance].notificationSymbol == 103)
    {
        if(self.requestSymbol3 == YES)
        {
            [[LoginSendHttp getInstance]ReceiveListWithFlag:0 all:1];
        }
        self.requestSymbol3 = NO;
    }
    


    
}
-(void)CMRevicer:(NSNotification *)noti{

       NSArray *arr = [noti object];
       self.thirdArr = arr;
    if([dm getInstance].notificationSymbol == 103)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"seleForuth" object:arr];

        
    }


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
