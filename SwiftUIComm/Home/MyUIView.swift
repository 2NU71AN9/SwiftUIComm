//
//  MyUIView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/28.
//

import SwiftUI

struct CustomUIView: View {
    
    @State private var text = "QWERT"
    
    var body: some View {
        List {
            Text(text)
            MyUIView($text)
//                .disabled(true)
            Button("Random Name"){
                text = String(Int.random(in: 0...100))
            }
        }
    }
}

struct MyUIView: UIViewRepresentable {
    
    typealias UIViewType = UITextField
    typealias Coordinator = TFCoordinator
    
    @Binding var text: String
    
    init(_ text: Binding<String>) {
        _text = text
    }
    
    func makeCoordinator() -> TFCoordinator {
        print("1---makeCoordinator")
        return .init($text)
    }
    
    func makeUIView(context: Context) -> UITextField {
        print("2---makeUIView")
        let tf = UITextField()
        tf.text = text
        tf.delegate = context.coordinator
        return tf
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        print("3---updateUIView")
//        uiView.isEnabled = context.environment.isEnabled
        uiView.text = text
    }
    
    // 在UIViewRepresentable视图被移出视图树之前，SwiftUI 会调用dismantleUIView
    static func dismantleUIView(_ uiView: UITextField, coordinator: TFCoordinator) {
        print("4---dismantleUIView")
    }
    
    
    class TFCoordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(_ text: Binding<String>) {
            _text = text
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                let s = text.replacingCharacters(in: range, with: string)
                self.text = s
            }
            return true
        }
    }
}
