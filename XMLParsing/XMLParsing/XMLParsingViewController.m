//
//  XMLParsingViewController.m
//  XMLParsing
//
//  Created by Martin Andonovski on 4/9/13.
//  Copyright (c) 2013 Spire. All rights reserved.
//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#import "XMLParsingViewController.h"
#import "XMLParsingAppDelegate.h"
#import "XMLParsingFirst.h"
#import "XMLParserDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CorePlot-CocoaTouch.h"
#import "CPTLegend.h"
#import "Reachability.h"

@interface XMLParsingViewController ()

@end

@implementation XMLParsingViewController

@synthesize graph,pieData;
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"header.png"];
    [image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
- (NSString *) platformString {
    // Gets a string with the device model
    size_t size;
    countNumber=0;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    hashIndex=0;
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"5";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"5";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"51";
    
    return platform;
}
-(void)initFunction{
    NSURL *url = [NSURL URLWithString:@"https://w3.sev.fo/hagtol/xml/pie_app_def.xml"];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //Test srting
    //NSString *content = [NSString stringWithFormat:@"<appSettings><timestampField>tiden</timestampField><dataFields><field colorHex=\"FF0000\" colorRGB=\"1,0,0\">Vatn</field><field colorHex=\"00FF00\" colorRGB=\"0,1,0\">Olja</field><field colorHex=\"0000FF\" colorRGB=\"0,0,1\">Vindur</field></dataFields></appSettings>"];
    
    NSData* xmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
    valueArr = [NSMutableArray array];
    keyArr = [NSMutableArray array];
    
    //[self doParse:xmlData];
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // create and init our delegate
    XMLParsingFirst *parser = [[XMLParsingFirst alloc] initXMLParser];
    testVariable=0;
    // set delegate
    [nsXmlParser setDelegate:parser];
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
        
        NSURL *url = [NSURL URLWithString:@"https://w3.sev.fo/hagtol/xml/fordeiling.xml"];
        NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        //Test srting
  
        NSData* mainXmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
        [self doParse:mainXmlData];
        
    }


}
-(void)searchByDate{
    
    NSString *tempStr = [NSString stringWithFormat:@"https://w3.sev.fo/hagtol/xml/fordeiling.aspx?from=%@",dateString];
    NSURL *url = [NSURL URLWithString:tempStr];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //Test srting
    
    
    NSData* xmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
    valueArr = [NSMutableArray array];
    keyArr = [NSMutableArray array];
    
    [self doParse:xmlData];
}


-(void)onBtnOpenDatePicker:(id)sender{

    NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
    [inputFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *inputDate = [inputFormat dateFromString: @"2007-01-19"];
    [datePickerView setHidden:NO];
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setMinimumDate:inputDate];
}
-(void)onBtnDatePickerSave:(id)sender{

    NSDate *localDate = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    dateString = [dateFormatter stringFromDate: localDate];
    [datePickerView setHidden:YES];
    [self searchByDate];
}

-(void)netAlert{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"No Internet"];
    [alert setMessage:@"Eitt óvæntað brek hendi"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"";
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                       
            [self initFunction];
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self netAlert];
        
        });
    };
    
    [reach startNotifier];
   
}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        [self initFunction];
        //notificationLabel.text = @"Notification Says Reachable";
    }
    else
    {
        [self netAlert];
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	return [self.pieData objectAtIndex:index];
}
- (void)loadView {

	CPTGraphHostingView * newView = [[CPTGraphHostingView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = newView;
}
- (void) doParse:(NSData *)data {
    
    // create and init NSXMLParser object
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
    
    // create and init our delegate
    XMLParserDelegate *parser = [[XMLParserDelegate alloc] initXMLParser];
    
    // set delegate
    [nsXmlParser setDelegate:parser];
    
    // parsing...
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
       // NSLog(@"No errors - user count : %i", [[parser rows] count]);
        
        graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
        CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
        hostingView.hostedGraph = graph;
        
        UIButton *buttonDisplay = [[UIButton alloc] init];
        buttonDisplay.backgroundColor = [UIColor clearColor];
        [[buttonDisplay titleLabel]setFont:[UIFont fontWithName:@"ArialMT" size:16]];
        
        //set time and date for past days and for current day
        NSString *today = [parser.rowValues objectForKey:@"tiden"];
        today = [today stringByReplacingOccurrencesOfString:@"  " withString:@""];
        [buttonDisplay setTitle:today forState:UIControlStateNormal];
        [buttonDisplay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buttonDisplay.transform = CGAffineTransformMakeScale(1, -1);
        
        UIButton *buttonLeita = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonLeita setImage:[UIImage imageNamed:@"Leita.png"] forState:UIControlStateNormal];
        [buttonLeita addTarget:self action:@selector(onBtnOpenDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [buttonLeita setFrame:CGRectMake(5, 360, 66, 34)];
        buttonLeita.transform = CGAffineTransformMakeScale(1, -1);
        
        UIButton *buttonBeint = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonBeint setImage:[UIImage imageNamed:@"Beint.png"] forState:UIControlStateNormal];
        [buttonBeint addTarget:self action:@selector(initFunction) forControlEvents:UIControlEventTouchUpInside];
        [buttonBeint setFrame:CGRectMake(75, 230, 66, 34)];
        buttonBeint.transform = CGAffineTransformMakeScale(1, -1);
        
        datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 260)];
        [datePickerView setBackgroundColor:[UIColor whiteColor]];
        datePickerView.transform = CGAffineTransformMakeScale(1, -1);

        datePicker = [[UIDatePicker alloc]init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePickerView addSubview:datePicker];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveButton.backgroundColor = [UIColor clearColor];
        [[saveButton titleLabel]setFont:[UIFont fontWithName:@"ArialMT" size:18]];
        [saveButton setTitle:@"Leita" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(onBtnDatePickerSave:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saveButton setFrame:CGRectMake(110, 223, 110, 34)];
        
        [datePickerView addSubview:saveButton];
        XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        if (IS_IPHONE5) {
            [buttonDisplay setFrame:CGRectMake(145, 310, 190, 300)];
            [buttonLeita setFrame:CGRectMake(5, 445, 66, 34)];
            [buttonBeint setFrame:CGRectMake(75, 445, 66, 34)];
        }else{
            [buttonDisplay setFrame:CGRectMake(145, 230, 190, 300)];
            [buttonLeita setFrame:CGRectMake(5, 360, 66, 34)];
            [buttonBeint setFrame:CGRectMake(75, 360, 66, 34)];
        }
        [self.view addSubview:buttonDisplay];
        [self.view addSubview:buttonLeita];
        [self.view addSubview:buttonBeint];
        [self.view addSubview:datePickerView];
        [datePickerView setHidden:YES];
        
        graph.paddingLeft   = 10.0;
        graph.paddingTop    = -30.0;
        graph.paddingRight  = 10.0;
        graph.paddingBottom = 10.0;
        
        graph.axisSet = nil;

        CPTPieChart *pieChart = [[CPTPieChart alloc] init];
        pieChart.dataSource = self;
        pieChart.pieRadius = 120.0;
        pieChart.identifier = @"PieChart1";
        pieChart.startAngle = M_PI_2;
        pieChart.sliceDirection = CPTPieDirectionCounterClockwise;
        pieChart.labelOffset = 5;
                
        CPTColor *your_color = [CPTColor whiteColor];
        graph.fill = [CPTFill fillWithColor:your_color];
                
        [parser.rowValues removeObjectForKey:@"tiden"];
        
        self.pieData =  [NSMutableArray array];
        
        for (NSString *key in parser.rowValues) {
            NSString *value = [parser.rowValues objectForKey:key];
        
            NSString *newString = [[value componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
           
            [valueArr addObject:newString];
            [keyArr addObject:key];
        }
        
        for (NSString *_number in valueArr) {
            
            NSString *stringValue = [_number stringByReplacingOccurrencesOfString:@"," withString:@"."];
            
            float floatValue = [stringValue floatValue];
            int intNumber = lroundf(floatValue);
            NSNumber *rightNumber = [NSNumber numberWithInt:intNumber];
            [self.pieData addObject:rightNumber];
            
        }
        
        valueArr = self.pieData;
        
        [graph addPlot:pieChart];
        CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
        theLegend.numberOfColumns = 2;
        theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        theLegend.borderLineStyle = [CPTLineStyle lineStyle];
        theLegend.cornerRadius = 5.0;
        
        graph.legend = theLegend;
        graph.legendAnchor = CPTRectAnchorBottom;
        graph.legendDisplacement = CGPointMake(0.0, 30.0);
        
        //XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];
        if(SYSTEM_VERSION_EQUAL_TO(@"5.0")){
        appDelegate.window.hidden = YES;
        appDelegate.window.hidden = NO;
        }
        
        if(countNumber==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Some Title" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
            someTextView.backgroundColor = [UIColor clearColor];
            someTextView.textColor = [UIColor whiteColor];
            someTextView.editable = NO;
            someTextView.font = [UIFont systemFontOfSize:15];
            NSDateFormatter *formatter;
            NSString        *dateString;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            dateString = [formatter stringFromDate:[NSDate date]];
            for (int i=0; i<[appDelegate.fromToArray count]; i++) {
                NSArray *separateTime = [appDelegate.fromToArray[0] componentsSeparatedByString:@";"];
                if([separateTime[0] doubleValue]<=[dateString doubleValue] && [separateTime[1] doubleValue]>=[dateString doubleValue]){
                    someTextView.text = appDelegate.messages[i];
                    [alert addSubview:someTextView];
                    [alert show];
                    break;
                }
                else if(i==[appDelegate.fromToArray count]){
                    break;
                }
            }
            countNumber++;
        }
        
        // Add a rotation animation
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.removedOnCompletion = NO;
        rotation.fillMode = kCAFillModeForwards;
        //rotation.fromValue = [NSNumber numberWithFloat:M_PI*5];
        rotation.toValue = [NSNumber numberWithFloat:0.0f];
        rotation.duration = 0.1f;
        rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        rotation.delegate = self;
        
        [pieChart addAnimation:rotation forKey:@"rotation"];
                
    } else {
        NSLog(@"Error parsing document!");
    }
}

//Labels around the Pie Chart. Set the "pieChart.labelOffset" value to negative to set the labels on the Pie Chart
/*-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
    
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", [keyArr objectAtIndex:index]]];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
   // CPTColor *your_color = [pieColorArr objectAtIndex:index];
    textStyle.color = [CPTColor blackColor];
    label.textStyle = textStyle;

    return label;
}*/
//Text for the Legend under the Pie Chart
-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index{
    
    NSString *returnString = [NSString stringWithFormat:@"%@ - %d%%",[keyArr objectAtIndex:index],[[valueArr objectAtIndex:index]intValue]];
    return returnString;
}
//Colors for the slices in the Pie Chart, this are changed in the "pieColorArr" in viewDidLoad
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index{
    
    //CPTColor *your_color = [pieColorArr objectAtIndex:index];
   // CPTColor *your_color = [CPTPieChart defaultPieSliceColorForIndex:index];

    XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    for (int i=0; i<[keyArr count]; i++) {
        if ([appDelegate.nameArray[index+1] isEqualToString:keyArr[i]]) {
            index=hashIndex;
            hashIndex=0;
            break;
        }
        hashIndex++;
    }
    
    NSString *yourColor = [appDelegate.attrArray objectAtIndex:index];
    NSArray* foo = [yourColor componentsSeparatedByString: @","];
    NSString *collorToConvert = [foo objectAtIndex:0];
    red = [collorToConvert floatValue];
    collorToConvert = [foo objectAtIndex:1];
    green = [collorToConvert floatValue];
    collorToConvert = [foo objectAtIndex:2];
    blue = [collorToConvert floatValue];
    float amountOfRed = red/255.0;
    float amountOfGreen = green/255.0;
    float amountOfBlue = blue/255.0;

    
    CPTColor *your_color = [CPTColor colorWithComponentRed:amountOfRed green:amountOfGreen blue:amountOfBlue alpha:1.0];
    //CPTColor *your_color = [CPTColor colorWithComponentRed:[[foo objectAtIndex: 0] floatValue] green:[[foo objectAtIndex: 1] floatValue] blue:[[foo objectAtIndex: 2] floatValue] alpha:1];
    
    return [CPTFill fillWithColor:your_color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
