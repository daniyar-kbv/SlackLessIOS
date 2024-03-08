//
//  SurveyController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-06.
//

import Foundation
import UIKit

final class SurveyController: UIViewController {
    private let viewModel: SurveyViewModel
    private lazy var contentView = SurveyView(question: viewModel.output.getQuestion())
    
    init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}

extension SurveyController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.getQuestion().answers.count
        
        contentView.setTableView(height: CGFloat(count) * contentView.tableView.rowHeight)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SurveyTableViewCell.self), for: indexPath) as! SurveyTableViewCell
        
        let answers = viewModel.output.getQuestion().answers
        if indexPath.row < answers.count {
            cell.set(answer: answers[indexPath.row])
        }
        
        return cell
    }
}

extension SurveyController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.input.selectAnswer(at: indexPath.row)
    }
}

