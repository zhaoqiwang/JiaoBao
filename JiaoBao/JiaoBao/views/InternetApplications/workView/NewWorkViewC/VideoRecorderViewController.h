//
//  VideoRecorderViewController.h
//  JiaoBao
//
//  Created by Zqw on 15/7/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessoryModel.h"

@class VideoRecorderViewControllerProtocol;

@protocol VideoRecorderViewControllerProtocol <NSObject>

-(void)VideoRecorderSelectFile:(AccessoryModel *)model;

@end

@interface VideoRecorderViewController : UIViewController

@property (weak,nonatomic) id <VideoRecorderViewControllerProtocol > delegate;

@end
