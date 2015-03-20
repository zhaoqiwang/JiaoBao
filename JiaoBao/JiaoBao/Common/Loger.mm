//
//  Loger.m
//  iUM
//
//  Created by yyyy on 11-9-28.
//  Copyright 2011年 yy. All rights reserved.
//

#import "Loger.h"

static NSMutableArray* logs = nil;
static int level = 0;  //输出的级别
static int maxLine = 500; //1000行最多缓存
static int number = 1; //记录编号

static NSMutableArray* oldList1 = nil, *oldList2 = nil;
static NetInfo* selni = nil;

@implementation logNode
@synthesize time, log;
-(NSString*)timeNow
{
	NSDate *nowDate = [NSDate new];
	NSDateFormatter *formatter	=  [[NSDateFormatter alloc] init];
	[formatter	setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	NSString *_time = [formatter stringFromDate:nowDate];
    [formatter release];
    [nowDate release];
	return _time;
}
-(id) initWithLog:(NSString*)_log
{
    self = [super init];
    if (self) {
        self.time = [self timeNow];
        self.log = _log;
    }
    return self;
}
-(void) dealloc
{
    self.log = nil;
    [super dealloc];
}
@end



@implementation Loger

// log's level is 1
+(void) log:(id) formatstring,...
{
    if (level>1) {
        return;
    }
    if (logs==nil) {
        logs = [[NSMutableArray alloc]init];
    }
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
    
    NSLog(@"%@", outstring);
    [logs addObject:[[[logNode alloc]initWithLog:outstring] autorelease]];
    number++;
    if ([logs count] > maxLine) {
        [logs removeObjectAtIndex:0];
    }
}

// warning's level is 2
+(void) warning:(id) formatstring,...
{
    if (level>2) {
        return;
    }
    if (logs==nil) {
        logs = [[NSMutableArray alloc]init];
    }
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
    
    NSLog(@"**%@", outstring);
    [logs addObject:[[[logNode alloc]initWithLog:[NSString stringWithFormat:@"**%@", outstring]] autorelease] ];
    number++;
    if ([logs count] > maxLine) {
        [logs removeObjectAtIndex:0];
    }
}

// err's level is 3
+(void) err:(id) formatstring,...
{
    if (level>3) {
        return;
    }
    if (logs==nil) {
        logs = [[NSMutableArray alloc]init];
    }
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
    
    NSLog(@"##%@", outstring);
    [logs addObject:[[[logNode alloc]initWithLog:[NSString stringWithFormat:@"##%@", outstring]] autorelease]];
    number++;
    if ([logs count] > maxLine) {
        [logs removeObjectAtIndex:0];
    }
}

// net connect status
+(void) net:(id) formatstring,...
{
    if (level>4) {
        return;
    }
    if (logs==nil) {
        logs = [[NSMutableArray alloc]init];
    }
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
    
    NSLog(@"$$net:%@", outstring);
    [logs addObject:[[[logNode alloc]initWithLog:[NSString stringWithFormat:@"$$net:%@", outstring]] autorelease]];
    number++;
    if ([logs count] > maxLine) {
        [logs removeObjectAtIndex:0];
    }
}

+(void) clearLog
{
    if (logs==nil) {
        logs = [[NSMutableArray alloc]init];
    }
    else {
        [logs removeAllObjects];
    }
    
    if (oldList1 != nil) {
        [oldList1 removeAllObjects];
    }
    
    if(oldList2!=nil) {
        [oldList2 removeAllObjects];
    }
    
    selni = nil;
}

// level 
// 1:  log, warning and err 
// 2:  warning and err
// 3:  err
// 4:  nothing
+(void) setLevel:(int) l
{
    level = l;
}

+(int)  getLevel
{
    return level;
}

// maxLinetoCache
+(void) setBufferSize:(int) lines
{
    maxLine = lines;
}

+(int) getBufferSize
{
    return maxLine;
}


// get string of all logs
+(NSString*) getLogString
{
    NSMutableString* str = [[[NSMutableString alloc]init] autorelease];
    int i = number-[logs count];
    for (logNode* l in logs) {
        [str appendFormat:@"[%d][%@]<br>\n%@<br>\n---------------------------<br>\n", i++, l.time, l.log];
    }
    return str;
}

@end
