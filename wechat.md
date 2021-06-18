## swiftui 集成微信支付

1. pod init
2. add `pod 'WechatOpenSDK'` to Podfile
3. pod install
4. create bridge-header file
* File > New > File > [operating system] > Source > Header File.
* In your Objective-C bridging header, import every Objective-C header you want to expose to Swift.
* In Build Settings, in Swift Compiler - General, make sure the Objective-C Bridging Header build setting has a path to the bridging header file. The path should be relative to your project, similar to the way your Info.plist path is specified in Build Settings. In most cases, you won't need to modify this setting.

完成第四步以后， 不需要显示import， 微信sdk的所有共有类都可以在swift里面直接使用

5. 在app的init方法中初始化WXApi
```
init() {
    print("=======================app init============================")
    WXApi.registerApp("wxd7b2f615bf516954", universalLink: "https://riderpie.jing-chi.com/")
}
```
6. 发起支付
```
let request: PayReq = PayReq()
request.partnerId = "10000100"
request.prepayId = "1101000000140415649af9fc314aa427"
request.package = "Sign=WXPay"
request.nonceStr = "a462b76e7436e98e0ed6e13c64b4fd1c"
request.timeStamp = 1397527777
request.sign = "582282D72DD2B03AD892830965F428CB16E7A256"
WXApi.send(request) { result in
    print("-----------------------------111111111----------------------------")
    print(result)
}
```

6. 处理微信支付回调
```
SomeView.onOpenURL(perform: handleWechatPayResult)
func handleWechatPayResult(url: URL) {
    if url.queryParameters!["ret"] == "0"{
        print("success")
    } else {
        print("fail")
    }
}
```

