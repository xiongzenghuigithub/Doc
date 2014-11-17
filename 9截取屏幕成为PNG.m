//1. 截取屏幕的大小
int s_w = self.view.bounds.size.width;
int s_h = self.view.bounds.size.height;

//2. 创建一个基于位图的图形上下文(截屏大小)
UIGraphicsBeginImageContext(CGSizeMake(s_w , s_h));

//3. 
[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];

//4. 
UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();

//5.
UIGraphicsEndImageContext();

//6.
//以png格式返回指定图片的数据
NSData * imageData = UIImagePNGRepresentation(aImage);