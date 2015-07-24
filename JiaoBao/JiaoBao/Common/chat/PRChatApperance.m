//
//  PRChatApperance.m
//  DocPlatform
//
//  Created by Perry on 14-9-19.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import "PRChatApperance.h"

const CGFloat PRChatControlStartMargin = 56;
const CGFloat PRChatControlEndMargin = 23;
const CGFloat PRChatControlAnchorWidth = 9;
const CGFloat PRChatControlMinHeight = 40;

const CGFloat PRChatTextStartMargin = 22;
const CGFloat PRChatTextEndMargin = 12;
const CGFloat PRChatTextTopMargin = 12;
const CGFloat PRChatTextBottomMargin = 13;

const CGFloat PRChatImageStartMargin = 19;
const CGFloat PRChatImageEndMargin = 10;
const CGFloat PRChatImageTopMargin = 10;
const CGFloat PRChatImageBottomMargin = 10;



@implementation PRChatApperance

+ (PRChatApperance *) sharedInstance
{
    static PRChatApperance *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[PRChatApperance alloc] init];
    });
    
    return _instance;
}
@end
