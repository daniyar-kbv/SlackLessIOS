//
//  UITableViewExtension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-12.
//

import Foundation
import UIKit

extension UITableViewDataSource where Self: UITableViewDelegate {
    func getTableViewHeight(in tableView: UITableView) -> CGFloat {
        (0..<(numberOfSections?(in: tableView) ?? 0))
            .compactMap({ [weak self] section -> [CGFloat]? in
                guard let self = self else { return nil }
                return (0..<self.tableView(tableView, numberOfRowsInSection: section))
                    .compactMap({ row in
                        self.tableView?(tableView, heightForRowAt:
                                .init(row: row, section: section))
                    })
            })
            .flatMap({ $0 })
            .reduce(0, +)
    }
}
