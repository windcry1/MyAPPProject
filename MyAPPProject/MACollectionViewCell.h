//
//  MACollectionViewCell.h
//  MyAPPProject
//
//  Created by 俞昊 on 2024/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MACollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *authorName;
@property (nonatomic, strong) UIImageView *authorPic;
@property (nonatomic, strong) UITableView *pics;

+ (CGFloat)heightWithData:(NSDictionary *)data;
- (void)fetchData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
