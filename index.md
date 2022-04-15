What the Fuck SwiftUI

## 关于动画奇怪的现象(strange things using withAnimation)
示例代码
```
struct MyShimmer: View {
    @State var show = false

    var body: some View {
        ZStack {
            Color.black
            VStack {
                ZStack {
                    Text("Chao")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 40))
                    Text("Chao")
                        .foregroundColor(Color.white)
                        .font(.system(size: 40))
                        .mask(
                            Color.red.opacity(0.5)
                                .frame(width: 20)
                                .offset(x: self.show ? 180 : -130)
                        )
                }
                .onAppear(){
    //                DispatchQueue.main.async {
                        withAnimation(Animation.default.speed(0.15).delay(0).repeatForever(autoreverses: false)){
                            self.show.toggle()
                        }
//                    }
                }
            }
        }
    }
}
```

在我的机器上，如果是直接使用withAnimation, 整个页面都会参与到动画当中，整夜页面从左上角飞入，
如果把withAnimation放到DispatchQueue.main.async里面，就是正常效果
目前暂时不知道为什么，使用时需要注意


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

## swiftui alert 组件只能展示一次?
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
![添加语言文件](https://github.com/huangchaosysu/wtf_swiftui/blob/main/assets/images/1.png?raw=true)

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
Angle.degrees(xx), xx取0为x轴朝右， 逆时针为负， 顺时针为正


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

[示例代码/example code](https://github.com/huangchaosysu/wtf_swiftui/tree/main/exampleCode)

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

[示例代码/example code](https://github.com/huangchaosysu/wtf_swiftui/tree/main/exampleCode)


## 轮播组件（carousel)
[示例代码/example code](https://github.com/huangchaosysu/wtf_swiftui/tree/main/exampleCode)


## a way to print some logs in swiftui(在swiftui的view里面打印log)
```
func log(_ log: String) -> EmptyView {
    print("** \(log)")
    return EmptyView()
}

```
## Textfield auto focus(文本框默认选中)

```
struct AutoFocusTextField: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var isFirstResponder: Bool = false
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textColor = UIColor.clear
        textField.tintColor = .clear
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.isFirstResponder { // 选中逻辑
            uiView.becomeFirstResponder()
            context.coordinator.isFirstResponder = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
}
```

## 查看simulator沙盒目录(sandbox dir of simulators)
1. xcode -> window -> devices and simulators  (cmd + shift + 2)
2. 如下图所示，选择模拟器，找到identifier

![图片](https://github.com/huangchaosysu/wtf_swiftui/blob/main/assets/images/2.png?raw=true)

3. ~/Library/Developer/CoreSimulator/Devices/xxxxxxxxxx, 这个目录就是模拟器的根目录, xxxxxx替换为模拟器的identifier
4. ~/Library/Developer/CoreSimulator/Devices/033DF892-6846-4E23-B571-657F02FCC37A/data/Containers/Data/Application/xxxxxxxxxxxxxxxxxxxxxx/, 这个目录就是应用的沙盒目录了，xxxxxxxx替换为应用的id
5. 也可以用下面的命令来看具体的路径
```
FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
```

## 环境变量
1. 设置环境变量

<code>Product -> Scheme -> Edit Scheme</code> 打开编辑窗口并添加环境变量
![图片](https://github.com/huangchaosysu/wtf_swiftui/blob/main/assets/images/3.png?raw=true)

2. 代码中使用环境变量
```
ProcessInfo.processInfo.environment["DEBUG_MODE"] != nil
```
## swiftui 动画详解
[参考这里-part1](https://swiftui-lab.com/swiftui-animations-part1/)
[参考这里-part2](https://swiftui-lab.com/swiftui-animations-part2/)
[参考这里-part3](https://swiftui-lab.com/swiftui-animations-part3/)

主要的知识点在于Animatable这个协议，以及如何把animatableData值的变化反应到属性的变化上
swiftui动画的原理是根据animatableData的渐进变化，重新渲染UI

##swiftui 动画问题
```
import SwiftUI
import Network
@main
struct weridegoApp: App {
    @State var width: CGFloat = 10
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack { // 直接把VStack部分的代码写在App内部， withAnimation不work, 需要把这一部分单独放到一个View里去
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: self.width, height: 100)
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.width += 10
                        }
                    } label: {
                        Text("shake")
                    }
                }
            }
            
        }
    }
}
```
以上代码除非给Rectangle添加.animation()这个modifier， 不然一直work, 原因未知
具体原因是App不能handle显示的动画调用, 详情参考[这里](https://stackoverflow.com/questions/68722067/why-does-not-withanimation-working-without-animation/68725083#68725083)

fix:

```
import SwiftUI
import Network
@main
struct weridegoApp: App {
    @State var width: CGFloat = 10
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TheView()
            }

        }
    }
}

struct TheView: View {
    @State var width: CGFloat = 10

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: self.width, height: 100)
            Button {
                withAnimation { // works
                    self.width += 10
                }
            } label: {
                Text("lalala")
            }

        }
    }
}
```

## 某个组件的出现动画(add/remove a view with animation)
```
struct The: View {
    @State var show = false
    var body: some View {
        VStack{
            Spacer()
            Text("lalala")
            
            if show {
                Text("hello world")
                    .transition(.slide)
                    // .animation()
                    
            }
            Button("toogle") {
                withAnimation(.default) {
                    self.show.toggle()
                }
            }
            .onAppear() {
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 5)) {
                        self.show = true
                    }
                }
            }
            Spacer()
        }
    }
}
```

不知道为什么，swiftui中，如果给某个组件设置了.transition + .animation, 不管是怎样设置的，这个组件都是从左上角飞入
上面的代码是个workaround


## unit test(单元测试)
1. create a unit test target(如果新建项目的时候没有选择include test， 那么需要执行这一步)
```
File -> New -> Target -> Unit Testing Bundle
```

2. 添加依赖的header

根据需要配置下面这两个属性，在有外部依赖的情况下，可能会出现找不到头文件的编译错误
```
Target -> Build Settings -> Header Search Paths
Target -> Build Settings -> Framework Search Paths
```
3. write you tests
```
@testable import yourProjectName
import XCTest

class xxxxxTests: XCTestCase {
}
```

## 监听事件
这个功能是有NotificationCenter结合Combine(Publisher)来实现

1. 进入前台事件, UIApplication.willEnterForegroundNotification
2. 进入后台事件, UIApplication.willResignActiveNotification

还有一些其他事件，自己尝试

使用方法
```
Text("Hello, World!")
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
        print("Moving to the background!")
    }
```

## 闪烁效果(shimmer)
这里用到一个叫mask的东西
```
struct MyShimmer: View {
    @State var show = false

    var body: some View {
        ZStack {
            Color.black
            VStack {
                ZStack {
                    Text("Chao")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 40))
                    Text("Chao")
                        .foregroundColor(Color.white)
                        .font(.system(size: 40))
                        .mask(
                            Color.red.opacity(0.5)
                                .frame(width: 20)
                                .offset(x: self.show ? 180 : -130)
                        )
                }
                .onAppear(){
                    DispatchQueue.main.async {
                        withAnimation(Animation.default.speed(0.15).delay(0).repeatForever(autoreverses: false)){
                            self.show.toggle()
                        }
                    }
                }
                
            }
        }
    }
}
```

## 线性渐变(进度条)(animating loading with linear gradient)
线性渐变的颜色滚动效果
```
struct Test: View {
    @State var isAnimating = false
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .red, .blue, .red]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 0)))
                    .frame(width: geo.size.width * 3, height: 30)
                    .offset(x: self.isAnimating ? 0 : -geo.size.width * 2, y: 0)
                Spacer()
            }
            .onAppear(){
                
                DispatchQueue.main.async {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)){
                        self.isAnimating.toggle()
                    }
                }
            }
        }
    }
}
```

## 宏定义-条件编译
1. 添加编译flag, 
`
项目 -> project -> Build Settings -> Swift Compiler - Custom Flags -> Active Compilation Conditions
`

2. 条件语句
#if DEBUG
    your code
#elseif condition
    your code
#else
    your code
#endif

## TextField 延时搜索(delayed search)
```
@State var workItem: DispatchWorkItem?
@State var searchText: String = ""
@State var tmpSearchText: String = ""

TextField("placeholder", text: $tmpSearchText, onCommit: {
                        searchText = tmpSearchText
                    })
                        .accentColor(Color("C1"))
                        .onChange(of: tmpSearchText) { _ in
                            self.workItem?.cancel()
                            let newWorkItem = DispatchWorkItem {
                                self.searchText = tmpSearchText
                            }

                            self.workItem = newWorkItem
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: self.workItem!)
                        }

```

## 宏定义-条件编译
1. 添加编译flag, 
`
项目 -> project -> Build Settings -> Swift Compiler - Custom Flags -> Active Compilation Conditions
`

2. 条件语句
#if DEBUG
    your code
#elseif condition
    your code
#else
    your code
#endif

## While executing gem ... (Gem::FilePermissionError), 重装gem, cocoapods
```
curl -L https://get.rvm.io | bash -s stable
# Reopen Terminal
rvm install ruby-3.1.1
rvm use ruby-3.1.1 
rvm --default use 3.1.1

sudo gem uninstall cocoapods
sudo gem install -n /usr/local/bin cocoapods

# Reopen Terminal
pod --version
```

## swiftui 侧滑返回
本身， swiftui是支持策划返回的， 但是设置完.navigationBarHidden(true)以后， 导航栏会被隐藏， 同时策划返回页失效了。解决办法添加导航扩展
```
extension UINavigationController: UIGestureRecognizerDelegate  {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
```

## ld: framework not found MAMapKit

mac升级最新版本系统以后原来正常的项目突然真机调试编译不了， 手机也升级到最新系统后恢复
