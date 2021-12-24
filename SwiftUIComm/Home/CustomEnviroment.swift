//
//  CustomEnviroment.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/24.
//

import SwiftUI
import SLIKit

struct CustomEnviroment: View {
    
    @Environment(\.ce) var customEn: String
    @Environment(\.rootVC) var rootVC: UIViewController?
    
    var body: some View {
        VStack {
            Button("Present") {
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                rootVC?.present(vc, animated: true, completion: nil)
            }
                .padding()
            Text(customEn)
                .navigationTitle("自定义环境变量")
        }
    }
}

struct CustomEnviroment_Previews: PreviewProvider {
    static var previews: some View {
        CustomEnviroment()
    }
}


struct CustomEnvironmentHolder {
    var value: String
}
struct CustomEnvironmentKey: EnvironmentKey {
    static var defaultValue: CustomEnvironmentHolder {
        CustomEnvironmentHolder(value: "自定义环境变量")
    }
}
extension EnvironmentValues {
    var ce: String {
        get { self[CustomEnvironmentKey.self].value }
        set { self[CustomEnvironmentKey.self].value = newValue }
    }
}
