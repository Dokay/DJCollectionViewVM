//
//  DJCollectionViewVMReusableView.m
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMReusableView.h"
#import "DJCollectionViewVMReusable.h"
#import "DJCollectionViewVM.h"

@implementation DJCollectionViewVMReusableView

+ (CGSize)sizeWithResuableVM:(DJCollectionViewVMReusable *)resuableVM collectionViewVM:(DJCollectionViewVM *)collectionViewVM
{
    if ([resuableVM isKindOfClass:[DJCollectionViewVMReusable class]] && resuableVM.resuableSize.height > 0){
        return resuableVM.resuableSize;
    }else{
        return CGSizeMake(collectionViewVM.collectionView.frame.size.width, 40);
    }
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
    self.loaded = YES;
}

- (void)viewWillAppear
{
    self.backgroundColor = self.reusableVM.backgroundColor;
}

- (void)viewDidDisappear
{
    //TODO:Dokay 
}

@end
