/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI15_0_0RCTWebSocketObserver.h"

#import <ReactABI15_0_0/ABI15_0_0RCTConvert.h>
#import <ReactABI15_0_0/ABI15_0_0RCTDefines.h>
#import <ReactABI15_0_0/ABI15_0_0RCTLog.h>
#import <ReactABI15_0_0/ABI15_0_0RCTUtils.h>

#import "ABI15_0_0RCTSRWebSocket.h"

#if ABI15_0_0RCT_DEV // Only supported in dev mode

@interface ABI15_0_0RCTWebSocketObserver () <ABI15_0_0RCTSRWebSocketDelegate>
@end

@implementation ABI15_0_0RCTWebSocketObserver {
  NSURL *_url;
  ABI15_0_0RCTSRWebSocket *_socket;
}

@synthesize delegate = _delegate;

- (instancetype)initWithURL:(NSURL *)url
{
  if ((self = [self init])) {
    _url = url;
}
  return self;
}

- (void)start
{
  [self stop];
  _socket = [[ABI15_0_0RCTSRWebSocket alloc] initWithURL:_url];
  _socket.delegate = self;

  [_socket open];
}

- (void)stop
{
  _socket.delegate = nil;
  [_socket closeWithCode:1000 reason:@"Invalidated"];
  _socket = nil;
}

- (void)webSocket:(ABI15_0_0RCTSRWebSocket *)webSocket didReceiveMessage:(id)message
{
  if (_delegate) {
    NSError *error = nil;
    NSDictionary<NSString *, id> *msg = ABI15_0_0RCTJSONParse(message, &error);

    if (!error) {
      [_delegate didReceiveWebSocketMessage:msg];
    } else {
      ABI15_0_0RCTLogError(@"WebSocketManager failed to parse message with error %@\n<message>\n%@\n</message>", error, message);
    }
  }
}

- (void)reconnect
{
  __weak ABI15_0_0RCTSRWebSocket *socket = _socket;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // Only reconnect if the observer wasn't stoppped while we were waiting
    if (socket) {
      [self start];
    }
  });
}

- (void)webSocket:(ABI15_0_0RCTSRWebSocket *)webSocket didFailWithError:(NSError *)error
{
  [self reconnect];
}

- (void)webSocket:(ABI15_0_0RCTSRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
  [self reconnect];
}

@end

#endif
