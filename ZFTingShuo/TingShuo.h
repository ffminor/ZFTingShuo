//
//  TingShuo.h
//  ZFTingShuo
//
//  Created by fminor on 11/18/14.
//                      To dear 将军.
//

#ifndef ZFTingShuo_TingShuo_h
#define ZFTingShuo_TingShuo_h

#pragma mark - thread

#define TS_SINGLETON_LOCK               @synchronized(self) {
#define TS_SINGLETON_UNLOCK             }

#pragma mark - color

#define TS_COLOR_BKG        [UIColor colorWithRed:(CGFloat)0xF0/0xFF green:(CGFloat)0xF0/0xFF blue:(CGFloat)0xF0/0xFF alpha:1]
#define TS_COLOR_SUBTILTE   [UIColor blackColor]
#define TS_COLOR_THEME      [UIColor colorWithRed:(CGFloat)0x30/0xFF green:(CGFloat)0x69/0xFF blue:(CGFloat)0xB1/0xFF alpha:1]

#pragma mark - key

#define kLastLoginUserIdentity          @"kLastLoginUserIdentity"

#pragma mark - swift model

#define TS_DATAMGR                      [TSDataManager sharedManager]

#endif
