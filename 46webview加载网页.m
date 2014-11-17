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