//
//  MLNEditTextViewConst.h
//
//
//  Created by MoMo on 2018/8/17.
//

#import <Foundation/Foundation.h>
#import "MLNGlobalVarExportProtocol.h"

typedef enum : NSUInteger {
    MLNEditTextViewInputModeNormal = 1,
    MLNEditTextViewInputModeNumber = 2,
} MLNEditTextViewInputMode;

// 账密自动填充类型
typedef enum : NSUInteger {
    MLNInternalTextAutoFillUserName = 1,
    MLNInternalTextAutoFillPassword = 2,
} MLNInternalTextAutoFillType;

typedef enum : NSUInteger {
    MLNEditTextViewReturnTypeDefault = 1,
    MLNEditTextViewReturnTypeGo = 2,
    MLNEditTextViewReturnTypeSearch = 3,
    MLNEditTextViewReturnTypeSend = 4,
    MLNEditTextViewReturnTypeNext = 5,
    MLNEditTextViewReturnTypeDone = 6,
} MLNEditTextViewReturnType;

@interface MLNEditTextViewConst : NSObject <MLNGlobalVarExportProtocol>

@end

