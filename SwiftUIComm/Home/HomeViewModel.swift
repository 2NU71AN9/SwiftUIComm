//
//  HomeViewModel.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/16.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    init() {
        asyncTest()
    }
    
    func asyncTest() {
        Task {
//            let _ = await fetch1()
//            await taskGroup()
//            await asynclet()
            await asyncComplete()
        }
    }
    
    func fetch1() async -> [Double] {
        (1...100).map { _ in Double.random(in: 10...30) }
    }
    
    func taskGroup() async {
        let string = await withTaskGroup(of: String.self) { group -> String in
            group.addTask {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                return "Hello"
            }
            group.addTask { "From" }
            group.addTask { "A" }
            group.addTask { "Task" }
            group.addTask { "Group" }
            _ = group.addTaskUnlessCancelled {
                "!!!"
            }
            var collected = [String]()
            for await value in group {
                collected.append(value)
            }
            return collected.joined(separator: " ")
        }
        print(string)
    }
}

extension HomeViewModel {
    func asynclet() async {
        async let a = fun1()
        async let b = fun2()
        async let c = fun3()
        await print(a, b, c)
    }
    
    func fun1() async -> String {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return "hello"
    }
    func fun2() async -> [Int] { [1, 2, 3] }
    func fun3() async -> [String] { ["hello"] }
}

extension HomeViewModel {
    func asyncComplete() async {
        let new = await fetchNews()
        print(new)
    }
    
    func fetchNews() async -> String {
        await withCheckedContinuation { continuation in
            fetchNews { str in
                continuation.resume(returning: str)
            }
        }
    }
    
    func fetchNews(complete: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            complete("1234567890")
        }
    }
}
