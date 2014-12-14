//
//  RootViewController.m
//  MSCDemo
//
//  Created by iflytek on 13-6-6.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "RootViewController.h"
#import "ISRViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Definition.h"
#import "PopupView.h"


@implementation RootViewController


/*
 Demo的主界面功能定义，具体内容介绍可以参考readme.txt介绍
 */
- (instancetype) init
{
    self = [super init];

    //demo支持的功能集合
    _functions = @[@"语音听写"];
    
    self.view.backgroundColor = [UIColor whiteColor];

    //adjust the UI for iOS 7
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
     if ( IOS7_OR_LATER )
     {
         self.edgesForExtendedLayout = UIRectEdgeNone;
         self.extendedLayoutIncludesOpaqueBars = NO;
         self.modalPresentationCapturesStatusBarAppearance = NO;
         self.navigationController.navigationBar.translucent = NO;
     }
    #endif

    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Margin , self.view.frame.size.width, self.view.frame.size.height- Margin*8) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.scrollEnabled = YES;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    UIColor * bkColor = [UIButton appearance].backgroundColor;
    _popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 300, 0, 0)];
    [UIButton appearance].tintColor = [UIColor whiteColor];
    [UIButton appearance].backgroundColor = [UIColor colorWithRed:28/255.0f green:160/255.0f blue:170/255.0f alpha:1.0];
      [[UIButton appearanceWhenContainedIn:[RootViewController class], nil] setBackgroundColor: bkColor];
    [[UIButton appearanceWhenContainedIn:[UIActionSheet class], nil] setBackgroundColor: bkColor];
    [UINavigationBar appearance].tintColor =[UIColor colorWithRed:28/255.0f green:160/255.0f blue:170/255.0f alpha:1.0];

    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_functions objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell ;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //语音听写
            ISRViewController * isr = [[ISRViewController alloc]init];
            [self.navigationController pushViewController:isr animated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
