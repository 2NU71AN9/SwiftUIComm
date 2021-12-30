//
//  MyViewController.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/30.
//

import UIKit
import SwiftUI

struct CustomUIViewController: View {
    
    @State private var cell_count = 2
    
    var body: some View {
        VStack {
            Stepper("\(cell_count)", value: $cell_count)
                .padding()
            MyViewControllerRepresentable($cell_count)
        }
    }
}

struct MyViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyViewController
    
    @Binding private var cell_count: Int
    
    init(_ cell_count: Binding<Int>) {
        _cell_count = cell_count
    }
    
    func makeUIViewController(context: Context) -> MyViewController {
        MyViewController(cell_count)
    }
    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        uiViewController.cell_count = cell_count
    }
}

class MyViewController: UIViewController {
    
    var cell_count = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(_ cell_count: Int) {
        super.init(nibName: nil, bundle: nil)
        self.cell_count = cell_count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped).sl
        .showsVerticalScrollIndicator(false)
        .showsHorizontalScrollIndicator(false)
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .estimatedSectionHeaderHeight(0)
        .estimatedSectionFooterHeight(0)
        .separatorStyle(.none)
        .registerClass(UITableViewCell.self)
        .base
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cell_count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var con = cell.defaultContentConfiguration()
        con.image = UIImage(systemName: "star")
        con.text = "\(indexPath.section + 1)-\(indexPath.row + 1)"
        cell.contentConfiguration = con
        return cell
    }
}
