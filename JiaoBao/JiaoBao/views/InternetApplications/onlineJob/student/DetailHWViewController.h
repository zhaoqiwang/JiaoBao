//
//  DetailHWViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/10/29.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"


@interface DetailHWViewController : UIViewController<MyNavigationDelegate,UIWebViewDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,strong)NSString *TabID;//作业ID
@property(nonatomic,strong)NSString *hwName;//作业名字
@property(nonatomic,strong)NSString *hwinfoid;
@property (weak, nonatomic) IBOutlet UILabel *hwNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)previousBtnAction:(id)sender;
- (IBAction)nextBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *qNum;//选题数量按钮
- (IBAction)qNumQustion:(id)sender;//选题数量按钮方法

@end
