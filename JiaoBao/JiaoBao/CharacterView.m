//
//  CharacterView.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CharacterView.h"
#import "Forward_cell.h"
NSString *kCell3 = @"Forward_cell3";
NSString *kSection = @"Forward_section";

@implementation CharacterView
-(void)selSecBtn:(id)sender
{
        self.datasource = [NSMutableArray arrayWithArray:[sender object] ];
        for(int i=0;i<self.datasource.count;i++)
        {
            myUnit *unit = [self.datasource objectAtIndex:i];

            UserListModel *model = [unit.list objectAtIndex:i];
            if([model.GroupName isEqualToString:@"本班老师"]|[model.GroupName isEqualToString:@"本班学生"])
            {
                [unit.list removeObject:model];
            }
            for(int i=0;i<model.groupselit_selit.count;i++)
            {
                groupselit_selitModel *model2 = [model.groupselit_selit objectAtIndex:i];
                NSLog(@"555555 = %@",model2.Name);
            }
    
        }
    
    
            [self.mCollectionV_list reloadData];
    }
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selSecBtn:) name:@"selSecBtn" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];
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
    self.mCollectionV_list = [[UICollectionView alloc]initWithFrame:CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y, [dm getInstance].width, 800) collectionViewLayout:flowLayout];
    [self addSubview:self.mCollectionV_list];
    self.mCollectionV_list.scrollEnabled = NO;
    
    self.mCollectionV_list.backgroundColor = [UIColor whiteColor];
    self.mCollectionV_list.layer.borderWidth = 1;
    self.mCollectionV_list.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCell3];
    [self.mCollectionV_list registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSection];
    self.mCollectionV_list.delegate = self;
    self.mCollectionV_list.dataSource = self;
    [[LoginSendHttp getInstance] login_CommMsgRevicerUnitList];

    
    
    
    return self;
    
}
#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.datasource.count;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
        myUnit *unit = [self.datasource objectAtIndex:section];
        UserListModel *model = [unit.list objectAtIndex:0];
    NSLog(@"count = %lu",(unsigned long)model.groupselit_selit.count);
        return model.groupselit_selit.count;

}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell3 forIndexPath:indexPath];
    if (!cell) {
        
    }
    myUnit *unit = [self.datasource objectAtIndex:indexPath.section];
    for(int i=0;i<unit.list.count;i++)
    {
        UserListModel *model = [unit.list objectAtIndex:i];
        groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
        groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
        if (groupModel.mInt_select == 0) {
            cell.mImgV_select.image = [UIImage imageNamed:@"blank"];
        } else {
            cell.mImgV_select.image = [UIImage imageNamed:@"selected"];
        }
        CGSize size = [groupModel.Name sizeWithFont:[UIFont systemFontOfSize:12]];
        if (size.width>cell.mLab_name.frame.size.width) {
            cell.mLab_name.numberOfLines = 2;
        }
        cell.mLab_name.text = groupModel.Name;

        

        
    }
    

    
    
    
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];
    
    


    Forward_section *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSection forIndexPath:indexPath];
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
    myUnit *unit = [self.datasource objectAtIndex:indexPath.section];
   // UserListModel *model = [unit.list objectAtIndex:indexPath.section];
//    if(myunit.isSelected == YES)
//    {
//        [view.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [view.rightBtn setImage:[UIImage imageNamed:@"blank.png"]forState:UIControlStateNormal];
//        
//    }
    view.mLab_name.text = unit.UintName ;
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
    myUnit *unit = [self.datasource objectAtIndex:indexPath.section];
    UserListModel *model = [unit.list objectAtIndex:0];
    groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
    groupModel = [model.groupselit_selit objectAtIndex:indexPath.row];
    if(groupModel.mInt_select == 1)
    {
        groupModel.mInt_select = 0;
    }
    else
    {
        groupModel.mInt_select = 1;
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
-(void)Forward_sectionClickBtnWith:(UIButton *)btn cell:(Forward_section *)section{
    if(btn.tag == 2)
    {
        groupselit_selitModel *groupModel = [[groupselit_selitModel alloc] init];
        myUnit *unit = [self.datasource objectAtIndex:section.tag];

        UserListModel *model = [unit.list objectAtIndex:0];
        for(int i=0;i<model.groupselit_selit.count;i++)
        {
            groupModel = [model.groupselit_selit objectAtIndex:i];
            if(groupModel.mInt_select == 1)
            {
                groupModel.mInt_select = 0;
            }
            else
            {
                groupModel.mInt_select = 1;
            }

            
        }

        [self.mCollectionV_list reloadData];
        
    }

}




@end
