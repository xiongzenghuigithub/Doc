------------------------------------------------
mac 下得 jdk删除:

1. finder中搜索 JavaAppletPlugin.plugin,然后删除

2. finder中进入 /Library/Java/JavaVirtualMachines,然后删除jdk1.7.xxx

注:删除过程中,需要输入管理员密码

mac 下得 jdk安装:

-vim ~/.bash_profile，添加如下代码:

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk的安装目录/Contents/Home
CLASSPAHT=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
PATH=$JAVA_HOME/bin:$PATH:
export JAVA_HOME
export CLASSPATH
export PATH

------------------------------------------------
问题解决:  ( fatal: unable to connect to github.com  )

git config --global url."https://".insteadOf git://

------------------------------------------------
json: 
	{} --> 字典
	[] --> 数组
------------------------------------------------
> 调试闪退、exc_bad_access

	xcode -> product -> scheme -> Edit Scheme -> Diagnostics -> Enable Zombie Objects

------------------------------------------------
-- > Xcode插件目录

~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins

--------------------------------------------------
> cocos2dx 3.2创建项目

cocos new GoodDay（项目名称）-p com.boleban.www（包名字）-l cpp（项目类型） -d D:\DevProject\cocos2dx_workspace（项目存放路径）

--------------------------------------------------

> duplicate symbol xxxx  错误提示

	重复定义 xxx

--------------------------------------------------



	

--------------------------------------------------

> #define 使用
	
	1. 改进NSLog()函数 -- 1)发布app时清除所有log语句 2)让log的信息更加详细

		#ifdef DEBUG
		#define log(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__]);
		#else 
		#define log(...); 
		#endif

	2. 代替一些常用的 对象、方法

		1) 对象 (如: Appdelegate对象)
			#define APP_DELEGATE (Appdelegate *) [[UIApplication application] delegate];

		2) 方法 
			#define Func(args1, args2) {return (args1+args2);}

	3. 防止 .h文件被重复导入

		//1)
		#include <stdio.h>

		//2)
		#ifndef __项目名__文件名__
		#define __项目名__文件名__

		//3)
		程序代码

		//4)
		#endif /* defind() */

----------------------------------------------------------


注意:
		1) 代理可以设置为 类
			> xxx.delegate = [xxx类  class];
			> 回调函数卸载xxx类的类函数 --》 + 修饰的函数
			> 调用对象 
				> [xxx类 sharedXxx类].属性
				> [[xxx类 sharedXxx类] 方法]


----------------------------------------------------------

> BaseViewController -- 所以控制器的父类，来提供一些基础性的代码

	1. 获取rootView的frame,(x,y), width, height, 最左边x, 最上边y
	2. 定义一个pushVC方法 , 来拦截所有该子类控制器的pushViewController方法
		- (void)pushVCfrom:(id)fromVC to:(id)toVC isAnimate:(BOOL)animate ;

> BaseNavigationController 
	1. [BaseNavigationController对象.view addSubView:MainViewController对象.view];
	2. 以后不断切换BaseNavigationController对象.view.subViews[0]个字view(控制器view)
		> 优点: 所有当要加入的controller.view之前, 都会首先调用BaseNavigationController对象.viewDidLoad()方法
					> 可以在BaseNavigationController对象.viewDidLoad()方法中 , 做一些预处理

----------------------------------------------------------

> 网络框架api设计
	



----------------------------------------------------------
> 动态加载第三方字体

1.网上搜索字体文件(后缀名为.ttf,或.odf)

2.把字体库导入到工程的resouce中

3.并且在项目的XX-Info.plist中加上Fonts provided by application这个属性，这个作为Array,在其item中加入.ttf字体的名字+后缀

4.获取系统所有的字体
	NSArray* fontArrays = [[NSArrayalloc] initWithArray:[UIFontfamilyNames]];

5. 创建自己的字体
	UIFont* fontOne = [UIFontfontWithName:@"外置放入的字体名"size:15];

 

NSArray *familyNames = [UIFont familyNames];  

    for( NSString *familyName in familyNames ){  
    	//1. 找到

    }

----------------------------------------------------------

判断两个日期之间的间隔

NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
NSDate* toDate     = [dateFormatter dateFromString:@"19700608142033"];
NSDate*  startDate    = [ [ NSDate alloc] init ];
NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
 
NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:startDate  toDate:toDate  options:0];
 
NSInteger diffYear = [cps year];
NSInteger diffMon = [cps month];
NSInteger diffDay = [cps day];
NSInteger diffHour = [cps hour];
NSInteger diffMin = [cps minute];
NSInteger diffSec = [cps second];

----------------------------------------------------------
发送本地视频的流程
	1. 从本地url或者path获取视频内容
	2. 对视频进行获取第一帧图片
	3. 然后初始化消息的Model
	4. 将获取的第一针图片设置封面

	//适配选取控制器获得用户选择的本地视屏
	NSString *mediaType = [editingInfo objectForKey:UIImagePickerControllerMediaType];
	NSString *videoPath;
	NSURL *videoUrl;
	if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
		
		videoUrl = (NSURL*)[editingInfo objectForKey:UIImagePickerControllerMediaURL];
		
		//从NSURL获取文件在本地的路径
		videoPath = [videoUrl path];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
		NSParameterAssert(asset);
		AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
		assetImageGenerator.appliesPreferredTrackTransform = YES;
		assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
		
		CGImageRef thumbnailImageRef = NULL;

		//视屏的第一帧图片
		CFTimeInterval thumbnailImageTime = 0;
		NSError *thumbnailImageGenerationError = nil;
		
		thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError;];
        
        if (!thumbnailImageRef)
			NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
        
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
        
        XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:thumbnailImage videoPath:videoPath videoUrl:nil sender:@"Jack" timestamp:[NSDate date]];
		[weakSelf addMessage:videoMessage];
	}


	注意:

		CMTimeMake -- 确定视频的第几秒的画面

		CMTime curFrame = CMTimeMake(第几帧， 帧率）  

			第几帧: 哪一个帧画面
			帧率: 一秒钟播放多少个帧画面


		如:

			CMTime firstframe=CMTimeMake(32，16);  
			CMTime lastframe=CMTimeMake(48, 24);

			这两个都表示2秒的时间。但是帧率是完全不同的。


----------------------------------------------------------
类似QQ空间的赞动画
	把需要的view先放大，然后再缩小就可以了

	UIView *zanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	zanView.backgroundColor = [UIColor redColor];
	[self.view addSubview:zanView];
	[UIView animateWithDuration:0.3 animations:^{
	    zanView.transform = CGAffineTransformMakeScale(1.2, 1.2);
	} completion:^(BOOL finished) {
	    [UIView animateWithDuration:0.3 animations:^{
	        zanView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	    } completion:^(BOOL finished) {
	        [UIView animateWithDuration:0.3 animations:^{
	            zanView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	        } completion:^(BOOL finished) {
	             
	        }];
	    }];
	}];
----------------------------------------------------------


常用动画

//
//  CoreAnimationEffect.h
//  CoreAnimationEffect
//
//  Created by VincentXue on 13-1-19.
//  Copyright (c) 2013年 VincentXue. All rights reserved.
//
 
#import <Foundation/Foundation.h>
 
/**
 !  导入QuartzCore.framework
 *
 *  Example:
 *
 *  Step.1
 *
 *      #import "CoreAnimationEffect.h"
 *
 *  Step.2
 *
 *      [CoreAnimationEffect animationMoveLeft:your view];
 *  
 */
 
 
@interface CoreAnimationEffect : NSObject
 
#pragma mark - Custom Animation
 
/**
 *   @brief 快速构建一个你自定义的动画,有以下参数供你设置.
 *
 *   @note  调用系统预置Type需要在调用类引入下句
 *
 *          #import <QuartzCore/QuartzCore.h>
 *
 *   @param type                动画过渡类型
 *   @param subType             动画过渡方向(子类型)
 *   @param duration            动画持续时间
 *   @param timingFunction      动画定时函数属性
 *   @param theView             需要添加动画的view.
 *
 *
 */
 
+ (void)showAnimationType:(NSString *)type
              withSubType:(NSString *)subType
                 duration:(CFTimeInterval)duration
           timingFunction:(NSString *)timingFunction
                     view:(UIView *)theView;
 
#pragma mark - Preset Animation
 
/**
 *  下面是一些常用的动画效果
 */
 
// reveal
+ (void)animationRevealFromBottom:(UIView *)view;
+ (void)animationRevealFromTop:(UIView *)view;
+ (void)animationRevealFromLeft:(UIView *)view;
+ (void)animationRevealFromRight:(UIView *)view;
 
// 渐隐渐消
+ (void)animationEaseIn:(UIView *)view;
+ (void)animationEaseOut:(UIView *)view;
 
// 翻转
+ (void)animationFlipFromLeft:(UIView *)view;
+ (void)animationFlipFromRigh:(UIView *)view;
 
// 翻页
+ (void)animationCurlUp:(UIView *)view;
+ (void)animationCurlDown:(UIView *)view;
 
// push
+ (void)animationPushUp:(UIView *)view;
+ (void)animationPushDown:(UIView *)view;
+ (void)animationPushLeft:(UIView *)view;
+ (void)animationPushRight:(UIView *)view;
 
// move
+ (void)animationMoveUp:(UIView *)view duration:(CFTimeInterval)duration;
+ (void)animationMoveDown:(UIView *)view duration:(CFTimeInterval)duration;
+ (void)animationMoveLeft:(UIView *)view;
+ (void)animationMoveRight:(UIView *)view;
 
// 旋转缩放
 
// 各种旋转缩放效果
+ (void)animationRotateAndScaleEffects:(UIView *)view;
 
// 旋转同时缩小放大效果
+ (void)animationRotateAndScaleDownUp:(UIView *)view;
 
 
 
#pragma mark - Private API
 
/**
 *  下面动画里用到的某些属性在当前API里是不合法的,但是也可以用.
 */
 
+ (void)animationFlipFromTop:(UIView *)view;
+ (void)animationFlipFromBottom:(UIView *)view;
 
+ (void)animationCubeFromLeft:(UIView *)view;
+ (void)animationCubeFromRight:(UIView *)view;
+ (void)animationCubeFromTop:(UIView *)view;
+ (void)animationCubeFromBottom:(UIView *)view;
 
+ (void)animationSuckEffect:(UIView *)view;
 
+ (void)animationRippleEffect:(UIView *)view;
 
+ (void)animationCameraOpen:(UIView *)view;
+ (void)animationCameraClose:(UIView *)view;
 
@end
 
 
 
//
//  CoreAnimationEffect.m
//  CoreAnimationEffect
//
//  Created by VincentXue on 13-1-19.
//  Copyright (c) 2013年 VincentXue. All rights reserved.
//
 
#import "CoreAnimationEffect.h"
 
#import <QuartzCore/QuartzCore.h>
 
@implementation CoreAnimationEffect
 
/**
 *  首先推荐一个不错的网站.   http://www.raywenderlich.com
 */
 
#pragma mark - Custom Animation
 
+ (void)showAnimationType:(NSString *)type
              withSubType:(NSString *)subType
                 duration:(CFTimeInterval)duration
           timingFunction:(NSString *)timingFunction
                     view:(UIView *)theView
{
    /** CATransition
     *
     *  @see http://www.dreamingwish.com/dream-2012/the-concept-of-coreanimation-programming-guide.html
     *  @see http://geeklu.com/2012/09/animation-in-ios/
     *
     *  CATransition 常用设置及属性注解如下:
     */
 
    CATransition *animation = [CATransition animation];
     
    /** delegate
     *
     *  动画的代理,如果你想在动画开始和结束的时候做一些事,可以设置此属性,它会自动回调两个代理方法.
     *
     *  @see CAAnimationDelegate    (按下command键点击)
     */
     
    animation.delegate = self;
     
    /** duration
     *
     *  动画持续时间
     */
     
    animation.duration = duration;
     
    /** timingFunction
     *
     *  用于变化起点和终点之间的插值计算,形象点说它决定了动画运行的节奏,比如是均匀变化(相同时间变化量相同)还是
     *  先快后慢,先慢后快还是先慢再快再慢.
     *
     *  动画的开始与结束的快慢,有五个预置分别为(下同):
     *  kCAMediaTimingFunctionLinear            线性,即匀速
     *  kCAMediaTimingFunctionEaseIn            先慢后快
     *  kCAMediaTimingFunctionEaseOut           先快后慢
     *  kCAMediaTimingFunctionEaseInEaseOut     先慢后快再慢
     *  kCAMediaTimingFunctionDefault           实际效果是动画中间比较快.
     */
     
    /** timingFunction
     *
     *  当上面的预置不能满足你的需求的时候,你可以使用下面的两个方法来自定义你的timingFunction
     *  具体参见下面的URL
     *
     *  @see http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/CAMediaTimingFunction_class/Introduction/Introduction.html
     *
     *  + (id)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
     *
     *  - (id)initWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
     */
     
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
     
    /** fillMode
     *
     *  决定当前对象过了非active时间段的行为,比如动画开始之前,动画结束之后.
     *  预置为:
     *  kCAFillModeRemoved   默认,当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     *  kCAFillModeForwards  当动画结束后,layer会一直保持着动画最后的状态
     *  kCAFillModeBackwards 和kCAFillModeForwards相对,具体参考上面的URL
     *  kCAFillModeBoth      kCAFillModeForwards和kCAFillModeBackwards在一起的效果
     */
     
    animation.fillMode = kCAFillModeForwards;
     
    /** removedOnCompletion
     *
     *  这个属性默认为YES.一般情况下,不需要设置这个属性.
     *
     *  但如果是CAAnimation动画,并且需要设置 fillMode 属性,那么需要将 removedOnCompletion 设置为NO,否则
     *  fillMode无效
     */
     
//    animation.removedOnCompletion = NO;
     
    /** type
     *
     *  各种动画效果  其中除了'fade', `moveIn', `push' , `reveal' ,其他属于似有的API(我是这么认为的,可以点进去看下注释).
     *  ↑↑↑上面四个可以分别使用'kCATransitionFade', 'kCATransitionMoveIn', 'kCATransitionPush', 'kCATransitionReveal'来调用.
     *  @"cube"                     立方体翻滚效果
     *  @"moveIn"                   新视图移到旧视图上面
     *  @"reveal"                   显露效果(将旧视图移开,显示下面的新视图)
     *  @"fade"                     交叉淡化过渡(不支持过渡方向)             (默认为此效果)
     *  @"pageCurl"                 向上翻一页
     *  @"pageUnCurl"               向下翻一页
     *  @"suckEffect"               收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
     *  @"rippleEffect"             滴水效果,(不支持过渡方向)
     *  @"oglFlip"                  上下左右翻转效果
     *  @"rotate"                   旋转效果
     *  @"push"                     
     *  @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)
     *  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
     */
     
    /** type
     *
     *  kCATransitionFade            交叉淡化过渡
     *  kCATransitionMoveIn          新视图移到旧视图上面
     *  kCATransitionPush            新视图把旧视图推出去
     *  kCATransitionReveal          将旧视图移开,显示下面的新视图
     */
     
    animation.type = type;
     
    /** subtype
     *
     *  各种动画方向
     *
     *  kCATransitionFromRight;      同字面意思(下同)
     *  kCATransitionFromLeft;
     *  kCATransitionFromTop;
     *  kCATransitionFromBottom;
     */
     
    /** subtype
     *
     *  当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
     *  90cw    逆时针旋转90°
     *  90ccw   顺时针旋转90°
     *  180cw   逆时针旋转180°
     *  180ccw  顺时针旋转180°
     */
     
    /**
     *  type与subtype的对应关系(必看),如果对应错误,动画不会显现.
     *
     *  @see http://iphonedevwiki.net/index.php/CATransition
     */
     
    animation.subtype = subType;
     
    /**
     *  所有核心动画和特效都是基于CAAnimation,而CAAnimation是作用于CALayer的.所以把动画添加到layer上.
     *  forKey  可以是任意字符串.
     */
     
    [theView.layer addAnimation:animation forKey:nil];
}
 
#pragma mark - Preset Animation
 
 
+ (void)animationRevealFromBottom:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationRevealFromTop:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromTop];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationRevealFromLeft:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationRevealFromRight:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromRight];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
 
+ (void)animationEaseIn:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationEaseOut:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
 
/**
 *  UIViewAnimation
 *
 *  @see    http://www.cocoachina.com/bbs/read.php?tid=110168
 *
 *  @brief  UIView动画应该是最简单便捷创建动画的方式了,详解请猛戳URL.
 *  
 *  @method beginAnimations:context 第一个参数用来作为动画的标识,第二个参数给代理代理传递消息.至于为什么一个使用
 *                                  nil而另外一个使用NULL,是因为第一个参数是一个对象指针,而第二个参数是基本数据类型.
 *  @method setAnimationCurve:      设置动画的加速或减速的方式(速度)
 *  @method setAnimationDuration:   动画持续时间
 *  @method setAnimationTransition:forView:cache:   第一个参数定义动画类型，第二个参数是当前视图对象，第三个参数是是否使用缓冲区
 *  @method commitAnimations        动画结束
 */
 
+ (void)animationFlipFromLeft:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:NO];
    [UIView commitAnimations];
}
 
+ (void)animationFlipFromRigh:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view cache:NO];
    [UIView commitAnimations];
}
 
 
+ (void)animationCurlUp:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view cache:NO];
    [UIView commitAnimations];
}
 
+ (void)animationCurlDown:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view cache:NO];
    [UIView commitAnimations];
}
 
+ (void)animationPushUp:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationPushDown:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationPushLeft:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationPushRight:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
// presentModalViewController
+ (void)animationMoveUp:(UIView *)view duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
// dissModalViewController
+ (void)animationMoveDown:(UIView *)view duration:(CFTimeInterval)duration
{
    CATransition *transition = [CATransition animation];
    transition.duration =0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [view.layer addAnimation:transition forKey:nil];
}
 
+ (void)animationMoveLeft:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromLeft];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationMoveRight:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromRight];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+(void)animationRotateAndScaleEffects:(UIView *)view
{
    [UIView animateWithDuration:0.35f animations:^
     {
         /**
          *  @see       http://donbe.blog.163.com/blog/static/138048021201061054243442/
          *
          *  @param     transform   形变属性(结构体),可以利用这个属性去对view做一些翻转或者缩放.详解请猛戳↑URL.
          *
          *  @method    valueWithCATransform3D: 此方法需要一个CATransform3D的结构体.一些非详细的讲解可以看下面的URL
          *
          *  @see       http://blog.csdn.net/liubo0_0/article/details/7452166
          *
          */
          
         view.transform = CGAffineTransformMakeScale(0.001, 0.001);
          
         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
          
         // 向右旋转45°缩小到最小,然后再从小到大推出.
         animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80)];
          
         /**
          *     其他效果:
          *     从底部向上收缩一半后弹出
          *     animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0)];
          *
          *     从底部向上完全收缩后弹出
          *     animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0)];
          *
          *     左旋转45°缩小到最小,然后再从小到大推出.
          *     animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.50, -0.50, 0.50)];
          *
          *     旋转180°缩小到最小,然后再从小到大推出.
          *     animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2)];
          */
          
         animation.duration = 0.45;
         animation.repeatCount = 1;
         [view.layer addAnimation:animation forKey:nil];
          
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.35f animations:^
          {
              view.transform = CGAffineTransformMakeScale(1.0, 1.0);
          }];
     }];
}
 
/** CABasicAnimation
 *
 *  @see https://developer.apple.com/library/mac/#documentation/cocoa/conceptual/CoreAnimation_guide/Articles/KVCAdditions.html
 *
 *  @brief                      便利构造函数 animationWithKeyPath: KeyPath需要一个字符串类型的参数,实际上是一个
 *                              键-值编码协议的扩展,参数必须是CALayer的某一项属性,你的代码会对应的去改变该属性的效果
 *                              具体可以填写什么请参考上面的URL,切勿乱填!
 *                              例如这里填写的是 @"transform.rotation.z" 意思就是围绕z轴旋转,旋转的单位是弧度.
 *                              这个动画的效果是把view旋转到最小,再旋转回来.
 *                              你也可以填写@"opacity" 去修改透明度...以此类推.修改layer的属性,可以用这个类.
 *
 *  @param toValue              动画结束的值.CABasicAnimation自己只有三个属性(都很重要)(其他属性是继承来的),分别为:
 *                              fromValue(开始值), toValue(结束值), byValue(偏移值),
 !                              这三个属性最多只能同时设置两个;
 *                              他们之间的关系如下:
 *                              如果同时设置了fromValue和toValue,那么动画就会从fromValue过渡到toValue;
 *                              如果同时设置了fromValue和byValue,那么动画就会从fromValue过渡到fromValue + byValue;
 *                              如果同时设置了byValue  和toValue,那么动画就会从toValue - byValue过渡到toValue;
 *
 *                              如果只设置了fromValue,那么动画就会从fromValue过渡到当前的value;
 *                              如果只设置了toValue  ,那么动画就会从当前的value过渡到toValue;
 *                              如果只设置了byValue  ,那么动画就会从从当前的value过渡到当前value + byValue.
 *
 *                              可以这么理解,当你设置了三个中的一个或多个,系统就会根据以上规则使用插值算法计算出一个时间差并
 *                              同时开启一个Timer.Timer的间隔也就是这个时间差,通过这个Timer去不停地刷新keyPath的值.
 !                              而实际上,keyPath的值(layer的属性)在动画运行这一过程中,是没有任何变化的,它只是调用了GPU去
 *                              完成这些显示效果而已.
 *                              在这个动画里,是设置了要旋转到的弧度,根据以上规则,动画将会从它当前的弧度专旋转到我设置的弧度.
 *
 *  @param duration             动画持续时间
 *
 *  @param timingFunction       动画起点和终点之间的插值计算,也就是说它决定了动画运行的节奏,是快还是慢,还是先快后慢...
 */
 
/** CAAnimationGroup
 *
 *  @brief                      顾名思义,这是一个动画组,它允许多个动画组合在一起并行显示.比如这里设置了两个动画,
 *                              把他们加在动画组里,一起显示.例如你有几个动画,在动画执行的过程中需要同时修改动画的某些属性,
 *                              这时候就可以使用CAAnimationGroup.
 *
 *  @param duration             动画持续时间,值得一提的是,如果添加到group里的子动画不设置此属性,group里的duration会统一
 *                              设置动画(包括子动画)的duration属性;但是如果子动画设置了duration属性,那么group的duration属性
 *                              的值不应该小于每个子动画中duration属性的值,否则会造成子动画显示不全就停止了动画.
 *
 *  @param autoreverses         动画完成后自动重新开始,默认为NO.
 *
 *  @param repeatCount          动画重复次数,默认为0.
 *
 *  @param animations           动画组(数组类型),把需要同时运行的动画加到这个数组里.
 *
 *  @note  addAnimation:forKey  这个方法的forKey参数是一个字符串,这个字符串可以随意设置.
 *
 *  @note                       如果你需要在动画group执行结束后保存动画效果的话,设置 fillMode 属性,并且把
 *                              removedOnCompletion 设置为NO;
 */
 
+ (void)animationRotateAndScaleDownUp:(UIView *)view
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 2];
 rotationAnimation.duration = 0.35f;
 rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     
 CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
 scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
 scaleAnimation.duration = 0.35f;
 scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
 CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
 animationGroup.duration = 0.35f;
 animationGroup.autoreverses = YES;
 animationGroup.repeatCount = 1;
 animationGroup.animations =[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil];
 [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
}
 
 
 
#pragma mark - Private API
 
+ (void)animationFlipFromTop:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"oglFlip"];
    [animation setSubtype:@"fromTop"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationFlipFromBottom:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"oglFlip"];
    [animation setSubtype:@"fromBottom"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationCubeFromLeft:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:@"fromLeft"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationCubeFromRight:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:@"fromRight"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationCubeFromTop:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:@"fromTop"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationCubeFromBottom:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:@"fromBottom"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationSuckEffect:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"suckEffect"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationRippleEffect:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"rippleEffect"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationCameraOpen:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cameraIrisHollowOpen"];
    [animation setSubtype:@"fromRight"];
     
    [view.layer addAnimation:animation forKey:nil];
}
 
+ (void)animationCameraClose:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cameraIrisHollowClose"];
    [animation setSubtype:@"fromRight"];
     
    [view.layer addAnimation:animation forKey:nil];
}
@end
----------------------------------------------------------


读取和写入plist文件 <==> NSDictionary

//写入plist文件：
                              
NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:@"/Sample.plist" ];
[ dict setObject:@"Yes" forKey:@"RestartSpringBoard" ];
[ dict writeToFile:@"/Sample.plist" atomically:YES ];
                              
//读取plist文件：
                              
NSMutableDictionary* dict =  [ [ NSMutableDictionary alloc ] initWithContentsOfFile:@"/Sample.plist" ];
NSString* object = [ dict objectForKey:@"RestartSpringBoard" ];
----------------------------------------------------------
使用base64, 将NSData --> NSString
> 下载 GTMBase64类库












