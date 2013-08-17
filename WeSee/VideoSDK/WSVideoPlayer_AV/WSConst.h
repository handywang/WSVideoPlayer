//
//  WSConst.h
//  WeSee
//
//  Created by handy on 7/31/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG_MODE 1

//===XcodeColors
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

//#if TARGET_OS_IPHONE
#if 0
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_IOS
#else
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
//==========================================

//NSLog(XCODE_COLORS_ESCAPE @"fg0,255,0;"
//      XCODE_COLORS_ESCAPE @"bg0,0,0;"
//      @"INFO: Everytings goes well..."
//      XCODE_COLORS_RESET);

#if DEBUG_MODE
    #if TARGET_IPHONE_SIMULATOR || 1
        #define NSLogInfo(s, ...) NSLog(@"%@Info: <%p %@:(%d)> %@ %@",XCODE_COLORS_ESCAPE @"fg0,255,0;" XCODE_COLORS_ESCAPE @"bg0,0,0;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__], XCODE_COLORS_RESET)
        #define NSLogWarning(s, ...) NSLog(@"%@Warning: <%p %@:(%d)> %@ %@",XCODE_COLORS_ESCAPE @"fg247,250,7;" XCODE_COLORS_ESCAPE @"bg0,0,0;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__], XCODE_COLORS_RESET)
        #define NSLogError(s, ...) NSLog(@"%@Error: <%p %@:(%d)> %@ %@",XCODE_COLORS_ESCAPE @"fg255,0,0;" XCODE_COLORS_ESCAPE @"bg0,0,0;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__], XCODE_COLORS_RESET)
    #else
        #define NSLogInfo(s, ...) NSLog(@"%@Info: <%p %@:(%d)> %@ %@",XCODE_COLORS_ESCAPE @"fg0,255,0;" XCODE_COLORS_ESCAPE @"bg0,0,0;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__], XCODE_COLORS_RESET)
        #define NSLogWarning(s, ...) NSLog(@"%@Warning: <%p %@:(%d)> %@ %@",XCODE_COLORS_ESCAPE @"fg247,250,7;" XCODE_COLORS_ESCAPE @"bg0,0,0;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__], XCODE_COLORS_RESET)
        #define NSLogError(s, ...) NSLog(@"%@Error: <%p %@:(%d)> %@ %@",XCODE_COLORS_ESCAPE @"fg255,0,0;" XCODE_COLORS_ESCAPE @"bg0,0,0;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__], XCODE_COLORS_RESET)
    #endif
#else
    #define NSLogInfo(s, ...) ((void)0)
    #define NSLogError(s, ...) ((void)0)
    #define NSLogWarning(s, ...) ((void)0)
#endif
//===========================================



#define kMsgBoxWidth                            (300.0f)
#define kMsgBoxHeight                           (160.0f)

#define kToolBarHeight_Phone                    (64.0f)
#define kToolBarHeight_Pad                      (100.0f)

#define kControlBarHeight_Phone                 (64.0f)
#define kControlBarHeight_Pad                   (100.0f)

#define kPlaylistViewWidth                      (300.0f)

#define kProgressBarWidth                       (500.0f)
#define kProgressBarPaddingLeftToPlayBtn        (10.0f)
#define kProgressTimeLabelWidth                 (60.0f)

@interface WSConst : NSObject
@end
