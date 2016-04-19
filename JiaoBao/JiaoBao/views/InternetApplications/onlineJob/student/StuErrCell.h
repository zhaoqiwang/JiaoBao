//
//  StuErrCell.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuErrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textview;

@property (weak, nonatomic) IBOutlet UILabel *htmlLabel;

@end

