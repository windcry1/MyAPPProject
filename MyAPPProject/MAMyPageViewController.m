//
//  MAMyPageViewController.m
//  MyAPPProject
//
//  Created by 俞昊 on 2024/4/24.
//

#import "MAMyPageViewController.h"
#import "MAHelper.h"

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
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"APIKey"]) {
        [self.APIKeyTextField setText:[userdefaults objectForKey:@"APIKey"]];
    }
}

- (UITextField *)APIKeyTextField {
    if (!_APIKeyTextField) {
        _APIKeyTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 150, screenWidth - 140, 40)];
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
        _APIKeyLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 150, 70, 40)];
        _APIKeyLabel.text = @"API Key:";
        _APIKeyLabel.textColor = [UIColor blackColor];
    }
    return _APIKeyLabel;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_saveButton setFrame:CGRectMake(screenWidth - 55, 150, 50, 40)];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton setBackgroundColor:[UIColor lightGrayColor]];
        _saveButton.enabled = YES;
        [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

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

// You can get API Key on Website https://www.juhe.cn/

@end
