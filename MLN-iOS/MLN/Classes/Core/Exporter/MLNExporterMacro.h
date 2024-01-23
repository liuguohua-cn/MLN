//
//  MLNExporterMacro.h
//  MLNCore
//
//  Created by MoMo on 2019/7/30.
//

#ifndef MLNExporterMacro_h
#define MLNExporterMacro_h

#import "MLNInvocation.h"
#import "MLNMachORegister.h"


#define  MLNExportBindSplit @"___MLNExportBind___"
#define  MLNExportBindSectionNameSpace @"MLNExportBind"

// 注册Goto actionName与处理类
#define LUA_ExportBind(luaClass, nativeClass) \
MLNMachORegisterK_VSet(MLNExportBind, luaClass##___MLNExportBind___##nativeClass);

/**
 构建方法列表
 
 @param METHODS 方法列表名称
 @param CLZ 类名称
 */
#define LUA_EXPORT_MAKE_METHOD_LIST(METHODS, CLZ) \
static const struct mln_objc_method METHODS ## CLZ [] = {

/**
 创建方法映射

 @param LUA_FUNC_NAME 在Lua中的名称
 @param SEL_NAME 原生中的方法名字符串
 @param CLZ_NAME 原生中的类名字符串
 @param IS_PROPERTY_T 是否为属性
 @param SETTER_NAME 原生中的setter方法名
 @param GETTER_NAME 原生中的getter方法名
 @param CFUNC 映射的Lua C function
 */
#define LUA_EXPORT_MAKE_METHOD(LUA_FUNC_NAME, SEL_NAME, CLZ_NAME, IS_PROPERTY_T, SETTER_NAME, GETTER_NAME, CFUNC) \
{(LUA_FUNC_NAME), (SEL_NAME), (CLZ_NAME), (IS_PROPERTY_T), (SETTER_NAME), (GETTER_NAME), (CFUNC)}


/**
 创建方法映射，并添加到方法映射表中

 @param LUA_FUNC_NAME 在Lua中的名称
 @param SEL_NAME 原生中的方法名字符串
 @param CLZ_NAME 原生中的类名字符串
 @param IS_PROPERTY_T 是否为属性
 @param SETTER_NAME 原生中的setter方法名
 @param GETTER_NAME 原生中的getter方法名
 @param CFUNC 映射的Lua C function
 */
#define LUA_EXPORT_METHOD_LIST_ADD(LUA_FUNC_NAME, SEL_NAME, CLZ_NAME, IS_PROPERTY_T, SETTER_NAME, GETTER_NAME, CFUNC) \
LUA_EXPORT_MAKE_METHOD(LUA_FUNC_NAME, SEL_NAME, CLZ_NAME, IS_PROPERTY_T, SETTER_NAME, GETTER_NAME, CFUNC),

/**
 方法映射表构建完成
 */
#define LUA_EXPORT_METHOD_LIST_COMPLETED \
{NULL, NULL, NULL, NO, NULL, NULL, NULL}\
};

#define MLN_COMMA "."

/**
 构建导出信息
 
 @param PKG_NAME 包名 （例："mm"）
 @param CLZ_NAME 类名 (例："NSObject")
 @param LUA_NAME 在lua中的类名 （例： "Object"）
 @param LTYPE_NAME 在lua中的类型 （例：LVType_UserDataNativeObject | LVType_UserDataView）
 @param HAS_SUPER 是否有父类 (YES/NO)
 @param SUPER_CLZ_NAME 父类名字 (例："NSObject")
 @param METHODS 方法列表
 @param CLZMETHODS 类方法列表
 @param CONSTRUCTO_T 构造器方法（例：initWithFrame:）
 @param CLZ 类名 (例：NSObject)
 */
#define LUA_EXPORT_MAKE_INFO(PKG_NAME, CLZ_NAME, LUA_CLZ_NAME, LTYPE_NAME, HAS_SUPER, SUPER_CLZ_NAME, HAS_CSTRUCTOR, METHODS,\
CLZMETHODS, CONSTRUCTOR_T, CLZ) \
static const struct mln_objc_class mln_Clazz_Info_ ## CLZ = {\
PKG_NAME,\
CLZ_NAME,\
LUA_CLZ_NAME,\
PKG_NAME MLN_COMMA LUA_CLZ_NAME,\
LTYPE_NAME,\
!(HAS_SUPER),\
SUPER_CLZ_NAME,\
HAS_CSTRUCTOR,\
METHODS,\
CLZMETHODS,\
CONSTRUCTOR_T\
};\
+ (const mln_objc_class *)mln_clazzInfo\
{\
return &mln_Clazz_Info_ ## CLZ;\
}

/**
 定义被导出类型

 @param TYPE 导出类型
 */
#define LUA_EXPORT_TYPE(TYPE) \
+ (MLNExportType)mln_exportType {\
    return (TYPE);\
}

#endif /* MLNExporterMacro_h */
