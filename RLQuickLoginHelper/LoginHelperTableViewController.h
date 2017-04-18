//
//  LoginHelperTableViewController
//  qingxun
//
//  Created by Richard Liang on 16/2/16.
//
//

#import <UIKit/UIKit.h>

#define AccountName         @"accountName"
#define AccountPasswd       @"accountPasswd"
#define AccountDictsArray   @"accountDictsArray"

@protocol LoginHelperDelegate <NSObject>

- (void)didSelectedAccountDict:(NSDictionary *)accountDict;

@end

@interface LoginHelperTableViewController : UITableViewController

+ (LoginHelperTableViewController *)shareViewController;

- (void)saveLoginHistoryWithAccount:(NSString *)account password:(NSString *)password;

- (void)showInLoginViewController:(id<LoginHelperDelegate>)delegate;

- (void)dismiss;

@end

