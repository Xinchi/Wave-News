//
//  RSSParser.h
//  RSSReader
//
//  Created by GUYU XUE on 24/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface RSSParser : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *newsList;
    NSData *webData;
    
    NSString *newsPaperName;
    NSString *sectionName;
}

@property (nonatomic, retain) NSMutableArray *newsList;
@property (nonatomic, retain) NSData *webData;
@property (nonatomic, retain) NSString *newsPaperName;
@property (nonatomic, retain) NSString *sectionName;

- (NSArray *) getRssRawData:(NSString *)urlString newspaper:(NSString *)newspaper section:(NSString *)section;

@end
