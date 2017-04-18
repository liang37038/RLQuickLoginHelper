//
//  RLQuickLoginHelper.m
//  RLQuickLoginHelperDemo
//
//  Created by Richard Liang on 2017/4/18.
//
//

#import "RLQuickLoginHelper.h"
@interface RLQuickLoginHelper ()

@property (strong, nonatomic) NSMutableArray *accountDictsArray;

@property (strong, nonatomic) UIAlertController *alertController;

@property (weak, nonatomic) id<RLQuickLoginHelperDelegate>loginDelegate;

@end


@implementation RLQuickLoginHelper

+ (RLQuickLoginHelper *)sharedHelper{
    static RLQuickLoginHelper *_shareViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareViewController = [[RLQuickLoginHelper alloc]initWithStyle:UITableViewStylePlain];
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

- (void)showInLoginViewController:(UIViewController<RLQuickLoginHelperDelegate>*)delegate{
    self.loginDelegate = delegate;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.accountDictsArray = [[userDefault arrayForKey:AccountDictsArray] mutableCopy];
    if (self.accountDictsArray.count > 0) {
        UIViewController *vc = (UIViewController *)delegate;
        [vc presentViewController:self.alertController animated:YES completion:nil];
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
    
    NSString *accountName = [accountDict objectForKey:AccountName];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", accountName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGSize)preferredContentSize{
    if (self.tableView.contentSize.height > 2/3 * [UIScreen mainScreen].bounds.size.width) {
        return CGSizeMake(self.tableView.contentSize.width, [UIScreen mainScreen].bounds.size.width * 2/3);
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
