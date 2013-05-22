//
//  XMLParsingFirst.m
//  SevPieChart
//
//  Created by Martin Andonovski on 5/8/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "XMLParsingFirst.h"
#import "XMLParsingAppDelegate.h"
@implementation XMLParsingFirst
@synthesize rows,rowValues;


- (XMLParsingFirst *) initXMLParser {
    
    self = [super init];
    XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.attrArray = [[NSMutableArray alloc] init];
    appDelegate.nameArray = [[NSMutableArray alloc] init];
    xmlParserCounter=1;
    
    return self;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];

    if ([elementName isEqualToString:@"field"]) {
        NSLog(@"user element found – create a new instance of Row class...");
        //row = [[Row alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        [appDelegate.attrArray addObject: [attributeDict objectForKey:@"colorRGB"]];
    }
        if ([elementName isEqualToString:@"message"] ) {
            NSString *from = [attributeDict objectForKey:@"from"];
            NSString *to   = [attributeDict objectForKey:@"to"];
            NSString *fromTo = [[NSString stringWithFormat:@"%@;%@", from, to] init];
            fromTo = [fromTo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            fromTo = [fromTo stringByReplacingOccurrencesOfString:@":" withString:@""];
            fromTo = [fromTo stringByReplacingOccurrencesOfString:@" " withString:@""];
            [appDelegate.fromToArray addObject:fromTo];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
    // NSLog(@"Processing value for : %@", string);
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];

    if ([elementName isEqualToString:@"appSettings"]) {
        // We reached the end of the XML document
        return;
    }
    
    if([elementName isEqualToString:@"message"]){
        NSString *messageStr = [currentElementValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        messageStr = [messageStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [appDelegate.messages addObject:messageStr];
    }

    
    if ([elementName isEqualToString:@"dataFields"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
        // [rows addObject:row];
        // release user object
    }
    else if(![elementName isEqualToString:@"message"] && ![elementName isEqualToString:@"messages"]){
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        NSString *parcedStr = [currentElementValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        parcedStr = [parcedStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [appDelegate.nameArray addObject:parcedStr];
    }
    
    currentElementValue = nil;
}
@end
