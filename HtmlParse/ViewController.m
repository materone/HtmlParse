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
@synthesize sURL;

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
    NSMutableString *msgStr = [[NSMutableString alloc]initWithCapacity:100];
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
    
    //set cookie
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    //JSession Cookie
    [cookieProperties setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"FA2D20B4133D7C14977A64995C041873" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"http://www.szairport.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/frontapp" forKey:NSHTTPCookiePath];
    //AD Cookie
    [cookieProperties setObject:@"AD_COOKIE" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"20111135" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"http://www.szairport.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    if ([sURL.text length] < 1) {
        sURL.text = @"CZ3575";
    }
    NSString *str = [NSString stringWithFormat:@"flag=%@&hbxx_hbh=%@",@"HBH",sURL.text];//设置参数@"CZ3575"
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    //
    //txtResult.text = str1;
    NSData *htmlData = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    searchResult = [doc searchWithXPathQuery:@"//tbody[@id='trs']/tr[@class='even']/td"];
//    NSRange rang;
//    rang.length = msgStr.length;
//    rang.location = 0;
    if (searchResult.count > 0) {
        for (int i = 0; i <searchResult.count; i++) {            
            TFHppleElement *elem = [searchResult objectAtIndex:i];
            [msgStr appendFormat:@"%@|",[elem text]];
            NSLog(@"Text:%@ :%@ :%@",[elem text],[elem tagName] ,[[elem attributes] objectForKey:@"width"]);
            //NSLog(@"Text:%@ :%@ :%@ :%@ ",[elem text],[elem tagName] ,[[elem attributes] objectForKey:@"width"],[elem objectForKey:@"href"]);
        }
    }
    NSInteger iCnt0  = msgStr.length;
    NSInteger iCnt1 = [msgStr replaceOccurrencesOfString:@"\x09" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, msgStr.length)];
    NSInteger iCnt2 = [msgStr replaceOccurrencesOfString:@"\x0D\x0A" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, msgStr.length)];
    NSInteger iCnt3 = [msgStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, msgStr.length)];
    txtResult.text = msgStr;
    NSLog(@"Result:%d  %d  %d  %d  %d",iCnt0,iCnt1,iCnt2,iCnt3,msgStr.length);
}
@end
