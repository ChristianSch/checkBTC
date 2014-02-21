//
//  DisplayDataCallbackProtocol.h
//  CheckBTC
//
//  Created by X on 21.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header DisplayData Callback Protocol
 This is the minimum of selectors to respond to asure proper communication between
 the DataController and the data display delegate that handles the visual presentation.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.1
 @updated 21.02.14
 */
@protocol DisplayDataCallbackProtocol <NSObject>

- (void)setText:(NSString *)text;
@optional
- (void)setTextWithAnimation:(NSString *)text;

@end
