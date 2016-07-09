//
//  LeaveDetailTableViewCell.h
//  JiaoBao
//  请假详情cell
//  Created by Zqw on 16/3/21.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaveDetailTableViewCellDelegate;

@interface LeaveDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *mLab_leave;//请假人，所有左侧name
@property (nonatomic,strong) IBOutlet UILabel *mLab_leaveValue;;//请假人姓名，所有右侧真是value
@property (nonatomic,strong) IBOutlet UILabel *mLab_go;//离开时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_goValue;;//离开时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_door;//值班门卫
@property (nonatomic,strong) IBOutlet UILabel *mLab_doorValue;;//值班门卫
@property (nonatomic,strong) IBOutlet UILabel *mLab_endTime;//结束时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_endTimeValue;//结束时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_comeTime;//回校时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_comeTimeValue;//回校时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_door2;//回校门卫
@property (nonatomic,strong) IBOutlet UILabel *mLab_door2Value;//回校门卫
@property (nonatomic,strong) IBOutlet UIButton *mBtn_check;//审核
@property (nonatomic,strong) IBOutlet UIButton *mBtn_delete;//撤回
@property (nonatomic,strong) IBOutlet UIButton *mBtn_update;//修改
@property (nonatomic,strong) IBOutlet UIButton *mBtn_checkDoor;//门卫离校签字
@property (nonatomic,strong) IBOutlet UIButton *mBtn_checkDoor2;//门卫回校签字
@property (weak,nonatomic) id<LeaveDetailTableViewCellDelegate> delegate;

-(IBAction)mBtn_check:(id)sender;
-(IBAction)mBtn_delete:(id)sender;
-(IBAction)mBtn_update:(id)sender;
-(IBAction)mBtn_checkDoor:(id)sender;
-(IBAction)mBtn_checkDoor2:(id)sender;

@end

@protocol LeaveDetailTableViewCellDelegate <NSObject>

@optional

//回调
-(void) LeaveDetailTableViewCellCheckBtn:(LeaveDetailTableViewCell *) cell;
-(void) LeaveDetailTableViewCellDeleteBtn:(LeaveDetailTableViewCell *) cell;
-(void) LeaveDetailTableViewCellUpdateBtn:(LeaveDetailTableViewCell *) cell;
-(void) LeaveDetailTableViewCellCheckDoorBtn:(LeaveDetailTableViewCell *) cell;
-(void) LeaveDetailTableViewCellCheckDoor2Btn:(LeaveDetailTableViewCell *) cell;

@end