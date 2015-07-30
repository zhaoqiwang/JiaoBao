//
//  PhotoCollectionCell.h
//  MobileDoctor
//
//  Created by SYM on 14-4-30.
//  Copyright (c) 2014年 SYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionCell : UICollectionViewCell<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *imgLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property(assign,nonatomic)BOOL gestureBool;
- (IBAction)deleteAction:(id)sender;

@end
