# RLQuickLoginHelper
####A tool which helps you remember and switch accounts during debuging your app

---

**Take a look at a GIF**

![](https://media.giphy.com/media/3og0IP9WqVb9XaRXnG/giphy.gif)

---

**How to use?**

STEP 1:

> Initial and show this QuickLoginHelper in viewDidAppear:

```
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.loginHelper = [RLQuickLoginHelper sharedHelper];
    [self.loginHelper showInLoginViewController:self];
}
```

> Please do not do these in viewWillAppear:

STEP 2:

> Impelement RLQuickLoginHelperDelegate in order to retrieve account and password from QuickLoginHelper

```
#pragma mark - RLQuickLoginHelperDelegate

- (void)didSelectedAccountDict:(NSDictionary *)accountDict{
    NSString *account = [accountDict objectForKey:AccountName];
    NSString *password = [accountDict objectForKey:AccountPasswd];
    self.accountTextField.text = account;
    self.passwordTextField.text = password;
    // Write your login logic !!!
}
```

STEP 3:
> Don't forget to save your new account and new password in RLQuickLoginHelper after a successfully login

```
[self.loginHelper saveLoginHistoryWithAccount:account password:password];
```

