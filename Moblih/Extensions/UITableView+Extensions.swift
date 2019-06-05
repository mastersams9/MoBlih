//
//  UITableView+Extensions.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

extension UITableView {

    func startLoading(on cellName: String? = nil) {
        if let loadingView = UINib(nibName: "TableViewLoader", bundle: nil).instantiate(withOwner: nil, options: nil).first as? TableViewLoader {
            if let cellName = cellName {
                loadingView.cellName = cellName
            }
            loadingView.tag = 10002
            let tableHeaderViewHeight = self.tableHeaderView?.frame.height ?? 0
            loadingView.frame = CGRect(x: 0,
                                       y: tableHeaderViewHeight,
                                       width: frame.width,
                                       height: frame.height)
            addSubview(loadingView)
            loadingView.tableview.rowHeight = rowHeight
            loadingView.startLoading()
        }
    }

    func stopLoading() {
        let viewToRemove = viewWithTag(10002)
        viewToRemove?.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            viewToRemove?.alpha = 0.0
        }) { _ in
            viewToRemove?.removeFromSuperview()
        }
    }
}
