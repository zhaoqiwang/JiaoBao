//
//  CategoryViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/8/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CategoryViewController.h"
#import "AllcategoryCollectionViewCell.h"
#import "CategorySection.h"
#import "dm.h"
#import "define_constant.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];

    if([nowViewStr isEqualToString:@"CategoryViewController"])
    {
        self.mArr_selectCategory = [[NSMutableArray alloc]initWithCapacity:0];
        self.collectionView.allowsMultipleSelection = YES;
        self.titileLabel.text = @"显示优先显示的话题类别";
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"AllcategoryCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategorySection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategorySection"];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:section];

    return model.mArr_subItem.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mArr_AllCategory.count;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    CategorySection *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CategorySection" forIndexPath:indexPath];
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    sectionView.nameLabel.text = model.item.Subject;
    sectionView.delegate = self;
    
    return sectionView;
}

//手动设置size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(320, 40);
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllcategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    ItemModel *itemModel = [model.mArr_subItem objectAtIndex:indexPath.row];
    cell.nameLabel.text = itemModel.Subject;
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    if([nowViewStr isEqualToString:@"CategoryViewController"])
    {
        if(cell.selected == YES)
        {
            cell.nameLabel.textColor = [UIColor redColor];
        }
        else
        {
            cell.nameLabel.textColor = [UIColor blackColor];
        }
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllcategoryCollectionViewCell *cell = (AllcategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.nameLabel.textColor = [UIColor redColor];
    self.categoryTF.text = cell.nameLabel.text;
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    ItemModel *itemModel = [model.mArr_subItem objectAtIndex:indexPath.row];
    [self.categoryId setString:itemModel.TabID];
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    if([nowViewStr isEqualToString:@"CategoryViewController"])
    {
        [self.mArr_selectCategory addObject:itemModel];

    }
    cell.nameLabel.textColor = [UIColor redColor];
    

    
    
    

    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllcategoryCollectionViewCell *cell = (AllcategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    ItemModel *itemModel = [model.mArr_subItem objectAtIndex:indexPath.row];
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    if([nowViewStr isEqualToString:@"CategoryViewController"])
    {
        [self.mArr_selectCategory removeObject:itemModel];
        
    }
    cell.nameLabel.textColor = [UIColor blackColor];
}



//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//-(void)CategorySectionClickBtnWith:(UIButton *)btn section:(CategorySection *) section
//{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
