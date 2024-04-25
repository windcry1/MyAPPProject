//
//  MACollectionViewPicCell.m
//  MyAPPProject
//
//  Created by 俞昊 on 2024/4/26.
//

#import "MACollectionViewPicCell.h"
#import <Masonry/Masonry.h>

@implementation MACollectionViewPicCell
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

@end
