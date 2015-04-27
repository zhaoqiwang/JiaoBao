//
//  CharacterView.h
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "Forward_section.h"

@interface CharacterView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,Forward_sectionDelegate>
@property(nonatomic,strong)UICollectionView *mCollectionV_list;
@property(nonatomic,strong)NSMutableArray *datasource;

@end
