//
//  MScrollView.swift
//  BMXQ
//
//  Created by 沉寂 on 2021/5/15.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import SLIKit

public struct MScrollView<Content: View>: View {
    
    @Binding var isRefreshing: Bool
    @Binding var isLoadingMore: Bool
    @Binding var isNoMore: Bool
    var scrollSubject: PassthroughSubject<Bool, Never>
    var refreshAction: () -> Void
    var loadingMoreAction: () -> Void
    
    var content: () -> Content
    
    private var startY: CGFloat = 0
    private var threshold: CGFloat = 100.0
    private var height: CGFloat = 60
    
    @State private var isShowBottom = false
    @State private var pullStatus: CGFloat = 0.0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var isFrozen: Bool = false
    
    
    public init(isRefreshing: Binding<Bool>,
                isLoadingMore: Binding<Bool>,
                isNoMore: Binding<Bool>,
                scrollSubject: PassthroughSubject<Bool, Never> = PassthroughSubject(),
                startY: CGFloat = 0,
                refreshAction: @escaping () -> Void,
                loadingMoreAction: @escaping () -> Void,
                @ViewBuilder content: @escaping () -> Content) {
        
        self._isRefreshing = isRefreshing
        self._isLoadingMore = isLoadingMore
        self._isNoMore = isNoMore
        self.scrollSubject = scrollSubject
        self.refreshAction = refreshAction
        self.loadingMoreAction = loadingMoreAction
        
        self.startY = startY
        self.content = content
        
    }
    
    var bottomView: some View{
        LazyVStack{
            if isLoadingMore{
                Text("加载中")
            }else {
                if isNoMore{
                    Text("没有更多了")
                        .foregroundColor(Color(.secondaryLabel))
                }else{
                    Text("加载更多")
                        .frame(height: 44)
                        .onTapGesture {
                            self.loadingMoreAction()
                        }
                        .onAppear {
                            self.loadingMoreAction()
                        }
                }
            }
        }.frame(height: 44)
        .foregroundColor(Color(.secondaryLabel))
        .font(.system(size: 12))
    }
    
    
    func scrollGeo(_ geo: GeometryProxy){
        
        let minY = geo.frame(in: .global).minY - SL.statusBarHeight - startY
        
        if minY < -1{
            return
        }
        DispatchQueue.main.async {
            
            self.scrollOffset = minY
            self.pullStatus = max(self.scrollOffset / self.threshold, 0)
            
            if !self.isRefreshing && (self.scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
                self.isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.refreshAction()
                }
            }
            
            if self.isRefreshing {
                if self.previousScrollOffset > self.threshold && self.scrollOffset <= self.threshold {
                    self.isFrozen = true
                }
            } else {
                self.isFrozen = false
            }
            
            self.previousScrollOffset = self.scrollOffset
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            ScrollViewReader{ reader in
                ScrollView{
                    VStack(spacing: 0){
                        
                        GeometryReader{ newGeo -> AnyView in
                            self.scrollGeo(newGeo)
                            return AnyView(Color.clear.frame(width: 0, height: 0))
                        }.frame(width: 0, height: 0)
                        .id(0)
                        
                        
                        content()
                        
                        if isShowBottom{
                            bottomView
                        }
                    }
                }.onReceive(scrollSubject) { _ in
                    withAnimation(.easeIn(duration: 0.1)) {
                        reader.scrollTo(0, anchor: .top)
                    }
                }
            }
            
            ActivityIndicator(isAnimating: $isRefreshing)
                .frame(width: 44, height: 44, alignment: .center)
                .background(Color(.secondarySystemBackground))
                .clipShape(Circle())
                .shadow(radius: 5)
                .scaleEffect(self.isRefreshing ? 1 : min(self.pullStatus, 1))
                .animation(self.isRefreshing ? nil : .linear(duration: 0.25))
                .frame(height: 60)
            
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.isShowBottom = true
            }
        }.onDisappear{
            self.isShowBottom = false
        }
    }
    
    private func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
        DispatchQueue.main.async {
            // Calculate scroll offset
            
            let movingBounds = values.first { $0.vType == .movingView }?.bounds ?? .zero
            let fixedBounds = values.first { $0.vType == .fixedView }?.bounds ?? .zero
            
            // 6 is the list top padding
            self.scrollOffset = movingBounds.minY - fixedBounds.minY
            self.pullStatus = self.scrollOffset / self.threshold
            
            //            Log.print("self.scrollOffset = \(self.scrollOffset)")
            
            // Crossing the threshold on the way down, we start the refresh process
            if !self.isRefreshing && (self.scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
                self.isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.refreshAction()
                }
            }
            
            if self.isRefreshing {
                // Crossing the threshold on the way up, we add a space at the top of the List
                if self.previousScrollOffset > self.threshold && self.scrollOffset <= self.threshold {
                    self.isFrozen = true
                }
            } else {
                // remove the first empty row inside the list view.
                self.isFrozen = false
            }
            
            // Update last scroll offset
            self.previousScrollOffset = self.scrollOffset
        }
    }
}


private struct FixedView: View {
    var body: some View {
        GeometryReader { proxy in
            Color(.systemBackground).opacity(0.000001)
                .preference(key: RefreshableKeyTypes.PrefKey.self,
                            value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
        }
    }
}

private struct MovingView: View {
    var body: some View {
        GeometryReader { proxy in
            Color(.systemBackground).opacity(0.000001)
                .preference(key: RefreshableKeyTypes.PrefKey.self,
                            value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
        }
    }
}

private struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    var style: UIActivityIndicatorView.Style = .large
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.hidesWhenStopped = false
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

private struct RefreshableKeyTypes {
    enum ViewType: Int {
        case movingView
        case fixedView
    }
    
    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }
    
    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []
        
        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }
    }
}

