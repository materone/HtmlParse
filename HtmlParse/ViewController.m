//
//  ViewController.m
//  HtmlParse
//
//  Created by tony on 13-12-6.
//  Copyright (c) 2013年 rd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize txtResult;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)parse:(id)sender {
    NSLog(@"This is a test");
    NSString *fPath=[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSLog(@"%@",fPath);
    NSData *data = [NSData dataWithContentsOfFile:fPath];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *searchResult = [doc searchWithXPathQuery:@"//a[@class='sponsor']"];
    if (searchResult.count > 0) {        
        TFHppleElement *elem = [searchResult objectAtIndex:0];
        NSLog(@"Text:%@ :%@ :%@ :%@ ",[elem text],[elem tagName] ,[[elem attributes] objectForKey:@"class"],[elem objectForKey:@"href"]);
    }
    
    //do a web req
    NSURL *url = [NSURL URLWithString:@"http://www.szairport.com/frontapp/HbxxServlet"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"flag=HBH";//设置参数
    [str stringByAppendingString:@"&hbxx_hbh=CZ3575"];
    [str stringByAppendingString:@"&AD_COOKIE=20111134"];
    [str stringByAppendingString:@"&JSESSIONID=964615E160EAB821E55BF031FC0FD3AA"];
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    //
    txtResult.text = str1;
    NSLog(@"Result:%@",str1);
}
@end
