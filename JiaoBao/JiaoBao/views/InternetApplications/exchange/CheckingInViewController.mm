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




@interface CheckingInViewController ()
{

    CLLocationManager  *locationManager;
    BOOL flag;
    //BMKMapManager* _mapManager;
    BMKMapView* BaidumapView;
    //__weak IBOutlet BMKMapView *BaidumapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    NSString *address;
    NSString *dateStr;


}

@property (strong, nonatomic) IBOutlet UIPickerView *pickView;//点击考勤模式弹出的pickView
@property (nonatomic, weak) IBOutlet MKMapView *mapView;//
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKPlacemark *placemark;
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

- (IBAction)checkInAction:(id)sender;//点击签到按钮方法

- (IBAction)recordAction:(id)sender;//点击纪录按钮方法
- (IBAction)groupTypeAction:(id)sender;//点击考勤模式方法


- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;




@end

@implementation CheckingInViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.mapView.showsUserLocation = YES;
    [_locService startUserLocationService];

    BaidumapView.showsUserLocation = NO;
    BaidumapView.showsUserLocation = YES;

    BaidumapView.delegate = self;
    _locService.delegate = self;
    // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.mapView.showsUserLocation = NO;
    [_locService stopUserLocationService];

    _locService.delegate = nil;


    BaidumapView.showsUserLocation = NO;
    BaidumapView.delegate = nil; // 不用时，置nil

    
    
}
-(void)getUnitName:(id)sender
{
    NSLog(@"title = %@",[dm getInstance].mStr_unit);
    [self.mNav_navgationBar leftBtnAction:[dm getInstance].mStr_unit];
    [[SignInHttp getInstance]getTime];

    [[SignInHttp getInstance]getSignInAddress];
    [[SignInHttp getInstance]GetSignInGroupByUnitID];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnitName:) name:@"unitNameNotication" object:nil];
    [[SignInHttp getInstance]getTime];

//    _mapManager = [[BMKMapManager alloc]init];
//    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//    BOOL ret = [_mapManager start:@"iqYoKFAodVcfY8oRpi0KtuHs"  generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
    BaidumapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64+30, 320, 568-94)];
    [self.view addSubview:BaidumapView];
    [self.view addSubview:bottomView];
    [bottomView setFrame:CGRectMake(0, self.view.frame.size.height-90, 320, 90)];
    
    BaidumapView.delegate = self;
    BaidumapView.zoomLevel = 1000;
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    //displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [BaidumapView updateLocationViewWithParam:displayParam];
    [self.view addSubview:self.mView_all];

    flag = YES;
    self.SignInGroupID = @"5150001";
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(-100, -100, -100, -100)];
    [self.view addSubview:self.field];
    self.field.inputAccessoryView = self.toolBar;
    self.field.inputView = self.pickView;
    self.selectedRow = 0;
    [[SignInHttp getInstance]getSignInAddress];
    [[SignInHttp getInstance]GetSignInGroupByUnitID];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSignInAddress:) name:@"getSignInAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSignInGroupByUnitID:) name:@"GetSignInGroupByUnitID" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrentTime:) name:@"GetTime" object:nil];

    
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@""];
    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"appNav_contact"]];
//    NSLog(@"unit = %@",[dm getInstance].mStr_unit);
//    [self.mNav_navgationBar setBackBtnTitle:[dm getInstance].mStr_unit];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar leftBtnAction:[dm getInstance].mStr_unit];
    [self.view addSubview:self.mNav_navgationBar];
    MKCoordinateRegion theRegion = { {0.0,0.0 }, {0.0,0.0 } };
    theRegion.center= self.mapView.userLocation.location.coordinate;
    //缩放的精度。数值越小约精准
    theRegion.span.longitudeDelta =0.001;
    theRegion.span.latitudeDelta =0.001;
    //让MapView显示缩放后的地图。
    [self.mapView setRegion:theRegion animated:YES];
    locationManager = [[CLLocationManager alloc] init];
    //获取授权认证
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {

    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
        
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
//    MKCoordinateRegion region;
//    //region.span = MKCoordinateSpanMake(2, 1);
//    region.span.longitudeDelta =0.005;
//    region.span.latitudeDelta =0.0025;
//    region.center = CLLocationCoordinate2DMake(36.681449, 117.021468);
//    [self.mapView setRegion:region animated:YES];

    self.geocoder = [[CLGeocoder alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAction) name:@"location" object:nil];
    // 添加圆形覆盖物
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    BMKCircle* circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
//    
//    [_mapView addOverlay:circle];
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
//    BOOL flag2 = [_searcher geoCode:geoCodeSearchOption];
//    if(flag2)
//    {
//        NSLog(@"geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"geo检索发送失败");
//    }






    // Do any additional setup after loading the view from its nib.
}
-(void)getCurrentTime:(id)sender
{
    NSDictionary *dic = [sender object];
    [utils logDic:dic];
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
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = userLocation.location.coordinate.latitude;
//    coor.longitude = userLocation.location.coordinate.longitude;
//    annotation.coordinate = coor;
//    annotation.title = @"这里是北京";
//    [BaidumapView addAnnotation:annotation];
    BaidumapView.showsUserLocation = YES;//显示定位图层
    [BaidumapView updateLocationData:userLocation];
    BaidumapView.centerCoordinate = userLocation.location.coordinate;
   // NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ 36.681449,117.021468};
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
 
    NSArray *arr = [sender object];
    if(arr.count >0)
    {
        [BaidumapView removeOverlay:self.circle];
        self.circle = nil;
        NSDictionary *dic = [[sender object]objectAtIndex:0];
        self.Longitude = (CLLocationDegrees)[[dic objectForKey:@"Longitude"] doubleValue];
        self.Latitude = (CLLocationDegrees)[[dic objectForKey:@"Latitude"] doubleValue];
        NSLog(@"Longitude = %f %f",self.Longitude,self.Latitude);
        
        
        
        self.location = [[CLLocation alloc]initWithLatitude:self.Latitude longitude:self.Longitude];
        
        self.circle = [BMKCircle circleWithCenterCoordinate:self.location.coordinate radius:[[dic objectForKey:@"Range"] doubleValue]];
        
        [BaidumapView addOverlay:self.circle];
        
    }

//    MKCoordinateRegion region;
//    //region.span = MKCoordinateSpanMake(2, 1);
//    region.span.longitudeDelta =0.006;
//    region.span.latitudeDelta =0.003;
//    region.center = CLLocationCoordinate2DMake(36.681449, 117.021468);
//    [self.mapView setRegion:region animated:YES];
//    MKCircle *circleTargePlace=[MKCircle circleWithCenterCoordinate:self.location.coordinate radius:100];
//    [self.mapView addOverlay:circleTargePlace];
    //[self.mapView setCenterCoordinate:location.coordinate animated:NO];
    
    
}
-(void)GetSignInGroupByUnitID:(id)sender
{
    self.groupArr = [sender object];
    
    
    
    
}
#pragma  mark - 底部按钮方法
- (IBAction)checkInAction:(id)sender {
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:BaidumapView.centerCoordinate.latitude longitude:BaidumapView.centerCoordinate.longitude];
    CLLocationDistance distance = [self.location distanceFromLocation:location2];
    if(distance>100)
    {
        [SVProgressHUD showErrorWithStatus:@"超出签到范围"];
        flag = NO;
        
    }
    
        NSString *time = [utils getLocalTime];
        dm *dmInstance = [dm getInstance];
        NSString *SignInTypeID = [[self.groupArr objectAtIndex:self.selectedRow]objectForKey:@"GroupID"];
//        NSArray *SignInGroupIDArr =  [[self.groupArr objectAtIndex:self.selectedRow]objectForKey:@"GroupItems"];
//    _SignInGroupID = [[SignInGroupIDArr objectAtIndex:0]objectForKey:@"SignInGroupID"];
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
    NSString *flagStr  = [NSString stringWithFormat:@"%d",flag];
    NSLog(@"SignInTypeID = %@",self.SignInGroupID);
        NSArray *value= [NSArray arrayWithObjects:dateStr,longitude,Latitude,address,dmInstance.userInfo.UserID,dmInstance.userInfo.UserName,dmInstance.userInfo.UserType,dmInstance.userInfo.UnitID,dmInstance.mStr_unit, @"1.00.5",@"8295",SignInTypeID,self.SignInGroupID,year,month,day,@"0",SignInTypeName,SignInGroupName,@"0",@"", nil];
    [utils logArr:value];
        NSArray *key = [NSArray arrayWithObjects:@"SignInDateTime",@"Longitude",@"Latitude",@"Place",@"UserID",@"UserName",@"UserTypeID",@"UnitID",@"UnitName",@"MobileEdition",@"MobileModel",@"SignInTypeID",@"SignInGroupID",@"Year",@"Month",@"day",@"HandleFlag",@"SignInTypeName",@"SignInGroupName",@"SignInFlag",@"Remark", nil];
    
    
    
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:value forKeys:key];
        [[SignInHttp getInstance]CreateSignIn:dic];
        
        
    
    
    
}
- (IBAction)recordAction:(id)sender {
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
        NSLog(@"SignInTypeID = %@",self.SignInGroupID);


        
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
        NSLog(@"SignInTypeID = %@",self.SignInGroupID);

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

    [self.mTableV_left reloadData];
    [self.mTableV_right reloadData];
    

    
    
    
}
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
//{
//    int TenLat=0;
//    int TenLog=0;
//    TenLat = (int)(yGps.latitude*10);
//    TenLog = (int)(yGps.longitude*10);
//    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
//    NSLog(sql);
//    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
//    int offLat=0;
//    int offLog=0;
//    while (sqlite3_step(stmtL)==SQLITE_ROW)
//    {
//        offLat = sqlite3_column_int(stmtL, 0);
//        offLog = sqlite3_column_int(stmtL, 1);
//        
//    }
//    
//    yGps.latitude = yGps.latitude+offLat*0.0001;
//    yGps.longitude = yGps.longitude + offLog*0.0001;
//    return yGps;
//    
//    
//}


//#pragma - mark 画圆
//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
//{
//    if ([overlay isKindOfClass:[MKCircle class]]) {
//        MKCircleView *_circleView=[[MKCircleView alloc] initWithCircle:overlay];
//        //_circleView.fillColor =  [UIColor redColor];
//        _circleView.strokeColor = [UIColor redColor];
//        _circleView.lineWidth=2.0;
//        return _circleView;
//    }
//    return nil;
//}
#pragma - mark MapView代理方法
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    
//    [self.mapView setCenterCoordinate:userLocation.coordinate animated:NO];
//    NSLog(@"====%f %f",userLocation.coordinate.longitude,userLocation.coordinate.latitude);
//    //    [self.geocoder geocodeAddressString:@"中国山东省济南天桥区铜元局前街金冠商务中心" completionHandler:^(NSArray *placemarks, NSError *error) {
//    //        [utils logArr:placemarks];
//    //    }];
//    
//    //    CLLocation *location = [[CLLocation alloc]initWithLatitude:36.681449 longitude:117.021468];
//    //    CLLocationCoordinate2D coord;
//    //    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
//    //        //转换后的coord
//    //        coord= [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
//    //    }
//    //    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
//    
//    //    CLLocationCoordinate2D Coordinate = [self zzTransGPS:userLocation.location.coordinate];///火星GPS
//    //    CLLocation *location = [[CLLocation alloc]initWithLatitude:Coordinate.latitude longitude:Coordinate.longitude];
//    //    NSLog(@"location = %@",location);
//    // Lookup the information for the current location of the user.
//    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ((placemarks != nil) && (placemarks.count > 0)) {
//            
//            _placemark = [placemarks objectAtIndex:0];
//            NSLog(@"_placemark = %@",[_placemark.addressDictionary objectForKey:@"FormattedAddressLines"]);
//            [utils logDic:_placemark.addressDictionary];
//            
//            
//            
//        }
//        else {
//            // Handle the nil case if necessary.
//        }
//    }];
//}












@end
