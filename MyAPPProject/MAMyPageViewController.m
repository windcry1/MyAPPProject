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
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation MAMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.APIKeyLabel];
    [self.view addSubview:self.APIKeyTextField];
}

- (UITextField *)APIKeyTextField {
    if (!_APIKeyTextField) {
        _APIKeyTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 150, screenWidth - 160, 50)];
        _APIKeyTextField.placeholder = @"Config your APIKey Here!";
        _APIKeyTextField.enabled = YES;
        _APIKeyTextField.secureTextEntry = YES;
        _APIKeyTextField.delegate = self;
    }
    return _APIKeyTextField;
}

- (UILabel *) APIKeyLabel {
    if (!_APIKeyLabel) {
        _APIKeyLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 150, 80, 50)];
        _APIKeyLabel.text = @"API Key:";
        _APIKeyLabel.textColor = [UIColor blackColor];
    }
    return _APIKeyLabel;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",self.APIKeyTextField.text);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
