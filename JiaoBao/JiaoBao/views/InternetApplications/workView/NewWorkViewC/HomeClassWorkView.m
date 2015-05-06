//
//  HomeClassWorkView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "HomeClassWorkView.h"
#import "Reachability.h"


@implementation HomeClassWorkView
@synthesize mViewTop,mScrollV_all;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //总框
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, [dm getInstance].width, self.frame.size.height)];
        self.mScrollV_all.contentSize = CGSizeMake(320, 800);
        [self addSubview:self.mScrollV_all];
        //上半部分
        self.mViewTop = [[NewWorkTopView alloc] init];
        self.mViewTop.delegate = self;
        [self.mScrollV_all addSubview:self.mViewTop];
        [self.mScrollV_all addSubview:[HomeClassRootScrollView shareInstance]];

//        //root
        [self.mScrollV_all addSubview:[HomeClassTopScrollView shareInstance]];
        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+10, [dm getInstance].width, 48);
//        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48+10, [dm getInstance].width, 300)];
//        [self addSubview:self.bottomView];
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48+10, [dm getInstance].width, 800);
        [HomeClassRootScrollView shareInstance].scrollEnabled = NO;
        //[HomeClassRootScrollView shareInstance].backgroundColor = [UIColor redColor];


        
    }
    return self;
}

//点击发送按钮
-(void)mBtn_send:(UIButton *)btn{
    NSLog(@"notificationSymbol = %lu",(unsigned long)[dm getInstance].notificationSymbol);
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mViewTop.mTextV_input.text.length == 0) {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"请输入内容";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }
    NSMutableArray *genArr = [[NSMutableArray alloc]initWithCapacity:0];

if([dm getInstance].notificationSymbol == 100)
{
    NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].classMessageView.dataArr;
    for(int i=0;i<dataArr.count;i++)
    {
        myUnit *unit = [dataArr objectAtIndex:i];
        if(unit.isSelected == YES)
        {
            UserListModel *model = [unit.list objectAtIndex:0];
            groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
            for(int i=0;i<model.groupselit_selit.count;i++)
            {
                groupModel = [model.groupselit_selit objectAtIndex:i];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:groupModel.flag forKey:@"flag"];
                [dic setValue:groupModel.selit forKey:@"selit"];
                [genArr addObject:dic];

                
                
                
            }
            
        }

        
    }
        int num = (int)genArr.count;
        NSLog(@"num = %d",num);
        [[LoginSendHttp getInstance] creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:1 unitid:[HomeClassRootScrollView shareInstance].classMessageView.unitStr classCount:(int)genArr.count grsms:1 array:genArr forwardMsgID:nil access:nil];


    
}
    if([dm getInstance].notificationSymbol == 101)
    {
        NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].characterView.datasource;
        for(int i=0;i<dataArr.count;i++)
        {
            myUnit *unit = [dataArr objectAtIndex:i];
            UserListModel *model = [unit.list objectAtIndex:0];
            groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
            for(int i=0;i<model.groupselit_selit.count;i++)
            {
                groupModel = [model.groupselit_selit objectAtIndex:i];
                if(groupModel.mInt_select == 1)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:groupModel.flag forKey:@"flag"];
                    [dic setValue:groupModel.selit forKey:@"selit"];
                    [genArr addObject:dic];
                    //[genArr addObject:groupModel];
                }
                
                
            }
            
        }
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:1 unitid:[HomeClassTopScrollView shareInstance].curunitid classCount:(int)genArr.count grsms:1 array:genArr forwardMsgID:nil access:nil];
        
    }
    if([dm getInstance].notificationSymbol == 102)
    {
        if([HomeClassRootScrollView shareInstance].schoolMessage.allSelected == YES)
        {
            NSArray *arr = [HomeClassTopScrollView shareInstance].thirdArr;

            for (int i=0; i<arr.count; i++) {
                SMSTreeArrayModel *model = [arr objectAtIndex:i];
                for (int m=0; m<model.smsTree.count; m++) {
                    SMSTreeUnitModel *tempModel = [model.smsTree objectAtIndex:m];
                    if (i == 1)
                    {
                        [genArr addObject:tempModel.id0];
                        
                    }

            }
            }
            
            [[LoginSendHttp getInstance]creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:1 unitid:[HomeClassTopScrollView shareInstance].curunitid classCount:0 grsms:1 arrMem:nil arrGen:genArr arrStu:nil access:nil];
            
            
        }
        else
        {
            
        }
        
    }
    
    if([dm getInstance].notificationSymbol == 103)
    {
        
            NSArray *arr = [HomeClassRootScrollView shareInstance].patriarchView.datasource;
            
            for (int i=0; i<arr.count; i++) {
                SMSTreeArrayModel *model = [arr objectAtIndex:i];
                for (int m=0; m<model.smsTree.count; m++) {
                    SMSTreeUnitModel *tempModel = [model.smsTree objectAtIndex:m];
                    if (i == 1)
                    {
                        if(tempModel.mInt_select == 1)
                        {
                        [genArr addObject:tempModel.id0];
                        }
                        
                    }
                    
                }
            
            
            [[LoginSendHttp getInstance]creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:1 unitid:[HomeClassTopScrollView shareInstance].curunitid classCount:0 grsms:1 arrMem:nil arrGen:genArr arrStu:nil access:nil];
            
            
        }
        
    }
   





    
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    //        self.mProgressV.userInteractionEnabled = NO;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
    
    
    
}
//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = NETWORKENABLE;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return YES;
    }else{
        return NO;
    }
}
-(void)noMore{
    sleep(1);
}
- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    //    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}


@end
