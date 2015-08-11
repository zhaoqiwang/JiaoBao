//
//  CommentViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "QuestionModel.h"
#import "UIImageView+WebCache.h"
#import "KnowledgeHttp.h"
#import "ButtonView.h"



@interface CommentViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,ButtonViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic,strong)QuestionModel *questionModel;
@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic,assign)float cellHeight;
@property(nonatomic,strong)ButtonView *mBtnV_btn;

@end
