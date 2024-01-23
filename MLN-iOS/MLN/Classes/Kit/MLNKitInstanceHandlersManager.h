//
//  MLNKitInstanceHandlers.h
//  MLN
//
//  Created by MoMo on 2019/8/28.
//

#import <Foundation/Foundation.h>
#import "MLNImageLoaderProtocol.h"
#import "MLNRefreshDelegate.h"
#import "MLNKitInstanceErrorHandlerProtocol.h"
#import "MLNHttpHandlerProtocol.h"
#import "MLNKitInstance.h"
#import "MLNNavigatorHandlerProtocol.h"
#import "MLNDependenceProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class MLNApplication;
@class MLNNetworkReachability;
@interface MLNKitInstanceHandlersManager : NSObject

/**
 承载Kit库bridge和LuaCore实例
 */
@property (nonatomic, weak, readonly) MLNKitInstance *instance;

/**
 错误处理句柄
 */
@property (nonatomic, weak) id<MLNKitInstanceErrorHandlerProtocol> errorHandler;

/**
 网络处理句柄
 */
@property (nonatomic, weak) id<MLNHttpHandlerProtocol> httpHandler;

/**
 图片加载器
 */
@property (nonatomic, weak) id<MLNImageLoaderProtocol> imageLoader;

/**
 可滚动视图上拉下拉操作处理句柄
 */
@property (nonatomic, weak) id<MLNRefreshDelegate> scrollRefreshHandler;

/**
 页面跳转处理句柄
 */
@property (nonatomic, weak) id<MLNNavigatorHandlerProtocol> navigatorHandler;

/**
 依赖处理句柄
 */
@property (nonatomic, weak) id<MLNDependenceProtocol> dependenceHandler;

/**
 应用级别事务处理工具
 */
@property (nonatomic, strong, readonly) MLNApplication *application;

/**
 网络连通检测工具
 */
@property (nonatomic, strong, readonly) MLNNetworkReachability *networkReachability;

/**
 创建Handler管理器

 @param instance 对应的KitInstance
 @return Handler管理器
 */
- (instancetype)initWithUIInstance:(MLNKitInstance *)instance;

/**
 创建默认的Handler管理器，如果某个KitInstance未设置相应的处理句柄，则使用默认管理器中的处理句柄

 @return Handler管理器
 */
+ (instancetype)defaultManager;

@end

NS_ASSUME_NONNULL_END
