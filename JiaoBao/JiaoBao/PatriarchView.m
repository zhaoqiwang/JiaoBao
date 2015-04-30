//
//  PatriarchView.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PatriarchView.h"
NSString *kCell4 = @"Forward_cell";
NSString *kSection4 = @"Forward_section";
@implementation PatriarchView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [dm getInstance].notificationSymbol = 203;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = @"所在班级家长";
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    //self.view.backgroundColor = [UIColor lightGrayColor];
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    
    //
    self.mCollectionV_list = [[UICollectionView alloc]initWithFrame:CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y, [dm getInstance].width, 300) collectionViewLayout:flowLayout];
    [self addSubview:self.mCollectionV_list];
    
    self.mCollectionV_list.backgroundColor = [UIColor whiteColor];
    self.mCollectionV_list.layer.borderWidth = 1;
    self.mCollectionV_list.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCell4];
    [self.mCollectionV_list registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSection4];
    self.mCollectionV_list.delegate = self;
    self.mCollectionV_list.dataSource = self;
    
    
    
    return self;
    
}
#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSLog(@"count = %d",self.mModel_myUnit.list.count);
    return self.mModel_myUnit.list.count;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    for (int i=0; i<self.mModel_myUnit.list.count; i++) {
        if (section == i) {
            UserListModel *model = [self.mModel_myUnit.list objectAtIndex:i];
            return model.groupselit_selit.count;
        }
    }
    return 0;
    
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell4 forIndexPath:indexPath];
    if (!cell) {
        
    }
    
    groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:indexPath.section];
    groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
    
    if (groupModel.selit.length>0) {
        cell.mLab_name.textColor = [UIColor blackColor];
        if (groupModel.mInt_select == 0) {
            cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
        } else {
            cell.mImgV_select.image = [UIImage imageNamed:@"selected"];
        }
    }else{
        cell.mLab_name.textColor = [UIColor grayColor];
        cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
    }
    CGSize size = [groupModel.Name sizeWithFont:[UIFont systemFontOfSize:12]];
    if (size.width>cell.mLab_name.frame.size.width) {
        cell.mLab_name.numberOfLines = 2;
    }
    cell.mLab_name.text = groupModel.Name;
    
    
    
    
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];
    
    
    
    
    Forward_section *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSection4 forIndexPath:indexPath];
    if([[dm getInstance].sectionSet2 containsObject:num])
    {
        [view.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [view.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
        
    }
    
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
    //    if(myunit.isSelected == YES)
    //    {
    //        [view.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    //    }
    //    else
    //    {
    //        [view.rightBtn setImage:[UIImage imageNamed:@"blank.png"]forState:UIControlStateNormal];
    //
    //    }
    view.mLab_name.text = model.GroupName;
    view.delegate = self;
    view.tag = indexPath.section;
    view.rightBtn.hidden = YES;
    view.mBtn_all.hidden = YES;
    
    
    return view;
}
//手动设置size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(120, 40);
}


//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    myUnit *myuint = [self.mModel_unitList.UnitClass objectAtIndex:indexPath.row];
//    myuint.isSelected = !myuint.isSelected;
//    [self.mCollectionV_list reloadData];
    
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
-(void)Forward_sectionClickBtnWith:(UIButton *)btn cell:(Forward_section *)section{
    //    UserListModel *model = [self.mModel_myUnit.list objectAtIndex:section.tag];
    //    groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
    //    myUnit *unit = [self.datasource objectAtIndex:section.tag];
    //    unit.isSelected = !unit.isSelected;
}
////通知界面更新，获取事务信息接收单位列表
//-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
//    [self.mProgressV hide:YES];
//    self.mModel_unitList = noti.object;
//    if([dm getInstance].notificationSymbol == 203)
//    {
//         [[LoginSendHttp getInstance] login_GetUnitClassRevicer:self.mModel_unitList.myUnit.TabID Flag:self.mModel_unitList.myUnit.flag];
//    }
//
//    
//    
//    
//    //[self.mCollectionV_list reloadData];
//    
//}
//
//-(void)GetUnitRevicer:(NSNotification *)noti{
//    [self.mProgressV hide:YES];
//    NSDictionary *dic = noti.object;
//    NSString *unitID = [dic objectForKey:@"unitID"];
//    NSArray *array = [dic objectForKey:@"array"];
//    //[utils logArr:array];
//    self.datasource  = array;
//    
//    
//    //班级
//    for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
//        myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
//        if ([unit.TabID intValue] == [unitID intValue]) {
//            unit.list = [NSMutableArray arrayWithArray:array];
//            self.mModel_myUnit = unit;
//        }
//    }
//    //    //刷新
//    [self.mCollectionV_list reloadData];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
