//
//  CheckingInViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/3/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "dm.h"
#import "MBProgressHUD.h"
#import <BaiduMapAPI/BMapKit.h>
//#import <MapKit/MapKit.h>
//#import "BMapKit.h"


@interface CheckingInViewController : UIViewController<MyNavigationDelegate,CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    IBOutlet UIView *bottomView;
    
}
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property (weak, nonatomic) IBOutlet UIButton *FirstBtn;//普通考勤
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;//默认考勤
@property(nonatomic,strong)UITableView *mTableV_left,*mTableV_right;
@property(nonatomic,strong)UIView *mView_all;


@end
