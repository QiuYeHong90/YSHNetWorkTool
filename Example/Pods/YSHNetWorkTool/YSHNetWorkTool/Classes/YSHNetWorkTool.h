//
//  YSHNetWorkTool.h
//  AFNetworking
//
//  Created by shuhui on 2018/12/12.
//




#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/// 请求成功的Block
typedef void(^PPHttpRequestSuccess)(id responseObject);

/// 请求失败的Block
typedef void(^PPHttpRequestFailed)(NSError *error);
/// 缓存的Block
typedef void(^PPHttpRequestCache)(id responseCache);


@interface YSHNetWorkTool : NSObject
+ (void)openLog;



+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


+ (__kindof NSURLSessionTask *)PUT:(NSString *)URL
                        parameters:(id)parameters
                           success:(PPHttpRequestSuccess)success
                           failure:(PPHttpRequestFailed)failure;

+ (__kindof NSURLSessionTask *)DELETE:(NSString *)URL
                           parameters:(id)parameters
                              success:(PPHttpRequestSuccess)success
                              failure:(PPHttpRequestFailed)failure;




@end

NS_ASSUME_NONNULL_END
