// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class EXErrorRecoveryManager;
@class EXKernelLinkingManager;
@class EXRemoteNotificationManager;

@interface EXKernelServiceRegistry : NSObject

@property (nonatomic, readonly) EXErrorRecoveryManager *errorRecoveryManager;
@property (nonatomic, readonly) EXRemoteNotificationManager *remoteNotificationManager;
@property (nonatomic, readonly) EXKernelLinkingManager *linkingManager;

@property (nonatomic, readonly) NSDictionary *allServices;

@end
