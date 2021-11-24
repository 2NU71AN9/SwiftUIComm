//
//  CodableView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/24.
//

import SwiftUI

struct CodableView: View {
    
    private var json = """
    {
        "name": "name",
        "price": "12.123456",
        "show": 0,
        "type": 1
    }
    """
    
    @State var model = CModel()
    
    var json2: String {
        if let jsonData = try? JSONEncoder().encode(model) {
            // 编码成功，将 jsonData 转为字符输出查看
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    var body: some View {
        VStack {
            Text(json)
            Spacer()
            Text("\(model.price.value ?? 0)")
            Toggle("SHOW", isOn: $model.show.value)
            if model.type == .type1 {
                Text("type1")
            }
            if model.type == .type2 {
                Text("type2")
            }
            if model.type == .type3 {
                Text("type3")
            }
            Spacer()
            Text(json2)
            Spacer()
        }
        .padding()
        .onAppear(perform: map)
    }
    
    func map() {
        model = try! JSONDecoder().decode(CModel.self, from: json.data(using: .utf8)!)
    }
}

struct CodableView_Previews: PreviewProvider {
    static var previews: some View {
        CodableView()
    }
}

enum CType: Int, Codable {
    case type1
    case type2
    case type3
}

struct CModel: Codable {
    var name: String?
    var price = DoubleConverter()
    var show = BoolConverter()
    var type: CType = .type1
}
