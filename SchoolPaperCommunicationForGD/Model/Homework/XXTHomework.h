//
//  XXTHomework.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTImage.h"

typedef enum{
    XXTSubjectTypeYuWen = 1
}XXTSubjectType;

@interface XXTHomework : XXTObject

@property (copy , nonatomic) NSNumber *homeworkId;
@property (copy , nonatomic) NSString *subject;
@property (copy , nonatomic) NSNumber *subjectId;
@property (copy , nonatomic) NSNumber *classId;
@property (copy , nonatomic) NSString *className;
@property (copy , nonatomic) NSString *title;
@property (copy , nonatomic) NSString *content;
@property (strong,nonatomic) XXTImage *image;
@property (copy , nonatomic) NSDate   *dateTime;
@property (copy , nonatomic) NSDate   *finishTime;

- (XXTHomework*) initWithDictionary:(NSDictionary*) dictionary;

- (XXTHomework*) initNewHomeworkWithContent:(NSString*) content
                                  subjectId:(XXTSubjectType) subjectId
                                    classId:(int) classId
                                      image:(XXTImage*) image
                                 finishTime:(NSDate*) date;;

@end
