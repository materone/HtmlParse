//
//  ViewController.h
//  HtmlParse
//
//  Created by tony on 13-12-6.
//  Copyright (c) 2013年 rd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtResult;
- (IBAction)parse:(id)sender;

@end
