//
//  MLNPaddingViewProtocol.h
//  MLN
//
//  Created by MoMo on 2019/6/19.
//

#ifndef MLNPaddingViewProtocol_h
#define MLNPaddingViewProtocol_h
#import <UIKit/UIKit.h>

/**
 带有Padding效果的视图协议。
 */
@protocol MLNPaddingContainerViewProtocol <NSObject>

/**
 被padding包裹的内容视图。
 */
@property (nonatomic, strong, readonly) UIView *lua_contentView;

@property (nonatomic, assign) CGFloat lua_paddingLeft;
@property (nonatomic, assign) CGFloat lua_paddingRight;
@property (nonatomic, assign) CGFloat lua_paddingTop;
@property (nonatomic, assign) CGFloat lua_paddingBottom;

/**
 当前的padding是否需要更新
 */
@property (nonatomic, assign, getter=lua_isPaddingNeedUpdated) BOOL lua_paddingNeedUpdated;

/**
 当视图内部Padding需要更新时候被调用，如果你需要自己处理padding，可以重写该方法。
 
 @warning 不可以主动调用该方法！
 */
- (void)lua_onUpdateForPadding;

/**
 当视图内部Padding更新后被调用，如果你需要自己处理padding，可以重写该方法。
 
 @warning 不可以主动调用该方法！
 */
- (void)lua_paddingUpdated;

@end

#endif /* MLNPaddingViewProtocol_h */
