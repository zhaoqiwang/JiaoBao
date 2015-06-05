//
//  UnitTableViewCell.h
//  JiaoBao
//
//  Created by songyanming on 15/6/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol unitCellDelegate;



@interface UnitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (strong,nonatomic) id<unitCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)addBtnAction:(id)sender;

@end
@protocol unitCellDelegate <NSObject>

//点击按钮
-(void)ClickBtnWith:(UIButton *)btn cell:(UnitTableViewCell *) cell;

@end
