//
//  XXTGroup.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/3/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTContactPerson.h"

enum XXTGroupType{
    XXTGroupTypeTeachers=1,
    XXTGroupTypeParents=2
};

@interface XXTGroup : XXTObject

@property (strong,nonatomic) NSString* groupId;
@property (strong,nonatomic) NSString* groupName;
@property enum XXTGroupType groupType;

@property (strong,nonatomic) NSArray* groupMemberArr;

@end
