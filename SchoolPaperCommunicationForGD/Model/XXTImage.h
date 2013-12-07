//
//  XXTImage.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTObject.h"

@interface XXTImage : XXTObject

@property (strong,nonatomic) NSString *originPicURL;    //原始图片URL
@property (strong,nonatomic) NSString *thumbPicURL;     //缩略图URL
@property (strong,nonatomic) UIImage  *originPicImage;  //原始图UIImage
@property (strong,nonatomic) UIImage  *thumbPicImage;   //缩略图UIImage



@end
