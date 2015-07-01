//
//  customViewTags.h
//  LiveCourse
//
//  Created by Lu on 15/1/8.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#ifndef LiveCourse_customViewTags_h
#define LiveCourse_customViewTags_h


static NSInteger const BarButtonItemBkgStretchLeftCap       = 10.0f;
static NSInteger const BarButtonItemBkgStretchTopCap        = 10.0f;
static NSInteger const KBaseViewControllerImageViewTag      = 99999;
static NSInteger const KBaseTableViewControllerImageViewTag = 99998;

static NSInteger const KUIPlaceHolderTextViewTag            = 998;

static NSInteger const KCourseItemKnowledgeWordViewTag      = 11000;//知识点tag
static NSInteger const KCourseItemFinalTestBloodTag         = 12000;//课时最后的练习血量tag
static NSInteger const KUICourseLevelCellItemTag             = 13000;//课程选择 itemTag

static NSInteger const KTestTopicTag                        = 14000;// 题型
static NSInteger const KTestTopicGjjzpddcTag                = 15000;// 根据句子 判断对错
static NSInteger const KTestTopicGjqjxzhsddaTag             = 16000;//根据情景选择合适的答案
static NSInteger const KTestTopicXzzqddaTag                 = 17000;//选择正确的答案
static NSInteger const KTestTopicTdhxzzqddaTag              = 18000;//听对话 选择正确的答案
static NSInteger const KTestTopicTlypddcTag                 = 19000;//听录音，判断对错
static NSInteger const KTestTopicGjlyxzzqdaTag              = 20000;//根据录音选择正确答案
static NSInteger const KTestTopicOptionManyTag              = 21000;//根据录音选择图片类型的答案
static NSInteger const KTestTopicGjlyxztpTag                = 22000;// 选择录音选择图片
static NSInteger const KTestTopicGjlyxzzqdaMany             = 23000;// 根据录音选择正确答案 - 多个选项型
static NSInteger const KTestTopicGjkwnrxzzqddaOptionTag     = 24000;// 根据课文内容选择正确的答案 选项tag
static NSInteger const KTestTopicGjkwnrxzzqddaShowAnswerTag = 25000;// 根据课文内容选择正确的答案 显示的选项tag
static NSInteger const kTestTopicXzdydjzlxtTitleTag         = 26000;// 选择对应的句子 连线题
static NSInteger const KTestTopicXzdydjzlxtShowAnswerTag    = 27000;//选择对应的句子 连线题
static NSInteger const KTestTopicXctkTitleTag               = 28000;//选词填空
static NSInteger const KTestTopicXctkShowAnswerTag          = 29000;//选词填空
static NSInteger const KTestTopicLccjTag                    = 30000;//连词成句
static NSInteger const KTestTopicLccjCopyTag                = 31000;//连词成句

static NSInteger const kAlertTag                            = 40000;


static NSInteger const kMoreShareActionSheet                = 45000;
static NSInteger const kMorechangeLanguageActionSheet       = 45001;


#endif
