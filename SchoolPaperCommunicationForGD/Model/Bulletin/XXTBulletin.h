//
//  XXTBulletin.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/7/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTImage.h"
#import "XXTPersonBase.h"

typedef enum{
    XXTBulletinTypeSchool = 1,
    XXTBulletinTypeClass  = 2
} XXTBulletinType;

@interface XXTBulletin : XXTObject

@property (copy,nonatomic) NSNumber* bid;
@property (copy,nonatomic) NSString* senderId;
@property (copy,nonatomic) NSString* senderName;
@property (copy,nonatomic) NSString* title;
@property (copy,nonatomic) NSString* content;
@property (strong,nonatomic) XXTImage* image;
@property (strong,nonatomic) NSDate*   startDate;
@property (strong,nonatomic) NSDate*   endDate;
@property (strong,nonatomic) NSDate*   dateTime;
@property (strong,nonatomic) NSNumber* schoolId;
@property (strong,nonatomic) NSNumber* classId;
@property XXTPersonType type;

- (XXTBulletin*) initWithDictionary:(NSDictionary*) dictionary;
- (XXTBulletin*) initNewBulletinWithSchoolId:(NSNumber*) schoolId
                                   startDate:(NSDate*) startDate
                                     endDate:(NSDate*) endDate
                                   teacherId:(NSNumber*) teacherId
                                     classId:(NSNumber*) classId
                                       title:(NSString*) title
                                     content:(NSString*) content;

@end
