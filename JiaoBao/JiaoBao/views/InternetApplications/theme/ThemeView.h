//
//  ThemeView.h
//  JiaoBao
//  主题
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "dm.h"
#import "utils.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "KnowledgeHttp.h"

@interface ThemeView : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//首页精选等
@property (nonatomic,strong) UITableView *mTableV_knowledge;//
@property (nonatomic,assign) int mInt_index;//首页等选择的索引
@property (nonatomic,strong) NSMutableArray *mArr_first;//首页
@property (nonatomic,strong) NSMutableArray *mArr_choice;//精选
@property (nonatomic,strong) NSMutableArray *mArr_recommend;//推荐
@property (nonatomic,strong) NSMutableArray *mArr_education;//教育
@property (nonatomic,strong) NSMutableArray *mArr_science;//科普
@property (nonatomic,strong) NSMutableArray *mArr_life;//生活
@property (nonatomic,strong) NSMutableArray *mArr_happy;//娱乐
@property (nonatomic,strong) NSMutableArray *mArr_paternity;//亲子
@property (nonatomic,strong) NSMutableArray *mArr_extracurricular;//课外


- (id)initWithFrame1:(CGRect)frame;
-(void)ProgressViewLoad;

@end
