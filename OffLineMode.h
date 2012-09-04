//
//  OffLineMode.h
//  WaveNews
//
//  Created by GUYU XUE on 29/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface OffLineMode : NSObject
{
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property (nonatomic, retain) Reachability *internetReachable;
@property (nonatomic, retain) Reachability *hostReachable;

+(BOOL) isConnected;
-(void) startTestNetwork;
-(void) checkNetworkStatus:(NSNotification *)notice;
+(NSArray *) getStoredNews:(NSString *) newspaper withSection:(NSString *) section;

@end
