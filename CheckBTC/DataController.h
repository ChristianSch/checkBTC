//
//  DataController.h
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIConnectionController.h"
#import "DataSourceProtocol.h"
#import "DisplayDataCallbackProtocol.h"
#import "UserDefaultsControllerDelegateProtocol.h"

/*!
 @header DataController
 This controller handles data retrieval, evaluation and handling of the results.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.1
 @updated 15.04.14
 */
@interface DataController : NSObject<AIConnectionControllerDelegateProtocol>
{
	NSTimer *theTimer;
	NSRunLoop *runLoop;
	NSNumber *lastAvg;
	
	/* controllers */
	AIConnectionController *connectionController;
}

- (id)initWithUserDefaultsControllerDelegate:
(id<UserDefaultsControllerDelegateProtocol>)delegate;

/*!
 @abstract Set delegate to handle setting and getting of user defaults
 @param delegate actual handler
 */
- (void)setUserDefaultsControllerDelegate:
(id<UserDefaultsControllerDelegateProtocol>)delegate;

/*!
 @abstract Set the delegate handling the visual representation of the aggregated data
 @param delegate actual handler
 */
- (void)setDisplayDataCallbackDelegate:(id<DisplayDataCallbackProtocol>)delegate;

@property (nonatomic, assign) id<UserDefaultsControllerDelegateProtocol>
userDefaultsControllerDelegate;

@property (nonatomic, assign) id<DisplayDataCallbackProtocol>
displayDataCallbackDelegate;

@property (nonatomic) id<DataSourceProtocol> dataSource;

@end
