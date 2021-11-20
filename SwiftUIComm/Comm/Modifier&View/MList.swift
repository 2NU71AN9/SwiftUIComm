//
//  MList.swift
//  SwiftUIDemo
//
//  Created by 沉寂 on 2021/3/4.
//


import Foundation
import UIKit
import SwiftUI
import Combine

public struct MList<Content: View>: View {
    
    @Binding var isRefreshing: Bool
    @Binding var isLoadingMore: Bool
    @Binding var isNoMore: Bool
    var scrollSubject: PassthroughSubject<Bool, Never>
    var refreshAction: () -> Void
    var loadingMoreAction: () -> Void
    
    var content: () -> Content
    
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
                refreshAction: @escaping () -> Void,
                loadingMoreAction: @escaping () -> Void,
                height: CGFloat = 60,
                @ViewBuilder content: @escaping () -> Content) {
        
        self._isRefreshing = isRefreshing
        self._isLoadingMore = isLoadingMore
        self._isNoMore = isNoMore
        self.scrollSubject = scrollSubject
        self.refreshAction = refreshAction
        self.loadingMoreAction = loadingMoreAction
        
        self.height = height
        self.content = content
        
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    var bottomView: some View{
        LazyVStack{
            if isLoadingMore{
                Text("加载中")
            }else {
                if isNoMore{
                    Text("--我是有底线的--")
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
        .hideListDivider()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            ScrollViewReader{ reader in
                List{
                    MovingView().frame(height: 0.000001)
                        .hideListDivider()
                        .id(0)
                    
                    content()
                    
                    if isShowBottom{
                        bottomView
                    }
                }.listStyle(PlainListStyle())
                .environment(\.defaultMinListRowHeight, 0)
                .environment(\.defaultMinListHeaderHeight, 0)
                .background(FixedView())
                .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
                    DispatchQueue.main.async {
                        self.refreshLogic(values: values)
                    }
                }.onReceive(scrollSubject) { _ in
                    withAnimation(.easeIn(duration: 0.1)) {
                        reader.scrollTo(0, anchor: .top)
                    }
                }
            }
            
            ActivityIndicator(isAnimating: $isRefreshing)
                .scaleEffect(self.isRefreshing ? 1 : min(self.pullStatus, 1))
                .opacity(self.isRefreshing ? 1 : Double(min(self.pullStatus, 1)))
                .animation(self.isRefreshing ? nil : .linear(duration: 0.25))
                .frame(height: 60)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
            Color.clear
                .preference(key: RefreshableKeyTypes.PrefKey.self,
                            value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
        }
    }
}

private struct MovingView: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
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



struct MListTestView: View {
    
    @State var numbers:[Int] = generateRandomNumbers()
    
    @State var isRefreshing = false
    @State var isLoadingMore = false
    @State var isNoMore = false
    @State var isFirst = true
    
    var body: some View {
        MList(isRefreshing: $isRefreshing,
              isLoadingMore: $isLoadingMore,
              isNoMore: $isNoMore,
              refreshAction: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.numbers = generateRandomNumbers()
                    self.isRefreshing = false
                }
              },
              loadingMoreAction: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.numbers.append(contentsOf: generateRandomNumbers())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isLoadingMore = false
                    }
                }
              })
        {
            ForEach(self.numbers, id: \.self){ number in
                
                NavigationLink(destination: Text("Test")){
                    HStack(){
                        Text("\(number)")
                        Spacer()
                    }.frame(height: 44)
                }
            }
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct MListTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MListTestView()
        }
    }
}



extension View{
    func hideListDivider(_ background: Color = Color(.systemBackground), cellHeight: CGFloat = .infinity) -> some View{
        Group{
            if #available(iOS 15, *){
                self.listRowSeparator(.hidden)
                    .background(background)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }else if #available(iOS 14, *){
                self.frame(maxWidth: .infinity, maxHeight: cellHeight, alignment: .leading)
                    .background(background)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }else{
                self
            }
        }
    }
}




func generateRandomNumbers(_ count: Int = 20) -> [Int] {
    var sequence = [Int]()
    for _ in 0..<count {
        sequence.append(Int.random(in: 0 ..< 100))
    }
    return sequence
}
