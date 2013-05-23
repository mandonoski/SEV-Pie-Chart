//
//  XMLParsingViewController.h
//  XMLParsing
//
//  Created by Spire Jankulovski on 4/9/13.
//  Copyright (c) 2013 Spire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface XMLParsingViewController : UIViewController<CPTPieChartDataSource, NSXMLParserDelegate>{
	CPTXYGraph * graph;
	NSMutableArray *pieData;
    NSMutableArray *valueArr;
    NSMutableArray *keyArr;
    NSMutableArray *pieColorArr;
    UIDatePicker *datePicker;
    UIView *datePickerView;
    NSString *dateString;
    float red;
    float green;
    float blue;
    int testVariable;
    int hashIndex;
    int countNumber;
}

@property(readwrite, retain, nonatomic) NSMutableArray *pieData;
@property (nonatomic,retain) CPTXYGraph * graph;
@property (strong, nonatomic) NSArray *arrayForLegend;

-(void)reachabilityChanged:(NSNotification*)note;

- (void) doParse:(NSData *)data;
-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index;
-(void)initFunction;
-(void)netAlert;
-(void)onBtnDatePickerSave:(id)sender;
-(void)onBtnOpenDatePicker:(id)sender;
@end
