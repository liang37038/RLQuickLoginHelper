//
//  RLQuickLoginHelper.h
//  RLQuickLoginHelperDemo
//
//  Created by Richard Liang on 2017/4/18.
//
//

#import <UIKit/UIKit.h>

#define AccountName         @"accountName"
#define AccountPasswd       @"accountPasswd"
#define AccountDictsArray   @"accountDictsArray"

@protocol RLQuickLoginHelperDelegate <NSObject>


/**
 实现该代理来获取选中的账号和密码

 @param accountDict 包含账号密码的Dict
 */
- (void)didSelectedAccountDict:(NSDictionary *)accountDict;

@end

@interface RLQuickLoginHelper : UITableViewController

+ (RLQuickLoginHelper *)sharedHelper;


/**
 调用该方法保存账号和密码，注意没有对密码进行加密

 @param account 账号
 @param password 密码
 */
- (void)saveLoginHistoryWithAccount:(NSString *)account password:(NSString *)password;


/**
 在某个ViewController上面使用present方式展现RLQuickLoginHelper

 @param delegate 代理
 */
- (void)showInLoginViewController:(UIViewController<RLQuickLoginHelperDelegate>*)delegate;

@end

