//
//  CustomWorkViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/4/28.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CustomWorkViewController.h"

@interface CustomWorkViewController ()

@end

@implementation CustomWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //通知界面更新，获取事务信息接收单位列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
    //获取到每个单位中的人员
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitRevicer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitRevicer:) name:@"GetUnitRevicer" object:nil];
    // Do any additional setup after loading the view from its nib.
}

//通知界面更新，获取事务信息接收单位列表
-(void)CommMsgRevicerUnitList:(NSNotification *)noti{
    [self.mProgressV hide:YES];
        self.mModel_unitList = noti.object;
        //获取当前单位的人员数组
        if ([dm getInstance].uType ==3) {
            [[LoginSendHttp getInstance] login_GetUnitClassRevicer:self.mModel_unitList.myUnit.TabID Flag:self.mModel_unitList.myUnit.flag];
        }else{
            [[LoginSendHttp getInstance] login_GetUnitRevicer:self.mModel_unitList.myUnit.TabID Flag:self.mModel_unitList.myUnit.flag];
        }
}
-(void)GetUnitRevicer:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSDictionary *dic = noti.object;
    NSString *unitID = [dic objectForKey:@"unitID"];
    NSArray *array = [dic objectForKey:@"array"];
    //找到当前这个单位，塞入数组
    
    //当前单位
    if ([self.mModel_unitList.myUnit.TabID intValue] == [unitID intValue]) {
        self.mModel_unitList.myUnit.list = [NSMutableArray arrayWithArray:array];
        self.mModel_myUnit = self.mModel_unitList.myUnit;
    }
    //上级单位
    for (int i=0; i<self.mModel_unitList.UnitParents.count; i++) {
        myUnit *unit = [self.mModel_unitList.UnitParents objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
            self.mModel_myUnit = unit;
        }
    }
    //下级单位
    for (int i=0; i<self.mModel_unitList.subUnits.count; i++) {
        myUnit *unit = [self.mModel_unitList.subUnits objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
            self.mModel_myUnit = unit;
        }
    }
    //班级
    for (int i=0; i<self.mModel_unitList.UnitClass.count; i++) {
        myUnit *unit = [self.mModel_unitList.UnitClass objectAtIndex:i];
        if ([unit.TabID intValue] == [unitID intValue]) {
            unit.list = [NSMutableArray arrayWithArray:array];
            self.mModel_myUnit = unit;
        }
    }
//    //刷新
//    [self CollectionReloadData];
}



-(void)addUnit{

    [self setFrame];
}
-(void)setFrame
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
