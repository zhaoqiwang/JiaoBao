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
#import "MBProgressHUD.h"
#import "KnowledgeHttp.h"
#import "dm.h"
#import "OnlineJobHttp.h"

@interface CategoryViewController ()
@property(nonatomic,strong)NSArray *myAttCateArr;

@end

@implementation CategoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)GetMyattCate:(id)sender
{
    NSNotification *note = sender;
    
    NSString *code = [note.object objectForKey:@"ResultCode"];
    if([code integerValue]==0)
    {
        NSArray *arr = [note.object objectForKey:@"array"];
        if(arr.count>0)
        {
            for(int i=0;i<arr.count;i++)
            {
                if([[arr objectAtIndex:i] isEqualToString:@""])
                {
                    
                }
                else
                {
                    self.myAttCateArr = arr;
                    [[KnowledgeHttp getInstance]GetCategoryById:[arr objectAtIndex:i]];
                    
                }
                
            }
        }

    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSString *ResultDesc = [note.object objectForKey:@"ResultDesc"];
        
        [MBProgressHUD showError:ResultDesc toView:self.view];
        
    }
    
}
-(void)GetCategoryById:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSNotification *note = sender;
    
    NSString *code = [note.object objectForKey:@"ResultCode"];
    if([code integerValue]==0)
    {
        CategoryModel *categoryModel = [note.object objectForKey:@"model"];
        for(int i=0;i<self.mArr_AllCategory.count;i++)
        {
            AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:i];
            for(int j=0;j<model.mArr_subItem.count;j++)
            {
                ItemModel *itemModel = [model.mArr_subItem objectAtIndex:j];
                if([categoryModel.TabID isEqualToString:itemModel.TabID])
                {
                    [self.mArr_selectCategory addObject:itemModel];

                }

            }

        }

        
        if(self.myAttCateArr.count == self.mArr_selectCategory.count)
        {
            [self.collectionView reloadData];
        }

        
        
        
    }
    else
    {
        NSString *ResultDesc = [note.object objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[OnlineJobHttp getInstance]getStuInfoWithAccID:@"723609" UID:@"72202"];
//    [[OnlineJobHttp getInstance]getGenInfoWithAccID:@"5236710" UID:@"72202"];

    self.mArr_addBtnSel = [[NSMutableArray alloc]init];

    if([self.classStr isEqualToString:@"ThemeView"])
    {
        [[KnowledgeHttp getInstance]GetMyattCate];

        self.collectionView.allowsMultipleSelection = YES;
        self.titileLabel.text = @"显示优先显示的话题类别";
        [self.collectionView selectItemAtIndexPath:0 animated:0 scrollPosition:UICollectionViewScrollPositionNone];
        self.selBtn.hidden = NO;
        //获取我关注的话题数组
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyattCate" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyattCate:) name:@"GetMyattCate" object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetCategoryById" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetCategoryById:) name:@"GetCategoryById" object:nil];
    }
    else
    {
        self.collectionView.allowsMultipleSelection = NO;
        self.titileLabel.text = @"请选择话题类别";
        [self.collectionView selectItemAtIndexPath:0 animated:0 scrollPosition:UICollectionViewScrollPositionNone];
        self.selBtn.hidden = YES;



    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"AllcategoryCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategorySection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategorySection"];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    NSNumber *num = [NSNumber numberWithInteger:section];
    if([self.mArr_addBtnSel containsObject:num])
    {
        return 0;
    }
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
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];

    if([self.mArr_addBtnSel containsObject:num])
    {
        [sectionView.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];

    }
    else
    {
        [sectionView.addBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];

    }

    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    sectionView.nameLabel.text = model.item.Subject;
    sectionView.delegate = self;
    sectionView.tag = indexPath.section;
    
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
        if([self.mArr_selectCategory containsObject:itemModel])
        {
            cell.nameLabel.textColor = [UIColor redColor];
        }
        else
        {
            cell.nameLabel.textColor = [UIColor darkGrayColor];
        }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllcategoryCollectionViewCell *cell = (AllcategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.nameLabel.textColor = [UIColor redColor];
    self.categoryTF.text = cell.nameLabel.text;
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    ItemModel *itemModel = [model.mArr_subItem objectAtIndex:indexPath.row];
    self.ItemModel.TabID = itemModel.TabID;
    self.ItemModel.Subject = itemModel.Subject;
    self.ItemModel.QCount = itemModel.QCount;
    self.ItemModel.AttCount = itemModel.AttCount;
    self.ItemModel.ParentId = itemModel.ParentId;
    self.ItemModel.Subject = itemModel.Subject;
    

    if([self.classStr isEqualToString:@"AddQuestionViewController"])
    {
        [self.mArr_selectCategory removeAllObjects];
        [self.mArr_selectCategory addObject:itemModel];
        cell.nameLabel.textColor = [UIColor redColor];
        [self.collectionView reloadData];
        if(self.categoryTF)
        {

        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCategory" object:itemModel];
        }
        [self dismissViewControllerAnimated:YES completion:nil];



    }
    else
    {
        if([cell.nameLabel.textColor isEqual:[UIColor redColor]])
        {
            [self.mArr_selectCategory removeObject:itemModel];
            cell.nameLabel.textColor = [UIColor darkGrayColor];
        }
        else
        {
            [self.mArr_selectCategory addObject:itemModel];
            cell.nameLabel.textColor = [UIColor redColor];
            
            
        }
        
    }

    [self.categoryId setString:itemModel.TabID];


    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllcategoryCollectionViewCell *cell = (AllcategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    ItemModel *itemModel = [model.mArr_subItem objectAtIndex:indexPath.row];
    if([self.classStr isEqualToString:@"AddQuestionViewController"])
    {if([self.mArr_selectCategory containsObject:itemModel])
    {
        [self.mArr_selectCategory removeObject:itemModel];
        cell.nameLabel.textColor = [UIColor darkGrayColor];
        
    }

    }
    else
    {
        if([cell.nameLabel.textColor isEqual:[UIColor redColor]])
        {
            [self.mArr_selectCategory removeObject:itemModel];
            cell.nameLabel.textColor = [UIColor darkGrayColor];
        }
        else
        {
            [self.mArr_selectCategory addObject:itemModel];
            cell.nameLabel.textColor = [UIColor redColor];
            
            
        }
        
    }

//    if([self.mArr_selectCategory containsObject:itemModel])
//    {
//        [self.mArr_selectCategory removeObject:itemModel];
//        cell.nameLabel.textColor = [UIColor blackColor];
//
//    }
//    else
//    {
//        if([self.classStr isEqualToString:@"ThemeView"])
//        {
//            [self.mArr_selectCategory addObject:itemModel];
//
//        }
//    }

}



//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:indexPath.section];
    ItemModel *itemModel = [model.mArr_subItem objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc]init];
    label.text = itemModel.Subject;
    CGSize size = [itemModel.Subject sizeWithFont:[UIFont systemFontOfSize:15]];
    return CGSizeMake(size.width, 30);
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

-(void)CategorySectionClickBtnWith:(UIButton *)btn section:(CategorySection *) section
{
    NSNumber *num = [NSNumber numberWithInteger:section.tag];

    if(![self.mArr_addBtnSel containsObject:num])
    {
        [self.mArr_addBtnSel addObject:num];
        
    }
    else
    {
        [self.mArr_addBtnSel removeObject:num];

    }
    [self.collectionView reloadData];

}

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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectAction:(id)sender {
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    if(self.mArr_selectCategory.count >0)
    {
        for(int i =0;i<self.mArr_selectCategory.count;i++)
        {
            ItemModel *model = [self.mArr_selectCategory objectAtIndex:i];
            [mArr addObject:model.TabID];

        }
        NSString *tabIdsStr = [mArr componentsJoinedByString:@","];
        [[KnowledgeHttp getInstance]AddMyattCateWithuid:tabIdsStr];

        //[MBProgressHUD showSuccess:@"关注话题成功"];

    }
    else
    {
        [[KnowledgeHttp getInstance]AddMyattCateWithuid:@""];
        [[NSNotificationCenter defaultCenter]removeObserver:self];

    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
