//
//  ISRViewController.h
//  MSCDemo
//
//  Created by iflytek on 13-6-6.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

//forward declare
@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechRecognizer;

/**
 无UI语音识别demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */
@interface ISRViewController : UIViewController<IFlySpeechRecognizerDelegate>

//识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;


@property (nonatomic, weak)   UITextView           * resultView;
@property (nonatomic, weak)   UIButton             * startBtn;

@property (nonatomic, strong) NSString             * result;
@property (nonatomic)         BOOL                 isCanceled;


- (void) onBtnStart:(id) sender;


@property NSTimer * timer;
@end
