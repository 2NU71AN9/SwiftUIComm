//
//  RunLoopView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/26.
//

import SwiftUI
import RxSwift

struct RunLoopView: View {
    
    private var timer: Timer = {
        var timer = Timer(fire: Date.future(), interval: 1, repeats: true) { _ in
            print("1")
        }
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    var body: some View {
        VStack {
            Button("点击") {
                print("123")
            }
            List(0..<50) {
                Text("\($0)")
            }
        }
        .onAppear(perform: openRunLoop)
    }
    
    func runTimer() {
        timer.fireDate = Date()
    }
    
    // 监听RunLoop
    func observer() {
        let observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.allActivities.rawValue, true, 0) { o, a in
            /**
             kCFRunLoopEntry = (1UL << 0),               // 即将进入Loop：1
             kCFRunLoopBeforeTimers = (1UL << 1),        // 即将处理Timer：2
             kCFRunLoopBeforeSources = (1UL << 2),       // 即将处理Source：4
             kCFRunLoopBeforeWaiting = (1UL << 5),       // 即将进入休眠：32
             kCFRunLoopAfterWaiting = (1UL << 6),        // 即将从休眠中唤醒：64
             kCFRunLoopExit = (1UL << 7),                // 即将从Loop中退出：128
             kCFRunLoopAllActivities = 0x0FFFFFFFU       // 监听全部状态改变
             */
            print(a)
        }
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
    }
    
    /**
     开启常驻线程
     线程内开启RunLoop
     线程和RunLoop是一一对应的,其映射关系是保存在一个全局的 Dictionary 里
     自己创建的线程默认是没有开启RunLoop的
     
     1--Run
     */
    func openRunLoop() {
        DispatchQueue(label: "", attributes: .concurrent).async {
            print("1--Run")
            RunLoop.current.add(Port(), forMode: .default)
            RunLoop.current.run()
            // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环,开启了一条常驻线程
            print("未开启RunLoop")
        }
    }
    
    /**
     保证子线程数据回来更新UI的时候不打断用户的滑动操作
     将更新UI事件放在主线程的NSDefaultRunLoopMode上执行即可，这样就会等用户不再滑动页面，主线程RunLoop由UITrackingRunLoopMode切换到NSDefaultRunLoopMode时再去更新UI
     */
//    func loadData() {
//        // 数据请求完成后调用
//        performSelector(onMainThread: #selector(refreshUI), with: nil, waitUntilDone: false, modes: [RunLoop.Mode.default.rawValue])
//    }
//    @objc func refreshUI() {
//
//    }
}

struct RunLoopView_Previews: PreviewProvider {
    static var previews: some View {
        RunLoopView()
    }
}
