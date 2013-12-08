//
//  BlockChainAPI.h
//  CheckBTC
//
//  Created by Christian Schulze on 05.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockChainAPI : NSObject

/*!
 @abstract Get the newest ticker update from blockchain.com
 @return Array with currencies and rates
 */
+ (NSDictionary *) getTicker;

@end
