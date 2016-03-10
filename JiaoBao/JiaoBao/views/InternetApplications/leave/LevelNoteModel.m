//
//  LevelNoteModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LevelNoteModel.h"

@implementation LevelNoteModel
-(void)dicToModel:(NSDictionary*)dic{
    NSString *Astr = [dic objectForKey:@"A"];
    if(![Astr isEqualToString:@""]||![Astr isEqual:[NSNull null]]){
        self.A = Astr;
    }else{
        self.A = @"一审";
    }
    NSString *Bstr = [dic objectForKey:@"B"];
    if(![Bstr isEqualToString:@""]||![Bstr isEqual:[NSNull null]]){
        self.B = Bstr;
    }else{
        self.B = @"二审";
    }
    NSString *Cstr = [dic objectForKey:@"C"];
    if(![Cstr isEqualToString:@""]||![Cstr isEqual:[NSNull null]]){
        self.C = Cstr;
    }else{
        self.C = @"三审";
    }
    NSString *Dstr = [dic objectForKey:@"D"];
    if(![Dstr isEqualToString:@""]||![Dstr isEqual:[NSNull null]]){
        self.D = Dstr;
    }else{
        self.D = @"四审";
    }
    NSString *Estr = [dic objectForKey:@"E"];
    if(![Estr isEqualToString:@""]||![Estr isEqual:[NSNull null]]){
        self.E = Estr;
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
