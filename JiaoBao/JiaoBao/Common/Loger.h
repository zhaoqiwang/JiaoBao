//
//  Loger.h
//  iUM
//
//  Created by yyyy on 11-9-28.
//  Copyright 2011年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UM_DEBUG  // 注释掉这行，如果使用release编译时
#define TOPLEVEL 100
/**
 * log information's Node struct
 * @time  the time when it's add
 * @log   the log context
 */
@interface logNode : NSObject {
    NSString* time;
    NSString* log;
}
@property (nonatomic, retain) NSString* time, *log;
-(id) initWithLog:(NSString*)log;
@end

/**
 * Loger using for log info and record them into File(if necesery)
 *
 *
 */
@class NetInfo;
@interface Loger : NSObject {
    
}
// log's level is 1
+(void) log:(id) formatstring,...;

// warning's level is 2
+(void) warning:(id) formatstring,...;

// err's level is 3
+(void) err:(id) formatstring,...;

// net connect status
+(void) net:(id) formatstring,...;

+(void) clearLog;

// level
// 1:  log, warning and err
// 2:  warning and err
// 3:  err
// 4:  nothing
+(void) setLevel:(int) l;
+(int)  getLevel;

// maxLinetoCache
+(void) setBufferSize:(int) lines;
+(int) getBufferSize;

// get string of all logs
+(NSString*) getLogString;

@end



#ifdef UM_DEBUG

#define D(format,...) NSLog(@format, ##__VA_ARGS__)
#define I(format,...) [Loger log:@format, ##__VA_ARGS__]
#define W(format,...) [Loger warning:@"-WARNING-\nFile: "__FILE__"\nLine: %5d:" format,__LINE__, ##__VA_ARGS__]
#define E(format,...) [Loger err:@"#ERROR#\nFile: "__FILE__"\nLine: %5d:" format,__LINE__, ##__VA_ARGS__]

#else

#define D(format,...)
#define I(format,...) [Loger log:@format, ##__VA_ARGS__]
#define W(format,...) [Loger warning:@"-WARNING-\nFile: "__FILE__"\nLine: %5d:" format,__LINE__, ##__VA_ARGS__]
#define E(format,...) [Loger err:@"#ERROR#\nFile: "__FILE__"\nLine: %5d:" format,__LINE__, ##__VA_ARGS__]

#endif
