//
//  CategoryViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllCategoryModel.h"
#import "CategorySection.h"
#import "MBProgressHUD+AD.h"

@interface CategoryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CategorySectionDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)UITextField *categoryTF;
@property(nonatomic,strong)NSMutableString *categoryId;
@property(nonatomic,strong)NSMutableArray *mArr_AllCategory;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property(nonatomic,strong)NSMutableArray *mArr_selectCategory;
@property(nonatomic,strong)NSMutableArray *mArr_addBtnSel;
@property(nonatomic,strong)NSString *classStr;
- (IBAction)selectAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end
