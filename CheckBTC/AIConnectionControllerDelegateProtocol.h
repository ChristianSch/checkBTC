//
//  AIConnectionControllerDelegateProtocol.h
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header AIConnectionController Delegate Protocol
 This protocol dictates the proper way to interact with finished requests of URL content.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.1
 @updated 20.02.14
 */
@protocol AIConnectionControllerDelegateProtocol <NSObject>

/*!
 @abstract The delegate needs to act on a finished connection. The `data` is the
 retrieved information given at calling makeRequestWithURLReqest in the
 AIConnectionController
 @param data Retrieved information
 */
- (void)didFinishLoading:(NSData *)data;

/*
 @abstract The delegate needs to act at any fail that has happened before, while, and
 after information retrieval by the AIConnectionController
 @param error Detailed information on the fail that occured
 */
- (void)didFailWithError:(NSError *)error;

@end
