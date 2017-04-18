//
//  QXLoginHelperTableViewController.m
//  qingxun
//
//  Created by Richard Liang on 16/2/16.
//
//

#import "LoginHelperTableViewController.h"
@interface LoginHelperTableViewController ()

@property (strong, nonatomic) NSMutableArray *accountDictsArray;

@property (strong, nonatomic) UIAlertController *alertController;

@property (weak, nonatomic) id<LoginHelperDelegate>loginDelegate;

@end


@implementation LoginHelperTableViewController

+ (LoginHelperTableViewController *)shareViewController{
    static LoginHelperTableViewController *_shareViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareViewController = [[LoginHelperTableViewController alloc]initWithStyle:UITableViewStylePlain];
    });
    [_shareViewController loadDefaultData];
    return _shareViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LoginCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDefaultData{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.accountDictsArray = [[userDefault arrayForKey:AccountDictsArray] mutableCopy];
    if (!self.accountDictsArray || self.accountDictsArray.count == 0) {
//
//        NSDictionary *student1 = @{
//                                 AccountName:@"18520229661",
//                                 AccountPasswd:@"123456",
//                                 };
//        NSDictionary *coach2 = @{
//                                 AccountName:@"mason@ganguo.hk",
//                                 AccountPasswd:@"123456",
//                                 };
//        NSDictionary *coach3 = @{
//                                 AccountName:@"admin@ganguo.hk",
//                                 AccountPasswd:@"123456",
//                                 };

        self.accountDictsArray = [NSMutableArray array];
        [userDefault setObject:[self.accountDictsArray mutableCopy] forKey:AccountDictsArray];
    }
    [self.tableView reloadData];
}

- (void)saveLoginHistoryWithAccount:(NSString *)account password:(NSString *)password{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *accountDictsArray = [[userDefault arrayForKey:AccountDictsArray] mutableCopy];
    if (accountDictsArray) {
        NSDictionary *existedAccountDict;
        for (NSDictionary *accountDict in accountDictsArray) {
            NSString *accountName = [accountDict objectForKey:AccountName];
            if ([accountName isEqualToString:account]) {
                existedAccountDict = accountDict;
            }
        }
        if (existedAccountDict) {
            [accountDictsArray removeObject:existedAccountDict];
        }
        NSDictionary *newAccountDict = @{
                                         AccountName:account,
                                        AccountPasswd:password
                                             };
        [accountDictsArray addObject:newAccountDict];
    }else{
        accountDictsArray = [NSMutableArray array];
        NSDictionary *newAccountDict = @{
                                         AccountName:account,
                                         AccountPasswd:password
                                         };
        [accountDictsArray addObject:newAccountDict];
    }
    [userDefault setObject:accountDictsArray forKey:AccountDictsArray];
    [userDefault synchronize];
}

- (void)showInLoginViewController:(id<LoginHelperDelegate>)delegate{
    self.loginDelegate = delegate;
    if ([delegate isKindOfClass:[UIViewController class]]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        self.accountDictsArray = [[userDefault arrayForKey:AccountDictsArray] mutableCopy];
        if (self.accountDictsArray.count > 0) {
            UIViewController *vc = (UIViewController *)delegate;
            [vc presentViewController:self.alertController animated:YES completion:nil];
        }
    }
}

- (void)dismiss{
    if ([self.loginDelegate isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)self.loginDelegate;
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountDictsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginCell" forIndexPath:indexPath];
    NSDictionary *accountDict = [self.accountDictsArray objectAtIndex:indexPath.row];
    
    NSString *accountName = STRING_OR_EMPTY([accountDict objectForKey:AccountName]);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", accountName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGSize)preferredContentSize{
    if (self.tableView.contentSize.height > 2/3 * SCREEN_HEIGHT) {
        return CGSizeMake(self.tableView.contentSize.width, SCREEN_HEIGHT * 2/3);
    }
    return self.tableView.contentSize;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *accountDict = [self.accountDictsArray objectAtIndex:indexPath.row];
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(didSelectedAccountDict:)]) {
        [self.loginDelegate didSelectedAccountDict:accountDict];
    }
    [self dismiss];
}

#pragma mark - Getter

- (UIAlertController *)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"快速登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alertController addAction:cancelAction];
        [_alertController setValue:self forKey:@"contentViewController"];
    }
    return _alertController;
}

- (NSMutableArray *)accountDictsArray{
    if (!_accountDictsArray) {
        _accountDictsArray = [[NSMutableArray alloc]init];
    }
    return _accountDictsArray;
}


@end
