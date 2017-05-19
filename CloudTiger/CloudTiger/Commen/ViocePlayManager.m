//
//  ViocePlayManager.m
//  ViocePlay
//
//  Created by cyan on 2017/5/15.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "ViocePlayManager.h"
#import <AVFoundation/AVFoundation.h>

@interface  ViocePlayManager()<AVSpeechSynthesizerDelegate>{
    
    
    AVSpeechSynthesizer *_synthesizer;
    
}

@end
@implementation ViocePlayManager

+ (instancetype)shareVioceManager{
    
    ViocePlayManager *_manager = [[ViocePlayManager alloc] init];
    
    [_manager setConfig];
    return _manager;
}

-(void)setConfig{
    //初始化语音播报，控制播放、暂停
    _synthesizer = [[AVSpeechSynthesizer alloc]init];
    _synthesizer.delegate = self;//注意：代理方法写在启动前x
    
}


//content代表要播报的内容
-(void)voiceBroadCastStr:(NSString *)content
{
    
    [self stop];
    // 实例化发声的对象，及朗读的内容
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
    
    //语音对象，说中文（zh_CN），英文(en-US)
    AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
    //指定语音类型
    utterance.voice = voiceType;
    //朗诵速度
    utterance.rate = 0.5;
    utterance.volume = 1.0;
    
    [_synthesizer speakUtterance:utterance];//启动
    
}



//3、暂停语音播报
-(void)pause{
    
    [_synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
}


//4、继续语音播报
-(void)continuePlay{
    
    [_synthesizer continueSpeaking];
    
}


//5、取消或停止语音播报

/**
 
 *AVSpeechBoundaryImmediate,  立即停
 
 AVSpeechBoundaryWord  说完一个整词再停
 
 */
-(void)stop{
    [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

@end
