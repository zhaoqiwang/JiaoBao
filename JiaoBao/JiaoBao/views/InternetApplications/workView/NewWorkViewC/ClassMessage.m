//
//  ClassMessage.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassMessage.h"
#import "Forward_cell.h"
#import "SVProgressHUD.h"
NSString *kCell = @"Forward_cell2";

@implementation ClassMessage

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(classMessage:) name:@"classMessage" object:nil];


    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    label.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    label.text = @"  所在班级家长";
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    //self.view.backgroundColor = [UIColor lightGrayColor];
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向

    if([dm getInstance].mModel_unitList.UnitClass.count == 0)
    {
        
    }
//
    self.mCollectionV_list = [[UICollectionView alloc]initWithFrame:CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y, [dm getInstance].width, 600) collectionViewLayout:flowLayout];
    [self addSubview:self.mCollectionV_list];

    self.mCollectionV_list.backgroundColor = [UIColor whiteColor];
    self.mCollectionV_list.layer.borderWidth = 1;
    self.mCollectionV_list.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCell];
    self.mCollectionV_list.delegate = self;
    self.mCollectionV_list.dataSource = self;
    self.mCollectionV_list.allowsMultipleSelection = YES;
    
    
    return self;
    
}
- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    
    return self.datasource.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    if (!cell) {
        
    }
    
    myUnit *myunit = [self.datasource objectAtIndex:indexPath.row];
    cell.mLab_name.text = myunit.UintName;
    if(myunit.isSelected == YES)
    {
        [cell.mImgV_select setImage:[UIImage imageNamed:@"selected.png"]];
    }
    else
    {
        [cell.mImgV_select setImage:[UIImage imageNamed:@"blank.png"]];

    }
    
    
    
    
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    myUnit *myuint = [self.datasource objectAtIndex:indexPath.row];
    myuint.isSelected = !myuint.isSelected;
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
    return CGSizeMake(120, 0);
}

////通知界面更新，获取事务信息接收单位列表
//-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
//    if([dm getInstance].notificationSymbol ==100)
//    {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"progress2" object:nil];
//        self.mModel_unitList = noti.object;
//    self.datasource = self.mModel_unitList.UnitClass;
//    [self.mCollectionV_list reloadData];
//
//    self.unitStr = self.mModel_unitList.myUnit.TabIDStr;
//    for(int i=0;i<self.mModel_unitList.UnitClass.count;i++)
//    {
//        myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
//        [[LoginSendHttp getInstance] login_GetUnitClassRevicer:unit.TabID Flag:unit.flag];
//
//    }
//    }
//
//    
//}
-(void)classMessage:(id)sender
{
    //[MBProgressHUD hideHUDForView:self];
    self.datasource = [dm getInstance].mModel_unitList.UnitClass;
                    for(int i=0;i<[dm getInstance].mModel_unitList.UnitClass.count;i++)
                    {
    
                        myUnit *unit = [[dm getInstance].mModel_unitList.UnitClass objectAtIndex:i];
                        [[LoginSendHttp getInstance] login_GetUnitClassRevicer:unit.TabID Flag:unit.flag];
    
                    }

    self.dataArr = [NSMutableArray arrayWithArray:[sender object]];

    for(int i=0;i<self.dataArr.count;i++)
    {
        myUnit *unit = [self.dataArr objectAtIndex:i];
        for(int i =0;i<unit.list.count ;i++)
        {
            UserListModel *model = [unit.list objectAtIndex:i];
            if([model.GroupName isEqualToString:@"本班老师"]|[model.GroupName isEqualToString:@"本班学生"])
            {
                [unit.list removeObject:model];
            }
            
        }
        
        
        
    }
//    if(self.datasource.count == 0)
//    {
//        [SVProgressHUD showInfoWithStatus:@"无班级" ];
//    }
//           [[NSNotificationCenter defaultCenter]postNotificationName:@"progress2" object:nil];

    
    [self.mCollectionV_list reloadData];
}
//-(void)GetUnitRevicer:(NSNotification *)noti{
//    if([dm getInstance].notificationSymbol == 2)
//    {
//        
//        NSDictionary *dic = noti.object;
//        NSString *unitID = [dic objectForKey:@"unitID"];
//        NSArray *array = [dic objectForKey:@"array"];
//        
//        //班级
//        for (int i=0; i<[dm getInstance].mModel_unitList.UnitClass.count; i++)
//        {
//            myUnit *unit = [[dm getInstance].mModel_unitList.UnitClass objectAtIndex:i];
//            if ([unit.TabID intValue] == [unitID intValue]) {
//
//            unit.list = [NSMutableArray arrayWithArray:array];
//            [self.dataArr addObject:unit];
//            }
//            
//            
//
//        }
//        for(int i=0;i<self.dataArr.count;i++)
//        {
//            myUnit *unit = [self.dataArr objectAtIndex:i];
//            for(int i =0;i<unit.list.count ;i++)
//            {
//                UserListModel *model = [unit.list objectAtIndex:i];
//                if([model.GroupName isEqualToString:@"本班老师"]|[model.GroupName isEqualToString:@"本班学生"])
//                {
//                    [unit.list removeObject:model];
//                }
//                
//            }
//            NSLog(@"dataArrCount = %lu",(unsigned long)self.dataArr.count);
//
//
//            
//        }
//
//
//        
//    }
//    
//
//}



@end
