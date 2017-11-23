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
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

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
