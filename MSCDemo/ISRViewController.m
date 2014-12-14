//
//  ISRViewController.m
//  MSCDemo
//
//  Created by iflytek on 13-6-6.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "ISRViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "Definition.h"
#import "iflyMSC/IFlyUserWords.h"
#import "RecognizerFactory.h"
#import "UIPlaceHolderTextView.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "PopupView.h"
#import "ISRDataHelper.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"

@implementation ISRViewController

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //创建识别
    _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];


    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //adjust the UI for iOS 7
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIView *mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor whiteColor];
    self.view = mainView;


    int top = Margin*2;
    //听写
    self.title = @"语音控制";
    UIPlaceHolderTextView *resultView = [[UIPlaceHolderTextView alloc] initWithFrame:
                                         CGRectMake(Margin*2, top, self.view.frame.size.width-Margin*4, 160)];
    resultView.layer.cornerRadius = 8;
    resultView.layer.borderWidth = 1;
    [self.view addSubview:resultView];
    resultView.font = [UIFont systemFontOfSize:17.0f];
    resultView.placeholder = @"识别结果";
    //键盘
    UIBarButtonItem *spaceBtnItem= [[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * hideBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏" style:UIBarButtonItemStylePlain target:self action:@selector(onKeyBoardDown:)];
    UIToolbar * toolbar = [[ UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    NSArray * array = [NSArray arrayWithObjects:spaceBtnItem,hideBtnItem, nil];
    [toolbar setItems:array];
    //resultView.inputAccessoryView = toolbar;
    [resultView setEditable:NO];
    self.resultView = resultView;
    
    
    //识别控制按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startBtn setTitle:@"开始识别" forState:UIControlStateNormal];
    startBtn.frame = CGRectMake(Padding, resultView.frame.origin.y + resultView.frame.size.height + Margin, (self.view.frame.size.width-Padding*4)/3, ButtonHeight);
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(onBtnStart:) forControlEvents:UIControlEventTouchUpInside];
    self.startBtn = startBtn;
 }

/*
 * @隐藏键盘
 */
-(void)onKeyBoardDown:(id) sender
{
    [_resultView resignFirstResponder];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.view = nil;
}
 - (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//   _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onBtnStart:) userInfo:nil repeats:YES];

}
-(void)viewWillDisappear:(BOOL)animated
{
    //取消识别
    [_timer invalidate];
    _timer = nil;

    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Handler
/*
 * @开始录音
 */
- (void) onBtnStart:(id) sender
{
 //   [_resultView setText:@""];
    [_resultView resignFirstResponder];
    
    self.isCanceled = NO;
    
    //设置为录音模式
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    bool ret = [_iFlySpeechRecognizer startListening];

     if (ret) {
        
    }
    else
    {
    }
    
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{

}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    

}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
//    NSLog(@"onEndOfSpeech");
//    
//    [_popUpView setText: @"停止录音"];
//    [self.view addSubview:_popUpView];
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{

}

/**
 * @fn      onResults
 * @brief   识别结果回调
 * 
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    //NSLog(@"听写结果：%@",resultString);

    [self actionOnSpeech:resultString ];

    self.result =[NSString stringWithFormat:@"%@%@", _resultView.text,resultString];

    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    
    _resultView.text = [NSString stringWithFormat:@"%@%@", _resultView.text,resultFromJson];
    
    if (isLast)
    {
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    
    NSLog(@"isLast=%d",isLast);
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param   
 * @see
 */
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void) showPopup
{
}

#pragma mark - IFlyDataUploaderDelegate

/**
 * @fn  onUploadFinished
 * @brief   上传完成回调
 * @param grammerID 上传用户词、联系人为空
 * @param error 上传错误
 */
- (void) onUploadFinished:(NSString *)grammerID error:(IFlySpeechError *)error
{    }

- (void) actionOnSpeech:(NSString*) speech
{
    if ([speech containsString:@"退出"]) {
         exit(0);
    }

}

@end
