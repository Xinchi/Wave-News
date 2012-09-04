//
//  WaveNewsIAPHelper.m
//  Wave News
//
//  Created by Max Gu on 1/21/12.
//  Copyright (c) 2012 guxinchi2000@gmail.com. All rights reserved.
//

#import "WaveNewsIAPHelper.h"

@implementation WaveNewsIAPHelper

static WaveNewsIAPHelper * _sharedHelper;

+ (WaveNewsIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[WaveNewsIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"com.unitedtech.wavenews.fullnews",
                                 nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end