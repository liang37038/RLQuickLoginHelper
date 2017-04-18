//
//  ViewController.m
//  RLQuickLoginHelperDemo
//
//  Created by Richard Liang on 2017/4/18.
//  Copyright © 2017年 lwj. All rights reserved.
//

#import "ViewController.h"
#import "RLQuickLoginHelper.h"
#import "MBProgressHUD.h"

@interface ViewController ()<RLQuickLoginHelperDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) RLQuickLoginHelper *loginHelper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.loginHelper = [RLQuickLoginHelper sharedHelper];
    [self.loginHelper showInLoginViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAction:(id)sender {
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    //模拟登陆
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"登陆成功";
        [hud hideAnimated:YES afterDelay:1.0];
        
        [self.loginHelper saveLoginHistoryWithAccount:account password:password];
    });
}

#pragma mark - RLQuickLoginHelperDelegate

- (void)didSelectedAccountDict:(NSDictionary *)accountDict{
    NSString *account = [accountDict objectForKey:AccountName];
    NSString *password = [accountDict objectForKey:AccountPasswd];
    self.accountTextField.text = account;
    self.passwordTextField.text = password;
    [self loginAction:nil];
}

@end
