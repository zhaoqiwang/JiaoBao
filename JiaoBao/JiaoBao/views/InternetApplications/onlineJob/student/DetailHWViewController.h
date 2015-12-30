//
//  DetailHWViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/10/29.
//  Copyright © 2015年 JSY. All rights reserved.
//做作业界面

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"


@interface DetailHWViewController : UIViewController<MyNavigationDelegate,UIWebViewDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,strong)NSString *TabID;//作业ID
@property(nonatomic,strong)NSString *hwName;//作业名字
@property(nonatomic,strong)NSString *hwinfoid;
@property (weak, nonatomic) IBOutlet UILabel *hwNameLabel;//作业名称
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;//上一题
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;//下一题
@property (weak, nonatomic) IBOutlet UIWebView *webView;//加载题目
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;//倒计时
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;//倒计时的时间
@property(nonatomic,assign)BOOL isSubmit;//作业是否已经完成 1：完成 0：未完成
@property(nonatomic,strong)NSString *FlagStr;//区分跳转到那个界面 1是学生 2是家长
- (IBAction)previousBtnAction:(id)sender;//上一题方法
- (IBAction)nextBtnAction:(id)sender;//下一题方法
@property (weak, nonatomic) IBOutlet UIButton *qNum;//选题数量按钮
- (IBAction)qNumQustion:(id)sender;//选题数量按钮方法
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;//collectionview高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewHeight;//webview高度（暂未用到）
@property(nonatomic,strong)NSString *navBarName;
@property (weak, nonatomic) IBOutlet UILabel *questionNumLabel;//总题数

@end
