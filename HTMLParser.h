//
//  HTMLParser.h
//  WaveNews
//
//  Created by GUYU XUE on 16/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLParser : NSObject

+(NSString *)parseNYTimesNews:(NSString *)urlString;
+(void)NYTRecursive:(NSArray *)allLinks withIndex:(NSUInteger)index intoResult:(NSMutableString*) fullContent;
+(NSString *) NYTSourceParser:(NSString *)rawWebPage;
+(NSArray *)NYTGetOtherPages:(NSString *)otherPages;



@end
