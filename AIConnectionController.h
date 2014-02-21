//
//  AIConnectionController.h
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIConnectionControllerDelegateProtocol.h"

/*!
 @header AIConnectionController
 This controller builds a wrapper upon retrieval of URL contents and managing the
 callback delegate to take action after the connection finished.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.1
 @updated 20.02.14
 */
@interface AIConnectionController : NSObject

@property (weak) id <AIConnectionControllerDelegateProtocol> callbackDelegate;
@property NSMutableData *data;

/*!
 @abstract Set the delegate that acts upon finished requests.
 @param delegate Delegate
 */
- (void)setDelegate:(id<AIConnectionControllerDelegateProtocol>)delegate;

/*!
 @abstract Request contents of a pre made request
 @param request Already set up request
 */
- (void)makeConnectionWithReqest:(NSURLRequest *)request;

/*!
 @abstract Retrieve content of URL
 @param url URL to retrieve the content from
 */
- (void)makeConnectionWithURL:(NSURL *)url;
@end