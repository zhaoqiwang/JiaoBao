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
#import "MBProgressHUD+AD.h"


@implementation HomeClassWorkView
@synthesize mViewTop,mScrollV_all;
-(void)refreshWorkView:(id)sender
{
    //[MBProgressHUD hideHUDForView:self];
    [self setFrame];
    //[self resetFrame];
}

-(void)dealloc1{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];
}

//发表消息成功
-(void)creatCommMsg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    NSString *message = [dic objectForKey:@"ResultDesc"];
    if ([code integerValue]==0) {
        [MBProgressHUD showSuccess:message toView:self];
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
    }else{
        [MBProgressHUD showError:@"发送失败" toView:self];
    }
}
-(void)progress:(id)sender
{
    //[MBProgressHUD hideHUDForView:self];
    NSString *str = [sender object];
    if(![str isEqualToString:@"正在加载"])
    {
        [MBProgressHUD showError:str toView:self];

    }
    else
    {
        [MBProgressHUD showMessage:str toView:self];
    }


    
}
-(void)progress2:(id)sender
{
        [MBProgressHUD hideHUDForView:self];

}

-(void)updateUI:(id)sender
{
    [MBProgressHUD hideHUDForView:self];
    [self setFrame];
}
- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateUI" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI:) name:@"updateUI" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"progress2" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(progress2:) name:@"progress2" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"progress" object:nil];

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

        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);

        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.frame;
        [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
        
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].classMessageView.mCollectionV_list.frame.size.height+150);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+[HomeClassTopScrollView shareInstance].frame.origin.y+48);
        [HomeClassRootScrollView shareInstance].classMessageView.frame  = CGRectMake(0, 0, [dm getInstance].width, [HomeClassTopScrollView shareInstance].frame.origin.y+[HomeClassTopScrollView shareInstance].frame.size.height+[HomeClassRootScrollView shareInstance].frame.size.height);
    }
    
    if([dm getInstance].notificationSymbol == 101)
    {

        
        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);

        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame;
        [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame.size.height+50);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+48+self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y);
        
        [HomeClassRootScrollView shareInstance].characterView.frame  = CGRectMake([dm getInstance].width, 0, 320, [HomeClassTopScrollView shareInstance].frame.origin.y+[HomeClassTopScrollView shareInstance].frame.size.height+[HomeClassRootScrollView shareInstance].frame.size.height);


        
    }
    
    if([dm getInstance].notificationSymbol == 102)
    {

        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, 100);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+48+self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y);
        [HomeClassRootScrollView shareInstance].schoolMessage.frame  = CGRectMake([dm getInstance].width*2, 0, 320, [HomeClassTopScrollView shareInstance].frame.origin.y+[HomeClassTopScrollView shareInstance].frame.size.height+[HomeClassRootScrollView shareInstance].frame.size.height);
        


        
    }
    
    if([dm getInstance].notificationSymbol == 103)
    {

        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
        CGRect tableViewFrame = [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame;
        [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame =CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].patriarchView.tableView.contentSize.height);
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame.size.height+50);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+48+self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y);
        
        [HomeClassRootScrollView shareInstance].patriarchView.frame  = CGRectMake([dm getInstance].width*3, 0, [dm getInstance].width, [HomeClassTopScrollView shareInstance].frame.origin.y+[HomeClassTopScrollView shareInstance].frame.size.height+[HomeClassRootScrollView shareInstance].frame.size.height);

    }

}
-(void)resetFrame
{
    if([dm getInstance].notificationSymbol == 101)
    {
        CGRect mCollectionV_listFrame = [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame;
        [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame = CGRectMake(mCollectionV_listFrame.origin.x, mCollectionV_listFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].characterView.mCollectionV_list.frame.size.height+150);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+48);
        
        [HomeClassRootScrollView shareInstance].characterView.frame  = CGRectMake([dm getInstance].width, 0, 320, [HomeClassTopScrollView shareInstance].frame.origin.y+[HomeClassTopScrollView shareInstance].frame.size.height+[HomeClassRootScrollView shareInstance].frame.size.height);
        
    }
    if([dm getInstance].notificationSymbol == 103)
    {
        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y, [dm getInstance].width, 48);
        CGRect tableViewFrame = [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame;
        [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame =CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, [dm getInstance].width, [HomeClassRootScrollView shareInstance].patriarchView.tableView.contentSize.height);
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48, [dm getInstance].width, [HomeClassRootScrollView shareInstance].patriarchView.tableView.frame.size.height+50);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, [HomeClassRootScrollView shareInstance].frame.size.height+48+self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y);
        
        [HomeClassRootScrollView shareInstance].patriarchView.frame  = CGRectMake([dm getInstance].width*3, 0, [dm getInstance].width, [HomeClassTopScrollView shareInstance].frame.origin.y+[HomeClassTopScrollView shareInstance].frame.size.height+[HomeClassRootScrollView shareInstance].frame.size.height);
    }



}


//点击发送按钮
-(void)mBtn_send:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    long long fileSizeSum = 0;
    for(int i=0;i<self.mViewTop.mArr_accessory.count;i++)
    {
        AccessoryModel *model = [self.mViewTop.mArr_accessory objectAtIndex:i];
        long long fileSize = 0;
        fileSize = [model.fileAttributeDic fileSize];
        fileSizeSum = fileSizeSum +fileSize;
        
    }
    D("fileSizeSum = %lld",fileSizeSum);
    
    if(fileSizeSum>10000000)
    {
        [MBProgressHUD showError:@"上传文件不能大于10M" toView:self];
        return;
        
    }
    if ([utils isBlankString:self.mViewTop.mTextV_input.text]) {
        [MBProgressHUD showError:@"请输入内容" toView:self];
        return;
    }
    NSMutableArray *genArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *array0 = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<self.mViewTop.mArr_accessory.count;i++)
    {
        AccessoryModel *model = [self.mViewTop.mArr_accessory objectAtIndex:i];
        [array0 addObject:model.mStr_name];
    }
    //[array0 addObjectsFromArray:self.mViewTop.mArr_accessory];
    if([dm getInstance].notificationSymbol == 1)
    {
        [dm getInstance].notificationSymbol = [HomeClassTopScrollView shareInstance].mInt_userSelectedChannelID;
    }

if([dm getInstance].notificationSymbol == 100)
{
    NSMutableArray * dataArr = [HomeClassRootScrollView shareInstance].classMessageView.datasource;
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
                if(unit.list.count>0)
                {
                    model = [unit.list objectAtIndex:0];

                }

                
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
    if(genArr.count ==0)
    {
        [MBProgressHUD showError:@"请选择人员" toView:self];
        return;
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
        if(genArr.count ==0)
        {
            [MBProgressHUD showError:@"请选择人员" toView:self];
            return;
        }
        
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
            if(genArr.count ==0)
            {
                [MBProgressHUD showError:@"请选择人员" toView:self];
                return;
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
        if(genArr.count ==0)
        {
            [MBProgressHUD showError:@"请选择人员" toView:self];
            return;
        }
                    [[LoginSendHttp getInstance]creatCommMsgWith:self.mViewTop.mTextV_input.text SMSFlag:self.mViewTop.mInt_sendMsg unitid:[dm getInstance].mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 arrMem:nil arrGen:genArr arrStu:nil access:array0];
        
    }
   





    [MBProgressHUD showMessage:@"正在发送..." toView:self];
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
