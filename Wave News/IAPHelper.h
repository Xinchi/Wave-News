//
//  IAPHelper.h
//  Wave News
//
//  Created by Max Gu on 1/21/12.
//  Copyright (c) 2012 guxinchi2000@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"

@interface IAPHelper : NSObject <SKProductsRequestDelegate> {
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

@end