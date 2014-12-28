//
//  TSConnectionManager.m
//  ZFTingShuo
//
//  Created by fminor on 12/18/14.
//
//

#import "TSConnectionManager.h"
#import "SwiftModule-swift.h"
#import "AFNetworking.h"
#import "TingShuo.h"

#define TS_HEART_BREAK_INTERVAL                     20.f

static TSConnectionManager *_gConnectionManager = nil;

@interface TSConnectionManager ()
{
    NSURL                               *_connectUrl;
    NSMutableURLRequest                 *_connectRequest;
//    AFHTTPRequestOperation              *_requestOperation;
    
    NSMutableArray                      *_delegates;
    
    NSTimer                             *_heartBreakTimer;
}

@end

@implementation TSConnectionManager

- (id)init
{
    self = [super init];
    if ( self ) {
        TSUser *_user = (TSUser *)[TS_DATAMGR dataForKey:kLastLoginUserIdentity];
        if ( _user ) {
            NSString *_name = _user.name;
            NSString *_pwd = _user.password;
            _connectUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://42.121.144.167/?acc=%@&psw=%@&type=hb",
                                                _name, _pwd]];
        }
        
        if ( _connectUrl ) {
            _connectRequest = [NSMutableURLRequest requestWithURL:_connectUrl];
        }
        
        _delegates = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - singleton

+ (TSConnectionManager *)sharedManager
{
    TS_SINGLETON_LOCK
    if ( !_gConnectionManager ) {
        _gConnectionManager = [[TSConnectionManager alloc] init];
    }
    return _gConnectionManager;
    TS_SINGLETON_UNLOCK
}

#pragma mark - delegates

- (void)addDelegate:(id<TSConnectionDelegate>)delegate
{
    if ( !delegate ) {
        return;
    }
    
    __weak id<TSConnectionDelegate> _wDelegate = delegate;
    if ( [_delegates containsObject:delegate] ) {
        return;
    }
    
    [_delegates addObject:_wDelegate];
}

- (void)removeDelegate:(id<TSConnectionDelegate>)delegate
{
    if ( !delegate ) {
        return;
    }
    
    if ( [_delegates containsObject:delegate] ) {
        [_delegates removeObject:delegate];
    }
}

#pragma mark - services

- (void)connect
{
    [self _connect];
    
    if ( _heartBreakTimer ) {
        [_heartBreakTimer invalidate];
        _heartBreakTimer = nil;
    }
    
    _heartBreakTimer = [NSTimer scheduledTimerWithTimeInterval:TS_HEART_BREAK_INTERVAL
                                                        target:self
                                                      selector:@selector(_connect)
                                                      userInfo:nil repeats:YES];
}

- (void)stop
{
    if ( _heartBreakTimer ) {
        [_heartBreakTimer invalidate];
        _heartBreakTimer = nil;
    }
}

- (void)_connect
{
    NSLog(@"Prepare to connect url: %@", _connectUrl);
    AFHTTPRequestOperation *_operation = nil;
    if ( !_operation ) {
        _operation = [[AFHTTPRequestOperation alloc] initWithRequest:_connectRequest];
        __weak TSConnectionManager *_wss = self;
        [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ( !_wss ) {
                return;
            }
            __strong TSConnectionManager *_sss = _wss;
            NSDictionary *_jsonDict = nil;
            @try {
                _jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
                NSLog(@"\nReceive package from url:%@,\ndata: %@", _sss->_connectUrl, _jsonDict);
            }
            @catch (NSException *exception) {
                NSLog(@"Parse json response failed!");
                return;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTSNotificationDidReceiveMessage
                                                                object:nil userInfo:nil];
            for ( id<TSConnectionDelegate> _delegate in _sss->_delegates ) {
                if ( [_delegate respondsToSelector:@selector(TSConnectionDidReceiveMessage:)] ) {
                    [_delegate TSConnectionDidReceiveMessage:_jsonDict];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    [_operation start];
}

@end
