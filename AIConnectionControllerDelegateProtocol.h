//
//  AIConnectionControllerDelegateProtocol.h
//  CheckBTC
//
//  Created by X on 20.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AIConnectionControllerDelegateProtocol <NSObject>

- (void)didFinishLoading:(NSData *)data;
- (void)didFailWithError:(NSError *)error;

@end
