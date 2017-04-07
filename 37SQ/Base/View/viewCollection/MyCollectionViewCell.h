//
//  MyCollectionViewCell.h
//  Uicollectionview
//
//  Created by administrator on 16/10/11.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

@interface MyCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)UIImageView *titleImg;

@property(strong,nonatomic)UIImageView *playImg;

@property(strong,nonatomic)UILabel *playLab;

@property(strong,nonatomic)UIImageView *commentImg;

@property(strong,nonatomic)UILabel *commentLab;

@property(strong,nonatomic)UILabel *contentLab;

@end
