//
//  RSSParser.m
//  RSSReader
//
//  Created by GUYU XUE on 24/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "RSSParser.h"
#import "HTMLHandler.h"

@implementation RSSParser

@synthesize newsList;
@synthesize webData;
@synthesize newsPaperName;
@synthesize sectionName;

BOOL hasImageFromDesc=FALSE;

#pragma mark - view life cycle
/*
-(id) init
{
    if(self=[super init])
    {
        
    }
}
*/

-(void)dealloc
{
    [newsPaperName release];
    [sectionName release];
    [super dealloc];
}

#pragma mark - get data from web
- (NSArray *) getRssRawData:(NSString *)urlString newspaper:(NSString *)newspaper section:(NSString *)section
{
    newsPaperName=newspaper;
    sectionName=section;
    
    newsList=[[[NSMutableArray alloc] init] autorelease];
    
    //read from web
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
    
    NSError *error;
    NSURLResponse *response;
    
    webData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSString *jsonString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",jsonString);
    
    if(webData)
    {
        NSXMLParser *theParser=[[[NSXMLParser alloc] initWithData:webData] autorelease];
        [theParser setDelegate:self];
        
        if([theParser parse])
        {
            NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *myDocPath = [myPaths objectAtIndex:0];
            
            newspaper=[newspaper stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            section=[section stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            
            NSString *fileName=[NSString stringWithFormat:@"%@_%@.plist",newspaper,section];
            
            NSString *filePath = [myDocPath stringByAppendingPathComponent:fileName];
            
            [newsList writeToFile:filePath atomically:YES];
            
            return newsList;
        }
        else
        {
            NSLog(@"parsing error");
            
            NSMutableDictionary *fakeNews=[[[NSMutableDictionary alloc] init] autorelease];
            [fakeNews setValue:@"RSS Feed is Temporarily Unavailable" forKey:@"title"];
            
            NSMutableArray *fakeNewsList=[[[NSMutableArray alloc] init] autorelease];
            [fakeNewsList addObject:fakeNews];
            
            return fakeNewsList;
        }
    }
    else
    {
        NSLog(@"download error");
        
        NSMutableDictionary *fakeNews=[[[NSMutableDictionary alloc] init] autorelease];
        [fakeNews setValue:@"RSS Feed is Temporarily Unavailable" forKey:@"title"];
        
        NSMutableArray *fakeNewsList=[[[NSMutableArray alloc] init] autorelease];
        [fakeNewsList addObject:fakeNews];
        
        return fakeNewsList;
    }
}

#pragma mark - XML parsing
//variables for temp use;
BOOL withinItem=FALSE;
BOOL isRecordingElement=FALSE;
NSMutableString *cumulatedValue;
NSString *mediaUrl;

NSMutableDictionary *curNews;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString* )namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
    if ([elementName isEqualToString:@"item"]) {
        //start recording
        withinItem=TRUE;
        
        curNews=[[NSMutableDictionary alloc] init];
        [curNews setValue:@"" forKey:@"title"];
        [curNews setValue:@"" forKey:@"url"];
        [curNews setValue:@"" forKey:@"description"];
        [curNews setValue:@"" forKey:@"author"];
        [curNews setValue:@"" forKey:@"pubDate"];
        [curNews setValue:newsPaperName forKey:@"source"];
        [curNews setValue:@"NO" forKey:@"isSaved"];
        [curNews setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"media"];
        
        return; 
    }
    
    if(!withinItem)
    {
        return;
    }
    
    if ([elementName isEqualToString:@"title"]
        || [elementName isEqualToString:@"link"]
        || [elementName isEqualToString:@"description"]
        || [elementName isEqualToString:@"pubDate"]
        || [elementName isEqualToString:@"dc:creator"]) 
    {
        cumulatedValue=[[NSMutableString alloc] init];
        
        isRecordingElement=TRUE;
        
        return; 
    }
    if([elementName isEqualToString:@"media:content"])
    {
        mediaUrl=[attributeDict objectForKey:@"url"];

        if(mediaUrl)
        {
            if(hasImageFromDesc)
            {
                [(NSMutableArray *)[curNews objectForKey:@"media"] removeAllObjects];
                hasImageFromDesc=FALSE;
            }
            
            
            [[curNews objectForKey:@"media"] addObject:mediaUrl];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!withinItem)
    {
        return;
    }
    if(!isRecordingElement)
    {
        return;
    }
    
    [cumulatedValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    NSString *valueForEachItem;
    
    if(!withinItem)
    {
        return;
    }
    
    if ([elementName isEqualToString:@"item"]) {
        //finish recording, store the news dictionary into the newslist array
        withinItem=FALSE;
        
        [newsList addObject:curNews];
        
        return; 
    }
    if ([elementName isEqualToString:@"title"]) 
    {
        //store the info into dictionary
        valueForEachItem = [cumulatedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [curNews setValue:valueForEachItem forKey:@"title"];
        cumulatedValue=nil;
        isRecordingElement=FALSE;
        
        return; 
    }
    if ([elementName isEqualToString:@"link"]) 
    {
        //store the info into dictionary
        valueForEachItem = [cumulatedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [curNews setValue:valueForEachItem forKey:@"url"];
        cumulatedValue=nil;
        isRecordingElement=FALSE;
        
        return; 
    }
    if ([elementName isEqualToString:@"description"]) 
    {
        //store the info into dictionary
        valueForEachItem = [cumulatedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableArray *returnResult = [[HTMLHandler discardAllTagAndGetImage:valueForEachItem] retain];
        
        [curNews setValue:[returnResult objectAtIndex:0] forKey:@"description"];
        
        if([[curNews objectForKey:@"media"] count]==0 && ![[returnResult objectAtIndex:1] isEqualToString:@""])
        {
            [[curNews objectForKey:@"media"] addObject:[returnResult objectAtIndex:1]];
            
            hasImageFromDesc=TRUE;
        }
        
        cumulatedValue=nil;
        isRecordingElement=FALSE;
        
        [returnResult release];
        
        return; 
    }
    if ([elementName isEqualToString:@"pubDate"]) 
    {
//        NSLog(@"-----%@ - %@ - %@-----",newsPaperName, sectionName, cumulatedValue);
        
        //store the info into dictionary
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];
        
        NSString *dateString = [cumulatedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSDate *sourceDate;
        
        //Los Angeles Times different time representation
        if([newsPaperName isEqualToString:@"LOS ANGELES TIMES"] || [newsPaperName isEqualToString:@"SAN FRANCISCO CHRONICLE"] || ([newsPaperName isEqualToString:@"YAHOO"]&&[sectionName isEqualToString:@"Sports"]) || ([newsPaperName isEqualToString:@"YAHOO"]&&[sectionName isEqualToString:@"Music"]))
        {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'PST'"];
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            sourceDate=[dateFormatter dateFromString:dateString];
            
//           NSLog(@"+++++%@+++++",sourceDate);
            
            if(!sourceDate)
            {
                [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss '-0800'"];
                
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                sourceDate=[dateFormatter dateFromString:dateString];
            }
        }
        else if([newsPaperName isEqualToString:@"WALL STREET JOURNAL"])
        {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'CST'"];
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            sourceDate=[dateFormatter dateFromString:dateString];
        }
        else if([newsPaperName isEqualToString:@"WASHINGTON POST"] || [newsPaperName isEqualToString:@"CNN"])
        {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'EST'"];
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            sourceDate=[dateFormatter dateFromString:dateString];
        }
        else if([newsPaperName isEqualToString:@"NEW YORK POST"])
        {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss '-0500'"];
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            sourceDate=[dateFormatter dateFromString:dateString];
        }
        else if([newsPaperName isEqualToString:@"YAHOO"] && [sectionName isEqualToString:@"Headlines"])
        {
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            sourceDate=[dateFormatter dateFromString:dateString];
        }
        else
        {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            sourceDate=[dateFormatter dateFromString:dateString];
        }
        
        NSDate* destinationDate;
        
        if(!sourceDate)
        {
            destinationDate=nil;
        }
        else
        {
            NSTimeZone *localTimeZone=[NSTimeZone localTimeZone];
            
            NSInteger destinationGMTOffset = [localTimeZone secondsFromGMTForDate:sourceDate];
            NSTimeInterval interval = destinationGMTOffset - 0;
            
            destinationDate=[[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
        }
        
        //valueForEachItem = [cumulatedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [curNews setValue:destinationDate forKey:@"pubDate"];
        
        cumulatedValue=nil;
        isRecordingElement=FALSE;
        
        [dateFormatter release];
        
        return; 
    }
    if ([elementName isEqualToString:@"dc:creator"]) 
    {
        //store the info into dictionary
        valueForEachItem = [cumulatedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [curNews setValue:valueForEachItem forKey:@"author"];
        cumulatedValue=nil;
        isRecordingElement=FALSE;
        
        return; 
    }
}
@end
