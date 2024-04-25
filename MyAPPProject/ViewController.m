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

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

typedef NS_ENUM(NSUInteger, fetchDataType) {
    fetchDataTypeHeader = 0,
    fetchDataTypeFooter,
};

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
/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/**
 每个分区item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MACollectionViewCell";
    MACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell fetchData:self.dataSource[indexPath.item]];
    //cell.imageStr = _imagesArray[indexPath.item];
    return cell;
}
/**
 创建区头视图和区尾视图
 */
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionHeader){
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionViewHeaderView" forIndexPath:indexPath];
//        headerView.backgroundColor = [UIColor yellowColor];
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
//        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区头",indexPath.section];
//        [headerView addSubview:titleLabel];
//        return headerView;
//    }else if(kind == UICollectionElementKindSectionFooter){
//        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionViewFooterView" forIndexPath:indexPath];
//        footerView.backgroundColor = [UIColor blueColor];
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:footerView.bounds];
//        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区尾",indexPath.section];
//        [footerView addSubview:titleLabel];
//        return footerView;
//    }
//    return nil;
//}
/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(screenWidth, [MACollectionViewCell heightWithData:self.dataSource[indexPath.item]]);
}
/**
 每个分区的内边距（上左下右）
 */
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 5, 10, 5);
//}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark - MJRefresh
- (void)refresh {
    NSLog(@"called refresh");
    [self fetchDataWithType:fetchDataTypeHeader];
    [self.collectionView.mj_header endRefreshing];
}

- (void)loadMore {
    NSLog(@"called loadMore");
    [self fetchDataWithType:fetchDataTypeFooter];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)fetchDataWithType:(fetchDataType)type{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
        @"key": [[NSUserDefaults standardUserDefaults] objectForKey:@"APIKey"],
        @"page": @(self.getPage),
        @"type": @"top",
    };
    [manager GET:@"https://v.juhe.cn/toutiao/index" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (type == fetchDataTypeFooter) {
            [self.dataSource addObjectsFromArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
        } else if (type == fetchDataTypeHeader) {
            self.dataSource = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Call for data error!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:sureBtn];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
}

@end
