//
//  GroupHolder.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-13.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    GroupChosenTypeNone,
    GroupChosenTypeAll,
    GroupChosenTypeSome
}GroupChosenType;
@interface GroupHolder : NSObject
@property (nonatomic) BOOL isExpand;
@property (nonatomic) GroupChosenType groupChosenType;
@property (nonatomic, retain) NSMutableArray *contactHolderArr;
@property (nonatomic, retain) NSString *groupName;
@end
