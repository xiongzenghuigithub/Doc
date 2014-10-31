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

安装:CocoaPods

1. 替换源为淘宝的
gem sources --remove https://rubygems.org/ 
gem sources -a http://ruby.taobao.org/ 
http://ruby.taobao.org/

2. 下载安装
sudo gem install cocoapods 

使用CocoaPods导入类库:

	1. 在工程根目录创建Podfile文件
		touch Podfile

	2. 在Podfile文件输入导入的类库
		文本编辑器打开Podfile文件
		
		如:
			platform :ios, '6.1'
			pod 'RestKit', '~> 0.23.3'

	3. 执行pod install命令 (在Podfile文件的当前路径)

------------------------------------------------
json: {}--字典,  []--数组
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

> iOS静态库打包

	1. 新建工程 --- Framework & Library
	2. 写完Framework项目后，直接编译，会生成 .h文件和.a实现文件(看不见源码的二进制文件)
			> 但是编译成 .a文件时, 要针对不同的平台编译 , 继而生成不同平台上可以使用的 .a 文件 
				1)iOS Device,编译出来的.a静态库文件是基于arm架构上的,即可在 - 真机(arm) - 上运行。
				2)iPhone Simulator,编译出来的静态库文件是基于i386架构的,可在 - 模拟器(i386) - 中运行
	3. 将不同平台下适用的.a文件, 统一打包成一个适用所有平台的.a文件
			> lipo -create i386平台的.a文件全路径 arm平台的.a文件 -output 通用.a文件的路径

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
苹果官方单例写法:

+ (NetworkManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static NetworkManager * sSharedInstance;
   
    dispatch_once(&onceToken;, ^{
        sSharedInstance = [[NetworkManager alloc] init];
    });
    return sSharedInstance;
}

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
	> 1. 异步执行请求
	> 2. 接受回调的代码块-Block
	> 3. 在回调的代码块Block中，传递加载到得服务器json

//1. get请求

//参数 1.url ,2.参数 ,3.回调block
- (void)getWithUrl:(NSString *)url 
		paramaters:(NSDictionary *)param 
   completeHandler:(void (^)(NSURLResponse *resp ,NSData *data ,NSError *error))handler {

   		//1.使用缓存 
   			> NSURLCache
   			> json保存到本地
   			> 将加载的数据NSData保存到本地Cache目录文件


   		//2.NSURLConnection sendAsyncChronousRequest
   			> NSOperationQueue 请求队列 - 全局单例存在

        [NSURLConnection sendAsynchronousRequest:request
                               queue:[RequestCenter sharedQueue]
                               completionHandler:^(NSURLResonse *response, NSData *data, NSError *error){
                        
            //mainQueue中，丢更新UI的block代码
            dispatch_async(dispatch_get_main_queue(),^{
                
                    if(handler) {
                        
                        //执行handler - 回调block, 并填充block需要的参数
                        handler(response,data,error);   
                    }
                });
          }];  
   }


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
> Block中得引发 retain cycle 错误

	> Block是什么？
		> 一个NSObject对象
		> 存在创建，释放等声明周期、
		> 也可以被一个该Block类型的变量所持有
		> 所以，Block就跟一般的对象，没有什么区别，所以也会产生内存不释放的问题


	> eg.1 - 非ARC下
	
	//下面这段代码会造成
		1. manager.complete变量持有Block对象
		2. Block对象又持有Manager对象
			> 相互持有, 形成2个都不能释放
	DoSomethingManager *manager = [[DoSomethingManager alloc] init];  
	manager.complete = ^{  
	    //...complete actions  
	    [manager otherAction];  
	    [manager release];  
	};  

	> 解决: 使Manager对象/Block对象 任一方，取消对另一方的持有

	DoSomethingManager *manager = [[DoSomethingManager alloc] init];  
	manager.complete = ^{  
		
		//1. block执行代码 
	    [manager otherAction];  

	    //2. 业务逻辑执行完后, 让Manager对象, 取消对当前Block对象的引用(持有/指向)
		manager.complete = nil;

		//3. 让Manager对象释放 --> Block对象跟着也会被释放
	    [manager release];  
	};  


	> eg.2 - ARC下

		> 使用 __weak、__block 修饰将要在Block内部使用的变量

		Manager * manager = [[DoSomethingManager alloc] init];  

		//复制一个weak指针指向Manager对象
		weak Manager * weak_manager = manager;

		manager.complete = ^{  

			//Block内部，使用Manager对象的weak指针变量
			[weak_manager otherAction];  
		}
----------------------------------------------------------


* 将所有请求的hosName/path/都封装起来，不像其他类暴露

大体逻辑顺序:

	> MKNetworkEngine维护一个NSOperationQueue(单例+静态)
	> MKNetworkEngine.NSOperationQueue添加多个MKNetWorkOperation操作
	> 一个MKNetWorkOperation操作, 内部又封装了一个NSMutableURLRequest请求对象
	> 将MKNetWorkOperation操作, 加入MKNetworkEngine.NSOperationQueue

1. MKNetworkEngine
	
	1) 一个MKNetworkEngine <--> 一个hostName(主机域名 -- 根路径) 		eg. /192.189.2.1/ 或 www.baidu.com/
		> 封装这个hostName下面所有child path的请求操作

	2) static NSOperationQueue *_sharedNetworkQueue 
			--> 静态单例NSOperationQueue队列 ,包含多个MKNetWorkOperation操作
			--> 一个MKNetworkOperation操作 , 包含一个NSMutableURLRequest请求对象
					(MKNetworkOperation -- 继承NSOperation，实现NSURLConnectionDataDelegate代理)

			
			eg.
				//path - hostName/子路径/
				//params - 访问改请求url，所需要提交的参数
				//httpMethod - Get/Post
				//SSL - 是否使用https:协议
				- (MKNetworkOperation *)oeprationWithPath:(NSString *)path
												   params:(NSDictionary *)dict
											   httpMethod:(NSString *)method 
											   SSL:(bool)ssl{
					//do somegthing

					//1. 构造完整URL
					NSString url = http://hostName/path/参数拼接 或者 https://hostName/path/参数拼接

					//2. 创建当前继承自MKNetWorkOperation子类的对象
					MKNetworkOperation *operation = [[self.customOperationSubclass alloc] initWithURLString:urlString params:body httpMethod:method];

					//2.1 在MKNetWorkOperation的init函数中, 创建了一个NSMutableURLRequest请求对象
					(
						* 在MKNetWorkOperation.initWithURLString:..函数中
						//1. 根据url创建NSMutableURLRequest
						//2. 设置请求get/post
						//3. 设置当前MKNetWorkOperation对象.state = MKNetworkOperationStateReady
					)

					//3. 给每一个MKNetWorkOperation对象, 做缓存 --> 给每一个MKNetWorkOperation对象，分配一个唯一的标示uniqueIdentifier
					(
						//1. 直接从MKNetworkEngine.memoryCache:(NSMutableDictionaet *)中查找 - 根据标示符uniqueIdentifier
						//2. 从本地文件读入,得到cacheData:(NSData *)
					)

					//4. 给MKNetWorkOperation对象, 设置回调代码块block --> 在请求完成/失败时候，回调执行
					(
						[MKNetWorkOperation对象 addCompletionHandler:请求完成执行的代码 errorHandler:请求失败执行的代码];

						//注意: block使用copy
					)

					//5. 把MKNetWorkOperation对象加入到MKNetworkEngine.NSOperationQueue队列中, 等待执行
					[MKNetworkEngine对象  enqueueOperation:op];
					(
						在enqueueOperation方法中

						1. 设置回调的保存缓存的代码块
						[operation setCacheHandler:(^)(MKNetworkOperation* completedCacheableOperation) {
							//将请求完成后的responseData:(NSData *)保存到缓存
							//1. 内存
							//2. 本地文件
						}];

						2.
						[_sharedNetworkQueue addOperation:operation];
					)

				}


	3) dispatch_queue_t backgroundCacheQueue -- 缓存队列

	4) dispatch_queue_t operationQueue -- 请求队列


	2. MKNetworkOperation

		1) 接受回调block
		typedef void (^block类项名字)(NSURLResponse *response, NSData *data, NSError *error);

		2) 在ios sdk的回调代码块中，执行接收的block

		3) 并将接收到的服务器数据，做为blokc的参数

----------------------------------------------------------
	
	单例宏

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [[self alloc] init]; \
        } \
    } \
    \
    return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname; \
        } \
    } \
    \
    return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\


----------------------------------------------------------

对请求的url进行数据缓存

	NSString *requestURL= @"http://www.baidu.com/"; 

	//得到全局缓存对象
    NSURLCache *urlCache = [NSURLCache sharedURLCache]; 

    /* 设置缓存的大小为1M*/
	[urlCache setMemoryCapacity:1*1024*1024]; 

    //创建一个nsurl 
	NSURL *url = [NSURL URLWithString:requestURL]; 

    //创建一个请求 
	NSMutableURLRequest *request = [NSMutableURLRequest
								requestWithURL:url 
								cachePolicy:NSURLRequestUseProtocolCachePolicy
								timeoutInterval:60.0f]; 

	//查询当前NSURLRequest是否已经缓存
	//1) 已经缓存:  直接从当前缓存取出数据
	//2) 没有缓存:  重新发起请求 
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request]; 

    //判断是否有缓存 
    if (response != nil){ 

        //如果有缓存输出，从缓存中获取数据
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad]; 

    } else {

    	//重新发起异步请求

    	//1. NSURLConnection
    	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //回调代码块
        }];

        //2. NSURLSession
        NSURLSessionConfiguration *sessionCfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionCfg delegate:self delegateQueue:queue];
        //通过session对象操作不同的api函数，进行不同的网络请求操作
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"...."]];

    }

    


----------------------------------------------------------

判断是否开启定位服务

if ([CLLocationManager locationServicesEnabled] &&  
                ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized  
                || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {  
                //定位功能可用，开始定位  
                _locationManger = [[CLLocationManager alloc] init];  
                locationManger.delegate = self;  
                [locationManger startUpdatingLocation];  
            }  
            else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){  
        NSlog("定位功能不可用，提示用户或忽略");   
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
//使用runtime查看私有api的所有方法


   1. 要导入#import <objc/runtime.h>
   2. 代码
   NSString *className = NSStringFromClass([UIView class]);
   //这里是uiview，可以改成自己想要的
    
   const char *cClassName = [className UTF8String];
    
   id theClass = objc_getClass(cClassName);
    
   unsigned int outCount;
    
   Method *m =  class_copyMethodList(theClass,&outCount;);
   
   NSLog(@"%d",outCount);
   for (int i = 0; i<outCount; i++) {
       SEL a = method_getName(*(m+i));
       NSString *sn = NSStringFromSelector(a);
       NSLog(@"%@",sn);
 
   }
----------------------------------------------------------
常见GCD使用

/**< 自定义queue，默认串行： NULL == DISPATCH_QUEUE_SERIAL*/

    dispatch_queue_t queue = dispatch_queue_create("label", NULL);    
    dispatch_async(queue, ^{
        NSLog(@"test");
    });
 
/**< 自定义queue，并行(DISPATCH_QUEUE_CONCURRENT)或串行(或DISPATCH_QUEUE_SERIAL) */
    dispatch_queue_t serial_queue = dispatch_queue_create("标签", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(serial_queue, ^(){

		// 尽管为异步调用且延迟3秒，但如果在serial队列中，block_1仍然先于block_2被打印出来,因为2个block任务都是在串行队列

        sleep(5);
        NSLog(@"block_1"); 
    });
    dispatch_async(serial_queue, ^(){
        NSLog(@"block_2");
    });
     
/**< 延迟执行*/
    /**< (int64_t)(delayInSeconds * NSEC_PER_SEC)：转换成毫秒*/
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"5s delay");
    });
     
/**< 常用的异步并发执行*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{
        sleep(5);//睡眠
        NSLog(@"block_1");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{
        NSLog(@"block_2");
    });
   
/**< 异步并回调主线程，常用ui更新*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{//自定义队列
        dispatch_async(dispatch_get_main_queue(), ^{//UI主线程队列
             //修改UI的数据
        });
    });

----------------------------------------------------------
后台播放音乐

AVAudioSession *session = [AVAudioSession sharedInstance];    
[session setActive:YES error:nil];    
[session setCategory:AVAudioSessionCategoryPlayback error:nil];   
 
//以及设置app支持接受远程控制事件代码。设置app支持接受远程控制事件，
//其实就是在dock中可以显示应用程序图标，同时点击该图片时，打开app。
//或者锁屏时，双击home键，屏幕上方出现应用程序播放控制按钮。
[[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; 
 
//用下列代码播放音乐，测试后台播放
// 创建播放器  
AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];  
[url release];  
[player prepareToPlay];  
[player setVolume:1];  
player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环  
[player play]; //播放
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
webview 加载 html, javascript等脚本

1) 网络url指向的html
NSURL *urlBai=[NSURL URLWithString:@"http://www.baidu.com"];
NSURLRequest *request=[NSURLRequest requestWithURL:urlBai];
[twoWebView loadRequest:request];
[webView addSubview:twoWebView];

2) 本地html文件
NSString *htmlString=@"我的<b>iPhone</b>程序";
[self.myWebView loadHTMLString:htmlString baseURL:nil];

2) javascript
[webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];  

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

----------------------------------------------------------
iOS本地推送

第一步：创建本地推送  

// 创建一个本地推送  
UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];  

//设置10秒之后  
NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];  

if (notification != nil) {  
   
    // 设置推送时间  
    notification.fireDate = pushDate;  
    // 设置时区  
    notification.timeZone = [NSTimeZone defaultTimeZone];  
    // 设置重复间隔  
    notification.repeatInterval = kCFCalendarUnitDay;  
    // 推送声音  
    notification.soundName = UILocalNotificationDefaultSoundName;  
    // 推送内容  
    notification.alertBody = @"推送内容";  
    //显示在icon上的红色圈中的数子  
    notification.applicationIconBadgeNumber = 1;  
    //设置userinfo 方便在之后需要撤销的时候使用  
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];  
    notification.userInfo = info;  
    //添加推送到UIApplication         
    UIApplication *app = [UIApplication sharedApplication];  
    [app scheduleLocalNotification:notification];   
      
}  
   
第二步：接收本地推送  
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iWeibo" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];  
    [alert show];  
    // 图标上的数字减1  
    application.applicationIconBadgeNumber -= 1;  
}  
   
第三步：解除本地推送  
// 获得 UIApplication  
UIApplication *app = [UIApplication sharedApplication];  

//获取本地推送数组  
NSArray *localArray = [app scheduledLocalNotifications];  

//声明本地通知对象  
UILocalNotification *localNotification;  
if (localArray) {  
    for (UILocalNotification *noti in localArray) {  
        NSDictionary *dict = noti.userInfo;  
        if (dict) {  
            NSString *inKey = [dict objectForKey:@"key"];  
            if ([inKey isEqualToString:@"对应的key值"]) {  
                if (localNotification){  
                    [localNotification release];  
                    localNotification = nil;  
                }  
                localNotification = [noti retain];  
                break;  
            }  
        }  
    }  
      
    //判断是否找到已经存在的相同key的推送  
    if (!localNotification) {  
        //不存在初始化  
        localNotification = [[UILocalNotification alloc] init];  
    }  
      
    if (localNotification) {  
        //不推送 取消推送  
        [app cancelLocalNotification:localNotification];  
        [localNotification release];  
        return;  
    }  
}
----------------------------------------------------------
CoreData简单使用

//假设已经在项目文件中创建了名为Person的对象（实体，Entity）
//首先，需要在使用Person实例类的代码头文件中加入：
 
#import <UIKit/UIKit.h> 
#import <CoreData/CoreData.h> 
#import "Person.h"
 
使用core data的简单代码，创建一个Person实体实例，保存它，然后遍历数据，相当于：select * from persons：
 
//1. 获取Person类的描述
Person *person=(Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[self managedObjectContext]]; 

person.name=@"张三";
 
NSError *error;
 
if (![[self managedObjectContext] save:&error;]) { 
    NSLog(@"error!"); 
}else { 
    NSLog(@"save person ok."); 
}
 
NSFetchRequest *request=[[NSFetchRequest alloc] init]; 
NSEntityDescription *entity=[NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]]; 
[request setEntity:entity];
 
NSArray *results=[[[self managedObjectContext] executeFetchRequest:request error:&error;] copy];
 
for (Person *p in results) { 
    NSLog(@">> p.id: %i p.name: %@",p.id,p.name); 
}
 
//如果需要删除也很简单：
 
[managedObjectContext deleteObject:person];
----------------------------------------------------------
NSKeyedArchiver -- 把一个对象数组，归档存储到本地文件

Person * p1 = [[Person alloc] init]; 
NSArray *Array = [NSArray arrayWithObjects:str, astr, nil];  
       
//保存数据  
NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; NSString *filename = [Path stringByAppendingPathComponent:@"test.plist"];  
[NSKeyedArchiver archiveRootObject:Array toFile:filename];  
       
str = @"a";  
astr = @"";  
       
//加载数据  
NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];  
str = [arr objectAtIndex:0];  
astr =  [arr objectAtIndex:1]; 

----------------------------------------------------------
json 映射  对象

//1. 导入 <objc/runtime.h>

//2. 获取Class对象的所有属性(属性的名字、属性的类型)
unsigned int count;
objc_property_t * properties = class_copyPropertyList(cls, &count);

for (int i = 0; i < count; ++i)
{
	objc_property_t property = properties[i];
	const char * propertyName = property_getName(property);
	const char * propertyType = getPropertyType(property);
}

//获取属性的类型
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}


//3. 











