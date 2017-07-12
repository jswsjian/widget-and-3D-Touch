//
//  TodayViewController.m
//  widget
//
//  Created by jian huang on 2017/7/11.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation TodayViewController
- (IBAction)actionClick:(id)sender {
    
    [self.extensionContext openURL:[NSURL URLWithString:@"haha://1"] completionHandler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.preferredContentSize = CGSizeMake(0,120);
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh-mm-ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    [self.button setTintColor:[UIColor grayColor]];
    [self.button setTitle:dateStr forState:UIControlStateNormal];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.demo.widget.name"];
    [userDefaults setObject:dateStr forKey:@"nowDate"];
    
    //通过NSFileManager共享数据
    
    NSData *dateData = [dateStr dataUsingEncoding:NSUTF8StringEncoding];
    [self saveDataByNSFileManager:dateData];
    
    completionHandler(NCUpdateResultNewData);
}

-(BOOL)saveDataByNSFileManager:(NSData *)data
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.demo.widget.name"];
    containerURL = [containerURL URLByAppendingPathComponent:@"widget"];
    BOOL result = [data writeToURL:containerURL atomically:YES];
    return result;
}

-(NSData *)readDataByNSFileManager
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.demo.widget.name"];
    containerURL = [containerURL URLByAppendingPathComponent:@"widget"];
    NSData *value = [NSData dataWithContentsOfURL:containerURL];
    return value;
}



-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    switch (activeDisplayMode) {
        case NCWidgetDisplayModeCompact:
            self.preferredContentSize = CGSizeMake(maxSize.width,300);
            break;
        case NCWidgetDisplayModeExpanded:
            self.preferredContentSize = CGSizeMake(maxSize.width,400);
            break;
        default:
            break;
    }
    
}
#endif



@end
