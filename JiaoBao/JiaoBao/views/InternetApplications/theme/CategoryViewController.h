//
//  CategoryViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllCategoryModel.h"

@interface CategoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *mArr_AllCategory;
- (IBAction)backAction:(id)sender;

@end
