//
//  CheckingInViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/3/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//iqYoKFAodVcfY8oRpi0KtuHs
#import "CheckingInViewController.h"
#import "KxMenu.h"
#import "SignInHttp.h"
#import "SVProgressHUD.h"
#import "dm.h"
#import "MBProgressHUD.h"
#import "RecordViewController.h"
#import <UMAnalytics/MobClick.h>

@interface CheckingInViewController ()
{

    CLLocationManager  *locationManager;
    BOOL flag;
    BMKMapView* BaidumapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    NSString *address;
    NSString *dateStr;


}

@property (strong, nonatomic) IBOutlet UIPickerView *pickView;//点击考勤模式弹出的pickView
@property(nonatomic,strong)CLLocationManager *locationManage;
@property(nonatomic,assign)CLLocationDegrees Longitude;
@property(nonatomic,assign)CLLocationDegrees Latitude;
@property(nonatomic,strong)CLLocation *location;
@property(nonatomic,strong)NSArray *groupArr;
@property(nonatomic,strong)NSString *SignInGroupID;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property(nonatomic,assign)NSUInteger selectedRow;
@property(nonatomic,strong)UITextField *field;
@property(nonatomic,strong)BMKCircle* circle;
@property(nonatomic,strong)UILabel *nameLabel,*nameLabel2;
@property(nonatomic,assign)NSUInteger range;

- (IBAction)checkInAction:(id)sender;//点击签到按钮方法

- (IBAction)recordAction:(id)sender;//点击纪录按钮方法
- (IBAction)groupTypeAction:(id)sender;//点击考勤模式方法


- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;




@end

@implementation CheckingInViewController
-(void)dealloc
{
    if(BaidumapView)
    {
        BaidumapView = nil;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    [BaidumapView viewWillAppear];
    [_locService startUserLocationService];

    BaidumapView.showsUserLocation = NO;
    BaidumapView.showsUserLocation = YES;

    BaidumapView.delegate = self;
    _locService.delegate = self;
    _searcher.delegate = self;
    // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

    [BaidumapView viewWillDisappear];
    [_locService stopUserLocationService];

    _locService.delegate = nil;
    _searcher.delegate = nil;


    BaidumapView.showsUserLocation = NO;
    BaidumapView.delegate = nil; // 不用时，置nil

    
    
}
-(void)getUnitName:(id)sender
{
    [self.mNav_navgationBar leftBtnAction:[dm getInstance].mStr_unit];
    [[SignInHttp getInstance]getTime];

    [[SignInHttp getInstance]getSignInAddress];
    [[SignInHttp getInstance]GetSignInGroupByUnitID];
}
-(void)locationAction:(id)sender
{
    [_locService stopUserLocationService];
    
    _locService.delegate = nil;
    
    
    BaidumapView.showsUserLocation = NO;
    BaidumapView.delegate = nil; // 不用时，置nil
    [_locService startUserLocationService];
    
    BaidumapView.showsUserLocation = NO;
    BaidumapView.showsUserLocation = YES;
    BaidumapView.delegate = self;
    _locService.delegate = self;
    self.nameLabel2.text = @"定位中...";

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, [dm getInstance].height*0.8, 280, 30)];
    self.nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, [dm getInstance].height*0.8, 280, 30)];


    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnitName:) name:@"unitNameNotication" object:nil];

    BaidumapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64+30, [dm getInstance].width, [dm getInstance].height-94)];
    [self.view addSubview:BaidumapView];
    [self.view addSubview:bottomView];
    [bottomView setFrame:CGRectMake(0, [dm getInstance].height-90, [dm getInstance].width, 90)];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.frame = CGRectMake(270, 64+35, 50, 30);
    [self.view addSubview:locationBtn];
    

    
    BaidumapView.delegate = self;
    BaidumapView.zoomLevel = 10;
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = YES;//精度圈是否显示
    //displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [BaidumapView updateLocationViewWithParam:displayParam];
    [self.view addSubview:self.mView_all];

    flag = YES;
    self.SignInGroupID = [dm getInstance].jiaoBaoHao;
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(-100, -100, -100, -100)];
    [self.view addSubview:self.field];
    self.field.inputAccessoryView = self.toolBar;
    self.field.inputView = self.pickView;
    self.selectedRow = 0;
    
    [[SignInHttp getInstance]getTime];
    [[SignInHttp getInstance]getSignInAddress];
    [[SignInHttp getInstance]GetSignInGroupByUnitID];
    [MBProgressHUD showMessage:@"" toView:self.view];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSignInAddress:) name:@"getSignInAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSignInGroupByUnitID:) name:@"GetSignInGroupByUnitID" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrentTime:) name:@"GetTime" object:nil];

    
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@""];
    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"appNav_contact"]];
//    [self.mNav_navgationBar setBackBtnTitle:[dm getInstance].mStr_unit];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar leftBtnAction:[dm getInstance].mStr_unit];
    [self.view addSubview:self.mNav_navgationBar];
    BMKCoordinateRegion theRegion = { {0.0,0.0 }, {0.0,0.0 } };
    //theRegion.center= BaidumapView.userLocation.location.coordinate;
    //缩放的精度。数值越小约精准
    theRegion.span.longitudeDelta =0.005;
    theRegion.span.latitudeDelta =0.005;
    //让MapView显示缩放后的地图。
    [BaidumapView setRegion:theRegion animated:YES];
    locationManager = [[CLLocationManager alloc] init];
    //获取授权认证
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {

    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
        
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkinResult:) name:@"checkinResult" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAction) name:@"location" object:nil];

    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //启动LocationService
    [_locService startUserLocationService];
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = @"海淀区上地10街10号";

}
-(void)checkinResult:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
    NSNotification *noti = sender;
    NSString *result = noti.object;
    if([result isEqualToString:@"成功"])
    {
        [MBProgressHUD showSuccess:@"签报成功" toView:self.view];
        
    }
    else
    {
        [MBProgressHUD showError:@"签报失败" toView:self.view];
    }
}

-(void)getCurrentTime:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
    NSDictionary *dic = [sender object];
    NSString *timeStr = [dic objectForKey:@"Data"];
    dateStr = timeStr;
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      NSLog(@"reverse = %@",result.address);
      address = result.address;
      self.nameLabel2.text = result.address;
      self.nameLabel2.backgroundColor = [UIColor whiteColor];
      self.nameLabel2.font = [UIFont systemFontOfSize:12];
      self.nameLabel2.textAlignment = NSTextAlignmentCenter;
      self.nameLabel2.textColor = [UIColor blueColor];
      [self.view addSubview:self.nameLabel2];
      
      
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    BaidumapView.showsUserLocation = YES;//显示定位图层
    [BaidumapView updateLocationData:userLocation];
    BaidumapView.centerCoordinate = userLocation.location.coordinate;

    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = BaidumapView.centerCoordinate;
    BOOL flag2 = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag2)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 2.0;
        
        return circleView;
    }
    return nil;
}
-(void)locationAction{
    [[SignInHttp getInstance]getSignInAddress];
    [[SignInHttp getInstance]GetSignInGroupByUnitID];
    
    
}
#pragma -mark 通知返回数据方法
-(void)getSignInAddress:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
    NSArray *arr = [sender object];
    if(arr.count >0)
    {
        [BaidumapView removeOverlay:self.circle];
        self.circle = nil;
        NSDictionary *dic = [[sender object]objectAtIndex:0];
        
        self.Longitude = (CLLocationDegrees)[[dic objectForKey:@"Longitude"] doubleValue];
        self.Latitude = (CLLocationDegrees)[[dic objectForKey:@"Latitude"] doubleValue];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = self.Latitude;
        coor.longitude = self.Longitude;
        annotation.coordinate = coor;
        annotation.title = [dic objectForKey:@"AddressName"];
        [BaidumapView addAnnotation:annotation];

        self.location = [[CLLocation alloc]initWithLatitude:self.Latitude longitude:self.Longitude];
        self.range = [[dic objectForKey:@"Range"]integerValue];
        
        self.circle = [BMKCircle circleWithCenterCoordinate:self.location.coordinate radius:[[dic objectForKey:@"Range"] doubleValue]];
        
        [BaidumapView addOverlay:self.circle];
        
    }

    
    
}
-(void)GetSignInGroupByUnitID:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
    self.groupArr = [sender object];
    
    
    
    
}
#pragma  mark - 底部按钮方法
- (IBAction)checkInAction:(id)sender {
    [MobClick event:@"CheckingInView_checkInAction" label:@""];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:BaidumapView.centerCoordinate.latitude longitude:BaidumapView.centerCoordinate.longitude];
    CLLocationDistance distance = [self.location distanceFromLocation:location2];
    if(distance>self.range)
    {
        [MBProgressHUD showError:@"超出签到范围" toView:self.view];
        flag = NO;
        
    }
    else
    {
    
        dm *dmInstance = [dm getInstance];
        NSString *SignInTypeID = [[self.groupArr objectAtIndex:self.selectedRow]objectForKey:@"GroupID"];

    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = [dateArr objectAtIndex:0];
    NSString *month = [dateArr objectAtIndex:1];
    NSString *dayStr = [dateArr objectAtIndex:2];
    NSArray *dayArr = [dayStr componentsSeparatedByString:@" "];
    NSString *day = [dayArr objectAtIndex:0];
    
    NSString *SignInTypeName = [self.FirstBtn titleForState:UIControlStateNormal];
        NSString *SignInGroupName = [self.secondBtn titleForState:UIControlStateNormal];
    NSString *longitude = [NSString stringWithFormat:@"%f",BaidumapView.centerCoordinate.longitude];
    NSString *Latitude = [NSString stringWithFormat:@"%f",BaidumapView.centerCoordinate.latitude];
        @try {
            NSArray *value= [NSArray arrayWithObjects:dateStr,longitude,Latitude,address,dmInstance.userInfo.UserID,dmInstance.userInfo.UserName,dmInstance.userInfo.UserType,dmInstance.userInfo.UnitID,dmInstance.mStr_unit, @"1.00.5",@"8295",SignInTypeID,self.SignInGroupID,year,month,day,@"0",SignInTypeName,SignInGroupName,@"0",@"", nil];
            NSArray *key = [NSArray arrayWithObjects:@"SignInDateTime",@"Longitude",@"Latitude",@"Place",@"UserID",@"UserName",@"UserTypeID",@"UnitID",@"UnitName",@"MobileEdition",@"MobileModel",@"SignInTypeID",@"SignInGroupID",@"Year",@"Month",@"day",@"HandleFlag",@"SignInTypeName",@"SignInGroupName",@"SignInFlag",@"Remark", nil];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:value forKeys:key];
            [[SignInHttp getInstance]CreateSignIn:dic];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
        @catch (NSException *exception) {
            [MBProgressHUD showError:@"数据异常" toView:self.view];

        }
        @finally {
            
        }

    }

    
}
- (IBAction)recordAction:(id)sender {
    [MobClick event:@"CheckingInView_recordAction" label:@""];
    RecordViewController *record = [[RecordViewController alloc]init];
    [utils pushViewController:record animated:YES];
    
}
#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
if(component == 0)
{
    return self.groupArr.count;
}
    if(component == 1)
    {
        NSDictionary *dic = [self.groupArr objectAtIndex:self.selectedRow];
        NSArray *GroupItems = [dic objectForKey:@"GroupItems"];
        return GroupItems.count;

    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle;
    if(component == 0)
    {
        NSDictionary *dic = [self.groupArr objectAtIndex:row];
        NSString *GroupTypeName = [dic objectForKey:@"GroupTypeName"];
        return GroupTypeName;
        
    }
    if(component == 1)
    {
        NSDictionary *dic = [self.groupArr objectAtIndex:self.selectedRow];
        NSArray *GroupItems = [dic objectForKey:@"GroupItems"];
        NSString *itemStr = [[GroupItems objectAtIndex:row]objectForKey:@"GroupName"];
        self.SignInGroupID = [[GroupItems objectAtIndex:row]objectForKey:@"TabID"];
        return itemStr;
        
    }
    return rowTitle;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        NSString *str = [[self.groupArr objectAtIndex:row]objectForKey:@"GroupTypeName"];
//        NSString *GroupIDstr = [[self.groupArr objectAtIndex:row]objectForKey:@"GroupID"];
        NSArray *arr = [[self.groupArr objectAtIndex:row]objectForKey:@"GroupItems"];
        NSDictionary *dic = [arr objectAtIndex:0];
        self.SignInGroupID = [dic objectForKey:@"TabID"];
        self.selectedRow = row;
        [self.pickView reloadComponent:1];
        [self.FirstBtn setTitle:str forState:UIControlStateNormal];
        [self.secondBtn setTitle:[dic objectForKey:@"GroupName"] forState:UIControlStateNormal];
    }
    if(component == 1)
    {
        NSDictionary *dic = [self.groupArr objectAtIndex:self.selectedRow];
        NSArray *GroupItems = [dic objectForKey:@"GroupItems"];
        NSString *title = [[GroupItems objectAtIndex:row]objectForKey:@"GroupName"];
        NSString *itemStr = [[GroupItems objectAtIndex:row]objectForKey:@"TabID"];
        [self.secondBtn setTitle:title forState:UIControlStateNormal];
        self.SignInGroupID = itemStr;

    }

}

#pragma mark - 点击考勤类型方法
- (IBAction)groupTypeAction:(id)sender {

    [self.field becomeFirstResponder];
    
    
}
#pragma mark - ToolBar
- (IBAction)cancelAction:(id)sender {
    [self.view endEditing:YES];
    
}

- (IBAction)doneAction:(id)sender {

    
    
    [self.view endEditing:YES];
}
#pragma mark - navigationBarItemAction
-(void)navigationRightAction:(UIButton *)sender
{
    if(self.mView_all.hidden)
    {
        self.mView_all.hidden = NO;
        self.mTableV_left.hidden = NO;
        self.mTableV_right.hidden = NO;
        
    }
    else{
        self.mView_all.hidden = YES;
        self.mTableV_left.hidden = YES;
        self.mTableV_right.hidden = YES;
        
    }
    [dm getInstance].tableSymbol = YES;

    [self.mTableV_left reloadData];
    [self.mTableV_right reloadData];
    

    
    
    
}
-(void)myNavigationGoback{
    BaidumapView = nil;
    _locService = nil;
    _searcher = nil;
    BaidumapView.delegate =nil;
    _locService.delegate = nil;
    _searcher.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [utils popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
