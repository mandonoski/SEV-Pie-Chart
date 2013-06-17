//
//  XMLParsingViewController.m
//  XMLParsing
//
//  Created by Martin Andonovski on 4/9/13.
//  Copyright (c) 2013 Мartin. All rights reserved.
//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define SETTING_URL ""

#import "XMLParsingViewController.h"
#import "XMLParsingAppDelegate.h"
#import "XMLParsingFirst.h"
#import "XMLParserDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CorePlot-CocoaTouch.h"
#import "CPTLegend.h"
#import "Reachability.h"
#import "Constants.h"
@implementation XMLParsingViewController

@synthesize graph,pieData;

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"header.png"];
    [image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)initFunction{
    
    NSURL *url = [NSURL URLWithString:XML_WITH_COLORS_AND_MESSAGES];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData* xmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    valueArr = [NSMutableArray array];
    keyArr = [NSMutableArray array];
    
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // create and init our delegate
    XMLParsingFirst *parser = [[XMLParsingFirst alloc] initXMLParser];
    testVariable=0;
    // set delegate
    [nsXmlParser setDelegate:parser];
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
        
        NSURL *url = [NSURL URLWithString:XML_WITH_VALUES];
        NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData* mainXmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
        [self doParse:mainXmlData];
    }


}
-(void)searchByDate{
    
    NSString *tempStr = [NSString stringWithFormat:XML_WITH_FROM_DATE,dateString];
    NSURL *url = [NSURL URLWithString:tempStr];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
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
-(void)createBottomLegend{
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    theLegend.numberOfColumns = 2;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottom;
    graph.legendDisplacement = CGPointMake(0.0, 30.0);
}

//Allert method called if their are no internet connection
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
    //Check internet connection with www.google.com
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
    }
    else
    {
        [self netAlert];
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
-(void)callAlertMessage{
    if(countNumber==0){
        XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
        someTextView.backgroundColor = [UIColor clearColor];
        someTextView.textColor = [UIColor whiteColor];
        someTextView.editable = NO;
        someTextView.font = [UIFont systemFontOfSize:15];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *todayString = [formatter stringFromDate:[NSDate date]];
        
        for (int i=0; i<[appDelegate.fromToArray count]; i++) {
            NSArray *separateTime = [appDelegate.fromToArray[i] componentsSeparatedByString:@";"];
            if([separateTime[0] doubleValue]<=[todayString doubleValue] && [separateTime[1] doubleValue]>=[todayString doubleValue]){
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
}

-(void)createGraph{
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
    [graph addPlot:pieChart];
}

-(void) setButtonsAndInicializeGraph{
    
    XMLParserDelegate *parser = [[XMLParserDelegate alloc] initXMLParser];

    graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostingView.hostedGraph = graph;
    
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
    
    if (IS_IPHONE5) {        [buttonLeita setFrame:CGRectMake(5, 445, 66, 34)];
        [buttonBeint setFrame:CGRectMake(75, 445, 66, 34)];
    }else{        [buttonLeita setFrame:CGRectMake(5, 360, 66, 34)];
        [buttonBeint setFrame:CGRectMake(75, 360, 66, 34)];
    }
    
    [self.view addSubview:buttonLeita];
    [self.view addSubview:buttonBeint];
    
}

-(void)setDatePicker{
    datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 260)];
    [datePickerView setBackgroundColor:[UIColor whiteColor]];
    datePickerView.transform = CGAffineTransformMakeScale(1, -1);
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePickerView addSubview:datePicker];
}

-(void)setSaveButton{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.backgroundColor = [UIColor clearColor];
    [[saveButton titleLabel]setFont:[UIFont fontWithName:@"ArialMT" size:18]];
    [saveButton setTitle:@"Leita" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(onBtnDatePickerSave:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveButton setFrame:CGRectMake(110, 223, 110, 34)];
    [datePickerView addSubview:saveButton];
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
    
    if (success) {
        
        [self callAlertMessage];
        [self setButtonsAndInicializeGraph];
        [self setDatePicker];
        [self setSaveButton];
        UIButton *buttonDisplay = [[UIButton alloc] init];
        buttonDisplay.backgroundColor = [UIColor clearColor];
        [[buttonDisplay titleLabel]setFont:[UIFont fontWithName:@"ArialMT" size:16]];
        
        NSString *today = [parser.rowValues objectForKey:@"tiden"];
        today = [today stringByReplacingOccurrencesOfString:@"  " withString:@""];
        [buttonDisplay setTitle:today  forState:UIControlStateNormal];
        [buttonDisplay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buttonDisplay.transform = CGAffineTransformMakeScale(1, -1);
        if (IS_IPHONE5)
            [buttonDisplay setFrame:CGRectMake(145, 310, 190, 300)];
        else
            [buttonDisplay setFrame:CGRectMake(145, 230, 190, 300)];
        [buttonDisplay setHidden:NO];
        [self.view addSubview:buttonDisplay];
        XMLParsingAppDelegate *appDelegate = (XMLParsingAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [self.view addSubview:datePickerView];
        [datePickerView setHidden:YES];
        [self createGraph];
        [parser.rowValues removeObjectForKey:@"tiden"];
        
        self.pieData =  [NSMutableArray array];
        
        for (NSString *key in parser.rowValues) {
            NSString *value = [parser.rowValues objectForKey:key];
        
            NSString *newString = [[value componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
           
            [valueArr addObject:newString];
            [keyArr addObject:key];
        }
        keyArr = [NSMutableArray arrayWithArray:appDelegate.nameArray];
        [keyArr removeObjectAtIndex:0];
        keyArr = [NSMutableArray arrayWithArray:[[keyArr reverseObjectEnumerator] allObjects]];
        
        
        [appDelegate.valueArray removeObjectAtIndex:0];
        appDelegate.valueArray = [NSMutableArray arrayWithArray:[[appDelegate.valueArray reverseObjectEnumerator] allObjects]];
        self.arrayForLegend = [NSArray arrayWithArray:appDelegate.valueArray];
        for (NSString *_number in appDelegate.valueArray) {
            
            NSString *stringValue = [_number stringByReplacingOccurrencesOfString:@"," withString:@"."];
            float floatValue = [stringValue floatValue];
            int intNumber = lroundf(floatValue);
            NSNumber *rightNumber = [NSNumber numberWithInt:intNumber];
            [self.pieData addObject:rightNumber];
            
        }
        
        //valueArr = self.pieData;
        
        
        [self createBottomLegend];
        [appDelegate.valueArray removeAllObjects];
        if(SYSTEM_VERSION_EQUAL_TO(@"5.0")){
        appDelegate.window.hidden = YES;
        appDelegate.window.hidden = NO;
        }
        
        


                
    } else {
        NSLog(@"Error parsing document!");
    }
}

//Text for the Legend under the Pie Chart
-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index{
    
    float percents = [[[self.arrayForLegend objectAtIndex:index] stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    
    NSString *returnString = [NSString stringWithFormat:@"%@ - %.01f %%",[keyArr objectAtIndex:index],percents];
    return returnString;
}

//Colors for the slices in the Pie Chart, this are changed in the "pieColorArr" in viewDidLoad
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index{

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
    
    return [CPTFill fillWithColor:your_color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
