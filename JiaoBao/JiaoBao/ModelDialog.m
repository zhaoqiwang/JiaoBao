//
//  ModelDialog.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ModelDialog.h"

@implementation ModelDialog


- (IBAction)cancelAction:(id)sender {
    [self _doClickCloseDialog];
}

- (IBAction)doneAction:(id)sender {
    [[self.window viewWithTag:9999]removeFromSuperview];

}
-(void) _doClickCloseDialog  {
    [[self.window viewWithTag:9999]removeFromSuperview];
}
@end
