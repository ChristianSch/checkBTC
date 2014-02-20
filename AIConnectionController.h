//
//  AIConnectionController.h
//  CheckBTC
//
//  Created by X on 20.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIConnectionControllerDelegateProtocol.h"

@interface AIConnectionController : NSObject

@property (weak) id <AIConnectionControllerDelegateProtocol> callbackDelegate;
@property NSMutableData *data;

- (void)setDelegate:(id)delegate;
- (void)makeRequestWithURLReqest:(NSURLRequest *)request;

@end