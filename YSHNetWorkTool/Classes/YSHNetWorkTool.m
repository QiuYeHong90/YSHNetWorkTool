//
//  YSHNetWorkTool.m
//  AFNetworking
//
//  Created by shuhui on 2018/12/12.
//


#import "PPNetworkCache.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YSHNetWorkTool.h"

#ifdef DEBUG
#define PPLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define PPLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

@implementation YSHNetWorkTool
static BOOL _isOpenLog;   // 是否已开启日志打印
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;


+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}


/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    _sessionManager.requestSerializer  = [AFJSONRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    
    
}
+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}
/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

+ (__kindof NSURLSessionTask *)PUT:(NSString *)URL
                        parameters:(id)parameters
                           success:(PPHttpRequestSuccess)success
                           failure:(PPHttpRequestFailed)failure
{
    
    return [self PUT:URL parameters:parameters responseCache:nil success:success failure:failure];
}
+ (__kindof NSURLSessionTask *)DELETE:(NSString *)URL
                        parameters:(id)parameters
                           success:(PPHttpRequestSuccess)success
                           failure:(PPHttpRequestFailed)failure
{
    
    return [self DELETE:URL parameters:parameters responseCache:nil success:success failure:failure];
}
#pragma mark - PUT请求自动缓存
+ (NSURLSessionTask *)PUT:(NSString *)URL
                parameters:(id)parameters
             responseCache:(PPHttpRequestCache)responseCache
                   success:(PPHttpRequestSuccess)success
                   failure:(PPHttpRequestFailed)failure {
    //读取缓存
    responseCache!=nil ? responseCache([PPNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager PUT:URL parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {
            PPLog(@"responseObject = %@",responseObject);
            
        }
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache!=nil ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {
            PPLog(@"error = %@",error);
            
        }
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark - DELETE请求自动缓存
+ (NSURLSessionTask *)DELETE:(NSString *)URL
               parameters:(id)parameters
            responseCache:(PPHttpRequestCache)responseCache
                  success:(PPHttpRequestSuccess)success
                  failure:(PPHttpRequestFailed)failure {
    //读取缓存
    responseCache!=nil ? responseCache([PPNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager DELETE:URL parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {
            PPLog(@"responseObject = %@",responseObject);
            
        }
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache!=nil ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {
            PPLog(@"error = %@",error);
            
        }
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}


@end
