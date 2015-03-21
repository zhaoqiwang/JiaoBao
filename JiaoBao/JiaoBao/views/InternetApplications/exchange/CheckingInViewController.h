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
#import <MapKit/MapKit.h>
#import "BMapKit.h"


@interface CheckingInViewController : UIViewController<MyNavigationDelegate,MyNavigationBtnTitleDelegate,MKMapViewDelegate,CLLocationManagerDelegate,BMKAnnotation,BMKMapViewDelegate,BMKOverlay,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    IBOutlet UIView *bottomView;
    
}
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property (weak, nonatomic) IBOutlet UIButton *FirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property(nonatomic,strong)UITableView *mTableV_left,*mTableV_right;
@property(nonatomic,strong)UIView *mView_all;


@end
