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
#import "utils.h"

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

    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < [self.model.answerModel.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [self.model.answerModel.Thumbnail objectAtIndex:i]];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
    
}


//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-70-40)/3, ([dm getInstance].width-70-40)/3);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 30);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [utils popViewControllerAnimated:YES];
}



@end