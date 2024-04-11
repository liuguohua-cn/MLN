// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: PBRenameCommand.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class pbbasecommand;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - PbrenameCommandRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface PbrenameCommandRoot : GPBRootObject
@end

#pragma mark - pbrenamecommand

typedef GPB_ENUM(pbrenamecommand_FieldNumber) {
  pbrenamecommand_FieldNumber_Basecommand = 1,
  pbrenamecommand_FieldNumber_OldFilePath = 2,
  pbrenamecommand_FieldNumber_OldRelativeFilePath = 3,
  pbrenamecommand_FieldNumber_NewFilePath = 4,
  pbrenamecommand_FieldNumber_NewRelativeFilePath = 5,
};

@interface pbrenamecommand : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) pbbasecommand *basecommand;
/** Test to see if @c basecommand has been set. */
@property(nonatomic, readwrite) BOOL hasBasecommand;

@property(nonatomic, readwrite, copy, null_resettable) NSString *oldFilePath;

@property(nonatomic, readwrite, copy, null_resettable) NSString *oldRelativeFilePath;

@property(nonatomic, readwrite, copy, null_resettable) NSString *newFilePath NS_RETURNS_NOT_RETAINED;

@property(nonatomic, readwrite, copy, null_resettable) NSString *newRelativeFilePath NS_RETURNS_NOT_RETAINED;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
