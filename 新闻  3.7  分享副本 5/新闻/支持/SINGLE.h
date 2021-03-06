//
//  SINGLE.h
//  UI16_单例(简单实现)
//
//  Created by dllo on 16/1/13.
//  Copyright © 2016年 dllo. All rights reserved.
//

#ifndef SINGLE_h
#define SINGLE_h

#define SINGLEN(className) + (instancetype)share##className

#if __has_feature(objc_arc)

#define SINGLEM(className) \
static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    if (_instance == nil) {\
        @synchronized(self) {\
            if (_instance == nil) {\
                _instance = [super allocWithZone:zone];\
            }\
        }\
    }\
    return _instance;\
}\
+ (instancetype)share##className{\
    if (_instance == nil) {\
        @synchronized(self) {\
            if (_instance == nil) {\
                _instance = [[super alloc]init];\
            }\
        }\
    }\
    return _instance;\
}
#else

#define SINGLEM(className) \
static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    if (_instance == nil) {\
        @synchronized(self) {\
            if (_instance == nil) {\
                _instance = [super allocWithZone:zone];\
            }\
        }\
    }\
    return _instance;\
}\
+ (instancetype)share##className{\
    if (_instance == nil) {\
        @synchronized(self) {\
            if (_instance == nil) {\
                _instance = [[super alloc]init];\
            }\
        }\
    }\
    return _instance;\
}\
- (oneway void)release{\
}\
- (instancetype)retain{\
        return _instance;\
}\
- (NSUInteger)retainCount{\
        return 1;\
    }\
- (instancetype)autorelease{\
        return _instance;\
}


#endif

#endif /* SINGLE_h */
