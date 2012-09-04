//
//  HTMLHandler.m
//  RSSReader
//
//  Created by GUYU XUE on 22/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "HTMLHandler.h"

@implementation HTMLHandler

//return true if successful
//discard everything within < and > 
+(NSMutableArray *)discardAllTagAndGetImage:(NSString *) rawText
{
    NSMutableArray *returnResult=[[[NSMutableArray alloc] init] autorelease];
    
    NSScanner *scanner=[NSScanner scannerWithString:rawText];
    NSString *pageContent=@"";
    NSString *imageUrl=@"";
    NSString *thisPara=nil;
    
    BOOL urlAlreadyGet=FALSE;
    
    while([scanner isAtEnd]==NO)
    {
        thisPara=@"";
        
        [scanner scanUpToString:@"<" intoString:&thisPara];
        
        if(!urlAlreadyGet)
        {
            if([scanner scanString:@"<img" intoString:NULL])
            {
                @try {
                    pageContent=[pageContent stringByAppendingString:thisPara];
                    
                    NSString *tempStorage=nil;
                    
                    [scanner scanUpToString:@">" intoString:&tempStorage];
                    [scanner scanString:@">" intoString:NULL];
                    
                    NSRange range=[tempStorage rangeOfString:@"src=\""];
                    tempStorage=[tempStorage substringFromIndex:range.location+range.length];
                    
                    range=[tempStorage rangeOfString:@"\""];
                    imageUrl=[tempStorage substringToIndex:range.location];
                    
                    urlAlreadyGet=TRUE;
                    
                    NSString *testFormat=[imageUrl substringFromIndex:imageUrl.length-3];
                    
                    if(![testFormat isEqualToString:@"jpg"] && ![testFormat isEqualToString:@"png"] && ![testFormat isEqualToString:@"bmp"] && ![testFormat isEqualToString:@"gif"])
                    {
                        imageUrl=@"";
                        urlAlreadyGet=FALSE;
                    }
                }
                @catch (NSException *exception) {
                    urlAlreadyGet=FALSE;
                    imageUrl=@"";
                }
            }
            else
            {
                pageContent=[pageContent stringByAppendingString:thisPara];
                
                [scanner scanUpToString:@">" intoString:NULL];
                [scanner scanString:@">" intoString:NULL];
                pageContent=[pageContent stringByAppendingString:@" "];
            }
        }
        else
        {
            pageContent=[pageContent stringByAppendingString:thisPara];
            
            [scanner scanUpToString:@">" intoString:NULL];
            [scanner scanString:@">" intoString:NULL];
            pageContent=[pageContent stringByAppendingString:@" "];
        }
    }
    
    [returnResult addObject:pageContent];
    [returnResult addObject:imageUrl];
    
    return returnResult;
}

+(NSString *)extractFromP: (NSString *) rawText
{
    NSScanner *scanner=[NSScanner scannerWithString:rawText];
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
    
    pageContent=[self replaceHTMLSpecialCharFromString:pageContent];
    
    return pageContent;
}

+(NSString *)replaceHTMLSpecialCharFromString:(NSString *) rawText
{
    NSUInteger ampIndex = [rawText rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return rawText;
    }
    
    // Make result string with some extra capacity.
    NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:rawText];
    
    [scanner setCharactersToBeSkipped:nil];
    
    //NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString=[[NSString alloc] init];
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            break;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&lsquo;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&rsquo;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&ldquo;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&rdquo;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&frasl;" intoString:NULL])
            [result appendString:@"/"];
        else if ([scanner scanString:@"&ndash;" intoString:NULL])
            [result appendString:@"-"];
        else if ([scanner scanString:@"&mdash;" intoString:NULL])
            [result appendString:@"-"];
        
        /*
         else if ([scanner scanString:@"&#" intoString:NULL]) {
         BOOL gotNumber;
         unsigned charCode;
         NSString *xForHex = @"";
         
         // Is it hex or decimal?
         if ([scanner scanString:@"x" intoString:&xForHex]) {
         gotNumber = [scanner scanHexInt:&charCode];
         }
         else {
         gotNumber = [scanner scanInt:(int*)&charCode];
         }
         
         if (gotNumber) {
         [result appendFormat:@"%C", charCode];
         
         [scanner scanString:@";" intoString:NULL];
         }
         else {
         NSString *unknownEntity = @"";
         
         [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
         
         
         [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
         
         //[scanner scanUpToString:@";" intoString:&unknownEntity];
         //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
         NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
         
         }
         
         }
         */
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
    
    return result;
}
@end
