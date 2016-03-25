//
//  ForwardViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ForwardViewController.h"
#import "Reachability.h"
#import "MobClick.h"
#import "MBProgressHUD+AD.h"
#define Margin 0//边距
#define BtnColor [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1]//按钮背景色

@interface ForwardViewController ()
@property(nonatomic,strong)NSTimer *timer;

@end

NSString *kDetailedViewControllerID = @"Forward_section";    // view controller storyboard id
NSString *kCellID = @"Forward_cell";                          // UICollectionViewCell storyboard id

@implementation ForwardViewController

-(void)dealloc
{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

    //界面消失时，移除通知
    
    [MBProgressHUD hideHUDForView:self.view];

    [self removeFromParentViewController];
}

-(void)removeNotification
{
    [self.timer invalidate];
    self.timer = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

-(void)refreshWorkView:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    if([dm getInstance].notificationSymbol ==1)
    {
        [self setFrame];
        [self CollectionReloadData];
        
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    [self setFrame];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
  }

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshWorkView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWorkView:) name:@"refreshWorkView" object:nil];
    
    //发表消息成功推送
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"creatCommMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatCommMsg:) name:@"creatCommMsg" object:nil];
    //获取到每个单位中的人员
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
    //获取到下发通知的权限
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMsgAllReviceUnitList" object:nil];
    
    [dm getInstance].notificationSymbol = 1;
    
    self.mModel_myUnit = [[myUnit alloc] init];

    //大scrollview的坐标
    self.mScrollV_all.frame = CGRectMake(0, 0, [dm getInstance].width, [dm getInstance].height-44-10);

    //接收人，全选，反选，发表

    self.topView = [[NewWorkTopView alloc]init];
    self.topView.delegate = self;
    
    [self.mScrollV_all addSubview:self.topView];
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height+self.topView.frame.origin.y, [dm getInstance].width, 28)];
    self.headView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.mScrollV_all insertSubview:self.headView belowSubview:self.mLab_4];
    self.mLab_4.frame =CGRectMake(10, self.topView.frame.size.height+self.topView.frame.origin.y, self.mLab_4.frame.size.width, 29);
    NSString *groupName = [dm getInstance].mStr_unit;
    self.mLab_4.text = [NSString stringWithFormat:@"%@人员分组",groupName];
    self.mBtn_all.frame = CGRectMake([dm getInstance].width-100+15, self.mLab_4.frame.origin.y, 40, 29);
    self.mBtn_all.tag = 1;
    [self.mBtn_all addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.mBtn_invertSelect.frame = CGRectMake([dm getInstance].width-60+15, self.mLab_4.frame.origin.y, 45, 29);
    self.mBtn_invertSelect.tag = 2;
    [self.mBtn_invertSelect addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

  
    
    //人员列表
    self.mCollectionV_list.frame = CGRectMake(Margin,self.mLab_4.frame.size.height+self.mLab_4.frame.origin.y, [dm getInstance].width, 0);
    self.mCollectionV_list.backgroundColor = [UIColor whiteColor];
    self.mCollectionV_list.layer.borderWidth = 1;
    self.mCollectionV_list.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCellID];
    [self.mCollectionV_list registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailedViewControllerID];
//    [self.mCollectionV_list registerClass:[CollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FootView"];
    
     [self.mCollectionV_list registerNib:[UINib nibWithNibName:@"CollectionFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView"];
    

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap2.delegate = self;
    [self.topView addGestureRecognizer:tap2];
    
   // [self sendRequest];
}
-(void)clickBtn:(id)sender
{
    UIButton *btn = sender;
    if(btn.tag ==1)
       {
           self.allSelected =1;
           for(int i=0;i<self.mModel_myUnit.list.count;i++)
           {
                UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
               model.sectionSelSymbol = 1;
               for(int i=0;i<model.groupselit_selit.count;i++)
               {
                   groupselit_selitModel *subModel = [model.groupselit_selit objectAtIndex:i];
                   subModel.mInt_select = 1;
               }
               
           }

           
       }
    else
    {
        if(self.allSelected ==0)
        {
            self.allSelected = 1;
            for(int i=0;i<self.mModel_myUnit.list.count;i++)
            {
                UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
                model.sectionSelSymbol = 1;
                for(int i=0;i<model.groupselit_selit.count;i++)
                {
                    groupselit_selitModel *subModel = [model.groupselit_selit objectAtIndex:i];
                    subModel.mInt_select = 1;
                }
                
            }
        }
        else if(self.allSelected ==1)
        {
            self.allSelected = 0;
            for(int i=0;i<self.mModel_myUnit.list.count;i++)
            {
                UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
                model.sectionSelSymbol = 0;
                for(int i=0;i<model.groupselit_selit.count;i++)
                {
                    groupselit_selitModel *subModel = [model.groupselit_selit objectAtIndex:i];
                    subModel.mInt_select = 0;
                }
                
            }
            
        }
        else
        {
            for(int i=0;i<self.mModel_myUnit.list.count;i++)
            {
                UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
                if(model.sectionSelSymbol == 0)
                {
                    model.sectionSelSymbol = 1;
                }
                else if(model.sectionSelSymbol == 1)
                {
                    model.sectionSelSymbol = 0;

                    
                }
                else{
                    
                }
                
                for(int i=0;i<model.groupselit_selit.count;i++)
                {
                    groupselit_selitModel *subModel = [model.groupselit_selit objectAtIndex:i];
                    if(subModel.mInt_select == 0)
                    {
                        subModel.mInt_select = 1;

                        
                    }
                    else
                    {
                        subModel.mInt_select = 0;
                    }
                }
                
            }
            
        }
    }
    if(self.allSelected ==1)
    {
        self.imgV.image = [UIImage imageNamed:@"selected.png"];

    }
    else
    {
        self.imgV.image = [UIImage imageNamed:@"blank.png"];

    }
    [self.mCollectionV_list reloadData];
}

-(void)setFrame
{
    //放单位信息的
    
    //接收人，全选，反选，发表
    self.headView.frame = CGRectMake(0, self.topView.frame.size.height+self.topView.frame.origin.y, [dm getInstance].width, 28);
    self.mLab_4.frame =CGRectMake(10, self.topView.frame.origin.y+self.topView.frame.size.height, self.mLab_4.frame.size.width, 29);
    self.imgV.frame = CGRectMake([dm getInstance].width-15-100+15, self.mLab_4.frame.origin.y+7, 14, 14);
    self.imgV.image = [UIImage imageNamed:@"blank.png"];
    self.mBtn_all.frame = CGRectMake([dm getInstance].width-100+15, self.mLab_4.frame.origin.y, 40, 29);
    self.mBtn_invertSelect.frame = CGRectMake([dm getInstance].width-60+15, self.mLab_4.frame.origin.y, 45, 29);
    self.mCollectionV_list.frame = CGRectMake(Margin, self.headView.frame.origin.y+self.headView.frame.size.height, self.mCollectionV_list.frame.size.width, self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
}






//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

-(void)pressTap:(UITapGestureRecognizer *)tap{
    [self.topView.mTextV_input resignFirstResponder];
    
}





//获取到每个单位中的人员
-(void)GetUnitRevicer:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        if([dm getInstance].notificationSymbol == 1)
        {
            [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];

            NSString *unitID = [dic objectForKey:@"unitID"];
            NSArray *array = [dic objectForKey:@"array"];
            
            //当前单位
            if ([[dm getInstance].mModel_unitList.myUnit.TabID intValue] == [unitID intValue]&&[unitID intValue] == [dm getInstance].UID) {
                [dm getInstance].mModel_unitList.myUnit.list = [NSMutableArray arrayWithArray:array];
                self.mModel_myUnit = [dm getInstance].mModel_unitList.myUnit;
            }
            //刷新
            [self CollectionReloadData];
        }
    }else{
        [MBProgressHUD showError:@"" toView:self.view];
    }
    
}

//发表消息成功
-(void)creatCommMsg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    NSString *message = [dic objectForKey:@"ResultDesc"];
    if ([code integerValue]!=0) {
        [MBProgressHUD showError:@"发送失败" toView:self.view];
    }else{
        if([dm getInstance].notificationSymbol ==1 )
        {
            [MBProgressHUD showSuccess:message ];
            self.topView.mTextV_input.text = @"";
            [self.topView.mArr_accessory removeAllObjects];
            [self.topView addAccessoryPhoto];
            for (int i=0; i<self.mModel_myUnit.list.count; i++)
            {
                UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
                model.sectionSelSymbol = 0;
                for (int i=0; i<model.groupselit_selit.count; i++) {
                    groupselit_selitModel *subModel = [model.groupselit_selit objectAtIndex:i];
                    subModel.mInt_select = 0;
                }
            }
            self.imgV.image = [UIImage imageNamed:@"blank.png"];
            [self.mCollectionV_list reloadData];
        }
    }
}
-(void)noMore{
    sleep(1);
}


//刷新
-(void)CollectionReloadData{
    [self.mCollectionV_list reloadData];
    self.mCollectionV_list.frame = CGRectMake(self.mCollectionV_list.frame.origin.x, self.mCollectionV_list.frame.origin.y, self.mCollectionV_list.frame.size.width, self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height);
    //float height = self.mCollectionV_list.collectionViewLayout.collectionViewContentSize.height;
    //NSLog(@"height = %f",height);
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mCollectionV_list.frame.origin.y+self.mCollectionV_list.frame.size.height+150);
}

#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
        return self.mModel_myUnit.list.count;
   
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    NSNumber *num = [NSNumber numberWithInteger:section];
    if([[dm getInstance].sectionSet containsObject:num])
    {
        
    }
    else
    {
        return 0;
    }

            for (int i=0; i<self.mModel_myUnit.list.count; i++)
            {
                if (section == i)
                {
                    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
                    return model.groupselit_selit.count;
                }
            }
    
    return 0;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (!cell) {
        
    }
    

        UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
        groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
    
            cell.mLab_name.textColor = [UIColor blackColor];

            if (groupModel.mInt_select == 0) {
                cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
            } else {
                cell.mImgV_select.image = [UIImage imageNamed:@"selected"];
            }
    
        CGSize size = [groupModel.Name sizeWithFont:[UIFont systemFontOfSize:12]];
        if (size.width>cell.mLab_name.frame.size.width) {
            cell.mLab_name.numberOfLines =0;
        }
        cell.mLab_name.text = groupModel.Name;
        
    
    return cell;
}
//定义并返回每个headerView或footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    Forward_section *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kDetailedViewControllerID forIndexPath:indexPath];
    
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];
    if([[dm getInstance].sectionSet containsObject:num])
    {
        [view.addBtn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [view.triangleBtn setImage:[UIImage imageNamed:@"bTri.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.addBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [view.triangleBtn setImage:[UIImage imageNamed:@"rTri.png"] forState:UIControlStateNormal];

    }
    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
    if(model.sectionSelSymbol ==1)
    {
        [view.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];

        
    }

    
    

    view.delegate = self;
    view.tag = indexPath.section;

    view.mLab_name.text = model.GroupName;

    

    CGSize size = [view.mLab_name.text sizeWithFont:[UIFont systemFontOfSize:12]];

    view.addBtn.frame = CGRectMake(view.mLab_name.frame.origin.x+size.width, 5, 30, 30);
    
    return view;
}
//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
    groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
    if(groupModel.mInt_select == 0)
    {
        groupModel.mInt_select = 1;
    }
    else
    {
        groupModel.mInt_select = 0;
    }
    NSUInteger subSymbol = 0;
    for(int i=0;i<model.groupselit_selit.count;i++)
    {
        groupselit_selitModel *subModel = [model.groupselit_selit objectAtIndex:i];
        subSymbol = subSymbol + subModel.mInt_select;
        
    }
    if(subSymbol == model.groupselit_selit.count)
    {
        model.sectionSelSymbol = 1;
    }
    else if (subSymbol == 0)
    {
        model.sectionSelSymbol = 0;
        
        
    }
    else{
        model.sectionSelSymbol = 2;
    }
    NSUInteger modelSymbol = 0;

    for(int i=0;i<self.mModel_myUnit.list.count;i++)
    {
        UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
       if(model.sectionSelSymbol ==2)
       {
           self.allSelected = 2;
           modelSymbol = 10000;
           break;
       }
        else
        {
            modelSymbol = modelSymbol + model.sectionSelSymbol;
        }
        
    }
    if(modelSymbol == self.self.mModel_myUnit.list.count)
    {
        self.allSelected = 1;
 
    }
    else if (modelSymbol == 0)
    {
        self.allSelected = 0;

    }
    else
    {
        self.allSelected = 2;
    }
    
    if(self.allSelected ==1)
    {
        self.imgV.image = [UIImage imageNamed:@"selected.png"];
        
    }
    else
    {
        self.imgV.image = [UIImage imageNamed:@"blank.png"];
        
    }

    [self.mCollectionV_list reloadData];
}
    

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-60)/2, 40);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//手动设置size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(120, 40);
}

//section点击事件
-(void)Forward_sectionClickBtnWith:(UIButton *)btn cell:(Forward_section *)section{
    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:section.tag];

    if(btn.tag == 6)
    {
        [self CollectionReloadData];
    }
    else if(btn.tag == 7)
    {
        if(model.sectionSelSymbol == 0||model.sectionSelSymbol == 2)
        {
            model.sectionSelSymbol = 1;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                groupModel.mInt_select = 1;
                
            }
            
        }
        else if(model.sectionSelSymbol == 1)
        {

        }


    }
    else if(btn.tag == 2)
    {
        if(model.sectionSelSymbol == 1)
        {
            model.sectionSelSymbol = 0;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                groupModel.mInt_select = 0;
                
            }
            
        }
        else if(model.sectionSelSymbol == 0)
        {
            model.sectionSelSymbol = 1;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                groupModel.mInt_select = 1;
                
            }
        }
        else if(model.sectionSelSymbol == 2)
        {
            model.sectionSelSymbol = 2;
            for (int i=0; i<model.groupselit_selit.count; i++)
            {
                groupselit_selitModel *groupModel = [model.groupselit_selit objectAtIndex:i];
                if(groupModel.mInt_select==0)
                {
                    groupModel.mInt_select = 1;

                    
                }
                else
                {
                    groupModel.mInt_select = 0;

                    
                }
                
            }
        }
        
    }
    NSInteger isAll = 0;
    for(int i=0;i<self.mModel_myUnit.list.count;i++)
    {
        UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
        if(model.sectionSelSymbol == 2)
        {
            self.allSelected = 2;
            isAll = 10000;
            break;
        }

        isAll = isAll+model.sectionSelSymbol;

        
    }
    if(isAll == 0)
    {
        self.allSelected = 0;
        
    }
    else if(isAll == self.mModel_myUnit.list.count)
    {
        self.allSelected = 1;
        
    
    }
    else
    {
        self.allSelected = 2;
    }
    if(self.allSelected ==1)
    {
        self.imgV.image = [UIImage imageNamed:@"selected.png"];
    }
    else
    {
        self.imgV.image = [UIImage imageNamed:@"blank.png"];

        
    }

[self.mCollectionV_list reloadData];
    
}



//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)mBtn_send:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    long long fileSizeSum = 0;
    for(int i=0;i<self.topView.mArr_accessory.count;i++)
    {
        AccessoryModel *model = [self.topView.mArr_accessory objectAtIndex:i];
        long long fileSize = 0;
        fileSize = [model.fileAttributeDic fileSize];
        fileSizeSum = fileSizeSum +fileSize;
        
    }
    D("fileSizeSum = %lld",fileSizeSum);

    if(fileSizeSum>10000000)
    {
        [MBProgressHUD showError:@"上传文件不能大于10M" toView:self.view];

        return;
        
    }


    
    if ([utils isBlankString:self.topView.mTextV_input.text])
    {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    
    myUnit *tempUnit = [dm getInstance].mModel_unitList.myUnit;
    
    [array addObjectsFromArray:[self addMyUnitMember:tempUnit]];
    
    if (array.count==0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }

        //发表
            NSMutableArray *array1 = [[NSMutableArray alloc]initWithCapacity:0];
            //[array1 addObjectsFromArray:self.topView.mArr_accessory];
    for(int i=0;i<self.topView.mArr_accessory.count;i++)
    {
        AccessoryModel *model = [self.topView.mArr_accessory objectAtIndex:i];
        [array1 addObject:model.mStr_name];
    }
            [[LoginSendHttp getInstance] creatCommMsgWith:self.topView.mTextV_input.text SMSFlag:self.topView.mInt_sendMsg unitid:[dm getInstance].mModel_unitList.myUnit.TabIDStr classCount:0 grsms:1 array:array forwardMsgID:@"" access:array1];
        

    
    [MBProgressHUD showMessage:@"正在发送" toView:self.view];
    
    [self.mCollectionV_list reloadData];
    
}
//加载新建事务的勾选人员
-(NSMutableArray *)addMyUnitMember:(myUnit *)tempUnit{
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<tempUnit.list.count; i++) {
        UserListModel *model2 = [tempUnit.list objectAtIndex:i];
        NSMutableArray *arr9 = model2.groupselit_selit;
        for (int n=0; n<arr9.count; n++) {
            groupselit_selitModel *model3 = [arr9 objectAtIndex:n];
            if (model3.mInt_select == 1) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:model3.flag forKey:@"flag"];
                [dic setValue:model3.selit forKey:@"selit"];
                [array addObject:dic];
            }
        }
    }
    return array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
