//
//  MACollectionViewCell.m
//  MyAPPProject
//
//  Created by 俞昊 on 2024/4/25.
//

#import "MACollectionViewCell.h"
#import "MAHelper.h"
#import <Masonry/Masonry.h>
#import "MACollectionViewPicCell.h"

@interface MACollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSArray *picsArray;

@end


@implementation MACollectionViewCell

+ (CGFloat)heightWithData:(NSDictionary *)data {
    NSString *thumbnailPicURL = [data objectForKey:@"thumbnail_pic_s"];
    if (thumbnailPicURL && ![thumbnailPicURL isEqualToString:@""])
        return 202;
    return 72;
}

- (void)fetchData:(NSDictionary *)data {
    self.data = data;
    [self configPicsArray];
    
    self.authorName.text = [data objectForKey:@"author_name"];
    self.authorName.font = [UIFont fontWithName:self.authorName.font.fontName size:12];
    
    self.title.text = [data objectForKey:@"title"];
    self.title.font = [UIFont fontWithName:self.title.font.fontName size:15];
    
    [self configCollectionView];
    
    [self.contentView addSubview:self.authorPic];
    [self.contentView addSubview:self.authorName];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.pics];
    [self.contentView addSubview:self.separateLine];
    // Now Top = 70
    // pics.size: 120*(360+20)
    // top:5 bottom:5 left:screenWidth-380
    if (self.picsArray.count) {
        [self.pics mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset((screenWidth - 380)/2);
            make.right.equalTo(self.contentView).offset((380 - screenWidth)/2);
            make.bottom.equalTo(self.contentView).offset(-7);
        }];
    }
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(2);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}

- (void)configCollectionView {
    [self.pics reloadData];
}

- (void)configPicsArray {
    NSMutableArray *tempPics = [NSMutableArray arrayWithCapacity:0];
    if ([self.data objectForKey:@"thumbnail_pic_s"])
        [tempPics addObject:[self.data objectForKey:@"thumbnail_pic_s"]];
    if ([self.data objectForKey:@"thumbnail_pic_s02"])
        [tempPics addObject:[self.data objectForKey:@"thumbnail_pic_s02"]];
    if ([self.data objectForKey:@"thumbnail_pic_s03"])
        [tempPics addObject:[self.data objectForKey:@"thumbnail_pic_s03"]];
    self.picsArray = [NSArray arrayWithArray:tempPics];
}

#pragma mark - Getters and Setters
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, screenWidth - 10, 30)];
    }
    return _title;
}

- (UILabel *)authorName {
    if (!_authorName) {
        _authorName = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, screenWidth - 45, 30)];
    }
    return _authorName;
}

- (UIImageView *)authorPic {
    if (!_authorPic) {
        _authorPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User"]];
        _authorPic.frame = CGRectMake(5, 5, 30, 30);
    }
    return _authorPic;
}

- (UIView *)separateLine {
    if (!_separateLine) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [UIColor grayColor];
    }
    return _separateLine;
}

- (UICollectionView *)pics {
    if (!_pics) {
        UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _pics = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _pics.delegate = self;
        _pics.dataSource = self;
        _pics.scrollEnabled = NO;
        [_pics registerClass:[MACollectionViewPicCell class] forCellWithReuseIdentifier:@"MACollectionViewPicCell"];
    }
    return _pics;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MACollectionViewPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MACollectionViewPicCell" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString: [self.picsArray objectAtIndex:indexPath.item]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSLog(@"data:%@",data);
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                [cell.imageView setImage:image];
                [cell addSubview:cell.imageView];
            });
        }
    });
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

@end
