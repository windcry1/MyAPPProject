//
//  MAMyPageViewController.m
//  MyAPPProject
//
//  Created by 俞昊 on 2024/4/24.
//

#import "MAMyPageViewController.h"
#import "MAHelper.h"
#import <Masonry/Masonry.h>

@interface MAMyPageViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *APIKeyTextField;
@property (nonatomic, strong) UILabel *APIKeyLabel;
@property (nonatomic, strong) UIAlertController *alertVC;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation MAMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap1];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.APIKeyLabel];
    [self.view addSubview:self.APIKeyTextField];
    [self.view addSubview:self.saveButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"APIKey"]) {
        [self.APIKeyTextField setText:[userdefaults objectForKey:@"APIKey"]];
    }
    [self layout];
}

- (void)layout {
    [self.APIKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.right.mas_lessThanOrEqualTo(self.APIKeyTextField.mas_left).offset(-5);
        make.top.equalTo(self.view).offset(150);
        make.height.mas_equalTo(40);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    [self.APIKeyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.APIKeyLabel.mas_right).offset(5);
        make.width.mas_greaterThanOrEqualTo(100);
        make.top.equalTo(self.view).offset(150);
        make.right.equalTo(self.saveButton.mas_left).offset(-5);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
        make.top.equalTo(self.view).offset(150);
    }];
}
#pragma mark - Getters and Setters

- (UITextField *)APIKeyTextField {
    if (!_APIKeyTextField) {
        _APIKeyTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _APIKeyTextField.placeholder = @"Config your APIKey Here!";
        _APIKeyTextField.enabled = YES;
        _APIKeyTextField.secureTextEntry = YES;
        _APIKeyTextField.delegate = self;
        _APIKeyTextField.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    }
    return _APIKeyTextField;
}

- (UILabel *) APIKeyLabel {
    if (!_APIKeyLabel) {
        _APIKeyLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _APIKeyLabel.text = @"API Key:";
        _APIKeyLabel.textColor = [UIColor blackColor];
    }
    return _APIKeyLabel;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton setBackgroundColor:[UIColor lightGrayColor]];
        _saveButton.enabled = YES;
        [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

#pragma mark - actions

- (void)endEditing:(id)sender {
    [self.APIKeyTextField endEditing:YES];
}

- (void)saveButtonClicked:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.APIKeyTextField.text forKey:@"APIKey"];
    [self endEditing:sender];
    [self presentViewController:self.alertVC animated:YES completion:nil];
}

- (UIAlertController *)alertVC {
    if (!_alertVC) {
        _alertVC = [UIAlertController alertControllerWithTitle:@"Save Success" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertVC addAction:sureBtn];
    }
    return _alertVC;
}

// You can get your API Key on Website https://www.juhe.cn/

@end
