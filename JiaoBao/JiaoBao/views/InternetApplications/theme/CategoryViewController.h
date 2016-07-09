//
//  CategoryViewController.h
//  JiaoBao
//  话题分类界面
//  Created by songyanming on 15/8/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllCategoryModel.h"
#import "CategorySection.h"
#import "MBProgressHUD+AD.h"

@interface CategoryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CategorySectionDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)UITextField *categoryTF;//分类输入框
@property(nonatomic,strong)NSMutableString *categoryId;//分类id
@property(nonatomic,strong)NSMutableArray *mArr_AllCategory;
@property(nonatomic,strong)ItemModel *ItemModel;//选择的话题model

- (IBAction)backAction:(id)sender;//返回按钮
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property(nonatomic,strong)NSMutableArray *mArr_selectCategory;//被选择的分类 数组
@property(nonatomic,strong)NSMutableArray *mArr_addBtnSel;//伸缩按钮
@property(nonatomic,strong)NSString *classStr;//区别下拉还是话题分类
- (IBAction)selectAction:(id)sender;//选择按钮方法
@property (weak, nonatomic) IBOutlet UIButton *selBtn;//选择按钮

@end
