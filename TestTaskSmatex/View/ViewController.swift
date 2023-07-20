//
//  ViewController.swift
//  TestTaskSmatex
//
//  Created by Максим Шишканов on 20.07.2023.
//

import UIKit

final class ViewController: UIViewController {
    private var times: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let dateFormat = "yyyy-MM-dd HH:mm:ss"
    private let cellReuseID = String(describing: UITableViewCell.self)

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.dataSource = self
        return tableView
    }()

    private lazy var addButton: UIButton = {
        let button = AddButton(delegate: self)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(addButton)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        times.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        cell.textLabel?.text = times[indexPath.row]
        return cell
    }
}

// MARK: - AddButtonDelegate
extension ViewController: AddButtonDelegate {
    func addButtonDidTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let dateString = formatter.string(from: Date())
        times.append(dateString)

        tableView.scrollToRow(at: .init(row: times.count - 1, section: .zero), at: .bottom, animated: true)
    }
}

