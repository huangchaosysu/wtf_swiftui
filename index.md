## 隐藏导航栏(hide navigation bar)

```
someview
.navigationTitle("")
.navigationBarTitle("")
.navigationBarHidden(true)
.navigationBarBackButtonHidden(true)
```



## EnvironmentObject && someview.envorinmentObject(store)

尽量在最外层调用envorinmentObject， 如果遇到navigationLink的情况， 如果不work， 可以使用一下方法
```
NavigationLink(destination: WRLoginCodeView().environmentObject(store), isActive: $waitingForCode) {
                EmptyView()
            }
```

## NavigationLink会影响destination的navigationBar的样式



## onAppear会调用多次（called multi times）

如果使用了多层路由， 那么父页面的onAppear可能调用多次， 一个解决方法就是在父页面设置一个状态位， 记录下是否已经执行过。

## swift Date() & Dateformatter()

Date()返回的是0时区的时间
Dateformatter().string 返回的是系统时区的时间

## fullScreenCover 只能用在Button上？

## transition removal animation not working in swiftui
The problem is that when views come and go in a ZStack, their "zIndex" doesn't stay the same. What is happening is that the when "showMessage" goes from true to false, the VStack with the "Hello World" text is put at the bottom of the stack and the yellow color is immediately drawn over top of it. It is actually fading out but it's doing so behind the yellow color so you can't see it.

To fix it you need to explicitly specify the "zIndex" for each view in the stack so they always stay the same - like so:
```
struct ContentView: View {
@State private var showMessage = false

var body: some View {
    ZStack {
        Color.yellow.zIndex(0)

        VStack {
            Spacer()
            Button(action: {
                withAnimation(.easeOut(duration: 3)) {
                    self.showMessage.toggle()
                }
            }) {
                Text("SHOW MESSAGE")
            }
        }.zIndex(1)

        if showMessage {
            Text("HELLO WORLD!")
                .transition(.opacity)
                .zIndex(2)
        }
    }
}
```

## extra argument in call
swiftui的ViewBuider限定最多只能10个子View

## swiftui alert 组件只能展示一次
```
Button(action: {
                        print("lslsls")
                        showAlert.toggle()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text(LocalizedStringKey("CancelOrder"))
                        }
                        .foregroundColor(Color.gray.opacity(0.8))
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(LocalizedStringKey("CancelOrder")),
                            message: Text("CancelWarningTip1"),
                            primaryButton: .default(
                                Text(LocalizedStringKey("Leave")),
                                action: {}  // alert set showAlert to false automatically
                            ),
                            secondaryButton: .destructive(
                                Text(LocalizedStringKey("KeepWaiting")),
                                action: {
                                    onCancel()
                                }
                            )
                        )
                    }
```

swiftui的Alert组件， button会默认dismiss弹窗， 自动把showAlert设为false， 所以不同自己设置


## swift(ios) 查找语言文件
```
Bundle.main.path(forResource: language, ofType: "lproj")
```

上述代码中, language为[language]-[script] 格式， 其中language部分参考ISO 639 code， script部分参考ISO 15924 code


## Xcode添加语言文件

选中项目->PROJECT -> Localization

## swiftui 隐藏键盘(dismiss keyboard)
```
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
```
找个地方注册一个事件， 手动调用hideKeyboard()


## swiftui 控制ScrollView的滚动位置
```
@Namespace var topID
@Namespace var bottomID

ScrollViewReader { proxy in
    ScrollView(showsIndicators: false) {
        Text("aaaaa").id(topID)
        Text("bbbbb").id(bottomID)
    }
}

// call proxy.scrollTo(bottomID) somewhere
```


## swiftui Angle
Angle.degrees(xx), xx去0为x轴朝右， 逆时针为负， 顺时针为正


## xCode: Errors were encountered while preparing your device for development
solution: reboot your iphone

## mapkit 地图区域显示问题
uiView.setUserTrackingMode(.none, animated: false)
set tracking mode to none in updateUIView


## [swiftui 集成微信支付(wechat pay)](/wtf_swiftui/wechat)

## [swiftui 集成微信分享(wechat share)](/wtf_swiftui/wechat)

## 注释写法(how to write comments)
```
/**
 * this is the description
 * - Parameter param1: what is param1
 *   param1-1: lalalalallalalalalal
 * - Returns:
 *   lalalalalalalalalalal
 */
```

## mapkit marker平滑移动(move annotation)
```
func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    // update car pose
    guard carAnnotations != nil else {
        return
    }
    for car in carAnnotations! {
        if carAnnotationObjs[car.title!] != nil {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 3) {
                    // keep the reference of annotation somewhere
                    carAnnotationObjs[car.title!]?.coordinate = car.coordinate
                    let oldYaw = carAnnotationObjs[car.title!]?.yaw
                    carAnnotationObjs[car.title!]?.yaw = car.yaw
                    // keep the reference of annotationView somewhere
                    carAnnotationViews[car.title!]?.transform = carAnnotationViews[car.title!]!.transform.rotated(by: CGFloat(car.yaw) - CGFloat(oldYaw!))
                }
            }
            
        } else {
            uiView.addAnnotation(car)
            carAnnotationObjs[car.title!] = car
        }
    }
}
```

```
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is CarAnnotation {
        let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: MapView.carAnnotationIdentifier)
        pin.image = UIImage(named: "car")
        pin.zPriority = MKAnnotationViewZPriority.max
        pin.frame = CGRect(x: pin.frame.minX + 2, y: pin.frame.minY, width: 22, height: 40)
          pin.transform = CGAffineTransform(rotationAngle: CGFloat((annotation as! CarAnnotation).yaw) + CGFloat.pi / 2)  // radian
        pin.transform = pin.transform.rotated(by: CGFloat((annotation as! CarAnnotation).yaw) + CGFloat.pi / 2)
        carAnnotationViews[annotation.title!!] = pin
        return pin
    }

    return nil
}
```

## hide keyboard(隐藏键盘)
```
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
```

## webview
```import SwiftUI
import WebKit

struct MyWebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard url != nil else {
            return
        }
        
        let request = URLRequest(url: url!)
        uiView.load(request)
    }
}
```

## lottie动画比较耗费cpu

## swiftui 集成lottie
1. File -> Swift Packages -> Add 'https://github.com/airbnb/lottie-ios.git'
2. put your lottie file into project, **.json
3. Build reusable View

```
import SwiftUI
import Lottie
import UIKit

struct MYLottieView: UIViewRepresentable {
    var name: String
    
    typealias UIViewType = UIView
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // add animation
        let animationView = AnimationView()
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
```


## by me a coffee
![By Me A Cofee](https://huangchaosysu.github.io/my_assets/images/wechat_qu_code.jpeg)
