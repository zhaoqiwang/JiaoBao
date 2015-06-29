//
//  CharacterView.h
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utils.h"
#import "dm.h"
#import "LoginSendHttp.h"
#import "Forward_cell.h"
#import "MBProgressHUD.h"
#import "Forward_section.h"

@interface CharacterView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,Forward_sectionDelegate>
@property(nonatomic,strong)UICollectionView *mCollectionV_list;
@property(nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
@property(nonatomic,strong)myUnit *mModel_myUnit;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *sectionArr;
- (void)removeNotification;


@end
