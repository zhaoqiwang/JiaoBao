//
//  addDateCell.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//自定的添加日期cell

#import <UIKit/UIKit.h>

@protocol addDateCellDelegate;

@interface addDateCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIButton *mBtn_delete;//删除
@property (nonatomic,strong) IBOutlet UILabel *mLab_start;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_end;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_startNow;//显示开始日期
@property (nonatomic,strong) IBOutlet UILabel *mLab_endNow;//显示结束日期
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线
@property (weak,nonatomic) id<addDateCellDelegate> delegate;

-(IBAction)deleteBtn:(id)sender;

@end

@protocol addDateCellDelegate <NSObject>

@optional

//点击
-(void) addDateCellDeleteBtn:(addDateCell *) view;

@end