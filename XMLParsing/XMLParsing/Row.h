//
//  Row.h
//  XMLParsing
//
//  Created by Spire Jankulovski on 4/9/13.
//  Copyright (c) 2013 Spire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Row : NSObject{
    
    NSString *tiden;
    NSString *vatn;
    NSString *olja;
    NSString *vindur;
}
@property (nonatomic, strong)    NSString *tiden;
@property (nonatomic, strong)    NSString *vatn;
@property (nonatomic, strong)    NSString *olja;
@property (nonatomic, strong)    NSString *vindur;

@end
