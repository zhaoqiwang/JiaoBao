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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.datasource = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
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
    [self.mCollectionV_list registerClass:[Forward_cell class] forCellWithReuseIdentifier:kCell3];
    [self.mCollectionV_list registerClass:[Forward_section class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSection];
    self.mCollectionV_list.delegate = self;
    self.mCollectionV_list.dataSource = self;
    
    return self;
    
}
#pragma mark - Collection View Data Source
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    
    return 6;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell3 forIndexPath:indexPath];
    if (!cell) {
        
    }
    
    
    cell.mLab_name.text = @"班级名称";
    
    
    
    
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
    
    
    view.delegate = self;
    view.tag = indexPath.section;


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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
