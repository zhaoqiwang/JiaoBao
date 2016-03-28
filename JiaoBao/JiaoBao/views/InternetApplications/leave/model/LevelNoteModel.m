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
    if(![Astr isEqualToString:@""]||![Astr isEqual:[NSNull null]]){
        self.A = Astr;
        if([self.A isEqualToString:@"False"])
        {
            self.A = nil;
        }
    }else{
        self.A = @"一审";
    }
    NSString *Bstr = [dic objectForKey:@"B"];
    if(![Bstr isEqualToString:@""]||![Bstr isEqual:[NSNull null]]){
        self.B = Bstr;
        if([self.B isEqualToString:@"False"])
        {
            self.B = nil;
        }
    }else{
        self.B = @"二审";
    }
    NSString *Cstr = [dic objectForKey:@"C"];
    if(![Cstr isEqualToString:@""]||![Cstr isEqual:[NSNull null]]){
        self.C = Cstr;
        if([self.C isEqualToString:@"False"])
        {
            self.C = nil;
        }
    }else{
        self.C = @"三审";
    }
    NSString *Dstr = [dic objectForKey:@"D"];
    if(![Dstr isEqualToString:@""]||![Dstr isEqual:[NSNull null]]){
        self.D = Dstr;
        if([self.D isEqualToString:@"False"])
        {
            self.D = nil;
        }
    }else{
        self.D = @"四审";
    }
    NSString *Estr = [dic objectForKey:@"E"];
    if(![Estr isEqualToString:@""]||![Estr isEqual:[NSNull null]]){
        self.E = Estr;
        if([self.E isEqualToString:@"False"])
        {
            self.E = nil;
        }
    }else{
        self.E = @"五审";
    }

//    self.A = [dic objectForKey:@"A"];
//    self.B = [dic objectForKey:@"B"];
//    self.C = [dic objectForKey:@"C"];
//    self.D = [dic objectForKey:@"D"];
//    self.E = [dic objectForKey:@"E"];
}

@end
