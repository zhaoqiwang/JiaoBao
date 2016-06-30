//
//  CategorySection.h
//  JiaoBao
//  话题分类section
//  Created by songyanming on 15/8/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CategorySectionDelegate;

@interface CategorySection : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) id<CategorySectionDelegate> delegate;
- (IBAction)AddBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@protocol CategorySectionDelegate <NSObject>

//点击按钮
-(void)CategorySectionClickBtnWith:(UIButton *)btn section:(CategorySection *) section;
@end