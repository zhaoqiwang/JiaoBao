//
//  HomeClassWorkView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "HomeClassWorkView.h"
#import "Reachability.h"
#import "SVProgressHUD.h"


@implementation HomeClassWorkView
@synthesize mViewTop,mScrollV_all;
-(void)refreshWorkView:(id)sender
{
    [self setFrame];
}

-(void)dealloc1{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];
}

//发表消息成功
-(void)creatCommMsg:(NSNotification *)noti{
    NSString *str = noti.object;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    if(str.length == 0)
    {
        str = @"成功";
    }
    //NSLog(@"str = %@",str);
    self.mProgressV.labelText = str;
    //    self.mProgressV.userInteractionEnabled = NO;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    self.mViewTop.mTextV_input.text = @"";
    [self.mViewTop.mArr_accessory removeAllObjects];
    [self.mViewTop addAccessoryPhoto]; 
    if([dm getInstance].notificationSymbol == 100)
    {
        NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].classMessageView.dataArr;
        for(int i=0;i<dataArr.count;i++)
        {
            myUnit *unit = [dataArr objectAtIndex:i];
            unit.isSelected = NO;
  
            
            
        }
        [[HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list reloadData];
        
        
    }
    if([dm getInstance].notificationSymbol == 101)
    {
        NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].characterView.datasource;
        for(int i=0;i<dataArr.count;i++)
        {
            myUnit *unit = [dataArr objectAtIndex:i];
            UserListModel *model;
            if(unit.list.count>1)
            {
                model = [unit.list objectAtIndex:1];
                
                
            }
            else
            {
                model = [unit.list objectAtIndex:0];
                
                
            }
            groupselit_selitModel *groupModel ;
            for(int i=0;i<model.groupselit_selit.count;i++)
            {
                groupModel = [model.groupselit_selit objectAtIndex:i];
                if(groupModel.mInt_select == 1)
                {
                    groupModel.mInt_select =0;

                }
                
                
            }
            
        }
        [[HomeClassRootScrollView shareInstance].characterView.mCollectionV_list reloadData];
        
    }
    if([dm getInstance].notificationSymbol == 102)
    {
        
        [[HomeClassRootScrollView shareInstance].schoolMessage.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
        
        
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
                        tempModel.mInt_select =0;
                    }
                    
                }
                
            }
            [[HomeClassRootScrollView shareInstance].patriarchView.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
            [[HomeClassRootScrollView shareInstance].patriarchView.tableView reloadData];
            
        
    }
    }
    [self setFrame];


    
    
}
-(void)progress:(id)sender
{
    NSString *str = [sender object];
    if(![str isEqualToString:@"正在加载"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mProgressV.mode = MBProgressHUDModeCustomView;

            self.mProgressV.labelText = str;
            self.mProgressV.userInteractionEnabled = NO;

            //[self.mProgressV show:YES];
            //[self.mProgressV hide:YES afterDelay:2];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            
            
        });
        
    }
    else
    {
            //[SVProgressHUD show];
            self.mProgressV.labelText = str;
            self.mProgressV.mode = MBProgressHUDModeIndeterminate;
            self.mProgressV.userInteractionEnabled = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        
    }


    
}
-(void)progress2:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mProgressV hide:YES];


                               });
        

}

-(void)updateUI:(id)sender
{
    [self setFrame];
}
- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI:) name:@"updateUI" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(progress2:) name:@"progress2" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(progress:) name:@"progress" object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"creatCommMsg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatCommMsg:) name:@"creatCommMsg" object:nil];

        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshWorkView" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];
        //总框
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.frame.size.height);
        [self addSubview:self.mScrollV_all];
        //self.mScrollV_all.backgroundColor = [UIColor redColor];
        //上半部分
        self.mViewTop = [[NewWorkTopView alloc] init];
        self.mViewTop.delegate = self;
        [self.mScrollV_all addSubview:self.mViewTop];
        [self.mScrollV_all addSubview:[HomeClassRootScrollView shareInstance]];

//        //root
        [self.mScrollV_all addSubview:[HomeClassTopScrollView shareInstance]];
        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
//        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48+10, [dm getInstance].width, 300)];
//        [self addSubview:self.bottomView];
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, 1000);
        //[HomeClassRootScrollView shareInstance].backgroundColor = [UIColor blueColor];
        
        [HomeClassRootScrollView shareInstance].scrollEnabled = NO;
        //[HomeClassRootScrollView shareInstance].backgroundColor = [UIColor redColor];
        self.mProgressV = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:self.mProgressV];
        self.mProgressV.delegate = self;


        
    }
    return self;
}
-(void)setFrame
{
    if([dm getInstance].notificationSymbol == 100)
    {
//        [HomeClassRootScrollView shareInstance].contentSize = CGSizeMake([dm getInstance].width, [dm getInstance].height - self.mViewTop.frame.size.height-self.mViewTop.frame.origin.y-[HomeClassTopScrollView shareInstance].frame.size.height);
//        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.frame.size.height);
//        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
//        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, 1000);
        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.frame;
        [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
        
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.frame.size.height+150);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+[HomeClassTopScrollView shareInstance].frame.origin.y+48);


        
    }
    
    if([dm getInstance].notificationSymbol == 101)
    {

        
        //[HomeClassRootScrollView shareInstance].contentSize = CGSizeMake([dm getInstance].width, 5);
//        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
//        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame;
//        [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.contentSize.height);
//        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame.size.height+150);
//        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+[HomeClassTopScrollView shareInstance].frame.origin.y+48);
        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame;
        [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
        
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame.size.height+150);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+[HomeClassTopScrollView shareInstance].frame.origin.y+48);


        
    }
    
    if([dm getInstance].notificationSymbol == 102)
    {

        
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mScrollV_all.frame.size.height);
        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
        
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [dm getInstance].height);

        
    }
    
    if([dm getInstance].notificationSymbol == 103)
    {

        
//        [HomeClassRootScrollView shareInstance].contentSize = CGSizeMake([dm getInstance].width, 1000);
//        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, 1000);
//        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
//        
//        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, 1000);
        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame;
        [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].patriarchView.tableView.contentSize.height);
        
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame.size.height+150);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+[HomeClassTopScrollView shareInstance].frame.origin.y+48);

        
    }

}
-(void)resetFrame
{
    CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame;
    [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
    [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame.size.height+150);
    self.mScrollV_all.contentSize = CGSizeMake(320, [HomeClassRootScrollView shareInstance].frame.size.height+48);
}


//点击发送按钮
-(void)mBtn_send:(UIButton *)btn{
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
    NSMutableArray *array0 = [NSMutableArray array];
    [array0 addObjectsFromArray:self.mViewTop.mArr_accessory];
    if([dm getInstance].notificationSymbol == 1)
    {
        [dm getInstance].notificationSymbol = [HomeClassTopScrollView shareInstance].mInt_userSelectedChannelID;
    }

if([dm getInstance].notificationSymbol == 100)
{
    NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].classMessageView.dataArr;
    for(int i=0;i<dataArr.count;i++)
    {
        myUnit *unit = [dataArr objectAtIndex:i];
        if(unit.isSelected == YES)
        {
            UserListModel *model;
            if(unit.list.count>1)
            {
                model = [unit.list objectAtIndex:1];

                
            }
            else
            {
                model = [unit.list objectAtIndex:0];

                
            }
            groupselit_selitModel *groupModel ;
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
        [[LoginSendHttp getInstance] creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:self.mViewTop.mInt_sendMsg unitid:[dm getInstance].mModel_unitList.myUnit.TabIDStr classCount:(int)genArr.count grsms:1 array:genArr forwardMsgID:nil access:array0];


    
}
    if([dm getInstance].notificationSymbol == 101)
    {
        NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].characterView.datasource;
        for(int i=0;i<dataArr.count;i++)
        {
            myUnit *unit = [dataArr objectAtIndex:i];
            UserListModel *model;
            if(unit.list.count>1)
            {
                model = [unit.list objectAtIndex:1];
                
                
            }
            else
            {
                model = [unit.list objectAtIndex:0];
                
                
            }            groupselit_selitModel *groupModel;
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
        //int num = (int)genArr.count;
        
            [[LoginSendHttp getInstance] creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:self.mViewTop.mInt_sendMsg unitid:[dm getInstance].mModel_unitList.myUnit.TabIDStr classCount:(int)genArr.count grsms:1 array:genArr forwardMsgID:nil access:array0];
        
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
            
            [[LoginSendHttp getInstance]creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:self.mViewTop.mInt_sendMsg unitid:[dm getInstance].mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 arrMem:nil arrGen:genArr arrStu:nil access:array0];
            
            
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

        }
                    [[LoginSendHttp getInstance]creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:self.mViewTop.mInt_sendMsg unitid:[dm getInstance].mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 arrMem:nil arrGen:genArr arrStu:nil access:array0];
        
    }
   





    
    self.mProgressV.labelText = @"正在发送...";
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
