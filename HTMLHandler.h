//
//  HTMLHandler.h
//  RSSReader
//
//  Created by GUYU XUE on 22/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLHandler : NSObject

+(NSMutableArray *)discardAllTagAndGetImage:(NSString *) rawText;
+(NSString *)extractFromP: (NSString *) rawText;
+(NSString *)replaceHTMLSpecialCharFromString:(NSString *) rawText;

@end
