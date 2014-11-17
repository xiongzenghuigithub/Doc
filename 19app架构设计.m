1. UIWindow中包含的一个继承自UINavigatioController的自定义导航控制器
		> 方便以后的所有子控制器都是push出来
		> 可以使用UINavigationController这个栈容器集中管理所有的子控制器
		
		*** 把RootNavController对象属性，配置成宏，可以让所有类使用

2. RootNavController:(UINavigationController)

	>  封装自带的push方法

	pushViewControllerWithType:(int) Animation:(BooL)
			> 所有的子控制器都有一个唯一的type值

			> 在方法中if - else if - else if … 判断传入的type值

			> 根据type值构造控制器类名

			> runtime创建控制器对象

			> 判断类名，根据条件差异化控制器的UI（navigationItem）
				if 控制器类名 == controll1 —》initNavKind1:
				if 控制器类名 == controll2 —》initNavKind2:
				if 控制器类名 == controll3 —》initNavKind3:
				if 控制器类名 == controll4 —》initNavKind4:

			> 最后push出控制器对象
	
	> 封装自带的popViewController

	> 封装自带的topViewController
		
			**重要：
 
					1. 所有的控制器类，都可以使用[UIWindow rootNav]得到RootNavController对象
					2. 继而从RootNavController对象 . topViewController 得到当前栈顶的控制器对象
					3. 并在栈顶控制器对象.view  添加 一些UI
				

3. 	RootNavController.view addSubView:[[RootViewController alloc] ]init]

4. RootViewController作为app的 主界面

		**** 主界面的所有点击后push到子控制器界面的按钮设计:

					1)  每个按钮对应一个服务器实体对象封装:
								图片名、显示文字、type值、按钮之间的排序、初始API请求的连接

					2） 从服务器读取需要显示在主界面的按钮选项 list数据
								1) IndexIconView
								2) IndexIcon
										> 按钮的图片名
										> 按钮文字
										> 按钮点击后要push到的控制器的type值 （事先声明好type值 与 控制器类 的对应关系）
										> 按钮出现的顺序编号
										> push到子控制器时，发起请求数据的API连接

5.  按钮选项的type值 与 子控制器类 的对应关系

> 使用宏、enum 定义

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
	