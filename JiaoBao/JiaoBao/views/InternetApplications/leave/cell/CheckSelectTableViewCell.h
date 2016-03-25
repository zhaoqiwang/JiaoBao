//
//  CheckSelectTableViewCell.h
//  JiaoBao
//  审核筛选自定义cell
//  Created by Zqw on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckSelectTableViewCellDelegate;

@interface CheckSelectTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_value;//
@property (nonatomic,strong) IBOutlet UIButton *mBtn_teacher;//教职工
@property (nonatomic,strong) IBOutlet UIButton *mBtn_student;//学生
@property (nonatomic,strong) IBOutlet UIButton *mBtn_one;//一审
@property (nonatomic,strong) IBOutlet UIButton *mBtn_two;//二审
@property (nonatomic,strong) IBOutlet UIButton *mBtn_three;//三审
@property (nonatomic,strong) IBOutlet UIButton *mBtn_four;//四审
@property (nonatomic,strong) IBOutlet UIButton *mBtn_five;//五审
@property (weak,nonatomic) id<CheckSelectTableViewCellDelegate> delegate;

-(IBAction)mBtn_teacher:(id)sender;
-(IBAction)mBtn_student:(id)sender;
-(IBAction)mBtn_one:(id)sender;
-(IBAction)mBtn_two:(id)sender;
-(IBAction)mBtn_three:(id)sender;
-(IBAction)mBtn_four:(id)sender;
-(IBAction)mBtn_five:(id)sender;

@end

@protocol CheckSelectTableViewCellDelegate <NSObject>

@optional

//
-(void) CheckSelectTableViewCellTeacherBtn:(CheckSelectTableViewCell *) cell;
-(void) CheckSelectTableViewCellStudentBtn:(CheckSelectTableViewCell *) cell;
-(void) CheckSelectTableViewCellOneBtn:(CheckSelectTableViewCell *) cell;
-(void) CheckSelectTableViewCellTwoBtn:(CheckSelectTableViewCell *) cell;
-(void) CheckSelectTableViewCellThreeBtn:(CheckSelectTableViewCell *) cell;
-(void) CheckSelectTableViewCellFourBtn:(CheckSelectTableViewCell *) cell;
-(void) CheckSelectTableViewCellFiveBtn:(CheckSelectTableViewCell *) cell;

@end
