//
//  XXTEvaluate.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTImage.h"

typedef enum{
    XXTEvaluateTypePerson = 1,
    XXTEvaluateTypeClass  = 2
} XXTEvaluateType;

@interface XXTEvaluatedPerson : XXTObject

@property (copy , nonatomic) NSNumber* pid;
@property (copy , nonatomic) NSString* name;
@property (strong,nonatomic) XXTImage* avatar;

- (XXTEvaluatedPerson*) initWithDictionary:(NSDictionary*) dict;

@end

@interface XXTEvaluate : XXTObject

@property (copy   , nonatomic) NSNumber* eid;
@property (strong , nonatomic) XXTImage* avatar; //只有thumb!
@property (copy   , nonatomic) NSString* name;
@property XXTEvaluateType type;
@property (strong , nonatomic) XXTImage* icon;
@property (copy   , nonatomic) NSString* content;
@property (strong , nonatomic) NSDate*   dateTime;
@property (strong , nonatomic) NSArray* evaluatedPersonArr;

@property NSInteger rank;

- (XXTEvaluate*) initWithDictionary:(NSDictionary*) dict;

- (XXTEvaluate*) initNewEvaluateWithIds:(NSArray*) studentIds
                                content:(NSString*) content
                                   rank:(int) rank;

@end
