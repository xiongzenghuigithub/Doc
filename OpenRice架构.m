--------------------------------------------------------------------------------

对象.属性 = 值 的调用过程:

RestaurantDetail的
-(NSArray*) phoneArray

--------------------------------------------------------------------------------
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif
--------------------------------------------------------------------------------
对于像城市列表等不会变动的服务器数据，只应该请求一次，就保存到本地，以后至访问本地数据库

	1. 第一次异步加载数据
	2. 使用和sqlite保存到本地DB文件
			> 创建本地DB对应的表
			> 将异步加载的数据, 作为数据记录插入到表
	3. 可以做缓存
		> 永远不变的数据
		> 不常变的数据
		> 隔一段时间变化的数据
			> 超过时间, 重新请求服务器数据 ,再保存到本地


--------------------------------------------------------------------------------
城市切换点击事件:

	CityListSelectionView.buttonUp方法

城市获取list:
	SettingManager:
	getRegionListFromJSONData方法


--------------------------------------------------------------------------------
#define LOCAL_CURRENT_REGION                            @"CurrentRegion"
#define LOCAL_CURRENT_REGION_NAME                       @"CurrentRegionName"
#define LOCAL_CURRENT_REGION_TITLE_NAME					@"CurrentRegionTitleName"
#define LOCAL_CURRENT_LANGUAGE                          @"CurrentLanguage"
#define LOCAL_API_TOKEN_KEY                             @"ApiTokenKey"
#define LOCAL_CURRENT_AREA_CODE                         @"CurrentAreaCode"
--------------------------------------------------------------------------------
//搜索框的所有记录的要显示的图片类型
typedef enum{
    Tips_ShopId             = 0,		//商店 --》商店
    Tips_ChainId            = 1,		//连锁 --》商店
    Tips_UserRecommedDish   = 2,
    Tips_SignatureDish      = 3,
    Tips_DistrictId         = 4,
    Tips_LandmarkId         = 5,
    Tips_CuisineId          = 6,		//菜式	
    Tips_DishId             = 7,		//食品
    Tips_AmenityId          = 8,		//美容 --》商店
    Tips_ThemeId            = 9,
    // RMS
    Tips_CompanyId          = 10
} SearchTipsType;

--------------------------------------------------------------------------------
** 所有子控制器push出时对应的type值 **

typedef enum {
	IndexIconsTypeAdvSearch = 1,
	IndexIconsTypeNearby = 2,
	IndexIconsTypeBookmark = 3,
	IndexIconsTypeCoupon = 4,
	IndexIconsTypeReservation = 5,
	IndexIconsTypeAward = 6,
	IndexIconsTypeChart = 7,
	IndexIconsTypeRandomSearch = 8,
	IndexIconsTypeAE = 9,
	IndexIconsTypeHotpot = 10,
	IndexIconsTypeBuffet = 11,
	IndexIconsTypeHotNews = 12,
	IndexIconsTypeSeason = 13,
	IndexIconsTypeLatestReview = 14,
	IndexIconsTypeSnapShare = 15,
	IndexIconsTypeWebLink = 16,
	IndexIconsTypeRestaurantDetail = 17,
	IndexIconsTypeCouponDetail = 18,
    IndexIconsTypeMyOpenRice = 19,
    IndexIconsTypeHome = 20,
    IndexIconsTypeQRScanner = 21,
    IndexIconsTypeMyCoupons = 22,
    IndexIconsTypeSetting = 23,
	IndexIconsTypeMyBookmark = 24,
    // Not yet handled in App
//    IndexIconsTypeHotNewsDetail = 25,
    IndexIconsTypeURLScheme = 26,
    IndexIconsTypeFBFanPage = 27

}IndexIconsType;

--------------------------------------------------------------------------------
DatabaseManager -- 得到app的手机目录
checkDatabase方法： lldb po dbPath
---------------------------------------------------------------------------
1. 公共类的封装
	> UI控件的增强 - Catagory
	> 宏定义

		> AppConfig.h: 
			> 定义一些项目APP有关的宏(sinaWeiBo..)

		> Common-Config.h: 
			> NSLog打印的宏代替
			> 项目所有用到的通知(NSNotification)的Key
			> 常用方法
				> 设置/获取当前APP的语言环境
				> 获取国际化文件的key对应的value
				> 获取OS_Version , 屏幕尺寸 , 屏幕方向 

		> Config.h
			> APP相关配置
				> APP_TYPE: 当前项目代码APP 所适合的硬件平台(Android/iPhone/WindowsPhone..)
				> APP_VER: APP的 版本号 -- [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
				> API_VER: 项目代码的 版本号
			> 常用单例对象的宏定义
				> #define APP_DELEGATE  		(AppDelegate*)[[UIApplication sharedApplication] delegate]
				> #define ROOT_VC				[APP_DELEGATE rootVC]

---------------------------------------------------------------------------
				> 项目所有模块对应的 - 网络请求manager对象 - 单例对象的宏定义
					-- 每一个模块的网络请求都封装到对应的 XxxManager类 中

					>将服务器JSON数据 --> 实体对象  的Manager
					#define JSON_MANAGER                (JsonManager *)[[AppManager sharedAppManager] jsonManager]

					>所有网络请求的Manager
				 	#define APP_MANAGER					[AppManager sharedAppManager]
					#define RESTAURANT_MANAGER          (RestaurantManager *)[[AppManager sharedAppManager] restaurantManager]
					#define RESTAURANT_DETAIL_MANAGER   (RestaurantDetailManager *)[[AppManager sharedAppManager] ]
					#define BUFFET_MANAGER              (BuffetManager *)[[AppManager sharedAppManager] buffetManager]
					#define HOTPOT_MANAGER              (HotpotManager *)[[AppManager sharedAppManager] hotpotManager]
					#define REVIEW_MANAGER              (ReviewManager *)[[AppManager sharedAppManager] reviewManager]
					#define PHOTO_MANAGER               (PhotoManager *)[[AppManager sharedAppManager] photoManager]
					#define SETTING_MANAGER             (SettingManager *)[[AppManager sharedAppManager] settingManager]
					#define FONT_MANAGER                (FontManager *)[[AppManager sharedAppManager] fontManager]
					#define CHART_MANAGER               (ChartManager *)[[AppManager sharedAppManager] chartManager]
					#define HOTNEWS_MANAGER             (HotnewsManager *)[[AppManager sharedAppManager] hotnewsManager]
					#define INDEX_MANAGER               (IndexManager *)[[AppManager sharedAppManager] indexManager]
					#define SEARCH_MANAGER              (SearchManager *)[[AppManager sharedAppManager] searchManager]
					#define DATABASE_MANAGER            (DatabaseManager *)[[AppManager sharedAppManager] databaseManager]
					#define BOOKMARK_MANAGER            (BookmarkManager *)[[AppManager sharedAppManager] bookmarkManager]
					#define ACCOUNT_MANAGER             (AccountManager *)[[AppManager sharedAppManager] accountManager]
					#define COUPON_MANAGER              (CouponManager *)[[AppManager sharedAppManager] couponManager]
					#define FACEBOOK_MANAGER            (FacebookManager *)[[AppManager sharedAppManager] facebookManager]
					#define CONTACTUS_MANAGER           (ContactUsManager *)[[AppManager sharedAppManager] contactUsManager]
					#define PAYPAL_MANAGER              (PayPalManager *)[[AppManager sharedAppManager] paypalManager]
					#define TWITTER_MANAGER             (TwitterManager *)[[AppManager sharedAppManager] twitterManager]
					#define GA_MANAGER                  (GAManager *)[[AppManager sharedAppManager] gaManager]
					#define PUSH_MANAGER                (PushManager *)[[AppManager sharedAppManager] pushManager]
					> 是用Manager来封装网络请求的优点:
						让Manager类类直接耦合ASIHTTPRequest或MKNetWorkKit
						而项目中只需要耦合Manager类
						项目其他类就没有直接耦合第三方库的代码
						日后改为另一个网络第三方库实现网络请求，就不会给项目带来很大的麻烦，只需要改动所有的Manager即可，其他项目代码不用改
---------------------------------------------------------------------------
					> 一切网络请求 --> 异步
						给Manager设置一个回调Block , 用于请求成功后 , 让Manager回传Json解析后的实体对象数据

---------------------------------------------------------------------------

		> plist文件: 
			> 定义APP内需要的配置内容(key-value)
---------------------------------------------------------------------------

2. 项目的类结构
	
	> 基类
		> BaseViewController
			控制器基类 , 用于写一些控制器所具有相同的功能(部分代码)
		> BaseUIView
			一些视图view的基类
			> UI控件中可以加入异步加载图片(其他数据)的代码 - 回调block中，更新UI要显示的数据

	> 一个模块所包含的

		> ViewControllers(一个模块包含多个显示界面--多个控制器 来管理):
			继承自 BaseViewController

			> 一个ViewController的代码结构:
				> init方法
					初始化所有需要显示的UI控件 、 工具类 

				> ViewDidLoad方法
					> initSubViews方法
						> 初始化UI控件 , 添加到 ViewController.view 上
						> 初始化子控件 , 分模块、分步骤、分方法 , 来按顺序创建 UI控件对象 , 并添加到 Controller.view

				> 给Manager设置的回调Block被调用后 , 给创建好的 UI控件对象 设置需要显示的数据

				> 点击事件 ---- (一个按钮 一定是对应 一个控制器)
					> UIButton: 
						push之前, 先给子控制器 setXxxx 需要的参数值
						self.navigationController.pushViewController:其他子控制器
					> UITableViewCell: 
						push之前, 先给子控制器 setXxxx 需要的参数值
						self.navigationController.pushViewController:其他子控制器
---------------------------------------------------------------------------
				> didReceiveMemoryWarining方法
					> 释放当前控制器, 所不需要的 UI控件对象、代理对象、Manager对象、各种缓存数据...
						> 判断当前控制器 在UINavigatioController的控制器栈中 是否处于底部  -- 判断当前控制器 是否是 RootViewController
							> 不是, 直接释放掉该控制器所持有的所有对象
								> controller.subViews(成员变量形式) 一个一个接着 release
								> @property属性 = nil;
								> 代理对象 = nil;
---------------------------------------------------------------------------
				> dealloc方法
					> [成员变量 release];
					> @property属性 = nil;
					> delegate = nil; 

---------------------------------------------------------------------------
				> setXxx方法 (类指针，数组..)
					> 1. [当前成员变量 release]; //对nil的指针进行release，不会报错
					> 2. 当前成员变量 = [传进来的指针变量 retain];
---------------------------------------------------------------------------
				> ASIFormDataRequest创建、异步请求、内存管理
					> 1. 声明成员变量 ASIFormDataRequest *request;
					> 2. 取消request指针所有之前数据
							[request clearDelegatesAndCancel];
							[request release];
					> 3. 创建ASIFormDataRequest对象
							request = [[xxx_xxxManager getXXXXXX: callBack:@selector(didGetPhotoDetail:)] retain];
					> 4. 回调函数didGetPhotoDetail:接收响应的json, 并解析成实体对象返回
					> 5. dealloc方法中，对request指针指向的ASIFormDataRequest对象释放
							[request release];
							requet = nil;
---------------------------------------------------------------------------

		> views: 
			继承自 BaseUIView
		> Manager:
			封装该模块(控制器)所有的网络请求代码实现细节
			ViewController给Manager设置回调Block代码 , 等待数据成功响应返回后 , 才来更新UI上显示的数据
		> Modules:
			所有该模块相关的实体类 - Entity
			> 对象(数据)的存储
				> plist - 本地文件 - 序列化对象
				> UserDefault - 内存 - 键值对形式存储
				> CoreData -关系型数据库 - 存储
				> SQLite API - sqlite嵌入式数据库 - 存储

3. App启动流程
---------------------------------------------------------------------------
	> AppDelegate
		> [AppDelegate.window setRootViewController:RoorViewController];
---------------------------------------------------------------------------
	> RoorViewController -- 不显示数据,只是一个界面框架布局的容器,并且实现了UINavigationControllerDelegate --> (RoorViewController是UINavigationController)
		> RoorViewController.viewDidLoad方法  
			> initSubViews方法
				> IndexPageViewController -- APP主界面控制器 -- [RootViewController.view addSUbview:IndexPageViewController.view];
					> 子视图:searchBoxView:QuickSearchBoxView -- IndexPageViewController.view 顶部搜索框
					> 子视图:bannerSV:UIScrollView -- IndexPageViewController.view 中间的滚动广告栏
					> 子视图:iconSV:UIScrollView -- IndexPageViewController.view 底部的所有子选项按钮群
						> 创建从IndexPageViewController.view主页 , 点击按钮 ,push到另外的子控制器的按钮选项
							> relayoutIndexIcon方法
								> 获取所有push按钮的图片 -- 通过Manager访问coreData本地数据库文件
								> 创建每一个选项按钮 --> push到对应的子控制器模块
									> IndexIcon: 选项的图片
										> iconType属性: 每一个选项都有一个唯一的type值
										> iconUrl属性: 每一个选项对应的网络请求baseUrl
									> IndexIconView: 每一个选项容器View
										> 依赖一个IndexIcon对象 -- 做为内部按钮的显示的图片
										> ORButton按钮 --> 按钮点击事件 , 用来pushViewController
											> 按钮事件方法: IndexIconView.buttonAction:
												> buttonAction: -- push child viewControllers
													- (void)buttonAction:(id)sender{

														//这里调的ROOT_VC(RootViewControlelr)的push方法
														[ROOT_VC pushVCWithType:type andDict:nil animated:YES];
													}
													> 根据log出得子控制器类名 --> 找对应的ViewController
								> 将创建好的IndexIconView选项 ,一次添加到 iconSV

		> [ROOT_VC pushVCWithType:type andDict:nil animated:YES] --> 负责由IndexPageViewController.view.iconSV.所有子模块的push控制器操作
			>1. ROOT_VC(RootViewController)实现了UINavigationControllerDelegate --> UINavigationController
			>2. ROOT_VC.pushVCWithType: andDict: animated:方法中
				> 根据传入的type值(IdexIconView.ORButton.tag)来决定classStr=type值对应的类名
				> 判断拼接完成的完整ClassName，做一些特别的处理: 加载数据、UI、..
				> 实例化该ClassName对应的控制器类
					Class vc = NSClassFromString(className);
					UIViewController *vc = [[vc alloc] init];
				> 最后调用[ROOT_VC.navigationController pushViewController:vc];
---------------------------------------------------------------------------
				> DragDownMenuView -- 导航栏上得那个点击可以下拉的列表按钮

				> DragUpMenuView -- 一个ORButton按钮项 就push出 一个viewController
					> shareBtn 
						action -- shareBtnDidPress: 方法
					> bookmarkBtn
						action -- bookmarkBtnDidPress: 方法
							> BookmarkView
							> BookmarkManager
					> reviewBtn
						action -- reviewBtnDidPress: 方法
					> photoBtn
						action -- photoBtnDidPress: 方法
							> EditPhotoViewController 
								> @selector(openCamera) - UploadPhoto_TakePhoto
								> @selector(showImagePicker) - UploadPhoto_ChooseFromLibrary
									> 都是 present view Controller to ELCAlbumPickerController
									> EditPhotoViewController 是 ELCImagePickerController 的代理
---------------------------------------------------------------------------

	> 由IndexPageViewController push出来的子控制器模块:

		> SearchAdvancedSearchListViewController - Advanced Search按钮点击
			> subViews组成结构:

		> NearbyListViewController - NearBy按钮点击
			> subViews组成结构:

		> ReservationListViewController - Reservation按钮点击
			> subViews组成结构:

		> CouponListViewController - Hot Offer按钮点击
			> subViews组成结构:
				> CouponDetailViewController - 优惠券详情

		> MyOpenRiceViewController - MyOpenRice按钮点击
			> LoginScreenViewController - 先登录成功后，才能到MyOpenRiceViewController
			> subViews组成结构:

		> MyBookmarkViewController - MyRestaurant按钮点击
			> LoginScreenViewController - 先登录成功后，才能到MyOpenRiceViewController
			> subViews组成结构:

		> RestaurantChartViewController - Chart按钮点击
			> subViews组成结构:

		> LatestReviewViewController - Review按钮点击
			> subViews组成结构:

		> RandomListViewController - Random按钮点击 - 商店列表
			> subViews组成结构:

				> UITabkeView的dataSource、delegate方法 --> 封装在RestaurantListBaseViewController中

				> 实体类: RestaurantListItem
					> 有得实体是赞助商
						> item.isSponsor判断

				> RestaurantListCell - (cell)
					> item.isSponsor=YES
						> [self createSponsorCell:item]
					> item.isSponsor=NO
						> [self createListCellForRecordItem:item]	

				> OverviewViewController - cell点击后 push viewController
					> OverviewView - 具体展示相关subViews
						> TabsView - 选项卡切换: Info、Reiview、photo
							> 内部封装三个对应选项卡的view
								> InfoView 
									> 添加的ScrollView: 最新照片 - (en.strings:  "RestaurantInfo_Photos" = "Latest Photos" )
										> infoView.detail.thumbnailArray - NSMutableArray
											> 元素: PhotoDetail
								> ReviewView
								> WaterFallPhotoView


		> QRScannerViewController - OR Code Scanner按钮点击
			> subViews组成结构:

		> SettingViewController - Settings按钮点击
			> subViews组成结构:

		> EditPhotoViewController - DragUpMenu中得upload photo按钮 push的
			> DragUpMenu.photoBtnDidPress:按钮点击事件
				> 上传的一个图片对应的实体类 - UploadPhotoItem

		> OverviewViewController: 详情界面

		> PhotoDetailViewController: 图片大图展示
			> reviewHeader:DetailHeaderView - 顶部信息
				> 方法: reloadHeaderAndCaption
				> woodBgIV
				> thumbnailIV
				> userGradeIV
				> nameLbl
				> titleLbl
				> expandTitleBtn
			> detailView:PhotoDetailView - 显示图片
				>方法: reloadContent

			> PhotoDetailViewController.reloadHeaderAndCaption方法 - headerView
			> PhotoDetailViewController.reloadContent方法 - content
---------------------------------------------------------------------------

		> TabsView - 选项卡
			> 三个选项卡切换
				> infoBtn:InfoView
				> reviewsBtn:ReviewView
				> photosBtn:WaterFallPhotoView

				> 三个按钮的点击事件都在一个方法处理 - buttonAction:

					* 强制令某个tab选中(强制触发对应tab的点击事件) --> [TabsView performSelector:@slector(buttonAction:) withObj:nil];
						> 可以加个tag标示，强制选中哪个tab

					>1. 判断当前的tab
						> case 1:currentTab = TabsTypeInfo
						> case 2:currentTab = TabsTypeReviews;
						> case 3:currentTab = TabsTypePhotos;
					>2. loadContent方法 - 加载对应tab的数据
						> loadDataSource方法
							> photoRequest = [[PHOTO_MANAGER getPhotoListWithPoiId....  callback:@selector(didGetPhoto:)] retain]
								> didGetPhoto: 回掉方法中，reloadContent - 执行数据源方法
									> 瀑布流数据源方法
										> -(NSInteger)numberOfViewsInCollectionView
										> -(PSCollectionViewCell *)collectionView: viewAtIndex:
											> 自定义cell - PSBroView
												> [v:(PSBroView) fillViewWithPhotoDetail:photoDetail];
													> [self.imageView loadImageFromURL:[NSURL URLWithString:photoDetail.photoUrlSmall]];
										> -(CGFloat)heightForViewAtIndex:
										> - (void)collectionView: didSelectView:
											> PhotoDetailViewController - push到得控制器
												> PhotoDetailView
													>[photoIV loadImageFromURL:[NSURL URLWithString:[photoDetail photoUrlLarge]]];
            										>[photoIV loadImageFromURL:[NSURL URLWithString:self.menuFile.fileUrlLarge]];
												    >[photoIV loadImageFromURL:[NSURL URLWithString:self.menuFile.fileUrlSmall]];

			> loadContent方法 - 加载数据
---------------------------------------------------------------------------
	> NavigationBaseViewController:UINavigationController - 控制全局UI风格、所有控制器跳转的拦截

		> 如何让做到？ 
			push之前 , 设置ViewController.title  ---> 会调用 BaseNavigationController.setTitle:
				> 1. 当前ViewController : BaseNavigationController -- (当前控制器也是一个UINavigationController)
				> 2. 所以当 ， [当前ViewController setTitle:@""] 时,一定会调用当前ViewController的父类BaseNavigationController.setTitle:方法
				> 3. 就造成继承自BaseNavigationController的子类，调用setTitle:时，自动进入BaseNavigationController.setTitle:方法中

			* 都会经过 BaseNavigationController.setTitle: 方法
				* 在该方法里面，进行额外的设置UI、Font..的代码
			> 1. 实例化控制器
			> 2. 给控制器设置需要的参数值
			> 3. 控制器.title = @"....";
			> 4. pushViewController

---------------------------------------------------------------------------

4. XxxManaer
	
	> BookmarkManager: - 收藏管理
		> getBookmarkCategoryListWithDelegate - 获取收藏分类(1.Family Gath.. 2.Dating 3.BusinessMetting 4.FriendGathe.. 5.FoodDelivery)
		
	> RestaurantDetailManager

	> COUPON_MANAGER - 优惠券
		> BookmarkResponse *bkResponse = [COUPON_MANAGER getbookmarkCouponResultFromJSONData:[request responseData]];
		> [bkResponse.couponIsBookmarkExist isEqualToString:@"1"] - 是否已经抽藏优惠券

		> [BOOKMARK_MANAGER checkBookmarkStatusWithPoiId:poiId
											  delegate:self
											  callback:@selector(didGetBookmarkStatus:)];
            > [bookmarkResponse couponIsBookmarkExist]


            [COUPON_MANAGER addBookmarkCouponWithCouponId:couponId
                                             delegate:topVC
                                             callback:@selector(didBookmarkCoupon:)];

            BookmarkResponse *bkResponse = [COUPON_MANAGER getbookmarkCouponResultFromJSONData:[request responseData]];

            [bkResponse.couponIsBookmarkExist isEqualToString:@"1"]

--------------------------------------------------------------------------------
Config.h 定义push到所有子控制器界面的id值

typedef enum {
	IndexIconsTypeAdvSearch = 1,
	IndexIconsTypeNearby = 2,
	IndexIconsTypeBookmark = 3,
	IndexIconsTypeCoupon = 4,
	IndexIconsTypeReservation = 5,
	IndexIconsTypeAward = 6,
	IndexIconsTypeChart = 7,
	IndexIconsTypeRandomSearch = 8,
	IndexIconsTypeAE = 9,
	IndexIconsTypeHotpot = 10,
	IndexIconsTypeBuffet = 11,
	IndexIconsTypeHotNews = 12,
	IndexIconsTypeSeason = 13,
	IndexIconsTypeLatestReview = 14,
	IndexIconsTypeSnapShare = 15,
	IndexIconsTypeWebLink = 16,
	IndexIconsTypeRestaurantDetail = 17,
	IndexIconsTypeCouponDetail = 18,
    IndexIconsTypeMyOpenRice = 19,
    IndexIconsTypeHome = 20,
    IndexIconsTypeQRScanner = 21,
    IndexIconsTypeMyCoupons = 22,
    IndexIconsTypeSetting = 23,
	IndexIconsTypeMyBookmark = 24,
    // Not yet handled in App
//    IndexIconsTypeHotNewsDetail = 25,
    IndexIconsTypeURLScheme = 26,
    IndexIconsTypeFBFanPage = 27

}IndexIconsType;
--------------------------------------------------------------------------------
//
//  Config.h
//  GTFramework
//
//  Created by Kevin Chan on 17/7/12.
//  Copyright (c) 2012 Green Tomato. All rights reserved.
//

#ifndef CONFIG_H
#define CONFIG_H


#import <Foundation/Foundation.h>
#import "AppManager.h"

////////////////////////////////////////////////////////////////////////////
// 1. Server Setting

/**
 *  APP_DEPLOYMENT_MODE
 *  0 -> Undefine 
 *  1 -> Lab release (E.g. client staging server)
 *  2 -> Production release (E.g. real production server)
 */
#ifndef APP_DEPLOYMENT_MODE 
//    #error "Please define 'APP_DEPLOYMENT_MODE'"
    #define APP_DEPLOYMENT_MODE 3
#endif

#define SVN_VER_NO @"06cc121de0dd3fb03ff9fc25cabb7c7579935801"

#if APP_DEPLOYMENT_MODE == 1
// Removed due to no longer in use
#elif APP_DEPLOYMENT_MODE == 2

#if (PRODUCTION == 1)
#define SHOW_DEBUG_VERSION                      0
#else
#define SHOW_DEBUG_VERSION                      1
#endif

#define SVN_NUMBER                              [NSString stringWithFormat:@"%@ (STAGING)", SVN_VER_NO]

#if (SG == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-SG.h"
#else
#import "../Configuration/Staging/Config-Staging-SG.h"
#endif

#elif (TH == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-TH.h"
#else
#import "../Configuration/Staging/Config-Staging-TH.h"
#endif

#elif (INDONESIA == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-ID.h"
#else
#import "../Configuration/Staging/Config-Staging-ID.h"
#endif

#elif (MY == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-MY.h"
#else
#import "../Configuration/Staging/Config-Staging-MY.h"
#endif

#elif (PH == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-PH.h"
#else
#import "../Configuration/Staging/Config-Staging-PH.h"
#endif

#elif (INDIA == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-IN.h"
#else
#import "../Configuration/Staging/Config-Staging-IN.h"
#endif

#elif (TW == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-TW.h"
#else
#import "../Configuration/Staging/Config-Staging-TW.h"
#endif

#elif (CN == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-CN.h"
#else
#import "../Configuration/Staging/Config-Staging-CN.h"
#endif

#elif (HK == 1)

#if (PRODUCTION == 1)
#import "../Configuration/Production/Config-Production-HK.h"
#else
#import "../Configuration/Staging/Config-Staging-HK.h"
#endif

#endif

// Google Plus Server ID.  Should be same for all regions.  This one is for staging and production.
#define GOOGLE_PLUS_SERVER_ID           @"681486649361-8c2a5rub1v79k4v1f80h7qfkgskdnfns.apps.googleusercontent.com"

#elif APP_DEPLOYMENT_MODE == 3

#define SHOW_DEBUG_VERSION                      1
#define SVN_NUMBER                              [NSString stringWithFormat:@"%@ (UAT)", SVN_VER_NO]

#if (SG == 1)
#import "../Configuration/UAT/Config-UAT-SG.h"
#elif (TH == 1)
#import "../Configuration/UAT/Config-UAT-TH.h"
#elif (MY == 1)
#import "../Configuration/UAT/Config-UAT-MY.h"
#elif (INDONESIA == 1)
#import "../Configuration/UAT/Config-UAT-ID.h"
#elif (PH == 1)
#import "../Configuration/UAT/Config-UAT-PH.h"
#elif (INDIA == 1)
#import "../Configuration/UAT/Config-UAT-IN.h"
#elif (TW == 1)
#import "../Configuration/UAT/Config-UAT-TW.h"
#elif (CN == 1)
#import "../Configuration/UAT/Config-UAT-CN.h"
#else
#import "../Configuration/UAT/Config-UAT-HK.h"
#endif

#warning "Current Mode: Lab-Release"

// Google Plus Server ID.  Should be same for all regions.  This one is for UAT.
#define GOOGLE_PLUS_SERVER_ID           @"186770535321-k59k2m16a8l6i32jfh0vgfqok4a4i9vg.apps.googleusercontent.com"

#else
    #error "Unknown APP_DEPLOYMENT_MODE"
#endif

// API Common Parameter

#ifndef APP_VER
#define APP_VER                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#endif

#ifndef API_VER
#define API_VER                                 @"401"
#define API_VER_SR1                             @"402"
#define API_VER_SNSConnect                      @"402"
#endif

#if (SG == 1)
#import "../Configuration/Common/Config-Common-SG.h"
#elif (TH == 1)
#import "../Configuration/Common/Config-Common-TH.h"
#elif (INDONESIA == 1)
#import "../Configuration/Common/Config-Common-ID.h"
#elif (MY == 1)
#import "../Configuration/Common/Config-Common-MY.h"
#elif (PH == 1)
#import "../Configuration/Common/Config-Common-PH.h"
#elif (INDIA == 1)
#import "../Configuration/Common/Config-Common-IN.h"
#elif (TW == 1)
#import "../Configuration/Common/Config-Common-TW.h"
#elif (CN == 1)
#import "../Configuration/Common/Config-Common-CN.h"
#elif (HK == 1)
#import "../Configuration/Common/Config-Common-HK.h"
#endif

// Google Map Key
#define GOOGLE_MAP_KEY                          @"AIzaSyB-_iHVGvGjX5hgXp4_T6zEsy8HyRFxXp4"

#ifndef HOCKEY_APP_BETA_IDENTIFIER
#define HOCKEY_APP_BETA_IDENTIFIER              @""
#define HOCKEY_APP_LIVE_IDENTIFIER              @""
#endif

////////////////////////////

// TODO, by Gary

#define NEW_RELIC_APP_ID                @""

// Facebook Account
// update in *.plist

/////////////////////////////

////////////////////////////////////////////////////////////////////////////
// 2. Manager Setting
typedef enum {
	IndexIconsTypeAdvSearch = 1,
	IndexIconsTypeNearby = 2,
	IndexIconsTypeBookmark = 3,
	IndexIconsTypeCoupon = 4,
	IndexIconsTypeReservation = 5,
	IndexIconsTypeAward = 6,
	IndexIconsTypeChart = 7,
	IndexIconsTypeRandomSearch = 8,
	IndexIconsTypeAE = 9,
	IndexIconsTypeHotpot = 10,
	IndexIconsTypeBuffet = 11,
	IndexIconsTypeHotNews = 12,
	IndexIconsTypeSeason = 13,
	IndexIconsTypeLatestReview = 14,
	IndexIconsTypeSnapShare = 15,
	IndexIconsTypeWebLink = 16,
	IndexIconsTypeRestaurantDetail = 17,
	IndexIconsTypeCouponDetail = 18,
    IndexIconsTypeMyOpenRice = 19,
    IndexIconsTypeHome = 20,
    IndexIconsTypeQRScanner = 21,
    IndexIconsTypeMyCoupons = 22,
    IndexIconsTypeSetting = 23,
	IndexIconsTypeMyBookmark = 24,
    // Not yet handled in App
//    IndexIconsTypeHotNewsDetail = 25,
    IndexIconsTypeURLScheme = 26,
    IndexIconsTypeFBFanPage = 27

}IndexIconsType;

//#define MenuTypeHome				9999
#define MenuTypeFavorite			8888
#define MenuTypeWriteReview			7777
#define MenuTypeEditPhoto			6666
#define MenuTypeRefineSearch		5555
//#define MenuTypeSetting             1212
#define MenuTypeMyOpenRice          2323

// Get AppDelegate 
#define APP_DELEGATE                (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define ROOT_VC						[APP_DELEGATE rootVC]

// Get Managers
#define APP_MANAGER					[AppManager sharedAppManager]
#define RESTAURANT_MANAGER          (RestaurantManager *)[[AppManager sharedAppManager] restaurantManager]
#define RESTAURANT_DETAIL_MANAGER   (RestaurantDetailManager *)[[AppManager sharedAppManager] restaurantDetailManager]
#define BUFFET_MANAGER              (BuffetManager *)[[AppManager sharedAppManager] buffetManager]
#define HOTPOT_MANAGER              (HotpotManager *)[[AppManager sharedAppManager] hotpotManager]
#define REVIEW_MANAGER              (ReviewManager *)[[AppManager sharedAppManager] reviewManager]
#define PHOTO_MANAGER               (PhotoManager *)[[AppManager sharedAppManager] photoManager]
#define SETTING_MANAGER             (SettingManager *)[[AppManager sharedAppManager] settingManager]
#define JSON_MANAGER                (JsonManager *)[[AppManager sharedAppManager] jsonManager]
#define FONT_MANAGER                (FontManager *)[[AppManager sharedAppManager] fontManager]
#define CHART_MANAGER               (ChartManager *)[[AppManager sharedAppManager] chartManager]
#define HOTNEWS_MANAGER             (HotnewsManager *)[[AppManager sharedAppManager] hotnewsManager]
#define INDEX_MANAGER               (IndexManager *)[[AppManager sharedAppManager] indexManager]
#define SEARCH_MANAGER              (SearchManager *)[[AppManager sharedAppManager] searchManager]
#define DATABASE_MANAGER            (DatabaseManager *)[[AppManager sharedAppManager] databaseManager]
#define BOOKMARK_MANAGER            (BookmarkManager *)[[AppManager sharedAppManager] bookmarkManager]
#define ACCOUNT_MANAGER             (AccountManager *)[[AppManager sharedAppManager] accountManager]
#define COUPON_MANAGER              (CouponManager *)[[AppManager sharedAppManager] couponManager]
#define FACEBOOK_MANAGER            (FacebookManager *)[[AppManager sharedAppManager] facebookManager]
#define CONTACTUS_MANAGER           (ContactUsManager *)[[AppManager sharedAppManager] contactUsManager]
#define PAYPAL_MANAGER              (PayPalManager *)[[AppManager sharedAppManager] paypalManager]
#define TWITTER_MANAGER             (TwitterManager *)[[AppManager sharedAppManager] twitterManager]
#define GA_MANAGER                  (GAManager *)[[AppManager sharedAppManager] gaManager]
#define PUSH_MANAGER                (PushManager *)[[AppManager sharedAppManager] pushManager]
#define SNS_MANAGER                 (SNSManager *)[[AppManager sharedAppManager] snsManager]

////////////////////////////////////////////////////////////////////////////
// 3. Project Constant

// Test on/off
#define MANAGER_DUMMY_DATA              0

#define WOODBOARD_TAG					1000

#define REQUEST_TIMEOUT                 30
#define REQUEST_TIMEOUT_FOR_SUBMIT      300

#define TOP_BAR_HEIGHT					44
#define CONTENT_HEIGHT                  CGRectGetHeight([[UIScreen mainScreen] applicationFrame]) - TOP_BAR_HEIGHT

#define NUM_OF_ITEM_PER_PAGE            20
#define NUM_OF_PHOTO_PER_PAGE           50
#define MAX_NUM_OF_LATEST_REVIEW        150

// restaruant list cell constant
#define SINGLE_LINE_VIEW_HEIGHT         20

#define NO_IMAGE_BACKGROUND_COLOR       [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:234.0/255.0 alpha:1.0]

#define PAYPAL_CANCEL_URL               @"http://paypalcancel.htm"
#define PAYPAL_RETURN_URL               @"http://paypalreturn.htm"

#define APILIB_ERROR_ALERT_TAG          102
#define API_REGION_LIST_ERROR_ALERT_TAG 103
#define API_MAINTAINCE_ALERT_TAG        20000
#define PUSH_ALERT_TAG                  30000

#define DEVICE_TOKEN_KEY                @"PushDeviceTokenKey"

#define KEYCHAIN_SERVICE                @"com.openrice.secure"
#define OR_SSO_ACCOUNT                  @"or_sso_account"

#define CODEBASE_STRING                 [SVN_NUMBER substringToIndex:(8 > [SVN_NUMBER length])?[SVN_NUMBER length]:8]

#import "Common-Config.h"
#endif
--------------------------------------------------------------------------------

5. 技巧性代码
	
	> UIView中 , 添加异步显示图片的代码
		
		* 可以加入将读取到得图片NSData数据，写入本地Cche目录做为缓存

		> 使用 - ASIHTTPRequest - 实现如下:
				- (void)loadImageFromURL:(NSURL*)url {

				    //1. 清空ASIHTTPRequest对象的代理
					request.delegate = nil;
				    [request clearDelegatesAndCancel];
					[request release];
					request = nil;
    
				    //2. 创建ASIHTTPRequest对象 ->>> 请求图片的url
				    request = [[ASIHTTPRequest requestWithURL:url] retain];
					
				    //3. 重新设置代理
				    [request setDelegate:self];
					
				    //4. cache
				    [request setDownloadCache:[ASIDownloadCache sharedCache]];
					//    [request setCachePolicy: ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
				    
				    //5. 缓存策略
					[request setCachePolicy:ASIUseDefaultCachePolicy];
				    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
				    // cache 30 天
				    [request setSecondsToCache:60 * 60 * 24 * 30];
				    // time out 自動重試的次數
				    [request setNumberOfTimesToRetryOnTimeout:2];
					
				    //6. 网络接收数据后回调处理函数

				    //6.1 请求处理成功 -> 接收到图片数据后 -> 设定回调函数 -> imageDidDownload:
				    [request setDidFinishSelector:@selector(imageDidDownload:)];

				    //6.2 请求处理失败 -> 设定回调函数 -> didServerFail:
				    [request setDidFailSelector:@selector(didServerFail:)];
					
					//	/* If we didn't set these selectors, sometimes the app will crash.*/
					//    [request setDidReceiveResponseHeadersSelector:@selector(dummySelector)];
					//    [request setDidStartSelector:@selector(dummySelector:)];
				    
				    //7. 发起 - 异步 - 网络请求
					[request startAsynchronous];
				    
				    //8. 回调函数中，取出图片的NSData数据
				    //imageDidDownload: 函数中

				    //9. NSData数据 ->>> UIImage
				}

				//网络请求回调函数 - 更新UI, 显示图片
				- (void)imageDidDownload:(ASIHTTPRequest *)_request
				{
				//	BOOL success = [request didUseCachedResponse];
				//	NSLog(@"------------>>>>>>> didUseCachedResponse is %@\n", (success ? @"YES" : @"NO"));
				//	NSLog(@"%s",__FUNCTION__);
				    // RMS
				    if (self.noImageType == NoImageHiddenWhenDownloadFail) {
				        self.hidden = FALSE;
				    }
				    // End RMS
				    NSData *imageData = [_request responseData];
				    UIImage *image = [[UIImage alloc] initWithData:imageData];
				    if (image != nil) {
				        [self setImage:image];
				    }else{
				       self.image = nil;
				    }
				    
				    
					// call our delegate and tell it that image is ready for display
					if ([delegate respondsToSelector:@selector(imageDidDownload)]) {
						[delegate performSelector:@selector(imageDidDownload)];
					}
					if ([delegate respondsToSelector:@selector(imageDidDownload:)]) {
						[delegate performSelector:@selector(imageDidDownload:) withObject:self];
					}
				    [image release];
				}


	图片缓存方案:	
		> NSURLCache
		> 图片NSData写入本地文件Cache目录

		



