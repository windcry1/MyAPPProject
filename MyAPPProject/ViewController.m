//
//  ViewController.m
//  test
//
//  Created by 俞昊 on 2022/10/10.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL state;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.button];
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [_button setBackgroundColor:[UIColor orangeColor]];
        [_button addTarget:self action:@selector(tapGesture) forControlEvents:UIControlEventTouchUpInside];
        //[_button setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    return _button;
}

- (void)tapGesture {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.button.frame = self.state ? CGRectMake(100, 100, 100, 100) : CGRectMake(100, 100, 200, 200);
    } completion:^(BOOL finished) {
        self.state = !self.state;
    }];
}

@end
