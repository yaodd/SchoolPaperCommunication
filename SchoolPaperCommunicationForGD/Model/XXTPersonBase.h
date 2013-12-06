//
//  XXTPerson.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTImage.h"
#import "XXTObject.h"

typedef enum {
    XXTPersonTypeTeacher = 1,
    XXTPersonTypeParent  = 2,
    XXTPersonTypeStudent = 3,
}XXTPersonType;

@interface XXTPersonBase : XXTObject

@property (strong,nonatomic) NSString* pid;
@property (strong,nonatomic) NSString *name;
@property (nonatomic) XXTPersonType type;
@property (strong,nonatomic) XXTImage *avatar;

@end
