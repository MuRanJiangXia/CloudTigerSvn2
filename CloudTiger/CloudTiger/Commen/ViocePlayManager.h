//
//  ViocePlayManager.h
//  ViocePlay
//
//  Created by cyan on 2017/5/15.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViocePlayManager : NSObject
+ (instancetype)shareVioceManager;
/**播放*/
-(void)voiceBroadCastStr:(NSString *)content;

/**暂停播放*/
-(void)pause;

/**继续语音播报*/
-(void)continuePlay;

/**取消或停止语音播报*/
-(void)stop;

@end
