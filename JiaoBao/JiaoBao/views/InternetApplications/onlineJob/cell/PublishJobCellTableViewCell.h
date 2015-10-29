//
//  PublishJobCellTableViewCell.h
//  JiaoBao
//
//  Created by songyanming on 15/10/20.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PublishJobDelegate;
@interface PublishJobCellTableViewCell : UITableViewCell
@property(weak,nonatomic)id<PublishJobDelegate>delegate;
- (IBAction)publishBtnAction:(id)sender;

@end
@protocol PublishJobDelegate <NSObject>
-(void)PublishJob;
@end

