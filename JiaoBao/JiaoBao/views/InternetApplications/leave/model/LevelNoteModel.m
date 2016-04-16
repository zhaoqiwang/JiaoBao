//
//  LevelNoteModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LevelNoteModel.h"
#import "SBJSON.h"
#import "JSONKit.h"



@implementation LevelNoteModel
-(void)dicToModel:(NSString*)dicStr{
    NSDictionary *dic = [dicStr objectFromJSONString];

    NSString *Astr = [dic objectForKey:@"A"];
    if([Astr isEqualToString:@""]||[Astr isEqual:[NSNull null]]){
        self.A = @"一审";

    }else{
        self.A = Astr;
        if([self.A isEqualToString:@"False"])
        {
            self.A = nil;
        }
    }
    NSString *Bstr = [dic objectForKey:@"B"];
    if([Bstr isEqualToString:@""]||[Bstr isEqual:[NSNull null]]){
        self.B = @"二审";

    }else{
        self.B = Bstr;
        if([self.B isEqualToString:@"False"])
        {
            self.B = nil;
        }
    }
    NSString *Cstr = [dic objectForKey:@"C"];
    if([Cstr isEqualToString:@""]||[Cstr isEqual:[NSNull null]]){
        self.C = @"三审";

    }else{
        self.C = Cstr;
        if([self.C isEqualToString:@"False"])
        {
            self.C = nil;
        }
    }
    NSString *Dstr = [dic objectForKey:@"D"];
    if([Dstr isEqualToString:@""]||[Dstr isEqual:[NSNull null]]){
        self.D = @"四审";

    }else{
        self.D = Dstr;
        if([self.D isEqualToString:@"False"])
        {
            self.D = nil;
        }
    }
    NSString *Estr = [dic objectForKey:@"E"];
    if([Estr isEqualToString:@""]||[Estr isEqual:[NSNull null]]){
        self.E = @"五审";

    }else{
        self.E = Estr;
        if([self.E isEqualToString:@"False"])
        {
            self.E = nil;
        }

//    self.A = [dic objectForKey:@"A"];
//    self.B = [dic objectForKey:@"B"];
//    self.C = [dic objectForKey:@"C"];
//    self.D = [dic objectForKey:@"D"];
//    self.E = [dic objectForKey:@"E"];
}
}

@end
