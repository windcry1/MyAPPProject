//
//  ViewController.m
//  test
//
//  Created by 俞昊 on 2022/10/10.
//

#import "ViewController.h"
#import "MACollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "MAHelper.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, fetchDataType) {
    fetchDataTypeHeader = 0,
    fetchDataTypeFooter,
};

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) BOOL state;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.collectionView];
    
    MJRefreshNormalHeader *mj_refresh_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    mj_refresh_header.automaticallyChangeAlpha = true;
    self.collectionView.mj_header = mj_refresh_header;
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Getters and Setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGRect collectionViewFrame = CGRectMake(0, 0, screenWidth, screenHeight);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[MACollectionViewCell class] forCellWithReuseIdentifier:@"MACollectionViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark - helpers

- (CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 15.0, *)) {
        UIStatusBarManager *statusBarManager = self.view.window.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    return statusBarHeight;
}

- (NSInteger)getPage {
    if (self.page >= 50)
        self.page = 0;
    return ++self.page;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (MACollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MACollectionViewCell";
    MACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell fetchData:self.dataSource[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(screenWidth, [MACollectionViewCell heightWithData:self.dataSource[indexPath.item]]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

#pragma mark - MJRefresh
- (void)refresh {
    NSLog(@"called refresh");
    __weak __typeof__(self) weakSelf = self;
    [self fetchDataWithType:fetchDataTypeHeader completion:^{
        __strong __typeof__(self) self = weakSelf;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}

- (void)loadMore {
    NSLog(@"called loadMore");
    __weak __typeof__(self) weakSelf = self;
    [self fetchDataWithType:fetchDataTypeFooter completion:^{
        __strong __typeof__(self) self = weakSelf;
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
}

- (void)fetchDataWithType:(fetchDataType)type completion:(nullable void (^)(void))completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
        @"key": [[NSUserDefaults standardUserDefaults] objectForKey:@"APIKey"]?:@"",
        @"page": @(self.getPage),
        @"type": @"top",
    };
    __weak __typeof__(self) weakSelf = self;
    [manager GET:@"https://v.juhe.cn/toutiao/index" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof__(self) self = weakSelf;
        if (![responseObject objectForKey:@"result"] || [[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            [self presentAlert];
            completion?completion():nil;
            return ;
        }
        if (type == fetchDataTypeFooter) {
            [self.dataSource addObjectsFromArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
        } else if (type == fetchDataTypeHeader) {
            self.dataSource = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
        }
        completion?completion():nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof__(self) self = weakSelf;
        [self presentAlert];
        completion?completion():nil;
    }];
}

- (void)presentAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Call for data error!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:sureBtn];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
