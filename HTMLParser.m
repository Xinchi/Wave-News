//
//  HTMLParser.m
//  WaveNews
//
//  Created by GUYU XUE on 16/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import "HTMLParser.h"
#import "HTMLHandler.h"

@implementation HTMLParser

#pragma mark - New York Times
+(NSString *)parseNYTimesNews:(NSString *)urlString
{
    //read from web
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    NSURLResponse *response=nil;
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *contentString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    
    //elementary process
    //2. find first <NYT_CORRECTION_TOP> - start of useful section
    NSRange range=[contentString rangeOfString:@"<NYT_CORRECTION_TOP>"];
    contentString=[contentString substringFromIndex:range.location];
    
    //3. find the <NYT_CORRECTION_BOTTON> - end of useful section
    range=[contentString rangeOfString:@"<NYT_CORRECTION_BOTTOM>"];
    contentString=[contentString substringToIndex:range.location];
    
    //4. split
    range=[contentString rangeOfString:@"pageLinks"];
    if(range.location!=NSNotFound)
    {
        NSString *articlePart=[[contentString substringToIndex:range.location] retain];
        NSString *linkPart=[[contentString substringFromIndex:range.location] retain]; 
        
        NSMutableString *fullContent=[[NSMutableString alloc] init];
        
        [fullContent appendString:[self NYTSourceParser:articlePart]];
        
        NSArray *otherLinks=[[self NYTGetOtherPages:linkPart] retain];
        
        [self NYTRecursive:otherLinks withIndex:0 intoResult:fullContent];
        
        [otherLinks release];
        [articlePart release];
        [linkPart release];
        [request release];
        
        [fullContent release];
        return [NSString stringWithString:fullContent];
    }
    else
    {
        [request release];
        
        return [self NYTSourceParser:contentString];
    }
}

+(void)NYTRecursive:(NSArray *)allLinks withIndex:(NSUInteger)index intoResult:(NSMutableString*) fullContent
{
    if([allLinks count]==index)
    {
        return;
    }
    
    //read from web
    NSURL *url = [NSURL URLWithString:[allLinks objectAtIndex:index]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    NSURLResponse *response=nil;
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *contentString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    
    //elementary process
    //2. find first <NYT_CORRECTION_TOP> - start of useful section
    NSRange range=[contentString rangeOfString:@"<NYT_CORRECTION_TOP>"];
    contentString=[contentString substringFromIndex:range.location];
    
    //3. find the <NYT_CORRECTION_BOTTON> - end of useful section
    range=[contentString rangeOfString:@"<NYT_CORRECTION_BOTTOM>"];
    contentString=[contentString substringToIndex:range.location];
    
    [fullContent appendString:[self NYTSourceParser:contentString]];
    
    [self NYTRecursive:allLinks withIndex:index+1 intoResult:fullContent];
}

+(NSString *) NYTSourceParser:(NSString *)rawWebPage
{
    NSScanner *scanner=[NSScanner scannerWithString:rawWebPage];
    NSString *pageContent=@"";
    NSString *thisPara=nil;
    
    BOOL readyToRecord=FALSE;
    
    while([scanner isAtEnd]==NO)
    {
        thisPara=@"";
        
        [scanner scanUpToString:@"<" intoString:&thisPara];
        
        if(readyToRecord)
        {
            pageContent=[pageContent stringByAppendingString:thisPara];
        }
        
        if ([scanner scanString:@"</p>" intoString:NULL] && readyToRecord==TRUE) 
        {
            pageContent=[pageContent stringByAppendingString:@"\n\n"];
            readyToRecord=FALSE;
        }
        else if ([scanner scanString:@"<p>" intoString:NULL])
        {
            readyToRecord=TRUE;
        }
        else if ([scanner scanString:@"</a>" intoString:NULL] && readyToRecord==TRUE)
        {
            pageContent=[pageContent stringByAppendingString:@" "];
        }
        else
        {
            [scanner scanUpToString:@">" intoString:NULL];
            [scanner scanString:@">" intoString:NULL];
        }
    }
    
    return pageContent;
}

+(NSArray *)NYTGetOtherPages:(NSString *)otherPages
{
    NSMutableArray *allLinks=[[NSMutableArray alloc] init];
    
    //1. split the string
    NSRange range=[otherPages rangeOfString:@"title"];
    otherPages=[otherPages substringFromIndex:range.location+4];
    
    NSArray *urls=[otherPages componentsSeparatedByString:@"title"];
    
    //2. loop the array and read all pages
    for(NSString *url in urls)
    {
        //2.1. trim the url
        range=[url rangeOfString:@"href"];
        
        if(range.location==NSNotFound)
        {
            continue;
        }
        
        url=[url substringFromIndex:range.location+6];
        
        range=[url rangeOfString:@"\">"];
        url=[url substringToIndex:range.location];
        
        //2.2. append
        url=[@"http://www.nytimes.com" stringByAppendingString:url];
        
        [allLinks addObject:url];
    }
    
    return [NSArray arrayWithArray:allLinks];
}

@end
