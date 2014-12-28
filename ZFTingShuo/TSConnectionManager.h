//
//  TSConnectionManager.h
//  ZFTingShuo
//
//  Created by fminor on 12/18/14.
//                          To dear 将军.
//

#import <Foundation/Foundation.h>

#define kTSNotificationDidReceiveMessage            @"kTSNotificationDidReceiveMessage"

#define TS_CNTMGR                                   [TSConnectionManager sharedManager]

@protocol TSConnectionDelegate;

@interface TSConnectionManager : NSObject

// singleton
+ (TSConnectionManager *)sharedManager;

// delegates
- (void)addDelegate:(id<TSConnectionDelegate>)delegate;
- (void)removeDelegate:(id<TSConnectionDelegate>)delegate;

// services
- (void)connect;
- (void)stop;

@end

@protocol TSConnectionDelegate <NSObject>

- (void)TSConnectionDidReceiveMessage:(NSDictionary *)message;

@end
