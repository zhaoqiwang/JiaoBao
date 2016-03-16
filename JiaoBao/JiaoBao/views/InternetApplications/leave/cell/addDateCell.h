//
//  addDateCell.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addDateCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIButton *mBtn_delete;//删除
@property (nonatomic,strong) IBOutlet UILabel *mLab_start;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_end;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_startNow;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_endNow;//
- (IBAction)deleteCellAction:(id)sender;

@end
