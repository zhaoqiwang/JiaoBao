//
//  KnowledgeTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgeTableViewCell.h"
#import "dm.h"
#import "Forward_cell.h"
#import "UIImageView+WebCache.h"

@implementation KnowledgeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.mLab_ATitle = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width-65, 16)];
    self.mLab_ATitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.mLab_ATitle.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.mLab_ATitle];
    
    self.mLab_Abstracts = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width-75, 100)];
    self.mLab_Abstracts.lineBreakMode = NSLineBreakByWordWrapping;
    self.mLab_Abstracts.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.mLab_Abstracts];
    
    self.model = [[QuestionModel alloc] init];
    
    //人员列表
    self.mCollectionV_pic.frame = CGRectMake(0,0, 0, 0);
    [self.mCollectionV_pic registerClass:[Forward_cell class] forCellWithReuseIdentifier:@"Forward_cell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return self.model.answerModel.Thumbnail.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Forward_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Forward_cell" forIndexPath:indexPath];
    if (!cell) {
        
    }
    NSString *str = [self.model.answerModel.Thumbnail objectAtIndex:indexPath.row];
    cell.mLab_name.hidden = YES;
    [cell.mImgV_select sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@",str] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    cell.mImgV_select.frame = CGRectMake(0, 0, ([dm getInstance].width-70-40)/3, ([dm getInstance].width-70-40)/3);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-70-40)/3, ([dm getInstance].width-70-40)/3);
}

//cell的最小行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 5;
//}
//cell的最小列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 5;
//}

//添加标题、答案点击事件
-(void) addTapClick{
    self.mLab_title.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(knowledgeTableViewCellClickTitle:)];
    [self.mLab_title addGestureRecognizer:tap];
    
    self.mLab_ATitle.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(knowledgeTableViewCellClickATitle:)];
    [self.mLab_ATitle addGestureRecognizer:tap1];
    
    self.mLab_Abstracts.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(knowledgeTableViewCellClickATitle:)];
    [self.mLab_Abstracts addGestureRecognizer:tap2];
}

-(void)knowledgeTableViewCellClickTitle:(UIGestureRecognizer *)gest{
    [self.delegate KnowledgeTableViewCellTitleBtn:self];
}

-(void)knowledgeTableViewCellClickATitle:(UIGestureRecognizer *)gest{
    [self.delegate KnowledgeTableViewCellAnswers:self];
}

@end
