//
//  ClassMessage.h
//  JiaoBao
//  班级通知
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utils.h"
#import "dm.h"
#import "LoginSendHttp.h"
#import "Forward_cell.h"
#import "MBProgressHUD.h"

@interface ClassMessage : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>
@property(nonatomic,strong)UICollectionView *mCollectionV_list;
@property(nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
//@property(nonatomic,strong)myUnit *unit;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSString *unitStr;
- (void)removeNotification;




@end
