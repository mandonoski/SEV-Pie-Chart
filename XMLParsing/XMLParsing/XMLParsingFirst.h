//
//  XMLParsingFirst.h
//  SevPieChart
//
//  Created by Spire Jankulovski on 5/8/13.
//  Copyright (c) 2013 Spire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParsingFirst : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    // user object
    // array of user objects
    NSMutableArray *rows;
    NSMutableDictionary *rowValues;
    int xmlParserCounter;
}
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSMutableDictionary *rowValues;

- (XMLParsingFirst *) initXMLParser;
@end
