//
//  MACollectionViewCell.m
//  MyAPPProject
//
//  Created by 俞昊 on 2024/4/25.
//

#import "MACollectionViewCell.h"
#import "MAHelper.h"
#import <Masonry/Masonry.h>

@interface MACollectionViewCell()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSArray *picsArray;

@end


@implementation MACollectionViewCell

+ (CGFloat)heightWithData:(NSDictionary *)data{
    return 200;
}

- (void)layoutSubviews {
    [self.authorPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.top.equalTo(self).offset(5);
    }];
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorPic.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(30);
        make.top.equalTo(self).offset(5);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorName.mas_bottom).offset(5);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(30);
    }];
}

- (void)fetchData:(NSDictionary *)data {
    self.data = data;
    [self configPicsArray];
    
    self.title.text = [data objectForKey:@"title"];
    self.title.font = [UIFont fontWithName:self.title.font.fontName size:16];
    
    self.authorName.text = [data objectForKey:@"author_name"];
    self.authorName.font = [UIFont fontWithName:self.authorName.font.fontName size:12];
    
    [self configTableView];
    
    [self addSubview:self.authorPic];
    [self addSubview:self.title];
    [self addSubview:self.authorName];
    if (self.picsArray.count) {
        [self addSubview:self.pics];
    }
}

- (void)configTableView {
    
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
        _title = [[UILabel alloc] init];
    }
    return _title;
}

- (UILabel *)authorName {
    if (!_authorName) {
        _authorName = [[UILabel alloc] init];
    }
    return _authorName;
}

- (UIImageView *)authorPic {
    if(!_authorPic) {
        _authorPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User"]];
    }
    return _authorPic;
}
@end
