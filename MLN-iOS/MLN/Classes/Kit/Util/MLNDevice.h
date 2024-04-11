//
//  MLNDevice.h
//  MLN
//
//  Created by MoMo on 2019/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNDevice : NSObject

+ (NSString *)platform;
+ (NSString *)hwmodel;
+ (BOOL)isIPHX;
+ (BOOL)isiPhoneSimulator;
+ (BOOL)isiPadSimulator;

@end

NS_ASSUME_NONNULL_END
