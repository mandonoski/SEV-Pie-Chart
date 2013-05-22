//
//  XMLParsingAppDelegate.h
//  XMLParsing
//
//  Created by Spire Jankulovski on 4/9/13.
//  Copyright (c) 2013 Spire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMLParsingViewController;

@interface XMLParsingAppDelegate : UIResponder <UIApplicationDelegate>{
    int *sleepCounter;
}

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *loading;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (strong, nonatomic) XMLParsingViewController *viewController;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (strong, nonatomic) NSMutableArray *attrArray;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *fromToArray;
 
@end
