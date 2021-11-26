//
//  GCDView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/25.
//

import SwiftUI
import RxSwift

struct GCDView: View {
    
    // 串行队列, 同一个串行队列同步嵌套会造成死锁
    let serialQueue = DispatchQueue(label: "serial")
    // 并行队列
    let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(perform: sale)
    }
}

// 任务 队列
extension GCDView {
    /**
     串行+同步
     不开线程,串行执行任务
     1-- <_NSMainThread: 0x600002c1c840>{number = 1, name = main}
     2-- <_NSMainThread: 0x600002c1c840>{number = 1, name = main}
     3-- <_NSMainThread: 0x600002c1c840>{number = 1, name = main}
     */
    func serial_sync() {
        print("1--", Thread.current)
        serialQueue.sync {
            print("2--", Thread.current)
        }
        print("3--", Thread.current)
    }
    
    /**
     串行+异步
     开启新线程（1条）,串行执行任务
     1-- <_NSMainThread: 0x600001354e00>{number = 1, name = main}
     5-- <_NSMainThread: 0x600001354e00>{number = 1, name = main}
     2-- <NSThread: 0x6000013d4d00>{number = 7, name = (null)}
     3-- <NSThread: 0x6000013d4d00>{number = 7, name = (null)}
     4-- <NSThread: 0x6000013d4d00>{number = 7, name = (null)}
     */
    func serial_async() {
        print("1--", Thread.current)
        serialQueue.async {
            print("2--", Thread.current)
        }
        serialQueue.async {
            print("3--", Thread.current)
        }
        serialQueue.async {
            print("4--", Thread.current)
        }
        print("5--", Thread.current)
    }
    
    /**
     并行+同步
     不开线程,串行执行任务
     1-- <_NSMainThread: 0x60000167ce00>{number = 1, name = main}
     2-- <_NSMainThread: 0x60000167ce00>{number = 1, name = main}
     3-- <_NSMainThread: 0x60000167ce00>{number = 1, name = main}
     4-- <_NSMainThread: 0x60000167ce00>{number = 1, name = main}
     5-- <_NSMainThread: 0x60000167ce00>{number = 1, name = main}
     */
    func concurrent_sync() {
        print("1--", Thread.current)
        concurrentQueue.sync {
            print("2--", Thread.current)
        }
        concurrentQueue.sync {
            print("3--", Thread.current)
        }
        concurrentQueue.sync {
            print("4--", Thread.current)
        }
        print("5--", Thread.current)
    }
    
    /**
     并行+异步
     开启新线程，并发执行任务
     1-- <_NSMainThread: 0x6000033fc180>{number = 1, name = main}
     5-- <_NSMainThread: 0x6000033fc180>{number = 1, name = main}
     2-- <NSThread: 0x6000033e4140>{number = 8, name = (null)}
     3-- <NSThread: 0x60000339d800>{number = 7, name = (null)}
     4-- <NSThread: 0x6000033dc3c0>{number = 6, name = (null)}
     */
    func concurrent_async() {
        print("1--", Thread.current)
        concurrentQueue.async {
            print("2--", Thread.current)
        }
        concurrentQueue.async {
            print("3--", Thread.current)
        }
        concurrentQueue.async {
            print("4--", Thread.current)
        }
        print("5--", Thread.current)
    }
    
    /**
     主队列+异步
     不开启新线程，串行执行任务
     1-- <_NSMainThread: 0x6000003fc4c0>{number = 1, name = main}
     5-- <_NSMainThread: 0x6000003fc4c0>{number = 1, name = main}
     2-- <_NSMainThread: 0x6000003fc4c0>{number = 1, name = main}
     3-- <_NSMainThread: 0x6000003fc4c0>{number = 1, name = main}
     4-- <_NSMainThread: 0x6000003fc4c0>{number = 1, name = main}
     */
    func main_async() {
        print("1--", Thread.current)
        DispatchQueue.main.async {
            print("2--", Thread.current)
        }
        DispatchQueue.main.async {
            print("3--", Thread.current)
        }
        DispatchQueue.main.async {
            print("4--", Thread.current)
        }
        print("5--", Thread.current)
    }
}

// 任务组
extension GCDView {
    /**
     group.notify
     同时执行多个异步任务，最终回到指定线程执行任务
     begin-- <_NSMainThread: 0x6000005801c0>{number = 1, name = main}
     end-- <_NSMainThread: 0x6000005801c0>{number = 1, name = main}
     1-- <NSThread: 0x600000598280>{number = 3, name = (null)}
     2-- <NSThread: 0x6000005cc2c0>{number = 7, name = (null)}
     3-- <NSThread: 0x6000005f47c0>{number = 5, name = (null)}
     notify-- <_NSMainThread: 0x6000005801c0>{number = 1, name = main}
     */
    func groupNotify() {
        print("begin--", Thread.current)
        let group = DispatchGroup()
        concurrentQueue.async(group: group) {
            print("1--", Thread.current)
        }
        concurrentQueue.async(group: group) {
            print("2--", Thread.current)
        }
        group.notify(queue: DispatchQueue.main) {
            print("notify--", Thread.current)
        }
        concurrentQueue.async(group: group) {
            print("3--", Thread.current)
        }
        print("end--", Thread.current)
    }
    
    /**
     group.enter() 未执行任务+1， group.leave() 未执行任务-1, 未执行任务=0，才会解除阻塞，继续执行后续代码
     begin-- <_NSMainThread: 0x6000009ac040>{number = 1, name = main}
     end-- <_NSMainThread: 0x6000009ac040>{number = 1, name = main}
     2-- <NSThread: 0x60000099bb00>{number = 4, name = (null)}
     3-- <NSThread: 0x6000009361c0>{number = 6, name = (null)}
     1-- <NSThread: 0x6000009a2b40>{number = 3, name = (null)}
     */
    func groupEnter() {
        print("begin--", Thread.current)
        let group = DispatchGroup()
        
        group.enter()
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 3)
            print("1--", Thread.current)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 1)
            print("2--", Thread.current)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 2)
            print("3--", Thread.current)
            group.leave()
        }
        
        group.enter()
        
        group.notify(queue: DispatchQueue.main) {
            print("notify--", Thread.current)
        }
        print("end--", Thread.current)
    }
    
    /**
     group.wait
     阻塞当前线程，暂停当前线程。wait后面所有代码都不执行, 等待前面任务执行完毕才往后执行
     begin-- <_NSMainThread: 0x60000253c1c0>{number = 1, name = main}
     1-- <NSThread: 0x600002554080>{number = 4, name = (null)}
     2-- <NSThread: 0x600002569980>{number = 7, name = (null)}
     end-- <_NSMainThread: 0x60000253c1c0>{number = 1, name = main}
     3-- <NSThread: 0x600002569980>{number = 7, name = (null)}
     notify-- <_NSMainThread: 0x60000253c1c0>{number = 1, name = main}
     */
    func groupWait() {
        let group = DispatchGroup()
        print("begin--", Thread.current)
        concurrentQueue.async(group: group) {
            print("1--", Thread.current)
        }
        concurrentQueue.async(group: group) {
            print("2--", Thread.current)
        }
        group.wait()
        concurrentQueue.async(group: group) {
            print("3--", Thread.current)
        }
        group.notify(queue: DispatchQueue.main) {
            print("notify--", Thread.current)
        }
        print("end--", Thread.current)
    }
    
    /**
     group.barrier(栅栏) 不会阻塞线程，group中barrier后的代码后执行
     begin-- <_NSMainThread: 0x60000259c9c0>{number = 1, name = main}
     end-- <_NSMainThread: 0x60000259c9c0>{number = 1, name = main}
     2-- <NSThread: 0x6000025f0200>{number = 3, name = (null)}
     1-- <NSThread: 0x6000025f0280>{number = 4, name = (null)}
     barrier-- <NSThread: 0x6000025f0280>{number = 4, name = (null)}
     3-- <NSThread: 0x6000025f0280>{number = 4, name = (null)}
     4-- <NSThread: 0x6000025f0200>{number = 3, name = (null)}
     notify-- <_NSMainThread: 0x60000259c9c0>{number = 1, name = main}
     */
    func groupBarrier() {
        let group = DispatchGroup()
        print("begin--", Thread.current)
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 4)
            print("1--", Thread.current)
        }
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 2)
            print("2--", Thread.current)
        }
        concurrentQueue.async(group: group, flags: .barrier) {
            print("barrier--", Thread.current)
        }
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 1)
            print("3--", Thread.current)
        }
        concurrentQueue.async(group: group) {
            Thread.sleep(forTimeInterval: 3)
            print("4--", Thread.current)
        }
        group.notify(queue: DispatchQueue.main) {
            print("notify--", Thread.current)
        }
        print("end--", Thread.current)
    }
}

// 信号量
extension GCDView {
    /**
     信号量, 保持线程同步,保证线程安全
     begin-- <_NSMainThread: 0x600003e80140>{number = 1, name = main}
     semaphore-- <NSThread: 0x600003ecd9c0>{number = 5, name = (null)}
     end-- <_NSMainThread: 0x600003e80140>{number = 1, name = main}
     */
    func semaphore() {
        let semaphore = DispatchSemaphore(value: 0)
        print("begin--", Thread.current)
        concurrentQueue.async {
            Thread.sleep(forTimeInterval: 3)
            print("semaphore--", Thread.current)
            //发送一个信号，让信号总量加 1
            semaphore.signal()
        }
        //可以使总信号量减 1，信号总量小于 0 时就会一直等待（阻塞所在线程），否则就可以正常执行。
        semaphore.wait()
        print("end--", Thread.current)
    }
    
    /**
     线程安全（使用 semaphore 加锁）
    
     剩余19张
     剩余18张
     剩余17张
     剩余16张
     剩余15张
     剩余14张
     剩余13张
     剩余12张
     剩余11张
     剩余10张
     剩余9张
     剩余8张
     剩余7张
     剩余6张
     剩余5张
     剩余4张
     剩余3张
     剩余2张
     剩余1张
     剩余0张
     卖完了
     卖完了
     */
    func sale() {
        var count = 20
        let semaphore = DispatchSemaphore(value: 1)

        let lock = NSLock()
        
        concurrentQueue.async {
            saleSafe()
        }
        concurrentQueue.async {
            saleSafe()
        }
        
        // 使用semaphore或者NSLock加锁
        func saleSafe() {
            while true {
//                semaphore.wait()
                lock.lock()
                if count > 0 {
                    count -= 1
                    print("剩余\(count)张")
                } else {
                    print("卖完了")
//                    semaphore.signal()
                    lock.unlock()
                    break
                }
//                semaphore.signal()
                lock.unlock()
            }
        }
    }
}

struct GCDView_Previews: PreviewProvider {
    static var previews: some View {
        GCDView()
    }
}
