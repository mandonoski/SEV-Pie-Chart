//
//  XMLParserDelegate.h
//  XMLParsing
//
//  Created by Spire Jankulovski on 4/9/13.
//  Copyright (c) 2013 Spire. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Row;
@interface XMLParserDelegate : NSObject
{
    NSMutableString *currentElementValue;
    // user object
    Row *row;
    // array of user objects
    NSMutableArray *rows;
    NSMutableDictionary *rowValues;
}
@property (nonatomic, strong) Row *row;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSMutableDictionary *rowValues;

- (XMLParserDelegate *) initXMLParser;
@end
