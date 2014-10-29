
> size classes 进行不同屏幕的适配

	1. size classes --> 设置同一层级的 兄弟UI控件 的布局显示效果
	2. Auto Layout  --> 子UI控件 随 父UI控件 长宽变化而变化

	3. 适配步骤

		>1. 设置当前尺寸下要显示哪些UI
		>2. 针对要显示的UI设置随父UI长宽变化怎么变化


		1) 使用size classes, 配置不同尺寸的设备上得, 要显示哪些UI控件
			 > 在 widthAny和heightAny全局尺寸, 屏幕上设置 所有尺寸屏幕都会出现、固定的UI控件 

		2) 使用Auto Layout, 设置 子UI 随 父UI 变化而变化 
			> resizingMask属性

	> 一份UI代码, 可以运行在不同尺寸的设备上运行, 而显示出不同的UI效果
		( ipad, iphone, iWatch, 还有各自的屏幕旋转)

--------------------------------------------------------