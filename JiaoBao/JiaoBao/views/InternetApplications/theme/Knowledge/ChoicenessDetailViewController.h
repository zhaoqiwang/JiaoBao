//
//  ChoicenessDetailViewController.h
//  JiaoBao
//  精选界面
//  Created by songyanming on 15/9/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickContentModel.h"
#import "MyNavigationBar.h"
#import "QuestionDetailModel.h"



@interface ChoicenessDetailViewController : UIViewController<MyNavigationDelegate>
@property(nonatomic,strong)PickContentModel *pickContentModel;//精选内容model
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property(nonatomic,strong)QuestionDetailModel *QuestionDetailModel;//问题详情model
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;


@end
