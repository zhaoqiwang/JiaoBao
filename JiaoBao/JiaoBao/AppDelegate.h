//
//  AppDelegate.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RootViewController.h"
#import "InternetApplicationsViewController.h"
#import "RegisterViewController.h"
#import "dm.h"
#import "Loger.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <UMAnalytics/MobClick.h>
#import<CoreData/CoreData.h>
#import "NSString+Extension.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
//    RootViewController *mRoot_view;
    InternetApplicationsViewController *mInternet;
    RegisterViewController *mRegister_view;
    int mInt_index;//当往数组中添加数据时，记录当前的readflag
    Reachability *internetReachable;

}

//@property (nonatomic,strong) RootViewController *mRoot_view;
@property (nonatomic,strong) InternetApplicationsViewController *mInternet;
@property (nonatomic,strong) RegisterViewController *mRegister_view;
@property (nonatomic,assign) int mInt_index;//当往数组中添加数据时，记录当前的readflag

@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

