//
//  XMLParserDelegate.m
//  XMLParsing
//
//  Created by Martin Andonovski on 4/9/13.
//  Copyright (c) 2013 Мartin. All rights reserved.
//

#import "XMLParserDelegate.h"
#import "XMLParsingAppDelegate.h"
@implementation XMLParserDelegate
@synthesize row,rows,rowValues;


- (XMLParserDelegate *) initXMLParser {
    
    self = [super init];
    // init array of user objects
    rows = [[NSMutableArray alloc] init];
    rowValues = [NSMutableDictionary dictionary];

    return self;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"Row"]) {
        NSLog(@"user element found – create a new instance of Row class...");
        //row = [[Row alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // row.att = [[attributeDict objectForKey:@"<att name>"] ...];
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

    if ([elementName isEqualToString:@"Root"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"Row"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
       // [rows addObject:row];
        // release user object
        row = nil;
    }
    for(NSString *name in appDelegate.nameArray){

        
        if ([elementName isEqualToString:name]) {
            
            // The parser hit one of the element values.
            // This syntax is possible because User object
            // property names match the XML user element names
            [rowValues setObject:currentElementValue forKey:elementName];
            NSLog(@"%@",rowValues);
        }
        
    }
    

    
    currentElementValue = nil;
}

@end
